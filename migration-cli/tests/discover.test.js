const fs = require('fs');
const path = require('path');
const os = require('os');
const discover = require('../lib/commands/discover');

describe('discover command (scaffold)', () => {
    test('writes a CSV report to provided output path', async () => {
        const out = path.join(os.tmpdir(), `discover-test-${Date.now()}.csv`);
        // run discover
        await discover({ out });
        // assert file exists and has header
        expect(fs.existsSync(out)).toBe(true);
        const content = fs.readFileSync(out, { encoding: 'utf8' });
        expect(content).toContain('normalized_text');
        expect(content).toContain('count');
        // cleanup
        try { fs.unlinkSync(out); } catch (e) { /* ignore */ }
    });
});
