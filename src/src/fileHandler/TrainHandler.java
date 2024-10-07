package fileHandler;

import model.ChairCarTrain;

import java.util.List;

public interface TrainHandler {

    void addTrain(ChairCarTrain train);
    List<ChairCarTrain> getTrains();
    void updateTrain();

}
