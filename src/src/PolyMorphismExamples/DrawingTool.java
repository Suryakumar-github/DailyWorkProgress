package PolyMorphismExamples;

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