<?php 
include '../users/auth/dbConfig.php';

$uid = $_GET['uid'];

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=$database", $username, $password);
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (\PDOException $err) {
    die("Couldn't connect to DB " . $err->getMessage());
}

$result = [];

if(isset($uid)){
    $bookingArr = getBookingArray($dbh,$uid);
    $availArr = [];
    // print_r($bookingArr);
    foreach ($bookingArr as $date => $value) {
        $availTimeArr=array();
        if(strtotime($date) > time()){
            foreach ($value as $slot => $booked) {
                if(!$booked){
                    array_push($availTimeArr,$slot);
                }
            }
            $availArr[$date]= $availTimeArr;
        }
    }
    $result['available'] = $availArr;
}
else{
    $result['message'] = "error";
}
echo json_encode($result);

function getBookingArray(\PDO $dbh, string $id){
    $sql = "SELECT BOOKING FROM doc_data WHERE UID=:id;";
    $stmt =  $dbh->prepare($sql);
    $stmt->bindParam(':id', $id);
    $stmt->execute();
    $stmt->setFetchMode(PDO::FETCH_ASSOC);
    $res = $stmt->fetch();
    return json_decode($res['BOOKING'],true);
}


?>