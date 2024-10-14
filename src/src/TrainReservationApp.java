import controller.*;
import dao.*;
import fileHandler.ChairCarTrainFileHandler;
import fileHandler.TicketFileHandler;
import fileHandler.UserFileHandler;
import view.MainView;

public class TrainReservationApp {

    private final AdminController adminController;
    private final SeatControllerImpl seatController;
    private final TrainDAO trainDAO = TrainDAOImpl.getInstance();
    private final TicketDAO ticketDAO = TicketDAOImpl.getInstance();
    private final UserDAO userDAO = UserDAOImpl.getInstance();

    public TrainReservationApp() {

        this.seatController = new SeatControllerImpl();
        this.adminController = new AdminControllerImpl(seatController);

        seatController.setAdminHandle(adminController);
    }

    public static void main(String[] args) throws Exception {
        TrainReservationApp trainReservationApp = new TrainReservationApp();
        trainReservationApp.loader();
    }

    private void loader() throws Exception {
        //new ChairCarTrainFileHandler().removeFile();
        trainDAO.setTrains(new ChairCarTrainFileHandler().getTrains());
        ticketDAO.setTickets(new TicketFileHandler().getTickets());
        userDAO.setUsers(new UserFileHandler().getUsers());

        MainView mainView = new MainView(adminController, seatController);
        mainView.start();
    }
}
