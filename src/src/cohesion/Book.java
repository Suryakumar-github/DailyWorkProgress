package cohesion;

// High-Cohesion
public class Book {
    String title;
    String author;
    String content;

    Book(String title, String author, String content) {
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
}
