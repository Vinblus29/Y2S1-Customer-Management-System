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
import java.sql.SQLException;

@WebServlet("/ForwardComplaintServlet")
public class ForwardComplaintServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/customercaresystem";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Keerthi@2002";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String complaintId = request.getParameter("complaintId");
        String department = request.getParameter("department");

        // Validate the input
        if (complaintId == null || department == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid complaint ID or department");
            return;
        }

        // SQL to update the complaint's assigned department
        String sql = "UPDATE complaints SET assigned_department = ? WHERE complaint_id = ?";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, department);
            pstmt.setInt(2, Integer.parseInt(complaintId));

            int rowsUpdated = pstmt.executeUpdate();
            if (rowsUpdated > 0) {
                // Optionally, set a success message or redirect
                response.sendRedirect("agent_dashboard.jsp?success=Complaint forwarded successfully.");
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Complaint not found");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred");
        }
    }
}
