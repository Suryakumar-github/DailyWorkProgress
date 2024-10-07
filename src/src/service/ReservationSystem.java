package service;

import model.ChairCarTrain;

import java.util.List;

public interface ReservationSystem {
    void bookTicket(String source, String destination, int numberOfPassengers) throws Exception;
    void cancelTicket(int pnr);

    ChairCarTrain getTrainByNumber(int trainNumber);

    void addTrain(ChairCarTrain train);

    List<ChairCarTrain> getTrains();

    List<ChairCarTrain> getAllTrains(String startingPoint, String commonStation);

    String findCommonStation(String startingPoint, String destination);
}

