package looseCoupling;

class Bike {
    private Engine engine;
    public Bike(Engine engine){
        this.engine = engine;
    }
    public void start(){
        engine.start();
    }
}