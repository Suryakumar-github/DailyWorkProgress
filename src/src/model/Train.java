package model;

import controller.TrainControllerImpl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Train {
    private static int trainCounter = 100;
    private int trainNumber;
    private String trainName;
    private List<String> routes;
    private double totalEarning;
    private TrainControllerImpl trainController ;

    public Train(String trainName, String[] routes) {
        trainNumber = trainCounter++;
        this.trainName = trainName;
        this.routes = new ArrayList<>();
        for (String route : routes) {
            this.routes.add(route);
        }
        this.totalEarning = 0;
    }

    public Train(String trainName, String[] routes, int trainNumber, double totalEarning) {
        this.trainName = trainName;
        this.trainNumber = trainNumber;
        this.totalEarning = totalEarning;
        this.routes = Arrays.asList(routes);
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

    public String display() {
        return "Train{" +
                "trainNumber=" + trainNumber +
                ", trainName='" + trainName + '\'' +
                ", routes=" + routes +
                '}';
    }
    public double getTotalEarning() {
        return totalEarning;
    }

    public void setTotalEarning(double totalEarning) {
        this.totalEarning += totalEarning;
    }
    public void setTrainName(String trainName) {
        this.trainName = trainName;
    }
    public void setRoutes(List<String> routes) {
        this.routes = routes;
    }
}
