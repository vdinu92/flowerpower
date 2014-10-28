package ro.pub.cs.aipi.lab03.controller;

import java.sql.SQLException;
import java.util.ArrayList;

import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Control;
import javafx.scene.control.Label;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.input.MouseEvent;
import javafx.scene.layout.GridPane;
import ro.pub.cs.aipi.lab03.dataaccess.DataBaseWrapper;
import ro.pub.cs.aipi.lab03.dataaccess.DataBaseWrapperImplementation;
import ro.pub.cs.aipi.lab03.general.Constants;
import ro.pub.cs.aipi.lab03.general.Utilities;
import ro.pub.cs.aipi.lab03.model.Author;
import ro.pub.cs.aipi.lab03.model.Book;
import ro.pub.cs.aipi.lab03.model.Genre;
import ro.pub.cs.aipi.lab03.model.Invoice;
import ro.pub.cs.aipi.lab03.model.InvoiceDetail;
import ro.pub.cs.aipi.lab03.model.Model;
import ro.pub.cs.aipi.lab03.model.PublishingHouse;
import ro.pub.cs.aipi.lab03.model.Series;
import ro.pub.cs.aipi.lab03.model.SupplyOrder;
import ro.pub.cs.aipi.lab03.model.SupplyOrderDetail;
import ro.pub.cs.aipi.lab03.model.User;
import ro.pub.cs.aipi.lab03.model.Writer;

public class TableManagement {

    private String tableName;

    private ArrayList<Label> attributesLabels;
    private ArrayList<Control> attributesControls;

    private DataBaseWrapper databaseWrapper;

    @FXML
    private TableView<Model> tableContentTableView;
    @FXML
    private GridPane attributesGridPane;

    public TableManagement(String tableName) {
        this.tableName = tableName;
        databaseWrapper = DataBaseWrapperImplementation.getInstance();
    }

    @FXML
    public void initialize() throws SQLException {

        if (tableName == null || tableName.equals("")) {
            return;
        }

        if (Constants.DEBUG) {
            System.out.println("starting initialize " + tableName + "...");
        }

        ArrayList<String> attributes = databaseWrapper.getTableColumns(tableName);

        attributesLabels = new ArrayList<>();
        attributesControls = new ArrayList<>();

        tableContentTableView.setItems(null);
        if (tableContentTableView.getColumns() != null) {
            tableContentTableView.getColumns().clear();
        }

        tableContentTableView.setEditable(true);
        int currentIndex = 0;
        for (String attribute : attributes) {

            TableColumn<Model, String> column = new TableColumn<Model, String>(attribute);
            column.setMinWidth(tableContentTableView.getPrefWidth() / attributes.size());
            column.setCellValueFactory(new PropertyValueFactory<Model, String>(attribute));
            tableContentTableView.getColumns().add(column);

            attributesLabels.add(new Label(attribute));
            // TO DO: exercise 3
            
            int attrLabelSize = attributesLabels.size()-1;
            Label label = attributesLabels.get(attrLabelSize);
            GridPane.setConstraints(label, 0, attrLabelSize);
            attributesGridPane.getChildren().add(label);
            
            String parentTable = databaseWrapper.getForeignKeyParentTable(tableName, attribute);
            if (parentTable != null) {
                ComboBox<String> attributeComboBox = new ComboBox<String>();
                attributeComboBox.setMinWidth(Constants.DEFAULT_COMBOBOX_WIDTH);
                attributeComboBox.setMaxWidth(Constants.DEFAULT_COMBOBOX_WIDTH);
                ArrayList<ArrayList<String>> parentTableContent = databaseWrapper.getTableContent(parentTable, null, null, null, null);
                for (ArrayList<String> parentTableRecord : parentTableContent) {
                    attributeComboBox.getItems().add(Utilities.compress(parentTableRecord));
                }
                attributesControls.add(attributeComboBox);
            } else {
                TextField attributeTextField = new TextField();
                attributeTextField.setMinWidth(Constants.DEFAULT_TEXTFIELD_WIDTH);
                attributeTextField.setPromptText(attribute);
                if (currentIndex == 0 && databaseWrapper.isAutoGeneratedPrimaryKey(tableName)) {
                    attributeTextField.setText(Integer.toString(databaseWrapper.getTablePrimaryKeyMaximumValue(tableName) + 1));
                    attributeTextField.setEditable(false);
                }
                attributesControls.add(attributeTextField);
            }
            // TO DO: exercise 3

            int attrControlSize = attributesControls.size()-1;
            Control control = attributesControls.get(attrControlSize);
            GridPane.setConstraints(control, 1, attrControlSize);
            attributesGridPane.getChildren().add(control);

            currentIndex++;
        }
        populateTableView(null);

        if (Constants.DEBUG) {
            System.out.println("finishing initialize " + tableName + "...");
        }
        
        // TO DO: exercise 8

    }

    private Model getCurrentEntity(ArrayList<String> values) {
        switch (tableName) {
            case "publishing_house":
                return new PublishingHouse(values);
            case "series":
                return new Series(values);
            case "genre":
                return new Genre(values);
            case "book":
                return new Book(values);
            case "writer":
                return new Writer(values);
            case "author":
                return new Author(values);
            case "supply_order":
                return new SupplyOrder(values);
            case "supply_order_detail":
                return new SupplyOrderDetail(values);
            case "user":
                return new User(values);
            case "invoice":
                return new Invoice(values);
            case "invoice_detail":
                return new InvoiceDetail(values);
        }
        return null;
    }

    public void populateTableView(String whereClause) {
        try {
            ArrayList<ArrayList<String>> values = DataBaseWrapperImplementation.getInstance().getTableContent(tableName,
                    null,
                    (whereClause == null || whereClause.isEmpty()) ? null : whereClause,
                    null,
                    null);
            ObservableList<Model> data = FXCollections.observableArrayList();
            for (ArrayList<String> record : values) {
                data.add(getCurrentEntity(record));
            }
            tableContentTableView.setItems(data);
        } catch (SQLException sqlException) {
            System.out.println("An exception had occured: " + sqlException.getMessage());
            if (Constants.DEBUG) {
                sqlException.printStackTrace();
            }
        }
    }

    @SuppressWarnings("unchecked")
    @FXML
    private void tableContentTableViewHandler(MouseEvent mouseEvent) {
        ArrayList<String> tableViewRecord = ((Model) tableContentTableView.getSelectionModel().getSelectedItem()).getValues();
        int currentIndex = 0;
        for (String value : tableViewRecord) {
            if (attributesControls.get(currentIndex) instanceof ComboBox) {
                try {
                    String parentTable = databaseWrapper.getForeignKeyParentTable(tableName, attributesLabels.get(currentIndex).getText());
                    if (parentTable != null) {
                        ArrayList<ArrayList<String>> parentTableReferrence = null;
                        parentTableReferrence = databaseWrapper.getTableContent(parentTable,
                                null,
                                databaseWrapper.getTablePrimaryKey(parentTable) + "=" + tableViewRecord.get(currentIndex),
                                null,
                                null);
                        ((ComboBox<String>) attributesControls.get(currentIndex)).setValue(Utilities.compress(parentTableReferrence.get(0)));
                    }
                } catch (SQLException sqlException) {
                    System.out.println("An exception had occured: " + sqlException.getMessage());
                    if (Constants.DEBUG) {
                        sqlException.printStackTrace();
                    }
                }
            } else {
                ((TextField) attributesControls.get(currentIndex)).setText(value);
            }
            currentIndex++;
        }
    }

    @SuppressWarnings("unchecked")
    private boolean checkAllFieldsCompletion() {
        for (Control attributeControl : attributesControls) {
            String value = null;
            if (attributeControl instanceof ComboBox) {
                value = ((ComboBox<String>) attributeControl).getValue();
            } else {
                value = ((TextField) attributeControl).getText();
            }
            if (value == null || value.isEmpty()) {
                return false;
            }
        }
        return true;
    }

    @SuppressWarnings("unchecked")
    @FXML
    private void updateButtonHandler(MouseEvent mouseEvent) {
        if (!checkAllFieldsCompletion()) {
            Dialog dialog = new Dialog();
            dialog.setProperties(Constants.ERROR_WINDOW_TITLE,
                    Constants.ERROR_ICON_LOCATION,
                    Constants.ERROR_MESSAGE_CONTENT);
            dialog.start();
            return;
        }
        int currentIndex = 0;
        ArrayList<String> values = new ArrayList<>();
        for (Control attributeControl : attributesControls) {
            if (attributeControl instanceof ComboBox) {
                try {
                    values.add(databaseWrapper.getForeignKeyValue(tableName,
                            attributesLabels.get(currentIndex).getText(),
                            Utilities.decompress(((ComboBox<String>) attributeControl).getValue())));
                } catch (Exception sqlException) {
                    System.out.println("An exception had occured: " + sqlException.getMessage());
                    if (Constants.DEBUG) {
                        sqlException.printStackTrace();
                    }
                }
            } else {
                values.add(((TextField) attributeControl).getText());
            }
            currentIndex++;
        }
        try {
            databaseWrapper.updateRecordsIntoTable(tableName,
                    null,
                    values,
                    " id = " + values.get(0));
        } catch (Exception sqlException) {
            System.out.println("An exception had occured: " + sqlException.getMessage());
            if (Constants.DEBUG) {
                sqlException.printStackTrace();
            }
        }
        populateTableView(null);
        clearButtonHandler(null);
    }

    @SuppressWarnings("unchecked")
    @FXML
    private void insertButtonHandler(MouseEvent mouseEvent) {
        // exercise 4
        if (!checkAllFieldsCompletion()) {
            Dialog dialog = new Dialog();
            dialog.setProperties(Constants.ERROR_WINDOW_TITLE,
                    Constants.ERROR_ICON_LOCATION,
                    Constants.ERROR_MESSAGE_CONTENT);
            dialog.start();
            return;
        }
        int currentIndex = 0;
        ArrayList<String> values = new ArrayList<>();
        for (Control attributeControl : attributesControls) {
            if (attributeControl instanceof ComboBox) {
                try {
                    values.add(databaseWrapper.getForeignKeyValue(tableName,
                            attributesLabels.get(currentIndex).getText(),
                            Utilities.decompress(((ComboBox<String>) attributeControl).getValue())));
                } catch (Exception sqlException) {
                    System.out.println("An exception had occured: " + sqlException.getMessage());
                    if (Constants.DEBUG) {
                        sqlException.printStackTrace();
                    }
                }
            } else {
                values.add(((TextField) attributeControl).getText());
            }
            currentIndex++;
        }
        try {
            databaseWrapper.insertValuesIntoTable(tableName,
                    null,
                    values,
                    false);
        } catch (Exception sqlException) {
            System.out.println("An exception had occured: " + sqlException.getMessage());
            if (Constants.DEBUG) {
                sqlException.printStackTrace();
            }
        }
        populateTableView(null);
        tableContentTableView.getSelectionModel().select(tableContentTableView.getItems().size() - 1);
        tableContentTableView.scrollTo(tableContentTableView.getItems().size() - 1);
        clearButtonHandler(null);
    }

    @SuppressWarnings("unchecked")
    @FXML
    private void deleteButtonHandler(MouseEvent mouseEvent) {
        int currentIndex = 0;
        ArrayList<String> attributes = new ArrayList<>();
        ArrayList<String> values = new ArrayList<>();
        for (Control attributeControl : attributesControls) {
            String value = null;
            if (attributeControl instanceof ComboBox) {
                try {
                    String parentTableValues = ((ComboBox<String>) attributeControl).getValue();
                    if (parentTableValues != null && !parentTableValues.isEmpty()) {
                        value = databaseWrapper.getForeignKeyValue(tableName,
                                attributesLabels.get(currentIndex).getText(),
                                Utilities.decompress(parentTableValues));
                    }
                } catch (Exception sqlException) {
                    System.out.println("An exception had occured: " + sqlException.getMessage());
                    if (Constants.DEBUG) {
                        sqlException.printStackTrace();
                    }
                }
            } else {
                value = ((TextField) attributeControl).getText();
            }
            if (value != null && !value.isEmpty()) {
                attributes.add(attributesLabels.get(currentIndex).getText());
                values.add(value);
            }
            currentIndex++;
        }
        try {
            if (attributes != null && values != null && !attributes.isEmpty() && !values.isEmpty()) {
                databaseWrapper.deleteRecordsFromTable(tableName,
                        attributes,
                        values,
                        null);
            }
        } catch (Exception sqlException) {
            System.out.println("An exception had occured: " + sqlException.getMessage());
            if (Constants.DEBUG) {
                sqlException.printStackTrace();
            }
        }
        populateTableView(null);
        tableContentTableView.getSelectionModel().select(0);
        tableContentTableView.scrollTo(0);
        clearButtonHandler(null);
    }

    @SuppressWarnings("unchecked")
    @FXML
    private void searchButtonHandler(MouseEvent mouseEvent) {
        // exercise 7
    }

    @SuppressWarnings("unchecked")
    @FXML
    private void clearButtonHandler(MouseEvent mouseEvent) {
        // exercise 5
    }
}
