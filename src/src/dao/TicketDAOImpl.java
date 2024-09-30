package dao;

import fileHandler.TicketHandler;
import model.Ticket;

import java.util.ArrayList;
import java.util.List;

public class TicketDAOImpl implements TicketDAO {
    private List<Ticket> tickets = new ArrayList<>();
    public TicketDAOImpl() {

    }

    @Override
    public List<Ticket> getAllTickets() {
        return tickets;
    }

    @Override
    public Ticket getTicketByPNR(int pnr) {
        for(Ticket ticket : tickets) {
            if(ticket.getPnr() == pnr) {
                return ticket;
            }
        }
        return null;
    }

    @Override
    public void addTicket(Ticket ticket) {
        TicketHandler.writeTicketToCSV(ticket);
    }

    @Override
    public void removeTicket(Ticket ticket) {
        tickets.remove(ticket);
    }

}
