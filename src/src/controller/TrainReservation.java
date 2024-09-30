package controller;
import dao.TicketDAO;
import dao.TicketDAOImpl;
import dao.TrainDAOImpl;
import dataLayer.DataLayer;
import fileHandler.ChairCarTrainHandler;
import model.*;
import service.AdminHandle;
import service.ReservationSystem;
import view.TrainView;
import java.util.ArrayList;
import java.util.List;

public class TrainReservation implements ReservationSystem {

    private final TrainDAOImpl trainDAO = new TrainDAOImpl();
    private final TicketDAO ticketDAO = new TicketDAOImpl();
    private final TrainView trainView = new TrainView();
    private final AdminHandle adminHandle = new AdminController();
    private final SeatController seatController = new SeatController();
    private static final DataLayer dataLayer = DataLayer.getInstance();
    @Override
    public void bookTicket(String source, String destination, int numberOfPassengers)  {

        ChairCarTrain selectedTrain = findTrainForRoute(source, destination);

        if (selectedTrain == null) {
            findConnectingTrain(source, destination, numberOfPassengers);
        } else {
            if (seatController.isSeatsAvailable(selectedTrain, source, destination, numberOfPassengers)) {
                if (isWaitingListFull(selectedTrain, numberOfPassengers)) {
                    trainView.displayMessage("No seats available and the waiting list is full. Unable to book the ticket.");
                    return;
                }
            }
        }
        bookTicket(numberOfPassengers, selectedTrain, source, destination);

    }

    private void bookTicket(int numberOfPassengers, ChairCarTrain selectedTrain, String source, String destination)
    {
        List<Passenger> passengers = trainView.getPassengers(numberOfPassengers);
        List<Seat> bookedSeats;
        float ticketPrice = 0.0f;
        try {
            List<Integer> trainNumbers = new ArrayList<>();
            if (selectedTrain != null) {
                bookedSeats = seatController.allocateSeats(selectedTrain, source, destination, passengers);
                trainNumbers.add(selectedTrain.getTrainNumber());
                ticketPrice = calculateTicketPrice(source, destination, selectedTrain.getRoutes()) * numberOfPassengers;
                selectedTrain.setTotalEarning(ticketPrice);
                Ticket ticket = new Ticket(source, destination, trainNumbers, bookedSeats, ticketPrice);
                ticketDAO.addTicket(ticket);
                trainView.printTicket(ticket);
                System.out.println(selectedTrain.getTrainName() + selectedTrain.getTrainNumber());
                ChairCarTrainHandler.updateChairCarTrain();
            }
            else
            {
                bookedSeats = seatController.allocateSeats(trainDAO.getTrain2(), source, findCommonStation(source, destination), passengers);
                bookedSeats.addAll(seatController.allocateSeats(trainDAO.getTrain1(), findCommonStation(source, destination), destination, passengers));
                trainNumbers.add(trainDAO.getTrain2().getTrainNumber());
                trainNumbers.add(trainDAO.getTrain1().getTrainNumber());
                float ticketPrice1 = calculateTicketPrice(source, findCommonStation(source, destination),trainDAO.getTrain2().getRoutes()) * numberOfPassengers;
                trainDAO.getTrain2().setTotalEarning(ticketPrice1);
                float ticketPrice2 =  calculateTicketPrice(findCommonStation(source, destination), destination,trainDAO.getTrain1().getRoutes()) * numberOfPassengers;
                trainDAO.getTrain1().setTotalEarning(ticketPrice2);
                ticketPrice = ticketPrice1 + ticketPrice2;
                Ticket ticket = new Ticket(source, destination, trainNumbers, bookedSeats, ticketPrice);
                ticketDAO.addTicket(ticket);
                trainView.printTicket(ticket);
                System.out.println(trainDAO.getTrain2().getTrainName() + trainDAO.getTrain1().getTrainName() );
               ChairCarTrainHandler.updateChairCarTrain();
            }

        } catch (Exception e) {
            trainView.displayMessage("Booking failed: " );
            e.printStackTrace();
        }
    }

    private float calculateTicketPrice(String source, String destination, List<String> routes) {
        float ticketPrice = (float) (routes.indexOf(source) - routes.indexOf(destination));
        return Math.abs(ticketPrice) * 50.0f;
    }

    private void findConnectingTrain(String source, String destination, int numberOfPassengers) {
        String commonStation = findCommonStation(source, destination);
        if (commonStation != null) {
            if(isRouteValid(source, commonStation,(trainDAO).getTrain2().getRoutes()) &&
                    isRouteValid(commonStation, destination,(trainDAO).getTrain1().getRoutes())) {
                if (seatController.isSeatsAvailable(( trainDAO).getTrain2(), source, commonStation, numberOfPassengers) ||
                        seatController.isSeatsAvailable(( trainDAO).getTrain1(), commonStation, destination, numberOfPassengers)) {// downcasted to access child specific methods
                    trainView.displayMessage("No seats available for the full journey.");
                }
            }else{
                trainView.displayMessage("No Train Available for the given Source and Destination");
            }
        } else {
            trainView.displayMessage("No valid route found.");
            trainView.displayMenuAndGetChoice();
        }
    }

    private boolean isWaitingListFull(ChairCarTrain train, int passengerCount) {
        int availableWaitingListSpots = 2 - train.getWaitingListPassengers().size();
        return passengerCount > availableWaitingListSpots;
    }

    private ChairCarTrain findTrainForRoute(String source, String destination) {
        for (ChairCarTrain train : dataLayer.getAllTrains()) {
            if (isRouteValid(source, destination, train.getRoutes())) {
                return train;
            }
        }
        return null;
    }

    @Override
    public void cancelTicket(int pnr) {
        Ticket ticketToCancel = ticketDAO.getTicketByPNR(pnr);

        if (ticketToCancel != null) {
            trainView.displayTicketDetails(ticketToCancel);
            List<Integer> passengersSerialNo = trainView.getPassengersSerialNumber(ticketToCancel);
            String canceledSource = ticketToCancel.getSource();
            String canceledDestination = ticketToCancel.getDestination();
            List<Integer> trainNumbers = ticketToCancel.getTrainNumbers();
            List<Seat> seats = ticketToCancel.getSeats();
            if(trainNumbers.size() == 1) {
                cancelTicket(ticketToCancel,trainNumbers.get(0), canceledSource, canceledDestination, seats, passengersSerialNo);
            }
            else{
                cancelTicket(ticketToCancel, trainNumbers, canceledSource, canceledDestination, seats, passengersSerialNo);
            }
        } else {
            trainView.displayMessage("PNR not found.");
        }
    }

    public void cancelTicket(Ticket ticket, int trainNumber, String canceledSource, String canceledDestination, List<Seat> seats, List<Integer> passengersSerialNo) {
        ChairCarTrain train = getTrainByTrainNumber(trainNumber);
        if (train != null) {
            List<Seat> seats1 = train.getSeats();
            for (Integer serialNo : passengersSerialNo) {
                Seat seat = seats1.get(serialNo - 1);
                seatController.setSeatUnOccupied(canceledSource, canceledDestination, seat);
            }

        }
        trainView.displayMessage("Train Cancelled Successfully");
        if (passengersSerialNo.size() == seats.size()) {
            ticketDAO.removeTicket(ticket);
        }

        reAllocateSeatsFromWaitingList(trainNumber, canceledSource, canceledDestination);
    }


    private void cancelTicket(Ticket ticket, List<Integer> trainNumbers, String canceledSource, String canceledDestination, List<Seat> seats, List<Integer> passengersSerialNo) {

        ChairCarTrain train = getTrainByTrainNumber(trainNumbers.get(0));
        if(train != null) {
            List<Seat> seats1 = train.getSeats();
            for(int i = 0; i < passengersSerialNo.size(); i++) {
                seatController.setSeatUnOccupied(canceledSource, findCommonStation(canceledSource, canceledDestination), seats1.get(i));
            }
        }

        ChairCarTrain train1 = getTrainByTrainNumber(trainNumbers.get(1));
        if(train1 != null) {
            List<Seat> seats1 = train1.getSeats();
            for(int i = 0; i < passengersSerialNo.size(); i++) {
                seatController.setSeatUnOccupied(findCommonStation(canceledSource, canceledDestination), canceledDestination, seats1.get(i));
            }
        }
        trainView.displayMessage("Train Cancelled Successfully");
        if (passengersSerialNo.size() == seats.size()) {
            ticketDAO.removeTicket(ticket);
        }

        reAllocateSeatsFromWaitingList(trainNumbers.get(0), canceledSource, findCommonStation(canceledSource, canceledDestination));
        reAllocateSeatsFromWaitingList(trainNumbers.get(1), findCommonStation(canceledSource, canceledDestination), canceledDestination);

    }

    private void reAllocateSeatsFromWaitingList(int trainNumber, String canceledSource, String canceledDestination) {
        ChairCarTrain train = getTrainByTrainNumber(trainNumber);
        if(train != null) {
            adminHandle.allocateSeatFromWaitingList(canceledSource, canceledDestination,trainNumber);
        }
    }

    private ChairCarTrain getTrainByTrainNumber(int trainNumber) {
        for(ChairCarTrain train : dataLayer.getAllTrains()) {
            if(train.getTrainNumber() == trainNumber) {
                return train;
            }
        }
        return null;
    }

    public String findCommonStation(String source, String destination) {
        for (String station : (trainDAO).getTrain1().getRoutes()) {
            if ((trainDAO).getTrain2().getRoutes().contains(station) && (trainDAO).getTrain2().getRoutes().contains(source) ||
                    (trainDAO).getTrain2().getRoutes().contains(destination) ) {
                return station;
            }
        }
        return null;
    }

    public boolean isRouteValid(String source, String destination, List<String> routes) {
        return routes.contains(source) && routes.contains(destination) && routes.indexOf(source) < routes.indexOf(destination);
    }

    public List<ChairCarTrain> getAllTrains(String startingPoint, String destination) {
        List<ChairCarTrain> trainsInLocation = new ArrayList<>();
        List<ChairCarTrain> trains = dataLayer.getAllTrains();
        for(ChairCarTrain train : trains) {
            if(isRouteValid(startingPoint,destination, train.getRoutes())){
                trainsInLocation.add(train);
            }
        }
        return trainsInLocation;
    }
}