<?php

function generateRandomKey()
{
    return bin2hex(random_bytes(32));
}

function getAuthKey(string $var){
    require "./secure_keys.php";
    return encrypt_message($var,$enc_key);
}

function getDecKey(string $var){
    require "./secure_keys.php";
    return decrypt_key_in_db($var,$enc_key);
}
function encrypt_message(string $plaintext, string $key)
{
    $method = "AES-256-CBC";
    $ivlen = openssl_cipher_iv_length($method);
    $iv = openssl_random_pseudo_bytes($ivlen);
    $ciphertext = openssl_encrypt($plaintext, $method, $key, OPENSSL_RAW_DATA, $iv);
    $hash = hash_hmac('sha256', $ciphertext . $iv, $key, true);

    return $iv . $hash . $ciphertext;
}
function decrypt_message(string $ivHashCiphertext, string $key)
{   
    $method = "AES-256-CBC";
    $iv = substr($ivHashCiphertext, 0, 32);
    $hash = substr($ivHashCiphertext, 32, 64);
    $ciphertext = substr($ivHashCiphertext, 96);
    // print_r(bin2hex($ciphertext. $iv));
    if (!hash_equals(hash_hmac('sha256', hex2bin($iv . $ciphertext) , $key), $hash)) return null;

    return openssl_decrypt(hex2bin($ciphertext), $method, $key, OPENSSL_RAW_DATA, hex2bin($iv));
    // return strlen($ciphertext);
}
function decrypt_key_in_db(string $ivHashCiphertext, string $key)
{   
    $method = "AES-256-CBC";
    $iv = substr($ivHashCiphertext, 0, 32);
    $hash = substr($ivHashCiphertext, 32, 64);
    $ciphertext = substr($ivHashCiphertext, 96);
    // print_r($ciphertext. $iv . '\n');
    if (!hash_equals(hash_hmac('sha256', hex2bin($ciphertext . $iv) , $key), $hash)) return null;

    return openssl_decrypt(hex2bin($ciphertext), $method, $key, OPENSSL_RAW_DATA, hex2bin($iv));
    // return strlen($ciphertext);
}
function decrypt_message_oauth(string $ivHashCiphertext, string $key)
{   
    $method = "AES-256-CBC";
    $iv = substr($ivHashCiphertext, 0, 32);
    $hash = substr($ivHashCiphertext, 32, 64);
    $ciphertext = substr($ivHashCiphertext, 96);
    // print_r( $iv  . $ciphertext. "\n");
    // print_r(hash_hmac('sha256', hex2bin($iv . $ciphertext), $key));
    // print_r("\n");
    // print_r($hash);
    if (!hash_equals(hash_hmac('sha256', hex2bin($iv . $ciphertext) , $key), $hash)) return null;

    return openssl_decrypt(hex2bin($ciphertext), $method, $key, OPENSSL_RAW_DATA, hex2bin($iv));
    // return strlen($ciphertext);
}