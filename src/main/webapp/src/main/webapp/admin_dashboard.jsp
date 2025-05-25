<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    if (session == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect("loginandsignup.jsp");
        return;
    }

    String DB_URL = "jdbc:mysql://localhost:3306/customercaresystem";
    String DB_USER = "root";
    String DB_PASSWORD = "Keerthi@2002";
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    // Determine which section to display based on URL parameters
    String section = request.getParameter("section");
    if (section == null) {
        section = "dashboard"; // Default section
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="styles.css"> <!-- Link to your CSS file -->
      <style>
        /* Add your CSS styles here */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
            background-image: url('home3.jpg');
            background-repeat: no-repeat;
            background-size: cover;
            background-position: center;
        }
        h1, h2 {
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background-color: #fff;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        form {
            display: inline;
        }
        input[type="text"], input[type="email"], input[type="password"], select {
            padding: 10px;
            margin: 5px 0;
            width: calc(100% - 22px);
            border: 1px solid #ccc;
            border-radius: 4px;
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
            margin-left:0;
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
        .content{
        background-color:#688da1;
        }
    </style>

</head>
<body>
    <!-- Navbar -->
    <div class="navbar">
        <a href="?section=dashboard">Dashboard</a>
        <a href="?section=agentDetails">Agent Details</a>
        <a href="?section=addAgent">Add New Agent</a>
        <a href="?section=history">History</a> <!-- New History Section -->
        <form action="LogoutServlet" method="post" style="display: inline;">
            <button class="logout-button" type="submit">Logout</button>
        </form>
    </div>
    <br><br><br><br><br>
	<div class="content">
	<h1 style="color:white">Welcome, Admin!</h1>
	</div>
    

    <% if ("dashboard".equals(section)) { %>
        <!-- View and Allocate Complaints Section -->
        <div class="content">
         <h2 style="color:white">View and Allocate Complaints</h2>
        </div>
       
        <table>
            <tr>
                <th>Complaint ID</th>
                <th>Customer ID</th>
                <th>Title</th>
                <th>Issue Type</th>
                <th>Description</th>
                <th>Status</th>
                <th>Agent</th>
                <th>Actions</th>
            </tr>
            <%
                try {
                    conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM complaints");

                    while (rs.next()) {
                        int complaintId = rs.getInt("complaint_id");
                        int customerId = rs.getInt("customer_id");
                        String title = rs.getString("title");
                        String issueType = rs.getString("issue_type");
                        String description = rs.getString("description");
                        String status = rs.getString("status");
                        int assignedAgentId = rs.getInt("agent_id");
            %>
            <tr>
                <td><%= complaintId %></td>
                <td><%= customerId %></td>
                <td><%= title %></td>
                <td><%= issueType %></td>
                <td><%= description %></td>
                <td><%= status %></td>
                <td>
                    <form action="AllocateComplaintServlet" method="post">
                        <input type="hidden" name="complaintId" value="<%= complaintId %>">
                        <select name="agentId" required>
                            <option value="">Select Agent</option>
                            <%
                                // Fetch agents to allocate
                                Statement agentStmt = conn.createStatement();
                                ResultSet agentRs = agentStmt.executeQuery("SELECT id, firstname, lastname FROM users WHERE role = 'agent'");
                                while (agentRs.next()) {
                                    int agentId = agentRs.getInt("id");
                                    String agentName = agentRs.getString("firstname") + " " + agentRs.getString("lastname");
                                    String selected = (assignedAgentId == agentId) ? "selected" : "";
                            %>
                            <option value="<%= agentId %>" <%= selected %>><%= agentName %></option>
                            <%
                                }
                                agentRs.close();
                                agentStmt.close();
                            %>
                        </select>
                        <button type="submit">Allocate</button>
                    </form>
                </td>
                <td>
                    <form action="DeleteComplaintServlet" method="post" onsubmit="return confirm('Are you sure you want to delete this complaint?');">
                        <input type="hidden" name="complaintId" value="<%= complaintId %>">
                        <button type="submit">Delete</button>
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
    <% } else if ("agentDetails".equals(section)) { %>
        <!-- Manage Agents Section -->
        <div class="content">
        <h2 style="color:white">Manage Agents</h2>
        </div>
        <table>
            <tr>
                <th>ID</th>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Email</th>
                <th>Username</th>
                <th>Telephone</th>
                <th>Password</th>
                <th>Actions</th>
            </tr>
            <%
                try {
                    conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT * FROM users WHERE role = 'agent'");

                    while (rs.next()) {
                        int id = rs.getInt("id");
                        String firstname = rs.getString("firstname");
                        String lastname = rs.getString("lastname");
                        String email = rs.getString("email");
                        String username = rs.getString("username");
                        String telephone = rs.getString("telephone");
                        String password = rs.getString("password");
            %>
            <tr>
                <td><%= id %></td>
                <td><%= firstname %></td>
                <td><%= lastname %></td>
                <td><%= email %></td>
                <td><%= username %></td>
                <td><%= telephone %></td>
                <td><%= password %></td>
                <td>
                    <form action="UpdateAgentServlet" method="post">
                        <input type="hidden" name="id" value="<%= id %>">
                        <input type="text" name="firstname" value="<%= firstname %>" required>
                        <input type="text" name="lastname" value="<%= lastname %>" required>
                        <input type="email" name="email" value="<%= email %>" required>
                        <input type="text" name="telephone" value="<%= telephone %>" required>
                        <input type="text" name="password" value="<%= password %>" required>
                        <button type="submit">Update</button>
                    </form>
                    <form action="DeleteAgentServlet" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="<%= id %>">
                        <button type="submit">Delete</button>
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
    <% } else if ("addAgent".equals(section)) { %>
        <!-- Add New Agent Section -->
        <h2>Add New Agent</h2>
        <form action="AddAgentServlet" method="post">
            <input type="text" name="firstname" placeholder="First Name" required>
            <input type="text" name="lastname" placeholder="Last Name" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="text" name="username" placeholder="Username" required>
            <input type="text" name="telephone" placeholder="Telephone" required>
            <input type="text" name="password" placeholder="Password" required>
            <button type="submit">Add Agent</button>
        </form>
    <% } else if ("history".equals(section)) { %>
        <!-- Complaint History Section -->
        <h2>Resolved Complaint History</h2>
        <table>
            <tr>
                <th>Customer Name</th>
                <th>Complaint Title</th>
                
                <th>Response Message</th>
            </tr>
            <%
                try {
                    conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
                    stmt = conn.createStatement();
                    String query = "SELECT c.title, u.firstname AS customer_firstname, u.lastname AS customer_lastname, " +
                                   "c.response_message " +"FROM complaints c " +
                                   "JOIN users u ON c.customer_id = u.id " +
                                   "LEFT JOIN users a ON c.agent_id = a.id " +
                                   "LEFT JOIN users r ON c.responser_id = r.id " + // Get responder's details
                                   "WHERE c.status = 'resolved'"; // Filter to show only resolved complaints
                    rs = stmt.executeQuery(query);

                    while (rs.next()) {
                        String customerName = rs.getString("customer_firstname") + " " + rs.getString("customer_lastname");
                        String complaintTitle = rs.getString("title");
                     
                        String responseMessage = rs.getString("response_message");
            %>
            <tr>
                <td><%= customerName %></td>
                <td><%= complaintTitle %></td>
               
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
    <% } %>
</body>
</html>
