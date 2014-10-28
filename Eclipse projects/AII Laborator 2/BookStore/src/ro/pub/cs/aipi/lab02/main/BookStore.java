package ro.pub.cs.aipi.lab02.main;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Scanner;

import javax.sql.rowset.FilteredRowSet;
import javax.sql.rowset.JoinRowSet;

import ro.pub.cs.aipi.lab02.dataaccess.DataBaseException;
import ro.pub.cs.aipi.lab02.dataaccess.DataBaseWrapper;
import ro.pub.cs.aipi.lab02.dataaccess.DataBaseWrapperImplementation;

public class BookStore {

	public int exercise2(String tableName) {
		DataBaseWrapper dbwi = DataBaseWrapperImplementation.getInstance();
		try {
			return dbwi.getTableNumberOfRows(tableName);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return -1;
	}

	public void exercise3() {
		// exercise 3

		DataBaseWrapper dbwi = DataBaseWrapperImplementation.getInstance();
		String tableName =  " book b, publishing_house ph ";
		String whereClause = " ph.id = b.publishing_house_id AND b.stockpile > 0 ";
		String orderByClause = " b.id ASC ";
		ArrayList<String> columnNames = new ArrayList<String>();
		columnNames.add("b.id");
		columnNames.add("(SELECT COALESCE(GROUP_CONCAT(CONCAT(w.first_name, ' ', w.last_name)), '* * *') "
		+ "	FROM author a, writer w "
		+ " WHERE a.book_id = b.id AND w.id = a.writer_id) AS author_names");

		columnNames.add("b.title");
		columnNames.add("ph.name");
		columnNames.add("b.printing_year");
		try {
			ArrayList<ArrayList<String>> tableContent = dbwi.getTableContent(tableName, columnNames, whereClause, orderByClause, null);
			try (BufferedWriter bw = new BufferedWriter(new FileWriter("output/books.txt"))) {
				for(ArrayList<String> recordList : tableContent) {
					String record = "";
					for(String singleRecord : recordList) {
						record += singleRecord + "\t";
					}
					record += "\n";
					bw.write(record, 0, record.length());
				}
			}
		} catch (SQLException | IOException e) {
			e.printStackTrace();
		}
	}

	public int exercise4() {
		int result = -1;
		
		Scanner scanner = new Scanner(System.in);
		System.out.print("personalIdentifier : ");
		String personalIdentifier = scanner.nextLine();
		try {
			Long.parseLong(personalIdentifier);
		} catch (NumberFormatException e) {
			scanner.close();
			return result;
		}
		System.out.print("firstName : ");
		String firstName = scanner.nextLine();
		System.out.print("lastName : ");
		String lastName = scanner.nextLine();
		System.out.print("address : ");
		String address = scanner.nextLine();
		System.out.print("phone_number : ");
		String phoneNumberStr = scanner.nextLine();
		try {
			Long.parseLong(phoneNumberStr);
		} catch (NumberFormatException e) {
			scanner.close();
			return result;
		}
		System.out.print("email : ");
		String email = scanner.nextLine();
		System.out.print("username : ");
		String username = scanner.nextLine();
		System.out.print("password : ");
		String password = scanner.nextLine();
		System.out.println();

		ArrayList<String> columnNames = new ArrayList<String>();
		ArrayList<String> values = new ArrayList<String>();

		columnNames.add("personal_identifier");
		values.add(personalIdentifier);
		columnNames.add("first_name");
		values.add(firstName);
		columnNames.add("last_name");
		values.add(lastName);
		columnNames.add("address");
		values.add(address);
		columnNames.add("phone_number");
		values.add(phoneNumberStr);
		columnNames.add("email");
		values.add(email);
		columnNames.add("username");
		values.add(username);
		columnNames.add("password");
		values.add(password);

		DataBaseWrapper dbwi = DataBaseWrapperImplementation.getInstance();
		try {
			result = dbwi.insertValuesIntoTable("user", columnNames, values, true);
		} catch (SQLException | DataBaseException e) {
			e.printStackTrace();
		}
		
		scanner.close();
		return result;
	}

	public int exercise5() {
		int result = -1;
		// exercise 5
		
		DataBaseWrapper dbwi = DataBaseWrapperImplementation.getInstance();
		String tableName =  " supply_order_detail, publishing_house, supply_order ";
		String whereClause = " supply_order.publishing_house_id = publishing_house.id AND "
								   + " supply_order_detail.supply_order_id = supply_order.id AND"
								   + " publishing_house.id = 50 AND "
								   + " publishing_house.registered_number = 510636670 ";
		ArrayList<String> columnNames = new ArrayList<String>();
		ArrayList<String> values = new ArrayList<String>();
		columnNames.add("supply_order_detail.quantity");
		values.add("1.2*supply_order_detail.quantity");
		try {
			result = dbwi.updateRecordsIntoTable(tableName, columnNames, values, whereClause);
			
		} catch (SQLException | DataBaseException e) {
			e.printStackTrace();
		}
		return result;
	}

	public int exercise6() {
		int result = -1;
		// exercise 6
		DataBaseWrapper dbwi = DataBaseWrapperImplementation.getInstance();
		String tableName =  " publishing_house ";
		String whereClause = " (select count(*) from book b where b.publishing_house_id = publishing_house.id) = 0 ";
		
		try {
			result = dbwi.deleteRecordsFromTable(tableName, null, null, whereClause);
		} catch (SQLException | DataBaseException e) {
			e.printStackTrace();
		}
		return result;
	}

	public void exercise7() {
		// exercise 7

		DataBaseWrapper dbwi = DataBaseWrapperImplementation.getInstance();
		ArrayList<String> parameterTypes = new ArrayList<>();
		parameterTypes.addAll(Arrays.asList(new String[] {"IN", "OUT"}));
		ArrayList<Integer> parameterDataTypes = new ArrayList<>();
		parameterDataTypes.addAll(Arrays.asList(new Integer[] {java.sql.Types.FLOAT}));

		ArrayList<String> cnpUsers = new ArrayList<>();
		
		try {
			for(String cnp : cnpUsers) {
				ArrayList<String> cnpArray = (ArrayList<String>) Arrays.asList(cnp);
				dbwi.executeProcedure("calculate_user_total_invoice_value", parameterTypes, cnpArray, parameterDataTypes);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}

	public void exercise8() {
		// TO DO: exercise 8   
	}

	public void exercise9() {
		// TO DO: exercise 9
	}

	public JoinRowSet exercise10() {
		JoinRowSet joinRowSet = null;
		// TO DO: exercise 10
		return joinRowSet;
	}

	public FilteredRowSet exercise11() {
		FilteredRowSet filteredRowSet = null;
		// TO DO: exercise 11
		return filteredRowSet;
	}
}
