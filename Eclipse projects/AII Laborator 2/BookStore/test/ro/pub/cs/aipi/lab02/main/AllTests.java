package ro.pub.cs.aipi.lab02.main;

import java.sql.SQLException;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.runner.RunWith;
import org.junit.runners.Suite;

import ro.pub.cs.aipi.lab02.dataaccess.DataBaseWrapper;
import ro.pub.cs.aipi.lab02.dataaccess.DataBaseWrapperImplementation;
import ro.pub.cs.aipi.lab02.general.Constants;

@RunWith(Suite.class)
@Suite.SuiteClasses({
	Exercise02Test.class,
	Exercise03Test.class,
	Exercise04Test.class,
	Exercise05Test.class,
	Exercise06Test.class,
	Exercise07Test.class,
	Exercise08Test.class,
	Exercise09Test.class,
	Exercise10Test.class,
	Exercise11Test.class
})
public class AllTests {

	private static boolean databaseLoaded = false;
	private static boolean databaseUnloaded = false;

	@BeforeClass
	public static void loadDatabase() {
		if (databaseLoaded)
			return;
		DataBaseWrapper dbWrapper = DataBaseWrapperImplementation.getInstance();
		try {
			if (Constants.DEBUG)
				System.out.println("loading database...");
			dbWrapper.runScript(Constants.LOAD_DATABASE_SCRIPT);
			dbWrapper.setDefaultDatabase(Constants.DATABASE_NAME);
		} catch(SQLException exception) {
			System.out.println("An exception has occured: "+exception.getMessage());
			if (Constants.DEBUG)
				exception.printStackTrace();
		} finally {
			databaseLoaded = true;
			dbWrapper.releaseResources();
		}		
	}

	@AfterClass
	public static void unloadDatabase() {
		if (databaseUnloaded)
			return;
		DataBaseWrapper dbWrapper = DataBaseWrapperImplementation.getInstance();
		try {
			if (Constants.DEBUG)
				System.out.println("unloading database...");
			dbWrapper.runScript(Constants.UNLOAD_DATABASE_SCRIPT);
		} catch(SQLException exception) {
			System.out.println("An exception has occured: "+exception.getMessage());
			if (Constants.DEBUG)
				exception.printStackTrace();
		} finally {
			databaseUnloaded = true;
			dbWrapper.releaseResources();
		}
	}
}
