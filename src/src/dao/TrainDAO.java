package dao;

import model.ChairCarTrain;

import java.util.List;

public interface TrainDAO {
    List<ChairCarTrain> getAllTrains();
    ChairCarTrain getTrainByNumber(int trainNumber);
}

