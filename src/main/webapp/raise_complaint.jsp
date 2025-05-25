<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Raise Complaint</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('complaint.jpg'); /* Background image for customer care theme */
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
            margin: 0;
            padding: 0;
            color: #333;
            position: relative; /* Added for overlay positioning */
        }

        /* Black shadow overlay */
        .overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5); /* Semi-transparent black */
            z-index: 1; /* Ensure overlay is above the background */
        }

        .navbar {
            background-color: rgba(0, 64, 128, 0.8); /* Semi-transparent background */
            overflow: hidden;
            padding: 14px 20px;
            position: fixed;
            width: 100%;
            top: 0;
            color: white;
            z-index: 2; /* Ensure navbar is above overlay */
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

        .container {
            background-color: rgba(255, 255, 255, 0.9); /* White background with slight transparency */
            padding: 30px;
            margin-top: 100px;
            max-width: 600px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            margin-left: auto;
            margin-right: auto;
            position: relative; /* Ensures that it is above the overlay */
            z-index: 2; /* Ensure container is above overlay */
        }
        
        h2 {
            margin-bottom: 20px;
            color: rgba(0, 64, 128, 0.8); /* Themed color for header */
        }

        input[type="text"], textarea, select {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
            background-color: #f9f9f9;
            box-sizing: border-box;
        }

        button {
            padding: 12px 20px;
            background-color: rgba(0, 64, 128, 0.8); /* Updated button color */
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 5px;
            margin-top: 10px;
            font-size: 16px;
        }

        button:hover {
            background-color: rgba(0, 64, 128, 1); /* Darker shade for hover effect */
        }

        label {
            font-size: 16px;
            display: block;
            margin-bottom: 5px;
            color: #333;
        }

        .logout-button {
            background-color: #ff4c4c;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            float: right;
            margin-right: 35px;
            transition: background-color 0.3s ease;
        }

        .logout-button:hover {
            background-color: #d43d3d; /* Darker shade on hover */
        }
    </style>
</head>
<body>
    <!-- Overlay for shadow effect -->
    <div class="overlay">

    <!-- Navbar -->
    <div class="navbar">
        <a href="customer_dashboard.jsp">Dashboard</a>
        <a href="raise_complaint.jsp">Raise Complaint</a>
        <a href="view_complaints.jsp">My Complaints</a>
    
        <form action="LogoutServlet" method="post" style="display: inline;">
            <button class="logout-button" type="submit">Logout</button>
        </form>
    </div>

    <!-- Main Content -->
    <div class="container">
        <h2>Raise a New Complaint</h2>
        <form action="SubmitComplaintServlet" method="post">
            <label for="title">Complaint Title</label>
            <input type="text" id="title" name="title" placeholder="Enter complaint title" required>

            <label for="issue-type">Issue Type</label>
            <select id="issue-type" name="issueType" required>
                <option value="" disabled selected>Select an issue type</option>
                <option value="technical">Technical Issue</option>
                <option value="billing">Billing Issue</option>
                <option value="other">Other</option>
            </select>

            <label for="description">Complaint Description</label>
            <textarea id="description" name="description" placeholder="Describe your complaint" rows="5" required></textarea>

            <button type="submit">Submit Complaint</button>
        </form>
    </div>
    </div>
</body>
</html>
