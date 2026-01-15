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
    
