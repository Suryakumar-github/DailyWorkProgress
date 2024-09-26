package interfaceExample;

public class Bike extends Vehicle {
    public void move()  {
        System.out.println("Bike is moving");
    }

    public static void main(String[] args) {
        Bike bike = new Bike();
        bike.move();
    }
}
