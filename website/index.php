<?php
$host = '10.10.20.11'; // IP della VM "db"
$username = 'utente'; // Nome utente MySQL
$password = 'utente'; // Password MySQL
$database = 'vagrant'; // Nome del database che hai appena creato

// Connessione a MySQL
$mysqli = new mysqli($host, $username, $password, $database);

// Verifica della connessione
if ($mysqli->connect_error) {
    die('Errore di connessione (' . $mysqli->connect_errno . ') ' . $mysqli->connect_error);
}

// Esegui una query di esempio
$result = $mysqli->query("SELECT * FROM table1");

// Mostra i risultati
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        echo "ID: " . $row["id"] . " - Nome: " . $row["nome"] . "<br>";
    }
} else {
    echo "0 risultati";
}

// Chiudi la connessione
$mysqli->close();
?>
