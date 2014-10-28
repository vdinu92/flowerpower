package ro.pub.cs.aipi.lab03.model;

import java.util.ArrayList;
import javafx.beans.property.SimpleStringProperty;

public class PublishingHouse extends Model {

    final private SimpleStringProperty id;
    final private SimpleStringProperty name;
    final private SimpleStringProperty registered_number;
    final private SimpleStringProperty description;
    final private SimpleStringProperty town;
    final private SimpleStringProperty region;
    final private SimpleStringProperty country;

    public PublishingHouse(String id, String name, String registered_number, String description, String town, String region, String country) {
        this.id = new SimpleStringProperty(id);
        this.name = new SimpleStringProperty(name);
        this.registered_number = new SimpleStringProperty(registered_number);
        this.description = new SimpleStringProperty(description);
        this.town = new SimpleStringProperty(town);
        this.region = new SimpleStringProperty(region);
        this.country = new SimpleStringProperty(country);
    }

    public PublishingHouse(ArrayList<String> publishinghouse) {
        this.id = new SimpleStringProperty(publishinghouse.get(0));
        this.name = new SimpleStringProperty(publishinghouse.get(1));
        this.registered_number = new SimpleStringProperty(publishinghouse.get(2));
        this.description = new SimpleStringProperty(publishinghouse.get(3));
        this.town = new SimpleStringProperty(publishinghouse.get(4));
        this.region = new SimpleStringProperty(publishinghouse.get(5));
        this.country = new SimpleStringProperty(publishinghouse.get(6));
    }

    public String getId() {
        return id.get();
    }

    public void setId(String id) {
        this.id.set(id);
    }

    public String getName() {
        return name.get();
    }

    public void setName(String name) {
        this.name.set(name);
    }

    public String getRegistered_number() {
        return registered_number.get();
    }

    public void setRegistered_number(String registered_number) {
        this.registered_number.set(registered_number);
    }

    public String getDescription() {
        return description.get();
    }

    public void setDescription(String description) {
        this.description.set(description);
    }

    public String getTown() {
        return town.get();
    }

    public void setTown(String town) {
        this.town.set(town);
    }

    public String getRegion() {
        return region.get();
    }

    public void setRegion(String region) {
        this.region.set(region);
    }

    public String getCountry() {
        return country.get();
    }

    public void setCountry(String country) {
        this.country.set(country);
    }

    @Override
    public ArrayList<String> getValues() {
        ArrayList<String> values = new ArrayList<>();
        values.add(id.get());
        values.add(name.get());
        values.add(registered_number.get());
        values.add(description.get());
        values.add(town.get());
        values.add(region.get());
        values.add(country.get());
        return values;
    }
}
