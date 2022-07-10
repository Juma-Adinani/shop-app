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
    $user = pg_escape_string($con, $_POST['user_id']);
    $sql = "SELECT cart.id as id, ordered_quantity, quantity, description, 
            product_name, product_photo, price, cart.user_id, price::int * ordered_quantity::int as totalPrice
            FROM cart, products 
            WHERE cart.product_id = products.id
            AND cart.user_id = '" . $user . "'";
    $query = pg_query($con, $sql);
    if (!pg_last_error($con)) {
        if (pg_num_rows($query) > 0) {
            while ($row = pg_fetch_assoc($query)) {
                $product = $row;
                array_push($products, $product);
            }
            $sql = pg_query($con, "SELECT SUM((SELECT price FROM products WHERE id = product_id)::int * ordered_quantity) as totalamount, SUM(ordered_quantity) as quantity 
                                FROM cart WHERE user_id = '" . $user . "'");
            $fetch = pg_fetch_assoc($sql);
            $total = $fetch['totalamount'];
            $quantityTotal = $fetch['quantity'];
            $quantityTotal = intval($quantityTotal);
        } else {
            $status = 'EMPTY';
            $message = 'No available products in your cart';
        }
    } else {
        $status = 'Error';
        $message = 'There is an error -> ' . pg_last_error($con);
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
        "totalQuantity" => $quantityTotal
    ]
];
// die(json_encode(var_dump($product)));
echo json_encode($response);
