Hostname: <?=gethostname();?><br/>

<?php

$link = mysqli_connect('db1', getenv('DB1_ENV_MYSQL_USERNAME'), getenv('DB1_ENV_MYSQL_PASSWORD'));
if (!$link) {
    die('Could not connect: ' . mysqli_error());
}
echo 'Connected successfully';
?>

PHP version: <?=phpversion()?> - MySQL version: <?=mysqli_get_server_info($link)?>

<?php mysqli_close($link); ?>