<template>
    <h1>Gestión de la Carta</h1>
    <Tabs :value="rooms[0].room_id" scrollable @click="changeRoom($event)">
        <TabList>
            <Tab v-for="room in rooms" :key="room.room_id" :value="room.room_id">
                {{ room.room_name }}
            </Tab>
        </TabList>
        <TabPanels>
            <TabPanel v-for="room in rooms" :key="room.room_id" :value="room.room_id">
                <DataTable :value="productosByRoom">
                    <Column field="product_name" header="Nombre"></Column>
                    <Column field="description" header="Descripcion"></Column>
                    <Column field="product_type" header="Tipo"></Column>
                    <Column field="image_url" header="Imagen">
                        <template #body="slotProps">
                            <img :src="slotProps.data.image_url" alt="Imagen" style="width: 100px" />
                        </template>
                    </Column>
                    <Column field="unit_price" header="Precio"></Column>
                    <Column field="stock" header="Stock"></Column>
                    <Column field="actions" header="Editar">
                        <template #body="slotProps">
                            <Button icon="pi pi-pencil" class="p-button-rounded p-button-success"
                                @click="editProduct(slotProps.data)" />
                        </template>
                    </Column>
                </DataTable>
            </TabPanel>
        </TabPanels>
    </Tabs>

    <Dialog v-model:visible="modalProductoVisible" modal header="Edit Producto" :style="{ width: '50vw' }"
        :breakpoints="{ '1199px': '75vw', '575px': '90vw' }">
        <div class="modal-content">
            <FloatLabel class="w-full">
                <InputText id="name" v-model="producToEdit.product_name" class="w-full" />
                <label for="name">Nombre</label>
            </FloatLabel>
            <FloatLabel class="w-full">
                <InputText id="descripcion" v-model="producToEdit.description" class="w-full" />
                <label for="descripcion">Descripcion</label>
            </FloatLabel>
            <FloatLabel class="w-full">
                <InputText id="type" v-model="producToEdit.product_type" class="w-full" />
                <label for="type">Tipo</label>
            </FloatLabel>
            <FloatLabel class="w-full">
                <InputNumber id="price" v-model="producToEdit.unit_price" class="w-full" showButtons :step="1" fluid />
                <label for="price">Precio</label>
            </FloatLabel>
            <FloatLabel class="w-full">
                <InputNumber id="stock" v-model="producToEdit.stock" class="w-full" showButtons :step="1" fluid />
                <label for="stock">Stock</label>
            </FloatLabel>
            <FloatLabel class="w-full">
                <InputText id="img" v-model="producToEdit.image_url" class="w-full" />
                <label for="img">Imagen</label>
            </FloatLabel>
            <div class="modal-footer">
                <button class="p-button p-button-rounded p-button-text"
                    @click="modalRoomVisible = false">Cancelar</button>
                <button class="p-button p-button-rounded p-button-success" @click="saveProduct()">Guardar</button>
            </div>
        </div>
    </Dialog>
</template>
<script setup>
import { ref, computed, watch, reactive } from 'vue';
import { useStore } from 'vuex';
const store = useStore();

const rooms = computed(() => store.getters['storeAdmin/getAllRooms'].data);
const products = computed(() => store.getters['storeAdmin/getAllProducts'].data);
console.log("Products");
console.log(products.value);
console.log("Rooms");
console.log(rooms.value);
const roomSelected = ref(1);
const productosByRoom = computed(() => {
    return products.value.filter(p => p.origin == rooms.value.find(r => r.room_id == roomSelected.value).theme);
});

const changeRoom = (event) => {
    roomSelected.value = parseInt(event.target.id.split(``)[event.target.id.length - 1]);
}

const producToEdit = ref(null);
const editProduct = (product) => {
    producToEdit.value = product;
    modalProductoVisible.value = true;
}

const modalProductoVisible = ref(false);

const saveProduct = () => {
    modalProductoVisible.value = false;
}

</script>
<style scoped>
.modal-content {
    display: flex;
    flex-direction: column;
    gap: 25px;
    margin-top: 25px;
    width: 100%;
}

.w-full {
    width: 100%;
}

.w-half {
    width: 50%;
}

.addButton {
    background-color: #0066ff;
}

.addButton:hover {
    background-color: #003e9b;
}

.header {
    display: flex;
    justify-content: space-between;
    align-items: end;
    margin-bottom: 20px;
}

.modal-footer {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
}
</style>