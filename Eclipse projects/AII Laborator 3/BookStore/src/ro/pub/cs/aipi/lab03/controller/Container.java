package ro.pub.cs.aipi.lab03.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;

import javafx.application.Platform;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.event.ActionEvent;
import javafx.event.Event;
import javafx.event.EventHandler;
import javafx.event.EventType;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Menu;
import javafx.scene.control.MenuBar;
import javafx.scene.control.MenuItem;
import javafx.scene.control.Tab;
import javafx.scene.control.TabPane;
import javafx.scene.image.Image;
import javafx.stage.Stage;
import ro.pub.cs.aipi.lab03.dataaccess.DataBaseWrapper;
import ro.pub.cs.aipi.lab03.dataaccess.DataBaseWrapperImplementation;
import ro.pub.cs.aipi.lab03.general.Constants;
import ro.pub.cs.aipi.lab03.general.Utilities;

public class Container implements EventHandler<Event> {

    private Stage applicationStage;
    private Scene applicationScene;

    private ArrayList<TableManagement> databaseManagementControllers;

    @FXML
    private MenuBar containerMenu;
    @FXML
    private Menu databaseManagementMenu;

    @FXML
    private TabPane databaseManagementTabPane;

    public Container() {
        databaseManagementControllers = new ArrayList<>();
    }

    public void start() {

        try {
            applicationScene = new Scene((Parent) FXMLLoader.load(getClass().getResource(Constants.CONTAINER_FXML)));
        } catch (Exception exception) {
            System.out.println("An exception has occured: " + exception.getMessage());
            if (Constants.DEBUG) {
                exception.printStackTrace();
            }
        }

        applicationStage = new Stage();
        applicationStage.setTitle(Constants.APPLICATION_NAME);
        applicationStage.getIcons().add(new Image(getClass().getResource(Constants.ICON_FILE_NAME).toExternalForm()));
        applicationStage.setScene(applicationScene);
        applicationStage.setMaximized(true);
        applicationStage.show();
    }

    @FXML
    private void initialize() {
        try {
            DataBaseWrapper dbWrapper = DataBaseWrapperImplementation.getInstance();
            ArrayList<String> tableNames = dbWrapper.getTableNames();
            for (String tableName : tableNames) {
                MenuItem menuItem = new MenuItem(Utilities.tableNameToMenuEntry(tableName));
                menuItem.addEventHandler(EventType.ROOT, (EventHandler<Event>) this);
                databaseManagementMenu.getItems().add(menuItem);
            }
        } catch (SQLException sqlException) {
            System.out.println("An exception has occured: " + sqlException.getMessage());
            if (Constants.DEBUG) {
                sqlException.printStackTrace();
            }
        }
        databaseManagementTabPane.getSelectionModel().selectedItemProperty().addListener(
                new ChangeListener<Tab>() {
                    @Override
                    public void changed(
                            ObservableValue<? extends Tab> observableValue,
                            Tab oldTab,
                            Tab newTab) {
                                if (Constants.DEBUG && oldTab != null && newTab != null) {
                                    System.out.println("The tab has been changed " + oldTab.getText() + " -> " + newTab.getText());
                                }
                                int currentIndex = 0;
                                for (Tab tab : databaseManagementTabPane.getTabs()) {
                                    if (tab.getText().equals(newTab.getText())) {
                                        try {
                                            if (Constants.DEBUG) {
                                                System.out.println("The index of the controller is: " + currentIndex + " / " + databaseManagementControllers.size());
                                            }
                                            if (!databaseManagementControllers.isEmpty()) {
                                                TableManagement currentTableManagementController = databaseManagementControllers.get(currentIndex);
                                                if (Constants.DEBUG) {
                                                    System.out.println("calling initialize of table management controller...");
                                                }
                                                currentTableManagementController.initialize();
                                                if (Constants.DEBUG) {
                                                    System.out.println("returning from call of initialize of table management controller...");
                                                }
                                            }
                                        } catch (SQLException sqlException) {
                                            System.out.println("An exception had occured: " + sqlException.getMessage());
                                            if (Constants.DEBUG) {
                                                sqlException.printStackTrace();
                                            }
                                        }
                                    }
                                    currentIndex++;
                                }
                            }
                });
    }

    @FXML
    protected void closeMenuItemHandler(ActionEvent event) {
        Platform.exit();
    }
    
    // TO DO: exercise 6

    @Override
    public void handle(final Event event) {
        if (event.getSource() instanceof MenuItem) {
            Platform.runLater(new Runnable() {
                @Override
                public void run() {
                    String menuEntry = ((MenuItem) event.getSource()).getText();
                    boolean tabExists = false;
                    for (Tab tab : databaseManagementTabPane.getTabs()) {
                        if (tab.getText().equals(menuEntry)) {
                            tabExists = true;
                            databaseManagementTabPane.getSelectionModel().select(tab);
                        }
                    }
                    if (!tabExists) {
                        FXMLLoader fxmlLoader = new FXMLLoader(this.getClass().getResource(Constants.TABLE_MANAGEMENT_FXML));
                        TableManagement databaseManagementController = new TableManagement(Utilities.menuEntryToTableName(menuEntry));
                        fxmlLoader.setController(databaseManagementController);
                        databaseManagementControllers.add(databaseManagementController);
                        Parent view = null;
                        try {
                            view = (Parent) fxmlLoader.load();
                        } catch (IOException ioException) {
                            System.out.println("An exception has occured: " + ioException.getMessage());
                        }
                        Tab tab = new Tab();
                        tab.setText(menuEntry);
                        tab.setContent(view);
                        databaseManagementTabPane.getTabs().add(tab);
                        databaseManagementTabPane.getSelectionModel().select(tab);
                    }
                }
            });
        }
    }
}
