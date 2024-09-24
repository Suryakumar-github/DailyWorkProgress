package liskovSubstitutionPrinciple.bad;

public class Penguin extends Bird{
    @Override
    public void fly() throws Exception {
        throw new Exception("Penguins can't Fly");
    }
}
