package com.QoRders.client.unit;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class ExampleTest {

    @Test
    public void testExample() {
        int expected = 42;
        int actual = 40 + 2;
        assertEquals(expected, actual, "Suma incorrecta");
    }
}