package model;

import java.util.ArrayList;
import java.util.List;

public class Seat {
    private int seatNumber;
    private List<String[]> occupiedRanges;
    private Passenger passenger;

    public Seat(int seatNumber) {
        this.seatNumber = seatNumber;
        this.occupiedRanges = new ArrayList<>();
        this.passenger = null;
    }

    public int getSeatNumber() {
        return seatNumber;
    }

    public List<String[]> getOccupiedRanges() {
        return this.occupiedRanges;
    }

    public String getPassangerName() {
        return (passenger != null) ? passenger.getName() : "EMPTY";
    }

    public void addPassanger(Passenger passenger) {
        this.passenger = passenger;
    }
}
