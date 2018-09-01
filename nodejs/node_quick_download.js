function argv2o(argv,m,k,rt){rt={};for(k in argv)(m=(rt[""+k]=argv[k]).match(/^(\/|--?)([a-zA-Z0-9-_]*)="?(.*)"?$/))&&(rt[m[2]]=m[3]);return rt}
var argo=argv2o(process.argv);
var url=argo.url;
var filename=argo.filename;
if(filename && url){
	var file = require('fs').createWriteStream(filename);
	require(url.match(/^(https?):\/\/([^\/]*)/)[1]).get(url, res=>{
		res.on('data', d=>{
			process.stdout.write('.');
		});
		res.pipe(file);
		file.on('finish', ()=>{
			file.close(()=>{ console.log('d/l done'); })
		});
	});
}else{
	console.log('Usage: node $me -url=... -filename=...');
}
