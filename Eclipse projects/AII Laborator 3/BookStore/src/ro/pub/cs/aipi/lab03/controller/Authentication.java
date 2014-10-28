package ro.pub.cs.aipi.lab03.controller;

import java.util.ArrayList;

import javafx.animation.FadeTransition;
import javafx.application.Platform;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.Label;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;
import javafx.scene.image.Image;
import javafx.stage.Stage;
import javafx.util.Duration;
import ro.pub.cs.aipi.lab03.dataaccess.DataBaseWrapper;
import ro.pub.cs.aipi.lab03.dataaccess.DataBaseWrapperImplementation;
import ro.pub.cs.aipi.lab03.general.Constants;

public class Authentication {

    private Stage applicationStage;
    private Scene applicationScene;

    @FXML
    private TextField usernameTextField;
    @FXML
    private PasswordField passwordTextField;
    @FXML
    private Label errorLabel;

    public void start() {

        try {
            applicationScene = new Scene((Parent) FXMLLoader.load(getClass().getResource(Constants.AUTHENTICATION_FXML)));
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
        applicationStage.show();
    }

    @FXML
    protected void okButtonHandler(ActionEvent event) throws Exception {

        // TO DO: exercise 2.4
        String username = usernameTextField.getText();
        String password = passwordTextField.getText();
        
        DataBaseWrapper dbw = DataBaseWrapperImplementation.getInstance();
        String tableName = "user";
        ArrayList<String> columnNames = new ArrayList<>();
        columnNames.add("role");
        
        String whereClause = " username=" + "\'" + username + "\' AND "
        				   + " password=" + "\'" + password + "\' ";
        ArrayList<ArrayList<String>> result;
        result = dbw.getTableContent(tableName, columnNames, whereClause , null, null);
        
        if (result == null || result.isEmpty()) {
        	errorLabel.setText(Constants.ERROR_USERNAME_PASSWORD);
        	FadeTransition ft = new FadeTransition(Duration.seconds(5), errorLabel);
        	ft.setFromValue(1);
        	ft.setToValue(0);
        	ft.play();
        }
        else {
        	for (ArrayList<String> singleResult : result) {
        		if (singleResult != null && singleResult.size() == 1 && singleResult.get(0).equals("administrator")) {
        			((Node) event.getSource()).getScene().getWindow().hide();
        			new Container().start();
        			return;
        		}
        	}
        }
		
    }

    @FXML
    protected void cancelButtonHandler(ActionEvent event) {
        
        // TO DO: exercise 2.4
    	Platform.exit();
    }
}
