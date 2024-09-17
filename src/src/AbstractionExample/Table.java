package AbstractionExample;

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
