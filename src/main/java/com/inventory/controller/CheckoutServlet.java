package com.inventory.controller;

import com.inventory.dao.ProductDAO;
import com.inventory.dao.SalesDAO;
import com.inventory.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/checkout-servlet")
public class CheckoutServlet extends HttpServlet {

    private ProductDAO productDAO;
    private SalesDAO salesDAO;

    public void init() {
        productDAO = new ProductDAO();
        salesDAO = new SalesDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        StringBuilder sb = new StringBuilder();
        BufferedReader reader = request.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }

        try {
            JSONArray cartItems = new JSONArray(sb.toString());
            List<Product> productsToUpdate = new ArrayList<>();
            List<JSONObject> salesToRecord = new ArrayList<>();
            
            // Generate a unique Transaction ID for this entire bill
            String transactionId = "TRX-" + System.currentTimeMillis();

            // 1. Validate Stock for all items first
            for (int i = 0; i < cartItems.length(); i++) {
                JSONObject item = cartItems.getJSONObject(i);
                
                int id;
                Object idObj = item.get("id");
                if (idObj instanceof Integer) {
                    id = (Integer) idObj;
                } else {
                    id = Integer.parseInt(idObj.toString());
                }

                int qty = item.getInt("qty");
                
                double price;
                Object priceObj = item.get("price");
                if (priceObj instanceof Double) {
                    price = (Double) priceObj;
                } else if (priceObj instanceof Integer) {
                    price = ((Integer) priceObj).doubleValue();
                } else {
                    price = Double.parseDouble(priceObj.toString());
                }

                Product dbProduct = productDAO.getProductById(id);
                if (dbProduct == null) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("Product not found: ID " + id);
                    return;
                }
                
                if (dbProduct.getStockQuantity() < qty) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("Insufficient stock for: " + dbProduct.getName());
                    return;
                }
                
                dbProduct.setStockQuantity(dbProduct.getStockQuantity() - qty);
                productsToUpdate.add(dbProduct);
                
                JSONObject sale = new JSONObject();
                sale.put("product_id", id);
                sale.put("product_name", dbProduct.getName());
                sale.put("quantity", qty);
                sale.put("total_price", price * qty);
                salesToRecord.add(sale);
            }

            // 2. Commit changes
            for (Product p : productsToUpdate) {
                productDAO.updateProduct(p);
            }
            
            // 3. Record Sales with Transaction ID
            for (JSONObject sale : salesToRecord) {
                salesDAO.recordSale(
                    transactionId, // Pass the group ID
                    sale.getInt("product_id"),
                    sale.getString("product_name"),
                    sale.getInt("quantity"),
                    sale.getDouble("total_price")
                );
            }

            response.getWriter().write("success");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Server Error: " + e.getMessage());
        }
    }
}