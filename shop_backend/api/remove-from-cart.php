<?php

include_once '../config/connection.php';
include_once '../json_format.php';

$response = [];
$data = array();
$status = "";
$message = "";

if ($_SERVER['REQUEST_METHOD'] == "POST") {

    $user = pg_escape_string($con, $_POST['userid']);
    $cartid = pg_escape_string($con, $_POST['cartid']);

    $sql = "SELECT product_id, ordered_quantity FROM cart WHERE id = '$cartid' AND user_id = '$user'";
    $result = pg_query($con, $sql);

    $row = pg_fetch_assoc($result);
    $quantity = $row['ordered_quantity'];
    $product = $row['product_id'];

    $sql = pg_query($con, "SELECT quantity FROM products WHERE id = '$product'");
    $productFetch = pg_fetch_assoc($sql);
    $availableQuantity = $productFetch['quantity'];

    $newQuantity = $availableQuantity + $quantity;

    $returnQuantity = pg_query($con, "UPDATE products SET quantity = '$newQuantity' WHERE id = '$product'");

    $sql = pg_query($con, "DELETE FROM cart WHERE id = '$cartid'");

    if (!pg_last_error($con)) {
        $status = "OK";
        $message = "Product removed from your cart";
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
