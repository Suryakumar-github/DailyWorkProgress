package dao;

import model.Ticket;

import java.util.List;

public interface TicketDAO {
    List<Ticket> getAllTickets();
    Ticket getTicketByPNR(int pnr);
    void addTicket(Ticket ticket);
    void removeTicket(Ticket ticket);
}
