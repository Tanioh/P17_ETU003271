<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.User, models.Depense, models.LigneCredit, java.util.List, java.util.Date, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lignes de dépense</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <%
        User user = null;
        if (session != null) {
            user = (User) session.getAttribute("user");
        }

        if (user == null) {
            response.sendRedirect("index.html");
            return;
        }

        // Récupérer toutes les lignes de crédit de l'utilisateur
        List<LigneCredit> lignesCredit = LigneCredit.getLignesCreditByUser(user.getId());
        if (lignesCredit.isEmpty()) {
            out.println("<p>Aucune ligne de crédit disponible. Veuillez en ajouter une d'abord.</p>");
            out.println("<p><a href='welcome.jsp'>Retour</a></p>");
            return;
        }

        // Récupérer le libellé sélectionné (si fourni)
        String selectedLibelle = request.getParameter("libelle");
        if (selectedLibelle == null && !lignesCredit.isEmpty()) {
            selectedLibelle = lignesCredit.get(0).getLibelle(); // Sélectionner la première ligne de crédit par défaut
        }

        // Récupérer les informations de la ligne de crédit sélectionnée
        LigneCredit selectedLigne = LigneCredit.getLigneCreditByLibelle(user.getId(), selectedLibelle);
        double montantLigneCredit = 0;
        Date dateDebut = null;
        Date dateFin = null;
        if (selectedLigne != null) {
            montantLigneCredit = selectedLigne.getMontant();
            dateDebut = selectedLigne.getDateDebut();
            dateFin = selectedLigne.getDateFin();
        }

        // Vérifier si la date actuelle est dans la période de validité
        Date today = new Date();
        boolean isWithinPeriod = dateDebut != null && dateFin != null && today.after(dateDebut) && today.before(dateFin);

        // Récupérer le total des dépenses pour ce libelle
        double totalDepenses = Depense.getTotalDepensesByLibelle(user.getId(), selectedLibelle);
        double reste = montantLigneCredit - totalDepenses;
    %>
    <h2>Lignes de dépense</h2>

    <!-- Liste déroulante pour sélectionner une ligne de crédit -->
    <form action="depenses.jsp" method="get">
        <label for="libelle">Sélectionner une ligne de crédit :</label>
        <select name="libelle" id="libelle" onchange="this.form.submit()">
            <%
                for (LigneCredit ligne : lignesCredit) {
                    String libelleOption = ligne.getLibelle();
                    String selected = libelleOption.equals(selectedLibelle) ? "selected" : "";
            %>
                <option value="<%= libelleOption %>" <%= selected %>><%= libelleOption %></option>
            <%
                }
            %>
        </select>
    </form>

    <%
        if (selectedLigne != null) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
    %>
        <h3>Détails de la ligne de crédit : <%= selectedLibelle %></h3>
        <p>Montant initial de la ligne de crédit : <%= montantLigneCredit %></p>
        <p>Date de début : <%= dateFormat.format(dateDebut) %></p>
        <p>Date de fin : <%= dateFormat.format(dateFin) %></p>
        <p>Total des dépenses : <%= totalDepenses %></p>
        <p>Reste : <%= reste %></p>

        <!-- Formulaire pour ajouter une dépense -->
        <h3>Ajouter une dépense</h3>
        <form action="addDepense" method="post">
            <input type="hidden" name="libelle" value="<%= selectedLibelle %>">
            <div>
                <label for="montant">Montant de la dépense :</label>
                <input type="number" id="montant" name="montant" step="0.01" required>
            </div>
            <%
                // Vérifier la condition : reste < 2 * dépense
                String montantDepenseStr = request.getParameter("montant");
                boolean canAddDepense = true;
                String errorMessage = "";
                if (!isWithinPeriod) {
                    canAddDepense = false;
                    errorMessage = "Erreur : La date actuelle (" + dateFormat.format(today) + ") n'est pas dans la période de validité (" + dateFormat.format(dateDebut) + " - " + dateFormat.format(dateFin) + ").";
                } else if (montantDepenseStr != null) {
                    try {
                        double montantDepense = Double.parseDouble(montantDepenseStr);
                        if (reste < 2 * montantDepense) {
                            canAddDepense = false;
                            errorMessage = "Erreur : Le reste (" + reste + ") doit être inférieur à 2 fois la dépense (" + (2 * montantDepense) + ").";
                        }
                    } catch (NumberFormatException e) {
                        errorMessage = "Erreur : Montant invalide.";
                    }
                }
                if (!errorMessage.isEmpty()) {
                    out.println("<p style='color: red;'>" + errorMessage + "</p>");
                }
            %>
            <button type="submit" <%= canAddDepense ? "" : "disabled" %>>Ajouter la dépense</button>
        </form>

        <!-- Afficher les dépenses existantes -->
        <h3>Dépenses existantes</h3>
        <table border="1">
            <tr>
                <th>ID</th>
                <th>Libellé</th>
                <th>Montant</th>
            </tr>
            <%
                List<Depense> depenses = Depense.getDepensesByLibelle(user.getId(), selectedLibelle);
                for (Depense depense : depenses) {
            %>
                <tr>
                    <td><%= depense.getId() %></td>
                    <td><%= depense.getLibelle() %></td>
                    <td><%= depense.getMontant() %></td>
                </tr>
            <%
                }
            %>
        </table>
    <%
        }
    %>

    <p><a href="welcome.jsp">Retour</a></p>
    <p><a href="dashboard.jsp">Voir le tableau de bord</a></p>
</body>
</html>