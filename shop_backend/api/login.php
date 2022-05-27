<?php
include_once '../config/connection.php';
include_once '../json_format.php';

$response = [];

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    if (!empty($_POST)) {
        $phone = mysqli_real_escape_string($con, $_POST['phone_number']);
        $password = mysqli_real_escape_string($con, $_POST['password']);
        $pass = sha1($password);

        $sql = "SELECT users.id as id, firstname, role_type, phone_number, sirname FROM users, roles
                    WHERE password = '" . $pass . "' 
                    AND phone_number = '" . $phone . "' 
                    AND users.role_id = roles.id";
        $query = mysqli_query($con, $sql);

        if (mysqli_error($con)) {
            $response['status'] = "Error";
            $response['message'] = "Error occured => " . mysqli_error($con);
        } else {

            if (mysqli_num_rows($query) == 1) {
                $user_details = mysqli_fetch_assoc($query);
                $response['status'] = "OK";
                $response['message'] = "umefanikiwa kuigia, karibu";
                $id = $user_details['id'];
                $role = $user_details['role_type'];
                $name = $user_details['firstname'];
                $phoneNumber = $user_details['phone_number'];
                $lastname = $user_details['sirname'];

                $response['data'] = ['id' => $id, 'firstname' => $name, 'role' => $role, 'phone_number' => $phoneNumber, 'sirname' => $lastname];
            } else {
                $response['status'] = "Error";
                $response['message'] = "Maingizo siyo sahihi, jaribu tena";
            }
        }
    }
} else {
    $response['status'] = 'Error';
    $response['message'] = 'Invalid request method';
}

echo json_encode($response);
