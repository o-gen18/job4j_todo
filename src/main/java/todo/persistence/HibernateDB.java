package todo.persistence;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.boot.MetadataSources;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import todo.model.*;
import java.util.List;
import java.util.function.Function;

public class HibernateDB implements AutoCloseable {
    private static final HibernateDB INSTANCE = new HibernateDB();
    private final StandardServiceRegistry registry =
            new StandardServiceRegistryBuilder().configure().build();
    private final SessionFactory sf =
            new MetadataSources(registry).buildMetadata().buildSessionFactory();

    private HibernateDB() {
    }

    private <T> T doTransaction(final Function<Session, T> command) {
        final Session session = sf.openSession();
        final Transaction tr = session.beginTransaction();
        try {
            T rsl = command.apply(session);
            tr.commit();
            return rsl;
        } catch (final Exception e) {
            session.getTransaction().rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    private Model create(Model model) {
        return this.doTransaction(session -> {
            session.save(model);
            return model;
        });
    }

    private Model update(Model model) {
        return this.doTransaction(session -> {
            session.update(model);
            return model;
        });
    }

    public static HibernateDB instOf() {
        return INSTANCE;
    }

    public Model save(Model model) {
        if (model.getId() == 0) {
            return create(model);
        } else {
            return update(model);
        }
    }

    public List<Task> findAll() {
        return this.doTransaction(session -> session
                .createQuery("from todo.model.Task as task order by task.created desc").list());
    }

    public List<Role> getRoles() {
        return this.doTransaction(session -> session
                .createQuery("from todo.model.Role as role order by role.id").list());
    }

    public boolean delete(Integer id) {
        Task toDelete = new Task();
        toDelete.setId(id);
        return this.doTransaction(session -> {
            session.delete(toDelete);
            return true;
        });
    }

    public User findUserByEmail(String email) {
        return (User) this.doTransaction(session ->
                session.createQuery("select user from todo.model.User as user where email =:email")
                        .setParameter("email", email)
                        .getResultList().stream()
                        .findFirst()
                        .orElse(null));
    }

    public Role findRoleByName(String roleName) {
        return (Role) this.doTransaction(session ->
            session.createQuery("select role from todo.model.Role as role where name =:roleName")
                    .setParameter("roleName", roleName)
                    .getResultList().stream()
                    .findFirst()
                    .orElse(null));
    }

    public List<Category> allCategories() {
        return this.doTransaction(session -> session
        .createQuery("from todo.model.Category as category order by category.id").list());
    }

    public Category findCategoryById(Integer id) {
        return this.doTransaction(session -> session.find(Category.class, id));
    }

    @Override
    public void close() throws Exception {
        StandardServiceRegistryBuilder.destroy(registry);
    }
}