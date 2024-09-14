package AbstractionExample;

abstract class  Furniture {
    abstract void assemble();
    abstract void move();
}

class Chair extends Furniture {
    public void assemble() {
        System.out.println("Assembling a chair with four legs and a seat.");
    }

    public void move() {
        System.out.println("Moving the chair by lifting it.");
    }

    public void adjustHeight() {
        System.out.println("Adjusting the height of the chair.");
    }
}

class Table extends Furniture {
    public void assemble() {
        System.out.println("Assembling a table with a flat surface and four legs.");
    }

    public void move() {
        System.out.println("Moving the table by dragging it.");
    }

    public void extendTable() {
        System.out.println("Extending the table for more space.");
    }
}

class Bed extends Furniture {
    public void assemble() {
        System.out.println("Assembling a bed frame and mattress.");
    }

    public void move() {
        System.out.println("Moving the bed by disassembling the parts.");
    }

    public void adjustRecline() {
        System.out.println("Adjusting the bed's recline angle.");
    }
}

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

