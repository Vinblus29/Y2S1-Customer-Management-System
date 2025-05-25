<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String complaintId = request.getParameter("complaintId");
    String DB_URL = "jdbc:mysql://localhost:3306/customercaresystem";
    String DB_USER = "root";
    String DB_PASSWORD = "Keerthi@2002";
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String title = "", issueType = "", description = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

        // Fetch complaint details for the given complaintId
        String sql = "SELECT title, issue_type, description FROM complaints WHERE complaint_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, complaintId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            title = rs.getString("title");
            issueType = rs.getString("issue_type");
            description = rs.getString("description");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Complaint</title>
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

        .container {
            width: 50%;
            margin: 50px auto;
            background: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #333;
        }
        label {
            display: block;
            margin: 10px 0 5px;
            font-weight: bold;
        }
        input[type="text"], textarea, select {
            width: 100%;
            padding: 10px;
            margin: 10px 0 20px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        button {
            padding: 10px 15px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
        }
        button:hover {
            background-color: #218838;
        }
        .cancel-button {
            background-color: #dc3545;
        }
        .cancel-button:hover {
            background-color: #c82333;
        }
         .navbar {
            background-color: #333;
            overflow: hidden;
            padding: 14px 20px;
            position: fixed;
            width: 100%;
            top: 0;
            color: white;
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
            .logout-button {
            background-color: #ff4c4c;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            float: right;
            margin-right: 50px;
            transition: background-color 0.3s ease;
            width:10%;
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
<br><br><br><br>
    <div class="container">
        <h1>Edit Complaint</h1>
        <form action="UpdateComplaintServlet" method="post">
            <!-- Passing the complaintId as a hidden field -->
            <input type="hidden" name="complaintId" value="<%= complaintId %>">
            
            <label for="title">Title:</label>
            <input type="text" name="title" value="<%= title %>" required>

            <label for="issueType">Issue Type:</label>
            <select name="issueType" required>
                <option value="Technical" <%= "Technical".equals(issueType) ? "selected" : "" %>>Technical</option>
                <option value="Billing" <%= "Billing".equals(issueType) ? "selected" : "" %>>Billing</option>
                <option value="General" <%= "General".equals(issueType) ? "selected" : "" %>>General</option>
            </select>

            <label for="description">Description:</label>
            <textarea name="description" required><%= description %></textarea>

            <button type="submit" style="background-color:#0066cc; width:48%">Update-Complaint</button><br>
        </form>
        <a href="customer_dashboard.jsp" class="cancel-button" style="text-decoration: none;">
            <button type="button" style="background-color:#0066cc;width:48%; float:right;margin-top:-35px;margin">Cancel</button>
        </a>
    </div>
</body>
</html>
