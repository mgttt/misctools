
//o2s/s2o//20161109
function o2s(o,l){
	if(null==o)return "null";
	var f=arguments.callee;
	var t=typeof o;
	if (!l>0) l=10;
	if (l<=0) return;
	if('object'==t){ if(RegExp==o.constructor)t='regexp'; }
	switch(t){
		case 'undefined':case 'unknown':return;
		case 'object':
		case 'array':
			var r=[];
			if(o.constructor==Array && o.length>=0){
				for(var i=0;i<o.length;i++){var v=f(o[i],l-1);if(v!==undefined)r.push(v);};return '['+r.join(',')+']';
			}
			try{for(var p in o){v=f(o[p],l-1);if(v!==undefined)r.push('"'+p+'":'+v);}}catch(ex){return ""+ex;};
			return '{'+r.join(',')+'}';
			break;
		case 'boolean':case 'regexp':return o.toString(); break;
		case 'number':return isFinite(o)?o.toString():'null';break;
		default:
			var s= o.toString?o.toString():(""+o);
			return '"'+s.replace(/(\\|\")/g,"\\$1").replace(/\n/g,"\\n").replace(/\r/g,"\\r")+'"';break;
	}
};
function s2o(s){ try{ return (new Function('return '+s))(); }catch(ex){} };

var test_case=[
	null,
	undefined,
	["x","y"],
	{x:11,y:12},
	{x:11,y:12,z:undefined},
	{x:11,y:[12,13]},
	console.log,
	"wtf omg",
	true,
	false,
	[true,false,null,0,-1,1],
	{x:true,y:false,z:null,r:0,s:-1,t:1},
	/^koko$/,
	[/^k2k2$/,1,2],
	["kk",{x:01,y:9999999999999992387091758912470982792735927572975927957895999999.9,z:-3.3333333}],
];

// NOTES: regexp might failed in java....?

for(var i in test_case){
	var o1=test_case[i];
	var s1=o2s(o1);
	var o2=s2o(s1);
	var s2=o2s(o2);

	var flg= (s1==s2);
	console.log( flg?'PASS':'FAIL',"\t",i);
	console.log( "\t",s1,"\t",s2,"\t",o1,"\t",o2);
}

