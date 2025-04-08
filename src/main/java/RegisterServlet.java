package controllers;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import models.*;
import java.sql.SQLException; // Add this import

public class RegisterServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String username = req.getParameter("nom");
        String password = req.getParameter("mdp");
        
        try {
            User user = new User(username, password);
            user.save();
            res.sendRedirect("index.html");
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur lors de l'inscription");
            req.getRequestDispatcher("register.jsp").forward(req, res);
        }
    }
}