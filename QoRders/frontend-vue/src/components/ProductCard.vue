<template>
    <div class="product-card">
        <div class="product-card-container">
            <!-- Imagen -->
            <div class="product-image-container">
                <img :src="product.imageUrl" :alt="product.name" class="product-image" />
            </div>

            <!-- Información del Producto -->
            <div class="product-info">
                <h3>{{ product.name }}</h3>
                <p>{{ product.description }}</p>

                <!-- Cantidad -->
                <div class="quantity">
                    <button @click="adjustQuantity(product, -1)">-</button>
                    <span>{{ product.quantity }}</span>
                    <button @click="adjustQuantity(product, 1)">+</button>
                </div>
            </div>


            <!-- Precio -->
            <div class="price">{{ parseFloat(product.unitPrice).toFixed(2) }}€</div>
        </div>
        <div>
            <!-- Alérgenos Dropdown -->
            <Accordion :activeIndex="null">
                <AccordionPanel value="0">
                    <AccordionHeader>Alérgenos</AccordionHeader>
                    <AccordionContent>
                        <p class="m-0">
                            {{ product.allergens }}
                        </p>
                    </AccordionContent>
                </AccordionPanel>
            </Accordion>
        </div>
    </div>
</template>

<script setup>
import Accordion from 'primevue/accordion';
import AccordionPanel from 'primevue/accordionpanel';
import AccordionHeader from 'primevue/accordionheader';
import AccordionContent from 'primevue/accordioncontent';

const props = defineProps({
    product: Object
});

const emit = defineEmits(['adjustQuantity']);


const adjustQuantity = (product, delta) => {
    emit('adjustQuantity', product, delta);
};
</script>

<style scoped>
.product-card {
    width: 100%;
    background: white;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    padding: 20px;
    display: flex;
    flex-direction: column;
}

.product-card-container {
    display: flex;
    align-items: center;
    justify-content: space-between;
}

.product-image-container {
    width: 50%;
}

.product-image {
    width: 100%;
    height: 150px;
    object-fit: cover;
}

.product-info {
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    padding-left: 10px;
    width: 100%;
}

.product-info h3 {
    font-size: 18px;
    font-weight: bold;
}

.product-info p {
    font-size: 14px;
    color: #555;
}

.quantity {
    display: flex;
    align-items: center;
}

.quantity button {
    padding: 5px;
    font-size: 16px;
    background-color: #f8f9fa;
    border: 1px solid #ccc;
    border-radius: 4px;
}

.quantity span {
    margin: 0 10px;
    font-size: 16px;
}

.price {
    font-size: 16px;
    font-weight: bold;
    color: #333;
}

.product-card .p-accordion {
    width: 100%;
    margin-top: 10px;
}

.p-accordion .p-accordionheader,
.p-accordion .p-accordioncontent,
.p-accordion .p-accordioncontent-content {
    font-size: 14px;
    padding: 10px;
}

.p-accordion p {
    margin: 0;
}
</style>