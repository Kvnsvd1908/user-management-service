-- Solo para la base local de Docker Compose. Nunca ejecutar en Aiven, TiDB o Render.
-- Credenciales de demostracion: admin@example.com / Admin1234!
USE crud_usuarios;

INSERT INTO users (id, name, email, password, role, status)
VALUES (
    '00000000-0000-0000-0000-000000000001',
    'Administrador',
    'admin@example.com',
    '$2a$12$sfwkajsls.fktQb0Ngw5cOiSiV3z4LIwbucSAy4sw2wyNlxbUBt4q',
    'ADMIN',
    'ACTIVE'
);
