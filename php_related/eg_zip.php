<?php
$s=file_get_contents('data');
$d=gzencode($s);
$u=base64_encode($d);
var_dump($u);
