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

    public boolean addPassengerToWaitingList(Passenger passenger, String[] sourceAndDestination) {
        if (waitingListPassengers.size() < 2) {
            waitingListPassengers.put(passenger, sourceAndDestination);
            return true;
        }
        return false;
    }

    public void allocateSeatFromWaitingList(String canceledSource, String canceledDestination) {
        List<Seat> availableSeats = getSeats();

        for (Seat seat : availableSeats) {
            if (seat.isAvailableForRange(canceledSource, canceledDestination, routes)) {
                for (Map.Entry<Passenger, String[]> entry : waitingListPassengers.entrySet()) {
                    Passenger waitingPassenger = entry.getKey();
                    String[] waitingPassengerRoute = entry.getValue();

                    String waitingSource = waitingPassengerRoute[0];
                    String waitingDestination = waitingPassengerRoute[1];

                    if (isRangeWithin(canceledSource, canceledDestination, waitingSource, waitingDestination)) {
                        System.out.println("Allocating seat " + seat.getSeatNumber() + " to waiting list passenger: " + waitingPassenger.getName());
                        seat.occupySeatForRange(waitingSource, waitingDestination);

                        waitingListPassengers.remove(waitingPassenger);
                        break;
                    }
                }
            }
        }
    }

    private boolean isRangeWithin(String canceledSource, String canceledDestination, String waitingSource, String waitingDestination) {
        int canceledSourceIndex = routes.indexOf(canceledSource);
        int canceledDestinationIndex = routes.indexOf(canceledDestination);
        int waitingSourceIndex = routes.indexOf(waitingSource);
        int waitingDestinationIndex = routes.indexOf(waitingDestination);

        return waitingSourceIndex >= canceledSourceIndex && waitingDestinationIndex <= canceledDestinationIndex;
    }
}
