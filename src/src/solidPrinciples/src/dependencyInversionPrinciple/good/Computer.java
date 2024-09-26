package dependencyInversionPrinciple.good;

public class Computer {
    private KeyBoard keyBoard ;
    private Monitor monitor ;

    Computer(KeyBoard keyBoard, Monitor monitor) {
        this.keyBoard = keyBoard;
        this.monitor = monitor;
    }
    public void typing() {
        keyBoard.type();
    }
    public void display() {
        monitor.display();
    }
}
