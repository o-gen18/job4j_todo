package todo.controller;

import todo.model.Task;
import todo.persistence.HibernateDB;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class DeleteTaskServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
        String id = req.getParameter("id");
        HibernateDB.instOf().delete(Integer.parseInt(id));
    }
}