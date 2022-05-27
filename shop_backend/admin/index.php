<?php

include_once '../config/connection.php';

$sql = $con->query("SELECT count(*) as count FROM orders");
$orders = mysqli_fetch_assoc($sql)['count'];

$sql = $con->query("SELECT count(*) as count FROM products");
$products = mysqli_fetch_assoc($sql)['count'];

$sql = $con->query("SELECT count(*) as count FROM users WHERE id != 1");
$users = mysqli_fetch_assoc($sql)['count'];

?>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>AShopie Shop | Smart and easy way to shop</title>
  <link href="../assets/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="d-flex flex-column vh-100 bg-light">
  <section>
    <!-- <nav class="navbar navbar-expand-lg navbar-light bg-white">
      <div class="container">
        <a class="navbar-brand" href="">
          <h4 class="h3 text-muted"><span style="color:orange;">UNI</span><span style="color: teal;">OAS</span></h4>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
          <ul class="navbar-nav me-auto mb-2 w-100 d-flex justify-content-end">
            <li class="" style="margin-right: 50px">
              <a class="nav-link" href="../homepage/">
                Home
              </a>
            </li>
            <li class="" style="margin-right: 50px">
              <a class="nav-link" href="../logout.php">
                logout
              </a>
            </li>
          </ul>
        </div>
      </div>
    </nav> -->
    <main>
      <article class="text-center container py-3">
        <div class="row">
          <div class="col-lg-6 col-md-8 mx-auto">
            <h1 class="h3 fw-light text-muted">DASHBOARD</h1>
          </div>
        </div>
      </article>
      <div class="album">
        <div class="container">
          <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-3">
            <div class="col">
              <div class="card shadow">
                <div class="card-body text-center text-light bg-dark">
                  <div class="mt-4">
                    <h1><?php echo $users; ?></h1>
                  </div>
                  <h3 class="card-title">Watumiaji</h3>
                  <div class="btn-group mt-2">
                    <a href="./users.php" class="btn btn-sm btn-outline-light">
                      open
                    </a>
                  </div>
                </div>
              </div>
            </div>
            <div class="col">
              <div class="card shadow">
                <div class="card-body text-center text-light" style="background: #17a2b8;">
                  <div class="mt-4">
                    <h1><?php echo $orders; ?></h1>
                  </div>
                  <h3 class="card-title">Oda</h3>
                  <div class="btn-group mt-2">
                    <a href="./orders.php" class="btn btn-sm btn-outline-light">
                      open
                    </a>
                  </div>
                </div>
              </div>
            </div>
            <div class="col">
              <div class="card shadow">
                <div class="card-body text-center text-light bg-secondary">
                  <div class="mt-4">
                    <h1><?php echo $products; ?></h1>
                  </div>
                  <h3 class="card-title">Bidhaa</h3>
                  <div class="btn-group mt-2">
                    <a href="./products.php" class="btn btn-sm btn-outline-light">
                      open
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="mt-5">
            <a href="./Mpesa/">Add mpesa numbers</a>
          </div>
        </div>
      </div>
    </main>
  </section>
  <footer class="text-muted mb-2 mt-auto">
    <div class="container">
      <p class="float-end mb-1">
        <a href="#">Back to top</a>
      </p>
      <p class="text-muted mt-3">All Rights Reserved. &copy; <?php echo date("Y"); ?>, Ashopie shop</p>
    </div>
  </footer>
  <script src="../assets/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>