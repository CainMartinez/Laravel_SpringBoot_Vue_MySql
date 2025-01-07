// package com.QoRders.client.e2e;

// import io.restassured.RestAssured;
// import org.junit.jupiter.api.Test;

// import static io.restassured.RestAssured.*;
// import static org.hamcrest.Matchers.*;

// public class BookingE2ETest {

//     @Test
//     void testCreateBookingE2E() {
//         RestAssured.baseURI = "http://localhost:8081";

//         given()
//                 .contentType("application/json")
//                 .body("{\"guestCount\": 4}")
//         .when()
//                 .post("/api/booking")
//         .then()
//                 .statusCode(201)
//                 .body("guestCount", equalTo(4));
//     }
// }