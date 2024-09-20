package controller;

import model.Passenger;
import model.Seat;
import model.Ticket;
import model.ChairCarTrain;
import service.ReservationSystem;
import view.TrainView;

import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class TrainReservation implements ReservationSystem {
    private ChairCarTrain train1 = new ChairCarTrain("Train 1", new String[]{"A", "B", "C", "D", "E"});
    private ChairCarTrain train2 = new ChairCarTrain("Train 2", new String[]{"X", "Y", "C"});
    private List<Ticket> bookedTickets = new ArrayList<>();
    private List<ChairCarTrain> trains = addTrains(train1,train2);
    private static Scanner scanner = new Scanner(System.in);
    private TrainView trainView = new TrainView();

    @Override
    public void bookTicket() throws Exception {

        String source = trainView.getSource();
        String destination = trainView.getDestination();

        int numberOfPassengers = trainView.getNumberOfPassengers();

        ChairCarTrain selectedTrain = findTrainForRoute(source, destination);

        if (selectedTrain == null) {
            String commonStation = findCommonStation();
            if (commonStation != null) {
                if (!isSeatsAvailable(train2, source, commonStation, numberOfPassengers) ||
                        !isSeatsAvailable(train1, commonStation, destination, numberOfPassengers)) {
                    throw new Exception("No seats available for the full journey.");
                }
            } else {
                throw new Exception("No valid route found.");
            }
        } else {
            if (!isSeatsAvailable(selectedTrain, source, destination, numberOfPassengers)) {
                if (isWaitingListFull(selectedTrain, numberOfPassengers)) {
                    trainView.displayMessage("No seats available and the waiting list is full. Unable to book the ticket.");
                    return;
                }
            }
        }

        List<Passenger> passengers = trainView.getPassengers(numberOfPassengers);


        List<Seat> bookedSeats;
        try {
            List<Integer> trainNumbers = new ArrayList<>();
            if (selectedTrain != null) {
                bookedSeats = allocateSeats(selectedTrain, source, destination, passengers);
                trainNumbers.add(selectedTrain.getTrainName().hashCode());
            } else {
                bookedSeats = allocateSeats(train2, source, findCommonStation(), passengers);
                bookedSeats.addAll(allocateSeats(train1, findCommonStation(), destination, passengers));
                trainNumbers.add(train2.getTrainName().hashCode());
                trainNumbers.add(train1.getTrainName().hashCode());
            }

            Ticket ticket = new Ticket(source, destination, trainNumbers, bookedSeats);
            bookedTickets.add(ticket);
            ticket.printTicket();
        } catch (Exception e) {
            trainView.displayMessage("Booking failed: " + e.getMessage());
        }
    }

    private boolean handleWaitingList(ChairCarTrain train, List<Passenger> passengers, String source, String destination) {
        boolean addedToWaitingList = false;
        for (Passenger passenger : passengers) {
            if (train.addPassengerToWaitingList(passenger, new String[]{source, destination})) {
                trainView.displayMessage("No seats available, " + passenger.getName() + " added to the waiting list.");
                addedToWaitingList = true;
            } else {
               trainView.displayMessage("Waiting list is full for " + passenger.getName());
                return false;
            }
        }
        return addedToWaitingList;
    }

    private boolean isWaitingListFull(ChairCarTrain train, int passengerCount) {
        int availableWaitingListSpots = 2 - train.getWaitingListPassengers().size();
        return passengerCount > availableWaitingListSpots;
    }

    private ChairCarTrain findTrainForRoute(String source, String destination) {
        for (ChairCarTrain train : trains) {
            if (isRouteValid(source, destination, train.getRoutes())) {
                return train;
            }
        }
        return null;
    }

    private boolean isSeatsAvailable(ChairCarTrain train, String source, String destination, int passengerCount) {
        int availableSeatCount = getAvailabeSeatCounts(source, destination, train.getRoutes(), train.getSeats());
        return passengerCount <= availableSeatCount;
    }

    private int getAvailabeSeatCounts(String source, String destination, List<String> routes, List<Seat> seats) {
        int availableSeatCount = 0;
        for (Seat seat : seats) {
            if (seat.isAvailableForRange(source, destination, routes)) {
                availableSeatCount++;
            }
        }
        return availableSeatCount;
    }
    private List<ChairCarTrain> addTrains(ChairCarTrain train1, ChairCarTrain train2) {
        List<ChairCarTrain> trians = new ArrayList<>();
        trians.add(train1);
        trians.add(train2);
        return trians;
    }

    @Override
    public void cancelTicket() {

        int pnr = trainView.getPnrToCancel();
        Ticket ticketToCancel = null;

        for (Ticket ticket : bookedTickets) {
            if (ticket.getPnr() == pnr) {
                ticketToCancel = ticket;
                break;
            }
        }

        if (ticketToCancel != null) {
            bookedTickets.remove(ticketToCancel);
            String canceledSource = ticketToCancel.getSource();
            String canceledDestination = ticketToCancel.getDestination();
            List<Integer> trainNumbers = ticketToCancel.getTrainNumbers();
            List<Seat> seats = ticketToCancel.getSeats();

            trainView.displayMessage("Train Cancelled Successfully");
            for(Seat seat : seats) {
                seat.setSeatUnOccupied();
            }

            reallocateSeatsFromWaitingList(trainNumbers, canceledSource, canceledDestination);

        } else {
            trainView.displayMessage("PNR not found.");
        }
    }

    private void reallocateSeatsFromWaitingList(List<Integer> trainNumbers, String canceledSource, String canceledDestination) {
        for(int trainNumber : trainNumbers) {
            ChairCarTrain train = getTrainByTrainNumber(trainNumber);
            if(train != null) {
                train.allocateSeatFromWaitingList(canceledSource, canceledDestination);
            }
        }
    }

    private ChairCarTrain getTrainByTrainNumber(int trainNumber) {
        for(ChairCarTrain train : trains) {
            if(train.getTrainName().hashCode() == trainNumber) {
                return train;
            }
        }
        return null;
    }

    @Override
    public void prepareOccupancyChart() {
        trainView.displayMessage("Occupancy chart for " + train1.getTrainName() + ":");
        trainView.printOccupancyChart(train1);

        trainView.displayMessage("Occupancy chart for " + train2.getTrainName() + ":");
        trainView.printOccupancyChart(train2);
    }

    private String findCommonStation() {
        for (String station : train1.getRoutes()) {
            if (train2.getRoutes().contains(station)) {
                return station;
            }
        }
        return null;
    }

    private List<Seat> allocateSeats(ChairCarTrain train, String source, String destination, List<Passenger> passengers) throws Exception {
        List<Seat> seats = train.getSeats();
        List<Seat> bookedSeats = new ArrayList<>();
        for (Passenger passenger : passengers) {
            boolean seatFound = false;
            for (Seat seat : seats) {
                if (seat.isAvailableForRange(source, destination, train.getRoutes())) {
                    seat.occupySeatForRange(source, destination);
                    seat.addPassanger(passenger);
                    seatFound = true;
                    bookedSeats.add(seat);
                    break;
                }
            }
            if (!seatFound) {
                if(train.addPassengerToWaitingList(passenger,new String[] {source,destination})) {
                    trainView.displayMessage("No seats available, " + passenger.getName() + " added to the waiting list.");
                }else{
                    throw new Exception("Waiting list is full, can't add the Passengers to WaitingList");
                }
            }
        }
        return bookedSeats;
    }

    private boolean isSeatsAvailable(List<ChairCarTrain> trains, String source, String destination, int passengerCount) {
        for(ChairCarTrain train : trains) {
            List<Seat> seats = train.getSeats();
            if(passengerCount < getAvailabeSeatCounts(source, destination, train.getRoutes(), seats)){
                return true;
            }
        }
        return false;
    }

    private boolean isRouteValid(String source, String destination, List<String> routes) {
        return routes.contains(source) && routes.contains(destination);
    }
}
