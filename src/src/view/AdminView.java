package view;

import controller.AdminController;
import controller.Traincontroller;
import model.ChairCarTrain;
import model.Seat;
import validation.Validation;

import java.util.List;
import java.util.Scanner;

public class AdminView {

    private AdminController adminController;
    private Traincontroller trainController;
    private final Scanner scanner = new Scanner(System.in);
    public AdminView() {}

    public void setAdminController(AdminController adminController) {
        this.adminController = adminController;
    }

    public void setTrainController(Traincontroller trainController) {
        this.trainController = trainController;
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
                System.exit(0);
                break;

            default:
                System.out.println("Invalid Option");
                displayAdminOption();
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
        scanner.nextLine();
    }

}
