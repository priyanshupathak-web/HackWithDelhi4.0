/**
 * api-client.js - Centralized REST API Client for Kisan Sathi Platform
 * Connects the existing frontend to the Spring Boot backend at http://localhost:8080/api
 */

const API_BASE_URL = (window.location.protocol === 'file:' || (window.location.port !== '8080' && window.location.port !== ''))
    ? 'http://localhost:8080/api'
    : '/api';

class ApiClient {
    constructor() {
        this.baseUrl = API_BASE_URL;
    }

    getToken() {
        return localStorage.getItem('kisan_sathi_jwt') || sessionStorage.getItem('kisan_sathi_jwt');
    }

    setToken(token, remember = true) {
        if (remember) {
            localStorage.setItem('kisan_sathi_jwt', token);
        } else {
            sessionStorage.setItem('kisan_sathi_jwt', token);
        }
    }

    clearToken() {
        localStorage.removeItem('kisan_sathi_jwt');
        sessionStorage.removeItem('kisan_sathi_jwt');
        localStorage.removeItem('currentUser');
        sessionStorage.removeItem('currentUser');
        sessionStorage.removeItem('isLockedIn');
    }

    getCurrentUser() {
        try {
            const userStr = localStorage.getItem('currentUser') || sessionStorage.getItem('currentUser');
            return userStr ? JSON.parse(userStr) : null;
        } catch (e) {
            return null;
        }
    }

    setCurrentUser(user, remember = true) {
        const userStr = JSON.stringify(user);
        if (remember) {
            localStorage.setItem('currentUser', userStr);
        } else {
            sessionStorage.setItem('currentUser', userStr);
        }
    }

    async request(endpoint, options = {}) {
        const url = `${this.baseUrl}${endpoint}`;
        const headers = {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            ...(options.headers || {})
        };

        const token = this.getToken();
        if (token && !headers['Authorization']) {
            headers['Authorization'] = `Bearer ${token}`;
        }

        const config = {
            ...options,
            headers
        };

        try {
            const response = await fetch(url, config);
            const isJson = response.headers.get('content-type')?.includes('application/json');
            const data = isJson ? await response.json() : await response.text();

            if (!response.ok) {
                if (response.status === 401) {
                    console.warn('Session expired or unauthorized. Clearing credentials.');
                }
                const errorMessage = (data && data.message) || response.statusText || 'API Request Failed';
                const error = new Error(errorMessage);
                error.status = response.status;
                error.data = data;
                throw error;
            }

            return data;
        } catch (error) {
            console.error(`API Error on [${options.method || 'GET'} ${endpoint}]:`, error);
            throw error;
        }
    }

    // -------------------------------------------------------------
    // Authentication Endpoints
    // -------------------------------------------------------------
    auth = {
        login: async (email, password, remember = true) => {
            const response = await this.request('/auth/login', {
                method: 'POST',
                body: JSON.stringify({ email, password })
            });
            if (response && response.token) {
                this.setToken(response.token, remember);
                this.setCurrentUser(response.farmer, remember);
            }
            return response;
        },

        register: async (registerData) => {
            const response = await this.request('/auth/register', {
                method: 'POST',
                body: JSON.stringify(registerData)
            });
            if (response && response.token) {
                this.setToken(response.token, true);
                this.setCurrentUser(response.farmer, true);
            }
            return response;
        },

        getMe: async () => {
            const farmer = await this.request('/auth/me');
            if (farmer) {
                this.setCurrentUser(farmer);
            }
            return farmer;
        },

        logout: () => {
            this.clearToken();
        }
    };

    // -------------------------------------------------------------
    // Crop Advisory Endpoints
    // -------------------------------------------------------------
    advisory = {
        recommend: async (formData) => {
            return await this.request('/advisory/recommend', {
                method: 'POST',
                body: JSON.stringify(formData)
            });
        },

        getMyHistory: async () => {
            return await this.request('/advisory/my-history');
        }
    };

    // -------------------------------------------------------------
    // Crops & Calendar Endpoints
    // -------------------------------------------------------------
    crops = {
        getAll: async (season = '', category = '') => {
            const params = new URLSearchParams();
            if (season) params.append('season', season);
            if (category) params.append('category', category);
            const query = params.toString() ? `?${params.toString()}` : '';
            return await this.request(`/crops${query}`);
        },

        getById: async (id) => {
            return await this.request(`/crops/${id}`);
        }
    };

    calendar = {
        getAll: async () => {
            return await this.request('/calendar');
        },

        getByMonth: async (monthName) => {
            return await this.request(`/calendar/${encodeURIComponent(monthName)}`);
        }
    };

    // -------------------------------------------------------------
    // Weather Intelligence Endpoints
    // -------------------------------------------------------------
    weather = {
        getCurrent: async (location = 'Delhi') => {
            const dto = await this.request(`/weather/current?location=${encodeURIComponent(location)}`);
            // Format to seamlessly match both DTO format and original WeatherAPI structure
            return {
                ...dto,
                location: {
                    name: dto.locationName || location,
                    region: dto.region || '',
                    country: dto.country || 'India'
                },
                current: {
                    temp_c: dto.tempC,
                    feelslike_c: dto.feelsLikeC,
                    humidity: dto.humidity,
                    wind_kph: dto.windKph,
                    wind_dir: dto.windDir,
                    precip_mm: dto.precipMm,
                    pressure_mb: dto.pressureMb,
                    uv: dto.uv,
                    vis_km: dto.visibilityKm,
                    air_quality: {
                        'us-epa-index': dto.airQualityIndex
                    }
                }
            };
        }
    };

    // -------------------------------------------------------------
    // Farmer Helpdesk Queries Endpoints
    // -------------------------------------------------------------
    queries = {
        submit: async (queryData) => {
            return await this.request('/queries', {
                method: 'POST',
                body: JSON.stringify(queryData)
            });
        },

        getMyQueries: async () => {
            return await this.request('/queries/my-queries');
        }
    };

    // -------------------------------------------------------------
    // Kisan Sathi AI Chatbot Endpoints
    // -------------------------------------------------------------
    chat = {
        sendMessage: async (sessionUuid, message) => {
            return await this.request('/chat/message', {
                method: 'POST',
                body: JSON.stringify({ sessionUuid, message })
            });
        },

        getHistory: async (sessionUuid) => {
            return await this.request(`/chat/history/${encodeURIComponent(sessionUuid)}`);
        }
    };
}

// Global singleton instance for frontend scripts
window.apiClient = new ApiClient();
console.log('🌾 Kisan Sathi ApiClient initialized [Backend URL: ' + API_BASE_URL + ']');
