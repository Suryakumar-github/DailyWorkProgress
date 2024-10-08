import controller.*;
import fileHandler.ChairCarTrainFileHandler;
import fileHandler.TicketFileHandler;
import fileHandler.UserFileHandler;
import view.AdminView;
import view.MainView;
import view.UserView;
import controller.Traincontroller;

public class TrainReservationApp {
    private final AdminView adminView;
    private final UserView userView;
    private final AdminController adminController;
    private final Traincontroller trainController;
    private final SeatControllerImpl seatController;

    public TrainReservationApp() {

        this.adminView = new AdminView();
        this.userView = new UserView();
        this.seatController = new SeatControllerImpl();
        this.adminController = new AdminControllerImpl(seatController, adminView);
        this.trainController = new TrainControllerImpl(adminController, seatController, userView);

        seatController.setAdminHandle(adminController);

        adminView.setAdminController(adminController);
        adminView.setSeatController(seatController);
        adminView.setTrainController(trainController);

        userView.setTrainController(trainController);
        userView.setAdminController(adminController);
        userView.setAdminView(adminView);
    }

    public static void main(String[] args) throws Exception {
        TrainReservationApp trainReservationApp = new TrainReservationApp();
        trainReservationApp.loader();
    }

    private void loader() throws Exception {
        //new ChairCarTrainFileHandler().removeFile();
        trainController.setTrains(new ChairCarTrainFileHandler().getTrains());
        trainController.setTickets(new TicketFileHandler().getTickets());
        adminController.setUser(new UserFileHandler().getUsers());

        MainView mainView = new MainView(adminController, userView, adminView);
        mainView.start();
    }
}
