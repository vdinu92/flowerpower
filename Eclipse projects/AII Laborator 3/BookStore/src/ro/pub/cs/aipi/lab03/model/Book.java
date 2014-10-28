package ro.pub.cs.aipi.lab03.model;

import java.util.ArrayList;
import javafx.beans.property.SimpleStringProperty;

public class Book extends Model {

    final private SimpleStringProperty id;
    final private SimpleStringProperty title;
    final private SimpleStringProperty description;
    final private SimpleStringProperty publishing_house_id;
    final private SimpleStringProperty printing_year;
    final private SimpleStringProperty edition;
    final private SimpleStringProperty series_id;
    final private SimpleStringProperty genre_id;
    final private SimpleStringProperty stockpile;
    final private SimpleStringProperty price;

    public Book(String id, String title, String description, String publishing_house_id, String printing_year, String edition, String series_id, String genre_id, String stockpile, String price) {
        this.id = new SimpleStringProperty(id);
        this.title = new SimpleStringProperty(title);
        this.description = new SimpleStringProperty(description);
        this.publishing_house_id = new SimpleStringProperty(publishing_house_id);
        this.printing_year = new SimpleStringProperty(printing_year);
        this.edition = new SimpleStringProperty(edition);
        this.series_id = new SimpleStringProperty(series_id);
        this.genre_id = new SimpleStringProperty(genre_id);
        this.stockpile = new SimpleStringProperty(stockpile);
        this.price = new SimpleStringProperty(price);
    }

    public Book(ArrayList<String> book) {
        this.id = new SimpleStringProperty(book.get(0));
        this.title = new SimpleStringProperty(book.get(1));
        this.description = new SimpleStringProperty(book.get(2));
        this.publishing_house_id = new SimpleStringProperty(book.get(3));
        this.printing_year = new SimpleStringProperty(book.get(4));
        this.edition = new SimpleStringProperty(book.get(5));
        this.series_id = new SimpleStringProperty(book.get(6));
        this.genre_id = new SimpleStringProperty(book.get(7));
        this.stockpile = new SimpleStringProperty(book.get(8));
        this.price = new SimpleStringProperty(book.get(9));
    }

    public String getId() {
        return id.get();
    }

    public void setId(String id) {
        this.id.set(id);
    }

    public String getTitle() {
        return title.get();
    }

    public void setTitle(String title) {
        this.title.set(title);
    }

    public String getDescription() {
        return description.get();
    }

    public void setDescription(String description) {
        this.description.set(description);
    }

    public String getPublishing_house_id() {
        return publishing_house_id.get();
    }

    public void setPublishing_house_id(String publishing_house_id) {
        this.publishing_house_id.set(publishing_house_id);
    }

    public String getPrinting_year() {
        return printing_year.get();
    }

    public void setPrinting_year(String printing_year) {
        this.printing_year.set(printing_year);
    }

    public String getEdition() {
        return edition.get();
    }

    public void setEdition(String edition) {
        this.edition.set(edition);
    }

    public String getSeries_id() {
        return series_id.get();
    }

    public void setSeries_id(String series_id) {
        this.series_id.set(series_id);
    }

    public String getGenre_id() {
        return genre_id.get();
    }

    public void setGenre_id(String genre_id) {
        this.genre_id.set(genre_id);
    }

    public String getStockpile() {
        return stockpile.get();
    }

    public void setStockpile(String stockpile) {
        this.stockpile.set(stockpile);
    }

    public String getPrice() {
        return price.get();
    }

    public void setPrice(String price) {
        this.price.set(price);
    }

    @Override
    public ArrayList<String> getValues() {
        ArrayList<String> values = new ArrayList<>();
        values.add(id.get());
        values.add(title.get());
        values.add(description.get());
        values.add(publishing_house_id.get());
        values.add(printing_year.get());
        values.add(edition.get());
        values.add(series_id.get());
        values.add(genre_id.get());
        values.add(stockpile.get());
        values.add(price.get());
        return values;
    }
}
