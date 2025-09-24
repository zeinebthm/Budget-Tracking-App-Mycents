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

header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $stmt = $pdo->query("SELECT * FROM categories");
    $categories = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode([
        "success" => true,
        "data" => $categories
    ]);


} 


elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);
    

    if (empty($data['name']) || !isset($data['budget']) || !is_numeric($data['budget'])) {
        http_response_code(400);
        die(json_encode(["success" => false, "message" => "Name und ein gültiges Budget sind erforderlich"]));
    }


    $stmt = $pdo->prepare("INSERT INTO categories (name, budget) VALUES (?, ?)");
    
    if ($stmt->execute([$data['name'], $data['budget']])) {
        echo json_encode([
            "success" => true,
            "message" => "Kategorie hinzugefügt",
            "id" => $pdo->lastInsertId()
        ]);
    } else {
        http_response_code(500);
        echo json_encode(["success" => false, "message" => "Datenbankfehler"]);
    }
}
elseif ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    $data = json_decode(file_get_contents("php://input"), true);
    
    if (empty($data['id'])) {
        http_response_code(400);
        die(json_encode(["success" => false, "message" => "Kategorie-ID erforderlich"]));
    }

    // Prüfen ob Kategorie in Verwendung ist
    $stmt = $pdo->prepare("SELECT COUNT(*) FROM budgets WHERE category_id = ?");
    $stmt->execute([$data['id']]);
    if ($stmt->fetchColumn() > 0) {
        http_response_code(400);
        die(json_encode(["success" => false, "message" => "Kategorie wird in Budgets verwendet"]));
    }

    $stmt = $pdo->prepare("DELETE FROM categories WHERE id = ?");
    $stmt->execute([$data['id']]);
    
    if ($stmt->rowCount() > 0) {
        echo json_encode(["success" => true, "message" => "Kategorie gelöscht"]);
    } else {
        http_response_code(404);
        echo json_encode(["success" => false, "message" => "Kategorie nicht gefunden"]);
    }
}
else {
    http_response_code(405);
    echo json_encode(["success" => false, "message" => "Methode nicht erlaubt"]);
}
?>