package interfaceSegregationPrinciple.good;

public class Pencil implements WritingEquipments,Sharer {
    public void write() {
        System.out.println("Started Writing using Pencil");
    }

    @Override
    public int getPrice() {
        return 0;
    }

    @Override
    public void sharpening() {
        System.out.println("Sharpening the Pencil Using Sharper");
    }
}
