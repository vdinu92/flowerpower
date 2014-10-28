package ro.pub.cs.aipi.lab03.model;

import java.util.ArrayList;
import javafx.beans.property.SimpleStringProperty;

public class SupplyOrderDetail extends Model {

    final private SimpleStringProperty id;
    final private SimpleStringProperty supply_order_id;
    final private SimpleStringProperty book_id;
    final private SimpleStringProperty quantity;

    public SupplyOrderDetail(String id, String supply_order_id, String book_id, String quantity) {
        this.id = new SimpleStringProperty(id);
        this.supply_order_id = new SimpleStringProperty(supply_order_id);
        this.book_id = new SimpleStringProperty(book_id);
        this.quantity = new SimpleStringProperty(quantity);
    }

    public SupplyOrderDetail(ArrayList<String> supplyorderdetail) {
        this.id = new SimpleStringProperty(supplyorderdetail.get(0));
        this.supply_order_id = new SimpleStringProperty(supplyorderdetail.get(1));
        this.book_id = new SimpleStringProperty(supplyorderdetail.get(2));
        this.quantity = new SimpleStringProperty(supplyorderdetail.get(3));
    }

    public String getId() {
        return id.get();
    }

    public void setId(String id) {
        this.id.set(id);
    }

    public String getSupply_order_id() {
        return supply_order_id.get();
    }

    public void setSupply_order_id(String supply_order_id) {
        this.supply_order_id.set(supply_order_id);
    }

    public String getBook_id() {
        return book_id.get();
    }

    public void setBook_id(String book_id) {
        this.book_id.set(book_id);
    }

    public String getQuantity() {
        return quantity.get();
    }

    public void setQuantity(String quantity) {
        this.quantity.set(quantity);
    }

    @Override
    public ArrayList<String> getValues() {
        ArrayList<String> values = new ArrayList<>();
        values.add(id.get());
        values.add(supply_order_id.get());
        values.add(book_id.get());
        values.add(quantity.get());
        return values;
    }
}
