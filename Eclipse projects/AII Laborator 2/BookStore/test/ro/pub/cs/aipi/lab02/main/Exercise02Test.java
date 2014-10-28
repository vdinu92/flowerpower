package ro.pub.cs.aipi.lab02.main;

import static org.junit.Assert.assertEquals;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collection;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

import ro.pub.cs.aipi.lab02.dataaccess.DataBaseWrapper;
import ro.pub.cs.aipi.lab02.dataaccess.DataBaseWrapperImplementation;
import ro.pub.cs.aipi.lab02.general.Constants;

@RunWith(Parameterized.class)
public class Exercise02Test {

	private String parameter;

	public Exercise02Test(String parameter) {
		this.parameter = parameter;
	}

	@Parameters
	public static Collection<Object[]> data() {
		AllTests.loadDatabase();
		ArrayList<Object[]> data = new ArrayList<>();
		DataBaseWrapper dbWrapper = DataBaseWrapperImplementation.getInstance();
		try {
			for (String tableName:dbWrapper.getTableNames())
				data.add(new Object[]{tableName});
		} catch(SQLException exception) {
			System.out.println("An exception has occured: "+exception.getMessage());
			if (Constants.DEBUG)
				exception.printStackTrace();
		} finally {
			dbWrapper.releaseResources();
		}
		return data;
	}

	@Test
	public void checkNumberOfRecords() {
		BookStore bookstore = new BookStore();
		assertEquals(parameter+" should have 100 records", 100, bookstore.exercise2(parameter));
	}

}
