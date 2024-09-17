package PolyMorphismExamples;

class Circle implements Shape {
    public void draw() {
        System.out.println("Drawing a circle");
    }

    public int findArea(int radius) {
        return (int)(Math.PI * radius * radius);
    }

    public double findArea(double radius) {
        return Math.PI * radius * radius;
    }
}
