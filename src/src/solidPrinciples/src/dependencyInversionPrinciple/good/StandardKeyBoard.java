package dependencyInversionPrinciple.good;

public class StandardKeyBoard implements KeyBoard {
    @Override
    public void type() {
        System.out.println("Typing using Standard Keyboard");
    }
}
