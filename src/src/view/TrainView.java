package view;

import model.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

import validation.Validation;

public class TrainView {
    private static final Scanner scanner = new Scanner(System.in);
    private static final AdminView adminView = new AdminView();
    private static final UserView userView = new UserView();
    public TrainView() {

    }
    public void start() throws Exception {
        while (true) {
            UserChoice choice = displayMenuAndGetChoice();

            if (choice != null) {
                switch (choice) {
                    case ADMIN:
                        adminView.displayMainMenu();
                        break;
                    case USER:
                        userView.displayMainMenu();
                        break;
                    case EXIT:
                        displayMessage("Exiting...");
                        System.exit(0);
                        break;
                    default:
                        displayMessage("Invalid choice.");
                        break;
                }
            } else {
                displayMessage("Invalid choice.");
            }
        }
    }

    public UserChoice displayMenuAndGetChoice() {
        System.out.println("\n1. Admin");
        System.out.println("2. User");
        System.out.println("3. Exit");
        System.out.print("Choose an option: ");
        String option = scanner.nextLine().trim();

        if (!Validation.validateNumbers(option)) {
            return null;
        }

        int choice = Integer.parseInt(option);
        return UserChoice.fromInt(choice);
    }

    public List<Passenger> getPassengers(int numberOfPassengers) {
        List<Passenger> passengers = new ArrayList<>();
        for (int i = 0; i < numberOfPassengers; i++) {
            System.out.println("Enter Passenger " + (i + 1) + " name:");
            String name = scanner.next();
            if(!Validation.validateName(name)){
                System.out.println("Enter the name only in Alphabets");
                break;
            }
            passengers.add(new Passenger(name));
        }
        return passengers;
    }


    public void displayMessage(String message) {
        System.out.println(message);
    }

    public void printOccupancyChart(ChairCarTrain train) {
        System.out.println("Train Name: " + train.getTrainName());
        for (Seat seat : train.getSeats()) {
            System.out.print("Seat " + seat.getSeatNumber() + ": ");
            if (seat.getOccupiedRanges().isEmpty()) {
                System.out.println("Available");
            } else {
                for (String[] range : seat.getOccupiedRanges()) {
                    System.out.println("Occupied from " + range[0] + " to " + range[1]);
                }
            }
        }
        System.out.println(".........................................");
    }


    public void displayTicketDetails(Ticket ticketToCancel) {
        List<Seat> seats = ticketToCancel.getSeats();
        for(Seat seat : seats) {
            System.out.println("Passenger Name : "+seat.getPassangerName() +" Seat No : "+seat.getSeatNumber());
        }
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
            if(!Validation.validateNumbers(cancelCount)) {
                System.out.println("Enter tickets count only in Integer");
                break;
            }
            serialNumber = scanner.nextInt();
            listOfPassengers.add(serialNumber);
        }
        return listOfPassengers;
    }

    public void printTicket(Ticket ticket) {
        System.out.println("PNR: " + ticket.getPnr());
        System.out.println("From: " + ticket.getSource() + " To: " + ticket.getDestination());
        System.out.println("Train Numbers: " + ticket.getTrainNumbers());
        for(Seat seat : ticket.getSeats()) {
            System.out.println("Passenger Name : "+ seat.getPassangerName() + ", Seat Number : "+seat.getSeatNumber());
        }
    }
}

