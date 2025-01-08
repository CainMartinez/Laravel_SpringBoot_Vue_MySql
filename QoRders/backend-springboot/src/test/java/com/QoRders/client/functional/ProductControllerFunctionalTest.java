// package com.QoRders.client.functional;

// import com.QoRders.client.auth.api.security.ratelimit.RateLimitConfig;
// import com.QoRders.client.auth.api.security.ratelimit.RateLimitFilter;
// import com.QoRders.client.infra.config.TestSecurityConfig;
// import com.QoRders.client.shop.api.controller.ProductController;
// import com.QoRders.client.shop.api.dto.ProductDto;
// import com.QoRders.client.shop.domain.service.ProductService;

// import org.junit.jupiter.api.Test;
// import org.mockito.Mockito;
// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
// import org.springframework.boot.test.mock.mockito.MockBean;
// import org.springframework.context.annotation.Import;
// import org.springframework.data.domain.Page;
// import org.springframework.data.domain.PageImpl;
// import org.springframework.data.domain.PageRequest;
// import org.springframework.data.domain.Pageable;
// import org.springframework.http.MediaType;
// import org.springframework.test.web.servlet.MockMvc;

// import java.math.BigDecimal;
// import java.util.List;

// import static org.mockito.ArgumentMatchers.any;
// import static org.mockito.ArgumentMatchers.eq;
// import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
// import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
// import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

// @WebMvcTest(controllers = ProductController.class)
// @Import(TestSecurityConfig.class)
// public class ProductControllerFunctionalTest {

//         @Autowired
//         private MockMvc mockMvc;

//         @MockBean
//         private ProductService productService;

//         @MockBean
//         private RateLimitConfig rateLimitConfig;

//         @MockBean

//         private RateLimitFilter rateLimitFilter;

//         @Test
//         void testGetProductsByRoom_returnsPagedProducts() throws Exception {
//                 // Configura datos simulados
//                 var mockProducts = List.of(
//                                 createProductDto(1, "Coca Cola", "drink-123", BigDecimal.valueOf(1.5), "image1.jpg",
//                                                 "DRINK", true),
//                                 createProductDto(2, "Pepsi", "drink-124", BigDecimal.valueOf(1.3), "image2.jpg",
//                                                 "DRINK", true));

//                 Pageable pageable = PageRequest.of(0, 2, org.springframework.data.domain.Sort.Direction.DESC,
//                                 "unitPrice");
//                 Page<ProductDto> page = new PageImpl<>(mockProducts, pageable, mockProducts.size());

//                 // Configurar el servicio simulado
//                 Mockito.when(productService.filterProductsBySlugAndType(
//                                 eq("Jardin_de_los_Cerezos_781230"),
//                                 eq("DRINK"),
//                                 any(Pageable.class)))
//                                 .thenReturn(page);

//                 // Ejecutar el endpoint y validar la respuesta
//                 mockMvc.perform(get("/api/products/room/Jardin_de_los_Cerezos_781230")
//                         .param("productType", "DRINK")
//                         .param("order", "desc")
//                         .param("limit", "2")
//                         .param("offset", "0")
//                         .contentType(MediaType.APPLICATION_JSON))
//                 .andExpect(status().isOk())
//                 .andExpect(jsonPath("$.content[0].name").value("Sake"))
//                 .andExpect(jsonPath("$.content[0].unitPrice").value(10.00))
//                 .andExpect(jsonPath("$.content[0].productType").value("DRINK"))
//                 .andExpect(jsonPath("$.content[1].name").value("Shochu"))
//                 .andExpect(jsonPath("$.content[1].unitPrice").value(12.50))
//                 .andExpect(jsonPath("$.content[1].productType").value("DRINK"))
//                 .andExpect(jsonPath("$.content.size()").value(2));
//         }

//         private ProductDto createProductDto(Integer id, String name, String slug, BigDecimal unitPrice, String imageUrl,
//                         String productType, Boolean isActive) {
//                 ProductDto response = new ProductDto();
//                 response.setProductId(id);
//                 response.setUuid("uuid-" + id);
//                 response.setName(name);
//                 response.setSlug(slug);
//                 response.setDescription(name + " Description");
//                 response.setUnitPrice(unitPrice);
//                 response.setAllergens("None");
//                 response.setStock(100);
//                 response.setImageUrl(imageUrl);
//                 response.setProductType(productType);
//                 response.setOrigin("Local");
//                 response.setIsActive(isActive);
//                 return response;
//         }
// }