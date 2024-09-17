package looseCoupling;

public class LosseCoupling {
    public static void main(String[] args) {
        Engine ev = new EvBike();
        Bike bike = new Bike(ev);
        bike.start();
    }
}
