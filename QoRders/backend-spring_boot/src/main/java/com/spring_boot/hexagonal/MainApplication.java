package com.spring_boot.hexagonal;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;

/**
 * The main class for the Hexagonal Spring Boot application.
 */
@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class})
public class MainApplication {

    /**
     * The main method that serves as the entry point for the Spring Boot application.
     *
     * @param args Command line arguments
     */
    public static void main(String[] args) {
        SpringApplication.run(MainApplication.class, args);
    }

}