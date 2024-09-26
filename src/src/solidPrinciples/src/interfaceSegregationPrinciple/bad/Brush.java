package interfaceSegregationPrinciple.bad;


public class Brush implements WritingEquipments {
    public void write() {
        System.out.println("Writing using Brush");
    }
    public String toString() {
        return "Product : Brush ";
    }

    @Override
    public int getPrice() {
        return 200;
    }

    @Override
    public void paintOnWall() {
        System.out.println("Painting on Wall using Brush");
    }

    @Override
    public void sharPenning() {

    }

    @Override
    public void refillInk() {

    }
}
