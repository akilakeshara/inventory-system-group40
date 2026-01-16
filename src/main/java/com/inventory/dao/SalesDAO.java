package com.inventory.dao;

import com.inventory.model.Sale;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class SalesDAO {

    public void recordSale(String transactionId, int productId, String productName, int quantity, double totalPrice) {
        String sql = "INSERT INTO sales (transaction_id, product_id, product_name, quantity, total_price) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {

            pst.setString(1, transactionId);
            pst.setInt(2, productId);
            pst.setString(3, productName);
            pst.setInt(4, quantity);
            pst.setDouble(5, totalPrice);

            pst.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Sale> getRecentTransactions() {
        List<Sale> sales = new ArrayList<>();
        String sql = "SELECT * FROM sales ORDER BY sale_date DESC LIMIT 10";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {
                sales.add(new Sale(
                    rs.getInt("id"),
                    rs.getString("transaction_id"),
                    rs.getInt("product_id"),
                    rs.getString("product_name"),
                    rs.getInt("quantity"),
                    rs.getDouble("total_price"),
                    rs.getTimestamp("sale_date")
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return sales;
    }

    public Map<String, List<Sale>> getRecentTransactionGroups() {
        Map<String, List<Sale>> transactionGroups = new LinkedHashMap<>();
        // Fixed: MySQL does not support LIMIT in IN subquery. Used JOIN instead.
        String sql = "SELECT s.* FROM sales s " +
                     "JOIN (SELECT transaction_id FROM sales GROUP BY transaction_id ORDER BY MAX(sale_date) DESC LIMIT 5) dt " +
                     "ON s.transaction_id = dt.transaction_id " +
                     "ORDER BY s.sale_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {
                String transactionId = rs.getString("transaction_id");
                Sale sale = new Sale(
                    rs.getInt("id"),
                    transactionId,
                    rs.getInt("product_id"),
                    rs.getString("product_name"),
                    rs.getInt("quantity"),
                    rs.getDouble("total_price"),
                    rs.getTimestamp("sale_date")
                );
                transactionGroups.computeIfAbsent(transactionId, k -> new ArrayList<>()).add(sale);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return transactionGroups;
    }

    public List<Sale> getAllTransactions() {
        List<Sale> sales = new ArrayList<>();
        String sql = "SELECT MAX(id) as id, transaction_id, COUNT(product_id) as item_count, SUM(total_price) as total_bill, MAX(sale_date) as date " +
                     "FROM sales GROUP BY transaction_id ORDER BY date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {
                sales.add(new Sale(
                    rs.getInt("id"),
                    rs.getString("transaction_id"),
                    0, 
                    rs.getInt("item_count") + " Items",
                    rs.getInt("item_count"),
                    rs.getDouble("total_bill"),
                    rs.getTimestamp("date")
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return sales;
    }

    public List<Sale> getItemsByTransactionId(String transactionId) {
        List<Sale> items = new ArrayList<>();
        String sql = "SELECT * FROM sales WHERE transaction_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
            
            pst.setString(1, transactionId);
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                items.add(new Sale(
                    rs.getInt("id"),
                    rs.getString("transaction_id"),
                    rs.getInt("product_id"),
                    rs.getString("product_name"),
                    rs.getInt("quantity"),
                    rs.getDouble("total_price"),
                    rs.getTimestamp("sale_date")
                ));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return items;
    }

    public double getTotalRevenue() {
        String sql = "SELECT SUM(total_price) FROM sales";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public double getTotalCOGS() {
        String sql = "SELECT SUM(s.quantity * p.purchase_price) FROM sales s JOIN products p ON s.product_id = p.id";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getTotalItemsSold() {
        String sql = "SELECT SUM(quantity) FROM sales";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public Map<String, Double> getLast7DaysRevenue() {
        return getRevenueTrend(7);
    }

    public Map<String, Double> getRevenueTrend(int days) {
        Map<String, Double> map = new LinkedHashMap<>();
        String sql = "SELECT DATE_FORMAT(sale_date, '%b %d') as sdate, SUM(total_price) as total " +
                     "FROM sales " +
                     "WHERE sale_date >= DATE_SUB(CURDATE(), INTERVAL ? DAY) " +
                     "GROUP BY DATE(sale_date), DATE_FORMAT(sale_date, '%b %d') " +
                     "ORDER BY DATE(sale_date) ASC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
             pst.setInt(1, days);
             ResultSet rs = pst.executeQuery();
             while (rs.next()) {
                 map.put(rs.getString("sdate"), rs.getDouble("total"));
             }
        } catch (SQLException e) { e.printStackTrace(); }
        
        if (map.isEmpty()) {
            map.put("Today", 0.0);
        }
        return map;
    }

    public Map<String, Integer> getTopSellingProducts(int limit) {
        Map<String, Integer> map = new LinkedHashMap<>();
        String sql = "SELECT product_name, SUM(quantity) as total_quantity " +
                     "FROM sales " +
                     "GROUP BY product_name " +
                     "ORDER BY total_quantity DESC " +
                     "LIMIT ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(sql)) {
             pst.setInt(1, limit);
             ResultSet rs = pst.executeQuery();
             while (rs.next()) {
                 map.put(rs.getString("product_name"), rs.getInt("total_quantity"));
             }
        } catch (SQLException e) { e.printStackTrace(); }
        return map;
    }
}