package ro.pub.cs.aipi.lab03.model;

import java.util.ArrayList;
import javafx.beans.property.SimpleStringProperty;

public class SupplyOrder extends Model {

    final private SimpleStringProperty id;
    final private SimpleStringProperty identification_number;
    final private SimpleStringProperty issue_date;
    final private SimpleStringProperty state;
    final private SimpleStringProperty publishing_house_id;

    public SupplyOrder(String id, String identification_number, String issue_date, String state, String publishing_house_id) {
        this.id = new SimpleStringProperty(id);
        this.identification_number = new SimpleStringProperty(identification_number);
        this.issue_date = new SimpleStringProperty(issue_date);
        this.state = new SimpleStringProperty(state);
        this.publishing_house_id = new SimpleStringProperty(publishing_house_id);
    }

    public SupplyOrder(ArrayList<String> supplyorder) {
        this.id = new SimpleStringProperty(supplyorder.get(0));
        this.identification_number = new SimpleStringProperty(supplyorder.get(1));
        this.issue_date = new SimpleStringProperty(supplyorder.get(2));
        this.state = new SimpleStringProperty(supplyorder.get(3));
        this.publishing_house_id = new SimpleStringProperty(supplyorder.get(4));
    }

    public String getId() {
        return id.get();
    }

    public void setId(String id) {
        this.id.set(id);
    }

    public String getIdentification_number() {
        return identification_number.get();
    }

    public void setIdentification_number(String identification_number) {
        this.identification_number.set(identification_number);
    }

    public String getIssue_date() {
        return issue_date.get();
    }

    public void setIssue_date(String issue_date) {
        this.issue_date.set(issue_date);
    }

    public String getState() {
        return state.get();
    }

    public void setState(String state) {
        this.state.set(state);
    }

    public String getPublishing_house_id() {
        return publishing_house_id.get();
    }

    public void setPublishing_house_id(String publishing_house_id) {
        this.publishing_house_id.set(publishing_house_id);
    }

    @Override
    public ArrayList<String> getValues() {
        ArrayList<String> values = new ArrayList<>();
        values.add(id.get());
        values.add(identification_number.get());
        values.add(issue_date.get());
        values.add(state.get());
        values.add(publishing_house_id.get());
        return values;
    }
}
