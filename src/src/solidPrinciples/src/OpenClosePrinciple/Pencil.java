package OpenClosePrinciple;

public class Pencil implements WritingEquipments{
    public void write() {
        System.out.println("Writing using pencil");
    }

    @Override
    public int getPrice() {
        return 0;
    }
}
