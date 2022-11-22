<?php
require("./dbConfig.php");
require './dbFunctions.php';
require './auth_helper.php';
require './secure_keys.php';
// header('Access-Control-Allow-Origin: *');
//MySQL database Connection
session_start();
try {
  $dbh = new PDO("mysql:host=$hostname;dbname=$database", $username, $password);
  $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (\PDOException $err) {
  die("Couldn't connect to DB " . $err->getMessage());
}
// $con = mysqli_connect('localhost', 'root', '', 'mydoc_db');
//Received JSON into $json variable
// $json = file_get_contents('php://input');

//Decoding the received JSON and store into $obj variable.
// $_POST = json_decode($json, true);
$result = [];
if (isset($_POST["email"]) && isset($_POST["pass"])) {
  // $key = getDecryptedAuthKeyFromEmail($dbh,$_POST["email"]);
  $email = $_POST["email"];
  $pass = $_POST['pass'];
  $pwd = decrypt_message($pass, $enc_key);
  //Declare array variable
  //Select Query
  $pwd =  bin2hex($pwd);
  $sql = "SELECT * FROM doctors WHERE EMAIL=:email and UPASS=:pwd ;";
  $stmt =  $dbh->prepare($sql);
  $stmt->bindParam(':email', $email);
  $stmt->bindParam(':pwd', $pwd);
  $stmt->execute();
  $stmt->setFetchMode(PDO::FETCH_ASSOC);
  $res = $stmt->fetchAll();
  if (isset($res) && isset($res[0]) && count($res) == 1) {
    $user_data = getUserData($dbh, $res[0]["UID"]);
    if ($user_data !== false) {
      // $isExists = checkKeyAlreadyExists($res[0]["USED_KEY"], $_POST["password"],$dbh,$res[0]["UID"]);
      // $_SESSION['loginStatus'] = false;
      // $result['message'] = "creadentials unaccepted";
      // $resKey = generateAndUpdateKeyForUser($dbh, $user_data['UID']);
      // $result["token"] = $resKey;
      // $result['message'] = "success";
      $_SESSION['loginStatus'] = true;
      $_SESSION["user_data"] = $user_data;
      header('Location: ../../../doc_end/home/static', true);

    } else {
      $_SESSION["user_data"] = null;

      header('Location: ../../../doc_end/home/static', true);
    }
  } else {

    $_SESSION['loginStatus'] = false;
    $result['message'] = "invalid";
    header('Location: ../../../doc_end/error', true);

  }
  // Converting the array into JSON format.
  $json_data = json_encode($result);

  // Echo the $json.
  echo $json_data;
} else {
  $result['message'] = "error";
  echo json_encode($result);
  header('Location: ../../../doc_end/error', true);
}
