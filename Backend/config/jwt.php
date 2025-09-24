<?php
require_once __DIR__ . '/../vendor/autoload.php';
use Firebase\JWT\JWT;
use Firebase\JWT\Key;

$secret_key = "dein_geheimer_schlüssel";

function generateJWT($user_id) {
    global $secret_key;
    $payload = [
        "iss" => "http://localhost",
        "iat" => time(),
        "exp" => time() + 3600,
        "sub" => $user_id
    ];
    return JWT::encode($payload, $secret_key, 'HS256');
}

function validateJWT($token) {
    global $secret_key;
    try {
        return JWT::decode($token, new Key($secret_key, 'HS256'));
    } catch (Exception $e) {
        return false;
    }
}
?>