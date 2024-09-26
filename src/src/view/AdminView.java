package view;

import controller.SeatController;
import controller.TrainReservation;
import dao.TrainDAO;
import dao.TrainDAOImpl;
import model.ChairCarTrain;
import service.SeatHandler;
import validation.Validation;
import model.Admin;
import controller.AdminController;

import java.util.List;
import java.util.Scanner;

public class AdminView {
    private static final Scanner scanner = new Scanner(System.in);
    private static final Admin admin = new Admin();
    private static final AdminController adminController = new AdminController();
    private static final TrainView trainView = new TrainView();
    private static final TrainDAO trainDAO = new TrainDAOImpl();
    private static final TrainReservation reservation = new TrainReservation();
    private final SeatHandler seatController = new SeatController();

    public void displayMainMenu() {
        System.out.println("..Admin Menu ..");
        System.out.println("\n1. Login");
        System.out.println("2. Exit");
        String option = scanner.next();

        if(!Validation.validateNumbers(option)) {
            return;
        }
        switch (option) {
            case "1" : displayLoginOption();
            break;

            case "2" : trainView.displayMenuAndGetChoice();

            default:
                System.out.println("Invalid Option");
        }

    }

    private void displayLoginOption() {
        System.out.println("Enter the User Name");
        String userName = scanner.next();
        System.out.println("Enter the Password");
        String password = scanner.next();
        if(userName.equals(admin.getUserName()) && password.equals(admin.getPassword())){
            displayAdminOption();
        }
        else {
            System.out.println("User name or Password is Incorrect");
        }
        displayMainMenu();
    }

    private void displayAdminOption() {
        System.out.println("Admin Menu");
        System.out.println("\n1. PrepareOccupancy Chart");
        String option = scanner.next();
        if(!Validation.validateNumbers(option)) {
            return;
        }
        if (option.equals("1")) {
            adminController.prepareOccupancyChart();
        }
    }
    public void displayTrainDetails() {
        List<ChairCarTrain> trains = trainDAO.getAllTrains();
        for(ChairCarTrain train : trains) {
            System.out.println("Train Name : "+train.getTrainName() + " Route : "+train.getRoutes() );
        }
    }

    public void displayTrainDetails(String startingPoint, String destination) {
        List<ChairCarTrain> trains = reservation.getAllTrains(startingPoint, destination);
        if(!trains.isEmpty()) {
            for (ChairCarTrain train : trains) {
                System.out.println("Available Seats from Source " + startingPoint + " to destination " + destination + " : " +
                        seatController.getAvailabeSeatCounts(startingPoint, destination, train.getRoutes(), train.getSeats()) + " Seats");
            }
        }
        else {
            String commonStation = reservation.findCommonStation(startingPoint,destination);
            List<ChairCarTrain> trains1 = reservation.getAllTrains(startingPoint, commonStation);
            List<ChairCarTrain> trains2 = reservation.getAllTrains(commonStation,destination );
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
}
