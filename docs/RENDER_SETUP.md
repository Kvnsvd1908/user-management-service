# Guía 3: Render y CI/CD

El repositorio contiene `render.yaml` para crear un Web Service Docker en el plan Free desde `main`. El Dockerfile ejecuta `mvn clean verify` durante la construcción y el flujo `.github/workflows/ci.yml` verifica cada push y pull request a `main`. Render usa `autoDeployTrigger: checksPass`: un push se despliega automáticamente después de que GitHub Actions termina correctamente.

## Configuración privada

Conecta la cuenta GitHub a Render y selecciona este repositorio. Crea una instancia de Blueprint desde `render.yaml` en la raíz. En el formulario de Render completa `DB_HOST`, `DB_PORT`, `DB_USERNAME` y `DB_PASSWORD` con los datos del servicio MySQL de Aiven. `DB_NAME=crud_usuarios` y `DB_SSL_MODE=REQUIRED` están definidos en el Blueprint. No copies la contraseña a GitHub, documentación, capturas ni mensajes.

`JWT_SECRET` se genera en Render. El plan Free bloquea SMTP saliente en los puertos habituales, así que este Blueprint fija `NOTIFICATIONS_EMAIL_ENABLED=false`. El correo sigue funcionando en el entorno local con Mailpit. La integración HTTPS de Brevo corresponde a la Guía 5; al implementarla habrá que activar las notificaciones y configurar sus variables en Render.

## Comprobación

Tras ver `Live` en Render, comprueba la URL HTTPS asignada: `/v3/api-docs` y `/swagger-ui/index.html` deben responder 200; `/api/users` sin token debe responder 401. Autentica la cuenta ADMIN privada en `POST /api/auth/login` y usa el `accessToken` para consultar `GET /api/users` con `Authorization: Bearer <token>`. No uses la cuenta de demostración local: no está sembrada en Aiven.

Para verificar el despliegue continuo, haz un push a `main`, confirma que el flujo CI termine en verde y que Render despliegue ese commit automáticamente. El plan Free puede suspender el servicio tras inactividad, por lo que una primera petición puede tardar más.

La Guía 3 también requiere 2FA en GitHub. El propietario de la cuenta debe activarlo desde **Settings → Password and authentication**, completar el QR/TOTP en su dispositivo y guardar los códigos de recuperación fuera del repositorio.

Referencias: [Render Blueprint](https://render.com/docs/blueprint-spec), [Render Free](https://render.com/docs/free), [despliegues automáticos](https://render.com/docs/deploys).
