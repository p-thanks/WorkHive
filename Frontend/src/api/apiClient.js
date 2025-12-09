// src/api/apiClient.js
import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_API_URL;

const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
  timeout: 10000, // 10 seconds
});


// Add a request interceptor to include the token in headers
apiClient.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    // FINAL DEBUGGING STEP: Log the token to the console
    console.log('Using token for API request:', token); 
    if (token) {
      config.headers['Authorization'] = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

export default apiClient;
