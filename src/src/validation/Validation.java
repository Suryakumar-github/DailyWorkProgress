package validation;

import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class Validation {

    private static final String PASSWORD_REGEX = "^[a-zA-Z](?=.*[@#$%^&+=])(?=\\S+$).{5,9}$";
    private static final String NAME_REGEX = "^[a-zA-Z]+$";
    private static final String USERNAME_REGEX = "^[a-zA-Z][a-zA-Z0-9]*$";
    private static final String NUMBER_ONLY_REGEX = "^[0-9]+$";


    public static boolean validatePassword(String password) {
        return validatePattern(password, PASSWORD_REGEX);
    }

    public static boolean validateName(String name) {
        return validatePattern(name, NAME_REGEX);
    }

    public static boolean validateUsername(String username) {
        return validatePattern(username, USERNAME_REGEX);
    }
    public static boolean validateNumbers(String number) {
        return validatePattern(number ,NUMBER_ONLY_REGEX);
    }

    private static boolean validatePattern(String input, String regex) {
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(input);
        return matcher.matches();
    }

}
