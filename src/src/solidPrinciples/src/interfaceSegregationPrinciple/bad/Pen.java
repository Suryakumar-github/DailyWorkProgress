package interfaceSegregationPrinciple.bad;


public class Pen implements WritingEquipments {

    public void write() {
        System.out.println("Writing using Pen");
    }

    @Override
    public int getPrice() {
        return 50;
    }

    @Override
    public void paintOnWall() {

    }

    @Override
    public void sharPenning() {

    }

    @Override
    public void refillInk() {
        System.out.println("Refill the Pen's Ink");
    }
}
