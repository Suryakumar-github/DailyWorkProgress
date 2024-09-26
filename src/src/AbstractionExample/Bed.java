package AbstractionExample;

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