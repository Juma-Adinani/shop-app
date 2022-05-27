<?php
include_once '../config/connection.php';
include_once '../json_format.php';

$response = [];

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST)) {

        $userId = mysqli_real_escape_string($con, $_POST['userid']); // from shared preferences
        $phoneNumber = mysqli_real_escape_string($con, $_POST['phone']);
        $amount = mysqli_real_escape_string($con, $_POST['amount']);
        $pin = mysqli_real_escape_string($con, $_POST['pin']);
        $orderedQuantity = mysqli_real_escape_string($con, $_POST['quantity']);
        $location = 'Dar Es Salaam';

        $fetch_mpesa_details = $con->query("SELECT phoneNumber FROM mpesa_account");

        if (mysqli_num_rows($fetch_mpesa_details) > 0) {

            while ($array_check = mysqli_fetch_assoc($fetch_mpesa_details)) {

                $result_phone_number[] = $array_check['phoneNumber'];
            }
            if (in_array($phoneNumber, $result_phone_number)) {

                $fetch_amount = $con->query("SELECT amount from mpesa_account WHERE phoneNumber = $phoneNumber");

                if (mysqli_num_rows($fetch_amount) == 1) {

                    $amount_check = mysqli_fetch_assoc($fetch_amount);
                    $balance = $amount_check['amount'];

                    if ($amount > $balance || $amount < 0) {

                        $response['status'] = "ERROR";
                        $response['message'] = "Huna salio la kutosha, Ongeza salio kuweza kukamilisha muamala huu";
                        $response['info'] = 'salio lako ni ' . $balance;
                    } else {

                        $fetch_pin = $con->query("SELECT pin FROM mpesa_account WHERE phoneNumber = $phoneNumber");

                        if (mysqli_num_rows($fetch_pin) == 1) {

                            $pin_check = mysqli_fetch_assoc($fetch_pin);

                            if ($pin != $pin_check['pin']) {
                                $response['status'] = "ERROR";
                                $response['message'] = "Namba ya siri uliyoingiza siyo sahihi";
                            } else {


                                $total_price = 0;
                                $price = 0;
                                $fetch_price = $con->query("SELECT SUM(price * ordered_quantity) AS total FROM cart, products WHERE cart.user_id = '" . $userId . "' AND cart.product_id = products.id");
                                while ($fetch_result = mysqli_fetch_assoc($fetch_price)) {

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
                                $query = mysqli_query($con, $sql);
                                if (!mysqli_error($con)) {
                                    if (mysqli_num_rows($query) > 0) {
                                        $stamp = time();
                                        while ($row = mysqli_fetch_assoc($query)) {
                                            $product = $row['product_id'];
                                            $order_query = $con->query(
                                                "INSERT INTO orders (order_id, product_id, ordered_quantity, location, phone_number, amount, to_be_paid, user_id, status_id) 
                                                VALUES ('$stamp','$product', '$orderedQuantity', '$location', '$phoneNumber', '$amount', '$toBePaid', '$userId', $status)"
                                            );
                                        }

                                        $sql = "DELETE FROM cart  WHERE user_id = $userId";
                                        $query = mysqli_query($con, $sql);

                                        $sql = $con->query("UPDATE mpesa_account SET amount = $remained WHERE phoneNumber = $phoneNumber");
                                        $response['status'] = 'SUCCESS';
                                        $response['message'] = 'Oda imefanyika kikamilifu';
                                        $response['totalPrice'] = $total_price;
                                        $response['toBePaid'] = $toBePaid;
                                        // 'salio' => $remained,
                                    } else {
                                        $response['status'] = 'EMPTY';
                                        $response['message'] = 'Hakuna bidhaa kwenye kapu lako';
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
                $response['message'] = 'Namba haijasajiliwa m-pesa';
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
