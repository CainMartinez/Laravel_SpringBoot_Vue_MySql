// package com.QoRders.client.functional;

// import com.QoRders.client.booking.api.controller.BookingController;
// import com.QoRders.client.booking.domain.service.BookingService;
// import org.junit.jupiter.api.Test;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
// import org.springframework.boot.test.mock.mockito.MockBean;
// import org.springframework.test.web.servlet.MockMvc;

// import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
// import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
// import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

// @WebMvcTest(BookingController.class)
// public class BookingControllerFunctionalTest {

//     @Autowired
//     private MockMvc mockMvc;

//     @MockBean
//     private BookingService bookingService;

//     @Test
//     void testGetBookings_returnsOk() throws Exception {
//         mockMvc.perform(get("/api/booking"))
//                 .andExpect(status().isOk())
//                 .andExpect(jsonPath("$.size()", org.hamcrest.Matchers.is(0)));
//     }
// }