package com.inventory.controller;

import com.inventory.dao.SalesDAO;
import com.inventory.model.Sale;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/bill-servlet")
public class BillServlet extends HttpServlet {

    private SalesDAO salesDAO;

    public void init() {
        salesDAO = new SalesDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String transactionId = request.getParameter("transactionId");
        
        if (transactionId != null) {
            List<Sale> items = salesDAO.getItemsByTransactionId(transactionId);
            
            JSONArray jsonArray = new JSONArray();
            for (Sale s : items) {
                JSONObject json = new JSONObject();
                json.put("name", s.getProductName());
                json.put("qty", s.getQuantity());
                json.put("total", s.getTotalPrice());
                jsonArray.put(json);
            }
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print(jsonArray.toString());
            out.flush();
        }
    }
}