package view;

import controller.TrainReservation;
import model.User;
import validation.Validation;
import java.util.Scanner;

public class UserView {
    private static final Scanner scanner = new Scanner(System.in);
    private static final TrainView trainView = new TrainView();
    private static final AdminView adminView = new AdminView();
    private static final TrainReservation reservation = new TrainReservation();
    private static User user = null;

    public void displayMainMenu() throws Exception {
        System.out.println("..User Menu ..");
        System.out.println("\n1. Register");
        System.out.println("2. Login");
        System.out.println("3. Exit" );
        String option = scanner.next();
        if(!Validation.validateNumbers(option)) {
            return;
        }
        switch (option) {
            case "1" : displayRegisterOption();
                break;

            case "2" : displayLoginOption();
                break;

            case "3" : trainView.displayMenuAndGetChoice();
                break;
            default:
                System.out.println("Invalid Option");
                break;
        }

    }

    private void displayRegisterOption() throws Exception {
        System.out.println("Enter the Name");
        String name = scanner.next();
        if(!Validation.validateName(name)) {
            System.out.println("Please enter the name only in alphabets");
            return;
        }
        System.out.println("Enter the User Name");
        String userName = scanner.next();
        if(!Validation.validateUsername(userName)) {
            System.out.println("Please enter the Username using alphabets and integers");
            return;
        }

        System.out.println("Enter the password");
        String password = scanner.next();
        if(!Validation.validatePassword(password)) {
            System.out.println("Please enter the password in correct format");
            return;
        }
         user = new User(name, userName, password);
        displayUserOption();
    }

    private void displayLoginOption() throws Exception {
        System.out.println("Enter the User Name");
        String userName = scanner.next();
        System.out.println("Enter the Password");
        String password = scanner.next();
        if(user != null) {
            if (userName.equals(user.getUserName()) && password.equals(user.getPassword())) {
                displayUserOption();
            }
            else {
                System.out.println("User name or Password is Incorrect");
            }
        }
        else {
            System.out.println("User is not available Please Register First");
            displayMainMenu();
        }

    }

    private void displayUserOption() throws Exception {
        System.out.println("User Menu");
        System.out.println("\n1. Book Ticket");
        System.out.println("2. Cancel Ticket");
        System.out.println("3. logOut");
        String option = scanner.next();
        if(!Validation.validateNumbers(option)) {
            return;
        }
        switch (option) {
            case "1" : bookTicket();
                break;
            case "2" : cancelTicket();
                break;
            case "3" : trainView.displayMenuAndGetChoice();
            default:
                System.out.println("Invalid Option");
        }
    }

    public void bookTicket() throws Exception {
        adminView.displayTrainDetails();
        System.out.print("Enter Starting point: ");
        String startingPoint = scanner.next().toUpperCase();
        if(!Validation.validateName(startingPoint)){
            System.out.println("Enter location only in String");
            displayUserOption();
        }
        System.out.print("Enter Destination point: ");
        String destination = scanner.next().toUpperCase();
        if(!Validation.validateName(destination)){
            System.out.println("Enter location only in String");
            displayUserOption();
        }
        adminView.displayTrainDetails(startingPoint, destination);
        System.out.print("Enter number of passengers: ");
        String numberOfPassengers = scanner.next();
        if(!Validation.validateNumbers(numberOfPassengers)){
            System.out.println("Enter passenger Count only in integer");
            displayUserOption();
        }
        reservation.bookTicket(startingPoint, destination, Integer.parseInt(numberOfPassengers));
        displayUserOption();
    }

    public void cancelTicket() throws Exception {
        System.out.print("Enter PNR to cancel: ");
        String pnr = scanner.next();
        if(!Validation.validateNumbers(pnr)){
            System.out.println("Enter passenger Count only in integer");
            return;
        }
        reservation.cancelTicket(Integer.parseInt(pnr));
        displayUserOption();
    }
}
