<?php
include_once '../json_format.php';
include_once '../config/connection.php';

$response = [];

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    if (!empty($_POST)) {
        $user = pg_escape_string($con, $_POST['user_id']);
        $product = pg_escape_string($con, $_POST['product_id']);
        $quantity = pg_escape_string($con, $_POST['ordered_quantity']);
        $addedOn = date("d-m-Y, H:i:s");
        $sql = pg_query($con, "SELECT quantity FROM products WHERE id = $product");
        if (!pg_last_error($con)) {

            $fetch_product = pg_fetch_assoc($sql);

            if ($quantity <= 0) {
                $response['error'] = 'you cannot order 0 quantity';
            } else {

                if ($quantity <= $fetch_product['quantity']) {

                    $sql = pg_query($con, "INSERT INTO cart (product_id, ordered_quantity, user_id, added_on) VALUES ('$product','$quantity', '$user', '$addedOn')");

                    $remained_quantity = $fetch_product['quantity'] - $quantity;
                    

                    $sql = pg_query($con, "UPDATE products SET quantity = $remained_quantity WHERE id = $product");

                    $response['status'] = 'OK';
                    $response['message'] = 'A remained quantity is ' . $remained_quantity;
                } else {
                    $response['status'] = 'info';
                    $response['info'] = 'Ordered quantity exceeds available quantity';
                    $response['available'] = $fetch_product['quantity'];
                }
            }
        } else {

            $response['status'] = 'Error';
            $response['message'] = 'There is an error -> ' . pg_last_error($con);
        }
    } else {
        $response['status'] = 'Error';
        $response['message'] = 'No product id captured';
    }
} else {

    $response['status'] = 'Error';
    $response['message'] = 'Invalid request method';
}
echo json_encode($response);
