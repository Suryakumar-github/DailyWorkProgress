package liskovSubstitutionPrinciple.bad;

public class Dove extends Bird{
    @Override
    public void fly() {
        System.out.println("Dove Flying");
    }

}
