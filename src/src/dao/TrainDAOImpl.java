package dao;
import dataLayer.DataLayer;
import fileHandler.ChairCarTrainHandler;
import model.ChairCarTrain;
import java.util.ArrayList;
import java.util.List;

public class TrainDAOImpl implements TrainDAO {

    private  List<ChairCarTrain> trains = new ArrayList<>();
    DataLayer dataLayer = DataLayer.getInstance();
    public TrainDAOImpl() {
    }

    @Override
    public void addTrain(ChairCarTrain train) {
        ChairCarTrainHandler.writeChairCarTrainToCSV(train);
    }
    public ChairCarTrain getTrain1() {
        List<ChairCarTrain> trains = dataLayer.getAllTrains();
        return trains.get(0);
    }

    public ChairCarTrain getTrain2() {
        List<ChairCarTrain> trains = dataLayer.getAllTrains();
        return trains.get(1);
    }

    @Override
    public ChairCarTrain getTrainByNumber(int trainNumber) {
        for (ChairCarTrain train : dataLayer.getAllTrains()) {
            if (trainNumber == train.getTrainNumber()) {
                return train;
            }
        }
        return null;
    }


}
