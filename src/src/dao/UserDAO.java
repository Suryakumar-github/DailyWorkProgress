package dao;

import model.User;

import java.util.List;

public interface UserDAO {
    void addUser(User user);
    List<User> getUser();
    boolean isValidUser(String userName, String password);
}
