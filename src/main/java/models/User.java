package models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class User extends BaseObject {
    private String username;
    private String password;

    public User() {}

    public User(int id, String username, String password) {
        super(id);
        this.username = username;
        this.password = password;
    }

    public User(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void save() throws SQLException {
        // Modifier la requête pour correspondre à la table "utilisateur" et ses colonnes "nom" et "mdp"
        String query = "INSERT INTO utilisateur_N (nom, mdp) VALUES (?, ?)";
        try (Connection connection = new Connexion().getConnexion();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, this.username); // "nom" correspond à username
            preparedStatement.setString(2, this.password); // "mdp" correspond à password
            preparedStatement.executeUpdate();
            System.out.println("Utilisateur ajouté avec succès!");
        }
    }

    public static User login(String username, String password) throws SQLException {
        // Modifier également la requête de login pour utiliser la table "utilisateur"
        String query = "SELECT * FROM utilisateur_N WHERE nom = ? AND mdp = ?";
        try (Connection connection = new Connexion().getConnexion();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, password);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                return new User(rs.getInt("id"), rs.getString("nom"), rs.getString("mdp"));
            }
            return null;
        }
    }
}