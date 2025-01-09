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
import Card from 'primevue/card';
import ProgressSpinner from 'primevue/progressspinner';
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';
import FloatLabel from 'primevue/floatlabel';
import ToggleButton from 'primevue/togglebutton';
import Textarea from 'primevue/textarea';
import Tabs from 'primevue/tabs';
import TabList from 'primevue/tablist';
import Tab from 'primevue/tab';

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
app.component('Card', Card);
app.component('ProgressSpinner', ProgressSpinner);
app.component('DataTable', DataTable);
app.component('Column', Column);
app.component('FloatLabel', FloatLabel);
app.component('ToggleButton', ToggleButton);
app.component('Textarea', Textarea);
app.component('Tabs', Tabs);
app.component('TabList', TabList);
app.component('Tab', Tab);

app.directive('tooltip', Tooltip);

app.mount('#app');
