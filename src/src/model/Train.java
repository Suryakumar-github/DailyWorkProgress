package model;

import java.util.List;

public class Train {
    String trainName;
    List<Seat> seats;
    String[] routes;

    Train(String trainName, List<Seat> seats,String[] routes) {
        this.trainName = trainName;
        this.seats = seats;
        this.routes = routes;
    }
    Train(String trainName, String[] routes) {
        this.trainName = trainName;
        this.routes = routes;
    }
    public String getTrainName() {
        return trainName;
    }
    public List<Seat> getSeats() {
        return seats;
    }
    public String[] getRoutes() {
        return routes;
    }

}
