function argv2o(argv,m,mm){var rt={};for(k in argv)(m=(rt[""+k]=argv[k]).match(/^(\/|--?)([a-zA-Z0-9-_]*)="?(.*)"?$/))&&(rt[m[2]]=m[3]);return rt}
var argo=argv2o(process.argv);
var url=argo.url;
var filename=argo.filename;
if(filename && url){
	var m=url.match(/^(https?):\/\/([^\/]*)/);
	var os=require('os');
	var fs=require('fs');
	var tmpdir=os.tmpdir();
	var web=require(m[1]);
	var file = fs.createWriteStream(filename);
	web.get(url, function( res ){
		res.pipe(file);
		file.on('finish', function() {
			file.close(function(){
				console.log('finish');
			});
		});
	});
}else{
	console.log('Usage: node $me -url=... -filename=...');
}
