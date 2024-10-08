package dao;

import fileHandler.UserFileHandler;
import fileHandler.UserHandler;
import model.User;

import java.util.ArrayList;
import java.util.List;

public class UserDAOImpl implements UserDAO {

    private final UserHandler userHandler = new UserFileHandler();
    private static UserDAOImpl instance;
    private List<User> users = new ArrayList<>();;

    private UserDAOImpl() {}

    public static UserDAOImpl getInstance() {
        if(instance == null)
        {
            instance = new UserDAOImpl();
        }
        return instance;
    }

    @Override
    public void addUser(User user) {
        users.add(user);
        userHandler.addUser(user);
    }

    @Override
    public List<User> getUser() {
       return users;
    }

    @Override
    public void setUsers(List<User> users) {
        this.users  = users;
    }

}
