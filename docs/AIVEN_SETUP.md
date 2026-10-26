# Guía 2: MySQL remoto en Aiven

El proyecto utiliza MySQL Connector/J y SQL específico de MySQL (`ENUM`, `ON UPDATE CURRENT_TIMESTAMP`). Un servicio PostgreSQL no sirve para esta etapa.

1. En Aiven, abre tu proyecto y ve a **Services → Create service → MySQL → Free → Create service**. Comprueba que el resumen indique **Free ($0/mes)** antes de confirmar. Espera al estado **Running**.
2. En **Overview → Connection information**, localiza host, puerto, usuario y contraseña. No pegues la contraseña en chats, capturas, tickets ni archivos versionados.
3. Completa el archivo privado `.environments/aiven.env` con este formato. Está excluido por `.gitignore` y `.dockerignore`:

   ```dotenv
   DB_HOST=host-del-servicio-mysql
   DB_PORT=puerto-del-servicio-mysql
   DB_NAME=crud_usuarios
   DB_USERNAME=usuario-del-servicio
   DB_PASSWORD=clave-privada-del-servicio
   DB_SSL_MODE=REQUIRED
   ```

4. En PowerShell ejecuta `./scripts/Initialize-Aiven.ps1`. Usa el cliente MySQL de Docker, exige TLS y ejecuta el `schema.sql` idempotente (`CREATE DATABASE IF NOT EXISTS` y `CREATE TABLE IF NOT EXISTS`). Comprueba que `users` tenga las ocho columnas esperadas; no borra datos. No imprime la contraseña.

   Si una contraseña aparece por accidente en una captura o chat, restablécela en Aiven antes de ejecutar este paso. El archivo privado debe contener únicamente la contraseña nueva.
5. Si deseas revisar la tabla visualmente, conecta MySQL Workbench con los mismos valores. Descarga el certificado CA de Aiven para la configuración SSL del cliente y consulta `SHOW TABLES`/`DESCRIBE users`.
6. Con JDK 17 activo, inicia la API desde PowerShell con `./scripts/Start-Aiven.ps1`. Usa `http://127.0.0.1:8080/swagger-ui/index.html` y `docs/API_TESTING.http` para verificar los endpoints. El correo de desarrollo llega a Mailpit en `http://127.0.0.1:8025`.
7. Para volver a MySQL local, detén la API con Ctrl+C y ejecuta `./scripts/Start-Local.ps1`. El volumen local de Docker se conserva.

`REQUIRED` cifra la conexión, pero no verifica la identidad del servidor. Para `VERIFY_CA`/`VERIFY_IDENTITY` hay que importar la CA de Aiven en un truststore Java y configurar el driver; no cambies el modo a `DISABLED` para resolver un error remoto.

El esquema remoto no crea un administrador con contraseña conocida. La cuenta de demostración `admin@example.com` existe solo en el seed local. Para las pruebas de la Guía 2 se creó una cuenta administradora en Aiven con contraseña aleatoria; sus credenciales están exclusivamente en `.environments/aiven-admin.env`, ignorado por Git. Se registró inicialmente como MEMBER/PENDING y se activó y promovió mediante una sentencia SQL específica para su ID y correo, ejecutada una sola vez. El endpoint público sigue sin permitir ADMIN. Conserva este archivo privado para las siguientes pruebas y compártelo con el compañero solo por un canal seguro si lo necesita.

**Estado actual:** conexión MySQL con TLS verificada; `crud_usuarios.users` existe con ocho columnas; API local conectada a Aiven; CRUD, JWT y correo a Mailpit probados. El usuario confirmó que el plan MySQL figura Free ($0/mes). La contraseña que apareció en una captura se restableció antes de las pruebas y no se usó.

Referencias: [MySQL Free](https://aiven.io/docs/products/mysql/concepts/mysql-free-tier), [crear un servicio](https://aiven.io/docs/products/mysql/get-started), [crear base de datos](https://aiven.io/docs/products/mysql/howto/create-database), [Workbench](https://aiven.io/docs/products/mysql/howto/connect-from-mysql-workbench), [TLS/SSL](https://aiven.io/docs/platform/concepts/tls-ssl-certificates).
