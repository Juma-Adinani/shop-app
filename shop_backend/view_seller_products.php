<?php

include_once './json_format.php';
include_once './config/connection.php';
session_start();

$response = [];

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    if (isset($_GET['id']) && !empty($_GET)) {
        $id = mysqli_real_escape_string($con, $_GET['id']);
        $sql = $con->query("SELECT product_name, product_photo, description, price, quantity
                FROM products
                WHERE products.user_id = '$_SESSION[id]' OR products.user_id = '$id'");
        if (!mysqli_error($con)) {
            if (mysqli_num_rows($sql) > 0) {
                while ($row = mysqli_fetch_assoc($sql)) {
                    $response[] = $row;
                }
            } else {
                $response['status'] = 'OK';
                $response['message'] = 'No available products yet';
            }
        } else {
            $response['status'] = 'Error';
            $response['message'] = 'There is an error -> ' . mysqli_error($con);
        }
    } else {
        $response['status'] = 'Warning';
        $response['message'] = 'id is not captured';
    }
} else {
    $response['status'] = 'Error';
    $response['message'] = 'Invalid request method';
}
echo json_encode($response);
