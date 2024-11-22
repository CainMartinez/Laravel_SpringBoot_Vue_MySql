import axios from 'axios';

export const api_spring = axios.create({
    baseURL: import.meta.env.VITE_URL_SPRING,
});

export const api_laravel = axios.create({
    baseURL: import.meta.env.VITE_URL_LARAVEL,
});
