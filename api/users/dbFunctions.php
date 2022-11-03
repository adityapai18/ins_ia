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
function createDataForUserWithUID(\PDO $dbh, string $uid , string $name , string $email)
{
    $insert = "INSERT INTO user_data(UID, NAME , EMAIL) VALUES( :uid , :name , :email)";
    $stmt =  $dbh->prepare($insert);
    $stmt->bindParam(':email', $email);
    $stmt->bindParam(':uid', $uid);
    $stmt->bindParam(':name', $name);
    $res = $stmt->execute();
    return $res;
}
function getUserData(\PDO $dbh, string $uid){
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
