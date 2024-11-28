import { createApp } from 'vue';
import App from './App.vue';
import router from './router/router';
import store from './store';

//PrimeVue Imports
import PrimeVue from 'primevue/config';

//PrimeVue Themes
import Aura from '@primevue/themes/aura';

//PrimeVue Components
import Button from 'primevue/button';
import Carousel from 'primevue/carousel';
import Paginator from 'primevue/paginator';
import ScrollTop from 'primevue/scrolltop';

//Prime React Components
import 'primereact/resources/themes/lara-light-blue/theme.css';
import 'primereact/resources/primereact.min.css';
import 'primeicons/primeicons.css';


const app = createApp(App);

app.use(router);
app.use(store);

app.use(PrimeVue, {
    theme: {
        preset: Aura
    }
});

app.component('Button', Button);
app.component('Carousel', Carousel);
app.component('Paginator', Paginator);
app.component('ScrollTop', ScrollTop);

app.mount('#app');
