package dao;

import dataLayer.DataLayer;
import fileHandler.TicketHandler;
import model.Ticket;

import java.util.ArrayList;
import java.util.List;

public class TicketDAOImpl implements TicketDAO {
    private List<Ticket> tickets = new ArrayList<>();
    private DataLayer dataLayer = DataLayer.getInstance();
    public TicketDAOImpl() {

    }

    @Override
    public List<Ticket> getAllTickets() {
        return dataLayer.getTickets();
    }

    @Override
    public Ticket getTicketByPNR(int pnr) {
        for(Ticket ticket : dataLayer.getTickets()) {
            System.out.println(pnr + " " + ticket.getPnr());
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
