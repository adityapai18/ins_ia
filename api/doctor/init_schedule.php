<?php
require_once './auth/dbConfig.php';
try {
    $dbh = new PDO("mysql:host=$hostname;dbname=$database", $username, $password);
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (\PDOException $err) {
    die("Couldn't connect to DB " . $err->getMessage());
}

$result = [];
if (isset($_POST['date']) && isset($_POST['startTime']) && isset($_POST['endTime']) && isset($_POST['email'])) {
    $startTime = $_POST['startTime'];
    $endTime = $_POST['endTime'];
    $date = $_POST['date'];
    $email = $_POST['email'];
    $schedule[$date] = array();
    for ($i = intval($startTime); $i < $endTime; $i++) {
        $slotArray[$i] = false;
    }
    $schedule=getBookingArray($dbh , $email);
    // print_r($schedule);
    $schedule[$date] = $slotArray;
    $scheduleJson = json_encode($schedule);
    $update = "UPDATE doc_data SET BOOKING = :bk WHERE EMAIL = :email;";
    $stmt =  $dbh->prepare($update);
    $stmt->bindParam(':bk', $scheduleJson);
    $stmt->bindParam(':email', $email);
    $status = $stmt->execute();
    if ($status)
        $result['message'] = 'success';
} else {
    $result['message'] = "error";
}
echo json_encode($result);


function getBookingArray(\PDO $dbh, string $email){
    $sql = "SELECT BOOKING FROM doc_data WHERE EMAIL=:email;";
    $stmt =  $dbh->prepare($sql);
    $stmt->bindParam(':email', $email);
    $stmt->execute();
    $stmt->setFetchMode(PDO::FETCH_ASSOC);
    $res = $stmt->fetch();
    return json_decode($res['BOOKING'],true);
}