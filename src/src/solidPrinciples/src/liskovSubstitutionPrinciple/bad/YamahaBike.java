package liskovSubstitutionPrinciple.bad;

public class YamahaBike extends Bike{
    @Override
    public void startEngine() {
        System.out.println("Yamaha Engine Started...");
    }
}
