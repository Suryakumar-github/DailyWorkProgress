package fileHandler;

import model.User;

import java.util.List;

public interface UserHandler {

    void addUser(User user);

    List<User> getUsers();
}
