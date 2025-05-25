<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    /*if (session == null || !"agent".equals(session.getAttribute("role"))) {
        response.sendRedirect("loginandsignup.jsp");
        return;
    }*/

    String DB_URL = "jdbc:mysql://localhost:3306/naga";
    String DB_USER = "root";
    String DB_PASSWORD = "naga@2002";
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agent Dashboard</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="stylesheet" href="StyleAll.css">
</head>
    <style>
        /* Add your CSS styles here */
        
         
        
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
<br><br><br><br><br>
    <h1>Welcome, <%= username %>!</h1>

    <h2>Your Allocated Complaints</h2>
    <table>
        <tr>
            <th>Complaint ID</th>
            <th>Customer ID</th>
            <th>Title</th>
            <th>Issue Type</th>
            <th>Description</th>
            <th>Status</th>
            <th>Forward</th>
        </tr>
        <%
            try {
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                stmt = conn.createStatement();
                // Fetch complaints assigned to the agent that haven't been forwarded yet
                rs = stmt.executeQuery("SELECT * FROM complaints WHERE agent_id = (SELECT id FROM users WHERE username = '" + username + "') AND assigned_department IS NULL");

                while (rs.next()) {
                    int complaintId = rs.getInt("complaint_id");
                    int customerId = rs.getInt("customer_id");
                    String title = rs.getString("title");
                    String issueType = rs.getString("issue_type");
                    String description = rs.getString("description");
                    String status = rs.getString("status");
        %>
                    <tr>
                        <td><%= complaintId %></td>
                        <td><%= customerId %></td>
                        <td><%= title %></td>
                        <td><%= issueType %></td>
                        <td><%= description %></td>
                        <td><%= status %></td>
                        <td>
                            <form action="ForwardComplaintServlet" method="post">
                                <input type="hidden" name="complaintId" value="<%= complaintId %>">
                                <select name="department" required>
                                    <option value="">Select Department</option>
                                    <option value="billing">Billing Department</option>
                                    <option value="technical">Technical Officer</option>
                                    <option value="other">Other</option> <!-- Added Other option -->
                                </select>
                                <button type="submit">Forward</button>
                            </form>
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

    <h2>Forwarded Complaints</h2>
    <table>
        <tr>
            <th>Complaint ID</th>
            <th>Customer ID</th>
            <th>Title</th>
            <th>Issue Type</th>
            <th>Description</th>
            <th>Status</th>
            <th>Assigned Department</th>
        </tr>
        <%
            try {
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                stmt = conn.createStatement();
                // Fetch complaints assigned to the agent that have been forwarded
                rs = stmt.executeQuery("SELECT * FROM complaints WHERE agent_id = (SELECT id FROM users WHERE username = '" + username + "') AND assigned_department IS NOT NULL");

                while (rs.next()) {
                    int complaintId = rs.getInt("complaint_id");
                    int customerId = rs.getInt("customer_id");
                    String title = rs.getString("title");
                    String issueType = rs.getString("issue_type");
                    String description = rs.getString("description");
                    String status = rs.getString("status");
                    String assignedDepartment = rs.getString("assigned_department");
        %>
                    <tr>
                        <td><%= complaintId %></td>
                        <td><%= customerId %></td>
                        <td><%= title %></td>
                        <td><%= issueType %></td>
                        <td><%= description %></td>
                        <td><%= status %></td>
                        <td><%= assignedDepartment %></td>
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