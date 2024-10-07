package controller;

import model.ChairCarTrain;
import model.Ticket;

import java.util.List;

public interface Traincontroller {
    void bookTicket(String source, String destination, int numberOfPassengers) throws Exception;
    void cancelTicket(int pnr);

    ChairCarTrain getTrainByNumber(int trainNumber);

    void addTrain(ChairCarTrain train);

    List<ChairCarTrain> getTrains();

    List<ChairCarTrain> getAllTrains(String startingPoint, String commonStation);

    TrainControllerImpl.ConnectingTrains findCommonStation(String startingPoint, String destination);

    void setTrains(List<ChairCarTrain> trains);

    void setTickets(List<Ticket> tickets);
}

