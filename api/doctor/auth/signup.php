<?php
require_once './auth_helper.php';
require_once "./dbConfig.php";
require_once './dbFunctions.php';
header('Access-Control-Allow-Origin: *');
session_start();
try {
    $dbh = new PDO("mysql:host=$hostname;dbname=$database", $username, $password);
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (\PDOException $err) {
    die("Couldn't connect to DB " . $err->getMessage());
}

//Received JSON into $json variable

//Decoding the received JSON and store into $obj variable.
// $result = [];
if (isset($_POST["email"]) && isset($_POST["password"]) && isset($_POST["name"])) {

    $email = $_POST['email'];
    $pwd = $_POST['pass'];
    $cpwd = $_POST['cpass'];
    $name = $_POST['name'];
    if ($cpwd !== $pwd) header('Location: ../../../doc_end/home', true);
    $sql = "SELECT * FROM doctors WHERE EMAIL = :email ;";

    $stmt =  $dbh->prepare($sql);
    $stmt->bindParam(':email', $email);
    $stmt->execute();
    $stmt->setFetchMode(PDO::FETCH_ASSOC);
    $res = $stmt->fetchAll();

    if (count($res) == 1) {
        header('Location: ../../../doc_end/error', true);
    } else {
        $insert = "INSERT INTO doctors(EMAIL,UPASS) VALUES( :email , :pwd )";
        $stmt =  $dbh->prepare($insert);
        $stmt->bindParam(':email', $email);
        $stmt->bindParam(':pwd', $pwd);
        $status = $stmt->execute();
        if ($status) {
            $uid = getUidOfThisUser($dbh, $email);
            if ($uid !== false) {
                $isCreated = createDataForUserWithUID($dbh, $uid, $name, $email);
                $user_data = getUserData($dbh, $uid);
                if ($isCreated !== false && $user_data !== false) {
                    $_SESSION['user_data'] = $user_data;
                    header('Location: ../../../doc_end/home', true);
                }
            }
            // $res['len']=strlen(bin2hex($key));
            // $res['gen_key']=bin2hex($genKey);
            // $res['dec_key']=bin2hex(getDecKey($key));
        } else {
            header('Location: ../../../doc_end/error', true);
        }
    }
    // echo json_encode($result);
} else {
    header('Location: ../../../doc_end/error', true);

    // echo json_encode($result);
}
