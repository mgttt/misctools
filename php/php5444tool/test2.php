<?php
require 'inc.func.http_req.php';

print http_req([
	'url'=>'https://www.apple.com/',
	'method'=>'GET'
]);
