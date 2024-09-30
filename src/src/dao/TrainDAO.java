package dao;

import model.ChairCarTrain;

public interface TrainDAO {
    ChairCarTrain getTrainByNumber(int trainNumber);
    void addTrain(ChairCarTrain train);
}

