package service;

import model.ChairCarTrain;
import model.Passenger;
import model.User;

public interface AdminHandle {
    void prepareOccupancyChart(ChairCarTrain train);

    boolean addPassengerToWaitingList(Passenger passenger, String[] strings, int i);

    void allocateSeatFromWaitingList(String canceledSource, String canceledDestination, int trainNumber);

    boolean isValidAdmin(String userName, String password);

    boolean isValidUser(String userName, String password);

    void addUser(User user);
}
