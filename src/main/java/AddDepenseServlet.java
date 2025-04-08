package controllers;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import models.*;
import java.util.Date;

public class AddDepenseServlet extends HttpServlet {
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

        try {
            double montant = Double.parseDouble(montantStr);

            // Récupérer la ligne de crédit pour vérifier les dates
            LigneCredit ligneCredit = LigneCredit.getLigneCreditByLibelle(user.getId(), libelle);
            if (ligneCredit == null) {
                req.setAttribute("error", "Ligne de crédit non trouvée.");
                res.sendRedirect("depenses.jsp?libelle=" + java.net.URLEncoder.encode(libelle, "UTF-8"));
                return;
            }

            // Vérifier si la date actuelle est dans la période de validité
            Date today = new Date();
            if (today.before(ligneCredit.getDateDebut()) || today.after(ligneCredit.getDateFin())) {
                req.setAttribute("error", "La date actuelle n'est pas dans la période de validité de la ligne de crédit.");
                res.sendRedirect("depenses.jsp?libelle=" + java.net.URLEncoder.encode(libelle, "UTF-8"));
                return;
            }

            // Vérifier la condition : reste < 2 * dépense
            double totalDepenses = Depense.getTotalDepensesByLibelle(user.getId(), libelle);
            double montantLigneCredit = ligneCredit.getMontant();
            double reste = montantLigneCredit - totalDepenses;
            if (reste < 2 * montant) {
                req.setAttribute("error", "Le reste (" + reste + ") doit être inférieur à 2 fois la dépense (" + (2 * montant) + ").");
                res.sendRedirect("depenses.jsp?libelle=" + java.net.URLEncoder.encode(libelle, "UTF-8"));
                return;
            }

            // Ajouter la dépense
            Depense depense = new Depense(libelle, montant, user.getId());
            depense.save();

            // Rediriger vers la page des dépenses
            res.sendRedirect("depenses.jsp?libelle=" + java.net.URLEncoder.encode(libelle, "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Erreur lors de l'ajout de la dépense : " + e.getMessage());
            res.sendRedirect("depenses.jsp?libelle=" + java.net.URLEncoder.encode(libelle, "UTF-8"));
        }
    }
}