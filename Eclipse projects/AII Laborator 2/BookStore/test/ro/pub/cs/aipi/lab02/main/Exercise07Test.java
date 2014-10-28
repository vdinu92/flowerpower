package ro.pub.cs.aipi.lab02.main;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.io.BufferedReader;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.junit.BeforeClass;
import org.junit.Test;

public class Exercise07Test {

	@BeforeClass
	public static void executeExercise7() {
		BookStore bookstore = new BookStore();
		bookstore.exercise7();
	}

	@Test
	public void checkFileContent() {
		Path outputFile = Paths.get("output/user_total_invoice_value.txt");
		assertTrue("File user_total_invoce_value.txt does not exist or cannot be accessed!", outputFile != null && Files.isRegularFile(outputFile) && Files.isReadable(outputFile));
		Path inputFile = Paths.get("input/user_total_invoice_value.txt");
		assertTrue("Reference file does not exist or cannot be accessed!", inputFile != null && Files.isRegularFile(inputFile) && Files.isReadable(inputFile));	
		Charset charset = Charset.forName("UTF-8");
		try (BufferedReader outputFileBufferedReader = Files.newBufferedReader(outputFile, charset); BufferedReader inputFileBufferedReader = Files.newBufferedReader(inputFile, charset)) {
			String outputFileCurrentLine, inputFileCurrentLine;
			int currentLine = 1;
			while ((outputFileCurrentLine = outputFileBufferedReader.readLine()) != null &&
					(inputFileCurrentLine = inputFileBufferedReader.readLine()) != null) {
				assertEquals("Files do not match at line "+currentLine, outputFileCurrentLine, inputFileCurrentLine);
				currentLine++;
			}
		} catch (IOException ioException) {
			System.out.println("An exception has occurred!"+ioException.getMessage());
		}
	}
}
