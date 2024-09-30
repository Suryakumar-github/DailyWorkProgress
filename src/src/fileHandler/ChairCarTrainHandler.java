package fileHandler;

import dataLayer.DataLayer;
import model.ChairCarTrain;
import model.Passenger;
import model.Seat;

import java.io.*;
import java.util.*;

public class ChairCarTrainHandler {

    private static final String CHAIR_CAR_TRAIN_CSV_FILE = "src/files/chair_car_trains.csv";
    private static final String HEADER = "TrainNumber,TrainName,Routes,Seats,WaitingListPassengers,TotalEarning";
    private static DataLayer dataLayer = DataLayer.getInstance();
    public static void writeChairCarTrainToCSV(ChairCarTrain train) {
        try (FileWriter fileWriter = new FileWriter(CHAIR_CAR_TRAIN_CSV_FILE,true))
        {
            fileWriter.append(String.valueOf(train.getTrainNumber())).append(",");
            fileWriter.append(train.getTrainName()).append(",");
            fileWriter.append(listToString(train.getRoutes())).append(",");
            fileWriter.append(seatsToString(train.getSeats())).append(",");
            if(train.getWaitingListPassengers() != null)
            {
                fileWriter.append(waitingListToString(train.getWaitingListPassengers())).append(",");
            }
            else
            {
                fileWriter.append(",");
            }
            fileWriter.append(String.valueOf(train.getTotalEarning())).append("\n");
        }
        catch (IOException e)
        {
            System.out.println("Error while writing ChairCarTrain to CSV: " );
        }
    }

    public static void readChairCarTrainsFromCSV()
    {
        List<ChairCarTrain> chairCarTrains = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(CHAIR_CAR_TRAIN_CSV_FILE))) {
            String line;
            while ((line = br.readLine()) != null && !line.isEmpty() && !line.equals("\\s")) {
                String[] trainData = line.split(",");
                    int trainNumber = Integer.parseInt(trainData[0]);
                    String trainName = trainData[1];
                    List<String> routes = stringToList(trainData[2]);
                    List<Seat> seats = stringToSeats(trainData[3]);
                    Map<Passenger, String[]> passengerMap = stringToWaitingList(trainData[4]);
                    double totalEarning = Double.parseDouble(trainData[5]);
                    ChairCarTrain chairCarTrain = new ChairCarTrain(trainName, trainNumber, routes.toArray(new String[0]), seats,passengerMap, totalEarning);
                    chairCarTrains.add(chairCarTrain);

            }
        } catch (IOException e) {
            System.out.println("Error while reading ChairCarTrains from CSV: " + e.getMessage());
        }
        dataLayer.setAllTrains(chairCarTrains);
    }

    public static String seatsToString(List<Seat> seats) {
        StringBuilder seatString = new StringBuilder();
        for (Seat seat : seats) {
            if (seat != null) {
                seatString.append(seat.getSeatNumber()).append(";");
                seatString.append(seat.getPassangerName() != null ? seat.getPassangerName() : "EMPTY");

                if (!seat.getOccupiedRanges().isEmpty()) {
                    seatString.append(":");
                    List<String> ranges = new ArrayList<>();
                    for (String[] range : seat.getOccupiedRanges()) {
                        ranges.add(String.join("-", range));
                    }
                    seatString.append(String.join(",", ranges));
                }
                seatString.append("|");
            }
        }
        return seatString.toString();
    }

    private static List<Seat> stringToSeats(String seatsStr) {
        List<Seat> seats = new ArrayList<>();
        String[] seatDataArray = seatsStr.split("\\|");
        for (String seatData : seatDataArray) {
            if (seatData.isEmpty()) continue;

            String[] parts = seatData.split(";");
            int seatNumber = Integer.parseInt(parts[0]);
            Seat seat = new Seat(seatNumber);

            String[] nameRanges = parts[1].split(":");
            String passengerName = nameRanges[0];
            if (!"EMPTY".equals(passengerName)) {
                seat.addPassanger(new Passenger(passengerName));
            }

            if (nameRanges.length > 1) {
                String[] ranges = nameRanges[1].split(",");
                for (String range : ranges) {
                    seat.getOccupiedRanges().add(range.split("-"));
                }
            }

            seats.add(seat);
        }
        return seats;
    }

    private static String waitingListToString(Map<Passenger, String[]> waitingList) {
        StringBuilder sb = new StringBuilder();
        if(waitingList.size()>0)
        {
            for (Map.Entry<Passenger, String[]> entry : waitingList.entrySet()) {
                sb.append(entry.getKey().getName()).append(":");
                sb.append(entry.getValue()[0]).append("-").append(entry.getValue()[1]).append("|");
            }
        }
        return sb.toString();
    }

    private static Map<Passenger, String[]> stringToWaitingList(String waitingListStr) {
        Map<Passenger, String[]> waitingList = new HashMap<>();

        String[] passengerDataArray = waitingListStr.split("\\|");
            for (String passengerData : passengerDataArray) {
                if (passengerData.isEmpty()) continue;
                String[] parts = passengerData.split(":");
                if(parts.length > 1) {
                    String name = parts[0];
                    String[] range = parts[1].split("-");
                    waitingList.put(new Passenger(name), range);
                }
            }
        return waitingList;
    }

    private static List<String> stringToList(String str) {
        return str.isEmpty() ? Collections.emptyList() : Arrays.asList(str.split(";"));
    }

    private static String listToString(List<String> list) {
        return String.join(";", list);
    }

    public static void updateChairCarTrain() {
        removeFile();
        List<ChairCarTrain> trains = dataLayer.getAllTrains();
        for(ChairCarTrain cTrain : trains)
        {
            System.out.println(cTrain.getTrainName());
            writeChairCarTrainToCSV(cTrain);
        }
    }

    private static void removeFile() {
        try
        {
            FileWriter writer = new FileWriter(CHAIR_CAR_TRAIN_CSV_FILE);
        }
        catch (IOException e) {
            System.out.println(e.getMessage());
        }
    }
}
