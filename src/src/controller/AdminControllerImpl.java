package controller;

import dao.TrainDAO;
import dao.TrainDAOImpl;
import dao.UserDAO;
import dao.UserDAOImpl;
import model.*;
import view.AdminView;

import java.util.List;
import java.util.Map;


public class AdminControllerImpl implements AdminController {
    private final TrainDAO trainDAO = TrainDAOImpl.getInstance();
    private final UserDAO userDAO = UserDAOImpl.getInstance();
    private final SeatController seatController ;
    private final AdminView adminView ;

    public AdminControllerImpl(SeatController seatController, AdminView adminView) {
        this.seatController = seatController;
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
        String adminUserName = "MainAdmin";
        String adminPassword = "MainAdmin@123";
        return userName.trim().equals(adminUserName.trim()) && password.trim().equals(adminPassword.trim());
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

    @Override
    public void setUser(List<User> users) {
        userDAO.setUsers(users);
    }
}
