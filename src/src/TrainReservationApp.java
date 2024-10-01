import fileHandler.ChairCarTrainHandler;
import fileHandler.TicketHandler;
import view.TrainView;

public class TrainReservationApp {
    public static void main(String[] args) throws Exception {
        loader();
        TrainView trainView = new TrainView();
        trainView.start();
    }

    private static void loader()
    {
        ChairCarTrainHandler.readChairCarTrainsFromCSV();
        TicketHandler.readTicketsFromCSV();
    }
}
/* 100,sk,A;B;C;D;E,1;EMPTY|2;EMPTY|3;EMPTY|4;EMPTY|5;EMPTY|6;EMPTY|7;EMPTY|8;EMPTY|,,0.0
   101,vaigai,X;Y;C,1;EMPTY|2;EMPTY|3;EMPTY|4;EMPTY|5;EMPTY|6;EMPTY|7;EMPTY|8;EMPTY|,,0.0 */