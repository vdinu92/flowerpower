package ro.pub.cs.aipi.lab03.model;

import java.util.ArrayList;
import javafx.beans.property.SimpleStringProperty;

public class Author extends Model {

    final private SimpleStringProperty id;
    final private SimpleStringProperty book_id;
    final private SimpleStringProperty writer_id;

    public Author(String id, String book_id, String writer_id) {
        this.id = new SimpleStringProperty(id);
        this.book_id = new SimpleStringProperty(book_id);
        this.writer_id = new SimpleStringProperty(writer_id);
    }

    public Author(ArrayList<String> author) {
        this.id = new SimpleStringProperty(author.get(0));
        this.book_id = new SimpleStringProperty(author.get(1));
        this.writer_id = new SimpleStringProperty(author.get(2));
    }

    public String getId() {
        return id.get();
    }

    public void setId(String id) {
        this.id.set(id);
    }

    public String getBook_id() {
        return book_id.get();
    }

    public void setBook_id(String book_id) {
        this.book_id.set(book_id);
    }

    public String getWriter_id() {
        return writer_id.get();
    }

    public void setWriter_id(String writer_id) {
        this.writer_id.set(writer_id);
    }

    @Override
    public ArrayList<String> getValues() {
        ArrayList<String> values = new ArrayList<>();
        values.add(id.get());
        values.add(book_id.get());
        values.add(writer_id.get());
        return values;
    }
}
