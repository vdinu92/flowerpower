package ro.pub.cs.aipi.lab03.dataaccess;

public class DataBaseException extends Exception {

    private static final long serialVersionUID = 2014L;

    private static final String MESSAGE = "Eroare la executia operatiei in baza de date";

    public DataBaseException() {
        super(MESSAGE);
    }

    public DataBaseException(String message) {
        super(MESSAGE + ": " + message);
    }

    public DataBaseException(Throwable cause) {
        super(MESSAGE, cause);
    }

    public DataBaseException(String message, Throwable cause) {
        super(MESSAGE + ": " + message, cause);
    }

}
