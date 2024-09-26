package inheritance.multiLevelInheritance;

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