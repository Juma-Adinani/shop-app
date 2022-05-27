<?php
include_once '../json_format.php';
include_once '../config/connection.php';

$response = [];

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    if (!empty($_POST)) {
        $user = mysqli_real_escape_string($con, $_POST['user_id']);
        $product = mysqli_real_escape_string($con, $_POST['product_id']);
        $quantity = mysqli_real_escape_string($con, $_POST['ordered_quantity']);
        $sql = $con->query("SELECT quantity FROM products WHERE id = $product");
        if (!mysqli_error($con)) {
            
            $fetch_product = mysqli_fetch_assoc($sql);

            if ($quantity <= 0) {
                $response['error'] = 'you cannot order 0 quantity';
            } else {

                if ($quantity <= $fetch_product['quantity']) {

                    $sql = $con->query("INSERT INTO cart (product_id, ordered_quantity, user_id) VALUES ('$product','$quantity', '$user')");

                    $remained_quantity = $fetch_product['quantity'] - $quantity;

                    $sql = $con->query("UPDATE products SET quantity = $remained_quantity WHERE id = $product");

                    $response['status'] = 'OK';
                    $response['message'] = 'A remained quantity is ' . $remained_quantity;
                } else {
                    $response['status'] = 'info';
                    $response['info'] = 'Idadi unayooda imezidi idadi iliyopo';
                    $response['available'] = $fetch_product['quantity'];
                }
            }
        } else {

            $response['status'] = 'Error';
            $response['message'] = 'There is an error -> ' . mysqli_error($con);
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
