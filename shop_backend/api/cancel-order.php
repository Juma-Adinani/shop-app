<?php
include_once '../config/connection.php';
include_once '../json_format.php';
$response = [];
// $data = array();
$status = '';
$message = '';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    if (isset($_POST)) {
        $order = mysqli_real_escape_string($con, $_POST['orderid']);
        $user = mysqli_real_escape_string($con, $_POST['userid']);

        $sql_order = $con->query("SELECT * FROM orders WHERE order_id = $order AND user_id = $user");

        if (mysqli_num_rows($sql_order) > 0) {
            $row = mysqli_fetch_assoc($sql_order);
            //take a cancel fee from the one who cancel the order
            $phone = $row['phone_number'];
            $cancelFee =  $row['amount'] * 0.1;
            $returnedAmount = $row['amount'] - $cancelFee;
            $sql_mpesa = $con->query("SELECT amount FROM mpesa_account WHERE phoneNumber = '" . $phone . "'");
            if (!mysqli_error($con)) {
                $mpesa_fetch = mysqli_fetch_assoc($sql_mpesa);
                $newAmount = $returnedAmount + $mpesa_fetch['amount'];

                $mpesa_update = $con->query("UPDATE mpesa_account SET amount = $newAmount  WHERE phoneNumber = '" . $phone . "'");

                //return a quantity to each product accordingly
                $quantityFetch = $con->query("SELECT products.id as id, quantity as current_quantity, ordered_quantity 
                                            FROM orders, products 
                                            WHERE orders.product_id = products.id
                                            AND orders.user_id = $user
                                            AND orders.order_id = $order");
                if (!mysqli_error($con)) {
                    if (mysqli_num_rows($quantityFetch) > 0) {
                        while ($quantity_update = mysqli_fetch_assoc($quantityFetch)) {
                            $newQuantity = $quantity_update['current_quantity'] + $quantity_update['ordered_quantity'];

                            $setNewQuantity = $con->query("UPDATE products SET quantity = $newQuantity WHERE id = '" . $quantity_update['id'] . "'");

                            if (!mysqli_error($con)) {
                                $cancelOrder = $con->query("DELETE FROM orders WHERE order_id = $order");

                                if (!mysqli_error($con)) {
                                    $status = "SUCCESS";
                                    $message = "Oda imeondolewa kikamilifu, Karibu tena";
                                    // $data = [
                                    //     'pesa ya kuoda'=> $row['amount'],
                                    //     'balance ya mpesa'=> $mpesa_fetch['amount'],
                                    //     'Pesa yetu'=>$cancelFee,
                                    //     'irudishwe to mpesa'=>$returnedAmount,
                                    //     'inayorudishwa + balance yake'=>$newAmount,
                                    // ];
                                } else {
                                    $message = "There is an error";
                                }
                            } else {
                                $message = "There is an error";
                            }
                        }
                    } else {
                        $message = "No data";
                    }
                } else {
                    $message = "There is an error" . mysqli_error($con);
                }
            } else {
                $status = 'ERROR';
                $message = 'There is an error';
            }
        } else {
            $status = 'ERROR';
            $message = 'No such order';
            $data = "Empty";
        }
    }
} else {
    $status = "Error";
    $message = "Invalid request method";
    $data = "empty";
}

// $response = [
//     'status' => $status,
//     'message' => $message,
//     'data' => $data,
// ];

$response = [
    'status' => $status,
    'message' => $message,
];

echo json_encode($response);
