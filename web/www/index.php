<?php

$link = mysql_connect('db1', 'env', 'SecurePW123@FromENV');
if (!$link) {
    die('Could not connect: ' . mysql_error());
}
echo 'Connected successfully';
mysql_close($link);