package com.inventory.controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String loginURI = req.getContextPath() + "/login.jsp";
        String loginServlet = req.getContextPath() + "/login";
        String publicURI = req.getContextPath() + "/index.jsp";
        String publicCSS = req.getContextPath() + "/css/"; // Allow CSS
        String publicJS = req.getContextPath() + "/js/";   // Allow JS
        String publicImages = req.getContextPath() + "/images/"; // Allow Images

        boolean loggedIn = (session != null && session.getAttribute("user") != null);
        boolean loginRequest = req.getRequestURI().equals(loginURI);
        boolean loginServletRequest = req.getRequestURI().equals(loginServlet);
        boolean publicRequest = req.getRequestURI().equals(publicURI) || req.getRequestURI().equals(req.getContextPath() + "/");
        boolean resourceRequest = req.getRequestURI().startsWith(publicCSS) || 
                                  req.getRequestURI().startsWith(publicJS) || 
                                  req.getRequestURI().startsWith(publicImages);

        if (loggedIn || loginRequest || loginServletRequest || publicRequest || resourceRequest) {
            chain.doFilter(request, response);
        } else {
            res.sendRedirect(loginURI);
        }
    }
}