package com.QoRders.client;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
/**
 * Clase principal de la aplicación.
 *
 * @author John
 * @version 1.0
 */
@SpringBootApplication(scanBasePackages = "com.QoRders.client")
public class QoRdersSbApplication {
    /**
     * Método principal de la aplicación.
     *
     * @param args Argumentos de la línea de comandos.
     */
    public static void main(String[] args){
        SpringApplication.run(QoRdersSbApplication.class, args);
    }
}