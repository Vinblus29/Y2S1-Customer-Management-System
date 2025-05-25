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

@WebServlet("/SubmitComplaintServlet")
public class SubmitComplaintServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database URL, username, and password (adjust if necessary)
    private static final String DB_URL = "jdbc:mysql://localhost:3306/customercaresystem";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Keerthi@2002";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get session and check if the user is logged in
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        if (username == null) {
            response.sendRedirect("loginandsignup.jsp");
            return;
        }

        // Extract complaint details from the request
        String title = request.getParameter("title");
        String issueType = request.getParameter("issueType");
        String description = request.getParameter("description");

        // Connect to the database and insert the complaint
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Load MySQL JDBC Driver
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // SQL query to insert the complaint into the database
            String sql = "INSERT INTO complaints (customer_id, title, issue_type, description, status) " +
                         "VALUES ((SELECT id FROM users WHERE username = ?), ?, ?, ?, 'pending')";

            // Prepare the statement to prevent SQL injection
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username); // Assuming username links to customer_id
            stmt.setString(2, title);
            stmt.setString(3, issueType);
            stmt.setString(4, description);

            // Execute the update
            int rowsInserted = stmt.executeUpdate();

            // Check if the insertion was successful
            if (rowsInserted > 0) {
                response.sendRedirect("customer_dashboard.jsp?success=true");
            } else {
                response.sendRedirect("raise_complaint.jsp?error=true");
            }

            // Close the connection
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("raise_complaint.jsp?error=true");
        }
    }
}
