<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="models.User, models.Depense, models.LigneCredit, java.util.List, java.util.HashSet, java.util.Set, java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tableau de bord</title>
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
    %>
    <h2>Tableau de bord</h2>
    <table border="1">
        <tr>
            <th>Ligne de crédit (Libellé)</th>
            <th>Montant initial</th>
            <th>Date de début</th>
            <th>Date de fin</th>
            <th>Montant des dépenses</th>
            <th>Reste</th>
        </tr>
        <%
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
            Set<String> libelles = new HashSet<>();
            try {
                String query = "SELECT DISTINCT libelle FROM ligne_credit WHERE user_id = ?";
                java.sql.Connection connection = new models.Connexion().getConnexion();
                java.sql.PreparedStatement stmt = connection.prepareStatement(query);
                stmt.setInt(1, user.getId());
                java.sql.ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    libelles.add(rs.getString("libelle"));
                }
                rs.close();
                stmt.close();
                connection.close();
            } catch (Exception e) {
                e.printStackTrace();
            }

            for (String libelle : libelles) {
                LigneCredit ligneCredit = LigneCredit.getLigneCreditByLibelle(user.getId(), libelle);
                double montantLigneCredit = ligneCredit.getMontant();
                double totalDepenses = Depense.getTotalDepensesByLibelle(user.getId(), libelle);
                double reste = montantLigneCredit - totalDepenses;
        %>
            <tr>
                <td><%= libelle %></td>
                <td><%= montantLigneCredit %></td>
                <td><%= dateFormat.format(ligneCredit.getDateDebut()) %></td>
                <td><%= dateFormat.format(ligneCredit.getDateFin()) %></td>
                <td><%= totalDepenses %></td>
                <td><%= reste %></td>
            </tr>
        <%
            }
        %>
    </table>

    <p><a href="welcome.jsp">Retour</a></p>
    <p><a href="logout">Se déconnecter</a></p>
</body>
</html>