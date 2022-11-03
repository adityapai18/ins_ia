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
    return decrypt_message($var,$enc_key);
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
    $iv = substr($ivHashCiphertext, 0, 16);
    $hash = substr($ivHashCiphertext, 16, 32);
    $ciphertext = substr($ivHashCiphertext, 48);

    if (!hash_equals(hash_hmac('sha256', $ciphertext . $iv, $key, true), $hash)) return null;

    return openssl_decrypt($ciphertext, $method, $key, OPENSSL_RAW_DATA, $iv);
    // return strlen($ciphertext);
}
