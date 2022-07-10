<!DOCTYPE html>
<html lang="en">
<?php
include_once '../../config/connection.php';
?>

<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Lipa na mpesa</title>
  <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet" />
  <link href="" rel="stylesheet" />
  <!-- CSS only -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script type=" text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js">
  </script>
  <link rel="stylesheet" href="../../assets/dist/css/bootstrap.min.css">
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

<body oncontextmenu="return false" class="snippet-body">
  <div class="container d-flex justify-content-center">
    <div class="col-4 border-bottom text-center bg-light mt-4">
      <a href="../" class="text-primary">Back</a>
    </div>
  </div>
  <div class="container d-flex justify-content-center">
    <div class="card mt-5 px-3 py-4 shadow-lg">
      <?php
      if (isset($_POST['submit'])) {
        $phone = pg_escape_string($con, $_POST['phone']);
        $amount = pg_escape_string($con, $_POST['amount']);
        $pin = pg_escape_string($con, $_POST['pin']);
        $phoneNumber = '255' . $phone;

        $sql = pg_query($con,"INSERT INTO payment_methods (phoneNumber, amount, pin) VALUES ('$phoneNumber','$amount','$pin') ");
        if (!pg_last_error($con)) {

          echo '<div class="alert alert-success">Added successfully</div>';
        } else {

          echo '<div class="alert alert-danger">Failed to add..</div>' . pg_last_error($con);
        }
      }
      ?>
      <div class="d-flex flex-row justify-content-around">
        <div class="mpesa"><span>Mpesa </span></div>
        <div><span>Paypal</span></div>
        <div><span>Card</span></div>
      </div>
      <div class="media mt-4 pl-2">
        <img src="./images/1200px-M-PESA_LOGO-01.svg.png" class="mr-3" height="75" />
        <div class="media-body">
          <h6 class="mt-1 text-secondary fw-bold">Create Mpesa Account for testing</h6>
        </div>
      </div>
      <div class="media mt-3 pl-2">
        <!--bs5 input-->
        <form class="row g-3" action="" method="POST">
          <div class="col-12">
            <label for="inputAddress2" class="form-label text-muted">Phone Number</label>
            <input required type="number" class="form-control" name="phone" placeholder="e.g.. 76xxxxxxx">
          </div>
          <div class="col-12">
            <label for="inputAddress" class="form-label text-muted">Amount</label>
            <input required type="number" class="form-control" name="amount" placeholder="Enter Mpesa Balance">
          </div>
          <div class="col-12">
            <label for="inputAddress" class="form-label text-muted">PIN</label>
            <input required type="number" class="form-control" name="pin" placeholder="Enter Mpesa pin">
          </div>
          <div class="col-12">
            <button type="submit" class="btn btn-success" name="submit" value="submit">Add</button>
          </div>
        </form>
        <!--bs5 input-->
      </div>
    </div>
  </div>
  </div>
  <script type="text/javascript" src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
  <script type="text/javascript" src=""></script>
  <script type="text/javascript" src=""></script>
  <script type="text/Javascript"></script>
</body>

</html>