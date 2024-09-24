package dependencyInversionPrinciple.good;

import dependencyInversionPrinciple.bad.KeyBoard;
import dependencyInversionPrinciple.bad.Monitor;

public class Computer {
    private KeyBoard keyBoard ;
    private Monitor monitor ;

    Computer(KeyBoard keyBoard, Monitor monitor) {
        this.keyBoard = keyBoard;
        this.monitor = monitor;
    }
}
