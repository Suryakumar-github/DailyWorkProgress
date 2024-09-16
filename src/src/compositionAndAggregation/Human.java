package compositionAndAggregation;

class Heart{
    String condition;
    public Heart(){

    }

}
public class Human {
    private Heart heart = new Heart();

    public Heart getHeart() {
        return heart;
    }

    public void setHeart(Heart heart) {
        this.heart = heart;
    }
    //CompositionAndAggregation.Heart heart1 = heart.clone();
}
