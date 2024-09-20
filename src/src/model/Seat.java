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
    }
    public int getSeatNumber() {
        return seatNumber;
    }
    public List<String[]> getOccupiedRanges() {
        return occupiedRanges;
    }
    public boolean isAvailableForRange(String source, String destination, List<String> route) {
        int sourceIndex = route.indexOf(source);
        int destinationIndex = route.indexOf(destination);

        for (String[] range : this.occupiedRanges) {
            int occupiedSourceIndex = route.indexOf(range[0]);
            int occupiedDestinationIndex = route.indexOf(range[1]);

            if (!(destinationIndex <= occupiedSourceIndex || sourceIndex >= occupiedDestinationIndex)) {
                return false;
            }
        }
        return true;
    }
    public void occupySeatForRange(String source, String destination) {
        occupiedRanges.add(new String[]{source, destination});
    }
    public String getPassangerName() {
        return this.passenger.getName();
    }
    public void setSeatUnOccupied() {
        occupiedRanges.clear();
    }
    public void addPassanger(Passenger passenger) {
        this.passenger = passenger;
    }
}

