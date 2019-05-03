var pool_a = {}; //outside scope to let pool works
module.exports = (opts) => {
	var { db_host, db_user, db_pass, db_port, db_name, Q, debug_level = 0 } = opts || {};
	var logger = console; //TMP
	if (!Q) Q = require('q');

	function qstr(s) { if (s == null) return "''"; return "'" + ("" + s).replace(/'/g, "''") + "'"; }

	function qstr_arr(a) { var rt_a = []; for (var k in a) { rt_a.push(qstr(a[k])); } return rt_a.join(',') }
	const mysql = require('mysql2');
	var pool_key = db_user + '@' + db_host + ':' + db_port;
	var pool = pool_a[pool_key];
	if (!pool) {
		pool_a[pool_key] = pool = mysql.createPool({
			host: db_host,
			user: db_user,
			password: db_pass,
			database: db_name,
			port: db_port,
			// waitForConnections: true,
			// connectionLimit: 10,
			// queueLimit: 0
			//TODO//acquireTimeout,timezone
		});
	}
	var exec_q = (sql, binding) => {
		if (typeof(sql) == 'object') {
			var { sql, binding } = sql;
		}
		var dfr = Q.defer();
		pool.getConnection((err, conn) => {
			//logger.log('pool.getConnection');
			if (err) return dfr.reject(err);
			conn.query(sql, binding, function(err, rst, fields) {
				//conn.destroy();
				pool.releaseConnection(conn);
				//TODO debug how many free left at the pool..
				if (err) { dfr.reject(err) }
				else { dfr.resolve({ STS: 'OK', /*fields,*/ rows: rst.rsa || rst, lastID: rst.insertId, af: rst.affectedRows }) }
			});
		});
		// pool.query(sql, binding, (err, rst, fields) => {
		// 	if (err) dfr.reject(err);
		// 	else dfr.resolve({ STS: 'OK', rows: rst.rsa || rst, lastID: rst.insertId, af: rst.affectedRows })
		// })
		return dfr.promise;
	}
	var upsert_q = (params) => {
		var { table, toUpdate, toFind, insert_first } = params;
		var s_kv = "",
			a_kv = [],
			s_w = "",
			a_w = [],
			s_v = "",
			a_v = [],
			s_k = "",
			a_k = [];
		for (var k in toFind) {
			var v = toFind[k];
			a_w.push("" + k + "=" + qstr(v));
		}
		var where = "WHERE " + a_w.join(" AND ");
		for (var k in toUpdate) {
			var v = toUpdate[k];
			a_v.push(qstr(v) + " AS " + k);
			//a_k.push(qstr(k));//mysql 不支付字段名用 ' ??
			a_k.push(k);
			a_kv.push("" + k + "=" + qstr(v));
		}
		s_k = a_k.join(",");
		s_v = a_v.join(",");
		s_kv = a_kv.join(",");

		var tmp_table = 'TMP_' + (new Date()).getTime();

		//其实还可以合成到一句的，不过未研究性能所以先不用.

		var sql_1 = `INSERT INTO ${table} (${s_k})
SELECT * FROM (SELECT ${s_v}) AS ${tmp_table}
WHERE NOT EXISTS (SELECT 'Y' FROM ${table} ${where} LIMIT 1)`;

		var sql_2 = `UPDATE ${table} SET ${s_kv} ${where}`;

		var lastID = -1;
		var af = -1;

		if (insert_first) { //try insert first
			return exec_q(sql_1)
				.then(rst => {
					lastID = rst.lastID;
					return exec_q(sql_2)
						.then(rst => {
							af = rst.af;
							return Q({ STS: af > 0 ? 'OK' : 'KO', lastID, af })
						})
				})
				.fail(err => {
					if (debug_level > 0)
						logger.log('DEBUG findAndUpsert_q.err=', err, sql_1, sql_2);
					return Q.reject(err)
				})
		}
		else { //try update first (default)
			return exec_q(sql_2)
				.then(rst => {
					af = rst.af;
					if (af > 0) {
						return Q({ STS: "OK", lastID, af })
					}
					else {
						return exec_q(sql_1)
							.then(rst => {
								lastID = rst.lastID;
								return Q({ STS: lastID > 0 ? 'OK' : 'KO', lastID, af })
							})
					}
				})
				.fail(err => {
					if (debug_level > 0)
						logger.log('DEBUG findAndUpsert_q.err=', err, sql_1, sql_2);
					return Q.reject(err)
				})
		}
	};

	return {
		qstr,
		exec_q,
		select_q: exec_q //alias
	}
};

