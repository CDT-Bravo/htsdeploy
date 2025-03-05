<?php
header('Content-Type: application/json');

// Path to the JSON file
$file = 'characters.json';

// Check if the file exists and is readable
if (file_exists($file)) {
    $data = file_get_contents($file);
    echo $data;  // Output the contents of the file as JSON
} else {
    echo json_encode([]);  // If no characters exist, return an empty array
}
?>
