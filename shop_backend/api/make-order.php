<?php
include_once '../config/connection.php';
include_once '../json_format.php';

$response = [];

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST)) {

        $userId = pg_escape_string($con, $_POST['userid']); // from shared preferences
        $phoneNumber = pg_escape_string($con, $_POST['phone']);
        $amount = pg_escape_string($con, $_POST['amount']);
        $pin = pg_escape_string($con, $_POST['pin']);
        $orderedQuantity = pg_escape_string($con, $_POST['quantity']);
        $orderDate = date("d-m-Y, H:i:s");
        $location = 'Dar Es Salaam';

        $fetch_mpesa_details = pg_query($con, "SELECT phoneNumber as phone FROM payment_methods");

        if (pg_num_rows($fetch_mpesa_details) > 0) {

            while ($array_check = pg_fetch_assoc($fetch_mpesa_details)) {

                $result_phone_number[] = $array_check['phone'];
            }
            if (in_array($phoneNumber, $result_phone_number)) {

                $fetch_amount = pg_query($con, "SELECT amount from payment_methods WHERE phoneNumber = '" . $phoneNumber . "'");

                if (pg_num_rows($fetch_amount) == 1) {

                    $amount_check = pg_fetch_assoc($fetch_amount);
                    $balance = $amount_check['amount'];

                    if ($amount > $balance || $amount < 0) {

                        $response['status'] = "ERROR";
                        $response['message'] = "Insufficient balance";
                        $response['info'] = 'salio lako ni ' . $balance;
                    } else {

                        $fetch_pin = pg_query($con, "SELECT pin FROM payment_methods WHERE phoneNumber = '" . $phoneNumber . "'");

                        if (pg_num_rows($fetch_pin) == 1) {

                            $pin_check = pg_fetch_assoc($fetch_pin);

                            if ($pin != $pin_check['pin']) {
                                $response['status'] = "ERROR";
                                $response['message'] = "Incorrect PIN";
                            } else {


                                $total_price = 0;
                                $price = 0;
                                $fetch_price = pg_query($con, "SELECT SUM(price::int * ordered_quantity) AS total FROM cart, products WHERE cart.user_id = '" . $userId . "' AND cart.product_id = products.id");
                                while ($fetch_result = pg_fetch_assoc($fetch_price)) {

                                    $total_price = $fetch_result['total'];
                                }

                                if ($amount == $total_price) {
                                    //set order status to complete
                                    $status = 2;
                                    $remained = $balance - $amount;
                                    $toBePaid = $total_price - $amount;
                                } else if ($amount > $total_price) {
                                    //set order status to complete
                                    $status = 2;
                                    $extra_amount = $amount - $total_price;
                                    $remained = ($balance - $amount) + $extra_amount;
                                    $toBePaid = 0;
                                    $amount = $total_price; //new one added
                                } else if ($amount < $total_price) {
                                    //set order status to pending                                    
                                    $status = 1;
                                    $remained = $balance - $amount;
                                    $toBePaid = $total_price - $amount;
                                }

                                // insert all from cart to orders table
                                $sql = "SELECT ordered_quantity, product_id FROM cart  WHERE user_id = $userId";
                                $query = pg_query($con, $sql);
                                if (!pg_last_error($con)) {
                                    if (pg_num_rows($query) > 0) {
                                        $stamp = time();
                                        while ($row = pg_fetch_assoc($query)) {
                                            $product = $row['product_id'];
                                            $order_query = pg_query(
                                                $con,
                                                "INSERT INTO orders (order_id, product_id, ordered_quantity, order_date, location, phone_number, amount, to_be_paid, user_id, status_id) 
                                                VALUES ('$stamp','$product', '$orderedQuantity', '$orderDate', '$location', '$phoneNumber', '$amount', '$toBePaid', '$userId', $status)"
                                            );
                                        }

                                        $sql = "DELETE FROM cart  WHERE user_id = $userId";
                                        $query = pg_query($con, $sql);

                                        $sql = pg_query($con, "UPDATE payment_methods SET amount = $remained WHERE phoneNumber = '" . $phoneNumber . "'");
                                        $response['status'] = 'SUCCESS';
                                        $response['message'] = 'Payment done successfully';
                                        $response['totalPrice'] = $total_price;
                                        $response['toBePaid'] = $toBePaid;
                                        // 'salio' => $remained,
                                    } else {
                                        $response['status'] = 'EMPTY';
                                        $response['message'] = 'No available products in your cart';
                                    }
                                } else {
                                    $response['status'] = 'ERROR';
                                    $response['message'] = 'There is an error';
                                }
                            }
                        }
                    }
                }
            } else {
                $response['status'] = 'ERROR';
                $response['message'] = 'phone number is not registered';
            }
        } else {
            $response['status'] = 'ERROR';
            $response['message'] = 'M-PESA account is not available';
        }
    }
} else {
    $response['status'] = 'ERROR';
    $response['message'] = 'Invalid request method';
}

echo json_encode($response);
