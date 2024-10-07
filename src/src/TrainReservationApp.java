import controller.*;
import fileHandler.ChairCarTrainFileHandler;
import fileHandler.TicketFileHandler;
import fileHandler.UserFileHandler;
import view.AdminView;
import view.MainView;
import view.UserView;

public class TrainReservationApp {

    private static SeatController seatController = new SeatControllerImpl();
    private static AdminController adminController = new AdminControllerImpl(seatController);

    static {
        ((SeatControllerImpl) seatController).setAdminHandle(adminController);
    }

    private static AdminView adminView = new AdminView();
    private static UserView userView = new UserView();

    private static Traincontroller trainController = new TrainControllerImpl(adminController, seatController);

    static {
        ((TrainControllerImpl) trainController).setAdminView(adminView);
        ((TrainControllerImpl) trainController).setUserView(userView);
        ((AdminControllerImpl) adminController).setAdminView(adminView);

        adminView.setAdminController(adminController);
        adminView.setSeatController(seatController);
        adminView.setTrainController(trainController);

        userView.setTrainController(trainController);
        userView.setAdminController(adminController);
        userView.setAdminView(adminView);
    }

    public static void main(String[] args) throws Exception {
        loader();
        MainView mainView = new MainView(adminController, userView, adminView);
        mainView.start();
    }

    private static void loader() {
        //new ChairCarTrainFileHandler().removeFile();
        trainController.setTrains(new ChairCarTrainFileHandler().getTrains());
        trainController.setTickets( new TicketFileHandler().getTickets());
        adminController.setUser(new UserFileHandler().getUsers());
    }
}


/* 100,sk,A;B;C;D;E,1;EMPTY|2;EMPTY|3;EMPTY|4;EMPTY|5;EMPTY|6;EMPTY|7;EMPTY|8;EMPTY|,,0.0
   101,vaigai,X;Y;C,1;EMPTY|2;EMPTY|3;EMPTY|4;EMPTY|5;EMPTY|6;EMPTY|7;EMPTY|8;EMPTY|,,0.0 */