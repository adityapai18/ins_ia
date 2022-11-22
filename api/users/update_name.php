<?php
include '../users/auth/dbFunctions.php';
include '../users/auth/dbConfig.php';
try {
    $dbh = new PDO("mysql:host=$hostname;dbname=$database", $username, $password);
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (\PDOException $err) {
    die("Couldn't connect to DB " . $err->getMessage());
}
$result = [];
$email = $_POST['email'];
$name = $_POST['name'];
if (isset($email) && isset($name)) {
    $update = "UPDATE user_data SET NAME = :uname WHERE EMAIL = :email;";
    $stmt =  $dbh->prepare($update);
    $stmt->bindParam(':uname', $name);
    $stmt->bindParam(':email', $email);
    $stmt->execute();
    $result['user_data'] = getUserDataFromEmail($dbh, $email);
    $result['message'] = 'success';
    echo json_encode($result);
} else {
    $result['message'] = "error";
    echo json_encode($result);
}
