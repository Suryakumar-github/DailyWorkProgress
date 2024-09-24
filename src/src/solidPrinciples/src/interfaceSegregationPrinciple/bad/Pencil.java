package interfaceSegregationPrinciple.bad;

public class Pencil implements WritingEquipments {
    public void write() {
        System.out.println("Writing using pencil");
    }

    @Override
    public int getPrice() {
        return 0;
    }

    @Override
    public void paintOnWall() {

    }

    @Override
    public void sharPenning() {
        System.out.println("Sharpening the Pencil");
    }

    @Override
    public void refillInk() {

    }
}
