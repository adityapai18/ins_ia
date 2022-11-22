<?php
$filename = tempnam('../../bucket/images', '');
unlink($filename);
$result = [];

try {
    $dbh = new PDO("mysql:host=localhost;dbname=mydoc_db", 'root', '');
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (\PDOException $err) {
    die("Couldn't connect to DB " . $err->getMessage());
}

function updateFileForEmail(\PDO $dbh, string $email , string $file)
{
    $update = "UPDATE user_data SET IMG_URL = :img WHERE EMAIL = :email;";
    $stmt =  $dbh->prepare($update);
    $stmt->bindParam(':img', $file);
    $stmt->bindParam(':email', $email);
    $res = $stmt->execute();
    return $res;
}

if (isset($_POST["image"])) {
    $base64_string = $_POST["image"];
    if (str_contains($_POST["type"], 'png')) $outputfile = str_replace('.tmp', '.png', $filename);
    if (str_contains($_POST["type"], 'jpg')) $outputfile = str_replace('.tmp', '.jpg', $filename);
    if (str_contains($_POST["type"], 'jpeg')) $outputfile = str_replace('.tmp', '.jpeg', $filename);
    //save as image.jpg in uploads/ folder

    $filehandler = fopen($outputfile, 'wb');
    //file open with "w" mode treat as text file
    //file open with "wb" mode treat as binary file

    fwrite($filehandler, base64_decode($base64_string));
    // we could add validation here with ensuring count($data)>1

    // clean up the file resource
    fclose($filehandler);
    if (updateFileForEmail($dbh,$_POST["email"],basename($outputfile))) {
        $result["error"] = false;
        $result["msg"] =  "Image Uploaded";
        $result["img_url"]= basename($outputfile);
    }else{
        $result["error"] = true;
        $result["msg"] =  "No image is submited.";
    }
    
} else {
    $result["error"] = true;
    $result["msg"] =  "No image is submited.";
}

header('Content-Type: application/json');
// tell browser that its a json data
echo json_encode($result);
