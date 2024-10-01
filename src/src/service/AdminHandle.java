package service;

import model.ChairCarTrain;
import model.Passenger;

public interface AdminHandle {
    void prepareOccupancyChart(ChairCarTrain train);

    boolean addPassengerToWaitingList(Passenger passenger, String[] strings, int i);

    void allocateSeatFromWaitingList(String canceledSource, String canceledDestination, int trainNumber);
}
