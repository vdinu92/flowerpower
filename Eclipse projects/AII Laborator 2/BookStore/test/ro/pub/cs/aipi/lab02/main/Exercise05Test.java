package ro.pub.cs.aipi.lab02.main;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

import java.sql.SQLException;
import java.util.ArrayList;

import org.junit.BeforeClass;
import org.junit.Test;

import ro.pub.cs.aipi.lab02.dataaccess.DataBaseWrapper;
import ro.pub.cs.aipi.lab02.dataaccess.DataBaseWrapperImplementation;
import ro.pub.cs.aipi.lab02.general.Constants;

public class Exercise05Test {

	@BeforeClass
	public static void executeExercise5() {
		BookStore bookstore = new BookStore();
		int result = bookstore.exercise5();
		if (result != 3)
			fail("The records were not updated! "+result);
	}

	@Test
	public void checkSupplyOrderDetail27() {	
		DataBaseWrapper dbWrapper = DataBaseWrapperImplementation.getInstance();
		try {
			ArrayList<String> attributes = new ArrayList<>();
			attributes.add("quantity");
			ArrayList<ArrayList<String>> content = dbWrapper.getTableContent("supply_order_detail", attributes, "id=\'27\'", null, null);
			assertEquals("book 27 should have been ordered in 12 copies", 12, Integer.parseInt(content.get(0).get(0)));
		} catch(SQLException exception) {
			System.out.println("An exception has occured: "+exception.getMessage());
			if (Constants.DEBUG)
				exception.printStackTrace();
			fail("book 27 should have been ordered in 12 copies");
		} finally {
			dbWrapper.releaseResources();
		}	
	}

	@Test
	public void checkSupplyOrderDetail39() {	
		DataBaseWrapper dbWrapper = DataBaseWrapperImplementation.getInstance();
		try {
			ArrayList<String> attributes = new ArrayList<>();
			attributes.add("quantity");
			ArrayList<ArrayList<String>> content = dbWrapper.getTableContent("supply_order_detail", attributes, "id=\'39\'", null, null);
			assertEquals("book 39 should have been ordered in 1 copy", 1, Integer.parseInt(content.get(0).get(0)));
		} catch(SQLException exception) {
			System.out.println("An exception has occured: "+exception.getMessage());
			if (Constants.DEBUG)
				exception.printStackTrace();
			fail("book 39 should have been ordered in 1 copy");
		} finally {
			dbWrapper.releaseResources();
		}	
	}

	@Test
	public void checkSupplyOrderDetail79() {	
		DataBaseWrapper dbWrapper = DataBaseWrapperImplementation.getInstance();
		try {
			ArrayList<String> attributes = new ArrayList<>();
			attributes.add("quantity");
			ArrayList<ArrayList<String>> content = dbWrapper.getTableContent("supply_order_detail", attributes, "id=\'79\'", null, null);
			assertEquals("book 79 should have been ordered in 5 copies", 5, Integer.parseInt(content.get(0).get(0)));
		} catch(SQLException exception) {
			System.out.println("An exception has occured: "+exception.getMessage());
			if (Constants.DEBUG)
				exception.printStackTrace();
			fail("book 79 should have been ordered in 5 copies");
		} finally {
			dbWrapper.releaseResources();
		}	
	}
}
