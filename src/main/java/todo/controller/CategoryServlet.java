package todo.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import todo.persistence.HibernateDB;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class CategoryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("json");
        ObjectMapper mapper = new ObjectMapper();
        String jsonCategories = mapper.writeValueAsString(HibernateDB.instOf().allCategories());
        resp.getWriter().write(jsonCategories);
    }
}
