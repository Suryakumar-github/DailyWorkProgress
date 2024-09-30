package fileHandler;

import model.User;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class UserHandler {

    private static final String USER_CSV_FILE = "src/files/users.csv";
    private static final String HEADER = "Name,Username,Password";

    public static void writeUserToCSV(User user) {
        try (FileWriter fileWriter = new FileWriter(USER_CSV_FILE, true)) {
            fileWriter.append(user.getName()).append(",");
            fileWriter.append(user.getUserName()).append(",");
            fileWriter.append(user.getPassword()).append("\n");
            System.out.println("User details successfully written to CSV.");
        } catch (IOException e) {
            System.out.println("Error while writing User to CSV: " + e.getMessage());
        }
    }

    public static List<User> readUsersFromCSV() {
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
        return users;
    }

    public static void createUserCSV() {
        try (FileWriter fileWriter = new FileWriter(USER_CSV_FILE)) {
            fileWriter.append(HEADER).append("\n");
            System.out.println("User CSV file created/reset with header.");
        } catch (IOException e) {
            System.out.println("Error while creating User CSV: " + e.getMessage());
        }
    }

}
