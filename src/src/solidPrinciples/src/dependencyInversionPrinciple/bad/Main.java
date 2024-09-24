package dependencyInversionPrinciple.bad;

public class Main {
    public static void main(String[] args) {
        KeyBoard keyBoard = new KeyBoard();
        Monitor monitor = new Monitor();
        Computer computer = new Computer();
        computer.typing();;
        computer.powerOn();
    }
}
