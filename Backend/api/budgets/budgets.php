<?php

if (isset($_SERVER['HTTP_ORIGIN'])) {
    header("Access-Control-Allow-Origin: {$_SERVER['HTTP_ORIGIN']}");
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Max-Age: 86400');
}
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_METHOD'])) {
        header("Access-Control-Allow-Methods: GET, POST, OPTIONS, PUT, DELETE");
    }
    if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS'])) {
        header("Access-Control-Allow-Headers: {$_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']}");
    }
    exit(0);
}


require_once __DIR__ . '/../../config/db.php';
require_once __DIR__ . '/../../config/jwt.php';

header("Content-Type: application/json");


function berechneSaldo($pdo, $user_id) {
    $stmt = $pdo->prepare("SELECT type, amount FROM budgets WHERE user_id = ?");
    $stmt->execute([$user_id]);
    $saldo = 0;
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $amount = (float)$row['amount'];
        $saldo += ($row['type'] === 'income') ? $amount : -$amount;
    }
    return number_format($saldo, 2, '.', '');
}


$headers = getallheaders();
$token = str_replace('Bearer ', '', $headers['Authorization'] ?? '');
$user_id = validateJWT($token)->sub ?? null;
if (!$user_id) {
    http_response_code(401);
    die(json_encode(["message" => "Nicht autorisiert"]));
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {

    $year = $_GET['year'] ?? date('Y');
    $month = $_GET['month'] ?? date('m');

    $sql = "SELECT * FROM budgets WHERE user_id = ? AND YEAR(date) = ? AND MONTH(date) = ?";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$user_id, $year, $month]);
    $budgets = $stmt->fetchAll(PDO::FETCH_ASSOC);

    $saldo = berechneSaldo($pdo, $user_id); 
    
    echo json_encode([
        'success' => true,
        'data' => [
            'budgets' => $budgets,
            'saldo' => $saldo
        ]
    ]);
} 


elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);
    
    // On vérifie maintenant aussi le champ 'name'
    if (empty($data['name']) || empty($data['category_id']) || empty($data['amount']) || empty($data['type'])) {
        http_response_code(400);
        die(json_encode(["success" => false, "message" => "Name, category_id, amount und type sind erforderlich"]));
    }

    // On ajoute 'name' à la requête d'insertion
    $stmt = $pdo->prepare("INSERT INTO budgets (user_id, name, category_id, amount, type) VALUES (?, ?, ?, ?, ?)");
    if ($stmt->execute([$user_id, $data['name'], $data['category_id'], $data['amount'], $data['type']])) {
        echo json_encode(["success" => true, "message" => "Budget hinzugefügt"]);
    } else {
        http_response_code(500);
        echo json_encode(["success" => false, "message" => "Datenbankfehler"]);
    }
}
?>