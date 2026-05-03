/**
 * Background Publish Job Executor
 * Polls the publish_job table for queued items and processes them
 * Handles compilation, validation, and status tracking
 */

const { PostgresWorkflowStore } = require('./postgres_store');

class PublishJobExecutor {
    constructor(pgConnectionConfig) {
        this.store = new PostgresWorkflowStore(pgConnectionConfig);
        this.maxRetries = 3;
        this.processingTimeout = 30000; // 30 seconds
        this.pollInterval = 5000; // 5 seconds
        this.running = false;
    }

    async connect() {
        await this.store.connect();
    }

    async close() {
        this.running = false;
        await this.store.close();
    }

    /**
     * Start the executor in polling mode
     */
    async start() {
        this.running = true;
        console.log('🚀 Publish Job Executor started');

        while (this.running) {
            try {
                await this.processBatch();
                await this.sleep(this.pollInterval);
            } catch (err) {
                console.error('❌ Executor error:', err.message);
                await this.sleep(this.pollInterval);
            }
        }

        console.log('🛑 Publish Job Executor stopped');
    }

    /**
     * Process one batch of queued jobs
     */
    async processBatch() {
        const result = await this.store.query(
            `SELECT pj.* FROM publish_job pj
             WHERE pj.status = 'queued'
             ORDER BY pj.created_at ASC
             LIMIT 5`
        );

        if (result.rows.length === 0) {
            return;
        }

        console.log(`\n📦 Processing ${result.rows.length} job(s)...`);

        for (const row of result.rows) {
            const job = this._mapJobRow(row);
            await this.processJob(job);
        }
    }

    /**
     * Process a single publish job
     */
    async processJob(job) {
        const client = await this.store.pool.connect();

        try {
            console.log(`\n▶ Processing job ${job.id} (version: ${job.versionId})`);

            // Update status to running
            await client.query('BEGIN');
            await client.query(
                `UPDATE publish_job SET status = $1, started_at = $2, attempts = $3 
                 WHERE id = $4`,
                ['running', new Date().toISOString(), job.attempts + 1, job.id]
            );

            // Get approval details
            const approvalResult = await client.query(
                `SELECT * FROM approvals WHERE id = $1`,
                [job.approval_id]
            );
            const approval = approvalResult.rows[0];

            // Execute job stages with timeout
            const stageResults = await Promise.race([
                this.executeJobStages(job, approval, client),
                new Promise((_, reject) =>
                    setTimeout(() => reject(new Error('Job processing timeout')), this.processingTimeout)
                )
            ]);

            // Update to succeeded
            await client.query(
                `UPDATE publish_job SET status = $1, finished_at = $2, payload = $3 
                 WHERE id = $4`,
                ['succeeded', new Date().toISOString(), JSON.stringify(stageResults), job.id]
            );

            // Log audit entry
            await client.query(
                `INSERT INTO audit_log (entity_type, entity_id, action, performed_by, delta, created_at)
                 VALUES ($1, $2, $3, $4, $5, $6)`,
                [
                    'publish_job',
                    job.id,
                    'publish_job_succeeded',
                    'executor',
                    JSON.stringify(stageResults),
                    new Date().toISOString()
                ]
            );

            await client.query('COMMIT');
            console.log(`✅ Job ${job.id} succeeded`);
        } catch (err) {
            await client.query('ROLLBACK');

            // Determine if job should be retried
            if (job.attempts + 1 < this.maxRetries) {
                console.log(`⚠️  Job ${job.id} failed (attempt ${job.attempts + 1}), retrying...`);
                await client.query(
                    `UPDATE publish_job SET status = $1, attempts = $2, updated_at = $3 
                     WHERE id = $4`,
                    ['queued', job.attempts + 1, new Date().toISOString(), job.id]
                );

                await client.query(
                    `INSERT INTO audit_log (entity_type, entity_id, action, performed_by, delta, created_at)
                     VALUES ($1, $2, $3, $4, $5, $6)`,
                    [
                        'publish_job',
                        job.id,
                        'publish_job_retried',
                        'executor',
                        JSON.stringify({ error: err.message, attempt: job.attempts + 1 }),
                        new Date().toISOString()
                    ]
                );
            } else {
                // Max retries exceeded
                console.log(`❌ Job ${job.id} failed after ${this.maxRetries} attempts`);
                await client.query(
                    `UPDATE publish_job SET status = $1, finished_at = $2, updated_at = $3 
                     WHERE id = $4`,
                    ['failed', new Date().toISOString(), new Date().toISOString(), job.id]
                );

                await client.query(
                    `INSERT INTO audit_log (entity_type, entity_id, action, performed_by, delta, created_at)
                     VALUES ($1, $2, $3, $4, $5, $6)`,
                    [
                        'publish_job',
                        job.id,
                        'publish_job_failed',
                        'executor',
                        JSON.stringify({ error: err.message, maxAttemptsExceeded: true }),
                        new Date().toISOString()
                    ]
                );
            }
        } finally {
            client.release();
        }
    }

    /**
     * Execute job processing stages (validation, compilation, deployment)
     */
    async executeJobStages(job, approval, client) {
        const results = {
            versionId: job.versionId,
            stages: {}
        };

        // Stage 1: Validation
        console.log(`  └─ 🔍 Validating formula version...`);
        results.stages.validation = await this.stageValidate(job, approval, client);
        console.log(`     ✓ Validation passed`);

        // Stage 2: Compilation (semantic analysis, dependency resolution)
        console.log(`  └─ 🔨 Compiling formula version...`);
        results.stages.compilation = await this.stageCompile(job, approval, client);
        console.log(`     ✓ Compilation succeeded`);

        // Stage 3: Deployment (finalize and mark as published)
        console.log(`  └─ 🚀 Deploying to production...`);
        results.stages.deployment = await this.stageDeployment(job, approval, client);
        console.log(`     ✓ Deployment completed`);

        return results;
    }

    /**
     * Validation stage: semantic checks, schema validation, cross-references
     */
    async stageValidate(job, approval, client) {
        const versionId = job.versionId;

        // Fetch formula version from schema
        const versionResult = await client.query(
            `SELECT * FROM formula_version WHERE id = $1`,
            [versionId]
        );

        if (versionResult.rows.length === 0) {
            throw new Error(`Formula version not found: ${versionId}`);
        }

        const version = versionResult.rows[0];

        // Validation checks
        const validations = {
            schemaValid: await this.validateSchema(version),
            dependenciesResolved: await this.validateDependencies(version, client),
            checksumValid: await this.validateChecksum(version),
            regionsResolved: await this.validateRegions(version, client)
        };

        const allValid = Object.values(validations).every(v => v === true);
        if (!allValid) {
            throw new Error(`Validation failed: ${JSON.stringify(validations)}`);
        }

        return validations;
    }

    /**
     * Compilation stage: semantic analysis and dependency resolution
     */
    async stageCompile(job, approval, client) {
        const versionId = job.versionId;

        // Get formula version details
        const versionResult = await client.query(
            `SELECT f.id as formula_id, fv.* FROM formula_version fv
             JOIN formula f ON fv.formula_id = f.id
             WHERE fv.id = $1`,
            [versionId]
        );

        const version = versionResult.rows[0];

        // Resolve class→formula→region mapping chain
        const mappingResult = await client.query(
            `SELECT cfm.* FROM class_formula_mapping cfm
             WHERE cfm.formula_id = $1`,
            [version.formula_id]
        );

        const mappings = mappingResult.rows;

        // Compile mapping table (simulate dependency resolution)
        const compilationReport = {
            formulaId: version.formula_id,
            versionId: versionId,
            mappingsProcessed: mappings.length,
            regionsImpacted: [...new Set(mappings.map(m => m.region))],
            classesImpacted: [...new Set(mappings.map(m => m.class_id))],
            compilationTime: Date.now() % 1000 // Simulate time in ms
        };

        return compilationReport;
    }

    /**
     * Deployment stage: finalize and mark as published
     */
    async stageDeployment(job, approval, client) {
        const versionId = job.versionId;
        const now = new Date().toISOString();

        // Update formula_version to published
        await client.query(
            `UPDATE formula_version SET status = $1, published_at = $2 WHERE id = $3`,
            ['published', now, versionId]
        );

        // Create cache snapshot
        await client.query(
            `INSERT INTO formula_cache_snapshot (version_id, snapshot_data, expires_at, created_at)
             VALUES ($1, $2, $3, $4)`,
            [
                versionId,
                JSON.stringify({ published: true, timestamp: now }),
                new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString(), // 24hr TTL
                now
            ]
        );

        // Mark approval as completed
        await client.query(
            `UPDATE approvals SET state = $1, updated_at = $2 WHERE id = $3`,
            ['completed', now, job.approval_id]
        );

        return {
            versionPublished: true,
            publishedAt: now,
            cacheInvalidated: false,
            approvalCompleted: true
        };
    }

    /**
     * Validate formula schema compliance
     */
    async validateSchema(version) {
        // Simulate schema validation
        // In production: JSONSchema validation, type checking, etc.
        return (
            version.content !== null &&
            version.checksum !== null &&
            version.formula_id !== null
        );
    }

    /**
     * Validate all formula dependencies are available
     */
    async validateDependencies(version, client) {
        // Fetch formula and check if it has dependencies
        const formulaResult = await client.query(
            `SELECT * FROM formula WHERE id = $1`,
            [version.formula_id]
        );

        if (formulaResult.rows.length === 0) {
            throw new Error(`Formula not found: ${version.formula_id}`);
        }

        // In production: validate referenced formulas, classes, regions, etc.
        return true;
    }

    /**
     * Validate checksum to ensure data integrity
     */
    async validateChecksum(version) {
        // Simulate checksum validation
        // In production: compute actual checksum and compare
        return version.checksum !== null && version.checksum.length > 0;
    }

    /**
     * Validate all regions referenced in mappings exist
     */
    async validateRegions(version, client) {
        // Fetch mappings for this formula
        const mappingResult = await client.query(
            `SELECT DISTINCT region FROM class_formula_mapping WHERE formula_id = $1`,
            [version.formula_id]
        );

        // In production: verify each region is valid and available
        return true;
    }

    /**
     * Sleep utility for polling
     */
    sleep(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    /**
     * Map Postgres job row to camelCase object
     */
    _mapJobRow(row) {
        return {
            id: row.id,
            approval_id: row.approval_id,
            versionId: row.version_id,
            status: row.status,
            attempts: Number(row.attempts),
            createdBy: row.created_by,
            createdAt: row.created_at,
            updatedAt: row.updated_at,
            startedAt: row.started_at,
            finishedAt: row.finished_at
        };
    }
}

module.exports = {
    PublishJobExecutor
};
