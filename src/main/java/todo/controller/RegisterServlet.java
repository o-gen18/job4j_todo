package todo.controller;

import todo.model.Role;
import todo.model.User;
import todo.persistence.HibernateDB;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class RegisterServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String roleName = req.getParameter("role");
        HibernateDB hibernate = HibernateDB.instOf();
        Role role = hibernate.findRoleByName(roleName);
        if (role == null) {
            role = Role.of(roleName);
            hibernate.save(role);
        }
        User user = hibernate.findUserByEmail(email);
        if (user != null) {
            resp.sendError(500, "Such email already exists, type different!");
        } else {
            user = (User) hibernate.save(
                    User.of(name, email, role, password));
            HttpSession sc = req.getSession();
            sc.setAttribute("user", user);
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        }
    }
}
