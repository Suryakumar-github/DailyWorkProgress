package fileHandler;

import model.Ticket;

import java.util.List;

public interface TicketHandler {

    void addTicket (Ticket ticket);
    List<Ticket> getTickets();
    void updateTicket(List<Ticket> tickets);

}
