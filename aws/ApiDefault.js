var Application, Server, logger;

var ManualTag = '2019-quick-demo-only';

module.exports = class {
    constructor(_Application, _Server) {
        Application = _Application;
        Server = _Server || {};
        logger = _Application.logger;
    }
    DebugRaw() {
        return {
            m: 'DebugRaw',
            server_time_stamp: (new Date()).getTime(),
            //method: httpMethod,
            raw: (Server.req.event), //Server.req.event
            post_o: Server.req.post_o,
            get_o: Server.req.get_o,
            request_o: Server.req.request_o
        }
    }

    GetVersion() {
        var { o2o, getTimeStr, fs } = Application;
        return { filename: __filename, filetime: getTimeStr(fs.statSync(__filename).mtime), ManualTag }
    }
    //.__filename
    static get __filename() {
        return __filename;
    }
};
