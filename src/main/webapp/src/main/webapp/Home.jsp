<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if the user is logged in
    boolean isLoggedIn = session != null && "customer".equals(session.getAttribute("role"));
    String username = isLoggedIn ? (String) session.getAttribute("username") : null;

    // Database connection details
    String DB_URL = "jdbc:mysql://localhost:3306/customercaresystem";
    String DB_USER = "root";
    String DB_PASSWORD = "Keerthi@2002";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Care - Home</title>
    <link rel="stylesheet" href="styles.css"> <!-- External CSS file for additional styles -->
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            animation: fadeIn 1s ease;
             background-image: url('homenew.jpg');
            background-repeat: no-repeat;
            background-size: cover;
            background-position: center;
            height:90vh;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .navbar {
            background-color: #333;
            overflow: hidden;
            padding: 14px 20px;
            position: fixed;
            width: 100%;
            top: 0;
            color: white;
            transition: background-color 0.3s ease;
        }

        .navbar:hover {
            background-color: #444; /* Darker shade on hover */
        }

        .navbar a {
            color: white;
            padding: 14px 20px;
            text-decoration: none;
            display: inline-block;
            transition: color 0.3s ease;
        }

        .navbar a:hover {
            color: #ffcc00; /* Change color on hover */
        }

        .navbar .login-button {
            background-color: #ff4c4c;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .navbar .login-button:hover {
            background-color: #d43d3d; /* Darker shade on hover */
        }

        .container {
            padding: 20px;
            margin-top: 70px; /* To avoid overlap with the fixed navbar */
            animation: slideIn 0.5s ease;
        }

        @keyframes slideIn {
            from { transform: translateY(-20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .welcome {
            font-size: 24px;
            margin-bottom: 20px;
            color: #dc5f00; /* Customer care theme color */
            animation: bounce 1s ease infinite alternate;
        }

        @keyframes bounce {
            from { transform: translateY(0); }
            to { transform: translateY(-10px); }
        }

        .info-section {
            background-color: #fff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            transition: transform 0.3s ease;
        }

        .info-section:hover {
            transform: translateY(-5px); /* Lift effect on hover */
        }

        .info-section h2 {
            margin-top: 0;
        }

        .info-section p {
            line-height: 1.6;
            color: #555;
        }

        .complaints-section {
            margin-top: 30px;
        }

        .question-answer {
            border: 1px solid #ddd;
            padding: 10px;
            margin: 10px 0;
            background-color: #fff;
            transition: background-color 0.3s ease;
        }

        .question-answer:hover {
            background-color: #f9f9f9; /* Light grey on hover */
        }

        .question {
            font-weight: bold;
            color: #333;
        }

        .answer {
            margin-top: 5px;
            color: #555;
        }
         .login-button {
            background-color: #ff4c4c;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            float: right;
            margin-right:25px;
            }
    </style>
</head>
 <script>
        function checkLogin(action) {
            const isLoggedIn = <%= isLoggedIn ? "true" : "false" %>;
            if (!isLoggedIn) {
                alert("You must log in to view this page.");
                window.location.href = "loginandsignup.jsp"; // Redirect to login page
                return false; // Prevent the default action
            }
            return true; // Proceed with the action
        }
        
    </script>
<body>
    <!-- Navbar -->
    <div class="navbar">
        
        <a href="customer_dashboard.jsp" onclick="return checkLogin(this.href)">Home</a>
        <a href="customer_dashboard.jsp" onclick="return checkLogin(this.href)">Raise Complaint</a>
        <a href="customer_dashboard.jsp" onclick="return checkLogin(this.href)">My Complaints</a>
        <form action="<%= isLoggedIn ? "LogoutServlet" : "loginandsignup.jsp" %>" method="post" style="display: inline;">
            <button class="login-button" type="submit"><%= isLoggedIn ? "Logout" : "Login" %></button>
        </form>
    </div>

    <!-- Main Content -->
    <div class="container"><center>
       <b> <h1 class="welcome">Welcome to Customer Care!</h1></b>
 </center>
        <!-- Information Section -->
        <div class="info-section">
            <h2>About Our Customer Care</h2>
            <p>
                Our customer care service is dedicated to providing support and assistance for all your inquiries and concerns. Whether you're facing technical issues, have billing questions, or need help with our services, we are here to help you 24/7.
            </p>
            <p>
                On this platform, you can easily raise complaints, track their status, and communicate with our support team. Your satisfaction is our priority, and we strive to resolve your issues promptly and efficiently.
            </p>
            <p>
                We value your feedback, as it helps us improve our services. Please feel free to reach out to us with any suggestions or questions.
            </p>
        </div>

        <!-- Complaints Section -->
         <div class="container">
        <div class="complaints-section">
            <h2>Your Complaints and Responses</h2>
            
                <p>Please log in to view your complaints.</p>
                 <a href="customer_dashboard.jsp">login here!!</a>
           
        </div>
    </div>
</body>
</html>
