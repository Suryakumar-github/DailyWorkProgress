package dao;

import fileHandler.UserHandler;
import model.User;

import java.util.List;

public class UserDAOImpl implements UserDAO {

    public UserDAOImpl() {

    }

    @Override
    public void addUser(User user) {
        UserHandler.writeUserToCSV(user);
    }

    @Override
    public List<User> getUser() {
       return UserHandler.readUsersFromCSV();
    }

    @Override
    public boolean isValidUser(String userName, String password) {
        List<User> users = getUser();

        for(User user : users) {
            if(user.getUserName().trim().equals(userName.trim()) && user.getPassword().trim().equals(password.trim())) {
                return true;
            }
        }
        return false;
    }

}
