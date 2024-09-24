package liskovSubstitutionPrinciple.bad;

public class AetherBike extends Bike{
    @Override
    public void startEngine() throws Exception {
        throw new Exception("I dont have Engine to Start..");
    }
}
