package model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ChairCarTrain extends Train{
    private List<Seat> seats;
    private Map<Passenger, String[]> waitingListPassengers;

    public ChairCarTrain(String trainName, String[] routes) {
        super(trainName,routes);
        this.seats = new ArrayList<>();
        this.waitingListPassengers = new HashMap<>();
        for (int i = 0; i < 8; i++) {
            seats.add(new Seat(i + 1));
        }
    }

    public List<Seat> getSeats() {
        return seats;
    }

    public Map<Passenger, String[]> getWaitingListPassengers() {
        return waitingListPassengers;
    }

    @Override
    public String toString() {
        return "ChairCarTrain{" +
                "trainNumber=" + getTrainNumber() +
                ", trainName='" + getTrainName() + '\'' +
                ", seats=" + seats +
                ", waitingListPassengers=" + waitingListPassengers +
                '}';
    }

}
