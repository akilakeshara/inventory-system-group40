package com.inventory.dao;

import com.inventory.model.Product;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {
                products.add(new Product(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("category"),
                        rs.getDouble("purchase_price"), // NEW
                        rs.getDouble("price"),
                        rs.getInt("stock_quantity"),
                        rs.getString("image"),
                        rs.getString("supplier")
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return products;
    }

    public List<Product> searchProducts(String query, String category) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE name LIKE ?");

        boolean hasCategory = category != null && !category.isEmpty() && !"all".equalsIgnoreCase(category);
        if (hasCategory) {
            sql.append(" AND category = ?");
        }
        sql.append(" ORDER BY id DESC");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql.toString())) {

            pst.setString(1, "%" + query + "%");
            if (hasCategory) {
                pst.setString(2, category);
            }

            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                products.add(new Product(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("category"),
                        rs.getDouble("purchase_price"),
                        rs.getDouble("price"),
                        rs.getInt("stock_quantity"),
                        rs.getString("image"),
                        rs.getString("supplier")
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return products;
    }

    public Product getProductById(int id) {
        Product product = null;
        String sql = "SELECT * FROM products WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setInt(1, id);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                product = new Product(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("category"),
                        rs.getDouble("purchase_price"), // NEW
                        rs.getDouble("price"),
                        rs.getInt("stock_quantity"),
                        rs.getString("image"),
                        rs.getString("supplier")
                );
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return product;
    }

