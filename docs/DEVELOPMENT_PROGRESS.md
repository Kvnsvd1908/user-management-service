# Avance del proyecto

## Fase 0 — auditoría

Completada. Se revisaron las cinco guías, el repositorio de origen, su historial, arquitectura, dependencias, ramas, pruebas y configuración. El informe inicial está fuera del repositorio en `outputs/AUDITORIA_FASE_0.md` del workspace de Codex.

## Guía 1 — ejecución local

Completada y validada en Windows con JDK 17, Maven Wrapper, Docker Compose, MySQL 8.4 y Mailpit. `mvnw.cmd clean verify` pasó 195 pruebas sin errores ni fallos. La cobertura JaCoCo de líneas fue 642/812 (79 %). El esquema `crud_usuarios.users` existe. Se probó OpenAPI/Swagger, JWT, usuario PENDING/ACTIVE, lectura, actualización y eliminación. El registro público con rol ADMIN responde 400; MEMBER responde 201. Se comprobó que el correo generado escapa HTML y no contiene la contraseña. La contraseña de demostración del administrador solo se siembra en la base local.

## Guía 2 — MySQL en Aiven

En progreso. La primera captura mostraba un servicio **PostgreSQL 18**, incompatible con este proyecto. El usuario ahora creó **MySQL** y confirmó que está en estado `Building`; todavía no se ha confirmado el plan Free ni el estado `Running`. Falta crear `crud_usuarios`, cargar la tabla y validar la conexión y el CRUD remoto. Las instrucciones y la configuración privada están en `docs/AIVEN_SETUP.md`.

## Guía 3 — preparación hasta la mitad acordada

Se revisaron `Dockerfile`, `render.yaml`, rama `main`, puerto configurable y variables de entorno. El Dockerfile ahora ejecuta `mvn clean verify` durante el build. La imagen `users-management-api:guide3-check` se construyó correctamente y ejecutó 195 pruebas sin fallos. El Blueprint mantiene secretos fuera de Git y solicita el host/puerto SMTP en vez de asumir Gmail. Después de completar Aiven, faltan la integración GitHub-Render, despliegue, HTTPS y comprobación de CD. Estos últimos pasos quedan para el compañero.

Render Free bloquea SMTP saliente en los puertos 25, 465 y 587; por ello el envío de correo mediante Gmail SMTP no puede darse por validado allí. La integración REST de Brevo corresponde a la Guía 5.

Referencias: [Render Blueprint](https://render.com/docs/blueprint-spec), [Render Free](https://render.com/docs/free).
