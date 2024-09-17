package tightCoupling;

class Bikes {
    Engines engine = new Engines();

    Bikes() {
    }
    public void start(){
        engine.start();
    }
}
