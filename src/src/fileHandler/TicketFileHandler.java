package fileHandler;

import dao.TicketDAOImpl;
import model.Passenger;
import model.Seat;
import model.Ticket;
import validation.Validation;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

public class TicketFileHandler implements TicketHandler{

    private static final String TICKET_CSV_FILE = Paths.get("src", "files", "tickets.csv").toString();
    private static TicketDAOImpl ticketDAO = TicketDAOImpl.getInstance();

    @Override
    public void addTicket(Ticket ticket) {
        try (FileWriter fileWriter = new FileWriter(TICKET_CSV_FILE, true)) {
            fileWriter.append(String.valueOf(ticket.getPnr())).append(",");
            fileWriter.append(ticket.getSource()).append(",");
            fileWriter.append(ticket.getDestination()).append(",");
            fileWriter.append(listToString(ticket.getTrainNumbers())).append(",");
            fileWriter.append(seatsToString(ticket.getSeats())).append(",");
            fileWriter.append(String.valueOf(ticket.getTicketPrice())).append("\n");
            System.out.println("Ticket details successfully written to CSV.");
        } catch (IOException e) {
            System.out.println("Error while writing Ticket to CSV: " + e.getMessage());
        }
    }

    @Override
    public List<Ticket> getTickets() {
        List<Ticket> tickets = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(TICKET_CSV_FILE))) {
            String line ;
            while ((line = br.readLine()) != null) {
                String[] ticketData = line.split(",");
                    int pnr = Integer.parseInt(ticketData[0]);
                    String source = ticketData[1];
                    String destination = ticketData[2];
                    List<Integer> trainNumbers = stringToList(ticketData[3]);
                    List<Seat> seats = stringToSeats(ticketData[4]);
                    float ticketPrice = Float.parseFloat(ticketData[5]);

                    Ticket ticket = new Ticket(source, destination, trainNumbers, seats, ticketPrice);
                    tickets.add(ticket);
            }

        } catch (IOException e) {
            System.out.println("Error while reading Tickets from CSV: " + e.getMessage());
        }
        ticketDAO.setTickets(tickets);
        return tickets;
    }

    private static String listToString(List<Integer> list) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < list.size(); i++) {
            sb.append(list.get(i));
            if (i != list.size() - 1) {
                sb.append(";");
            }
        }
        return sb.toString();
    }

    private static List<Integer> stringToList(String str) {
        List<Integer> list = new ArrayList<>();
        String[] parts = str.split(";");
        for (String part : parts) {
            list.add(Integer.parseInt(part));
        }
        return list;
    }

    private static String seatsToString(List<Seat> seats) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < seats.size(); i++) {
            Seat seat = seats.get(i);
            sb.append(seatToString(seat));
            if (i != seats.size() - 1) {
                sb.append(";");
            }
        }
        return sb.toString();
    }

    private static String seatToString(Seat seat) {
        StringBuilder sb = new StringBuilder();
        sb.append(seat.getSeatNumber()).append(":");
        sb.append(passengerToString(seat.getPassangerName())).append(":");
        sb.append(rangesToString(seat.getOccupiedRanges()));
        return sb.toString();
    }

    private static Seat stringToSeat(String str) {
        String[] parts = str.split(":");
        int seatNumber = 0;
        if(Validation.validateNumbers(parts[0])) {

            seatNumber = Integer.parseInt(parts[0]);
        }
        else {
            seatNumber = 0;
        }
        Seat seat = new Seat(seatNumber);
        if (parts.length > 1 && !parts[1].isEmpty()) {
            Passenger passenger = new Passenger(parts[1]);
            seat.addPassanger(passenger);
        }
        if (parts.length > 2) {
            seat.getOccupiedRanges().addAll(stringToRanges(parts[2]));
        }
        return seat;
    }

    private static List<Seat> stringToSeats(String str) {
        List<Seat> seats = new ArrayList<>();
        String[] parts = str.split(";");
        for (String part : parts) {
            seats.add(stringToSeat(part));
        }
        return seats;
    }

    private static String passengerToString(String passengerName) {
        return passengerName != null ? passengerName : "";
    }


    private static String rangesToString(List<String[]> ranges) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < ranges.size(); i++) {
            sb.append(rangeToString(ranges.get(i)));
            if (i != ranges.size() - 1) {
                sb.append("|");
            }
        }
        return sb.toString();
    }

    private static String rangeToString(String[] range) {
        return range[0] + "-" + range[1];
    }

    private static List<String[]> stringToRanges(String str) {
        List<String[]> ranges = new ArrayList<>();
        String[] rangeParts = str.split("\\|");
        for (String range : rangeParts) {
            ranges.add(range.split("-"));
        }
        return ranges;
    }

    @Override
    public void updateTicket(List<Ticket> tickets) {
        fileRemover();
        for(Ticket ticket : tickets) {
            addTicket(ticket);
        }
    }

    private static void fileRemover() {
        try
        {
            FileWriter writer = new FileWriter(TICKET_CSV_FILE);
        }
        catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
