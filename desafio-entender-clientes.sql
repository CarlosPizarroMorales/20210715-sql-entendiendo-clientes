-- Desafio 3 - SQL
-- $ createdb desafio3-sql  -- se crea para realizar la restauración
-- 1. Importar respaldo de base de datos:
-- $ psql -h localhost -U postgres -f mi/ruta/local/unidad2.sql desafio3-sql

-- 2. El cliente  usuario01 ha realizado la siguiente compra: 
BEGIN TRANSACTION;
    INSERT INTO compra(cliente_id, fecha) VALUES (1, NOW());
    INSERT INTO detalle_compra(producto_id, compra_id, cantidad)
    VALUES (9, (SELECT MAX(id) FROM compra), 5);
    UPDATE producto SET stock = stock - 5 WHERE id = 9;
COMMIT;
SELECT * FROM producto WHERE id = 9;

-- 3. Compra usuario02

BEGIN TRANSACTION;
    INSERT INTO compra(cliente_id, fecha) VALUES(2, NOW());

    INSERT INTO detalle_compra(producto_id, compra_id, cantidad)
    VALUES (1, (SELECT MAX(id) FROM compra), 3);
    
    UPDATE producto SET stock = stock - 3 WHERE id = 2;

    INSERT INTO detalle_compra(producto_id, compra_id, cantidad)
    VALUES(8, (SELECT MAX(id) FROM compra), 3);

    UPDATE producto SET stock = stock - 3  WHERE id = 8;
COMMIT;
SELECT * FROM producto WHERE id IN (1, 2, 8) -- para verificar los cambios

-- 4. Consultas varias:
-- 4.1. deshabilitar autocommit
-- \set AUTOCOMMIT off

-- 4.2. insertar nuevo cliente
INSERT INTO cliente (nombre, email) VALUES ('nuevouser', 'user11@gmail.com');

-- 4.3. confirmar inserción del registro anterior
SELECT * FROM cliente; -- podría haber utilizado un filtro pero esta selección cumple el requisito.

-- 4.4. REALIZAR ROLLBACK. ESTE PUNTO ES CONFUSO PUES EL INICIO DEL PUNTO 4 NO PIDE QUE INICE UNA TRANSACCION.  
-- Se escribe la palabra reservada tal cual se usuaría en una transacción.
ROLLBACK;

-- 4.5. Confirmar la restauración. Esto no se entiende, pues el punto no solicita crear una transacción. 
-- Si se hubiera creado una transacción en el punto 4.2 el caso sería:
-- BEGIN TRANSACTION;
-- INSERT INTO cliente (nombre, email) VALUES ('nuevouser11', 'user11@gmail.com');
-- SELECT * FROM cliente;
-- ROLBACK;
SELECT * FROM cliente; -- con esto se confirmaría que la inserción no fue realizada.

-- 4.6. habilitar el autocommit
-- \set AUTOCOMMIT on;

