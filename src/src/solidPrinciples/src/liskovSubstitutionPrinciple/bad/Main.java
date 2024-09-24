package liskovSubstitutionPrinciple.bad;

public class Main {
    public static void main(String[] args) throws Exception {
        Bird bird = new Bird();
        Dove dove = new Dove();
        Penguin penguin = new Penguin();
        fly(penguin);
    }
    public static void fly(Bird bird) throws Exception {
        bird.fly();
    }
}
