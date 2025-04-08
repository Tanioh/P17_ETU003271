package models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class Depense {
    private int id;
    private String libelle; // Le libelle de la ligne de crédit associée
    private double montant;
    private int userId;

    public Depense() {}

    public Depense(String libelle, double montant, int userId) {
        this.libelle = libelle;
        this.montant = montant;
        this.userId = userId;
    }

    // Getters et setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getLibelle() {
        return libelle;
    }

    public void setLibelle(String libelle) {
        this.libelle = libelle;
    }

    public double getMontant() {
        return montant;
    }

    public void setMontant(double montant) {
        this.montant = montant;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    // Méthode pour sauvegarder une dépense
    public void save() throws SQLException {
        String query = "INSERT INTO depense (libelle, montant, user_id) VALUES (?, ?, ?)";
        try (Connection connection = new Connexion().getConnexion();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, this.libelle);
            preparedStatement.setDouble(2, this.montant);
            preparedStatement.setInt(3, this.userId);
            preparedStatement.executeUpdate();
            System.out.println("Dépense ajoutée avec succès !");
        }
    }

    // Méthode pour récupérer toutes les dépenses d'un utilisateur pour un libelle donné
    public static List<Depense> getDepensesByLibelle(int userId, String libelle) throws SQLException {
        List<Depense> depenses = new ArrayList<>();
        String query = "SELECT * FROM depense WHERE user_id = ? AND libelle = ?";
        try (Connection connection = new Connexion().getConnexion();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setInt(1, userId);
            preparedStatement.setString(2, libelle);
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                Depense depense = new Depense();
                depense.setId(rs.getInt("id"));
                depense.setLibelle(rs.getString("libelle"));
                depense.setMontant(rs.getDouble("montant"));
                depense.setUserId(rs.getInt("user_id"));
                depenses.add(depense);
            }
        }
        return depenses;
    }

    // Méthode pour calculer le total des dépenses pour un libelle donné
    public static double getTotalDepensesByLibelle(int userId, String libelle) throws SQLException {
        double total = 0;
        String query = "SELECT SUM(montant) as total FROM depense WHERE user_id = ? AND libelle = ?";
        try (Connection connection = new Connexion().getConnexion();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setInt(1, userId);
            preparedStatement.setString(2, libelle);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                total = rs.getDouble("total");
            }
        }
        return total;
    }
}