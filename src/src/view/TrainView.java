package view;

import model.Passenger;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class TrainView {
    private Scanner scanner = new Scanner(System.in);

    public int displayMenuAndGetChoice() {
        System.out.println("\n1. Book Ticket");
        System.out.println("2. Cancel Ticket");
        System.out.println("3. Prepare Occupancy Chart");
        System.out.println("4. Exit");
        System.out.print("Choose an option: ");
        return scanner.nextInt();
    }

    public String getSource() {
        System.out.print("Enter Starting point: ");
        return scanner.next();
    }

    public String getDestination() {
        System.out.print("Enter Destination point: ");
        return scanner.next();
    }

    public int getNumberOfPassengers() {
        System.out.print("Enter number of passengers: ");
        return scanner.nextInt();
    }

    public List<Passenger> getPassengers(int numberOfPassengers) {
        List<Passenger> passengers = new ArrayList<>();
        for (int i = 0; i < numberOfPassengers; i++) {
            System.out.println("Enter Passenger " + (i + 1) + " name:");
            passengers.add(new Passenger(scanner.next()));
        }
        return passengers;
    }

    public int getPnrToCancel() {
        System.out.print("Enter PNR to cancel: ");
        return scanner.nextInt();
    }

    public void displayMessage(String message) {
        System.out.println(message);
    }

    public void displayTicketDetails(String ticketDetails) {
        System.out.println(ticketDetails);
    }

    public void displayOccupancyChart(String occupancyChart) {
        System.out.println(occupancyChart);
    }
}
