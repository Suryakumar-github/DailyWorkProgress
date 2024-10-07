package controller;

import dao.TrainDAO;
import dao.UserDAO;
import model.*;
import service.AdminHandle;
import service.SeatHandler;
import view.AdminView;

import java.util.List;
import java.util.Map;


public class AdminController implements AdminHandle {

    private final TrainDAO trainDAO ;
    private final SeatHandler seatController ;
    private final UserDAO userDAO;
    private AdminView adminView ;

    public AdminController(TrainDAO trainDAO, UserDAO userDAO, SeatHandler seatHandler) {
        this.trainDAO = trainDAO;
        this.userDAO = userDAO;
        this.seatController = seatHandler;

    }
    public void setAdminView(AdminView adminView) {
        this.adminView = adminView;
    }

    @Override
    public void prepareOccupancyChart(ChairCarTrain train) {
        adminView.printOccupancyChart(train);
    }

    @Override
    public boolean addPassengerToWaitingList(Passenger passenger, String[] sourceAndDestination, int trainNumber) {
        ChairCarTrain train = trainDAO.getTrainByNumber(trainNumber);
        if(train != null) {
            train.getWaitingListPassengers().put(passenger, sourceAndDestination);
            return true;
        }
        return false;
    }

    @Override
    public void allocateSeatFromWaitingList(String canceledSource, String canceledDestination, int trainNumber) {
        ChairCarTrain train = trainDAO.getTrainByNumber(trainNumber);
        if (train != null) {
            List<Seat> availableSeats = train.getSeats();

            for (Seat seat : availableSeats) {
                if (seatController.isAvailableForRange(canceledSource, canceledDestination, train.getRoutes(),seat)) {
                    for (Map.Entry<Passenger, String[]> entry : train.getWaitingListPassengers().entrySet()) {
                        Passenger waitingPassenger = entry.getKey();
                        String[] waitingPassengerRoute = entry.getValue();

                        String waitingSource = waitingPassengerRoute[0];
                        String waitingDestination = waitingPassengerRoute[1];

                        if (isRangeWithin(canceledSource, canceledDestination, waitingSource, waitingDestination,train)) {
                            System.out.println("Allocating seat " + seat.getSeatNumber() + " to waiting list passenger: " + waitingPassenger.getName());
                            seatController.occupySeatForRange(waitingSource, waitingDestination,seat);

                            train.getWaitingListPassengers().remove(waitingPassenger);
                            break;
                        }
                    }
                }
            }
            trainDAO.updateTrain();
        }
    }

    private boolean isRangeWithin(String canceledSource, String canceledDestination, String waitingSource, String waitingDestination,ChairCarTrain train) {
        int canceledSourceIndex = train.getRoutes().indexOf(canceledSource);
        int canceledDestinationIndex = train.getRoutes().indexOf(canceledDestination);
        int waitingSourceIndex = train.getRoutes().indexOf(waitingSource);
        int waitingDestinationIndex = train.getRoutes().indexOf(waitingDestination);

        return waitingSourceIndex >= canceledSourceIndex && waitingDestinationIndex <= canceledDestinationIndex;
    }
    @Override
    public boolean isValidAdmin(String userName, String password) {
        Admin admin = new Admin();
        return userName.trim().equals(admin.getUserName().trim()) && password.trim().equals(admin.getPassword().trim());
    }
    @Override
    public boolean isValidUser(String userName, String password) {
        List<User> users = userDAO.getUser();

        for(User user : users)
        {
            if(user.getUserName().trim().equals(userName) && user.getPassword().trim().equals(password)) {
                return true;
            }
        }
        return false;
    }

    @Override
    public void addUser(User user) {
        userDAO.addUser(user);
    }
}
