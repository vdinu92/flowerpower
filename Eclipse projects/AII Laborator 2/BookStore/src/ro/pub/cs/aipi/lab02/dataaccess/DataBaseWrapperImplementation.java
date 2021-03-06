package ro.pub.cs.aipi.lab02.dataaccess;

import java.io.BufferedReader;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import ro.pub.cs.aipi.lab02.entities.Referrence;
import ro.pub.cs.aipi.lab02.general.Constants;

public class DataBaseWrapperImplementation implements DataBaseWrapper {

	private Connection        				dbConnection;
	private DatabaseMetaData  				dbMetaData;
	private String 							defaultDatabase;

	private static DataBaseWrapperImplementation 	instance;


	private DataBaseWrapperImplementation() { }

	public void releaseResources() {
		try {
			closeConnection();
		} catch (SQLException exception) {
			System.out.println("An exception has occured: "+exception.getMessage());
			if (Constants.DEBUG)
				exception.printStackTrace();
		}
	}

	public static DataBaseWrapperImplementation getInstance() {
		if (instance == null)
			instance = new DataBaseWrapperImplementation();
		return instance;
	}

	private void openConnection() throws SQLException {
		if (dbConnection == null || dbConnection.isClosed()) {
			dbConnection  = DriverManager.getConnection(
					Constants.DATABASE_CONNECTION + (defaultDatabase!=null?defaultDatabase:""), 
					Constants.DATABASE_USERNAME, 
					Constants.DATABASE_PASSWORD);
			dbMetaData    = dbConnection.getMetaData();
		}
	}

	private void closeConnection() throws SQLException {
		if (dbConnection != null && !dbConnection.isClosed())
			dbConnection.close();
	}

	private Statement createStatement() throws SQLException {
		openConnection();
		return dbConnection.createStatement(
				ResultSet.TYPE_SCROLL_SENSITIVE, 
				ResultSet.CONCUR_UPDATABLE);
	}

	private void destroyStatement(Statement statement) throws SQLException {
		if (statement != null && !statement.isClosed())
			statement.close();
	}

	public void setDefaultDatabase(String defaultDatabase) {
		this.defaultDatabase = defaultDatabase; 	
	}

	public ArrayList<String> getTableNames() throws SQLException {
		openConnection();
		ArrayList<String> tableNames = new ArrayList<>();
		ResultSet result = dbMetaData.getTables(Constants.DATABASE_NAME, null, null, null);
		while (result.next())
			tableNames.add(result.getString("TABLE_NAME"));
		return tableNames;
	}

	public int getTableNumberOfRows(String tableName) throws SQLException {
		int numberOfRows = -1;
		String query = "SELECT COUNT(*) FROM "+tableName;
		openConnection();
		Statement statement = createStatement();
		ResultSet result = statement.executeQuery(query);
		result.next();
		numberOfRows = result.getInt(1);
		destroyStatement(statement);
		return numberOfRows;
	}

	public int getTableNumberOfColumns(String tableName) throws SQLException {
		int numberOfColumns = 0;
		openConnection();
		ResultSet result = dbMetaData.getColumns(Constants.DATABASE_NAME, null, tableName, null);
		while (result.next()) 
			numberOfColumns++;
		return numberOfColumns;
	}

	public String getTablePrimaryKey(String tableName) throws SQLException {
		ArrayList<String> result = getTablePrimaryKeys(tableName);
		if (result.size() != 1)
			return null;
		return result.get(0);
	}    

	public ArrayList<String> getTablePrimaryKeys(String tableName) throws SQLException {
		ArrayList<String> primaryKeys = new ArrayList<>();
		openConnection();
		ResultSet result = dbMetaData.getPrimaryKeys(Constants.DATABASE_NAME, null, tableName);
		while (result.next())
			primaryKeys.add(result.getString("COLUMN_NAME"));
		return primaryKeys;
	}     

	public int getTablePrimaryKeyMaximumValue(String tableName) throws SQLException {
		String primaryKey = getTablePrimaryKey(tableName);
		String query = "SELECT MAX("+primaryKey+") FROM "+tableName;
		openConnection();
		Statement statement = createStatement();
		ResultSet result = statement.executeQuery(query);
		result.next();
		int primaryKeyMaximumValue = result.getInt(1);
		destroyStatement(statement);
		return primaryKeyMaximumValue;
	}    

	public ArrayList<String> getTableColumns(String tableName) throws SQLException {
		ArrayList<String> tableColumns = new ArrayList<>();
		openConnection();
		ResultSet result = dbMetaData.getColumns(Constants.DATABASE_NAME, null, tableName, null);
		while (result.next())
			tableColumns.add(result.getString("COLUMN_NAME"));
		return tableColumns;
	}

	public ArrayList<ArrayList<String>> getTableContent(String tableName, ArrayList<String> attributes, String whereClause, String orderByClause, String groupByClause) throws SQLException {
		openConnection();
		Statement statement = createStatement();
		String query = 
				  " SELECT ";
		int numberOfColumns = -1;
		if (attributes == null) {
			numberOfColumns = getTableNumberOfColumns(tableName);
			query += "*";
		}
		else {
			numberOfColumns = attributes.size();
			for (String attribute:attributes) {
				query += attribute+", ";
			}
			query = query.substring(0,query.length()-2);            
		}
		query += " FROM " + tableName;
		if (whereClause != null) {
			query += " WHERE "+whereClause;
		}
		if (groupByClause != null) {
			query += " GROUP BY "+groupByClause;
		}
		if (orderByClause != null) {
			query += " ORDER BY "+orderByClause;
		}
		if (Constants.DEBUG) {
			System.out.println("query: "+query);
		}
		if (numberOfColumns == -1) {
			return null;
		}      
		ArrayList<ArrayList<String>> dataBaseContent = new ArrayList<>();
		ResultSet result = statement.executeQuery(query);  
		int currentRow = 0;
		while (result.next()) {
			dataBaseContent.add(new ArrayList<String>());
			for (int currentColumn = 0; currentColumn < numberOfColumns; currentColumn++) {
				dataBaseContent.get(currentRow).add(result.getString(currentColumn+1));
			}
			currentRow++;
		}
		destroyStatement(statement);
		return dataBaseContent;
	}

	public int insertValuesIntoTable(String tableName, ArrayList<String> attributes, ArrayList<String> values, boolean skipPrimaryKey) throws SQLException, DataBaseException {
		int result = -1;
		openConnection();
		Statement statement = createStatement();
		String query = "INSERT INTO "+tableName+" (";
		if (attributes == null) {
			attributes = getTableColumns(tableName);
			if (skipPrimaryKey) {
				attributes.remove(0);
			}
		}
		if (attributes.size() != values.size()) {
			throw new DataBaseException ("Numarul de atribute ("+attributes.size()+") nu corespunde cu numarul de valori ("+values.size()+") precizate");
		}
		for (String attribute:attributes) {
			query += attribute + ", ";
		}      
		query = query.substring(0,query.length()-2);
		query += ") VALUES (";
		for (String currentValue: values) {
			query += "\'"+currentValue+"\',";
		}
		query = query.substring(0,query.length()-1);
		query += ")";
		if (Constants.DEBUG) {
			System.out.println("query: "+query);
		}
		result = statement.executeUpdate(query);
		destroyStatement(statement);
		return result;
	}

	public int updateRecordsIntoTable(String tableName, ArrayList<String> attributes, ArrayList<String> values, String whereClause) throws SQLException, DataBaseException {
		int result = -1;
		openConnection();
		Statement statement = createStatement();
		String query = "UPDATE "+tableName+" SET ";
		if (attributes == null) {
			attributes = getTableColumns(tableName);
		}
		if (attributes.size() != values.size()) {
			throw new DataBaseException ("Numarul de atribute ("+attributes.size()+") nu corespunde cu numarul de valori ("+values.size()+") precizate");
		}
		for (int currentIndex = 0; currentIndex < values.size(); currentIndex++) {
			query += attributes.get(currentIndex)+"="+values.get(currentIndex)+", ";
		}
		query = query.substring(0,query.length()-2);
		query += " WHERE ";
		if (whereClause != null ) {
			query += whereClause;
		} else {
			query += getTablePrimaryKey(tableName)+"=\'"+values.get(0)+"\'";
		}
		if (Constants.DEBUG) {
			System.out.println("query: "+query);
		}
		result = statement.executeUpdate(query);
		destroyStatement(statement);
		return result;
	}

	public int deleteRecordsFromTable(String tableName, ArrayList<String> attributes, ArrayList<String> values, String whereClause) throws SQLException, DataBaseException {
		int result = -1;
		openConnection();
		Statement statement = createStatement();
		String query = "DELETE FROM "+tableName;
		
		query += " WHERE ";
		
		if (attributes != null && values != null) {
			if(attributes.size() != values.size()) {
				throw new DataBaseException ("Numarul de atribute ("+attributes.size()+") nu corespunde cu numarul de valori ("+values.size()+") precizate");
			}
			for (int currentIndex = 0; currentIndex < values.size(); currentIndex++) {
				query += attributes.get(currentIndex)+"="+values.get(currentIndex)+", ";
			}
			query = query.substring(0,query.length()-2);
		}
		else if (whereClause != null ) {
			query += whereClause;
		}
		else {
			throw new DataBaseException ("Nu a fost precizata clauza where in metoda deleteRecordsFromTable().");
		}
		if (Constants.DEBUG) {
			System.out.println("query: "+query);
		}
		result = statement.executeUpdate(query);
		destroyStatement(statement);
		return result;
	}

	public String executeProcedure(String procedureName, ArrayList<String> parameterTypes, ArrayList<String> parameterValues, ArrayList<Integer> parameterDataTypes) throws SQLException {
		String result = new String();
		int resultIndex = -1;
		openConnection();
		String query = "{CALL "+procedureName+"(";
		int parameterNumber = parameterTypes.size();
		for (int count = 1; count <= parameterNumber; count++)
			query += "?, ";
		if (parameterNumber != 0)
			query = query.substring(0,query.length()-2);
		query += ")}";
		CallableStatement statement = dbConnection.prepareCall(query);
		int i = 0, j = 0, k = 1;
		for (String parameterType:parameterTypes) {
			switch (parameterType) {
			case "IN":
				statement.setString(k,parameterValues.get(i++));
				break;
			case "OUT":
				statement.registerOutParameter(k,parameterDataTypes.get(j++).intValue());
				resultIndex = k;
				break;
			case "INOUT":
				statement.setString(k,parameterValues.get(i++));
				statement.registerOutParameter(k, parameterDataTypes.get(j++).intValue());
				resultIndex = k;
				break;
			}
			k++;
		}
		statement.execute();
		result = statement.getString(resultIndex);
		statement.close();
		return result;
	}


	public ArrayList<Referrence> getReferrences(String tableName) throws SQLException {
		ArrayList<Referrence> referrences = new ArrayList<>();
		// TO DO: exercise 9
		return referrences;
	}

	public void runScript(String fileName) throws SQLException {
		openConnection();
		Charset charset = Charset.forName("UTF-8");
		try (BufferedReader bufferedReader = Files.newBufferedReader(Paths.get(fileName), charset)) {
			String currentLine;
			StringBuffer command = new StringBuffer();
			boolean insideStoredProcedure = false, insideComment = false;
			while ((currentLine = bufferedReader.readLine()) != null) {
				if ((!insideComment && currentLine.startsWith("/*")) || (insideComment && currentLine.endsWith("*/"))) {
					insideComment = !insideComment;
					continue;
				}
				if (currentLine == null || currentLine.isEmpty() || currentLine.startsWith("--"))
					continue;
				if (currentLine.endsWith("//")) {
					insideStoredProcedure = !insideStoredProcedure;
					if (!insideStoredProcedure)
						command.append(currentLine.substring(0, currentLine.indexOf("//")).trim()+" ");
				}
				else
					command.append(currentLine.trim()+" ");
				if ((currentLine.endsWith(";") || currentLine.endsWith("//")) && !insideStoredProcedure) {
					if (Constants.DEBUG)
						System.out.println("Executing command: "+command.toString());
					Statement statement = null;
					try {
						statement = createStatement();
						statement.execute(command.toString());
						if (Constants.DEBUG)
							System.out.println("Command has been executed successfully");
					} catch (SQLException sqlException) {
						System.out.println("Command has not been executed successfully: "+sqlException.getMessage());
						if (Constants.DEBUG)
							sqlException.printStackTrace();
					} finally {
						if (statement != null)
							destroyStatement(statement);
					}
					command = new StringBuffer();
				}
			}
		} catch (Exception exception) {
			System.out.println("An exception has occured: "+exception.getMessage());
			if (Constants.DEBUG)
				exception.printStackTrace();
		}
	}

}
