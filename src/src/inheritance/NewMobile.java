package inheritance;

// Inheritance
public class NewMobile {
    String modelName;
    float price;
    String color;
    int batteryCapacity;

    NewMobile(String modelName, float price, String color, int batteryCapacity) {
        this.modelName = modelName;
        this.price = price;
        this.color = color;
        this.batteryCapacity = batteryCapacity;

    }
    public String getModelName() {
        return modelName;
    }
    public float getPrice() {
        return price;
    }
    public String getColor() {
        return color;
    }
    public int getBatteryCapacity() {
        return batteryCapacity;
    }
    public void setPrice(float price) {
        this.price = price;
    }
    public String toString() {
        return  modelName + "," + price + "," + color + "," + batteryCapacity;
    }
    public  void powerOn(){
        System.out.println("Power on");
    }
    public  void powerOff(){
        System.out.println("Power off");
    }
}
//Single Inheritance
class Xiomi extends NewMobile {

    Xiomi(String modelName, float price, String color, int batteryCapacity) {
        super(modelName, price, color, batteryCapacity);
    }

}

// Multi-level Inheritance
class Redmi extends Xiomi{
    Redmi (String modelName, float price, String color, int batteryCapacity) {
        super(modelName, price, color, batteryCapacity);
    }

    public static void main(String[] args) {
        Redmi redmi = new Redmi("Nazro",20000f,"White",5000);
        redmi.powerOn();
        redmi.powerOff();
        System.out.println("Model Name : "+redmi.getModelName());
        System.out.println("Price : "+redmi.getPrice());
        System.out.println("Color : "+redmi.getColor());
        System.out.println("Battery Capacity : "+redmi.getBatteryCapacity());
        redmi.setPrice(18000f);
        System.out.println("Price : "+redmi.getPrice());
    }
}