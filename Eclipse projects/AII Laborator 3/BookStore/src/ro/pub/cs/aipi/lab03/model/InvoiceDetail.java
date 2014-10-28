package ro.pub.cs.aipi.lab03.model;

import java.util.ArrayList;
import javafx.beans.property.SimpleStringProperty;

public class InvoiceDetail extends Model {

    final private SimpleStringProperty id;
    final private SimpleStringProperty invoice_id;
    final private SimpleStringProperty book_id;
    final private SimpleStringProperty quantity;

    public InvoiceDetail(String id, String invoice_id, String book_id, String quantity) {
        this.id = new SimpleStringProperty(id);
        this.invoice_id = new SimpleStringProperty(invoice_id);
        this.book_id = new SimpleStringProperty(book_id);
        this.quantity = new SimpleStringProperty(quantity);
    }

    public InvoiceDetail(ArrayList<String> supplyorderdetail) {
        this.id = new SimpleStringProperty(supplyorderdetail.get(0));
        this.invoice_id = new SimpleStringProperty(supplyorderdetail.get(1));
        this.book_id = new SimpleStringProperty(supplyorderdetail.get(2));
        this.quantity = new SimpleStringProperty(supplyorderdetail.get(3));
    }

    public String getId() {
        return id.get();
    }

    public void setId(String id) {
        this.id.set(id);
    }

    public String getInvoice_id() {
        return invoice_id.get();
    }

    public void setInvoice_id(String invoice_id) {
        this.invoice_id.set(invoice_id);
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
        values.add(invoice_id.get());
        values.add(book_id.get());
        values.add(quantity.get());
        return values;
    }
}
