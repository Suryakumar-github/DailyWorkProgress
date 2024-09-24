package interfaceSegregationPrinciple.good;

public class Brush implements WritingEquipments, Painting {
    public void write() {
        System.out.println("Writing using Pen");
    }

    @Override
    public int getPrice() {
        return 200;
    }
    @Override
    public void paintOnWall() {
        System.out.println("Painting on Wall Using Brush");
    }
}
