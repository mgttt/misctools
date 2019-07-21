module.exports = (opts) => {
    var o2s = (o) => { try { return JSON.stringify(o) } catch (ex) {} },
        s2o = (s) => { try { return JSON.parse(s) } catch (ex) {} },
        o2o = (o1, o2, o3) => {
            if (o3) { for (var k in o3) { o1[o3[k]] = o2[o3[k]] } }
            else { for (var k in o2) { o1[k] = o2[k] } }
            return o1;
        },
        tryRequire = (mmm, fff) => {
            try { if (fff) { delete require.cache[require.resolve(mmm)] } return require(mmm); }
            catch (ex) { return null; }
        },
        getTimeStr = (dt, fmt, tz) => (dt = dt || new Date(), (new Date(dt.getTime() + ((tz === null) ? 0 : ((tz || tz === 0) ? tz : (-dt.getTimezoneOffset() / 60))) * 3600 * 1000)).toISOString().replace('T', ' ').substr(0, 19)),
        logger = console, //TMP, to use lambda logger later
        approot = '.',
        flag_production = true,
        fs = require('fs');
    return {
        o2s,
        s2o,
        o2o,
        tryRequire,
        getTimeStr,
        fs,
        logger,
        approot,
        flag_production,
    };
};
