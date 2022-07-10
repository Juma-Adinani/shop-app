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

<body oncontextmenu="return false" class="snippet-body">
    <div class="container d-flex justify-content-center">
        <div class="col-4 border-bottom text-center bg-light mt-4">
            <a href="./" class="text-primary">Dashboard</a>
        </div>
    </div>
    <div class="container d-flex justify-content-center">
        <div class="card mt-5 px-3 py-4 shadow-sm w-75">
            <?php
            if (isset($_FILES['photo'])) {
                $path = "../assets/uploaded_products/";
                $filename = basename($_FILES['photo']['name']);
                $filepath = $path . $filename;
                $filetype = pathinfo($filepath, PATHINFO_EXTENSION);
                $name = pg_escape_string($con, $_POST['product']);
                $description = pg_escape_string($con, $_POST['description']);
                $price = pg_escape_string($con, $_POST['price']);
                $quantity = pg_escape_string($con, $_POST['quantity']);
                $category = pg_escape_string($con, $_POST['category']);
                $postedOn = date("d-m-Y, H:i:s");

                if (isset($_POST['post'])) {
                    //checking the format of a file
                    $format = array('jpg', 'jpeg', 'png');
                    if (in_array($filetype, $format)) {

                        $tmpname = $_FILES['photo']['tmp_name'];

                        //inserting data into a database
                        if (move_uploaded_file($tmpname, $filepath)) {

                            $sql = pg_query($con, "INSERT INTO products(product_name, description, price, quantity, product_photo, posted_on, category_id, user_id ) 
                                                VALUES ('$name', '$description','$price','$quantity','$filename','$postedOn','$category', 1)");

                            if (!pg_last_error($con)) {
                                echo '<center class="alert alert-success">Product posted successfully</center>';
                                header("Refresh:3;");
                            } else {
                                echo '<center class="alert alert-danger">There is an error!..</center>';
                                die(pg_last_error($con));
                            }
                        } else {
                            echo '<center class="alert alert-danger">Error on uploading a photo.!</center>';
                        }
                    } else {
                        echo '<center class="alert alert-danger">Make Sure You post photo in (jpg, png, jpeg) formats..!</center>';
                    }
                } else {
                    echo "<div class='alert alert-warning'><strong>Select a file to upload!</strong></div>";
                }
            }
            ?>
            <div class="media mt-4 pl-2">
                <div class="media-body">
                    <h6 class="mt-1 h4 text-secondary fw-bold text-center">Post Products</h6>
                </div>
            </div>
            <div class="media mt-3 pl-2 d-flex justify-content-center">
                <!--bs5 input-->
                <form class="row g-3" action="" method="POST" enctype="multipart/form-data">
                    <div class="col-6">
                        <label for="product" class="form-label text-muted">Name</label>
                        <input required type="text" class="form-control" name="product" placeholder="Enter a product name">
                    </div>
                    <div class="col-6">
                        <label for="description" class="form-label text-muted">Description</label>
                        <input required type="text" class="form-control" name="description" placeholder="Enter product description">
                    </div>
                    <div class="col-6">
                        <label for="price" class="form-label text-muted">Price</label>
                        <input required type="number" class="form-control" name="price" placeholder="Enter product price">
                    </div>
                    <div class="col-6">
                        <label for="quantity" class="form-label text-muted">Quantity</label>
                        <input required type="number" class="form-control" name="quantity" placeholder="Enter product quantity">
                    </div>
                    <div class="col-6">
                        <label for="category" class="form-label text-muted">Category</label>
                        <select required name="category" id="category" class="form-control">
                            <option value="">choose category...</option>
                            <?php
                            $sql = pg_query($con, "SELECT * FROM product_categories");
                            while ($row = pg_fetch_assoc($sql)) {
                            ?>
                                <option value="<?php echo $row['id']; ?>"><?php echo $row['category_name']; ?></option>
                            <?php
                            }
                            ?>
                        </select>
                    </div>
                    <div class="col-6">
                        <label for="photo" class="form-label text-muted">Product Photo</label>
                        <input required type="file" class="form-control" name="photo" placeholder="Enter product photo">
                    </div>
                    <div class="col-12 d-flex justify-content-end">
                        <button type="submit" class="btn btn-success w-25" name="post">Post</button>
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