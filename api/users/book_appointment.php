<?php
include '../users/auth/dbConfig.php';
try {
    $dbh = new PDO("mysql:host=$hostname;dbname=$database", $username, $password);
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (\PDOException $err) {
    die("Couldn't connect to DB " . $err->getMessage());
}
$result = [];
$doc_id = $_GET['doc_id'];
$user_id = $_GET['user_id'];
$bk_date = $_GET['bk_date'];
$bk_time = $_GET['bk_time'];

if (isset($doc_id) && isset($bk_date) && isset($bk_time)) {
    $bookingArr = getBookingArray($dbh, $doc_id);
    if (isset($bookingArr[$bk_date][$bk_time])) {
        if (!$bookingArr[$bk_date][$bk_time]) {
            $bookingArr[$bk_date][$bk_time] = true;
            if (updateInDocDB($dbh, $doc_id, json_encode($bookingArr)) && putInBookingTable($dbh, 
            $user_id, $doc_id, $bk_date, $bk_time)) {
                $result['booking_status'] = true;
                $result['message'] = "booking successfull";
            } else {
                $result['booking_status'] = false;
                $result['message'] = "error";
            }
        } else {
            $result['booking_status'] = false;
            $result['message'] = "slot taken";
        }
    } else {
        $result['booking_status'] = false;
        $result['message'] = "slot unavailable";
    }
} else {
    $result['booking_status'] = false;
    $result['message'] = "error";
}
echo json_encode($result);

function getBookingArray(\PDO $dbh, string $id)
{
    $sql = "SELECT BOOKING FROM doc_data WHERE UID=:id;";
    $stmt =  $dbh->prepare($sql);
    $stmt->bindParam(':id', $id);
    $stmt->execute();
    $stmt->setFetchMode(PDO::FETCH_ASSOC);
    $res = $stmt->fetch();
    return json_decode($res['BOOKING'], true);
}

function updateInDocDB(\PDO $dbh, string $id, string $bookingData)
{
    $update = "UPDATE doc_data SET BOOKING = :bk_data WHERE UID = :id;";
    $stmt =  $dbh->prepare($update);
    $stmt->bindParam(':id', $id);
    $stmt->bindParam(':bk_data', $bookingData);
    return $stmt->execute();
}

function putInBookingTable(\PDO $dbh, string $user_id, string $doc_id, string $apt_date, string $apt_time)
{
    $insert = "INSERT INTO booking(doc_id , user_id , apt_date , apt_time , booked_at) VALUES( :doc_id , :user_id , :apt_date, :apt_time , :booked_at)";
    $stmt =  $dbh->prepare($insert);
    $tim = time();
    $stmt->bindParam(':doc_id', $doc_id);
    $stmt->bindParam(':user_id', $user_id);
    $stmt->bindParam(':apt_date', $apt_date);
    $stmt->bindParam(':apt_time', $apt_time);
    $stmt->bindParam(':booked_at', $tim);
    $res = $stmt->execute();
    return $res;
}
