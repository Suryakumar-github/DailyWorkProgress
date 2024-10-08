package view;

import controller.AdminController;
import controller.Traincontroller;
import model.Passenger;
import model.Seat;
import model.Ticket;
import model.User;
import validation.Validation;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class UserView {

    private Traincontroller trainController;
    private AdminController adminController;
    private AdminView adminView;
    private Scanner scanner = new Scanner(System.in);

    public UserView() {

    }

    public void setTrainController(Traincontroller trainController) {
        this.trainController = trainController;
    }

    public void setAdminController(AdminController adminController) {
        this.adminController = adminController;
    }

    public void setAdminView(AdminView adminView) {
        this.adminView = adminView;
    }

    public void displayRegisterOption() throws Exception {
        System.out.println("Enter the Name");
        String name = scanner.nextLine().trim();
        if (!Validation.validateName(name))
        {
            System.out.println("Please enter the name only in alphabets");
            return;
        }
        System.out.println("Enter the User Name");
        String userName = scanner.nextLine().trim();
        if (!Validation.validateUsername(userName))
        {
            System.out.println("Please enter the Username using alphabets and numbers");
            return;
        }

        System.out.println("Enter the password");
        String password = scanner.nextLine().trim();
        if (!Validation.validatePassword(password))
        {
            System.out.println("Please enter the password in correct format, at least that should contain one number and one special character");
            return;
        }
        User user = new User(name, userName, password);
        adminController.addUser(user);
        displayUserOption();
    }

    public void displayUserOption() throws Exception {
        System.out.println("User Menu");
        System.out.println("1. Book Ticket");
        System.out.println("2. Cancel Ticket");
        System.out.println("3. logOut");
        String option = scanner.nextLine().trim();
        if (!Validation.validateNumbers(option))
        {
            System.out.println("Enter the number only in numbers");
            displayUserOption();
        }
        switch (option) {
            case "1":
                bookTicket();
                break;
            case "2":
                cancelTicket();
                break;
            case "3":
                System.exit(0);
                break;
            default:
                System.out.println("Invalid Option");
                displayUserOption();
                break;
        }
    }

    public void bookTicket() throws Exception {
        adminView.displayTrainDetails();
        System.out.print("Enter Starting point: ");
        String startingPoint = scanner.nextLine().trim().toUpperCase();
        if (!Validation.validateName(startingPoint))
        {
            System.out.println("Enter location only in String");
            displayUserOption();
        }

        System.out.print("Enter Destination point: ");
        String destination = scanner.nextLine().trim().toUpperCase();
        if (!Validation.validateName(destination))
        {
            System.out.println("Enter location only in String");
            displayUserOption();
        }

        adminView.displayTrainDetails(startingPoint, destination);
        System.out.print("Enter number of passengers: ");
        String numberOfPassengers = scanner.nextLine().trim();
        if (!Validation.validateNumbers(numberOfPassengers))
        {
            System.out.println("Enter passenger Count only in numbers");
            displayUserOption();
        }
        trainController.bookTicket(startingPoint, destination, Integer.parseInt(numberOfPassengers));
        scanner.nextLine();
        displayUserOption();
    }

    public void cancelTicket() throws Exception {
        System.out.print("Enter PNR to cancel: ");
        String pnr = scanner.nextLine().trim();
        if (!Validation.validateNumbers(pnr))
        {
            System.out.println("Enter passenger Count only in numbers");
            return;
        }
        trainController.cancelTicket(Integer.parseInt(pnr));
        displayUserOption();
    }

    public List<Integer> getPassengersSerialNumber(Ticket ticket) {
        System.out.println("Enter the No of tickets to be Cancelled");
        String cancelCount = scanner.next();
        if(!Validation.validateNumbers(cancelCount)) {
            System.out.println("Enter tickets count only in Integer");

        }
        List<Integer> listOfPassengers = new ArrayList<>();
        int serialNumber ;
        for(int i = 0; i < Integer.parseInt(cancelCount); i++) {
            System.out.println("Enter SerialNo : ");
            if(!Validation.validateNumbers(cancelCount))
            {
                System.out.println("Enter tickets count only in Integer");
                break;
            }
            serialNumber = scanner.nextInt();
            listOfPassengers.add(serialNumber);
        }
        return listOfPassengers;
    }

    public List<Passenger> getPassengers(int numberOfPassengers)
    {
        List<Passenger> passengers = new ArrayList<>();
        for (int i = 0; i < numberOfPassengers; i++)
        {
            System.out.println("Enter Passenger " + (i + 1) + " name:");
            String name = scanner.next();
            if(!Validation.validateName(name))
            {
                System.out.println("Enter the name only in Alphabets");
                break;
            }
            passengers.add(new Passenger(name));
        }
        return passengers;
    }

    public void printTicket(Ticket ticket) {

        System.out.println("PNR: " + ticket.getPnr());
        System.out.println("From: " + ticket.getSource() + " To: " + ticket.getDestination());
        System.out.println("Train Numbers: " + ticket.getTrainNumbers());
        for(Seat seat : ticket.getSeats())
        {
            System.out.println("Passenger Name : "+ seat.getPassangerName() + ", Seat Number : "+seat.getSeatNumber());
        }
        System.out.println("Total Ticket Price : " + ticket.getTicketPrice());
    }

    public void displayMessage(String message) {
        System.out.println(message);
    }
    public void displayTicketDetails(Ticket ticketToCancel) {
        List<Seat> seats = ticketToCancel.getSeats();
        for(Seat seat : seats) {
            System.out.println("Passenger Name : "+seat.getPassangerName() +" Seat No : "+seat.getSeatNumber());
        }
    }
}
