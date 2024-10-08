package dao;

import model.User;

import java.util.List;
public interface UserDAO {
    void addUser(User user);
    List<User> getUser();
    void setUsers(List<User> users);
}