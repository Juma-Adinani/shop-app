<?php
include_once '../config/connection.php';
include_once '../json_format.php';

$response = [];
$status = '';
$message = '';
$data = array();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST)) {

        $userId = mysqli_real_escape_string($con, $_POST['userid']); // from shared preferences
        $phoneNumber = mysqli_real_escape_string($con, $_POST['phone']);
        $amount = mysqli_real_escape_string($con, $_POST['amount']);
        $pin = mysqli_real_escape_string($con, $_POST['pin']);
        $orderid = mysqli_real_escape_string($con, $_POST['orderid']);

        $fetch_mpesa_details = $con->query("SELECT phoneNumber FROM payment_methods");

        if (mysqli_num_rows($fetch_mpesa_details) > 0) {

            while ($array_check = mysqli_fetch_assoc($fetch_mpesa_details)) {

                $result_phone_number[] = $array_check['phoneNumber'];
            }
            if (in_array($phoneNumber, $result_phone_number)) {

                $fetch_amount = $con->query("SELECT amount from payment_methods WHERE phoneNumber = $phoneNumber");

                if (mysqli_num_rows($fetch_amount) == 1) {

                    $amount_check = mysqli_fetch_assoc($fetch_amount);
                    $balance = $amount_check['amount'];

                    if ($amount > $balance || $amount < 0) {

                        $status = "ERROR";
                        $message = 'Huna salio la kutosha, Ongeza salio kuweza kukamilisha muamala huu';
                    } else {

                        $fetch_pin = $con->query("SELECT pin FROM payment_methods WHERE phoneNumber = $phoneNumber");

                        if (mysqli_num_rows($fetch_pin) == 1) {

                            $pin_check = mysqli_fetch_assoc($fetch_pin);

                            if ($pin != $pin_check['pin']) {
                                $status = "ERROR";
                                $message = "Namba ya siri uliyoingiza siyo sahihi";
                            } else {
                                $orders = $con->query("SELECT order_id, amount, to_be_paid FROM orders WHERE order_id = '$orderid'");

                                if (mysqli_num_rows($orders) > 0) {

                                    $fetchOrders = mysqli_fetch_assoc($orders);
                                    $tobepaid = $fetchOrders['to_be_paid'];
                                    $fetchedAmount = $fetchOrders['amount'];

                                    if ($amount >= $tobepaid) {
                                        $remainedAmount = $amount - $tobepaid;
                                        $mpesaAmount = $remainedAmount + ($balance - $amount); //to mpesa
                                        $newAmount = $tobepaid + $fetchedAmount; //to amount
                                        $tobepaid = 0;
                                        $status = 2;
                                    }

                                    if ($tobepaid > $amount) {
                                        $remainedAmount = $tobepaid - $amount; //to to be paid
                                        $tobepaid = $remainedAmount;
                                        $newAmount = $fetchedAmount + $amount; //to amount
                                        $mpesaAmount = $balance - $amount; //to mpesa
                                        $status = 1;
                                    }

                                    $mpesaQuery = $con->query("UPDATE payment_methods SET amount = '$mpesaAmount' WHERE phoneNumber = '$phoneNumber'");

                                    $orderQuery = $con->query("UPDATE orders SET amount = '$newAmount', to_be_paid = '$tobepaid', status_id = '$status' WHERE order_id = '$orderid'");

                                    if (!mysqli_error($con)) {
                                        $status = "OK";
                                        $message = "Malipo yamefanyika kikamilifu";
                                    }

                                    // $data = [
                                    //     'salio la mpesa kabla ya malipo' => $balance,
                                    //     'kiasi kilicholipwa' => $amount,
                                    //     'kiasi kipya katika order' => $newAmount,
                                    //     'kiasi kilichobaki kulipwa' => $tobepaid,
                                    //     'salio jipya la mpesa' => $mpesaAmount
                                    // ];

                                    //inayosalia return to mpesa account where phone number  is equal to hiyo number posted hapo
                                    //update tobe paid set to zero,
                                    //update amount set fetchamount + tobepaid
                                    //update status set to 2

                                } else {
                                    $status = 'ERROR';
                                    $message = 'Order chossen is not available';
                                }
                            }
                        }
                    }
                }
            } else {
                $status = 'ERROR';
                $message = 'Namba ya simu haijasajiliwa';
            }
        } else {
            $status = 'ERROR';
            $message = 'M-PESA account is not available';
        }
    }
} else {
    $status = 'ERROR';
    $message = 'Invalid request method';
}

$response = [
    'status' => $status,
    'message' => $message,
    'data' => $data
];

echo json_encode($response);
