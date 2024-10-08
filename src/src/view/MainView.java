package view;

import controller.AdminController;
import validation.Validation;
import java.util.Scanner;

public class MainView {
    private final Scanner scanner = new Scanner(System.in);
    private final AdminController adminController ;
    private final UserView userView;
    private final AdminView adminView;

    public MainView(AdminController adminController, UserView userView, AdminView adminView) {
        this.adminController = adminController;
        this.userView = userView;
        this.adminView = adminView;
    }

    public void start() throws Exception {

        int userChoice = displayMenuAndGetChoice();
        switch (userChoice) {
            case 1 :
                userView.displayRegisterOption();
                displayMenuAndGetChoice();
                break;

            case 2 :
                displayLoginOption();
                displayMenuAndGetChoice();
                break;

            case 3 :
                System.exit(0);
                break;
            default :
                System.out.println("Invalid Option ");
                displayMenuAndGetChoice();
                break;
        }
    }
    public int displayMenuAndGetChoice()
    {
        System.out.println(".............................");
        System.out.println("1. Register");
        System.out.println("2. Login");
        System.out.println("3. Exit");
        System.out.println(".............................");

        System.out.print("Choose an option: ");
        String option = scanner.nextLine().trim();

        if (!Validation.validateNumbers(option))
        {
            return 0;
        }

        int choice = Integer.parseInt(option);
        return choice;
    }

    private void displayLoginOption() throws Exception {
        System.out.println("Enter the User Name");
        String userName = scanner.nextLine().trim();
        System.out.println("Enter the Password");
        String password = scanner.nextLine().trim();

        if(adminController.isValidAdmin(userName, password))
        {
            adminView.displayAdminOption();
        }
        else if(adminController.isValidUser(userName, password))
        {
            userView.displayUserOption();
        }
        else
        {
            System.out.println("Invalid userName or Password ");
            displayLoginOption();
        }
    }

}
