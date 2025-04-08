package models;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Connexion {
    private static final String URL = "jdbc:mysql://localhost:3306/db_s2_ETU003271";
    private static final String USER = "ETU003271_tomcat";
    private static final String PASSWORD = "Axi5vybr";

    public Connection getConnexion() throws SQLException {
        Connection connection = null;
        try {
            // Charger explicitement le driver JDBC
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Connection successful!");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new SQLException("MySQL JDBC Driver not found", e);
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return connection;
    }
}