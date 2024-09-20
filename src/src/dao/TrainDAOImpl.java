package dao;

import model.ChairCarTrain;
import model.Passenger;
import model.Seat;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class TrainDAOImpl implements TrainDAO {
    private ChairCarTrain train1;
    private ChairCarTrain train2;
    private List<ChairCarTrain> trains = new ArrayList<>();

    public TrainDAOImpl() {
        train1 = new ChairCarTrain("Train 1", new String[]{"A", "B", "C", "D", "E"});
        train2 = new ChairCarTrain("Train 2", new String[]{"X", "Y", "C"});
        trains.add(train1);
        trains.add(train2);
    }

    public ChairCarTrain getTrain1() {
        return train1;
    }

    public ChairCarTrain getTrain2() {
        return train2;
    }

    @Override
    public List<ChairCarTrain> getAllTrains() {
        return trains;
    }

    @Override
    public ChairCarTrain getTrainByNumber(int trainNumber) {
        for (ChairCarTrain train : trains) {
            if (trainNumber == train.getTrainName().hashCode()) {
                return train;
            }
        }
        return null;
    }

    @Override
    public void addTrain(ChairCarTrain train) {
        trains.add(train);
    }

    public boolean addPassengerToWaitingList(Passenger passenger, String[] sourceAndDestination, int trainNumber) {
        for (ChairCarTrain train : trains) {
            if (train.getTrainName().hashCode() == trainNumber) {
                train.getWaitingListPassengers().put(passenger, sourceAndDestination);
                return true;
            }
        }
        return false;
    }

    public void allocateSeatFromWaitingList(String canceledSource, String canceledDestination, int trainNumber) {
        ChairCarTrain train = getTrainByNumber(trainNumber);

        if (train != null) {
            List<Seat> availableSeats = train.getSeats();

            for (Seat seat : availableSeats) {
                if (seat.isAvailableForRange(canceledSource, canceledDestination, train.getRoutes())) {
                    for (Map.Entry<Passenger, String[]> entry : train.getWaitingListPassengers().entrySet()) {
                        Passenger waitingPassenger = entry.getKey();
                        String[] waitingPassengerRoute = entry.getValue();

                        String waitingSource = waitingPassengerRoute[0];
                        String waitingDestination = waitingPassengerRoute[1];

                        if (isRangeWithin(canceledSource, canceledDestination, waitingSource, waitingDestination,train)) {
                            System.out.println("Allocating seat " + seat.getSeatNumber() + " to waiting list passenger: " + waitingPassenger.getName());
                            seat.occupySeatForRange(waitingSource, waitingDestination);

                            train.getWaitingListPassengers().remove(waitingPassenger);
                            break;
                        }
                    }
                }
            }
        }

    }
    private boolean isRangeWithin(String canceledSource, String canceledDestination, String waitingSource, String waitingDestination,ChairCarTrain train) {
        int canceledSourceIndex = train.getRoutes().indexOf(canceledSource);
        int canceledDestinationIndex = train.getRoutes().indexOf(canceledDestination);
        int waitingSourceIndex = train.getRoutes().indexOf(waitingSource);
        int waitingDestinationIndex = train.getRoutes().indexOf(waitingDestination);

        return waitingSourceIndex >= canceledSourceIndex && waitingDestinationIndex <= canceledDestinationIndex;
    }
}
