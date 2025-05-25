package Controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ReplyComplaintServlet")
public class ReplyComplaintServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/customercaresystem";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Keerthi@2002";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get complaint ID and response message from the form
        String complaintId = request.getParameter("complaintId");
        String responseMessage = request.getParameter("responseMessage");

        if (complaintId == null || responseMessage == null || responseMessage.trim().isEmpty()) {
            response.sendRedirect("technical_officer_dashboard.jsp?error=missing_fields");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Connect to the database
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Update the complaints table to include the response and mark as resolved
            String sql = "UPDATE complaints SET response_message = ?, status = 'resolved' WHERE complaint_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, responseMessage);
            pstmt.setInt(2, Integer.parseInt(complaintId));

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                // Get the user's role from the session
                HttpSession session = request.getSession(false);
                String role = (String) session.getAttribute("role");

                // Redirect to the appropriate dashboard based on the role
                if ("technical_officer".equals(role)) {
                    response.sendRedirect("technical_officer_dashboard.jsp?success=reply_sent");
                } else if ("billing_department".equals(role)) {
                    response.sendRedirect("billing_department_dashboard.jsp?success=reply_sent");
                } else {
                    // If the role is not recognized, redirect to a default page
                    response.sendRedirect("home.jsp");
                }
            } else {
                // If no rows were updated, something went wrong
                response.sendRedirect("technical_officer_dashboard.jsp?error=complaint_not_found");
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Handle exceptions by redirecting to an error page or showing an error message
            response.sendRedirect("technical_officer_dashboard.jsp?error=server_error");
        } finally {
            // Close the resources
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    }
}
