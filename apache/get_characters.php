<?php
$file = 'characters.json';

// Read the existing data from the JSON file
$charactersJson = file_get_contents($file);

// Check if reading the file was successful
if ($charactersJson === false) {
    echo json_encode(['error' => 'Failed to read the JSON file']);
    exit;
}

// Decode the JSON data
$characters = json_decode($charactersJson, true);

// Check if decoding the JSON was successful
if ($characters === null) {
    echo json_encode(['error' => 'Failed to decode JSON data from file']);
    exit;
}

// Return the characters as a JSON response
echo json_encode($characters, JSON_PRETTY_PRINT);
?>
