package interfaceExample;

public interface Movable {
    public void move();
}
class Vehicle implements Movable {
    public void move() {
        System.out.println("Moving a vehicle");
    }
}
class Car extends Vehicle {
    public void move() {
        System.out.println("Car Started Moving");
    }
    public static void main(String[] args) {
        Movable movable = new Car();
        movable.move();
    }
}