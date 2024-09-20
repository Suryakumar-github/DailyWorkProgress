package controller;

import dao.TicketDAO;
import dao.TicketDAOImpl;
import dao.TrainDAO;
import dao.TrainDAOImpl;
import model.Passenger;
import model.Seat;
import model.Ticket;
import model.ChairCarTrain;
import service.ReservationSystem;
import view.TrainView;
import java.util.ArrayList;
import java.util.List;

public class TrainReservation implements ReservationSystem {

    private TrainDAO trainDAO = new TrainDAOImpl();
    private TicketDAO ticketDAO = new TicketDAOImpl();
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
                if (!isSeatsAvailable(((TrainDAOImpl)trainDAO).getTrain2(), source, commonStation, numberOfPassengers) ||
                        !isSeatsAvailable(((TrainDAOImpl)trainDAO).getTrain1(), commonStation, destination, numberOfPassengers)) {// downcasted to access child specific methods
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
                bookedSeats = allocateSeats(((TrainDAOImpl)trainDAO).getTrain2(), source, findCommonStation(), passengers);
                bookedSeats.addAll(allocateSeats(((TrainDAOImpl)trainDAO).getTrain1(), findCommonStation(), destination, passengers));
                trainNumbers.add(((TrainDAOImpl)trainDAO).getTrain2().getTrainName().hashCode());
                trainNumbers.add(((TrainDAOImpl)trainDAO).getTrain1().getTrainName().hashCode());
            }

            Ticket ticket = new Ticket(source, destination, trainNumbers, bookedSeats);
            ticketDAO.addTicket(ticket);
            ticket.printTicket();
        } catch (Exception e) {
            trainView.displayMessage("Booking failed: " + e.getMessage());
        }
    }

    private boolean isWaitingListFull(ChairCarTrain train, int passengerCount) {
        int availableWaitingListSpots = 2 - train.getWaitingListPassengers().size();
        return passengerCount > availableWaitingListSpots;
    }

    private ChairCarTrain findTrainForRoute(String source, String destination) {
        for (ChairCarTrain train : trainDAO.getAllTrains()) {
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

    @Override
    public void cancelTicket() {

        int pnr = trainView.getPnrToCancel();
        Ticket ticketToCancel = ticketDAO.getTicketByPNR(pnr);

        if (ticketToCancel != null) {
            ticketDAO.removeTicket(ticketToCancel);
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
                ((TrainDAOImpl)trainDAO).allocateSeatFromWaitingList(canceledSource, canceledDestination,trainNumber);
            }
        }
    }

    private ChairCarTrain getTrainByTrainNumber(int trainNumber) {
        for(ChairCarTrain train : trainDAO.getAllTrains()) {
            if(train.getTrainName().hashCode() == trainNumber) {
                return train;
            }
        }
        return null;
    }

    @Override
    public void prepareOccupancyChart() {
        for(ChairCarTrain train : trainDAO.getAllTrains()) {
            trainView.printOccupancyChart(train);
        }
    }

    private String findCommonStation() {
        for (String station : ((TrainDAOImpl)trainDAO).getTrain1().getRoutes()) {
            if (((TrainDAOImpl)trainDAO).getTrain2().getRoutes().contains(station)) {
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
                if(((TrainDAOImpl)trainDAO).addPassengerToWaitingList(passenger,new String[] {source,destination},train.getTrainName().hashCode())) {
                    trainView.displayMessage("No seats available, " + passenger.getName() + " added to the waiting list.");
                }else{
                    throw new Exception("Waiting list is full, can't add the Passengers to WaitingList");
                }
            }
        }
        return bookedSeats;
    }

    private boolean isRouteValid(String source, String destination, List<String> routes) {
        return routes.contains(source) && routes.contains(destination);
    }
}