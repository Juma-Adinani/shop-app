<!DOCTYPE html>
<html lang="en">
<?php
include_once '../config/connection.php';
?>

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ashopie Shop | shop smartly</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet" />
    <link href="" rel="stylesheet" />
    <!-- CSS only -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script type=" text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js">
    </script>
    <link rel="stylesheet" href="../assets/dist/css/bootstrap.min.css">
    <style>
        @import url("https://fonts.googleapis.com/css2?family=Rubik:wght@500&display=swap");

        body {
            background-color: #eaedf4;
            font-family: "Rubik", sans-serif;
        }

        .card {
            width: 310px;
            border: none;
            border-radius: 15px;
        }

        .justify-content-around div {
            border: none;
            border-radius: 20px;
            background: #f3f4f6;
            padding: 5px 20px 5px;
            color: #8d9297;
        }

        .justify-content-around span {
            font-size: 12px;
        }

        .justify-content-around div:hover {
            background: #545ebd;
            color: #fff;
            cursor: pointer;
        }

        .justify-content-around div:nth-child(1) {
            background: #545ebd;
            color: #fff;
        }

        span.mt-0 {
            color: #8d9297;
            font-size: 12px;
        }

        h6 {
            font-size: 15px;
        }

        .mpesa {
            background-color: green !important;
        }

        img {
            border-radius: 15px;
        }
    </style>
</head>
<?php
$message = "";
if (isset($_POST['inform'])) {
    $orderDate = date('d-m-Y, H:i:s', strtotime(pg_query($con, $_POST['date'])));
    $phone = pg_query($con, $_POST['phone']);
    $toBePaid = pg_query($con, $_POST['tobe']);
    $deadlineDate = date('d-m-Y', strtotime($orderDate . ' + 60 days'));
    $name = pg_query($con, $_POST['name']);
    // api key -> 96dc69cd86ef03f5
    // secret key -> ODU3MjAwZTMzMTgwY2M2MWVhODdjZjQxNjJjNDYyYWZkZTViMDA5MzNkYzY4M2QzNzEwNmZjMjM5ZmFmZDkzMQ== -->
    $api_key = '96dc69cd86ef03f5';
    $secret_key = 'ODU3MjAwZTMzMTgwY2M2MWVhODdjZjQxNjJjNDYyYWZkZTViMDA5MzNkYzY4M2QzNzEwNmZjMjM5ZmFmZDkzMQ==';

    $postData = array(
        'source_addr' => 'INFO',
        'encoding' => 0,
        'schedule_time' => '',
        'message' => 'Ndugu ' . $name . ' unakumbushwa kulipa kiasi cha sh. ' . $toBePaid . ' katika oda yako ya tarehe ' . $orderDate . ', kabla ya tarehe ' . $deadlineDate . '.
Ahsante sana na karibu sana kuendelea kutumia huduma zetu',
        'recipients' => [array('recipient_id' => '1', 'dest_addr' => $phone)]
    );
    $Url = 'https://apisms.beem.africa/v1/send';

    $ch = curl_init($Url);
    error_reporting(E_ALL);
    ini_set('display_errors', 1);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
    curl_setopt_array($ch, array(
        CURLOPT_POST => TRUE,
        CURLOPT_RETURNTRANSFER => TRUE,
        CURLOPT_HTTPHEADER => array(
            'Authorization:Basic ' . base64_encode("$api_key:$secret_key"),
            'Content-Type: application/json'
        ),
        CURLOPT_POSTFIELDS => json_encode($postData)
    ));

    $response = curl_exec($ch);

    if ($response === FALSE) {
        echo $response;
        $message .= "<div class='col-12 alert alert-danger'><i class='fa fa-times'></i>&nbsp;There is an error</div>";
        die(curl_error($ch));
    } else {
        $error = '{"data":{"code":102,"message":"Insufficient balance"}}';
        if ($response == $error) {
            $message .= '<div class="alert alert-warning"><i class="fa fa-times"></i>&nbsp;Message not sent due to Insufficient balance, <a href="https://login.beem.africa/#!/" target="_blank">purchase sms to proceed</a></div>';
        } else {
            $message .= '<div class="alert alert-success col-12">Message sent</div>';
            header("Refresh:2");
        }
    }
    // var_dump($response);
}

?>

<body oncontextmenu="return false" class="snippet-body">
    <div class="container d-flex justify-content-center">
        <div class="col-4 border-bottom text-center bg-light my-2">
            <a href="./" class="text-primary py-5">Dashboard</a>
        </div>
    </div>
    <div class="container">
        <?php
        echo $message;
        ?>
    </div>
    <div class="container d-flex justify-content-center mt-3">
        <div class="table-responsive">
            <table class="table table-striped table-bordered table-hover">
                <thead>
                    <tr>
                        <th scope="col">Order id</th>
                        <th scope="col">Ordered by</th>
                        <th scope="col">phone number</th>
                        <th scope="col">Location</th>
                        <th scope="col">Order date</th>
                        <th scope="col">Quantity Ordered</th>
                        <th scope="col">Amount remained</th>
                        <th scope="col">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <?php
                        $sql = pg_query($con, "SELECT concat(firstname,' ',sirname) as name, users.phone_number, order_date, address, ordered_quantity, order_id, to_be_paid
                                                FROM users, orders
                                                WHERE orders.user_id = users.id
                                                AND status_id = 1
                                                GROUP BY order_id,users.phone_number, order_date, address, ordered_quantity, order_id, name, to_be_paid
                                                ");
                        // die(mysqli_error($con));
                        if (pg_num_rows($sql) > 0) {
                            while ($row = pg_fetch_assoc($sql)) {
                        ?>
                                <td><a href=""><?= $row['order_id']; ?></a></td>
                                <td><?= $row['name']; ?></td>
                                <td><?= $row['phone_number']; ?></td>
                                <td><?= $row['address']; ?></td>
                                <td><?= $row['order_date']; ?></td>
                                <td><?= $row['ordered_quantity']; ?></td>
                                <td><?=$row['to_be_paid'];?></td>
                                <td>
                                    <form action="" method="post">
                                        <input type="text" name="tobe" value="<?= $row['to_be_paid']; ?>" hidden>
                                        <input type="text" name="phone" value="<?= $row['phone_number']; ?>" hidden>
                                        <input type="text" name="date" value="<?= $row['order_date']; ?>" hidden>
                                        <input type="text" name="name" value="<?= $row['name']; ?>" hidden>
                                        <button class="btn btn-sm btn-success" type="submit" name="inform">Inform</button>
                                    </form>
                                </td>
                    </tr>
            <?php
                            }
                        } else {
                            echo '<tr><td colspan="6">no available order made...!</td></tr>';
                        }
            ?>
                </tbody>
            </table>
        </div>
    </div>
    </div>
    <script type="text/javascript" src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
    <script type="text/javascript" src=""></script>
    <script type="text/javascript" src=""></script>
    <script type="text/Javascript"></script>
</body>

</html>