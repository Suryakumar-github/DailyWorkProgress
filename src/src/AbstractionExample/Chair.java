package AbstractionExample;


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
