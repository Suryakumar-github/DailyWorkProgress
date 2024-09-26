package dependencyInversionPrinciple.good;

public class StandardMonitor implements Monitor {
    @Override
    public void display() {
        System.out.println("Displaying the Picture using the Monitor");
    }
}
