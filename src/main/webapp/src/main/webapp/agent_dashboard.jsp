<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*, java.sql.*" %>
<%
    // Checking if the session is valid and the role is technical officer
    if (session == null || !"technical_officer".equals(session.getAttribute("role"))) {
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
    <title>Technical Officer Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
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

    <!-- Pending Complaints Section -->
    <h2>Pending Complaints</h2>
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
                String sql = "SELECT complaint_id, title, description, status, response_message FROM complaints WHERE assigned_department = 'technical' AND status != 'resolved'";
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

    <!-- Replied Complaints Section -->
    <h2>Replied Complaints</h2>
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
                String sql = "SELECT complaint_id, title, description, status, response_message FROM complaints WHERE assigned_department = 'technical' AND status = 'resolved'";
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
