<?php
header("Access-Control-Allow-Origin: *");
$host   = "localhost";
$user   = "root";
$db     = "shop_app";
$pass   = "";

$con = mysqli_connect($host, $user, $pass, $db);

if (mysqli_connect_error()) {
    include_once '../json_format.php';
    die(json_encode(['status' => 'Error', 'message' => 'There is an error in database connection.', 'data' => '']));
}
