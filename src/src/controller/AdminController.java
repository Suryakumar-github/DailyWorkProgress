package controller;

import model.ChairCarTrain;
import model.Passenger;
import model.User;

import java.util.List;

public interface AdminController {
    void prepareOccupancyChart(ChairCarTrain train);

    boolean addPassengerToWaitingList(Passenger passenger, String[] strings, int i);

    void allocateSeatFromWaitingList(String canceledSource, String canceledDestination, int trainNumber);

    boolean isValidAdmin(String userName, String password);

    boolean isValidUser(String userName, String password);

    void addUser(User user);

    void setUser(List<User> users);
}
