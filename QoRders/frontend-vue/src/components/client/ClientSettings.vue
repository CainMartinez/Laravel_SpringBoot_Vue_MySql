<template>
    <div class="recipe-book">
        <div class="book-cover">
            <div class="book-title">
                <h2>Libro de Recetas Personal</h2>
                <div class="book-subtitle">Ingredientes para una experiencia perfecta</div>
                <div class="utensil-decoration">🍴</div>
            </div>

            <form @submit.prevent="handleSubmit" class="recipe-form">
                <div class="recipe-section">
                    <div class="section-header">
                        <div class="utensil-icon">👨‍🍳</div>
                        <h3>Sobre el Chef</h3>
                    </div>
                    
                    <div class="ingredient-group">
                        <div class="ingredient-row">
                            <div class="form-group">
                                <label for="firstName">Nombre</label>
                                <input type="text" id="firstName" v-model="form.firstName" placeholder="Tu nombre" />
                            </div>

                            <div class="form-group">
                                <label for="lastName">Apellido</label>
                                <input type="text" id="lastName" v-model="form.lastName" placeholder="Tu apellido" />
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" v-model="form.email" placeholder="Email" disabled />
                            <small class="recipe-note">*Este ingrediente no se puede modificar</small>
                        </div>

                        <div class="ingredient-row">
                            <div class="form-group">
                                <label for="age">Edad</label>
                                <input type="number" id="age" v-model="form.age" placeholder="Años de experiencia" />
                            </div>

                            <div class="form-group">
                                <label for="address">Dirección</label>
                                <input type="text" id="address" v-model="form.address" placeholder="Tu cocina personal" />
                            </div>
                        </div>
                    </div>
                </div>

                <div class="recipe-section">
                    <div class="section-header">
                        <div class="utensil-icon">🍽️</div>
                        <h3>Detalles de Sabor</h3>
                    </div>
                    
                    <div class="form-group">
                        <label for="avatar_url">Foto para el Recetario</label>
                        <input type="text" id="avatar_url" v-model="form.avatarUrl" placeholder="URL de tu foto de perfil" />
                    </div>

                    <div class="form-group">
                        <label for="bio">Notas Personales</label>
                        <textarea id="bio" v-model="form.bio" placeholder="Tus preferencias culinarias y gustos..." />
                    </div>
                </div>

                <div class="recipe-actions">
                    <button type="submit" class="btn-submit">
                        <span class="btn-icon">📝</span>
                        Guardar en el Recetario
                    </button>
                </div>
            </form>
        </div>
        
        <div class="book-binding"></div>
        <div class="book-pages"></div>
    </div>
    <Modal v-model:visible="isModalVisible" :message="modalMessage" :title="modalTitle" />
</template>

<script setup>
import { ref } from 'vue';
import { useStore } from 'vuex';
import Modal from '../Modal.vue';

const store = useStore();
const isModalVisible = ref(false);
const modalMessage = ref('');
const modalTitle = ref('');

const userData = store.getters['storeAuth/getUserData'].client;

const form = ref({
    firstName: userData.firstName,
    lastName: userData.lastName,
    email: userData.email,
    age: userData.age,
    address: userData.address,
    avatarUrl: userData.avatar_url,
    bio: userData.bio,
});

const handleSubmit = async () => {
    try {
        await store.dispatch('storeAuth/updateUser', form.value);
        modalMessage.value = '¡Receta actualizada correctamente!';
        modalTitle.value = 'Perfecto';
        isModalVisible.value = true;
    } catch (error) {
        modalMessage.value = 'Error al actualizar la receta personal';
        modalTitle.value = '¡Ops!';
        isModalVisible.value = true;
    }
};
</script>

<style scoped>
.recipe-book {
    max-width: 800px;
    margin: 40px auto;
    position: relative;
    perspective: 1500px;
}

.book-cover {
    background-color: #f9f3e9;
    border-radius: 8px 16px 16px 8px;
    box-shadow: 10px 10px 30px rgba(0, 0, 0, 0.2), 
                0 0 8px rgba(0, 0, 0, 0.1) inset;
    padding: 40px;
    position: relative;
    transform-style: preserve-3d;
    transform: rotateY(-3deg);
    z-index: 10;
    background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100"><rect width="100" height="100" fill="%23f9f3e9"/><rect x="0" y="0" width="100" height="100" fill="none" stroke="%23d9c7a3" stroke-width="0.5" stroke-dasharray="2,2"/></svg>');
}

.book-binding {
    position: absolute;
    left: 0;
    top: 0;
    bottom: 0;
    width: 30px;
    background: linear-gradient(to right, #a86832, #d4a76a, #a86832);
    border-radius: 3px 0 0 3px;
    box-shadow: -2px 0 5px rgba(0, 0, 0, 0.2) inset;
    transform-origin: left;
    transform: rotateY(15deg) translateZ(-10px);
    z-index: 5;
}

.book-pages {
    position: absolute;
    left: 28px;
    top: 5px;
    bottom: 5px;
    width: calc(100% - 28px);
    background-color: #fff;
    border-radius: 0 5px 5px 0;
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
    transform-origin: left;
    transform: rotateY(-3deg) translateZ(-20px);
    z-index: 1;
}

.book-title {
    text-align: center;
    margin-bottom: 30px;
    padding-bottom: 20px;
    border-bottom: 2px dashed #d9c7a3;
    position: relative;
}

.book-title h2 {
    font-family: 'Brush Script MT', cursive;
    font-size: 36px;
    margin: 0 0 8px;
    color: #8b4513;
    text-shadow: 1px 1px 0 #f0e6d2;
}

.book-subtitle {
    font-family: 'Georgia', serif;
    font-style: italic;
    color: #a0522d;
    font-size: 16px;
}

.utensil-decoration {
    font-size: 24px;
    margin: 10px 0;
}

.recipe-form {
    font-family: 'Georgia', serif;
}

.recipe-section {
    background-color: rgba(255, 255, 255, 0.6);
    border: 1px solid #e0d3b8;
    border-radius: 8px;
    padding: 25px;
    margin-bottom: 25px;
    box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
}

.section-header {
    display: flex;
    align-items: center;
    margin-bottom: 20px;
    border-bottom: 1px solid #e0d3b8;
    padding-bottom: 10px;
}

.utensil-icon {
    font-size: 24px;
    margin-right: 15px;
}

.section-header h3 {
    font-family: 'Georgia', serif;
    font-size: 20px;
    color: #8b4513;
    margin: 0;
}

.ingredient-group {
    padding: 0 10px;
}

.ingredient-row {
    display: flex;
    gap: 20px;
    margin-bottom: 15px;
}

.form-group {
    margin-bottom: 20px;
    flex: 1;
}

.form-group label {
    display: block;
    font-weight: bold;
    margin-bottom: 8px;
    color: #8b4513;
    font-size: 15px;
}

.form-group input,
.form-group textarea {
    width: 100%;
    padding: 12px;
    border: 1px solid #d9c7a3;
    border-radius: 6px;
    font-size: 15px;
    background-color: #fffcf5;
    color: #5a3921;
    font-family: 'Georgia', serif;
    transition: all 0.3s ease;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05) inset;
}

.form-group input:focus,
.form-group textarea:focus {
    outline: none;
    border-color: #a86832;
    box-shadow: 0 0 8px rgba(168, 104, 50, 0.2);
}

.form-group input:disabled {
    background-color: #f0e6d2;
    cursor: not-allowed;
}

.form-group textarea {
    min-height: 120px;
    resize: vertical;
}

.recipe-note {
    display: block;
    margin-top: 5px;
    font-style: italic;
    color: #a0522d;
    font-size: 12px;
}

.recipe-actions {
    text-align: center;
    margin-top: 30px;
}

.btn-submit {
    background-color: #8b4513;
    color: #fff;
    border: none;
    padding: 12px 25px;
    font-size: 16px;
    font-family: 'Georgia', serif;
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.3s ease;
    display: inline-flex;
    align-items: center;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.btn-submit:hover {
    background-color: #a0522d;
    transform: translateY(-2px);
    box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
}

.btn-icon {
    margin-right: 10px;
    font-size: 18px;
}

/* Responsive */
@media (max-width: 768px) {
    .book-cover {
        padding: 25px;
        transform: none;
    }
    
    .book-binding, .book-pages {
        display: none;
    }
    
    .ingredient-row {
        flex-direction: column;
        gap: 0;
    }
    
    .book-title h2 {
        font-size: 28px;
    }
}
</style>