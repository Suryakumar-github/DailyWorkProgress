package inheritance;
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

class Fans extends ElectronicDevices {
    int totalSpeed;

    Fans(String modelName, float price, int warrantyInYears, String color, int totalSpeed) {
        super(modelName,price,warrantyInYears,color);
        this.totalSpeed = totalSpeed;
    }
    public int getTotalSpeed() {
        return totalSpeed;
    }
    public void run(){
        System.out.println("Fans Started Running");
    }
}
class Orient extends Fans{
    boolean isHavingRemote;

    Orient(String modelName, float price, int warrantyInYears, String color, int totalSpeed, boolean isHavingRemote) {
        super(modelName,price,warrantyInYears,color,totalSpeed);
        this.isHavingRemote = isHavingRemote;
    }

    public static void main(String[] args) {
        Orient orient = new Orient("SuperFan",6000,5,"Brown",5,true);
        orient.run();
        System.out.println(orient.getTotalSpeed());
        System.out.println(orient.isHavingRemote);
        System.out.println(orient.getColor());
        System.out.println(orient.getWarrantyInYears());

    }
}