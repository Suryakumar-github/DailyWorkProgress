// Example for Object, Class, Encapsulation

public class HeadPhone {
    private String brandName;
    private String color;
    private float price;
    private boolean isWireLess;

    HeadPhone(String brandName, String color, float price, boolean isWireLess) {
        this.brandName = brandName;
        this.color = color;
        this.price = price;
        this.isWireLess = isWireLess;
    }

    public String getName() {
        return brandName;
    }
    public String getColor() {
        return color;
    }
    public float getPrice() {
        return price;
    }
    public boolean isWireLess() {
        return isWireLess;
    }
    public void setName(String brandName) {
        this.brandName = brandName;
    }
    public void setColor(String color) {
        this.color = color;
    }
    public void setPrice(float price) {
        this.price = price;
    }

    public void play() {
        System.out.println("Play the song");
    }
    public void pause() {
        System.out.println("Pause the song");
    }
    public void increaseVolume() {
        System.out.println("Increase the volume of the song");
    }
    public void decreaseVolume() {
        System.out.println("Decrease the volume of the song");
    }


    public static void main(String[] args) {
        HeadPhone headPhone1 = new HeadPhone("Boat", "Black", 450,false);
        System.out.println("Color : "+headPhone1.getColor());
        System.out.println("Brand Name : "+headPhone1.getName());
        System.out.println("Price : "+headPhone1.getPrice());
        headPhone1.play();
        headPhone1.pause();
        headPhone1.increaseVolume();
        headPhone1.decreaseVolume();
        System.out.println(headPhone1.isWireLess);
    }
}
