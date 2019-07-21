exports.handler = async(event, context) => {
	var rst;
	try {
		var headers = { 'Access-Control-Allow-Origin': '*' }; //
		const Application = require('./Application')();
		var { s2o, o2s, o2o, tryRequire, flag_production, approot } = Application;
		var { queryStringParameters, httpMethod, body, path, requestContext } = event || {};
		var body_raw = body;
		var post_o = s2o(body) || {};
		var get_o = queryStringParameters || {};
		var request_o = o2o(get_o, post_o);
		var { c, m } = request_o || {};
		var mm;
		if (path) {
			var u;
			var mmm = path.match(/.*\/([a-zA-Z0-9_]*)\.([a-zA-Z0-9_]+)(\.api)?$/); // [C.M,.M,C.M.api,.M.api]
			if (mmm) {
				[u, c, m] = mmm;
			}
			else {
				var mmm = path.match(/.*\/([a-zA-Z0-9_]+)(\.api)?$/); // [M,M.api]
				if (mmm) {
					[u, m] = mmm;
				}
			}
			mm = m;
		}
		else {
			if (requestContext) {
				mm = 'HandleWebSocket'; //
			}
			else {
				mm = 'EditQuickTest'; //
			}
		}
		if (!c) c = 'Default'; //route to ApiDefault
		if (c.substr(0, 3) != "Api") c = "Api" + c; //we want Prefix 'Api' for c
		//var p = request_o.p;
		var req = {
				request_o,
				post_o,
				get_o,
				event,
				body_raw,
				region: process.env.AWS_REGION //@ref http://docs.aws.amazon.com/lambda/latest/dg/current-supported-versions.html#lambda-environment-variables
			},
			res = { headers };
		var cc;
		var _logicModule = tryRequire(approot + '/' + c, !flag_production);
		if (_logicModule) cc = new _logicModule(Application, /*Server=*/ { req, res, c, m });
		if (cc && cc[mm]) rst = await cc[mm](request_o.p);
		// else if (httpMethod == 'GET') return Application.sendFile({ fileName: ("/" == path) ? '/index.html' : path, headers });
		else rst = (`404 ${path} ${c}.${mm} ${httpMethod}`);
	}
	catch (err) { rst = '500 ' + err; }
	return { statusCode: 200, body: JSON.stringify(rst), headers }
};
