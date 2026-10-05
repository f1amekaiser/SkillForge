package com.skillforge.controller;

import com.skillforge.dao.ServiceDAO;
import com.skillforge.model.Service;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/services", "/admin/services/action"})
public class AdminServiceServlet extends HttpServlet {

    private final ServiceDAO serviceDAO = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Service> services = serviceDAO.getAllServices();
        request.setAttribute("services", services);
        request.getRequestDispatcher("/manage-services.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String serviceIdStr = request.getParameter("serviceId");
        String action = request.getParameter("action"); // "remove"

        if (serviceIdStr != null && "remove".equalsIgnoreCase(action)) {
            try {
                int serviceId = Integer.parseInt(serviceIdStr);
                serviceDAO.deleteService(serviceId);
            } catch (NumberFormatException ignored) {}
        }

        response.sendRedirect(request.getContextPath() + "/admin/services?msg=service_updated");
    }
}
