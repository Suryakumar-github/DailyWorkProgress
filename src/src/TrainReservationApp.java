import controller.AdminController;
import controller.SeatController;
import controller.TrainController;
import dao.*;
import fileHandler.*;
import service.AdminHandle;
import service.ReservationSystem;
import service.SeatHandler;
import view.AdminView;
import view.MainView;
import view.UserView;

public class TrainReservationApp {
    private static UserHandler userHandler = new UserFileHandler();
    private static TrainHandler trainHandler = new ChairCarTrainFileHandler();
    private static  TicketHandler ticketHandler = new TicketFileHandler();
    private static UserDAO userDAO = UserDAOImpl.getInstance(userHandler);
    private static TicketDAO ticketDAO = TicketDAOImpl.getInstance(ticketHandler);
    private static TrainDAO trainDAO = TrainDAOImpl.getInstance(trainHandler);
    private static SeatHandler seatHandler = new SeatController();
    private static AdminHandle adminHandle = new AdminController(trainDAO, userDAO, seatHandler);

    static {
        ((SeatController) seatHandler).setAdminHandle(adminHandle);
    }

    private static AdminView adminView = new AdminView();
    private static UserView userView = new UserView();

    private static ReservationSystem reservationSystem = new TrainController(trainDAO, ticketDAO, adminHandle, seatHandler);

    static {
        ((TrainController) reservationSystem).setAdminView(adminView);
        ((TrainController) reservationSystem).setUserView(userView);

        adminView.setAdminHandle(adminHandle);
        adminView.setSeatHandler(seatHandler);
        adminView.setReservationSystem(reservationSystem);

        userView.setReservationSystem(reservationSystem);
        userView.setAdminHandle(adminHandle);
        userView.setAdminView(adminView);
    }

    public static void main(String[] args) throws Exception {
        loader();
        MainView mainView = new MainView(seatHandler, adminHandle, reservationSystem, userView, adminView);
        mainView.start();
    }

    private static void loader() {

        trainDAO.setTrains(new ChairCarTrainFileHandler().getTrains());
        ticketDAO.setTickets(new TicketFileHandler().getTickets());
        userDAO.setUsers(new UserFileHandler().getUsers());
    }
}


/* 100,sk,A;B;C;D;E,1;EMPTY|2;EMPTY|3;EMPTY|4;EMPTY|5;EMPTY|6;EMPTY|7;EMPTY|8;EMPTY|,,0.0
   101,vaigai,X;Y;C,1;EMPTY|2;EMPTY|3;EMPTY|4;EMPTY|5;EMPTY|6;EMPTY|7;EMPTY|8;EMPTY|,,0.0 */