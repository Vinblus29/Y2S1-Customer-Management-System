package Controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@SuppressWarnings("serial")
@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (role == null) {
            response.sendRedirect("loginandsignup.jsp");
        } else {
            switch (role) {
                case "customer":
                    response.sendRedirect("customer_dashboard.jsp");
                    break;
                case "admin":
                    response.sendRedirect("admin_dashboard.jsp");
                    break;
                case "agent":
                    response.sendRedirect("agent_dashboard.jsp");
                    break;
                case "technical_officer":
                    response.sendRedirect("technical_officer_dashboard.jsp");
                    break;
                case "billing_department":
                    response.sendRedirect("billing_department_dashboard.jsp");
                    break;
            }
        }
     }
   }