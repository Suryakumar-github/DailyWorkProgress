package PolyMorphismExamples;

class Square implements Shape {
    public void draw() {
        System.out.println("Drawing a square");
    }

    public int findArea(int length) {
        return length * length;
    }

    public double findArea(double length) {
        return length * length;
    }

}
