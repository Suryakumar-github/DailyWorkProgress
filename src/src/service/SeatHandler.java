package service;

import model.ChairCarTrain;
import model.Passenger;
import model.Seat;

import java.util.List;

public interface SeatHandler {
    void occupySeatForRange(String source, String destination, Seat seat);
    void setSeatUnOccupied(String canceledSource, String canceledDestination, Seat seat);
    List<Seat> allocateSeats(ChairCarTrain train, String source, String destination, List<Passenger> passengers) throws Exception;
    boolean isSeatsAvailable(ChairCarTrain train, String source, String destination, int passengerCount);
    int getAvailabeSeatCounts(String source, String destination, List<String> routes, List<Seat> seats);
    boolean isAvailableForRange(String source, String destination, List<String> route, Seat seat);
}
