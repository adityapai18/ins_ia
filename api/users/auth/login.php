<?php
require_once("./dbConfig.php");
require_once './dbFunctions.php';
require_once './auth_helper.php';
require_once './secure_keys.php';
header('Access-Control-Allow-Origin: *');
//MySQL database Connection

try {
  $dbh = new PDO("mysql:host=$hostname;dbname=$database", $username, $password);
  $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (\PDOException $err) {
  die("Couldn't connect to DB " . $err->getMessage());
}
// $con = mysqli_connect('localhost', 'root', '', 'mydoc_db');
//Received JSON into $json variable
$json = file_get_contents('php://input');

//Decoding the received JSON and store into $obj variable.
$obj = json_decode($json, true);
$result = [];
if (isset($obj["email"]) && isset($obj["password"])) {
  // $key = getDecryptedAuthKeyFromEmail($dbh,$obj["email"]);
  $email = $obj["email"];
  $pwd = decrypt_message($obj['password'], $enc_key);
  //Declare array variable
  //Select Query
  $sql = "SELECT * FROM users WHERE EMAIL=:email and UPASS=:pwd ;";
  $stmt =  $dbh->prepare($sql);
  $stmt->bindParam(':email', $email);
  $stmt->bindParam(':pwd', $pwd);
  $stmt->execute();
  $stmt->setFetchMode(PDO::FETCH_ASSOC);
  $res = $stmt->fetchAll();
  if (isset($res) && isset($res[0]) && count($res) == 1) {
    $user_data = getUserData($dbh, $res[0]["UID"]);
    if ($user_data !== false) {
      $isExists = checkKeyAlreadyExists($res[0]["USED_KEY"], $obj["password"],$dbh,$res[0]["UID"]);
      if ($isExists) {
        $result['loginStatus'] = false;
        $result['message'] = "creadentials unaccepted";
      } else {
        $resKey = generateAndUpdateKeyForUser($dbh, $user_data['UID']);
        $result['loginStatus'] = true;
        $result['message'] = "success";
        $result["user_data"] = $user_data;
        $result["token"] = $resKey;
      }
    } else {
      $result["user_data"] = null;
    }
  } else {

    $result['loginStatus'] = false;
    $result['message'] = "invalid";
  }
  // Converting the array into JSON format.
  $json_data = json_encode($result);

  // Echo the $json.
  echo $json_data;
} else {
  $result['message'] = "error";
  echo json_encode($result);
}
