package inheritance;

// Single Inheritance
public class Mobile {
     String modelName;
     float price;
     String color;
     int batteryCapacity;

     Mobile(String modelName, float price, String color, int batteryCapacity) {
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

class Oppo extends Mobile {

    Oppo(String modelName, float price, String color, int batteryCapacity) {
        super(modelName, price, color, batteryCapacity);
    }

    public static void main(String[] args) {
        Oppo oppo = new Oppo("F20",40000f,"Black",5000);
        oppo.powerOn();
        oppo.powerOff();
        System.out.println("Model Name : "+oppo.getModelName());
        System.out.println("Price : "+oppo.getPrice());
        System.out.println("Color : "+oppo.getColor());
        System.out.println("Battery Capacity : "+oppo.getBatteryCapacity());
        oppo.setPrice(37500f);
        System.out.println("Price : "+oppo.getPrice());
    }
}