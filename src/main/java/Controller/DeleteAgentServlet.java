package Controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@SuppressWarnings("serial")
@WebServlet("/DeleteAgentServlet")
public class DeleteAgentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String agentId = request.getParameter("id");

        String DB_URL = "jdbc:mysql://localhost:3306/customercaresystem";
        String DB_USER = "root";
        String DB_PASSWORD = "Keerthi@2002";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            String sql = "DELETE FROM users WHERE id = ? AND role = 'agent'";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(agentId));
            pstmt.executeUpdate();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect("admin_dashboard.jsp");
    }
}
