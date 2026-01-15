package com.inventory.controller;

import com.inventory.dao.SupplierDAO;
import com.inventory.model.Supplier;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/supplier-servlet")
public class SupplierServlet extends HttpServlet {

    private SupplierDAO supplierDAO;

    public void init() {
        supplierDAO = new SupplierDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            String name = request.getParameter("name");
            String contact = request.getParameter("contact");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");

            Supplier supplier = new Supplier(0, name, contact, phone, email);
            supplierDAO.addSupplier(supplier);
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String contact = request.getParameter("contact");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");

            Supplier supplier = new Supplier(id, name, contact, phone, email);
            supplierDAO.updateSupplier(supplier);
        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            supplierDAO.deleteSupplier(id);
        }

        response.sendRedirect("suppliers.jsp");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            supplierDAO.deleteSupplier(id);
            response.sendRedirect("suppliers.jsp");
        }
    }
}