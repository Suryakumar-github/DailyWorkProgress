package dataLayer;

import model.ChairCarTrain;

import java.util.ArrayList;
import java.util.List;

public class DataLayer {
    public static DataLayer instance;
    private List<ChairCarTrain> trains = new ArrayList<>();

    private DataLayer() {

    }
    public static DataLayer getInstance() {
        if(instance == null) {
             instance = new DataLayer();
        }
        return instance;
    }

    public List<ChairCarTrain> getAllTrains()
    {
        return trains;
    }
    public void setAllTrains(List<ChairCarTrain> trains)
    {
       System.out.println(trains.size());
        this.trains = trains;
    }
}
