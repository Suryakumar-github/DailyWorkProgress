package cohesion;// Low-Cohesion

public class Books {
    String title;
    String author;
    String content;

    Books(String title, String author, String content) {
        this.title = title;
        this.author = author;
        this.content = content;
    }

    public String getTitle() {
        return title;
    }
    public void setTitle(String title) {
        this.title = title;
    }
    public String getAuthor() {
        return author;
    }
    public String getContent() {
        return content;
    }
    public void getDetails() {
        System.out.println("Title: " + title + "\nAuthor: " + author );
    }
    public void read() {
        System.out.println("Reading the content : "+ content);
    }
    public void getMembersDetails() {
        System.out.println("Members in a Library : ");
    }
    public void calculateFineAmount() {
        System.out.println("The Fine Amount is : ");
    }
}
