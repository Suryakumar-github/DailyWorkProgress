package liskovSubstitutionPrinciple.good;

public class YamahaBike implements Bike {
    @Override
    public void startEngine() {
        System.out.println("Yamaha Engine Started");
    }
}
