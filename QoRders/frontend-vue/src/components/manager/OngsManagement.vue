<template>
    <div class="header">
        <h1>Gestión de Ongs</h1>
        <Button icon="pi pi-plus" class="p-button-rounded addButton" @click="crearOng" style="margin-bottom: 20px" />
    </div>
    <DataTable :value="ongs">
        <Column field="logo" header="Logo">
            <template #body="slotProps">
                <img :src="slotProps.data.logo_url" alt="Imagen" style="width: 100px" />
            </template>
        </Column>
        <Column field="ngo_name" header="Nombre" />
        <!--<Column field="description" header="Descripcion" />-->
        <Column field="country" header="Tema" />
        <Column header="Imagen">
            <template #body="slotProps">
                <img :src="slotProps.data.description_img_url" alt="Imagen" style="width: 100px" />
            </template>
        </Column>
        <Column field="is_active" header="Estado">
            <template #body="slotProps">
                <ToggleButton v-model="slotProps.data.is_active" onLabel="Activo" offLabel="Inactivo"
                    @change="changeOng(slotProps.data)" />
            </template>
        </Column>
        <Column field="phone_number" header="Telefono" />
        <Column field="total_donations" header="Donaciones" />
        <Column field="website_url" header="Url" />
        <Column field="actions" header="Editar">
            <template #body="slotProps">
                <Button icon="pi pi-pencil" class="p-button-rounded p-button-success"
                    @click="editOng(slotProps.data)" />
            </template>
        </Column>
    </DataTable>
    <Dialog v-model:visible="modalOngVisible" modal header="Edit Ong" :style="{ width: '50vw' }"
        :breakpoints="{ '1199px': '75vw', '575px': '90vw' }">
        <div class="modal-content">

        </div>
        <div class="modal-footer">
            <button class="p-button p-button-rounded p-button-text" @click="modalRoomVisible = false">Cancelar</button>
            <button class="p-button p-button-rounded p-button-success" @click="guardarSala()">Guardar</button>
        </div>
    </Dialog>
</template>
<script setup>
import Column from 'primevue/column';
import InputNumber from 'primevue/inputnumber';
import InputText from 'primevue/inputtext';
import { ref, computed } from 'vue';
import { useStore } from 'vuex';

const store = useStore();

const ongs = computed(() => store.getters['storeAdmin/getAllNgos'].data);

console.log("Ongs" + ongs.value);
console.log(ongs.value)

const editOng = (ong) => {
    ongToEdit.value = ong;
    modalOngVisible.value = true;
}

const modalOngVisible = ref(false);

const ongToEdit = ref(null);

const crearOng = () => {
    ongToEdit.value = null;
    modalOngVisible.value = true;
}

const saveOng = () => {
    if (ongToEdit.value.ngo_id) {
        store.dispatch('storeAdmin/updateOng', ongToEdit.value);
    } else {
        store.dispatch('storeAdmin/createOng', ongToEdit.value);
    }
    modalOngVisible.value = false;
}

const changeOng = (ong) => {
    ong.is_active = ong.is_active ? 1 : 0;
    if (ong.is_active) {
        store.dispatch('storeAdmin/enableOng', ong.ong_slug);
    } else {
        store.dispatch('storeAdmin/disableOng', ong.ong_slug);
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