package com.inventory.model;

public class Product {
    private int id;
    private String name;
    private String category;
    private double purchasePrice; // NEW
    private double price; // Selling Price
    private int stockQuantity;
    private String image;
    private String supplier;

    public Product(int id, String name, String category, double purchasePrice, double price, int stockQuantity, String image, String supplier) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.purchasePrice = purchasePrice;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.image = image;
        this.supplier = supplier;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public double getPurchasePrice() { return purchasePrice; }
    public void setPurchasePrice(double purchasePrice) { this.purchasePrice = purchasePrice; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public String getSupplier() { return supplier; }
    public void setSupplier(String supplier) { this.supplier = supplier; }
}