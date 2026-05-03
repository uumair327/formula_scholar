module.exports = async function (opts) {
    const dry = opts.dryRun || false;
    console.log(`Staging discovered items. dryRun=${dry}`);
    // TODO: Implement: read discover report, apply staging transformations, insert into staging tables.
    console.log('STUB: parse discover-report.csv, create staging entries, run lightweight checks.');
};
