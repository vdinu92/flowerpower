package ro.pub.cs.aipi.lab03.model;

import java.util.ArrayList;
import javafx.beans.property.SimpleStringProperty;

public class Writer extends Model {

    final private SimpleStringProperty id;
    final private SimpleStringProperty first_name;
    final private SimpleStringProperty last_name;
    final private SimpleStringProperty biography;

    public Writer(String id, String first_name, String last_name, String biography) {
        this.id = new SimpleStringProperty(id);
        this.first_name = new SimpleStringProperty(first_name);
        this.last_name = new SimpleStringProperty(last_name);
        this.biography = new SimpleStringProperty(biography);
    }

    public Writer(ArrayList<String> writer) {
        this.id = new SimpleStringProperty(writer.get(0));
        this.first_name = new SimpleStringProperty(writer.get(1));
        this.last_name = new SimpleStringProperty(writer.get(2));
        this.biography = new SimpleStringProperty(writer.get(3));
    }

    public String getId() {
        return id.get();
    }

    public void setId(String id) {
        this.id.set(id);
    }

    public String getFirst_name() {
        return first_name.get();
    }

    public void setFirst_name(String first_name) {
        this.first_name.set(first_name);
    }

    public String getLast_name() {
        return last_name.get();
    }

    public void setLast_name(String last_name) {
        this.last_name.set(last_name);
    }

    public String getBiography() {
        return biography.get();
    }

    public void setBiography(String biography) {
        this.biography.set(biography);
    }

    @Override
    public ArrayList<String> getValues() {
        ArrayList<String> values = new ArrayList<>();
        values.add(id.get());
        values.add(first_name.get());
        values.add(last_name.get());
        values.add(biography.get());
        return values;
    }
}
