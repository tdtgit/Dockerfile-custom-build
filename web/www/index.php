Hostname: <?=gethostname();?><br/>

<?php

$link = mysqli_connect(
    getenv('DB1_PORT_3306_TCP_ADDR'),
    getenv('DB1_ENV_MYSQL_USERNAME'),
    getenv('DB1_ENV_MYSQL_PASSWORD'),
    getenv('DB1_ENV_MYSQL_DBNAME')
);

if (!$link) {
    die('Could not connect: ' . mysqli_error());
}
echo 'Connected successfully';
?>

PHP version: <?=phpversion()?> - MySQL version: <?=mysqli_get_server_info($link)?>

<?php mysqli_close($link); ?>