import axios from 'axios';
import dotenv from 'dotenv';

dotenv.config();

const axiosInstance = axios.create({
    baseURL: `https://api.ultramsg.com/${process.env.ULTRAMSG_INSTANCE_ID}`,
    params: {
        token: process.env.ULTRAMSG_TOKEN,
    },
});

export default axiosInstance;