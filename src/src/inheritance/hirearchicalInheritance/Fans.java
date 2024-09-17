package inheritance.hirearchicalInheritance;

class Fans extends ElectronicDevice {
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