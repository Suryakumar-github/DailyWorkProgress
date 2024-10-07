package view;

import model.ChairCarTrain;
import model.Seat;
import model.Ticket;
import service.AdminHandle;
import service.ReservationSystem;
import service.SeatHandler;
import validation.Validation;

import java.util.List;
import java.util.Scanner;

public class AdminView {

    private AdminHandle adminController;
    private SeatHandler seatController;
    private ReservationSystem trainController;
    private static Scanner scanner = new Scanner(System.in);
    public AdminView() {}

    public void setAdminHandle(AdminHandle adminHandle) {
        this.adminController = adminHandle;
    }

    public void setSeatHandler(SeatHandler seatHandler) {
        this.seatController = seatHandler;
    }

    public void setReservationSystem(ReservationSystem reservationSystem) {
        this.trainController = reservationSystem;
    }

    public void displayAdminOption() {
        System.out.println("Admin Menu");
        System.out.println("1. PrepareOccupancy Chart");
        System.out.println("2. Find Trains Total Earning's");
        System.out.println("3. Add Train");
        System.out.println("4. Logout");
        String option = scanner.nextLine().trim();
        if (!Validation.validateNumbers(option)) {
            return;
        }
        switch (option) {
            case "1":
                getTrainDetails();
                break;

            case "2":
                displayTotalEarnings();
                break;

            case "3":
                addTrain();
                break;

            case "4" :
                break;

            default:
                System.out.println("Invalid Option");
                break;
        }
    }

    private void getTrainDetails() {
        displayTrainDetails();
        System.out.println("Enter the Train Number ");
        int trainNumber = scanner.nextInt();
        ChairCarTrain cTrain = trainController.getTrainByNumber(trainNumber);
        if(cTrain != null )
        {
            adminController.prepareOccupancyChart(cTrain);
            displayAdminOption();
        }
        else
        {
            System.out.println("Invalid Train Number ");
            getTrainDetails();
        }
    }

    private void addTrain() {
        System.out.println("Enter Train Name ");
        String trainName = scanner.nextLine().trim();

        if(!Validation.validateName(trainName))
        {
            System.out.println("Please Enter the Train Name only in Alphabets");
            displayAdminOption();
        }
        System.out.println("Enter no of Stations");
        String stationsCount = scanner.nextLine().trim();
        if(!Validation.validateNumbers(stationsCount))
        {
            System.out.println("Enter the Stations count only in integers");
            displayAdminOption();
        }
        String[] stations = new String[Integer.parseInt(stationsCount)];
        for(int i = 0; i < Integer.parseInt(stationsCount); i++)
        {
            System.out.println("Enter station "+(i+1) +" Name");
            stations[i] = scanner.nextLine().trim().toUpperCase();
        }
        ChairCarTrain train = new ChairCarTrain(trainName, stations);
        trainController.addTrain(train);
        displayAdminOption();
    }

    private void displayTotalEarnings() {
        List<ChairCarTrain> trains = trainController.getTrains();

        for(ChairCarTrain train : trains) {
            System.out.println("Train Name : " + train.getTrainName() + " ,Total Earnings : "+train.getTotalEarning());
        }
        displayAdminOption();
    }

    public void displayTrainDetails() {
        List<ChairCarTrain> trains = trainController.getTrains();
        for(ChairCarTrain train : trains) {
            System.out.println("Train Name : "+train.getTrainName() + " Route : "+train.getRoutes()+ " Train No : "+train.getTrainNumber() );
        }
    }

    public void displayTrainDetails(String startingPoint, String destination) {
        List<ChairCarTrain> trains = trainController.getAllTrains(startingPoint, destination);
        if(!trains.isEmpty()) {
            for (ChairCarTrain train : trains) {
                System.out.println("Available Seats from Source " + startingPoint + " to destination " + destination + " : " +
                        seatController.getAvailabeSeatCounts(startingPoint, destination, train.getRoutes(), train.getSeats()) + " Seats");
            }
        }
        else {
            String commonStation = trainController.findCommonStation(startingPoint,destination);
            List<ChairCarTrain> trains1 = trainController.getAllTrains(startingPoint, commonStation);
            List<ChairCarTrain> trains2 = trainController.getAllTrains(commonStation,destination );
            for (ChairCarTrain train : trains1) {
                System.out.println("Available Seats from Source " + startingPoint + " to destination " + commonStation + " : " +
                        seatController.getAvailabeSeatCounts(startingPoint, destination, train.getRoutes(), train.getSeats()) + " Seats");
            }
            for (ChairCarTrain train : trains2) {
                System.out.println("Available Seats from Source " + commonStation + " to destination " + destination + " : " +
                        seatController.getAvailabeSeatCounts(startingPoint, destination, train.getRoutes(), train.getSeats()) + " Seats");
            }
        }
    }

    public void printOccupancyChart(ChairCarTrain train) {
        System.out.println(".........................................");
        System.out.println("Train Name: " + train.getTrainName());
        System.out.println(".........................................");
        for (Seat seat : train.getSeats()) {
            System.out.print("Seat " + seat.getSeatNumber() + ": ");
            if (seat.getOccupiedRanges().isEmpty())
            {
                System.out.println("Available");
            }
            else
            {
                for (String[] range : seat.getOccupiedRanges())
                {
                    System.out.println("Occupied from " + range[0] + " to " + range[1]);
                }
            }
        }
        System.out.println(".........................................");
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

    public void displayTicketDetails(Ticket ticketToCancel) {
        List<Seat> seats = ticketToCancel.getSeats();
        for(Seat seat : seats) {
            System.out.println("Passenger Name : "+seat.getPassangerName() +" Seat No : "+seat.getSeatNumber());
        }
    }

    public void displayMessage(String message) {
        System.out.println(message);
    }
}
