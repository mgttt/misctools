<?php
// static.php 是针对 $c.$m.static 的伪静态优化方案.
// 注意：$c.$m() 要注意不要依赖 $_s，否则会导致串sess !!

error_reporting(E_ERROR|E_COMPILE_ERROR|E_PARSE|E_CORE_ERROR|E_USER_ERROR);
//NOTES:  _c._m.static is a super cache to _c._m.api for special use.  going to kill for the .shtml....

//确立 _TMP_ 作为缓存区.
$SAE=defined('SAE_TMP_PATH') && !$argv[0];//dirty code
if(!defined("_STATIC_DIR_")){
	if($SAE){
		define("_STATIC_DIR_", "saemc://");//提醒：新建 SAE应用要打开 memcache 服务...
	}else{
		require "config.switch.override.tmp";
		if(defined("_TMP_")){
			define("_STATIC_DIR_", _TMP_);
		}else{
			define("_STATIC_DIR_", __DIR__."/_tmp/");
		}
	}
}

$current_time=time();//NOTES: no need to care the timezone here

$REQUEST_URI=$_SERVER['REQUEST_URI'];
//要忽略 URL(GET)中的 _s 参数，否则太多缓存了...
$REQUEST_URI=preg_replace("([^a-zA-Z0-9]_s=[a-zA-Z0-9]*)","",$REQUEST_URI);

$cache_time=$_GET['cache_time'];
if(is_numeric($cache_time) && $cache_time>0 && $cache_time< 99999){
	//OK, use it.
}else{
	$cache_time=120;//Default
}

read_cache_and_judge:{
	$REQUEST_METHOD=$_SERVER['REQUEST_METHOD'];
	if("GET"!=$REQUEST_METHOD) //要GET才做缓存.
		goto do_normal_only;

	//TODO 检查其它 明显 不需要缓存的情况?

	function _handle304_v2($now, $lmt, $tag, $client_cache_time=3600){
		$md5 = md5($lmt.$tag);
		$etag = '"' . $md5 . '"';

		$flag_time=true;
		$flag_etag=true;

		$flag_check=false;//假设默认 !(HTTP_IF_MODIFIED_SINCE || HTTP_IF_UNMODIFIED_SINCE || HTTP_IF_NONE_MATCH)

		//$lmt+=1;//测试 PASS
		if(isset($_SERVER['HTTP_IF_MODIFIED_SINCE'])){
			$flag_check=true;
			if(strtotime($_SERVER['HTTP_IF_MODIFIED_SINCE']) < $lmt){
				$flag_time=false;
			}
		}
		if(isset($_SERVER['HTTP_IF_UNMODIFIED_SINCE'])){
			$flag_check=true;
			if(strtotime($_SERVER['HTTP_IF_UNMODIFIED_SINCE']) >= $lmt) {
				$flag_time=false;
			}
		}
		$HTTP_IF_NONE_MATCH="";
		if(isset($_SERVER['HTTP_IF_NONE_MATCH'])){
			$flag_check=true;
			$HTTP_IF_NONE_MATCH=$_SERVER['HTTP_IF_NONE_MATCH'];
			$HTTP_IF_NONE_MATCH=preg_replace("/^W\//","",$HTTP_IF_NONE_MATCH);
			$HTTP_IF_NONE_MATCH=preg_replace("/-gzip$//","",$HTTP_IF_NONE_MATCH);
			$etag2=preg_replace("/-gzip$//","",$etag2);
			if( $HTTP_IF_NONE_MATCH != $etag2){
				$flag_etag=false;
			}
		}

		#session_cache_limiter("public");

		header('Cache-Control: public, max-age='.$client_cache_time);

		header('Expires: '.gmdate('D, d M Y H:i:s', $now + $client_cache_time).' GMT');//设置页面缓存时间

		header('Pragma: public');

		header('Last-Modified: '.gmdate('D, d M Y H:i:s',$lmt ).' GMT');

		header("ETag: $etag");
		if($flag_check && $flag_time && $flag_etag)
		{
			header("HTTP/1.1 304 Not Modified");
			//exit(0);
			return false;
		}
		header("FailReason: Fail".($flag_etag?"_1":"_ETAG").($flag_time?"_2":"_TIME")
			.($flag_check?"_3":"_CHCK")."($etag,$HTTP_IF_NONE_MATCH,$etag2)");
		return true;
	}//function _handle304_v2

	$cache_tag=md5($REQUEST_URI);
	$cache_file_base =_STATIC_DIR_.$cache_tag;
	$cache_file = $cache_file_base .".cache";
	$cache_lmt_file = $cache_file_base.".lmt";
	if(file_exists($cache_file) && file_exists($cache_lmt_file)){
		$cache_lmt=file_get_contents($cache_lmt_file);
		if( $current_time < $cache_lmt + $cache_time ){
			$cache_content=file_get_contents($cache_file);
			if($cache_content!=""){
				$Content_type=$_GET['Content_type'];
				if($Content_type!=""){
					if($Content_type=='text/css'){
						header("Content-Type: $Content_type");
					}else{
						//先忽略，以后再看情况.
						//header("Content-Type: ".$Content_type);
					}
				}
				ignore_user_abort(true);//304后客户端可能会主动断开。这时我也先不断开，还要判断下要不要做步进缓存.
				$flag_304= ! _handle304_v2($current_time, $cache_lmt, $cache_tag, $cache_time );
				if ($flag_304){
					//if send 304, the browser will try to disconnect now,
					//that's why we nee to set ignore_user_abort() to continue
					header("StaticDebug: Yes304");//Should see no this.
				}else{
					header("StaticDebug: Fail304");
					//如果 304 失败，改为把缓存输出先，等下会再看要不要建立缓存.
					//$headers_from_client=getallheaders();
					#header("StaticTime: ".date_create()->format('Y-m-d H:i:s'));
					#header("LMT: ".date_create($cache_lmt)->format('Y-m-d H:i:s'));
				}

				//since the buffer is send, we now proceed on to check where we need to update the cache
				if ( $current_time < $cache_lmt + $cache_time/2 ){
					//strategy: if within half cache_time config, we skip the cache generation...
					$flag_build_anyway=false;//还在步进区间，不用build.
				}else{
					#goto do_normal_and_write_cache_only;
					header("StaticNormal: \"".date_create()->format('Y-m-d H:i:s') ."\"");
					$flag_build_anyway=true;
				}
				if(!$flag_304){
					echo $cache_content;
					flush();
				}
				if($flag_build_anyway){
					$output=_static_build_content($cache_file, $cache_lmt_file, $current_time);
				}
				goto section_end;
			}
		}else{
			header("StaticDebug: \"Failed $current_time < $cache_lmt + $cache_time\"");
		}
	}else{
		header("StaticDebug: NoCacheFound");
	}
}//read_cache_and_judge

function _static_build_content($cache_file, $cache_lmt_file, $current_time){
	$_prev_HTTP_ACCEPT_ENCODING=$_SERVER['HTTP_ACCEPT_ENCODING'];
	$_SERVER['HTTP_ACCEPT_ENCODING']='deflate';

	//do normal handling
	@ob_start();
	include 'index.php';
	$output = ob_get_clean();

	file_put_contents($cache_file, $output);
	file_put_contents($cache_lmt_file, $current_time);

	$_SERVER['HTTP_ACCEPT_ENCODING']=$_prev_HTTP_ACCEPT_ENCODING;
	return $output;
}

$output=_static_build_content($cache_file, $cache_lmt_file, $current_time);
header("StaticNormal: NormalBuild");
_gzip_output($output);
goto section_end;

do_normal_only:{
	header("StaticNormal: NormalNotBuild");
	include 'index.php';
	goto section_end;
}

section_end:{}


