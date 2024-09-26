package model;

import java.util.List;

public class Ticket {
    private static int counter = 1000;
    private int pnr;
    private String source;
    private String destination;
    private List<Integer> trainNumbers;
    private List<Seat> seats;

    public Ticket(String source, String destination, List<Integer> trainNumbers,List<Seat> seats) {
        this.pnr = counter++;
        this.source = source;
        this.destination = destination;
        this.trainNumbers = trainNumbers;
        this.seats = seats;
    }

    public int getPnr() {
        return pnr;
    }

    public String getSource() {
        return source;
    }

    public String getDestination() {
        return destination;
    }

    public List<Integer> getTrainNumbers() {
        return trainNumbers;
    }

    public List<Seat> getSeats() {
        return seats;
    }
}


