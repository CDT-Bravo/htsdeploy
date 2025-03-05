<?php
// File where characters are stored
$file = 'characters.json';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get the incoming data
    $data = json_decode(file_get_contents('php://input'), true);

    // Validate incoming data
    if (!isset($data['name']) || !isset($data['class']) || !isset($data['race']) || !isset($data['level'])) {
        echo json_encode(['error' => 'Missing required fields']);
        exit;
    }

    // Read the existing data from the JSON file
    $characters = json_decode(file_get_contents($file), true);

    // Add the new character (raw data, no escaping)
    $characters[] = $data;

    // Save the updated characters to the JSON file
    file_put_contents($file, json_encode($characters, JSON_PRETTY_PRINT));

    // Return success message
    echo json_encode(['message' => 'Character saved!']);
}
?>
