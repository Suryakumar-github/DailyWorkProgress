package model;

import java.util.ArrayList;
import java.util.List;

public class Train {
    String trainName;
    List<Seat> seats;
    List<String> routes;

    Train(String trainName, String[] routes) {
        this.trainName = trainName;
        this.seats = new ArrayList<>();
        this.routes = new ArrayList<>();
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
