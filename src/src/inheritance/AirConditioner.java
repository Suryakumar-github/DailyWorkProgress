package inheritance;

public class AirConditioner extends ElectronicDevice{
    boolean isWorkWithoutStebeliser;

    public AirConditioner(String brandName, float price, int warrantInYears, String color, boolean isWorkWithoutStebeliser) {
        super(brandName, price, warrantInYears, color);
        this.isWorkWithoutStebeliser = false;
    }
    public void run(){
        System.out.println("Air conditioner is running");
    }
    public static void main(String[] args) {
        AirConditioner airConditioner = new AirConditioner("LG", 50000,5,"White", false);
        airConditioner.run();
        System.out.println("Is works Without Stabiliser : "+airConditioner.isWorkWithoutStebeliser);
        System.out.println("Brand : "+airConditioner.getBrandName());
        System.out.println("Price : "+airConditioner.getPrice());
        System.out.println("Color : "+airConditioner.getColor());

    }
}
