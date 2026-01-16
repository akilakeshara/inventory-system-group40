package com.inventory.controller;

import com.inventory.dao.ExpenseDAO;
import com.inventory.model.Expense;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/expense-servlet")
public class ExpenseServlet extends HttpServlet {

    private ExpenseDAO expenseDAO;

    public void init() {
        expenseDAO = new ExpenseDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("expenses.jsp");
            return;
        }

        switch (action) {
            case "add":
                addExpense(request, response);
                break;
            case "update":
                updateExpense(request, response);
                break;
            default:
                response.sendRedirect("expenses.jsp");
                break;
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            deleteExpense(request, response);
        } else {
            response.sendRedirect("expenses.jsp");
        }
    }

    private void addExpense(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String description = request.getParameter("description");
        double amount = Double.parseDouble(request.getParameter("amount"));
        Date date = Date.valueOf(request.getParameter("date"));
        expenseDAO.addExpense(description, amount, date);
        response.sendRedirect("expenses.jsp");
    }

    private void updateExpense(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String description = request.getParameter("description");
        double amount = Double.parseDouble(request.getParameter("amount"));
        Date date = Date.valueOf(request.getParameter("date"));
        Expense expense = new Expense(id, description, amount, date);
        expenseDAO.updateExpense(expense);
        response.sendRedirect("expenses.jsp");
    }

    private void deleteExpense(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        expenseDAO.deleteExpense(id);
        response.sendRedirect("expenses.jsp");
    }
}