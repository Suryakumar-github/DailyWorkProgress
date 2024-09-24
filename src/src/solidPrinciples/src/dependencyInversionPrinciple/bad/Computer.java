package dependencyInversionPrinciple.bad;

public class Computer {
    private KeyBoard keyBoard ;
    private Monitor monitor ;

    Computer() {
        keyBoard = new KeyBoard();
        monitor = new Monitor();
    }
}
