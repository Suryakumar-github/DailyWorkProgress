package inheritance.multiLevelInheritance;
// Multi Level Inheritance

public class ElectronicDevices {
    String modelName;
    float price;
    int warrantyInYears;
    String color;

    ElectronicDevices(String modelName, float price, int warrantyInYears, String color) {
        this.modelName = modelName;
        this.price = price;
        this.warrantyInYears = warrantyInYears;
        this.color = color;

    }
    public String getModelName() {
        return modelName;
    }
    public void setModelName(String modelName) {
        this.modelName = modelName;
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

