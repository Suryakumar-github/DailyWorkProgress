package dao;

import model.ChairCarTrain;

import java.util.ArrayList;
import java.util.List;

public class TrainDAOImpl implements TrainDAO {
    private static ChairCarTrain train1 = new ChairCarTrain("Train 1", new String[]{"A", "B", "C", "D", "E"});;
    private static ChairCarTrain train2 = new ChairCarTrain("Train 2", new String[]{"X", "Y", "C"}); ;
    private static List<ChairCarTrain> trains = new ArrayList<>();

    public TrainDAOImpl() {
        if(trains.isEmpty()){
            addTrains(train1,train2);
        }
    }

    void addTrains(ChairCarTrain train1, ChairCarTrain train2) {
        trains.add(train1);
        trains.add(train2);
    }
    public ChairCarTrain getTrain1() {
        return train1;
    }

    public ChairCarTrain getTrain2() {
        return train2;
    }

    @Override
    public List<ChairCarTrain> getAllTrains() {
        return trains;
    }

    @Override
    public ChairCarTrain getTrainByNumber(int trainNumber) {
        for (ChairCarTrain train : trains) {
            if (trainNumber == train.getTrainNumber()) {
                return train;
            }
        }
        return null;
    }

}
