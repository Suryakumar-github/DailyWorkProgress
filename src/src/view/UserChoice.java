package view;

public enum UserChoice {
    ADMIN(1), USER(2), EXIT(3);

    private final int choice;

    UserChoice(int choice) {
        this.choice = choice;
    }

    public int getChoice() {
        return choice;
    }

    public static UserChoice fromInt(int choice) {
        for (UserChoice userChoice : values()) {
            if (userChoice.choice == choice) {
                return userChoice;
            }
        }
        return null;
    }
}
