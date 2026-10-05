package com.skillforge.controller;

import com.skillforge.dao.ServiceDAO;
import com.skillforge.model.Service;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/delete-service")
public class DeleteServiceServlet extends HttpServlet {

    private final ServiceDAO serviceDAO = new ServiceDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        int freelancerId = (Integer) session.getAttribute("userId");

        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int serviceId = Integer.parseInt(idStr);
                Service service = serviceDAO.getById(serviceId);
                if (service != null && service.getFreelancerId() == freelancerId) {
                    serviceDAO.deleteService(serviceId);
                }
            } catch (NumberFormatException ignored) {}
        }

        response.sendRedirect(request.getContextPath() + "/my-services?msg=service_deleted");
    }
}
