<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*, java.sql.*" %>
<%
    // Checking if the session is valid and the role is billing department
    if (session == null || !"billing_department".equals(session.getAttribute("role"))) {
        response.sendRedirect("loginandsignup.jsp");
        return;
    }

    String DB_URL = "jdbc:mysql://localhost:3306/customercaresystem";
    String DB_USER = "root";
    String DB_PASSWORD = "Keerthi@2002";
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billing Department Dashboard</title>
 <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #eef1f7;
            margin: 0;
            padding: 0;
             background-image: url('home3.jpg');
            background-repeat: no-repeat;
            background-size: cover;
            background-position: center;
            height:100vh;
        }

        h1 {
             color: #333;
            text-align: center;
            margin-top: 20px;
        }

        h2 {
             color: #333;
            margin-bottom: 10px;
        }

     
       
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background-color: rgba(255, 255, 255, 0.8); /* Semi-transparent white background */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* Optional: Adds a slight shadow effect */
        }
        th, td {
            border: 3px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #f1f1f1;
        }

          button {
            background-color: rgba(0, 64, 128, 0.8); /* Updated customer care theme color */
            color: white;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background-color: rgba(0, 64, 128, 1); /* Darker shade on hover */
        }
        .navbar {
            background-color: rgba(0, 64, 128, 0.8); /* Semi-transparent background */
            overflow: hidden;
            padding: 14px 20px;
            position: fixed;
            width: 100%;
            top: 0;
            color: white;
            margin-left: 0;
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
        }

        .logout-button:hover {
            background-color: #d43d3d; /* Darker shade on hover */
        }
        .content {
            background-color: #688da1;
        }

       
        .complaints-section {
            display: none;
        }

        .active {
            display: block;
        }

        .tab {
            cursor: pointer;
           
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            margin: 0 5px;
            display: inline-block;
        }

        .tab:hover {
            background-color: #004494;
        }
          .content{
        background-color:#688da1;
        }
    </style>
</head>
<body>
 <!-- Navbar -->
    <div class="navbar">
        <a href="billing_department_dashboard.jsp">Pending Billing Complaints</a>
        <a href="billing_department_dashboard.jsp">Replied Billing Complaints</a>
        
       
        <form action="LogoutServlet" method="post" style="display: inline;">
            <button class="logout-button" type="submit">Logout</button>
        </form>
    </div>
    <br><br><br><br><br>
    <div class="content">
    <h1 style="color:white">Welcome, <%= username %>!</h1>
    </div>

    <!-- Table for billing complaints not yet resolved -->
    <div class="content">
    <h2>Pending Billing Complaints</h2>
    </div>
    <table>
        <tr>
            <th>Complaint ID</th>
            <th>Title</th>
            <th>Description</th>
            <th>Status</th>
            <th>Response</th>
        </tr>
        <%
            try {
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                String sql = "SELECT complaint_id, title, description, status, response_message FROM complaints WHERE assigned_department = 'billing' AND status != 'resolved'";
                stmt = conn.prepareStatement(sql);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    int complaintId = rs.getInt("complaint_id");
                    String title = rs.getString("title");
                    String description = rs.getString("description");
                    String status = rs.getString("status");
                    String responseMessage = rs.getString("response_message");
        %>
                    <tr>
                        <td><%= complaintId %></td>
                        <td><%= title %></td>
                        <td><%= description %></td>
                        <td><%= status %></td>
                        <td>
                            <%
                                if ("resolved".equals(status)) {
                                    out.print(responseMessage); // Show the response if resolved
                                } else {
                                    // Show the reply form if not resolved
                            %>
                                    <form action="ReplyComplaintServlet" method="post">
                                        <input type="hidden" name="complaintId" value="<%= complaintId %>">
                                        <textarea name="responseMessage" required></textarea>
                                        <button type="submit">Reply</button>
                                    </form>
                            <%
                                }
                            %>
                        </td>
                    </tr>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
            }
        %>
    </table>

    <!-- Table for resolved billing complaints showing replies -->
    <div class="content">
    <h2>Replied Billing Complaints</h2>
    </div>
    <table>
        <tr>
            <th>Complaint ID</th>
            <th>Title</th>
            <th>Description</th>
            <th>Status</th>
            <th>Response Message</th>
        </tr>
        <%
            try {
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                String sql = "SELECT complaint_id, title, description, status, response_message FROM complaints WHERE assigned_department = 'billing' AND status = 'resolved'";
                stmt = conn.prepareStatement(sql);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    int complaintId = rs.getInt("complaint_id");
                    String title = rs.getString("title");
                    String description = rs.getString("description");
                    String status = rs.getString("status");
                    String responseMessage = rs.getString("response_message");
        %>
                    <tr>
                        <td><%= complaintId %></td>
                        <td><%= title %></td>
                        <td><%= description %></td>
                        <td><%= status %></td>
                        <td><%= responseMessage %></td>
                    </tr>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
            }
        %>
    </table>
</body>
</html>
