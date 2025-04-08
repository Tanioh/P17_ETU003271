<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.User, models.LigneCredit, models.Depense, java.util.List, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bienvenue</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        h3 {
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <%
        User user = null;
        if (session != null) {
            user = (User) session.getAttribute("user");
        }

        if (user == null) {
            response.sendRedirect("index.html");
        } else {
    %>
        <h2>Bienvenue, <%= user.getUsername() %> !</h2>
        <p>Vous êtes maintenant connecté.</p>
        <p>Nom d'utilisateur : <%= user.getUsername() %></p>

        <!-- Formulaire pour ajouter une ligne de crédit -->
        <h3>Ajouter une ligne de crédit</h3>
        <form action="addCredit" method="post">
            <div>
                <label for="libelle">Libellé :</label>
                <input type="text" id="libelle" name="libelle" required>
            </div>
            <div>
                <label for="montant">Montant :</label>
                <input type="number" id="montant" name="montant" step="0.01" required>
            </div>
            <div>
                <label for="dateDebut">Date de début :</label>
                <input type="date" id="dateDebut" name="dateDebut" required>
            </div>
            <div>
                <label for="dateFin">Date de fin :</label>
                <input type="date" id="dateFin" name="dateFin" required>
            </div>
            <button type="submit">Ajouter</button>
        </form>

        <!-- Tableau de bord -->
        <h3>Tableau de bord</h3>
        <%
            List<LigneCredit> lignesCredit = LigneCredit.getLignesCreditByUser(user.getId());
            if (lignesCredit.isEmpty()) {
                out.println("<p>Aucune ligne de crédit disponible.</p>");
            } else {
                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        %>
            <table>
                <tr>
                    <th>Ligne de crédit (Libellé)</th>
                    <th>Montant initial</th>
                    <th>Date de début</th>
                    <th>Date de fin</th>
                    <th>Montant des dépenses</th>
                    <th>Reste</th>
                </tr>
                <%
                    for (LigneCredit ligne : lignesCredit) {
                        String libelle = ligne.getLibelle();
                        double montantLigneCredit = ligne.getMontant();
                        double totalDepenses = Depense.getTotalDepensesByLibelle(user.getId(), libelle);
                        double reste = montantLigneCredit - totalDepenses;
                %>
                    <tr>
                        <td><%= libelle %></td>
                        <td><%= montantLigneCredit %></td>
                        <td><%= dateFormat.format(ligne.getDateDebut()) %></td>
                        <td><%= dateFormat.format(ligne.getDateFin()) %></td>
                        <td><%= totalDepenses %></td>
                        <td><%= reste %></td>
                    </tr>
                <%
                    }
                %>
            </table>
        <%
            }
        %>

        <!-- Historique des lignes de crédit -->
        <h3>Historique des lignes de crédit</h3>
        <%
            if (lignesCredit.isEmpty()) {
                out.println("<p>Aucun historique disponible.</p>");
            } else {
                SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        %>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Libellé</th>
                    <th>Montant</th>
                    <th>Date de début</th>
                    <th>Date de fin</th>
                    <th>Utilisateur</th>
                </tr>
                <%
                    for (LigneCredit ligne : lignesCredit) {
                %>
                    <tr>
                        <td><%= ligne.getId() %></td>
                        <td><%= ligne.getLibelle() %></td>
                        <td><%= ligne.getMontant() %></td>
                        <td><%= dateFormat.format(ligne.getDateDebut()) %></td>
                        <td><%= dateFormat.format(ligne.getDateFin()) %></td>
                        <td><%= user.getUsername() %></td>
                    </tr>
                <%
                    }
                %>
            </table>
        <%
            }
        %>

        <p><a href="depenses.jsp">Gérer les dépenses</a></p>
        <p><a href="dashboard.jsp">Voir le tableau de bord détaillé</a></p>
        <p><a href="logout">Se déconnecter</a></p>
    <%
        }
    %>
</body>
</html>