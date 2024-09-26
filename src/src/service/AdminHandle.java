package service;

import model.Passenger;

public interface AdminHandle {
    void prepareOccupancyChart();

    boolean addPassengerToWaitingList(Passenger passenger, String[] strings, int i);

    void allocateSeatFromWaitingList(String canceledSource, String canceledDestination, int trainNumber);
}
