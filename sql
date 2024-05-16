CREATE TABLE clientes (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    direccion TEXT,
    correo_electronico VARCHAR(255),
    telefono VARCHAR(15)
);
CREATE TABLE productos (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255),
    descripcion TEXT,
    precio DECIMAL(10, 2),
    categoria VARCHAR(50),
    stock INT
);
CREATE TABLE pedidos (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    ID_cliente INT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('Pendiente', 'Enviado', 'Entregado'),
    total DECIMAL(10, 2),
    FOREIGN KEY (ID_cliente) REFERENCES clientes(ID)
);
CREATE TABLE ventas (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    ID_pedido INT,
    ID_producto INT,
    cantidad INT,
    precio_venta DECIMAL(10, 2),
    FOREIGN KEY (ID_pedido) REFERENCES pedidos(ID),
    FOREIGN KEY (ID_producto) REFERENCES productos(ID)
);

INSERT INTO clientes (nombre, apellido, direccion, correo_electronico, telefono)
VALUES ('pedro', 'miguel', 'Calle Falsa 123', 'pedromiguel@gmail.com', '555-123456');

INSERT INTO clientes (nombre, apellido, direccion, correo_electronico, telefono)
VALUES ('sonya', 'González', 'Avenida luz 789', 'sonya@gmail.com', '555-654321');

INSERT INTO clientes (nombre, apellido, direccion, correo_electronico, telefono)
VALUES ('Carlos', 'gimenez', 'calle pasaje 42', 'carlosgimenez@gmai.com', '555-987654');

INSERT INTO productos (nombre, descripcion, precio, categoria, stock)
VALUES ('Camiseta azul', 'Camiseta de algodón azul', 19.99, 'Camisetas', 50);

INSERT INTO productos (nombre, descripcion, precio, categoria, stock)
VALUES ('Jean Azul', 'Jean de mezclilla azul', 29.99, 'Pantalones', 40);

INSERT INTO productos (nombre, descripcion, precio, categoria, stock)
VALUES ('Zapatos Blancos', 'Zapatillas deportivas blancas', 49.99, 'Calzado', 60);
INSERT INTO pedidos (ID_cliente, fecha, estado, total)
VALUES (1, '2024-04-01', 'Pendiente', 39.98);

INSERT INTO pedidos (ID_cliente, fecha, estado, total)
VALUES (2, '2024-04-02', 'Enviado', 59.98);

INSERT INTO pedidos (ID_cliente, fecha, estado, total)
VALUES (3, '2024-04-03', 'Entregado', 79.98);

INSERT INTO ventas (ID_pedido, ID_producto, cantidad, precio_venta)
VALUES (1, 1, 2, 19.99);

INSERT INTO ventas (ID_pedido, ID_producto, cantidad, precio_venta)
VALUES (2, 2, 1, 29.99);

INSERT INTO ventas (ID_pedido, ID_producto, cantidad, precio_venta)
VALUES (3, 3, 1, 49.99);

SELECT c.nombre, c.apellido, c.direccion, c.correo_electronico
FROM clientes c
JOIN pedidos p ON c.ID = p.ID_cliente
WHERE p.fecha >= DATE_SUB(CURRENT_DATE, INTERVAL 30 DAY);

SELECT vp.ID_producto, SUM(vp.cantidad) AS total_vendido
FROM ventas vp
JOIN pedidos p ON vp.ID_pedido = p.ID
WHERE p.fecha BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH) AND CURRENT_DATE
GROUP BY vp.ID_producto;

SELECT pr.nombre, sub.total_vendido
FROM (
    SELECT vp.ID_producto, SUM(vp.cantidad) AS total_vendido
    FROM ventas vp
    JOIN pedidos p ON vp.ID_pedido = p.ID
    WHERE p.fecha BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 1 MONTH) AND CURRENT_DATE
    GROUP BY vp.ID_producto
) sub
JOIN productos pr ON sub.ID_producto = pr.ID
ORDER BY sub.total_vendido DESC;

SELECT c.nombre, c.apellido, COUNT(p.ID) AS total_pedidos
FROM clientes c
JOIN pedidos p ON c.ID = p.ID_cliente
WHERE p.fecha >= DATE_SUB(CURRENT_DATE, INTERVAL 1 YEAR)
GROUP BY c.ID
ORDER BY total_pedidos DESC;

UPDATE productos
SET precio = precio * 1.10
WHERE categoria = 'Camisetas';

DELETE FROM pedidos
WHERE ID NOT IN (SELECT DISTINCT ID_pedido FROM ventas);

CREATE VIEW vista_clientes_pedidos AS
SELECT CONCAT(c.nombre, ' ', c.apellido) AS nombre_completo, p.fecha, p.total
FROM clientes c
JOIN pedidos p ON c.ID = p.ID_cliente;
