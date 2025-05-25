package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@SuppressWarnings("serial")
@WebServlet("/UpdateComplaintServlet")
public class UpdateComplaintServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Retrieve form data including complaintId
        String complaintId = request.getParameter("complaintId");
        String title = request.getParameter("title");
        String issueType = request.getParameter("issueType");
        String description = request.getParameter("description");

        String DB_URL = "jdbc:mysql://localhost:3306/customercaresystem";
        String DB_USER = "root";
        String DB_PASSWORD = "Keerthi@2002";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Update complaint based on complaintId
            String updateSQL = "UPDATE complaints SET title = ?, issue_type = ?, description = ? WHERE complaint_id = ?";
            pstmt = conn.prepareStatement(updateSQL);

            pstmt.setString(1, title);
            pstmt.setString(2, issueType);
            pstmt.setString(3, description);
            pstmt.setString(4, complaintId); // Use the complaintId to identify the correct record

            int rowsUpdated = pstmt.executeUpdate();

            if (rowsUpdated > 0) {
                // If update successful, redirect to customer dashboard
                response.sendRedirect("customer_dashboard.jsp");
            } else {
                // If no rows were updated, send error message
                request.setAttribute("errorMessage", "Update failed. No rows affected.");
                request.getRequestDispatcher("customer_dashboard.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Handle any exceptions and show error page
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("customer_dashboard.jsp").forward(request, response);

        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
