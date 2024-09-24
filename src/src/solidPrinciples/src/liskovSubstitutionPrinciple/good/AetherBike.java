package liskovSubstitutionPrinciple.good;

public class AetherBike implements EvBike {

    @Override
    public void start() {
        System.out.println("EvBike started");
    }
}
