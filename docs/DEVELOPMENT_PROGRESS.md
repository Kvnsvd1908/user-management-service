# Avance del proyecto

## Fase 0 — auditoría

Completada. Se revisaron las cinco guías, el repositorio de origen, su historial, arquitectura, dependencias, ramas, pruebas y configuración. El informe inicial está fuera del repositorio en `outputs/AUDITORIA_FASE_0.md` del workspace de Codex.

## Guía 1 — ejecución local

Completada y validada en Windows con JDK 17, Maven Wrapper, Docker Compose, MySQL 8.4 y Mailpit. `mvnw.cmd clean verify` pasó 195 pruebas sin errores ni fallos. La cobertura JaCoCo de líneas fue 642/812 (79 %). El esquema `crud_usuarios.users` existe. Se probó OpenAPI/Swagger, JWT, usuario PENDING/ACTIVE, lectura, actualización y eliminación. El registro público con rol ADMIN responde 400; MEMBER responde 201. Se comprobó que el correo generado escapa HTML y no contiene la contraseña. La contraseña de demostración del administrador solo se siembra en la base local.

## Guía 2 — MySQL en Aiven

Validada técnicamente. La primera captura mostró PostgreSQL, incompatible con el proyecto, y luego se creó MySQL Free ($0/mes), según confirmación del usuario. Una captura posterior expuso la clave inicial de `avnadmin`; se restableció antes de desplegar en Render. Se verificó que la nueva clave es distinta y conecta por TLS; permanece únicamente en `.environments/aiven.env`. `scripts/Initialize-Aiven.ps1` confirmó conexión TLS y creó/verificó `crud_usuarios.users` con ocho columnas. La API arrancó con Aiven; Hikari abrió conexión remota. OpenAPI y Swagger dieron 200; un GET protegido sin JWT dio 401. Se probó registro 201, login PENDING 401, activación administrativa, login ADMIN 200 con JWT, listado 200, consulta 200, actualización 200, login ACTIVE 200, eliminación 204 y consulta del eliminado 404. El correo llegó a Mailpit sin contraseña. El usuario temporal fue eliminado. La cuenta ADMIN de prueba permanece para continuar y su clave aleatoria está solo en `.environments/aiven-admin.env` (ignorado por Git).

## Guía 3 — Render y CI/CD

El servicio Docker Free está [Live en Render](https://users-management-api-wxx6.onrender.com) desde `main`. `Dockerfile` ejecuta `mvn clean verify` durante el build y el despliegue pasó 196 pruebas. Render generó `JWT_SECRET` y recibió la contraseña MySQL como variable privada, sin versionarla. Los logs confirman Tomcat en el puerto 10000 y conexión Hikari a Aiven. En la URL pública se comprobaron raíz 401, OpenAPI y Swagger 200, login ADMIN 200 y `GET /api/users` con JWT 200. La configuración está en [RENDER_SETUP.md](RENDER_SETUP.md).

GitHub Actions verifica cada push o pull request a `main`; la ejecución del commit `9a7405b` terminó correctamente. Render usa `autoDeployTrigger: checksPass` para desplegar tras un check verde. Queda comprobar un segundo despliegue automático después de este cambio documental. GitHub aún indica que 2FA no está habilitada; el propietario debe completar el QR/TOTP y guardar los códigos de recuperación en privado.

Render Free bloquea SMTP saliente en los puertos 25, 465 y 587; `NOTIFICATIONS_EMAIL_ENABLED=false` desactiva los intentos allí. La integración REST de Brevo corresponde a la Guía 5.

Referencias: [Render Blueprint](https://render.com/docs/blueprint-spec), [Render Free](https://render.com/docs/free).
