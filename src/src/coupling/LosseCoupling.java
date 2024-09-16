package coupling;

interface Engine{
    void start();
}
class EvBike implements Engine{
    public void start(){
        System.out.println("coupling.EvBike started");
    }
}
class Bike {
    private Engine engine;
    public Bike(Engine engine){
        this.engine = engine;
    }
    public void start(){
        engine.start();
    }
}
public class LosseCoupling {
    public static void main(String[] args) {
        Engine ev = new EvBike();
        Bike bike = new Bike(ev);
        bike.start();
    }
}
