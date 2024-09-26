package model;
import java.util.ArrayList;
import java.util.List;

public class Seat {
    private int seatNumber;
    private  List<String[]> occupiedRanges;
    private Passenger passenger;

    public Seat(int seatNumber) {
        this.seatNumber = seatNumber;
        occupiedRanges = new ArrayList<>();
    }
    public int getSeatNumber() {
        return seatNumber;
    }
    public List<String[]> getOccupiedRanges() {
        return this.occupiedRanges;
    }
    public String getPassangerName() {
        return this.passenger.getName();
    }
    public void addPassanger(Passenger passenger) {
        this.passenger = passenger;
    }
}

