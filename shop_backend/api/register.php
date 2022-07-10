<?php
include_once '../config/connection.php';
include_once '../json_format.php';

$response  = [];

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (!empty($_POST)) {
        $firstname = pg_escape_string($con, $_POST['firstname']);
        $sirname = pg_escape_string($con, $_POST['sirname']);
        $phone = pg_escape_string($con, $_POST['phone_number']);
        $password = pg_escape_string($con, $_POST['password']);
        // $pass = sha1($password);
        $role = 3;
        $address = pg_escape_string($con, $_POST['address']);
        $joinedOn = date("d-m-Y, H:i:s");

        $sql = pg_query($con, "INSERT INTO users (firstname, sirname, phone_number, address, password,joined_on, role_id ) 
                            VALUES ('" . $firstname . "', '" . $sirname . "', '" . $phone . "','" . $address . "', '" . $password . "', '" . $joinedOn . "', '" . $role . "')");
        if (!pg_last_error($con)) {
            $response['status'] = "OK";
            $response['message'] = "Registered successfully";
        } else {
            $response['status'] = "Error";
            // $response['message'] = "Failed to register, Try again" . mysqli_error($con);
            $response['message'] = "Failed to register";
        }
    }
} else {
    $response['status'] = 'Error';
    $response['message'] = 'Invalid request method';
}

echo json_encode($response);
