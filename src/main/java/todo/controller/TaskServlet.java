package todo.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import todo.model.Task;
import todo.persistence.HibernateDB;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.Date;

public class TaskServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json");
        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(HibernateDB.instOf().findAll());
        resp.getWriter().write(json);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Task task = new Task();
        if (req.getParameter("id") == null) {
            task.setDescription(req.getParameter("description"));
            task.setCreated(new Timestamp(new Date().getTime()));
            task.setDone(false);
        } else {
            task.setId(Integer.parseInt(req.getParameter("id")));
            task.setDescription(req.getParameter("description"));
            task.setCreated(new Timestamp(Long.parseLong(req.getParameter("created"))));
            task.setDone(Boolean.parseBoolean(req.getParameter("done")));
        }
        HibernateDB.instOf().save(task);
    }
}
