package functionalTest;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import static org.junit.Assert.*;

import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

public class KarateRunner {

    @Test
    public void testParallel() throws IOException {
        // Needed for pass values from parameters
//        String environment = String.valueOf(System.getProperty("karate.ENV"));

        List<String> tags = Arrays.asList("~@ignore");
        List<String> features = Arrays.asList("src/test/scala/test/features");
        String karateOutputPath = "target/surefire-reports";
        Results results = Runner.parallel(tags, features, 6, karateOutputPath);

        // Doing in Jenkins with cucumber plugins
        generateReport(karateOutputPath);
        assertTrue(results.getErrorMessages(), results.getFailCount() == 0);
    }

    private static void generateReport(String karateOutputPath) {
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[]{"json"}, true);
        List<String> jsonPaths = new ArrayList(jsonFiles.size());
        for (File file : jsonFiles) {
            jsonPaths.add(file.getAbsolutePath());
        }
        Configuration config = new Configuration(new File("target"), "ryanair_demo");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();    }
}