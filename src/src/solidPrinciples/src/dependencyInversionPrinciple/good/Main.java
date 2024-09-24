package dependencyInversionPrinciple.good;

public class Main {
    public static void main(String[] args) {
        KeyBoard keyBoard = new StandardKeyBoard();
        Monitor monitor = new StandardMonitor();
        Computer computer = new Computer(keyBoard, monitor);
        computer.display();;
        computer.typing();
    }
}
