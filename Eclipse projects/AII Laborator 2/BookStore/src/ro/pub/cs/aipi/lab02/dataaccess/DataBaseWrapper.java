package ro.pub.cs.aipi.lab02.dataaccess;

import java.util.ArrayList;
import java.sql.SQLException;

import ro.pub.cs.aipi.lab02.entities.Referrence;

public interface DataBaseWrapper {

	public void setDefaultDatabase(String currentDatabase);

	public ArrayList<String> getTableNames() throws SQLException;
	public int getTableNumberOfRows(String tableName) throws SQLException;
	public int getTableNumberOfColumns(String tableName) throws SQLException;
	public String getTablePrimaryKey(String tableName) throws SQLException;
	public ArrayList<String> getTablePrimaryKeys(String tableName) throws SQLException;
	public int getTablePrimaryKeyMaximumValue(String tableName) throws SQLException;
	public ArrayList<String> getTableColumns(String tableName) throws SQLException;

	public ArrayList<ArrayList<String>> getTableContent(String tableName, ArrayList<String> columnNames, String whereClause, String orderByClause, String groupByClause) throws SQLException;

	public int insertValuesIntoTable(String tableName, ArrayList<String> columnNames, ArrayList<String> values, boolean skipPrimaryKey) throws SQLException, DataBaseException;
	public int updateRecordsIntoTable(String tableName, ArrayList<String> columnNames, ArrayList<String> values, String whereClause) throws SQLException, DataBaseException;
	public int deleteRecordsFromTable(String tableName, ArrayList<String> columnNames, ArrayList<String> values, String whereClause) throws SQLException, DataBaseException;

	public String executeProcedure(String procedureName, ArrayList<String> parameterTypes, ArrayList<String> parameterValues, ArrayList<Integer> parameterDataTypes) throws SQLException;

	public ArrayList<Referrence> getReferrences(String tableName) throws SQLException;

	public void releaseResources();

	public void runScript(String fileName) throws SQLException;

}
