import axios from 'axios';

const api = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3001',
  headers: {
    'Content-Type': 'application/json',
  },
});

// Interceptor for adding token
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('accessToken');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Auth APIs
export const register = (data: any) => api.post('/auth/register', data);
export const login = (data: any) => api.post('/auth/login', data);
export const refreshToken = (data: any) => api.post('/auth/refresh', data);

// Request APIs
export const getRequests = () => api.get('/requests');
export const createRequest = (data: any) => api.post('/requests', data);
export const getRequestById = (id: string) => api.get(`/requests/${id}`);

// Admin APIs
export const getAdminStats = () => api.get('/admin/stats');
export const getAdminUsers = () => api.get('/admin/users');
export const getAdminRequests = () => api.get('/admin/requests');
export const updateRequestStatus = (id: string, status: string) => 
  api.put(`/admin/requests/${id}/status`, { status });

export default api;
