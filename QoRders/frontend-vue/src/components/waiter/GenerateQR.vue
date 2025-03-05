<template>
    <div class="generate-qr">
        <h2 class="title">Código QR de la Reserva</h2>
        <div v-if="qrCode" class="qr-container">
            <img :src="qrCode" alt="Código QR" class="qr-image" />
        </div>
        <div v-else class="loading">
            <p>Cargando el QR...</p>
        </div>
        <button class="btn-close" @click="closeQr">Cerrar</button>
    </div>
</template>

<script>
import QRCode from "qrcode";

export default {
    props: {
        url: {
            type: String,
            required: true, // La URL del QR se pasa como prop
        },
    },
    data() {
        return {
            qrCode: null, // Almacena la imagen del QR
        };
    },
    methods: {
        async generateQrCode() {
            try {
                this.qrCode = await QRCode.toDataURL(this.url); // Genera el QR desde la URL
            } catch (error) {
                console.error("Error generando el QR:", error);
            }
        },
        closeQr() {
            this.$emit("close"); // Emite un evento para cerrar el componente
        },
    },
    mounted() {
        this.generateQrCode(); // Genera el QR cuando se monta el componente
    }
};
</script>

<style scoped>
/* Contenedor general */
.generate-qr {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 2rem;
    background-color: white;
    border-radius: 10px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    max-width: 400px;
    margin: 0 auto;
    text-align: center;
    font-family: Arial, sans-serif;
}

/* Título */
.title {
    font-size: 1.5rem;
    font-weight: bold;
    margin-bottom: 1rem;
    color: #000000;
}

/* Contenedor del QR */
.qr-container {
    margin: 1.5rem 0;
    padding: 1rem;
    background-color: #f9f9f9;
    border: 1px solid #ddd;
    border-radius: 10px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.qr-image {
    max-width: 250px;
    max-height: 250px;
    object-fit: contain;
    border-radius: 5px;
    transition: transform 1s;
}
.qr-image:hover {
    transform: scale(1.05);
    transition: 1s;
}
/* Estado de carga */
.loading {
    font-size: 1rem;
    color: #555;
    margin: 1rem 0;
}

/* Botón de cerrar */
.btn-close {
    padding: 0.8rem 1.5rem;
    background-color: #dc3545;
    color: white;
    border: none;
    border-radius: 5px;
    font-size: 1rem;
    font-weight: bold;
    cursor: pointer;
    transition: background-color 0.2s ease, transform 0.2s ease;
}

.btn-close:hover {
    background-color: #bd2130;
    transform: scale(1.05);
}

.btn-close:active {
    transform: scale(0.95);
}

@media (max-width: 768px) {
    .generate-qr {
        padding: 1rem;
        max-width: 90%;
    }

    .qr-image {
        max-width: 200px;
        max-height: 200px;
    }

    .btn-close {
        padding: 0.6rem 1.2rem;
        font-size: 0.9rem;
    }
}
</style>