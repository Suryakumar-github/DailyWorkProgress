package liskovSubstitutionPrinciple.good;

public class Main {
    public static void main(String[] args) {
        Parrot parrot = new Parrot();
        Penguin penguin = new Penguin();
        fly(parrot);
        eat(parrot);
        eat(penguin);
    }
    public static void fly(Flyable flyable) {
        flyable.fly();
    }
    public static void eat(Bird bird) {
        bird.eat();
    }
}
