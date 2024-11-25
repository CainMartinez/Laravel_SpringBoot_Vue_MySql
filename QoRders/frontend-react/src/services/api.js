import axios from 'axios';

export const api_spring = axios.create({
    baseURL: import.meta.env.VITE_API_BASE_URL_SPRING,
});

export const api_laravel = axios.create({
    baseURL: import.meta.env.VITE_API_BASE_URL_LARAVEL,
});