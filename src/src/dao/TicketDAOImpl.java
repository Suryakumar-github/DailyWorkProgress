package dao;

import fileHandler.TicketFileHandler;
import fileHandler.TicketHandler;
import model.Ticket;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class TicketDAOImpl implements TicketDAO {

    private List<Ticket> tickets = new ArrayList<>();
    public static TicketDAOImpl instance;
    TicketHandler ticketHandler  = new TicketFileHandler();

    private TicketDAOImpl() {
    }

    public static TicketDAOImpl getInstance() {
        if(instance == null)
        {
            instance = new TicketDAOImpl();
        }
        return instance;
    }

    @Override
    public List<Ticket> getAllTickets()
    {
        return tickets;
    }

    @Override
    public Ticket getTicketByPNR(int pnr)
    {
        for(Ticket ticket : tickets) {
            System.out.println(pnr + " " + ticket.getPnr());
            if(ticket.getPnr() == pnr)
            {
                return ticket;
            }
        }
        return null;
    }

    @Override
    public void addTicket(Ticket ticket)
    {
        tickets.add(ticket);
        ticketHandler.addTicket(ticket);
    }

    @Override
    public void removeTicket(Ticket ticket)
    {
        Iterator<Ticket> iterator = tickets.iterator();

        while (iterator.hasNext()) {
            Ticket ticket1 = iterator.next();
            if (ticket1.equals(ticket)) {
                iterator.remove();
                break;
            }
        }
        ticketHandler.updateTicket(tickets);
    }

    @Override
    public void setTickets(List<Ticket> tickets) {
        this.tickets = tickets;
        System.out.println(tickets);
    }

}
