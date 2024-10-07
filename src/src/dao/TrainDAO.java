package dao;

import model.ChairCarTrain;

import java.util.List;

public interface TrainDAO {

    ChairCarTrain getTrainByNumber(int trainNumber);
    void addTrain(ChairCarTrain train);
    List<ChairCarTrain> getTrains();
    void updateTrain();
    void setTrains(List<ChairCarTrain> trains);
}

