<?php

if (isset($_SERVER['HTTP_ORIGIN'])) {
    header("Access-Control-Allow-Origin: {$_SERVER['HTTP_ORIGIN']}");
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Max-Age: 86400');
}
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_METHOD']))
        header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
    if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']))
        header("Access-Control-Allow-Headers: {$_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']}");
    exit(0);
}


require_once __DIR__ . '/../../config/db.php';


header("Content-Type: application/json");

$data = json_decode(file_get_contents("php://input"), true);

if (empty($data['email']) || empty($data['password'])) {
    http_response_code(400);
    die(json_encode(["success" => false, "message" => "E-Mail und Passwort sind erforderlich"]));
}

$email = $data['email'];
$password = $data['password'];


$stmt = $pdo->prepare("SELECT id FROM users WHERE email = ?");
$stmt->execute([$email]);
if ($stmt->fetch()) {
    http_response_code(409);
    die(json_encode(["success" => false, "message" => "Diese E-Mail-Adresse wird bereits verwendet"]));
}

$hashed_password = password_hash($password, PASSWORD_DEFAULT);

try {
    $stmt = $pdo->prepare("INSERT INTO users (email, password) VALUES (?, ?)");
    $stmt->execute([$email, $hashed_password]);
    
    echo json_encode(["success" => true, "message" => "Benutzerkonto erfolgreich erstellt"]);

} catch (PDOException $e) {
    http_response_code(500); 
    echo json_encode(["success" => false, "message" => "Registrierung fehlgeschlagen: Serverfehler"]);
}
?>