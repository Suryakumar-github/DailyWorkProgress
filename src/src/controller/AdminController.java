package controller;

import dao.TrainDAOImpl;
import dataLayer.DataLayer;
import fileHandler.ChairCarTrainHandler;
import model.ChairCarTrain;
import model.Passenger;
import model.Seat;
import service.AdminHandle;
import service.SeatHandler;
import view.TrainView;

import java.util.List;
import java.util.Map;


public class AdminController implements AdminHandle {

    private static final TrainDAOImpl trainDAO = new TrainDAOImpl();
    private static final TrainView trainView = new TrainView();
    private static final SeatHandler seatController = new SeatController();

    @Override
    public void prepareOccupancyChart(ChairCarTrain train) {
        trainView.printOccupancyChart(train);
    }

    @Override
    public boolean addPassengerToWaitingList(Passenger passenger, String[] sourceAndDestination, int trainNumber) {
        ChairCarTrain train = trainDAO.getTrainByNumber(trainNumber);
        if(train != null) {
            train.getWaitingListPassengers().put(passenger, sourceAndDestination);
            return true;
        }
        return false;
    }

    @Override
    public void allocateSeatFromWaitingList(String canceledSource, String canceledDestination, int trainNumber) {
        ChairCarTrain train = trainDAO.getTrainByNumber(trainNumber);
        if (train != null) {
            List<Seat> availableSeats = train.getSeats();

            for (Seat seat : availableSeats) {
                if (seatController.isAvailableForRange(canceledSource, canceledDestination, train.getRoutes(),seat)) {
                    for (Map.Entry<Passenger, String[]> entry : train.getWaitingListPassengers().entrySet()) {
                        Passenger waitingPassenger = entry.getKey();
                        String[] waitingPassengerRoute = entry.getValue();

                        String waitingSource = waitingPassengerRoute[0];
                        String waitingDestination = waitingPassengerRoute[1];

                        if (isRangeWithin(canceledSource, canceledDestination, waitingSource, waitingDestination,train)) {
                            System.out.println("Allocating seat " + seat.getSeatNumber() + " to waiting list passenger: " + waitingPassenger.getName());
                            seatController.occupySeatForRange(waitingSource, waitingDestination,seat);

                            train.getWaitingListPassengers().remove(waitingPassenger);
                            break;
                        }
                    }
                }
            }
            ChairCarTrainHandler.updateChairCarTrain();
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
