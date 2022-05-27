<?php
include_once '../config/connection.php';
include_once '../json_format.php';

$response  = [];

if ($_SERVER['REQUEST_METHOD']== 'GET') {

    $sql = $con->query("SELECT * FROM products WHERE quantity != 0 ORDER BY posted_on DESC");
    
    if(!mysqli_error($con)){
        if (mysqli_num_rows($sql) >  0) {
            while($product_details = mysqli_fetch_assoc($sql)){
                $response[] = $product_details;
            }
        } else {
            $response['status'] = 'OK';
            $response['message'] = 'No available products yet';
        }
    }else{
        $response['status'] = 'error';
        $response['message'] = 'There is an error -> '.mysqli_error($con);
    }

} else {
    $response['status'] = 'error';
    $response['message'] = 'Invalid Request Method';
}

echo json_encode($response);