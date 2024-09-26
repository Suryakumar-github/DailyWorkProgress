package service;

import model.ChairCarTrain;

import java.util.List;

public interface ReservationSystem {
    void bookTicket(String source, String destination, int numberOfPassengers) throws Exception;
    void cancelTicket(int pnr);
}

