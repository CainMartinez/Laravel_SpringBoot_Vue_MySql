<template>
    <div class="header">
        <h1>Gestión de Ongs</h1>
        <Button icon="pi pi-plus" class="p-button-rounded addButton" @click="crearOng" style="margin-bottom: 20px" />
    </div>
    <DataTable :value="ongs">
        <Column field="logo" header="Logo">
            <template #body="slotProps">
                <a :href="slotProps.data.website_url" _blank>
                    <img :src="slotProps.data.logo_url" alt="Imagen" style="width: 100px" />
                </a>
            </template>
        </Column>
        <Column field="ngo_name" header="Nombre" />
        <Column field="country" header="Tema" />
        <Column header="Imagen">
            <template #body="slotProps">
                <img :src="slotProps.data.image_url" alt="Imagen" style="width: 100px" />
            </template>
        </Column>
        <Column header="Imagen Descripcion">
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
            <FloatLabel class="w-full">
                <InputText id="name" v-model="ongToEdit.ngo_name" class="w-full" />
                <label for="name">Nombre</label>
            </FloatLabel>
            <FloatLabel class="w-full">
                <Textarea id="name" v-model="ongToEdit.description" class="w-full" />
                <label for="name">Descripcion</label>
            </FloatLabel>
            <FloatLabel class="w-full">
                <InputText id="name" v-model="ongToEdit.country" class="w-full" />
                <label for="name">Pais</label>
            </FloatLabel>
            <FloatLabel class="w-full">
                <InputText id="name" v-model="ongToEdit.email" class="w-full" />
                <label for="name">Email contacto</label>
            </FloatLabel>
            <FloatLabel class="w-full">
                <InputText id="name" v-model="ongToEdit.phone_number" class="w-full" />
                <label for="name">Numero Telefono</label>
            </FloatLabel>
            <FloatLabel class="w-full">
                <InputText id="name" v-model="ongToEdit.logo_url" class="w-full" />
                <label for="name">Logo</label>
            </FloatLabel>
            <FloatLabel class="w-full">
                <InputText id="name" v-model="ongToEdit.image_url" class="w-full" />
                <label for="name">Imagen Principal</label>
            </FloatLabel>
            <FloatLabel class="w-full">
                <InputText id="name" v-model="ongToEdit.description_img_url" class="w-full" />
                <label for="name">Imagen Descripcion</label>
            </FloatLabel>
            <FloatLabel class="w-full">
                <InputText id="name" v-model="ongToEdit.website_url" class="w-full" />
                <label for="name">Pagina Web</label>
            </FloatLabel>
        </div>
        <div class="modal-footer">
            <button class="p-button p-button-rounded p-button-text" @click="modalRoomVisible = false">Cancelar</button>
            <button class="p-button p-button-rounded p-button-success" @click="guardarOng()">Guardar</button>
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
    ongToEdit.value = {
        ngo_name: '',
        description: '',
        country: '',
        email: '',
        phone_number: '',
        logo_url: '',
        image_url: '',
        description_img_url: '',
        website_url: '',
    };
    modalOngVisible.value = true;
}

const validateOng = () => {
    if (!ongToEdit.value.ngo_name) {
        alert('El nombre de la ONG es requerido');
        return true;
    }
    if (!ongToEdit.value.description) {
        alert('La descripcion de la ONG es requerida');
        return true;
    }
    if (!ongToEdit.value.country) {
        alert('El pais de la ONG es requerido');
        return true;
    }
    if (!ongToEdit.value.email) {
        alert('El email de la ONG es requerido');
        return true;
    }
    if (!ongToEdit.value.phone_number) {
        alert('El numero de telefono de la ONG es requerido');
        return true;
    }
    if (!ongToEdit.value.logo_url) {
        alert('El logo de la ONG es requerido');
        return true;
    }
    if (!ongToEdit.value.image_url) {
        alert('La imagen principal de la ONG es requerida');
        return true;
    }
    if (!ongToEdit.value.website_url) {
        alert('La pagina web de la ONG es requerida');
        return true;
    }
    return false;
}

const guardarOng = () => {
    if (validateOng()) {
        return;
    }
    if (ongToEdit.value.ngo_id) {
        store.dispatch('storeAdmin/updateNgo', ongToEdit.value);
    } else {
        store.dispatch('storeAdmin/fetchCreateNgo', ongToEdit.value);
    }
    modalOngVisible.value = false;
}

const changeOng = (ong) => {
    ong.is_active = ong.is_active ? 1 : 0;
    if (ong.is_active) {
        store.dispatch('storeAdmin/enableNgo', ong.ngo_slug);
    } else {
        store.dispatch('storeAdmin/disableNgo', ong.ngo_slug);
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
    margin-top: 15px;
    display: flex;
    justify-content: flex-end;
    gap: 10px;
}
</style>
