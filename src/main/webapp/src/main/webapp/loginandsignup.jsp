<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login/Signup Form</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        /* Remove default margin for body and html */
        html, body {
            margin: 0;
            padding: 0;
        }

        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-image: url('home3.jpg');
            background-repeat: no-repeat;
            animation: gradientAnimation 10s ease infinite;
            font-family: Arial, sans-serif;
            background-attachment: fixed;
            background-size: cover;
            position: relative; /* Added for absolute positioning of the overlay */
        }

        /* Overlay for shadow effect */
        .overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.4); /* Semi-transparent black */
            z-index: 1; /* Below the navbar but above the background */
        }

        .container {
            background-color: rgba(255, 255, 255, 0.7); /* Increased transparency */
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 15px 25px rgba(0, 0, 0, 0.2);
            width: 350px;
            max-height: 90vh;
            overflow-y: auto;
            margin-top: 20px;
            font-size: 16px; /* Increased font size */
            position: relative; /* Make sure the container is above the overlay */
            z-index: 2; /* Ensures container is on top of the overlay */
        }

        h2 {
            color: rgba(0, 64, 128, 0.8); /* Heading color */
            margin-bottom: 15px;
        }

        .input-group input {
            width: 100%;
            padding: 10px;
            border: none;
            border-radius: 5px;
            background: rgba(240, 240, 240, 0.8);
            color: #333;
            font-size: 13px;
            transition: border-color 0.3s, background 0.3s;
        }

        .input-group input:focus {
            outline: none;
            background: rgba(255, 255, 255, 1);
        }

        .input-group label {
            position: absolute;
            left: 10px;
            top: 10px;
            color: #686d76;
            font-size: 14px;
            transition: 0.3s;
        }

        .input-group input:focus + label,
        .input-group input:not(:placeholder-shown) + label {
            top: -10px;
            font-size: 12px;
            color: #dc5f00;
        }

        button {
            margin: 5px;
            cursor: pointer;
            padding: 8px 12px;
            border: none;
            border-radius: 25px;
            background: rgba(0, 64, 128, 0.8); /* Base color */
            color: white;
            font-size: 14px;
            position: relative;
            overflow: hidden;
            width: 100%;
        }

        button:hover {
            background: rgba(0, 64, 128, 0.8); /* Hover color matching the heading */
            box-shadow: 0 0 10px rgba(0, 64, 128, 1), 0 0 10px rgba(0, 64, 128, 1);
        }

        form {
            display: none;
        }

        #login-form {
            display: block;
        }

        .navbar {
            background-color: rgba(0, 64, 128, 0.8); /* Semi-transparent background */
            overflow: hidden;
            padding: 14px 20px;
            position: fixed;
            width: 100%;
            top: 0;
            color: white;
            z-index: 3; /* Ensure navbar is on top */
        }

        .navbar a {
            color: white;
            padding: 14px 20px;
            text-decoration: none;
            display: inline-block;
            transition: background-color 0.3s ease;
        }

        .navbar a:hover {
            background-color: #0066cc;
        }

        a {
            display: block;
            text-align: center;
            margin-top: 10px;
            color: #dc5f00;
            text-decoration: none;
            font-size: 14px;
        }

        a:hover {
            text-decoration: underline;
        }

    </style>
</head>
<body>
    <div class="overlay"></div> <!-- Overlay for black shadow effect -->
    <div class="container">
        <form action="LoginServlet" method="post" id="login-form">
            <h2>Login</h2>
            <input type="text" id="username" name="username" placeholder="Email or Username" size="37" required>
            <input type="password" id="password" name="password" placeholder="Password" size="37" required>
            <button type="submit">Login</button>
            <a href="forgot_password.jsp" style="color: #007bff; text-decoration: none;">Forgot Password?</a>
            <a href="#" onclick="showSignup()" style="color: #007bff; text-decoration: none;">Create new Account?</a>
        </form>
        <form id="signup-form" method="post" action="SignupServlet">
            <h2>Sign Up</h2>
            <input type="text" id="firstname" name="firstname" placeholder="First Name" size="37" required>
            <input type="text" id="lastname" name="lastname" placeholder="Last Name" size="37" required>
            <input type="email" id="email" name="email" placeholder="Email" size="37" required>
            <input type="text" id="username-signup" name="username" placeholder="Username" size="37" required>
            <input type="password" id="new-password" name="new-password" placeholder="Password" size="37" required>
            <input type="password" id="confirm-password" name="password" placeholder="Confirm Password" size="37" required>
            <input type="tel" id="telephone" name="telephone" placeholder="Telephone Number" size="37" required>
            <button type="submit">Sign Up</button>
            <a href="#" onclick="showLogin()" style="color: #007bff; text-decoration: none;">Already have an account?</a>
        </form>
    </div>

    <script>
        function showLogin() {
            document.getElementById('login-form').style.display = 'block';
            document.getElementById('signup-form').style.display = 'none';
        }

        function showSignup() {
            document.getElementById('signup-form').style.display = 'block';
            document.getElementById('login-form').style.display = 'none';
        }
    </script>
</body>
</html>
