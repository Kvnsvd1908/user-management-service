# User Management Service

Microservicio REST de gestión de usuarios con Java 17, Spring Boot 3.3, Maven, JDBC/MySQL, Spring Security/JWT y OpenAPI. Sigue una arquitectura hexagonal: dominio y casos de uso separados de los adaptadores HTTP, persistencia y correo.

Basado en [users-management-microservice](https://github.com/arrietajohn/users-management-microservice) de John Carlos Arrieta Arrieta; se conserva el historial original. La API REST es el punto de entrada activo; la CLI antigua permanece inactiva.

## Requisitos

- Windows/PowerShell con JDK 17 configurado en `JAVA_HOME` y Docker Desktop activo.
- Maven Wrapper incluido (`mvnw.cmd`); no hace falta instalar Maven globalmente.
- VS Code con extensiones Java/Spring y REST Client si se quiere usar `docs/API_TESTING.http`.

## Ejecutar en local

1. Copiar `compose.env.example` a `.env` y reemplazar los valores de ejemplo con secretos aleatorios. `JWT_SECRET` debe ser Base64 de al menos 32 bytes. `.env` está ignorado por Git.
2. En PowerShell, desde la raíz del repositorio:

   ```powershell
   .\mvnw.cmd clean verify
   .\scripts\Start-Local.ps1
   ```

3. Abrir [Swagger UI](http://127.0.0.1:8080/swagger-ui/index.html) y [Mailpit](http://127.0.0.1:8025). El esquema `crud_usuarios.users` se inicializa al crear el volumen MySQL. El administrador de demostración se siembra solo en el entorno local; su clave figura en `schema-local-seed.sql` y debe cambiarse antes de compartir una instalación.

Los servicios Docker están vinculados a `127.0.0.1`: MySQL 3306, Mailpit SMTP 1025 y UI 8025. Para detener solo la API, pulsa Ctrl+C. El volumen de MySQL conserva los datos entre reinicios.

## MySQL remoto y despliegue

La [configuración de Aiven](docs/AIVEN_SETUP.md) explica cómo guardar la conexión en `.environments/aiven.env`, inicializar el esquema con `./scripts/Initialize-Aiven.ps1` y ejecutar `./scripts/Start-Aiven.ps1`. La API y el CRUD ya se probaron contra MySQL remoto. Para volver a local, detén la API remota y ejecuta `./scripts/Start-Local.ps1`.

El servicio está desplegado en [Render Free](https://users-management-api-wxx6.onrender.com) desde `main`. [Swagger UI](https://users-management-api-wxx6.onrender.com/swagger-ui/index.html) y la [configuración de Render](docs/RENDER_SETUP.md) explican cómo probarlo. GitHub Actions ejecuta las pruebas en cada push y Render despliega después de que pasen. En Render Free, SMTP saliente por 25/465/587 está bloqueado; `NOTIFICATIONS_EMAIL_ENABLED=false` evita intentos de envío allí. La integración Brevo HTTPS corresponde a la Guía 5.

## API y estructura

Swagger describe los métodos reales; [API_TESTING.http](docs/API_TESTING.http) ofrece peticiones de ejemplo con valores que deben reemplazarse localmente. El registro público admite únicamente el rol MEMBER y crea usuarios PENDING. Los endpoints de consulta/edición requieren JWT y los cambios administrativos exigen ADMIN.

`src/main/java/.../domain` contiene el modelo, `application` los casos de uso y `infrastructure` los adaptadores. `src/main/resources/schema.sql` define la tabla, `compose.yaml` prepara el entorno local, `Dockerfile` construye la imagen y `docs/guias/` conserva los cinco PDF del curso.


