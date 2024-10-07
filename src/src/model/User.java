package model;

public class User {
    String userName;
    String password;
    String name;

    public User(String name, String userName, String password) {
        this.name = name;
        this.userName = userName;
        this.password = password;
    }
    public String getUserName() {
        return userName;
    }
    public String getPassword() {
        return password;
    }
    public String getName() {
        return name;
    }
}
