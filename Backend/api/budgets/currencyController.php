<?php
header("Access-control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Datenbankverbindung herstellen
$host = 'localhost';
$dbname = 'budget_app';
$username = 'root';
$password = '';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Datenbankverbindung fehlgeschlagen: " . $e->getMessage());
}

// Header für CORS
header('Access-Control-Allow-Origin: *');
header('Content-Type: text/html; charset=UTF-8');

// Prüfen, ob API-Aufruf für Währungen
if (isset($_GET['action']) && $_GET['action'] === 'get_currencies') {
    getCurrencies();
    exit;
}

// Prüfen, ob Formular abgeschickt wurde
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    createBudget();
    exit;
}

// HTML Formular anzeigen
showForm();

function getCurrencies() {
    header('Content-Type: application/json');
    
    $currencies = [
        ['code' => 'EUR', 'name' => 'Euro'],
        ['code' => 'USD', 'name' => 'US-Dollar'],
        ['code' => 'CHF', 'name' => 'Schweizer Franken'],
        ['code' => 'GBP', 'name' => 'Britisches Pfund'],
        ['code' => 'JPY', 'name' => 'Japanischer Yen'],
        ['code' => 'CAD', 'name' => 'Kanadischer Dollar'],
        ['code' => 'AUD', 'name' => 'Australischer Dollar']
    ];
    
    echo json_encode($currencies);
}

function createBudget() {
    global $pdo;
    
    $amount = $_POST['amount'] ?? null;
    $currency_code = $_POST['currency_code'] ?? null;
    
    if (!$amount || !$currency_code) {
        http_response_code(400);
        echo "Fehler: Betrag und Währung sind erforderlich";
        return;
    }
    
    try {
        // User-ID und Category-ID holen
        $user_id = getDefaultUserId();
        $category_id = getDefaultCategoryId();
        
        // SQL-Query mit allen required Spalten
        $stmt = $pdo->prepare("INSERT INTO budgets (amount, currencies, user_id, category_id) VALUES (:amount, :currency_code, :user_id, :category_id)");
        $stmt->bindParam(':amount', $amount);
        $stmt->bindParam(':currency_code', $currency_code);
        $stmt->bindParam(':user_id', $user_id);
        $stmt->bindParam(':category_id', $category_id);
        $stmt->execute();
        
        $budget_id = $pdo->lastInsertId();
        echo "Budget erfolgreich erstellt (ID: $budget_id): $amount $currency_code für User ID: $user_id, Category ID: $category_id";
        
    } catch (PDOException $e) {
        http_response_code(500);
        echo "Fehler beim Speichern in der Datenbank: " . $e->getMessage();
        
        // Zusätzliche Debug-Info
        echo "<br><br>Debug-Info:";
        echo "<br>Amount: " . htmlspecialchars($amount);
        echo "<br>Currency Code: " . htmlspecialchars($currency_code);
        echo "<br>User ID: " . ($user_id ?? 'nicht gesetzt');
        echo "<br>Category ID: " . ($category_id ?? 'nicht gesetzt');
    }
}

function getDefaultUserId() {
    global $pdo;
    
    try {
        // Prüfen ob users-Tabelle existiert
        $tableExists = $pdo->query("SHOW TABLES LIKE 'users'")->rowCount() > 0;
        
        if (!$tableExists) {
            return 1; // Fallback, wenn users-Tabelle nicht existiert
        }
        
        // Ersten User aus der users-Tabelle nehmen
        $userResult = $pdo->query("SELECT id FROM users LIMIT 1");
        $user = $userResult->fetch(PDO::FETCH_ASSOC);
        
        if ($user && isset($user['id'])) {
            return $user['id'];
        }
        
        // Falls keine User existieren, einen Default-User erstellen
        $pdo->exec("INSERT INTO users (username, email, created_at) VALUES ('default_user', 'default@example.com', NOW())");
        return $pdo->lastInsertId();
        
    } catch (PDOException $e) {
        // Falls etwas schiefgeht, Fallback auf ID 1
        return 1;
    }
}

function getDefaultCategoryId() {
    global $pdo;
    
    try {
        // Prüfen ob categories-Tabelle existiert
        $tableExists = $pdo->query("SHOW TABLES LIKE 'categories'")->rowCount() > 0;
        
        if (!$tableExists) {
            return 1; // Fallback, wenn categories-Tabelle nicht existiert
        }
        
        // Erste Category aus der categories-Tabelle nehmen
        $categoryResult = $pdo->query("SELECT id FROM categories LIMIT 1");
        $category = $categoryResult->fetch(PDO::FETCH_ASSOC);
        
        if ($category && isset($category['id'])) {
            return $category['id'];
        }
        
        // Falls keine Categories existieren, eine Default-Category erstellen
        $pdo->exec("INSERT INTO categories (name, description, created_at) VALUES ('Default Category', 'Automatically created category', NOW())");
        return $pdo->lastInsertId();
        
    } catch (PDOException $e) {
        // Falls etwas schiefgeht, Fallback auf ID 1
        return 1;
    }
}

function showForm() {
    ?>
    <!DOCTYPE html>
    <html lang="de">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Budget erstellen</title>
        <style>
            body { 
                font-family: Arial, sans-serif; 
                margin: 20px; 
                background-color: #f5f5f5;
            }
            .container {
                max-width: 500px;
                margin: 0 auto;
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            h2 {
                color: #333;
                text-align: center;
                margin-bottom: 20px;
            }
            form { 
                max-width: 400px; 
                margin: 0 auto; 
            }
            label { 
                display: block; 
                margin: 15px 0 5px; 
                font-weight: bold;
                color: #555;
            }
            input, select, button { 
                width: 100%; 
                padding: 12px; 
                margin: 5px 0 15px; 
                border: 1px solid #ddd;
                border-radius: 4px;
                box-sizing: border-box;
            }
            input:focus, select:focus {
                outline: none;
                border-color: #007bff;
                box-shadow: 0 0 5px rgba(0,123,255,0.3);
            }
            button { 
                background: #007bff; 
                color: white; 
                border: none; 
                cursor: pointer; 
                font-size: 16px;
                font-weight: bold;
                padding: 15px;
                margin-top: 10px;
            }
            button:hover { 
                background: #0056b3; 
            }
            .loading {
                color: #666;
                font-style: italic;
            }
            .success {
                color: green;
                font-weight: bold;
                margin-top: 15px;
                padding: 10px;
                background: #d4edda;
                border: 1px solid #c3e6cb;
                border-radius: 4px;
            }
            .error {
                color: #dc3545;
                font-weight: bold;
                margin-top: 15px;
                padding: 10px;
                background: #f8d7da;
                border: 1px solid #f5c6cb;
                border-radius: 4px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>Budget erstellen</h2>
            
            <form id="create-budget-form">
                <label for="amount">Betrag:</label>
                <input type="number" id="amount" name="amount" required step="0.01" min="0" placeholder="0.00">

                <label for="currency">Währung:</label>
                <select id="currency" name="currency_code" required>
                    <option value="">Bitte Währung wählen...</option>
                    <option class="loading" value="" disabled>Lade Währungen...</option>
                </select>

                <button type="submit">Budget erstellen</button>
            </form>

            <div id="message"></div>
        </div>

        <script>
        document.addEventListener('DOMContentLoaded', function() {
            loadCurrencies();
        });

        function loadCurrencies() {
            const currencySelect = document.getElementById('currency');
            
            currencySelect.innerHTML = '<option value="" disabled>Lade Währungen...</option>';
            
            fetch('currencyController.php?action=get_currencies')
                .then(response => response.json())
                .then(currencies => {
                    currencySelect.innerHTML = '<option value="">Bitte Währung wählen...</option>';
                    
                    currencies.forEach(currency => {
                        const option = document.createElement('option');
                        option.value = currency.code;
                        option.textContent = `${currency.name} (${currency.code})`;
                        currencySelect.appendChild(option);
                    });
                })
                .catch(error => {
                    console.error('Fehler beim Laden der Währungen:', error);
                    currencySelect.innerHTML = '<option value="">Fehler beim Laden</option>';
                    showMessage('Fehler beim Laden der Währungen: ' + error.message, 'error');
                });
        }

        function showMessage(text, type = 'info') {
            const messageDiv = document.getElementById('message');
            messageDiv.textContent = text;
            messageDiv.className = type;
            messageDiv.style.display = 'block';
            
            setTimeout(() => {
                messageDiv.style.display = 'none';
            }, 5000);
        }

        document.getElementById('create-budget-form').addEventListener('submit', function(event) {
            event.preventDefault();

            const amount = document.getElementById('amount').value;
            const currency = document.getElementById('currency').value;

            if (!amount || !currency) {
                showMessage('Bitte füllen Sie alle Felder aus', 'error');
                return;
            }

            const formData = new FormData();
            formData.append('amount', amount);
            formData.append('currency_code', currency);

            const submitButton = this.querySelector('button[type="submit"]');
            submitButton.disabled = true;
            submitButton.textContent = 'Wird gespeichert...';

            fetch('currencyController.php', {
                method: 'POST',
                body: formData
            })
            .then(response => response.text())
            .then(data => {
                showMessage(data, 'success');
                document.getElementById('create-budget-form').reset();
            })
            .catch(error => {
                console.error('Fehler beim Erstellen des Budgets:', error);
                showMessage('Fehler beim Erstellen des Budgets: ' + error.message, 'error');
            })
            .finally(() => {
                submitButton.disabled = false;
                submitButton.textContent = 'Budget erstellen';
            });
        });
        </script>
    </body>
    </html>
    <?php
}
?>