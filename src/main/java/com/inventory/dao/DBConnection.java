package com.inventory.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Database Configuration
    private static final String URL = "jdbc:mysql://localhost:3306/inventory_system";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "12345678"; // <--- CHANGE THIS TO YOUR MYSQL PASSWORD

    public static Connection getConnection() {
        Connection connection = null;
        try {
            // Load the MySQL JDBC Driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Create the connection
            connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            System.out.println("Driver not found!");
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Connection failed!");
        }
        return connection;
    }

    // Main method to test the connection immediately
    public static void main(String[] args) {
        Connection con = getConnection();
        if (con != null) {
            System.out.println("✅ Database Connected Successfully!");
        } else {
            System.out.println("❌ Failed to connect.");
        }
    }
}