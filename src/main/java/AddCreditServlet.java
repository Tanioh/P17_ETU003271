package controllers;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import models.*;
import java.text.SimpleDateFormat;
import java.util.Date;

public class AddCreditServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect("index.html");
            return;
        }

        User user = (User) session.getAttribute("user");
        String libelle = req.getParameter("libelle");
        String montantStr = req.getParameter("montant");
        String dateDebutStr = req.getParameter("dateDebut");
        String dateFinStr = req.getParameter("dateFin");

        try {
            double montant = Double.parseDouble(montantStr);
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date dateDebut = dateFormat.parse(dateDebutStr);
            Date dateFin = dateFormat.parse(dateFinStr);

            // Vérifier que la date de fin est après la date de début
            if (dateFin.before(dateDebut)) {
                req.setAttribute("error", "La date de fin doit être après la date de début.");
                req.getRequestDispatcher("welcome.jsp").forward(req, res);
                return;
            }

            LigneCredit ligneCredit = new LigneCredit(libelle, montant, user.getId(), dateDebut, dateFin);
            ligneCredit.save();

            // Rediriger vers la page des dépenses
            res.sendRedirect("depenses.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur lors de l'ajout de la ligne de crédit : " + e.getMessage());
            req.getRequestDispatcher("welcome.jsp").forward(req, res);
        }
    }
}