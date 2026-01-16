package com.inventory.controller;

import com.inventory.dao.CategoryDAO;
import com.inventory.dao.ProductDAO;
import com.inventory.model.Product;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/product-servlet")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class ProductServlet extends HttpServlet {

    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    public void init() {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            productDAO.deleteProduct(id);
            String referer = request.getHeader("referer");
            response.sendRedirect(referer != null ? referer : "dashboard.jsp");
        } else if ("search".equals(action)) {
            String query = request.getParameter("q");
            String category = request.getParameter("category");
            List<Product> products = productDAO.searchProducts(query, category);
            
            JSONArray jsonArray = new JSONArray();
            for (Product p : products) {
                JSONObject json = new JSONObject();
                json.put("id", p.getId());
                json.put("name", p.getName());
                json.put("category", p.getCategory());
                json.put("price", p.getPrice());
                json.put("stock", p.getStockQuantity());
                json.put("image", p.getImage());
                json.put("supplier", p.getSupplier());
                jsonArray.put(json);
            }
            
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            out.print(jsonArray.toString());
            out.flush();
        } else {
            String referer = request.getHeader("referer");
            response.sendRedirect(referer != null ? referer : "dashboard.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            saveProduct(request, response, false);
        } else if ("update".equals(action)) {
            saveProduct(request, response, true);
        } else if ("addCategory".equals(action)) {
            addCategory(request, response);
        } else if ("deleteCategory".equals(action)) {
            deleteCategory(request, response);
        }
    }

    private void saveProduct(HttpServletRequest request, HttpServletResponse response, boolean isUpdate) throws IOException, ServletException {
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        double price = Double.parseDouble(request.getParameter("price"));
        
        double purchasePrice = 0.0;
        String ppStr = request.getParameter("purchasePrice");
        if (ppStr != null && !ppStr.isEmpty()) {
            purchasePrice = Double.parseDouble(ppStr);
        } else {
            purchasePrice = price * 0.7; // Default if not provided
        }

        int quantity = Integer.parseInt(request.getParameter("quantity"));
        String supplier = request.getParameter("supplier");

        String imageFileName = "default.png";
        Part filePart = request.getPart("image");

        if (filePart != null && filePart.getSize() > 0) {
            imageFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();
            filePart.write(uploadPath + File.separator + imageFileName);
        } else if (isUpdate) {
            imageFileName = request.getParameter("oldImage");
        }

        if (isUpdate) {
            int id = Integer.parseInt(request.getParameter("id"));
            Product product = new Product(id, name, category, purchasePrice, price, quantity, imageFileName, supplier);
            productDAO.updateProduct(product);
        } else {
            Product product = new Product(0, name, category, purchasePrice, price, quantity, imageFileName, supplier);
            productDAO.addProduct(product);
        }

        response.sendRedirect("products.jsp");
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String newCategory = request.getParameter("categoryName");
        response.setContentType("text/plain");
        if (newCategory != null && !newCategory.trim().isEmpty()) {
            boolean added = categoryDAO.addCategory(newCategory);
            response.getWriter().write(added ? "success" : "error");
        } else {
            response.getWriter().write("error");
        }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String name = request.getParameter("name");
        response.setContentType("text/plain");
        if(name != null) {
            categoryDAO.deleteCategory(name);
            response.getWriter().write("success");
        } else {
            response.getWriter().write("error");
        }
    }
}