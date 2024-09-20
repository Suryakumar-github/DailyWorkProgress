package model;

import java.util.List;

public class Train {
    String trainName;
    List<Seat> seats;
    List<String> routes;

    Train(String trainName, List<Seat> seats,String[] routes) {
        this.trainName = trainName;
        this.seats = seats;
        for (String route : routes) {
            this.routes.add(route);
        }
    }
    Train(String trainName, String[] routes) {
        this.trainName = trainName;
        for (String route : routes) {
            this.routes.add(route);
        }
    }
    public String getTrainName() {
        return trainName;
    }
    public List<Seat> getSeats() {
        return seats;
    }
    public List<String> getRoutes() {
        return routes;
    }

}
