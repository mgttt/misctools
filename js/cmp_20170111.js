/^u/.test(typeof namespace)&&(namespace=function(s,r,c,i,k){r=r||/^u/.test(typeof window)?global:window;c=s.split('.');for(i=0;i<c.length;i++){k=c[i];r[k]||(r[k]={});r=r[k];}return r});
(function(cmp){
	cmp.o2s=function(o,l){
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
	cmp.s2o=function(s){ try{ return (new Function('return '+s))(); }catch(ex){} };
	cmp.ajax={
		x:function(){return new(self.XMLHttpRequest||ActiveXObject)("Microsoft.XMLHTTP");}
		,send:function(u,f,m,a){var x=this.x();x.open(m,u,true);x.onerror=function(ex){f({STS:"KO",errmsg:"Network Failed."+ex},-1,u);};x.onreadystatechange=function(){if(x.readyState==4){f(x.responseText,x.status,u);}};if(m=='POST')x.setRequestHeader('Content-type','application/x-www-form-urlencoded');x.send(a);}
		,get:function(url,func){this.send(url,func,'GET');}
		,gets:function(url){var x=this.x();x.open('GET',url,false);x.send(null);return x.responseText;}
		,post:function(url,func,args){this.send(url,func,'POST',args);}
	};
	//namespace('cmp').render=...;//TODO
	//namespace('cmp')
})(namespace('cmp'));

