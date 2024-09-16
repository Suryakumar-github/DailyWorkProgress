package coupling;

class Engines {
    public void start(){
        System.out.println("coupling.EvBike started");
    }
}
class Bikes {
    Engines engine = new Engines();

    Bikes() {
    }
    public void start(){
        engine.start();
    }
}


public class TightCoupling {
    public static void main(String[] args) {
        Bikes bike = new Bikes();
        bike.start();
    }
}
