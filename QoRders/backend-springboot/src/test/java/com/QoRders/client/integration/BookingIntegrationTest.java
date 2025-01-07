// package com.QoRders.client.integration;

// import com.QoRders.client.booking.domain.entity.BookingEntity;
// import com.QoRders.client.booking.domain.repository.BookingRepository;
// import org.junit.jupiter.api.Test;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.boot.test.context.SpringBootTest;
// import org.springframework.transaction.annotation.Transactional;

// import static org.junit.jupiter.api.Assertions.*;

// @SpringBootTest
// @Transactional
// public class BookingIntegrationTest {

//     @Autowired
//     private BookingRepository bookingRepository;

//     @Test
//     void testBookingPersistence() {
//         // Arrange
//         BookingEntity booking = new BookingEntity();
//         booking.setGuestCount(3);

//         // Act
//         BookingEntity saved = bookingRepository.save(booking);

//         // Assert
//         assertNotNull(saved.getId());
//         assertEquals(3, saved.getGuestCount());
//     }
// }