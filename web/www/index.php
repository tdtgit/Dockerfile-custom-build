<?php

$link = mysqli_connect('db1', 'env', 'SecurePW123@FromENV');
if (!$link) {
    die('Could not connect: ' . mysqli_error());
}
echo 'Connected successfully';
?>

PHP version: <?=phpversion()?> - MySQL version: <?=mysqli_get_server_info($link)?>

<?php mysqli_close($link); ?>