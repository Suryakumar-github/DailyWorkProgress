package OpenClosePrinciple;

public class Brush implements WritingEquipments{
    public void write() {
        System.out.println("Writing using Pen");
    }

    @Override
    public int getPrice() {
        return 200;
    }
}
