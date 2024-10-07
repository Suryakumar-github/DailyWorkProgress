package controller;

import model.ChairCarTrain;
import model.Passenger;
import model.Seat;
import view.AdminView;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class SeatControllerImpl implements SeatController {
    private AdminController adminController ;
    AdminView adminView = new AdminView();

    public void setAdminHandle(AdminController adminController) {
        this.adminController = adminController;
    }

    @Override
    public void occupySeatForRange(String source, String destination, Seat seat)
    {
        String[] str = new String[]{source, destination};
        seat.getOccupiedRanges().add(str);
    }

    @Override
    public void setSeatUnOccupied(String canceledSource, String canceledDestination, Seat seat) {
        Iterator<String[]> iterator = seat.getOccupiedRanges().iterator();
        while (iterator.hasNext()) {
            String[] range = iterator.next();
            if (range[0].equals(canceledSource) && range[1].equals(canceledDestination)) {
                iterator.remove();
            }
        }
    }

    @Override
    public boolean isAvailableForRange(String source, String destination, List<String> route, Seat seat) {
        int sourceIndex = route.indexOf(source);
        int destinationIndex = route.indexOf(destination);

        for (String[] range : seat.getOccupiedRanges()) {
            int occupiedSourceIndex = route.indexOf(range[0]);
            int occupiedDestinationIndex = route.indexOf(range[1]);

            if (!(destinationIndex <= occupiedSourceIndex || sourceIndex >= occupiedDestinationIndex)) {
                return false;
            }
        }
        return true;
    }

    @Override
    public List<Seat> allocateSeats(ChairCarTrain train, String source, String destination, List<Passenger> passengers) throws Exception {
        List<Seat> seats = train.getSeats();
        List<Seat> bookedSeats = new ArrayList<>();
        for (Passenger passenger : passengers) {
            boolean flag =true;
            for (Seat seat : seats) {
                if (isAvailableForRange(source, destination, train.getRoutes(),seat))
                {
                    occupySeatForRange(source, destination, seat);
                    seat.addPassanger(passenger);
                    bookedSeats.add(seat);
                    flag =false;
                    break;
                }
            }

            if (flag)
            {
                if(adminController.addPassengerToWaitingList(passenger, new String[]{source, destination}, train.getTrainNumber())) {
                    adminView.displayMessage("No seats available, " + passenger.getName() + " added to the waiting list.");
                }
                else {
                    throw new Exception("Waiting list is full, can't add the passengers to the waiting list.");
                }
            }
        }
        return bookedSeats;
    }

    @Override
    public boolean isSeatsAvailable(ChairCarTrain train, String source, String destination, int passengerCount) {
        int availableSeatCount = getAvailabeSeatCounts(source, destination, train.getRoutes(), train.getSeats());
        return passengerCount > availableSeatCount;
    }
    @Override
    public int getAvailabeSeatCounts(String source, String destination, List<String> routes, List<Seat> seats) {
        int availableSeatCount = 0;
        for (Seat seat : seats)
        {
            if (isAvailableForRange(source, destination, routes, seat))
            {
                availableSeatCount++;
            }
        }
        System.out.println( "Available count "+ availableSeatCount);
        return availableSeatCount;
    }

}
