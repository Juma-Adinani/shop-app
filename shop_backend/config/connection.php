<?php
header("Access-Control-Allow-Origin: *");
// $host   = "localhost";
// $user   = "root";
// $db     = "shop_app";
// $pass   = "";

// $con = mysqli_connect($host, $user, $pass, $db);
// $con = pg_connect("host=localhost user=postgres dbname=shopdb password=juma");
$con = pg_connect("host=ec2-34-233-115-14.compute-1.amazonaws.com user=lmadosmyycefpd dbname=d32iad0dnronhi password=4644315ce75f70978d521cebd17f4b51d3c312b8504f736c1e771acf3e65441a");

// if (mysqli_connect_error()) {
//     include_once '../json_format.php';
//     die(json_encode(['status' => 'Error', 'message' => 'There is an error in database connection.', 'data' => '']));
// }

if (pg_last_error()) {
    include_once '../json_format.php';
    die(json_encode(['status' => 'Error', 'message' => 'There is an error in database connection.', 'data' => '']));
}
