<?php
include_once '../config/connection.php';
include_once '../json_format.php';
// session_start();

$response = [];

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    if (!empty($_FILES)) {

        $path = "../assets/uploaded_products/";
        $name = mysqli_real_escape_string($con, $_POST['product_name']);
        $description = mysqli_escape_string($con, $_POST['description']);
        $price = mysqli_real_escape_string($con, $_POST['price']);
        $quantity = mysqli_real_escape_string($con, $_POST['quantity']);
        // $photo = mysqli_real_escape_string($con, $_POST['product_photo']);
        // $category_id = mysqli_real_escape_string($con, $_POST['category_id']);
        $filename = basename($_FILES['product_photo']['name']);
        $filepath = $path . $filename;
        $filetype = pathinfo($filepath, PATHINFO_EXTENSION);
        // $id = $_SESSION['id'];

        if (!empty($_POST)) {
            //checking the format of a file
            $format = array('jpg', 'jpeg', 'png');
            if (in_array($filetype, $format)) {

                $tmpname = $_FILES['product_photo']['tmp_name'];

                //inserting data into a database
                if (move_uploaded_file($tmpname, $filepath)) {

                    $sql = "INSERT INTO products (product_name, description, price, quantity, product_photo, category_id, user_id)
                            VALUES ('$name', '$description', '$price', '$quantity', '$filename', 1, 1)";
                    $result = mysqli_query($con, $sql);

                    if (!mysqli_error($con)) {
                        $response['status'] = "OK";
                        $response['message'] = "Product Posted Successfully..!";
                    } else {
                        $response['status'] = "Error";
                        $response['message'] = "Fail to post => " . mysqli_error($con);
                    }
                } else {

                    $response['status'] = "Error";
                    $response['message'] = "Error occured on posting";
                }
            } else {
                $response['status'] = "Error";
                $response['message'] = "Make Sure You post photo in (jpg, png, jpeg) formats..!";
            }
        } else {
            $response['status'] = "Warning";
            $response['message'] = "Select a file to upload";
        }
    }
} else {
    $response['status'] = "Error";
    $response['message'] = "Invalid request method";
}

echo json_encode($response);
