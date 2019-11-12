package functionalTest;

import java.net.MalformedURLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Random;

public class Utilities {

    public String getYesterdayDate() {
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd");
        return LocalDate.now().minusDays(1).toString();
    }

    public String getTodayDate() throws MalformedURLException {
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy/MM/dd");
        LocalDate localDate = LocalDate.now();
        return LocalDate.now().toString();
    }

    public Integer getRandomNumber(int min, int max)  throws MalformedURLException {
        Random rand = new Random();
        int randomNum = rand.nextInt((max - min) + 1) + min;
        return randomNum;
    }
}