package controllers;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import models.*;
import java.sql.SQLException;

public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        System.out.println("Début de la méthode doPost");

        String username = req.getParameter("nom");
        String password = req.getParameter("mdp");

        // Validation des entrées
        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            System.out.println("Nom d'utilisateur ou mot de passe manquant");
            req.setAttribute("error", "Veuillez entrer un nom d'utilisateur et un mot de passe");
            req.getRequestDispatcher("index.html").forward(req, res);
            return;
        }

        System.out.println("Nom d'utilisateur saisi : " + username);
        System.out.println("Mot de passe saisi : " + password);

        try {
            System.out.println("Entrée dans le bloc try");
            User user = User.login(username, password);
            System.out.println("Résultat de User.login : " + (user != null ? "Utilisateur trouvé" : "Utilisateur non trouvé"));
            if (user != null) {
                HttpSession session = req.getSession(true);
                session.setAttribute("user", user);
                System.out.println("Session créée, redirection vers welcome.jsp");
                res.sendRedirect("welcome.jsp");
            } else {
                req.setAttribute("error", "Identifiants invalides");
                System.out.println("Identifiants invalides, redirection vers index.html");
                req.getRequestDispatcher("index.html").forward(req, res);
            }
        } catch (SQLException e) {
            System.out.println("SQLException capturée : " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "Erreur de connexion à la base de données : " + e.getMessage());
            req.getRequestDispatcher("index.html").forward(req, res);
        } catch (Exception e) {
            System.out.println("Exception inattendue : " + e.getMessage());
            e.printStackTrace();
            req.setAttribute("error", "Erreur inattendue : " + e.getMessage());
            req.getRequestDispatcher("index.html").forward(req, res);
        }
    }
}