<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // Check if the user is logged in
    if (session == null || !"customer".equals(session.getAttribute("role"))) {
        response.sendRedirect("loginandsignup.jsp");
        return;
    }
    
    String username = (String) session.getAttribute("username");
    
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
    <title>Customer Dashboard</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            position: relative; /* To position the pseudo-element */
            overflow: hidden; /* Prevents scrolling */
        }
        
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: url('homenew.jpg'); /* Replace with your image URL */
            background-size: cover; /* Ensures the image covers the entire background */
            background-position: center; /* Center the image */
            background-repeat: no-repeat; /* Prevents image repetition */
            background-attachment: fixed;
            filter: brightness(0.8); /* Darkens the image slightly */
            z-index: -1; /* Places the overlay behind content */
        }

        .navbar {
            background-color: rgba(0, 64, 128, 0.8); /* Semi-transparent background */
            overflow: hidden;
            padding: 14px 20px;
            position: fixed;
            width: 100%;
            top: 0;
            color: white;
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
            padding: 20px;
            margin-top: 70px;
            background-color: rgba(255, 255, 255, 0.9); /* White background with slight transparency */
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }

        .welcome {
            font-size: 24px;
            margin-bottom: 20px;
            color: #004080; /* Theme color */
        }

        .complaints-section {
            margin-top: 30px;
            padding: 20px;
        }

        .question-answer {
            border: 1px solid #ddd;
            padding: 10px;
            margin: 10px 0;
            background-color: #f9f9f9;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }

        .question-answer:hover {
            background-color: #e6e6e6;
        }

        .question {
            font-weight: bold;
            color: #004080; /* Theme color */
        }

        .answer {
            margin-top: 5px;
            color: #555;
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
        <h1 class="welcome">Welcome, <%= username %>!</h1>

        <div class="complaints-section">
            <h2>Your Complaints and Responses</h2>
            <%
                try {
                    conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                    String sql = "SELECT c.title, c.status, c.response_message " +
                                 "FROM complaints c JOIN users u ON c.customer_id = u.id " +
                                 "WHERE u.username = ?"; // Query to fetch complaints for the logged-in customer
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, username);
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
                        String title = rs.getString("title");
                        String status = rs.getString("status");
                        String responseMessage = rs.getString("response_message");
            %>
                        <div class="question-answer">
                            <div class="question">Complaint: <%= title %></div>
                            <div class="answer">Status: <%= status %></div>
                            <div class="answer">Response: <%= responseMessage != null ? responseMessage : "No response yet" %></div>
                        </div>
            <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                }
            %>
        </div>
    </div>
</body>
</html>
