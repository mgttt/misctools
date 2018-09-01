/^u/.test(typeof namespace)&&(namespace=function(s,r,c,i,k){r=r||/^u/.test(typeof window)?global:window;c=s.split('.');for(i=0;i<c.length;i++){k=c[i];r[k]||(r[k]={});r=r[k];}return r});
(function(tgt,src){for(f in src){tgt[f]=src[f]}})(namespace('cmp'),{
	o2s:function(o,l){//20170121
		if(null==o)return "null";
		var f=arguments.callee;
		if (!l>0) l=10;
		if (l<=0) return;
		var t=typeof o;
		if('object'==t){ if(RegExp==o.constructor)t='regexp'; }
		switch(t){
			case 'undefined':case 'unknown':return;
			case 'boolean':case 'regexp':return o.toString(); break;
			case 'number':return isFinite(o)?o.toString():'null';break;
			case 'object':
			case 'array':
				var r=[];
				if(o.constructor==Array && o.length>=0){
					for(var i=0;i<o.length;i++){var v=f(o[i],l-1);if(v!==undefined)r.push(v);};return '['+r.join(',')+']';
				}
				try{for(var p in o){v=f(o[p],l-1);if(v!==undefined)r.push('"'+p+'":'+v);}}catch(ex){return ""+ex;};
				if(r.length==0 && (""+o)!=""){
					//if really empty, let 'default' handle..
				}else{
					return '{'+r.join(',')+'}';
				}
			default:
				//var s= o.toString?o.toString():(""+o);
				var s= ""+o;
				return '"'+s.replace(/(\\|\")/g,"\\$1").replace(/\n/g,"\\n").replace(/\r/g,"\\r")+'"';
		}
	}
	,s2o:function(s){try{return(new Function('return '+s))()}catch(ex){}}
	,ajax:{
		x:function(){return new(self.XMLHttpRequest||ActiveXObject)("Microsoft.XMLHTTP");}
		,send:function(u,f,m,a){var x=this.x();x.open(m,u,true);x.onerror=function(ex){f({STS:"KO",errmsg:"Network Failed."+ex},-1,u);};x.onreadystatechange=function(){if(x.readyState==4){f(x.responseText,x.status,u);}};if(m=='POST')x.setRequestHeader('Content-type','application/x-www-form-urlencoded');x.send(a);}
		,get:function(url,func){this.send(url,func,'GET');}
		,gets:function(url){var x=this.x();x.open('GET',url,false);x.send(null);return x.responseText;}
		,post:function(url,func,args){this.send(url,func,'POST',args);}
	}
	/*
	,CheckAndCallBack:function(func_check,timeout,max_timeout,callback,sum_timeout){
		if(!sum_timeout) sum_timeout=0;
		if(sum_timeout>max_timeout){
			callback("timeout");
		}else{
			if(func_check()){
				callback("ok");
			}else{
				setTimeout(function(){
					CheckAndCallBack(func_check,timeout,max_timeout,callback,sum_timeout+timeout);
				},timeout);
			}
		}
	}*/
	,sha1:function(d){var l=0,a=0,f=[],b,c,g,h,p,e,m=[b=1732584193,c=4023233417,~b,~c,3285377520],n=[],k=unescape(encodeURI(d));for(b=k.length;a<=b;)n[a>>2]|=(k.charCodeAt(a)||128)<<8*(3-a++%4);for(n[d=b+8>>2|15]=b<<3;l<=d;l+=16){b=m;for(a=0;80>a;b=[[(e=((k=b[0])<<5|k>>>27)+b[4]+(f[a]=16>a?~~n[l+a]:e<<1|e>>>31)+1518500249)+((c=b[1])&(g=b[2])|~c&(h=b[3])),p=e+(c^g^h)+341275144,e+(c&g|c&h|g&h)+882459459,p+1535694389][0|a++/20]|0,k,c<<30|c>>>2,g,h])e=f[a-3]^f[a-8]^f[a-14]^f[a-16];for(a=5;a;)m[--a]=m[a]+b[a]|0}for(d="";40>a;)d+=(m[a>>3]>>4*(7-a++%8)&15).toString(16);return d}
	,_micro_templates_:{}
	,_micro_templates_s_:{}
	,render:function(json_obj,tpl_s,name_tpl){
		if(tpl_s==null) return null;
		if(!name_tpl)name_tpl=this.sha1(tpl_s);
		var _micro_templates_s_=this._micro_templates_s_;
		var _micro_templates_=this._micro_templates_;
		var _func_tmp=function(){
			return arguments[0].replace(/'|\\/g, "\\$&").replace(/\n/g, "\\n");
		};
		if(_micro_templates_[name_tpl]){
			var _nf=_micro_templates_[name_tpl];
			if(typeof(_nf)=="function"){
				return _nf(json_obj);
			}else{
				throw new Error(""+name_tpl+" tpl not found");
			}
		}else{
			var tpl=tpl_s;
			tpl=tpl
			.replace(/&lt;%/g, "<%")
			.replace(/%&gt;/g, "%>")
			.replace(/\r|\*+="/g, ' ')
			.split('<%').join("\r")
			.replace(/(?:^|%>)[^\r]*/g, _func_tmp)
			.replace(/\r=(.*?)%>/g, "',$1,'")
			.split("\r").join("');");

			tpl=tpl.split('%>').join("\n"+"_write.push('");

			tpl=tpl
			.replace(/&gt;/g, ">")
			.replace(/&lt;/g, "<")
			.replace(/&amp;/g, "&");

			_micro_templates_s_[name_tpl]=tpl;
			var _s="";
			try{
				_s="try";
				_s+="{var _write=[];with(_data_"+name_tpl+"){"+"\n"+"_write.push('"+ tpl +"');};return _write.join('');}";
				_s+="catch(ex){console.log('err in tpl("+name_tpl+")',''+ex);console.log(_tpl_"+name_tpl+");throw ex}";
				var nf= new Function('_data_'+name_tpl,'_tpl_'+name_tpl,_s);
				_micro_templates_[name_tpl] = nf;//cached
				return nf(json_obj,tpl);
			}catch(ex){
				try{console.log("tpl error",tpl);}catch(e){alert(e);}
				throw ex;
			}
		}
		if(this.debug>0){
			_micro_templates_[name_tpl]=null;//no cache for debug mode
		}
	}
});

