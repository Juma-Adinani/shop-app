<?php
include_once '../config/connection.php';
include_once '../json_format.php';

$response  = [];

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (!empty($_POST)) {
        $firstname = mysqli_real_escape_string($con, $_POST['firstname']);
        $sirname = mysqli_real_escape_string($con, $_POST['sirname']);
        $phone = mysqli_real_escape_string($con, $_POST['phone_number']);
        $password = mysqli_real_escape_string($con, $_POST['password']);
        $pass = sha1($password);
        $role = 3;
        $address = '';

        $sql = $con->query("INSERT INTO users (firstname, sirname, phone_number, address, password, role_id ) 
                            VALUES ('" . $firstname . "', '" . $sirname . "', '" . $phone . "', '" . $address . "', '" . $pass . "', '" . $role . "')");
        if (!mysqli_error($con)) {
            $response['status'] = "OK";
            $response['message'] = "Umejisajili kikamilifu";
        } else {
            $response['status'] = "Error";
            // $response['message'] = "Failed to register, Try again" . mysqli_error($con);
            $response['message'] = "Umeshindwa kujisajili, jaribu tena";
        }
    }
} else {
    $response['status'] = 'Error';
    $response['message'] = 'Invalid request method';
}

echo json_encode($response);
