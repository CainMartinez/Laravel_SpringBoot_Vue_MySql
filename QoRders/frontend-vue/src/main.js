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
import InputText from 'primevue/inputtext';
import Select from 'primevue/select';
import Accordion from 'primevue/accordion';
import AccordionPanel from 'primevue/accordionpanel';
import AccordionContent from 'primevue/accordioncontent';
import AccordionHeader from 'primevue/accordionheader';
import InputNumber from 'primevue/inputnumber';
import Dialog from 'primevue/dialog';
import DatePicker from 'primevue/datepicker';

// PrimeVue Directives
import Tooltip from 'primevue/tooltip';


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
app.component('InputText', InputText);
app.component('Select', Select);
app.component('Accordion', Accordion);
app.component('AccordionPanel', AccordionPanel);
app.component('AccordionContent', AccordionContent);
app.component('AccordionHeader', AccordionHeader);
app.component('InputNumber', InputNumber);
app.component('Dialog', Dialog);
app.component('DatePicker', DatePicker);

app.directive('tooltip', Tooltip);

app.mount('#app');
