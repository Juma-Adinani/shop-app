<?php

include_once '../json_format.php';
include_once '../config/connection.php';
session_start();

$status = "OK";
$products = [];
$total = 0;
$message = "";
$quantityTotal = 0;

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user = mysqli_real_escape_string($con, $_POST['user_id']);
    $sql = "SELECT cart.id as id, ordered_quantity, quantity, description, 
            product_name, product_photo, price, cart.user_id, price * ordered_quantity as totalPrice
            FROM cart, products 
            WHERE cart.product_id = products.id
            AND cart.user_id = '" . $user . "'";
    $query = mysqli_query($con, $sql);
    if (!mysqli_error($con)) {
        if (mysqli_num_rows($query) > 0) {
            while ($row = mysqli_fetch_assoc($query)) {
                $product = $row;
                array_push($products, $product);
            }
            $sql = $con->query("SELECT SUM((SELECT price FROM products WHERE id = product_id) * ordered_quantity) as totalAmount, SUM(ordered_quantity) as quantity FROM cart WHERE user_id = '" . $user . "'");
            $fetch = mysqli_fetch_assoc($sql);
            $total = $fetch['totalAmount'];
            $quantityTotal = $fetch['quantity'];
            $quantityTotal = intval($quantityTotal);
        } else {
            $status = 'EMPTY';
            $message = 'Hakuna bidhaa kwenye kapu lako';
        }
    } else {
        $status = 'Error';
        $message = 'There is an error -> ' . mysqli_error($con);
    }
} else {
    $status = 'Error';
    $message = 'Invalid request method';
}

$response = [
    "status" => $status,
    "message" => $message,
    "data" => [
        "products" => $products,
        "total" => $total,
        "totalQuantity"=>$quantityTotal
    ]
];

echo json_encode($response);
