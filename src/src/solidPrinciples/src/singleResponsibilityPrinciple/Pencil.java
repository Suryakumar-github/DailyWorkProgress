package singleResponsibilityPrinciple;

public class Pencil {
    public void write() {
        System.out.println("Writing using pencil");
    }
    public void sharpening() {
        System.out.println("Sharpening the pencil");
    }
    public void coloring() {
        System.out.println("Coloring using the pencil");
    }
    public int getPrice() {
        return 10;
    }
    public String toString() {
        return "Product : Pencil ";
    }
}
