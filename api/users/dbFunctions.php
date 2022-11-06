<?php
function getUidOfThisUser(\PDO $dbh, string $email)
{
    $sql = "SELECT * FROM users WHERE EMAIL = :email ;";
    $stmt =  $dbh->prepare($sql);
    $stmt->bindParam(':email', $email);
    $stmt->execute();
    $stmt->setFetchMode(PDO::FETCH_ASSOC);
    $res = $stmt->fetchAll();
    if (isset($res) && isset($res[0]) && count($res) == 1) {
        return $res[0]["UID"];
    }
    return false;
}
function createDataForUserWithUID(\PDO $dbh, string $uid, string $name, string $email)
{
    $insert = "INSERT INTO user_data(UID, NAME , EMAIL) VALUES( :uid , :name , :email)";
    $stmt =  $dbh->prepare($insert);
    $stmt->bindParam(':email', $email);
    $stmt->bindParam(':uid', $uid);
    $stmt->bindParam(':name', $name);
    $res = $stmt->execute();
    return $res;
}
function getUserData(\PDO $dbh, string $uid)
{
    $sql = "SELECT * FROM user_data WHERE UID = :id ;";
    $stmt =  $dbh->prepare($sql);
    $stmt->bindParam(':id', $uid);
    $stmt->execute();
    $stmt->setFetchMode(PDO::FETCH_ASSOC);
    $res = $stmt->fetchAll();
    if (isset($res) && isset($res[0]) && count($res) == 1) {
        return $res[0];
    }
    return false;
}
function getDecryptedAuthKeyFromEmail(\PDO $dbh, string $email)
{
    require_once "./auth_helper.php";
    $sql = "SELECT * FROM users WHERE EMAIL = :email ;";
    $stmt =  $dbh->prepare($sql);
    $stmt->bindParam(':email', $email);
    $stmt->execute();
    $stmt->setFetchMode(PDO::FETCH_ASSOC);
    $res = $stmt->fetchAll();
    return getDecKey($res[0]["AUTH_KEY"]);
}
function generateAndUpdateKeyForUser(\PDO $dbh, string $uid)
{
    $genKey = generateRandomKey();
    $key = getAuthKey($genKey);
    $hexKey = bin2hex($key);
    $update = "UPDATE users SET AUTH_KEY = :key WHERE UID = $uid;";
    $stmt =  $dbh->prepare($update);
    $stmt->bindParam(':key', $hexKey);
    $stmt->execute();
    return $hexKey;
}
function checkKeyAlreadyExists(string $keyArr, string $currKey, \PDO $dbh, string $uid)
{
    $hashedKey = hash('sha256', $currKey);
    $arr = json_decode($keyArr,true);
    if (!isset($arr) || !in_array($hashedKey, $arr)) {
        if(!isset($arr)){
            $arr = array();
        }
        array_push($arr, $hashedKey);
        $arr = json_encode($arr);
        $update = "UPDATE users SET USED_KEY = :key WHERE UID = $uid;";
        $stmt =  $dbh->prepare($update);
        $stmt->bindParam(':key', $arr);
        $stmt->execute();
        return false;
    }
    return true;
}
