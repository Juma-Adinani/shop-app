<?php
include_once '../config/connection.php';
include_once '../json_format.php';

$response = [];
$data = array();
$message = "";
$status = "";
$total = 0;

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST)) {
        $user = mysqli_real_escape_string($con, $_POST['userid']);

        $sql = "SELECT order_id as id, count(product_id) as product, product_photo, status, to_be_paid, ordered_quantity as quantity, amount, order_date 
                            FROM orders, products, order_status
                            WHERE orders.user_id = $user
                            AND orders.product_id = products.id
                            AND orders.status_id = order_status.id
                            GROUP BY order_id
                            ORDER BY order_date DESC";
        $result = mysqli_query($con, $sql);

        if (!mysqli_error($con)) {
            if (!mysqli_num_rows($result) > 0) {
                $status = "EMPTY";
                $message = "Huna oda yeyote kwa sasa";
            } else {
                while ($row = mysqli_fetch_assoc($result)) {
                    $status = "OK";
                    $message = "";
                    array_push($data, $row);
                }

                // $sql = $con->query("SELECT SUM(amount) as totalAmount FROM orders WHERE user_id = '$user'");
                // $fetch = mysqli_fetch_assoc($sql);
                // $total = $fetch['totalAmount'];

                $sql = $con->query("SELECT amount FROM orders WHERE user_id = '$user' GROUP BY order_id");
                while ($fetchTotal = mysqli_fetch_assoc($sql)) {
                    $total += $fetchTotal['amount'];
                }
                $total = strval($total);
            }
        } else {
            $status = 'ERROR';
            $message = 'Failed to fetch' . mysqli_error($con);
        }
    }
} else {
    $status = 'Error';
    $message = 'Invalid request method';
}

$response = [
    'status' => $status,
    'message' => $message,
    'data' => $data,
    'totalAmount' => $total
];

echo json_encode($response);
