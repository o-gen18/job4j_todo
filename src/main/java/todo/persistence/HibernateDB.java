package todo.persistence;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.boot.MetadataSources;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import todo.model.Task;
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

    private Task create(Task task) {
        return this.doTransaction(session -> {
            session.save(task);
            return task;
        });
    }

    private Task update(Task task) {
        return this.doTransaction(session -> {
            session.update(task);
            return task;
        });
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
        return this.doTransaction(session -> session
                .createQuery("from todo.model.Task as task order by task.created desc").list());
    }

    public boolean delete(Integer id) {
        Task toDelete = new Task();
        toDelete.setId(id);
        return this.doTransaction(session -> {
            session.delete(toDelete);
            return true;
        });
    }

    @Override
    public void close() throws Exception {
        StandardServiceRegistryBuilder.destroy(registry);
    }
}
