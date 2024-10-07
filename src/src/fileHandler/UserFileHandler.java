package fileHandler;

import dao.UserDAO;
import dao.UserDAOImpl;
import model.User;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

public class UserFileHandler implements UserHandler{

    private final String USER_CSV_FILE = Paths.get("src", "files", "users.csv").toString();
    private final UserDAO userDAO = UserDAOImpl.getInstance(this);

    @Override
    public void addUser(User user) {

        try (FileWriter fileWriter = new FileWriter(USER_CSV_FILE, true)) {
            fileWriter.append(user.getName()).append(",");
            fileWriter.append(user.getUserName()).append(",");
            fileWriter.append(user.getPassword()).append("\n");
            System.out.println("User details successfully written to CSV.");
        } catch (IOException e) {
            System.out.println("Error while writing User to CSV: " + e.getMessage());
        }
    }


    @Override
    public List<User> getUsers() {

        List<User> users = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(USER_CSV_FILE))) {
            String line ;
            while ((line = br.readLine()) != null) {
                String[] userData = line.split(",");
                if (userData.length == 3) {
                    User user = new User(userData[0], userData[1], userData[2]);
                    users.add(user);
                }
            }
        } catch (IOException e) {
            System.out.println("Error while reading Users from CSV: " + e.getMessage());
        }
        userDAO.setUsers(users);
        return users;
    }


}
