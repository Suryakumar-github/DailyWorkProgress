package controller;
import dao.TicketDAO;
import dao.TicketDAOImpl;
import dao.TrainDAOImpl;
import fileHandler.ChairCarTrainFileHandler;
import fileHandler.TicketFileHandler;
import fileHandler.TicketHandler;
import fileHandler.TrainHandler;
import model.*;
import view.AdminView;
import view.UserView;

import java.util.ArrayList;
import java.util.List;

public class TrainControllerImpl implements Traincontroller {
    TrainHandler trainHandler = new ChairCarTrainFileHandler();
    TicketHandler ticketHandler = new TicketFileHandler();
    private final TrainDAOImpl trainDAO = TrainDAOImpl.getInstance(trainHandler) ;
    private final TicketDAO ticketDAO = TicketDAOImpl.getInstance(ticketHandler);
    private final AdminController adminHandle ;
    private final SeatController seatController;
    private  UserView userView ;
    private  AdminView adminView ;

    public TrainControllerImpl(AdminController adminHandle, SeatController seatHandler) {
        this.adminHandle = adminHandle;
        this.seatController = seatHandler;
    }

    public void setAdminView(AdminView adminView) {
        this.adminView = adminView;
    }

    public void setUserView(UserView userView) {
        this.userView = userView;
    }

    @Override
    public void bookTicket(String source, String destination, int numberOfPassengers)  {

        ChairCarTrain selectedTrain = findTrainForRoute(source, destination);

        if (selectedTrain == null)
        {
            ConnectingTrains connectingTrains = findConnectingTrain(source, destination, numberOfPassengers);
            bookTicket(numberOfPassengers, connectingTrains, source, destination);
        }
        else
        {
            if (seatController.isSeatsAvailable(selectedTrain, source, destination, numberOfPassengers))
            {
                if (isWaitingListFull(selectedTrain, numberOfPassengers))
                {
                    adminView.displayMessage("No seats available and the waiting list is full. Unable to book the ticket.");
                    return;
                }
            }
        }
        bookTicket(numberOfPassengers, selectedTrain, source, destination);

    }

    private void bookTicket(int numberOfPassengers, ConnectingTrains connectingTrains, String source, String destination)  {
        List<Passenger> passengers = userView.getPassengers(numberOfPassengers);
        List<Seat> bookedSeats;
        float ticketPrice = 0.0f;
        try {
            if (connectingTrains != null) {
                List<Integer> trainNumbers = new ArrayList<>();
                bookedSeats = seatController.allocateSeats(connectingTrains.getTrain1(), source, findCommonStation(source, destination).getCommonStation(), passengers);
                bookedSeats.addAll(seatController.allocateSeats(connectingTrains.getTrain2(), findCommonStation(source, destination).getCommonStation(), destination, passengers));
                trainNumbers.add(connectingTrains.getTrain1().getTrainNumber());
                trainNumbers.add(connectingTrains.getTrain2().getTrainNumber());
                float ticketPrice1 = calculateTicketPrice(source, findCommonStation(source, destination).getCommonStation(), connectingTrains.getTrain1().getRoutes()) * numberOfPassengers;
                connectingTrains.getTrain1().setTotalEarning(ticketPrice1);
                float ticketPrice2 = calculateTicketPrice(findCommonStation(source, destination).getCommonStation(), destination, connectingTrains.getTrain2().getRoutes()) * numberOfPassengers;
                connectingTrains.getTrain2().setTotalEarning(ticketPrice2);
                ticketPrice = ticketPrice1 + ticketPrice2;
                Ticket ticket = new Ticket(source, destination, trainNumbers, bookedSeats, ticketPrice);
                ticketDAO.addTicket(ticket);
                adminView.printTicket(ticket);
                trainDAO.updateTrain();
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }

    private void bookTicket(int numberOfPassengers, ChairCarTrain selectedTrain, String source, String destination)
    {
        List<Passenger> passengers = userView.getPassengers(numberOfPassengers);
        List<Seat> bookedSeats;
        float ticketPrice = 0.0f;
        try {
            List<Integer> trainNumbers = new ArrayList<>();
            if (selectedTrain != null)
            {
                bookedSeats = seatController.allocateSeats(selectedTrain, source, destination, passengers);
                trainNumbers.add(selectedTrain.getTrainNumber());
                ticketPrice = calculateTicketPrice(source, destination, selectedTrain.getRoutes()) * numberOfPassengers;
                selectedTrain.setTotalEarning(ticketPrice);
                Ticket ticket = new Ticket(source, destination, trainNumbers, bookedSeats, ticketPrice);
                ticketDAO.addTicket(ticket);
                adminView.printTicket(ticket);
                trainDAO.updateTrain();
            }
        }
        catch (Exception e)
        {
            adminView.displayMessage("Booking failed: " );
            e.printStackTrace();
        }
    }

    private float calculateTicketPrice(String source, String destination, List<String> routes) {
        float ticketPrice = (float) (routes.indexOf(source) - routes.indexOf(destination));
        return Math.abs(ticketPrice) * 50.0f;
    }

    private ConnectingTrains findConnectingTrain(String source, String destination, int numberOfPassengers) {
        ConnectingTrains connectingTrains = findCommonStation(source, destination);
        if(connectingTrains != null ) {
            String commonStation = connectingTrains.getCommonStation();
            if (commonStation != null) {
                if (isRouteValid(source, commonStation, connectingTrains.getTrain1().getRoutes()) &&
                        isRouteValid(commonStation, destination, connectingTrains.getTrain2().getRoutes())) {
                    if (seatController.isSeatsAvailable(connectingTrains.getTrain1(), source, commonStation, numberOfPassengers) ||
                            seatController.isSeatsAvailable(connectingTrains.getTrain2(), commonStation, destination, numberOfPassengers)) {
                        adminView.displayMessage("No seats available for the full journey.");
                    }
                } else {
                    adminView.displayMessage("No Train Available for the given Source and Destination");
                }
            }
        }
        else
        {
            adminView.displayMessage("No valid route found.");
        }
        return connectingTrains;
    }

    private boolean isWaitingListFull(ChairCarTrain train, int passengerCount) {
        int availableWaitingListSpots = 2 - train.getWaitingListPassengers().size();
        return passengerCount > availableWaitingListSpots;
    }

    private ChairCarTrain findTrainForRoute(String source, String destination) {
        for (ChairCarTrain train : trainDAO.getTrains())
        {
            if (isRouteValid(source, destination, train.getRoutes()))
            {
                return train;
            }
        }
        return null;
    }

    @Override
    public void cancelTicket(int pnr) {
        Ticket ticketToCancel = ticketDAO.getTicketByPNR(pnr);

        if (ticketToCancel != null)
        {
            adminView.displayTicketDetails(ticketToCancel);
            List<Integer> passengersSerialNo = userView.getPassengersSerialNumber(ticketToCancel);
            String canceledSource = ticketToCancel.getSource();
            String canceledDestination = ticketToCancel.getDestination();
            List<Integer> trainNumbers = ticketToCancel.getTrainNumbers();
            List<Seat> seats = ticketToCancel.getSeats();
            if(trainNumbers.size() == 1)
            {
                cancelTicket(ticketToCancel,trainNumbers.get(0), canceledSource, canceledDestination, seats, passengersSerialNo);
            }
            else
            {
                cancelTicket(ticketToCancel, trainNumbers, canceledSource, canceledDestination, seats, passengersSerialNo);
            }
        } else
        {
            adminView.displayMessage("PNR not found.");
        }
    }

    public void cancelTicket(Ticket ticket, int trainNumber, String canceledSource, String canceledDestination, List<Seat> seats, List<Integer> passengersSerialNo) {
        ChairCarTrain train = getTrainByTrainNumber(trainNumber);
        if (train != null)
        {
            List<Seat> seats1 = train.getSeats();
            for (Integer serialNo : passengersSerialNo)
            {
                Seat seat = seats1.get(serialNo - 1);
                seatController.setSeatUnOccupied(canceledSource, canceledDestination, seat);
            }
            trainDAO.updateTrain();

        }
        adminView.displayMessage("Train Cancelled Successfully");
        if (passengersSerialNo.size() == seats.size())
        {
            ticketDAO.removeTicket(ticket);
        }

        reAllocateSeatsFromWaitingList(trainNumber, canceledSource, canceledDestination);
    }


    private void cancelTicket(Ticket ticket, List<Integer> trainNumbers, String canceledSource, String canceledDestination, List<Seat> seats, List<Integer> passengersSerialNo) {

        ChairCarTrain train = getTrainByTrainNumber(trainNumbers.get(0));
        if(train != null)
        {
            List<Seat> seats1 = train.getSeats();
            for(int i = 0; i < passengersSerialNo.size(); i++)
            {
                seatController.setSeatUnOccupied(canceledSource, findCommonStation(canceledSource, canceledDestination).getCommonStation(), seats1.get(i));
            }
            trainDAO.updateTrain();
        }

        ChairCarTrain train1 = getTrainByTrainNumber(trainNumbers.get(1));
        if(train1 != null)
        {
            List<Seat> seats1 = train1.getSeats();
            for(int i = 0; i < passengersSerialNo.size(); i++)
            {
                seatController.setSeatUnOccupied(findCommonStation(canceledSource, canceledDestination).getCommonStation(), canceledDestination, seats1.get(i));
            }
            trainDAO.updateTrain();
        }
        adminView.displayMessage("Train Cancelled Successfully");
        if (passengersSerialNo.size() == seats.size())
        {
            ticketDAO.removeTicket(ticket);
        }

        reAllocateSeatsFromWaitingList(trainNumbers.get(0), canceledSource, findCommonStation(canceledSource, canceledDestination).getCommonStation());
        reAllocateSeatsFromWaitingList(trainNumbers.get(1), findCommonStation(canceledSource, canceledDestination).getCommonStation(), canceledDestination);

    }

    private void reAllocateSeatsFromWaitingList(int trainNumber, String canceledSource, String canceledDestination) {
        ChairCarTrain train = getTrainByTrainNumber(trainNumber);
        if(train != null)
        {
            adminHandle.allocateSeatFromWaitingList(canceledSource, canceledDestination,trainNumber);
        }
    }


    private ChairCarTrain getTrainByTrainNumber(int trainNumber) {
        for(ChairCarTrain train : trainDAO.getTrains())
        {
            if(train.getTrainNumber() == trainNumber)
            {
                return train;
            }
        }
        return null;
    }

    @Override
    public ConnectingTrains findCommonStation(String source, String destination) {
        List<ChairCarTrain> trains = trainDAO.getTrains();
        for(ChairCarTrain train : trains) {
            if(train.getRoutes().contains(source) || train.getRoutes().contains(destination)) {
                return findCommonStation(train, source, destination);
            }
        }
        return null;
    }

    private ConnectingTrains findCommonStation(ChairCarTrain train, String source, String destination) {
        List<String > routes = train.getRoutes();

        for(String station : routes) {
            for(ChairCarTrain train1 : trainDAO.getTrains()) {
                if(!train.equals(train1) && train1.getRoutes().contains(station)) {
                    if(train.getRoutes().contains(source) && train1.getRoutes().contains(destination)) {
                       return new ConnectingTrains(train, train1, station);
                    }
                    else if(train1.getRoutes().contains(source) && train.getRoutes().contains(destination)) {
                        return new ConnectingTrains(train1, train, station);
                    }
                }
            }
        }
        return null;
    }

    public boolean isRouteValid(String source, String destination, List<String> routes) {
        return routes.contains(source) && routes.contains(destination) && routes.indexOf(source) < routes.indexOf(destination);
    }

    @Override
    public List<ChairCarTrain> getAllTrains(String startingPoint, String destination) {
        List<ChairCarTrain> trainsInLocation = new ArrayList<>();
        List<ChairCarTrain> trains = trainDAO.getTrains();
        for(ChairCarTrain train : trains)
        {
            if(isRouteValid(startingPoint,destination, train.getRoutes()))
            {
                trainsInLocation.add(train);
            }
        }
        return trainsInLocation;
    }

    @Override
    public ChairCarTrain getTrainByNumber(int trainNumber) {
        return trainDAO.getTrainByNumber(trainNumber);
    }
    @Override
    public void addTrain(ChairCarTrain train) {
        trainDAO.addTrain(train);
    }
    @Override
    public List<ChairCarTrain> getTrains() {
        return trainDAO.getTrains();
    }
    @Override
    public void setTrains(List<ChairCarTrain> trains) {
        trainDAO.setTrains(trains);
    }
    @Override
    public void setTickets(List<Ticket> tickets) {
        ticketDAO.setTickets(tickets);
    }
    public class ConnectingTrains {
        private ChairCarTrain train1;
        private ChairCarTrain train2;
        private String commonStation;

        public ConnectingTrains(ChairCarTrain train1, ChairCarTrain train2, String commonStation) {
            this.train1 = train1;
            this.train2 = train2;
            this.commonStation = commonStation;
        }

        public ChairCarTrain getTrain1() {
            return train1;
        }

        public ChairCarTrain getTrain2() {
            return train2;
        }

        public String getCommonStation() {
            return commonStation;
        }

    }

}