package todo.persistence;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.boot.MetadataSources;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import todo.model.Task;
import java.util.List;

public class HibernateDB implements AutoCloseable {
    private static final HibernateDB INSTANCE = new HibernateDB();
    private final StandardServiceRegistry registry =
            new StandardServiceRegistryBuilder().configure().build();
    private final SessionFactory sf =
            new MetadataSources(registry).buildMetadata().buildSessionFactory();

    private HibernateDB() {
    }

    private Task create(Task task) {
        Session session = sf.openSession();
        session.beginTransaction();
        session.save(task);
        session.getTransaction().commit();
        return task;
    }

    private Task update(Task task) {
        Session session = sf.openSession();
        session.beginTransaction();
        session.update(task);
        session.getTransaction().commit();
        return task;
    }

    public static HibernateDB instOf() {
        return INSTANCE;
    }

    public Task save(Task task) {
        if (task.getId() == 0) {
            return create(task);
        } else {
            return update(task);
        }
    }

    public List<Task> findAll() {
        Session session = sf.openSession();
        session.beginTransaction();
        List<Task> list = session
                .createQuery("from todo.model.Task as task order by task.created desc").list();
        session.getTransaction().commit();
        return list;
    }

    public boolean delete(Integer id) {
        Session session = sf.openSession();
        session.beginTransaction();
        Task toDelete = new Task();
        toDelete.setId(id);
        session.delete(toDelete);
        session.getTransaction().commit();
        return true;
    }

    @Override
    public void close() throws Exception {
        StandardServiceRegistryBuilder.destroy(registry);
    }
}
