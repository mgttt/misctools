var exports_handler = (event, context, callback) => {
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
		};
	var { queryStringParameters, httpMethod, body, path } = event || {};
	var headers = { 'Access-Control-Allow-Origin': '*' };
	var post_o = s2o(body);
	var get_o = queryStringParameters || {};
	var request_o = o2o(get_o, post_o);
	var { c, m } = request_o || {};
	var approot = '.';
	var flag_production = true;
	var fs = require('fs');
	var Q = require('q');
	var logger = console; //TMP, to use lambda logger later
	if (!path) m = 'QuickTest'; //QUICK TEST FOR LOCAL IDE
	//httpMethod = 'GET', path = '/'; //QUICK TEST CASE 2 FOR / => index.html
	if (!c) c = 'Default'; //route to ApiDefault
	if (c.substr(0, 3) != "Api") c = "Api" + c; //we want Prefix 'Api' for c
	var p = request_o.p;
	var req = { request_o, post_o, get_o, event },
		res = { headers, callback };
	var cc;
	var session = req.session; //TODO 
	const getTimeStr = (dt, fmt, tz) => (dt = dt || new Date(), (new Date(dt.getTime() + ((tz === null) ? 0 : ((tz || tz === 0) ? tz : (-dt.getTimezoneOffset() / 60))) * 3600 * 1000)).toISOString().replace('T', ' ').substr(0, 19));

	var Application = { //TODO move to Application.js later.
		getTimeStr,
		fs,
		o2o,
		o2s,
		s2o,
		logger,
		Q,
		approot,
		flag_production,
		sendFile: (opts = {}) => {
			var dfr = Q.defer();
			var { res, fileName, ContentType } = opts; //TODO ContentType is not yet done.
			var filePath = fileName;
			headers["content-type"] = //@ref https://github.com/jshttp/mime-db/blob/master/db.json
				{ html: 'text/html' }[filePath.split('.').pop()];
			fs.readFile(approot + '/' + filePath, (err, data) => {
				if (err) dfr.reject(err);
				else dfr.resolve(data.toString());
			});
			return dfr.promise;
		}
	};
	Q().then(() => {
			var _logicModule = tryRequire(approot + '/' + c, !flag_production);
			if (_logicModule) cc = new _logicModule(Application, /*Server=*/ { req, res, session, c, m });
			if (cc && cc[m]) return cc[m](p);
			else if (httpMethod == 'GET') return Application.sendFile({ res, fileName: ("/" == path) ? '/index.html' : path });
			else return Q(`404 ${path} ${c}.${m} ${httpMethod}`);
		})
		.fail(err => 'ERR=' + err) //wrap err to 200
		.done(rst => callback(null, { statusCode: 200, headers, body: typeof(rst) == 'string' ? rst : o2s(rst) }));
};

//NOTES: lambda directly using callback might have strange bug, so we make a little h*ck wrapping...like shit:
exports.handler = async(event, context) => new Promise((resolve, reject) => exports_handler(event, context, (err, rst) => err ? reject(err) : resolve(rst)));

