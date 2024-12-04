package com.QoRders.client;

import java.io.FileOutputStream;
import java.io.PrintStream;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = "com.QoRders.client")
public class QoRdersSbApplication {
    public static void main(String[] args) throws Exception {
        System.setOut(new PrintStream(new FileOutputStream("logs/output.log", true)));
        SpringApplication.run(QoRdersSbApplication.class, args);
    }
}