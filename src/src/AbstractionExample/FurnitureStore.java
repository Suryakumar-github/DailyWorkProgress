package AbstractionExample;

public class FurnitureStore {
    public static void main(String[] args) {
        Furniture chair = new Chair();
        Furniture table = new Table();
        Furniture bed = new Bed();

        chair.assemble();
        chair.move();
        ((Chair) chair).adjustHeight();

        System.out.println();

        table.assemble();
        table.move();
        ((Table) table).extendTable();

        System.out.println();

        bed.assemble();
        bed.move();
        ((Bed) bed).adjustRecline();
    }
}
