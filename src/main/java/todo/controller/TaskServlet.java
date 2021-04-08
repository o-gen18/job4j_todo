package todo.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import todo.model.Category;
import todo.model.Task;
import todo.model.User;
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
        resp.setContentType("json");
        ObjectMapper mapper = new ObjectMapper();
        String json = mapper.writeValueAsString(HibernateDB.instOf().findAll());
        resp.getWriter().write(json);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Task task = new Task();
        User user = (User) req.getSession().getAttribute("user");
        task.setAuthor(user);
        if (req.getParameter("id") == null) {
            String[] categoriesIds = req.getParameterValues("selectedCategories");
            for (String categoryId : categoriesIds) {
                Category category = HibernateDB.instOf()
                        .findCategoryById(Integer.parseInt(categoryId));
                task.addCategory(category);
            }
            task.setName(req.getParameter("description"));
            task.setDone(false);
        } else {
            String[] categoriesIds = req.getParameterValues("categoryIds");
            for (String categoryId : categoriesIds) {
                Category category = HibernateDB.instOf()
                        .findCategoryById(Integer.parseInt(categoryId));
                task.addCategory(category);
            }
            task.setId(Integer.parseInt(req.getParameter("id")));
            task.setName(req.getParameter("description"));
            task.setCreated(new Date(Long.parseLong(req.getParameter("created"))));
            task.setDone(Boolean.parseBoolean(req.getParameter("done")));
        }
        HibernateDB.instOf().save(task);
    }
}