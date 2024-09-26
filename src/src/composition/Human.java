package composition;


public class Human {
    private Heart heart = new Heart();

    public Heart getHeart() {
        return heart;
    }

    public void setHeart(Heart heart) {
        this.heart = heart;
    }
    //Heart heart1 = heart.clone();
}
