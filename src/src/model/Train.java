package model;

import java.util.ArrayList;
import java.util.List;

public class Train {
    private static int trainCounter = 100;
    private int trainNumber;
    private String trainName;
    private List<String> routes;

    Train(String trainName, String[] routes) {
        trainNumber = trainCounter++;
        this.trainName = trainName;
        this.routes = new ArrayList<>();
        for (String route : routes) {
            this.routes.add(route);
        }
    }

    public String getTrainName() {
        return trainName;
    }

    public List<String> getRoutes() {
        return routes;
    }
    public int getTrainNumber() {
        return this.trainNumber;
    }

    public String toString() {
        return "Train{" +
                "trainNumber=" + trainNumber +
                ", trainName='" + trainName + '\'' +
                ", routes=" + routes +
                '}';
    }
}
