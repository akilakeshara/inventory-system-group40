package com.inventory.model;

import java.sql.Date;

public class Expense {
    private int id;
    private String description;
    private double amount;
    private Date date;

    public Expense(int id, String description, double amount, Date date) {
        this.id = id;
        this.description = description;
        this.amount = amount;
        this.date = date;
    }

    public int getId() { return id; }
    public String getDescription() { return description; }
    public double getAmount() { return amount; }
    public Date getDate() { return date; }
}