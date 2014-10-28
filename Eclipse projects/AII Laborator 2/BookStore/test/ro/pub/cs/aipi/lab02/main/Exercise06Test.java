package ro.pub.cs.aipi.lab02.main;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.fail;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;

import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

import ro.pub.cs.aipi.lab02.dataaccess.DataBaseWrapper;
import ro.pub.cs.aipi.lab02.dataaccess.DataBaseWrapperImplementation;
import ro.pub.cs.aipi.lab02.general.Constants;

@RunWith(Parameterized.class)
public class Exercise06Test {

	private int parameter;

	public Exercise06Test(Integer parameter) {
		this.parameter = parameter.intValue();
	}

	@Parameters
	public static Collection<Object[]> data() {
		return Arrays.asList(new Object[][] { 
				{1}, {4}, {6}, {8}, 
				{13}, 
				{21}, {23}, 
				{34}, {39}, 
				{42}, {43}, {46}, {48}, 
				{50}, {51}, {54}, {55}, {56}, {57}, {58}, 
				{63}, {64}, {65}, {66}, {67}, 
				{70}, {72}, {74}, {77}, 
				{80}, {82}, {87}, {88}, {89}, 
				{91}, {96}, {99}
		});
	}	

	@BeforeClass
	public static void executeExercise6() {
		BookStore bookstore = new BookStore();
		int result = bookstore.exercise6();
		if (result != 37)
			fail("The records were not deleted! "+result);
	}

	@Test
	public void checkDeletedPublishingHouses() {	
		DataBaseWrapper dbWrapper = DataBaseWrapperImplementation.getInstance();
		try {
			ArrayList<String> attributes = new ArrayList<>();
			attributes.add("COUNT(*)");
			ArrayList<ArrayList<String>> content = dbWrapper.getTableContent("publishing_house", attributes, "id=\'"+parameter+"\'", null, null);
			assertEquals("publishing_house "+parameter+" should have been ordered deleted", 0, Integer.parseInt(content.get(0).get(0)));
		} catch(SQLException exception) {
			System.out.println("An exception has occured: "+exception.getMessage());
			if (Constants.DEBUG)
				exception.printStackTrace();
			fail("publishing_house "+parameter+" should have been ordered deleted");
		} finally {
			dbWrapper.releaseResources();
		}
	}
}
