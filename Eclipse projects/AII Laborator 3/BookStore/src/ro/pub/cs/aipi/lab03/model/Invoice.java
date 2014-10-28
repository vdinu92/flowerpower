package ro.pub.cs.aipi.lab03.model;

import java.util.ArrayList;
import javafx.beans.property.SimpleStringProperty;

public class Invoice extends Model {

    final private SimpleStringProperty id;
    final private SimpleStringProperty identification_number;
    final private SimpleStringProperty issue_date;
    final private SimpleStringProperty state;
    final private SimpleStringProperty user_personal_identifier;

    public Invoice(String id, String identification_number, String issue_date, String state, String user_personal_identifier) {
        this.id = new SimpleStringProperty(id);
        this.identification_number = new SimpleStringProperty(identification_number);
        this.issue_date = new SimpleStringProperty(issue_date);
        this.state = new SimpleStringProperty(state);
        this.user_personal_identifier = new SimpleStringProperty(user_personal_identifier);
    }

    public Invoice(ArrayList<String> invoice) {
        this.id = new SimpleStringProperty(invoice.get(0));
        this.identification_number = new SimpleStringProperty(invoice.get(1));
        this.issue_date = new SimpleStringProperty(invoice.get(2));
        this.state = new SimpleStringProperty(invoice.get(3));
        this.user_personal_identifier = new SimpleStringProperty(invoice.get(4));
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

    public String getUser_personal_identifier() {
        return user_personal_identifier.get();
    }

    public void setUser_personal_identifier(String user_personal_identifier) {
        this.user_personal_identifier.set(user_personal_identifier);
    }

    @Override
    public ArrayList<String> getValues() {
        ArrayList<String> values = new ArrayList<>();
        values.add(id.get());
        values.add(identification_number.get());
        values.add(issue_date.get());
        values.add(state.get());
        values.add(user_personal_identifier.get());
        return values;
    }
}
