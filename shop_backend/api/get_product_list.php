<?php
include_once '../config/connection.php';
include_once '../json_format.php';

$response  = [];

if ($_SERVER['REQUEST_METHOD'] == 'GET') {

    $sql = pg_query($con, "SELECT products.id as id, product_name, description, price, quantity, 
                        product_photo, posted_on, category_name, category_id, user_id
                        FROM products, product_categories
                        WHERE quantity != 0 
                        AND products.category_id = product_categories.id 
                        ORDER BY posted_on DESC");

    if (!pg_last_error($con)) {
        if (pg_num_rows($sql) >  0) {
            while ($product_details = pg_fetch_assoc($sql)) {
                $response[] = $product_details;
            }
        } else {
            $response['status'] = 'OK';
            $response['message'] = 'No available products yet';
        }
    } else {
        $response['status'] = 'error';
        $response['message'] = 'There is an error -> ' . pg_last_error($con);
    }
} else {
    $response['status'] = 'error';
    $response['message'] = 'Invalid Request Method';
}

echo json_encode($response);
