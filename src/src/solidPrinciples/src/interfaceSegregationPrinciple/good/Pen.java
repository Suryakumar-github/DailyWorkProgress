package interfaceSegregationPrinciple.good;

public class Pen implements WritingEquipments,InkFiller {

    public void write() {
        System.out.println("Writing using Pen");
    }

    @Override
    public int getPrice() {
        return 50;
    }

    @Override
    public void reFillInk() {
        System.out.println("Refill pen with Ink");
    }
}
