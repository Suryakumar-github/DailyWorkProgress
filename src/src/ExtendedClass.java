public class ExtendedClass {
    Excercise exercise;
    int id;
    static int num = 10;
    static {
        num = 100;
    }

    ExtendedClass(Excercise exercise, int id) {
        this.exercise = exercise;
        this.id = id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public static void main(String[] args) {
        Excercise excercise = new Excercise(01,23);
        ExtendedClass e = new ExtendedClass(excercise,1);
        /*ExtendedClass e2 = new ExtendedClass(e.exercise, e.id);
        System.out.println(e2.id);
        System.out.println(e.id);
        e.setId(100);
        System.out.println(e2.id);
        System.out.println(e.id);*/
        ExtendedClass e3 = e;
        System.out.println(e3.id);
        System.out.println(e.id);
        e.setId(111);
        System.out.println(e3.id);
        System.out.println(e.id);

        System.out.println(num);
    }
}
