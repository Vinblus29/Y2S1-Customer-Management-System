package Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/customercaresystem";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Keerthi@2002";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String telephone = request.getParameter("telephone");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Set response type
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            if (newPassword == null || confirmPassword == null) {
                // Verification process
                PreparedStatement stmt = conn.prepareStatement("SELECT * FROM users WHERE username = ? AND email = ? AND telephone = ?");
                stmt.setString(1, username);
                stmt.setString(2, email);
                stmt.setString(3, telephone);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    // User details are correct, show the new password form
                    request.setAttribute("username", username);
                    request.getRequestDispatcher("forgot_password.jsp").include(request, response);
                    response.getWriter().write("<script>showNewPasswordForm('" + username + "');</script>");
                } else {
                    out.println("<div style='color:red; align-items:center;'>Invalid username, email, or telephone number.</div>");
                    request.getRequestDispatcher("forgot_password.jsp").include(request, response);
                }
            } else {
                // Password reset process
                if (newPassword.equals(confirmPassword)) {
                    PreparedStatement updateStmt = conn.prepareStatement("UPDATE users SET password = ? WHERE username = ?");
                    updateStmt.setString(1, newPassword);
                    updateStmt.setString(2, username);
                    int rowsUpdated = updateStmt.executeUpdate();

                    if (rowsUpdated > 0) {
                        out.println("<div>Password successfully updated!</div>");
                        response.sendRedirect("loginandsignup.jsp");
                    } else {
                        out.println("<div style='color:red;'>Failed to update password.</div>");
                    }
                } else {
                    out.println("<div style='color:red;'>Passwords do not match.</div>");
                }
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<div style='color:red;'>Error occurred: " + e.getMessage() + "</div>");
        } finally {
            out.close();
        }
    }
}
