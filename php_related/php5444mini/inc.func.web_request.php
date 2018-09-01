<?php
//简单的 get/post 函数 用 curl包.
//NOTES:
//如果要复杂的curl用法，请看 NetCommon 类、WebAPIClient类等
//如果没有或者不想用curl库，看 inc.func.http_post.php 中的 http_post和http_get 就OK.
//Usage
//HTTP POST: web_request($url, array("xx"=>"yy")); or  web_request($url, my_json_encode($obj)):
//HTTP GET: web_request($url):
function web_request($url,$postdata,$timeout=7){
	if(is_array($postdata)){
		$postdata_s=http_build_query($postdata);
	}elseif(is_string($postdata)){
		$postdata_s=$postdata;
	}else{
		//throw new Exception("unknown param");
	}
	$url_a=parse_url($url);
	$curl = curl_init();
	curl_setopt($curl, CURLOPT_URL, $url);
	if($url_a['scheme']=="https"){
		curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, FALSE);
		curl_setopt($curl, CURLOPT_SSL_VERIFYHOST, FALSE);
	}
	if($postdata_s){
		curl_setopt($curl, CURLOPT_POST, true);
		//curl_setopt($curl, CURLOPT_POST, 1);
		curl_setopt($curl, CURLOPT_POSTFIELDS, $postdata_s);
	}
	curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
	if($timeout>0 && $timeout<1){
		curl_setopt($curl, CURLOPT_NOSIGNAL,1);//毫秒级需要..
		curl_setopt($curl, CURLOPT_TIMEOUT_MS,200);//超时毫秒，cURL 7.16.2中被加入。从PHP 5.2.3起可使用
	}elseif($timeout>=1){
		curl_setopt($curl, CURLOPT_TIMEOUT,$timeout);
	}
	$result = curl_exec($curl);
	$errno=curl_errno($curl);
	$errmsg=curl_error($curl);
	curl_close($curl);
	if($errno){
		throw new Exception($errmsg,$errno);
	}
	return $result;
}

