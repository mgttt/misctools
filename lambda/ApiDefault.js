var Application, Server, logger, Q;
var db_host = 'XXX',
    db_port = 3306,
    db_user = 'XXX',
    db_pass = 'XXX',
    db_name = 'XXX';
var db = require('./mysql2wrapper')({ db_host, db_user, db_pass, db_port, db_name, Q });

module.exports = class {
    constructor(_Application, _Server) {
        Application = _Application;
        Server = _Server || {};
        logger = _Application.logger;
        Q = Application.Q;
    }
    DebugRaw() {
        return {
            m: 'DebugRaw',
            server_time_stamp: (new Date()).getTime(),
            //method: httpMethod,
            raw: JSON.stringify(Server.req.event), //Server.req.event
            post_o: Server.req.post_o,
            get_o: Server.req.get_o,
            request_o: Server.req.request_o
        }
    }
    QuickTest(param) {

        var { o2o, o2s, getTimeStr } = Application;
        var { post_o, get_o, request_o } = Server.req || {};

        //var sql = 'SELECT * FROM t_test LIMIT 5';
        //var sql='SHOW TABLES';
        var sql = 'SHOW FULL PROCESSLIST';

        //var sql = 'INSERT INTO t_yunxin_sync (value) VALUES (' + db.qstr(o2s({ txt: '中文测试' })) + ')';
        return db.exec_q(sql).then(rst => {
            var server_time_stamp = (new Date()).getTime();
            o2o(rst, {
                server_time_stamp,
                server_time: getTimeStr(),
                post_o,
                get_o,
                // request_o,
                //filename: __filename,///var/task/ApiDefault.js //TODO list folder later.
                param
            });
            return rst;
        });
    }

    GetVersion() {
        var { o2o, getTimeStr, fs } = Application;
        return { filename: __filename, filetime: getTimeStr(fs.statSync(__filename).mtime) }
    }
    //.__filename
    static get __filename() {
        return __filename;
    }
};

