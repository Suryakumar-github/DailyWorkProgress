package service;

public interface ReservationSystem {
    void bookTicket() throws Exception;
    void cancelTicket();
    void prepareOccupancyChart();
}

