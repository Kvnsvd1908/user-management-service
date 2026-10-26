# Avance del proyecto

## Fase 0 — auditoría

Completada. Se revisaron las cinco guías, el repositorio de origen, su historial, arquitectura, dependencias, ramas, pruebas y configuración. El informe inicial está fuera del repositorio en `outputs/AUDITORIA_FASE_0.md` del workspace de Codex.

## Guía 1 — ejecución local

Completada y validada en Windows con JDK 17, Maven Wrapper, Docker Compose, MySQL 8.4 y Mailpit. `mvnw.cmd clean verify` pasó 195 pruebas sin errores ni fallos. La cobertura JaCoCo de líneas fue 642/812 (79 %). El esquema `crud_usuarios.users` existe. Se probó OpenAPI/Swagger, JWT, usuario PENDING/ACTIVE, lectura, actualización y eliminación. El registro público con rol ADMIN responde 400; MEMBER responde 201. Se comprobó que el correo generado escapa HTML y no contiene la contraseña. La contraseña de demostración del administrador solo se siembra en la base local.

## Guía 2 — MySQL en Aiven

Validada técnicamente. La primera captura mostró PostgreSQL, incompatible con el proyecto, y luego se creó MySQL Free ($0/mes), según confirmación del usuario. Una captura posterior expuso la clave de `avnadmin`; el usuario la restableció y guardó la nueva únicamente en `.environments/aiven.env`. No se usó la clave expuesta. `scripts/Initialize-Aiven.ps1` confirmó conexión TLS y creó/verificó `crud_usuarios.users` con ocho columnas. La API arrancó con Aiven; Hikari abrió conexión remota. OpenAPI y Swagger dieron 200; un GET protegido sin JWT dio 401. Se probó registro 201, login PENDING 401, activación administrativa, login ADMIN 200 con JWT, listado 200, consulta 200, actualización 200, login ACTIVE 200, eliminación 204 y consulta del eliminado 404. El correo llegó a Mailpit sin contraseña. El usuario temporal fue eliminado. La cuenta ADMIN de prueba permanece para continuar y su clave aleatoria está solo en `.environments/aiven-admin.env` (ignorado por Git).

## Guía 3 — preparación hasta la mitad acordada

Se revisaron `Dockerfile`, `render.yaml`, rama `main`, puerto configurable y variables de entorno. El Dockerfile ahora ejecuta `mvn clean verify` durante el build. La imagen `users-management-api:guide3-check` se construyó correctamente y ejecutó 195 pruebas sin fallos. El Blueprint mantiene secretos fuera de Git y solicita el host/puerto SMTP en vez de asumir Gmail. Después de completar Aiven, faltan la integración GitHub-Render, despliegue, HTTPS y comprobación de CD. Estos últimos pasos quedan para el compañero.

Render Free bloquea SMTP saliente en los puertos 25, 465 y 587; por ello el envío de correo mediante Gmail SMTP no puede darse por validado allí. La integración REST de Brevo corresponde a la Guía 5.

Referencias: [Render Blueprint](https://render.com/docs/blueprint-spec), [Render Free](https://render.com/docs/free).
