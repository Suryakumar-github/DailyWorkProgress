package dataLayer;

import model.ChairCarTrain;
import model.Ticket;

import java.util.ArrayList;
import java.util.List;

public class DataLayer {
    public static DataLayer instance;
    private List<ChairCarTrain> trains = new ArrayList<>();
    private List<Ticket> tickets = new ArrayList<>();
    private DataLayer() {

    }
    public static DataLayer getInstance() {
        if(instance == null) {
             instance = new DataLayer();
        }
        return instance;
    }

    public List<ChairCarTrain> getAllTrains()
    {
        return trains;
    }
    public void setAllTrains(List<ChairCarTrain> trains)
    {
        this.trains = trains;
    }
    public List<Ticket> getTickets()
    {
        return tickets;
    }
    public void setTickets(List<Ticket> tickets)
    {
        this.tickets = tickets;
    }

}
