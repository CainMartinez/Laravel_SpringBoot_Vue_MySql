// package com.QoRders.client.unit.service;

// import com.QoRders.client.booking.domain.entity.BookingEntity;
// import com.QoRders.client.booking.domain.repository.BookingRepository;
// import com.QoRders.client.booking.domain.service.BookingServiceImpl;
// import org.junit.jupiter.api.Test;
// import org.junit.jupiter.api.extension.ExtendWith;
// import org.mockito.InjectMocks;
// import org.mockito.Mock;
// import org.mockito.junit.jupiter.MockitoExtension;

// import static org.junit.jupiter.api.Assertions.*;
// import static org.mockito.ArgumentMatchers.any;
// import static org.mockito.Mockito.*;

// @ExtendWith(MockitoExtension.class)
// public class BookingServiceTest {

//     @InjectMocks
//     private BookingServiceImpl bookingService;

//     @Mock
//     private BookingRepository bookingRepository;

//     @Test
//     void testCreateBooking_success() {
//         // Arrange
//         BookingEntity booking = new BookingEntity();
//         booking.setId(1);
//         booking.setGuestCount(4);
//         when(bookingRepository.save(any(BookingEntity.class))).thenReturn(booking);

//         // Act
//         BookingEntity result = bookingService.createBooking(1, "Test Note");

//         // Assert
//         assertNotNull(result);
//         assertEquals(4, result.getGuestCount());
//         verify(bookingRepository, times(1)).save(any(BookingEntity.class));
//     }
// }