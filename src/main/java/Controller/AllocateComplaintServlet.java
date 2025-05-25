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

@SuppressWarnings("serial")
@WebServlet("/AllocateComplaintServlet")
public class AllocateComplaintServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String complaintIdStr = request.getParameter("complaintId");
        String agentIdStr = request.getParameter("agentId");

        // Validate parameters
        if (complaintIdStr == null || complaintIdStr.isEmpty() || agentIdStr == null || agentIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Complaint ID or Agent ID is missing.");
            return;
        }

        try {
            int complaintId = Integer.parseInt(complaintIdStr);
            int agentId = Integer.parseInt(agentIdStr);

            // Database connection
            String DB_URL = "jdbc:mysql://localhost:3306/customercaresystem";
            String DB_USER = "root";
            String DB_PASSWORD = "Keerthi@2002";
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Update complaint status and assign agent
            String updateQuery = "UPDATE complaints SET agent_id = ?, status = 'in-progress' WHERE complaint_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(updateQuery);
            pstmt.setInt(1, agentId);
            pstmt.setInt(2, complaintId);
            pstmt.executeUpdate();

            // Redirect or send success response
            response.sendRedirect("admin_dashboard.jsp");
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Complaint ID or Agent ID.");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error occurred.");
        }
    }
}
