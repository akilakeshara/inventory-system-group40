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

    public boolean addProduct(Product product) {
        String sql = "INSERT INTO products (name, category, purchase_price, price, stock_quantity, image, supplier) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setString(1, product.getName());
            pst.setString(2, product.getCategory());
            pst.setDouble(3, product.getPurchasePrice()); // NEW
            pst.setDouble(4, product.getPrice());
            pst.setInt(5, product.getStockQuantity());
            pst.setString(6, product.getImage());
            pst.setString(7, product.getSupplier());

            return pst.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean updateProduct(Product product) {
        String sql = "UPDATE products SET name=?, category=?, purchase_price=?, price=?, stock_quantity=?, image=?, supplier=? WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setString(1, product.getName());
            pst.setString(2, product.getCategory());
            pst.setDouble(3, product.getPurchasePrice()); // NEW
            pst.setDouble(4, product.getPrice());
            pst.setInt(5, product.getStockQuantity());
            pst.setString(6, product.getImage());
            pst.setString(7, product.getSupplier());
            pst.setInt(8, product.getId());

            return pst.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public void deleteProduct(int id) {
        String sql = "DELETE FROM products WHERE id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            pst.setInt(1, id);
            pst.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }
}