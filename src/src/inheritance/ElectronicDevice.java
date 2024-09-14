package inheritance;
// Single Level Inheritance

public class ElectronicDevice {
    private String brandName;
    private float price;
    private int warrantyInYears;
    private String color;

    ElectronicDevice(String brandName, float price, int warrantyInYears, String color) {
        this.brandName = brandName;
        this.price = price;
        this.warrantyInYears = warrantyInYears;
        this.color = color;

    }
    public String getBrandName() {
        return brandName;
    }
    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }
    public float getPrice() {
        return price;
    }
    public void setPrice(float price) {
        this.price = price;
    }
    public int getWarrantyInYears() {
        return warrantyInYears;
    }
    public String getColor() {
        return color;
    }
    public void run() {
        System.out.println("Device Started ");
    }
}

class Fan extends ElectronicDevice {
    private int totalSpeed;

    Fan(String brandName, float price, int warrantyInYears, String color, int totalSpeed) {
        super(brandName,price,warrantyInYears,color);
        this.totalSpeed = totalSpeed;
    }
    public int getTotalSpeed() {
        return totalSpeed;
    }
    public void run(){
        System.out.println("Fan started Running");
    }
    public static void main(String[] args) {
        Fan fan = new Fan("Super",8000,7,"White",5);
        fan.run();
        System.out.println("Brand : " + fan.getBrandName());
        System.out.println("Price : " + fan.getPrice());
        System.out.println("Warranty : " + fan.getWarrantyInYears());
        System.out.println("Color : " + fan.getColor());
        System.out.println("Total Speed : " + fan.getTotalSpeed());
    }
}
