<!-- register.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Inscription</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <h2>Inscription</h2>
    <form action="register" method="post">
        <div>
            <label for="username">Nom d'utilisateur</label>
            <input type="text" id="username" name="nom">
            
            <label for="password">Mot de passe</label>
            <input type="password" id="password" name="mdp">
        </div>
        <button type="submit">S'inscrire</button>
    </form>
    <a href="index.html">Retour à la connexion</a>
</body>
</html>