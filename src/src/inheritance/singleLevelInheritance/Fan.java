package inheritance.singleLevelInheritance;

class Fan extends ElectronicDevice {
    int totalSpeed;

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