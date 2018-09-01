<?php
$f=$argv[1];$dateYmd=date('Ymd');while($l=fgets(STDIN)){file_put_contents("$f.$dateYmd.gz",gzencode($l),FILE_APPEND);echo($l);}
