<?php
require_once 'db.php';  // Da beide Dateien im gleichen Ordner liegen, sollte der relative Pfad einfach 'db.php' sein.

try {
    // Teste die Verbindung zur Datenbank
    $pdo->query("SELECT 1");  // Einfache SQL-Anweisung zum Testen der Verbindung
    echo "Verbindung zur Datenbank erfolgreich!";
} catch (PDOException $e) {
    // Wenn ein Fehler auftritt, gib die Fehlermeldung aus
    echo "Verbindung fehlgeschlagen: " . $e->getMessage();
}
?>
