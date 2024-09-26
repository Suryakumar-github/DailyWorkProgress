package model;

public class User extends Passenger{
    String userName;
    String password;

    public User(String name, String userName, String password) {
        super(name);
        this.userName = userName;
        this.password = password;
    }
    public String getUserName() {
        return userName;
    }
    public String getPassword() {
        return password;
    }
}
