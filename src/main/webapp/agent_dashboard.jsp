<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    if (session == null || !"agent".equals(session.getAttribute("role"))) {
        response.sendRedirect("loginandsignup.jsp");
        return;
    }

    String DB_URL = "jdbc:mysql://localhost:3306/customercaresystem";
    String DB_USER = "root";
    String DB_PASSWORD = "Keerthi@2002";
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
    <style>
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

        h1 {
            color: #333;
            text-align: center;
            margin-top: 20px;
        }

        h2 {
            color: #688da1;
            margin-bottom: 10px;
        }

        table {
            width: 90%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 15px;
            border: 1px solid #ddd;
            text-align: left;
        }

        th {
            background-color: #688da1;
            color: white;
            text-transform: uppercase;
        }

        td {
            background-color: #f9f9f9;
        }

        form {
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        textarea {
            width: 90%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        button {
            background-color: #688da1;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        button:hover {
            background-color: #55788f;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            table, form {
                width: 100%;
            }

            textarea {
                width: 100%;
            }

            button {
                width: 100%;
            }
        }

        .navbar {
            background-color: #688da1;
            overflow: hidden;
            padding: 14px 20px;
            position: fixed;
            width: 100%;
            top: 0;
            color: white;
            z-index: 1;
        }

        .navbar a {
            color: white;
            padding: 14px 20px;
            text-decoration: none;
            display: inline-block;
        }

        .navbar a:hover {
            background-color: #55788f;
            color: white;
        }

        .logout-button {
            background-color: #ff4c4c;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            float: right;
            margin-right: 25px;
        }
          .content{
        background-color:#688da1;
        }
    </style>
    <script>
        function showSection(sectionId) {
            // Hide all sections
            document.getElementById('allocatedComplaints').style.display = 'none';
            document.getElementById('forwardedComplaints').style.display = 'none';
            // Show the selected section
            document.getElementById(sectionId).style.display = 'block';
        }

        // Display the allocated complaints by default when the page loads
        window.onload = function() {
            showSection('allocatedComplaints');
        };
    </script>
</head>
<body>

    <!-- Navbar -->
    <div class="navbar">
        <a href="#" class="tab" onclick="showSection('allocatedComplaints')">Allocated Complaints</a>
        <a href="#" class="tab" onclick="showSection('forwardedComplaints')">Forwarded Complaints</a>
        <form action="LogoutServlet" method="post" style="display: inline;">
            <button class="logout-button" type="submit">Logout</button>
        </form>
    </div>
    <br><br><br><br><br>
    <div class="content">
    <h1 style="color:white">Welcome, <%= username %>!</h1>
	</div>
    <!-- Allocated Complaints Section -->
    <div id="allocatedComplaints">
     <div class="content">
        <h2 style="color:white">Allocated Complaints</h2>
        </div>
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
                                        <option value="other">Other</option>
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
    </div>

    <!-- Forwarded Complaints Section -->
    <div id="forwardedComplaints" style="display: none;">
    <div class="content">
        <h2 style="color:white">Forwarded Complaints</h2>
        </div>
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
    </div>
</body>
</html>
