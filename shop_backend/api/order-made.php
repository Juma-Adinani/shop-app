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
        $user = pg_escape_string($con, $_POST['userid']);

        $sql = "SELECT order_id as id, count(product_id) as product, MAX(product_photo) as product_photo, MAX(status) as status, MAX(to_be_paid) as to_be_paid, MAX(ordered_quantity) as quantity, MAX(amount) as amount, MAX(order_date) as order_date
                            FROM orders, products, order_status
                            WHERE orders.user_id = $user
                            AND orders.product_id = products.id
                            AND orders.status_id = order_status.id
                            GROUP BY order_id
                            ORDER BY order_date DESC";
        $result = pg_query($con, $sql);

        if (!pg_last_error($con)) {
            if (!pg_num_rows($result) > 0) {
                $status = "EMPTY";
                $message = "You have not make an order";
            } else {
                while ($row = pg_fetch_assoc($result)) {
                    $status = "OK";
                    $message = "";
                    array_push($data, $row);
                }

                // $sql = pg_query($con, "SELECT SUM(amount) as totalAmount FROM orders WHERE user_id = '$user'");
                // $fetch = pg_fetch_assoc($sql);
                // $total = $fetch['totalAmount'];

                $sql = pg_query($con, "SELECT amount FROM orders WHERE user_id = '$user' GROUP BY order_id, amount");
                while ($fetchTotal = pg_fetch_assoc($sql)) {
                    $total += $fetchTotal['amount'];
                }
                $total = strval($total);
            }
        } else {
            $status = 'ERROR';
            $message = 'Failed to fetch' . pg_last_error($con);
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
