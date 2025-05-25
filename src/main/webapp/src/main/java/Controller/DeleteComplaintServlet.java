package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/DeleteComplaintServlet")
@SuppressWarnings("serial")
public class DeleteComplaintServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String complaintId = request.getParameter("complaintId");

        String DB_URL = "jdbc:mysql://localhost:3306/customercaresystem";
        String DB_USER = "root";
        String DB_PASSWORD = "Keerthi@2002";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Check if user is logged in and get their role from the session
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("role") == null) {
                response.sendRedirect("loginandsignup.jsp");
                return;
            }

            String role = (String) session.getAttribute("role");

            // Delete the complaint from the database
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            String sql = "DELETE FROM complaints WHERE complaint_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, complaintId);
            pstmt.executeUpdate();

            // Redirect based on user role
            if ("admin".equals(role)) {
                response.sendRedirect("admin_dashboard.jsp");
            } else if ("customer".equals(role)) {
                response.sendRedirect("view_complaints.jsp");
            } else {
                response.sendRedirect("loginandsignup.jsp"); // Fallback for unrecognized roles
            }

        } catch (Exception e) {
            e.printStackTrace();
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
