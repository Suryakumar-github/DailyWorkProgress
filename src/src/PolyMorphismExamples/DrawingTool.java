package PolyMorphismExamples;

interface Shape {
    void draw();
    int findArea(int dimension);
    double findArea(double dimension);
}

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

public class DrawingTool {
    public void drawShape(Shape shape) {
        shape.draw();
    }

    public static void main(String[] args) {
        DrawingTool tool = new DrawingTool();

        Shape circle = new Circle();
        Shape square = new Square();


        tool.drawShape(circle);
        tool.drawShape(square);
    }
}
