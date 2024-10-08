package dao;
import fileHandler.ChairCarTrainFileHandler;
import fileHandler.TrainHandler;
import model.ChairCarTrain;
import java.util.ArrayList;
import java.util.List;

public class TrainDAOImpl implements TrainDAO {

    private final TrainHandler trainHandler = new ChairCarTrainFileHandler();
    private List<ChairCarTrain> trains = new ArrayList<>();
    private static TrainDAOImpl instance ;
    private TrainDAOImpl() {
    }

    public static TrainDAOImpl getInstance() {

        if(instance == null)
        {
            instance = new TrainDAOImpl();
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
