package liskovSubstitutionPrinciple.good;

public class Parrot extends Bird implements Flyable {
    public void eat() {
        System.out.println("Parrot is Eating");
    }
    public void fly() {
        System.out.println("Parrot Flying");
    }
}
