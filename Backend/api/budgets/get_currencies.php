<?php
header("Access-control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
// get_currencies.php
header('Content-Type: application/json');

// Beispiel: Währungen aus Datenbank oder Array
$currencies = [
    ['code' => 'EUR', 'name' => 'Euro'],
    ['code' => 'USD', 'name' => 'US-Dollar'],
    ['code' => 'CHF', 'name' => 'Schweizer Franken'],
    // Weitere Währungen...
];

echo json_encode($currencies);
?>