<template>
    <div class="header">
        <h1>Gestión de Salas</h1>
        <Button icon="pi pi-plus" class="p-button-rounded addButton" @click="crearRoom" style="margin-bottom: 20px" />
    </div>
    <DataTable :value="rooms">
        <Column field="room_name" header="Nombre" />
        <Column field="description" header="Descripcion" />
        <Column field="max_capacity" header="Capacidad" />
        <Column field="theme" header="Tema" />
        <Column header="Imagen">
            <template #body="slotProps">
                <img :src="slotProps.data.image_url" alt="Imagen" style="width: 100px" />
            </template>
        </Column>
        <Column field="is_active" header="Estado">
            <template #body="slotProps">
                <ToggleButton v-model="slotProps.data.is_active" onLabel="Activo" offLabel="Inactivo"
                    @change="changeRoom(slotProps.data)" />
            </template>
        </Column>
        <Column field="actions" header="Editar">
            <template #body="slotProps">
                <Button icon="pi pi-pencil" class="p-button-rounded p-button-success"
                    @click="editRoom(slotProps.data)" />
            </template>
        </Column>
    </DataTable>
    <Dialog v-model:visible="modalRoomVisible" modal header="Edit room" :style="{ width: '50vw' }"
        :breakpoints="{ '1199px': '75vw', '575px': '90vw' }">
        <div class="modal-content">
            <FloatLabel class="w-full">
                <InputText id="name" v-model="roomToEdit.room_name" class="w-full" />
                <label for="name">Nombre</label>
            </FloatLabel>
            <FloatLabel class="w-full">
                <InputText id="descripcion" v-model="roomToEdit.description" class="w-full" />
                <label for="descripcion">Descripcion</label>
            </FloatLabel>
            <FloatLabel class="w-full">
                <InputNumber id="capacidad" v-model="roomToEdit.max_capacity" class="w-full" showButtons :step="1"
                    fluid />
                <label for="capacidad">Numero de personas</label>
            </FloatLabel>
            <FloatLabel class="w-full">
                <InputText id="img" v-model="roomToEdit.image_url" class="w-full" />
                <label for="img">Imagen</label>
            </FloatLabel>
            <FloatLabel class="w-full">
                <Select id="img" v-model="roomToEdit.ngo" :options="ongs" optionLabel="ngo_name" class="w-full" />
                <label for="img">Ong</label>
            </FloatLabel>
            <div class="modal-footer">
                <button class="p-button p-button-rounded p-button-text"
                    @click="modalRoomVisible = false">Cancelar</button>
                <button class="p-button p-button-rounded p-button-success" @click="guardarSala()">Guardar</button>
            </div>
        </div>
    </Dialog>
</template>
<script setup>
import Column from 'primevue/column';
import InputNumber from 'primevue/inputnumber';
import InputText from 'primevue/inputtext';
import Select from 'primevue/select';
import { ref, computed } from 'vue';
import { useStore } from 'vuex';

const store = useStore();

const rooms = computed(() => store.getters['storeAdmin/getAllRooms'].data);
const ongs = computed(() => store.getters['storeAdmin/getAllNgos'].data);
console.log(rooms.value)
console.log(ongs.value)
const editRoom = (room) => {
    roomToEdit.value = room;
    modalRoomVisible.value = true;
}

const modalRoomVisible = ref(false);

const roomToEdit = ref(null);

const crearRoom = () => {
    roomToEdit.value = {
        room_name: '',
        description: '',
        max_capacity: null,
        image_url: '',
        theme: '',
        is_active: false,
        ngo: null,
        ngo_id: 0
    };
    modalRoomVisible.value = true;
}

const guardarSala = () => {
    roomToEdit.value.is_active = roomToEdit.value.is_active ? 1 : 0;
    roomToEdit.value.ngo_id = roomToEdit.value.ngo.ngo_id;
    if (roomToEdit.value.room_id) {
        store.dispatch('storeAdmin/updateRoom', roomToEdit.value);
    } else {
        store.dispatch('storeAdmin/fetchCreateRoom', roomToEdit.value);
    }
    modalRoomVisible.value = false;
}

const changeRoom = (room) => {
    room.is_active = room.is_active ? 1 : 0;
    if (room.is_active) {
        store.dispatch('storeAdmin/enableRoom', room.room_slug);
    } else {
        store.dispatch('storeAdmin/disableRoom', room.room_slug);
    }
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