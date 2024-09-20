
import controller.TrainReservation;
import service.ReservationSystem;
import view.TrainView;

public class TrainReservationApp {
    public static void main(String[] args)  {
        ReservationSystem reservationSystem = new TrainReservation();
        TrainView view = new TrainView();

        while (true) {
            int choice = view.displayMenuAndGetChoice();

            switch (choice) {
                case 1:
                    try {
                        reservationSystem.bookTicket();
                        break;
                    }
                    catch (Exception e) {
                        System.out.println(e.getMessage());
                        System.exit(0);
                    }

                case 2:
                    reservationSystem.cancelTicket();
                    break;
                case 3:
                    reservationSystem.prepareOccupancyChart();
                    break;
                case 4:
                    view.displayMessage("Exiting...");
                    System.exit(0);
                    break;
                default:
                    view.displayMessage("Invalid choice.");
            }
        }
    }
}

