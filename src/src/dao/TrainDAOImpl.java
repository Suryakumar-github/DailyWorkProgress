package dao;
import fileHandler.TrainHandler;
import model.ChairCarTrain;
import java.util.ArrayList;
import java.util.List;

public class TrainDAOImpl implements TrainDAO {

    private List<ChairCarTrain> trains = new ArrayList<>();
    private static TrainDAOImpl instance ;
    TrainHandler trainHandler ;
    private TrainDAOImpl(TrainHandler trainHandler) {
        this.trainHandler = trainHandler;
    }

    public static TrainDAOImpl getInstance(TrainHandler trainHandler) {

        if(instance == null)
        {
            instance = new TrainDAOImpl(trainHandler);
        }
        return instance;
    }

    @Override
    public void addTrain(ChairCarTrain train) {
        trains.add(train);
        trainHandler.addTrain(train);
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
    @Override
    public List<ChairCarTrain> getTrains() {
        return trains;
    }

    @Override
    public void updateTrain() {
        trainHandler.updateTrain();
    }

    public void setTrains(List<ChairCarTrain> trains)
    {
        this.trains = trains;
    }


}
