<?php

include_once '../config/connection.php';
include_once '../json_format.php';

$response = [];
$data = array();
$status = "";
$message = "";

if ($_SERVER['REQUEST_METHOD'] == "POST") {

    $user = mysqli_real_escape_string($con, $_POST['userid']);
    $cartid = mysqli_real_escape_string($con, $_POST['cartid']);

    $sql = "SELECT product_id, ordered_quantity FROM cart WHERE id = '$cartid' AND user_id = '$user'";
    $result = mysqli_query($con, $sql);

    $row = mysqli_fetch_assoc($result);
    $quantity = $row['ordered_quantity'];
    $product = $row['product_id'];

    $sql = $con->query("SELECT quantity FROM products WHERE id = '$product'");
    $productFetch = mysqli_fetch_assoc($sql);
    $availableQuantity = $productFetch['quantity'];

    $newQuantity = $availableQuantity + $quantity;

    $returnQuantity = $con->query("UPDATE products SET quantity = '$newQuantity' WHERE id = '$product'");

    $sql = $con->query("DELETE FROM cart WHERE id = '$cartid'");

    if (!mysqli_error($con)) {
        $status = "OK";
        $message = "Bidhaa imeondolewa kwenye kapu kikamililifu";
    }
} else {
    $status = "ERROR";
    $message = "Invalid request method";
}

$response = [
    "status" => $status,
    "message" => $message,
];

echo json_encode($response);
