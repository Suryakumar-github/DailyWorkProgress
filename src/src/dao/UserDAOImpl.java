package dao;

import fileHandler.UserHandler;
import model.User;

import java.util.ArrayList;
import java.util.List;

public class UserDAOImpl implements UserDAO {
    private static UserDAOImpl instance;
    private List<User> users;
    UserHandler userHandler ;

    private UserDAOImpl(UserHandler userHandler) {
        this.userHandler = userHandler;
        users = new ArrayList<>();
    }

    public static UserDAOImpl getInstance(UserHandler userHandler) {
        if(instance == null)
        {
            instance = new UserDAOImpl(userHandler);
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
    public boolean isValidUser(String userName, String password) {

        for(User user : users ) {
            if(user.getUserName().trim().equals(userName.trim()) && user.getPassword().trim().equals(password.trim())) {
                return true;
            }
        }
        return false;
    }

    @Override
    public void setUsers(List<User> users) {
        this.users  = users;
    }

}
