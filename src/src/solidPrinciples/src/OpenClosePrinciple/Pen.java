package OpenClosePrinciple;

public class Pen implements WritingEquipments{

    public void write() {
        System.out.println("Writing using Pen");
    }

    @Override
    public int getPrice() {
        return 50;
    }
}
