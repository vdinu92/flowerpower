package ro.pub.cs.aipi.lab02.general;

public interface Constants {
	final public static String      DATABASE_CONNECTION     = "jdbc:mysql://localhost/";
	final public static String      DATABASE_USERNAME       = "root";
	final public static String      DATABASE_PASSWORD       = "root";
	final public static String      DATABASE_NAME           = "bookstore";

	final public static boolean     DEBUG                   = true;

	final public static String		LOAD_DATABASE_SCRIPT	= "scripts/Laborator02l.sql";
	final public static String		UNLOAD_DATABASE_SCRIPT	= "scripts/Laborator02u.sql";
}
