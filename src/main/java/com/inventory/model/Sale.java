package com.inventory.model;

import java.sql.Timestamp;

public class Sale {
    private int id;
    private String transactionId; // NEW: Group ID for multiple items in one bill
    private int productId;
    private String productName;
    private int quantity;
    private double totalPrice;
    private Timestamp saleDate;

    public Sale(int id, String transactionId, int productId, String productName, int quantity, double totalPrice, Timestamp saleDate) {
        this.id = id;
        this.transactionId = transactionId;
        this.productId = productId;
        this.productName = productName;
        this.quantity = quantity;
        this.totalPrice = totalPrice;
        this.saleDate = saleDate;
    }

    public int getId() { return id; }
    public String getTransactionId() { return transactionId; }
    public int getProductId() { return productId; }
    public String getProductName() { return productName; }
    public int getQuantity() { return quantity; }
    public double getTotalPrice() { return totalPrice; }
    public Timestamp getSaleDate() { return saleDate; }
}