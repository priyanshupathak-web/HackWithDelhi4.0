# 🌾 Kisan Sathi (AgriTech Solutions) — Backend Platform

> **Smart India Hackathon (SIH) Full-Stack Project**  
> **Backend Architecture:** Spring Boot 3.3.4, Java 17/21, Spring Data JPA, Spring Security (JWT), MySQL / H2  
> **Frontend Integration:** AgriTech Solutions HTML5, CSS3, ES6 JavaScript  

---

## 1. Project Overview

**Kisan Sathi** is an enterprise-ready agricultural decision support system designed to assist Indian farmers with:
1. **Secure Farmer Authentication:** BCrypt encrypted passwords, JWT stateless session tokens, and personal farm profile management.
2. **Smart Crop Advisory Engine:** Algorithmic recommendation system considering soil types, agro-climatic zones, seasonal cycles (Kharif, Rabi, Zaid), water availability, and historical rotation.
3. **12-Month Agricultural Calendar:** Comprehensive monthly guide detailing temperatures, rainfall, sowing methods, farm operations, and seasonal crop risks.
4. **Live Weather Intelligence & Agro-Advisories:** Real-time localized weather data with dynamic farming advisories (irrigation, spraying precautions, frost prevention).
5. **Farmer Helpdesk Ticketing System:** Query submission and agronomist response tracking.
6. **AI Chatbot Assistant:** Kisan Sathi bilingual conversational agent with secure backend proxying and resilient agricultural knowledge fallback.

---

## 2. Architecture & Layering

The backend follows the clean 4-tier enterprise design pattern:

```
[Browser / Frontend Client]
        │
        ▼ (HTTP REST + JSON + JWT Bearer Token)
[Controller Layer]       (@RestController, @Valid, Swagger OpenAPI Documentation)
        │
        ▼ (DTOs / Business Objects)
[Service Layer]          (Business logic: Advisory matching, BCrypt hashing, Weather, Chatbot)
        │
        ▼ (Entity instances)
[Repository Layer]       (Spring Data JPA Repositories, Custom JPQL Queries)
        │
        ▼ (JDBC Driver)
[Database Layer]         (MySQL 8.0 `kisan_sathi_db` / Dev Persistent Database)
```

### Key Packages in `src/main/java/com/kisansathi/`

- **`config/`**: `SecurityConfig` (CORS, CSRF, Route Filters), `OpenApiConfig` (Swagger UI), `RestTemplateConfig`.
- **`controller/`**: `AuthController`, `FarmerController`, `CropController`, `CalendarController`, `AdvisoryController`, `QueryController`, `WeatherController`, `ChatController`.
- **`dto/`**: Data Transfer Objects for decoupled, secure request/response payloads without entity exposure.
- **`entity/`**: JPA Entities mapped to database tables (`Farmer`, `Crop`, `CropCalendar`, `AdvisoryRequest`, `FarmerQuery`, `ChatSession`, `ChatMessage`).
- **`exception/`**: Centralized `GlobalExceptionHandler` and custom error response formats (`ErrorDetails`).
- **`repository/`**: Spring Data JPA interfaces with derived and custom `@Query` methods.
- **`security/`**: JWT Token Provider, JWT Auth Filter, `CustomUserDetailsService`, and `UserPrincipal`.
- **`service/`**: Core agricultural business logic, external API integrations, and rule engines.
- **`data/`**: `DatabaseDataSeeder` automatically seeding 20+ crops, 12 calendar months, and demo farmer accounts.

---

## 3. Database Design & Tables

A clean, normalized database structure:

1. **`farmers`**: Farmer demographic data, farm size, location, crop preferences, and hashed passwords.
2. **`crops`**: Preserves agronomic characteristics, yield potential, duration, water requirements, price, and sowing/harvesting periods.
3. **`crop_calendars`**: Month-by-month agricultural guides (January to December).
4. **`advisory_requests`**: History of crop recommendations requested by farmers.
5. **`farmer_queries`**: Farmer inquiries, issue categories, status (`PENDING`, `RESOLVED`), and official responses.
6. **`chat_sessions` & `chat_messages`**: Chat conversation persistence for the AI chatbot.

A full SQL creation script is available at `src/main/resources/schema.sql`.

---

## 4. Quick Start & Execution

### Option A: Using the 1-Click Batch File (Recommended)
Double-click `run-backend.bat` in the `fp/` folder.  
It will automatically verify Java, compile the project, and start the backend on `http://localhost:8080`.

### Option B: Using PowerShell
```powershell
.\start-backend.ps1
```

### Option C: Using Maven Directly
```powershell
# Run with persistent dev profile (MySQL-compatible H2 mode):
mvn spring-boot:run "-Dspring-boot.run.profiles=dev"

# Or run with your local MySQL 8.0 server:
$env:DB_USERNAME = "root"
$env:DB_PASSWORD = "your_mysql_password"
mvn spring-boot:run
```

---

## 5. API Documentation & Interactive Testing

Once the backend is running, open your web browser:

- **Swagger UI Interactive Docs:** [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html)
- **OpenAPI JSON Spec:** [http://localhost:8080/v3/api-docs](http://localhost:8080/v3/api-docs)
- **Database Console:** [http://localhost:8080/h2-console](http://localhost:8080/h2-console) (JDBC URL: `jdbc:h2:file:./data/kisan_sathi_db`, User: `sa`, Password: *blank*)

### Pre-Seeded Demo Credentials

| Role | Email | Password | Purpose |
| :--- | :--- | :--- | :--- |
| **Demo Farmer** | `testuser@gmail.com` | `12345` | Matches existing frontend lock-screen and login tab |
| **Admin Agronomist** | `admin@kisansathi.com` | `admin123` | Demonstrates administrative query management |

---

## 6. How the Frontend Connects to the Backend

The frontend in `Agritech solutions/` has been upgraded with `api-client.js`:
- **Real JWT Authentication:** The forced lock overlay and Farmer Account tab call `POST /api/auth/login` and `POST /api/auth/register`.
- **Smart Crop Advisory:** The form in `ksp/index.html` submits directly to `POST /api/advisory/recommend` and renders ranked crop recommendations with agronomic tips.
- **Weather Intelligence:** `app.js` fetches live weather and farming advice via `GET /api/weather/current?location=...`.
- **Farmer Query Form:** Inquiries are posted to `POST /api/queries` and saved to the database.
- **Kisan Sathi Chatbot:** Messages flow through `POST /api/chat/message`, keeping API keys secure on the server side.

---

## 7. SIH & College Presentation Guide

When demonstrating this project to evaluators:

1. **Highlight Security:** Show that API keys (WeatherAPI, OpenRouter) and database passwords are moved out of browser JavaScript and secured on the Spring Boot server.
2. **Demonstrate JWT Auth:** Log in through the frontend, open Developer Tools (`F12 -> Application -> Local Storage`), and show the `kisan_sathi_jwt` token.
3. **Showcase the Advisory Algorithm:** Open `ksp/index.html`, select **Black Clay** soil, **South India**, planning date in **November** (Rabi season). Show how the Spring Boot service evaluates crop compatibility rules and returns ranked recommendations with cultivation tips.
4. **Display Swagger UI:** Open `http://localhost:8080/swagger-ui.html` to demonstrate your REST API design, validation annotations (`@Valid`, `@NotNull`), and centralized exception handling.
