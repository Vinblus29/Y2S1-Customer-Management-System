<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-image: url('home3.jpg');
            background-repeat: no-repeat;
            background-attachment: fixed;
            background-size: cover;
            margin: 0;
            font-family: Arial, sans-serif;
        }

        .container {
            background-color: rgba(255, 255, 255, 0.9);
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 15px 25px rgba(0, 0, 0, 0.3);
            width: 350px;
            max-height: 90vh;
            overflow-y: auto;
            font-size: 16px;
        }

        h2 {
            color: rgba(0, 64, 128, 0.8);
            margin-bottom: 20px;
            text-align: center;
        }

        input {
            width: calc(100% - 20px);
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            background: rgba(240, 240, 240, 0.9);
            color: #333;
            font-size: 14px;
        }

        button {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 25px;
            background: rgba(0, 64, 128, 0.8);
            color: white;
            font-size: 15px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        button:hover {
            background: rgba(0, 64, 128, 1);
        }

        .error {
            color: red;
            font-size: 14px;
            text-align: center;
            margin-bottom: 10px;
        }

        .hidden {
            display: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Forgot Password</h2>
        <div id="error-message" class="error"></div>

        <form id="verification-form" method="post" action="ForgotPasswordServlet">
            <input type="text" name="username" id="username" placeholder="Enter your username" required>
            <input type="email" name="email" id="email" placeholder="Enter your email" required>
            <input type="tel" name="telephone" id="telephone" placeholder="Enter your phone number" required>
            <button type="submit">Verify</button>
        </form>

        <form id="new-password-form" method="post" action="ForgotPasswordServlet" class="hidden">
            <input type="hidden" name="username" id="hidden-username">
            <input type="password" name="newPassword" id="newPassword" placeholder="Enter new password" required>
            <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Confirm new password" required>
            <button type="submit">Reset Password</button>
        </form>

        <a href="#" onclick="showLogin()">Back to Login</a>
    </div>

    <script>
        function showLogin() {
            window.location.href = 'loginandsignup.jsp';
        }

        function showNewPasswordForm(username) {
            document.getElementById('verification-form').classList.add('hidden');
            document.getElementById('new-password-form').classList.remove('hidden');
            document.getElementById('hidden-username').value = username;
        }
    </script>
</body>
</html>
