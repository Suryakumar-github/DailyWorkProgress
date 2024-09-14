public class Excercise {
    int id;
    int age;
    static {
        Excercise ex = new Excercise();
        System.out.println(ex.id);
       // static int age = 23;
       // System.out.println(age);
    }
    Excercise(int id, int age) {
        this.id = id;
        this.age = age;
    }
    Excercise() {}

}
class Child extends Excercise {
    public static void main(String[] args) {
       // Child child = new Child(12,37);

    }
}