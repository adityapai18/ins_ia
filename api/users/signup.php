<?php
require_once './auth_helper.php';
require_once "./dbConfig.php" ;
require_once './dbFunctions.php';
header('Access-Control-Allow-Origin: *');

try {
    $dbh = new PDO("mysql:host=$hostname;dbname=$database", $username, $password);
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (\PDOException $err) {
    die("Couldn't connect to DB " . $err->getMessage());
}

//Received JSON into $json variable
$json = file_get_contents('php://input');

//Decoding the received JSON and store into $obj variable.
$obj = json_decode($json, true);
$result = [];
if (isset($obj["email"]) && isset($obj["password"]) && isset($obj["name"])) {

    $email = $obj['email'];
    $pwd = $obj['password'];
    $name = $obj['name'];
    $sql = "SELECT * FROM users WHERE EMAIL = :email ;";

    $stmt =  $dbh->prepare($sql);
    $stmt->bindParam(':email', $email);
    $stmt->execute();
    $stmt->setFetchMode(PDO::FETCH_ASSOC);
    $res = $stmt->fetchAll();

    if (count($res) == 1) {
        $result['message'] = "error";
    } else {
        $genKey = generateRandomKey();
        $key = getAuthKey($genKey);
        $hexKey = bin2hex($key);
        $insert = "INSERT INTO users(EMAIL,UPASS,AUTH_KEY) VALUES( :email , :pwd , :key )";
        $stmt =  $dbh->prepare($insert);
        $stmt->bindParam(':email', $email);
        $stmt->bindParam(':pwd', $pwd);
        $stmt->bindParam(':key', $hexKey);
        $status = $stmt->execute();

        if ($status) {
            $uid = getUidOfThisUser($dbh, $email);
            if ($uid !== false) {
                $isCreated = createDataForUserWithUID($dbh, $uid, $name, $email);
                $user_data= getUserData($dbh,$uid);
                if ($isCreated !== false && $user_data !==false) {
                    $result['message'] = "success";
                    $result['token'] = $hexKey;
                    $result['user_data'] = $user_data;
                }
            }
            // $res['len']=strlen(bin2hex($key));
            // $res['gen_key']=bin2hex($genKey);
            // $res['dec_key']=bin2hex(getDecKey($key));
        } else {
            $result['message'] = "error";
        }
    }
    echo json_encode($result);
} else {
    $result['message'] = "error";
    echo json_encode($result);
}
