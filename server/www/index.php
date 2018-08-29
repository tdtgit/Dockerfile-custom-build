<?php

$link = mysql_connect('172.17.0.2', 'trump', 'AJZ9b2fFGJ6I)REd');
if (!$link) {
    die('Could not connect: ' . mysql_error());
}
echo 'Connected successfully';
mysql_close($link);