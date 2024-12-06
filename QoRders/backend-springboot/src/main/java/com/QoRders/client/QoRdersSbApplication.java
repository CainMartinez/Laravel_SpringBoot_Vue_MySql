package com.QoRders.client;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = "com.QoRders.client")
public class QoRdersSbApplication {
    public static void main(String[] args){
        SpringApplication.run(QoRdersSbApplication.class, args);
    }
}