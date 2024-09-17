package inheritance.hirearchicalInheritance;


public class ElectronicDevice {
    String brandName;
    float price;
    int warrantyInYears;
    String color;

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
