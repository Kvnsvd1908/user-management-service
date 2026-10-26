# Guía 2: MySQL remoto en Aiven

El proyecto utiliza MySQL Connector/J y SQL específico de MySQL (`ENUM`, `ON UPDATE CURRENT_TIMESTAMP`). Un servicio PostgreSQL no sirve para esta etapa.

1. En Aiven, abre tu proyecto y ve a **Services → Create service → MySQL → Free → Create service**. Comprueba que el resumen indique **Free ($0/mes)** antes de confirmar. Espera al estado **Running**.
2. En el servicio MySQL, abre **Connect → Databases → Create database** y crea `crud_usuarios`.
3. En **Overview → Connection information**, localiza host, puerto, usuario y contraseña. No pegues la contraseña en chats, capturas, tickets ni archivos versionados. En un cliente como MySQL Workbench usa esos valores y descarga el certificado CA de Aiven para la configuración SSL del cliente.
4. Crea la carpeta privada `.environments` dentro del repositorio y el archivo `.environments/aiven.env` con este formato. Está excluido por `.gitignore` y `.dockerignore`:

   ```dotenv
   DB_HOST=host-del-servicio-mysql
   DB_PORT=puerto-del-servicio-mysql
   DB_NAME=crud_usuarios
   DB_USERNAME=usuario-del-servicio
   DB_PASSWORD=clave-privada-del-servicio
   DB_SSL_MODE=REQUIRED
   ```

5. En Workbench, selecciona `crud_usuarios` y ejecuta únicamente el bloque `CREATE TABLE IF NOT EXISTS users` de `src/main/resources/schema.sql`. La base ya se creó en Aiven; no hace falta repetir `CREATE DATABASE`/`USE`. Comprueba `SHOW TABLES` y `DESCRIBE users`.
6. Con JDK 17 activo, inicia la API desde PowerShell con `./scripts/Start-Aiven.ps1`. Usa `http://127.0.0.1:8080/swagger-ui/index.html` y `docs/API_TESTING.http` para verificar los endpoints. El correo de desarrollo llega a Mailpit en `http://127.0.0.1:8025`.
7. Para volver a MySQL local, detén la API con Ctrl+C y ejecuta `./scripts/Start-Local.ps1`. El volumen local de Docker se conserva.

`REQUIRED` cifra la conexión, pero no verifica la identidad del servidor. Para `VERIFY_CA`/`VERIFY_IDENTITY` hay que importar la CA de Aiven en un truststore Java y configurar el driver; no cambies el modo a `DISABLED` para resolver un error remoto.

El esquema remoto no crea un administrador con contraseña conocida. La cuenta de demostración `admin@example.com` existe solo en el seed local. Antes de probar operaciones administrativas remotas, se debe definir un procedimiento de aprovisionamiento privado y auditable; no promuevas usuarios públicos a ADMIN mediante el endpoint de registro.

**Estado actual:** pendiente de servicio Aiven MySQL Free en `Running`, credenciales locales privadas, tabla remota y pruebas de integración. No se ha probado conectividad remota todavía.

Referencias: [MySQL Free](https://aiven.io/docs/products/mysql/concepts/mysql-free-tier), [crear un servicio](https://aiven.io/docs/products/mysql/get-started), [crear base de datos](https://aiven.io/docs/products/mysql/howto/create-database), [Workbench](https://aiven.io/docs/products/mysql/howto/connect-from-mysql-workbench), [TLS/SSL](https://aiven.io/docs/platform/concepts/tls-ssl-certificates).
