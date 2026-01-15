package com.inventory.model;

public class Supplier {
    private int id;
    private String name;
    private String contactPerson;
    private String phone;
    private String email;

    public Supplier(int id, String name, String contactPerson, String phone, String email) {
        this.id = id;
        this.name = name;
        this.contactPerson = contactPerson;
        this.phone = phone;
        this.email = email;
    }

    public int getId() { return id; }
    public String getName() { return name; }
    public String getContactPerson() { return contactPerson; }
    public String getPhone() { return phone; }
    public String getEmail() { return email; }
}