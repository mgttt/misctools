<?php
//usage:
//GET
// echo http_req(array('url'=>'http://baidu.com/'));
function http_req($param){
	if(!$param) throw new Exception("http_req EMPTY PARAM");
	$url=$param['url'];
	if(!$url) throw new Exception("http_req EMPTY url");

	$ctx=array();
	$method=$param['method'];
	if(!$method) $method='POST';//default
	$ctx['method']=$method;
	
	if($method=='POST'){
		$postdata=$param['data'];
		if(is_array($postdata)){
			$postdata_s=http_build_query($postdata);
		}else/*if(is_string($postdata))*/{
			$postdata_s=$postdata;
		}
		$data_len = strlen($postdata_s);
		$ctx['content']=$postdata_s;
		$header="Connection: close\r\nContent-Length: $data_len\r\n";
	}else{
		//先当作GET
		$header="Connection: close\r\n";
	}
	$user_agent=$param['user_agent'];
	if($user_agent){
		if($user_agent=='DEFAULT')
			$user_agent="User-agent: Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36";
		$header="User-agent: $user_agent\r\n".$header;
	}
	//$header="User-agent: Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36\r\n".$header;
	$ctx['header']=$header;

	$proxy=$param['proxy'];
	if($proxy){
		$ctx['proxy']=$proxy;
	}
	
	$scheme=$param['scheme'];
	if(!$scheme) $scheme='http';//default

	$timeout=$param['timeout'];
	if($timeout>0){
		$ctx['timeout']=$timeout;
	}
	
	/*array(
		'method'=>'POST',
		'timeout'=>$timeout,
		//"header"  => "User-agent: Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.101 Safari/537.36", 
		//"proxy"   => "tcp://my-proxy.localnet:3128", 
		//'request_fulluri' => True //some proxy need full uri
		'header'=>"Connection: close\r\nContent-Length: $data_len\r\n",
		'content'=>$postdata_s,
	)*/
	$context=stream_context_create(array($scheme=>$ctx));
	$rt=file_get_contents($url, false, $context);
	return $rt;
}
//make default json encode the $p['data']
function http_req2($p){
	$data=$p['data'];
	if(is_string($data) || !$data){
		//skip
	}else{
		$p['data']=my_json_encode($data);
	}
	return http_req($p);
}
function http_req_quick($url, $postdata, $timeout=7){
	$p=array(
		'url'=>$url,
		'data'=>$postdata,
	);
	if($timeout>0){
		$p['timeout']=$timeout;
	}
	return http_req($p);
}

//这个第二参数默认自动做json并POST处理.
function http_req_quick2($url, $postdata, $timeout=7){
	if(is_string($postdata) || !$postdata){
		//SKIP
	}else{
		$postdata=my_json_encode($postdata);
	}
	//return http_req_quick($p);
	$p=array(
		'url'=>$url,
		'data'=>$postdata,
	);
	if($timeout>0){
		$p['timeout']=$timeout;
	}
	return http_req($p);
}


