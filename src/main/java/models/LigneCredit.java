package models;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class LigneCredit {
    private int id;
    private String libelle;
    private double montant;
    private int userId;
    private Date dateDebut; // Nouvelle propriété pour la date de début
    private Date dateFin;   // Nouvelle propriété pour la date de fin

    public LigneCredit() {}

    public LigneCredit(String libelle, double montant, int userId, Date dateDebut, Date dateFin) {
        this.libelle = libelle;
        this.montant = montant;
        this.userId = userId;
        this.dateDebut = dateDebut;
        this.dateFin = dateFin;
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

    public Date getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(Date dateDebut) {
        this.dateDebut = dateDebut;
    }

    public Date getDateFin() {
        return dateFin;
    }

    public void setDateFin(Date dateFin) {
        this.dateFin = dateFin;
    }

    // Méthode pour sauvegarder la ligne de crédit dans la base de données
    public void save() throws SQLException {
        String query = "INSERT INTO ligne_credit (libelle, montant, user_id, date_debut, date_fin) VALUES (?, ?, ?, ?, ?)";
        try (Connection connection = new Connexion().getConnexion();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, this.libelle);
            preparedStatement.setDouble(2, this.montant);
            preparedStatement.setInt(3, this.userId);
            preparedStatement.setDate(4, new java.sql.Date(this.dateDebut.getTime()));
            preparedStatement.setDate(5, new java.sql.Date(this.dateFin.getTime()));
            preparedStatement.executeUpdate();
            System.out.println("Ligne de crédit ajoutée avec succès !");
        }
    }

    // Méthode pour récupérer toutes les lignes de crédit d'un utilisateur
    public static List<LigneCredit> getLignesCreditByUser(int userId) throws SQLException {
        List<LigneCredit> lignesCredit = new ArrayList<>();
        String query = "SELECT * FROM ligne_credit WHERE user_id = ?";
        try (Connection connection = new Connexion().getConnexion();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setInt(1, userId);
            ResultSet rs = preparedStatement.executeQuery();
            while (rs.next()) {
                LigneCredit ligne = new LigneCredit();
                ligne.setId(rs.getInt("id"));
                ligne.setLibelle(rs.getString("libelle"));
                ligne.setMontant(rs.getDouble("montant"));
                ligne.setUserId(rs.getInt("user_id"));
                ligne.setDateDebut(rs.getDate("date_debut"));
                ligne.setDateFin(rs.getDate("date_fin"));
                lignesCredit.add(ligne);
            }
        }
        return lignesCredit;
    }

    // Méthode pour récupérer une ligne de crédit par libellé et utilisateur
    public static LigneCredit getLigneCreditByLibelle(int userId, String libelle) throws SQLException {
        String query = "SELECT * FROM ligne_credit WHERE user_id = ? AND libelle = ? LIMIT 1";
        try (Connection connection = new Connexion().getConnexion();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setInt(1, userId);
            preparedStatement.setString(2, libelle);
            ResultSet rs = preparedStatement.executeQuery();
            if (rs.next()) {
                LigneCredit ligne = new LigneCredit();
                ligne.setId(rs.getInt("id"));
                ligne.setLibelle(rs.getString("libelle"));
                ligne.setMontant(rs.getDouble("montant"));
                ligne.setUserId(rs.getInt("user_id"));
                ligne.setDateDebut(rs.getDate("date_debut"));
                ligne.setDateFin(rs.getDate("date_fin"));
                return ligne;
            }
        }
        return null;
    }
}