package model;

public class Admin extends Passenger{
    private static final String userName = "MainAdmin";
    private static final String password = "MainAdmin@123";

    public Admin(String name) {
        super(name);
    }
    public Admin() {
        super();

    }
    public String getUserName() {
        return userName;
    }
    public String getPassword() {
        return password;
    }
}
