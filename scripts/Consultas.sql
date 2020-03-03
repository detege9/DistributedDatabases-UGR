-- Consultas

-- 1. LISTAR LOS CLIENTES (NOMBRE Y DIRECCION) DE ANDALUCÍA O CASTILLA-LA MANCHA
-- Y LAS SUCURSALES (NOMBRE Y CIUDAD), A LOS QUE SE LE HA SUMINISTRADO VINO DE
-- LA MARCA "TABLAS DE DAIMIEL" ENTRE EL 1 DE ENERO DE 2016 Y EL 1 DE SEPTIEMBRE
-- DE 2016


SELECT cl.nombre_cliente, cl.direccion_cliente, su.nombre_sucursal, su.ciudad_sucursal
FROM v_cliente cl, v_ClienteSolicitaVinoASucursal rp, v_vino v, v_Sucursal su
WHERE cl.codCliente = rp.codCliente
  AND rp.codSucursal = su.codSucursal
  AND rp.codVino = v.codVino
  AND (cl.CA_cliente = 'Andalucía' OR cl.CA_cliente = 'Castilla-La Mancha')
  AND v.marca_vino = 'Tablas de Daimiel'
  AND (rp.fecha > TO_DATE('01-01-2019', 'DD/MM/YYYY') AND rp.fecha < TO_DATE('01-09-2019', 'DD/MM/YYYY'));

-- 2. DADO POR TECLADO EL CÓDIGO DE UN PRODUCTOR LISTAR LA MARCA, EL AÑO DE COSECHA,
-- DE CADA UNO DE LOS VINOS PRODUCIDOS POR ÉL Y LA CANTIDAD TOTAL SUMINISTRADA
-- DE CADA UNO DE ELLOS A CLIENTES DE LAS COMUNIDADES AUTÓNOMAS DE BALEARES,
-- EXTREMADURA O PAÍS VALENCIANO

SELECT v.marca_vino, v.anyo_vino, sum(rp.cantidad) AS "CANTIDAD TOTAL"
FROM v_vino v, v_ClienteSolicitaVinoASucursal rp, v_cliente cl
WHERE v.codVino = rp.codVino
  AND rp.codCliente = cl.codCliente
  AND cl.CA_cliente IN('Baleares', 'Extremadura', 'País Valenciano')
    AND v.codProductor = &xCodProductor
GROUP BY v.marca_vino, v.anyo_vino;


-- 3. DADO POR TECLADO EL CÓDIGO DE UNA SUCURSAL LISTAR EL NOMBRE DE CADA UNO DE
-- SUS CLIENTES, SU TIPO Y LA CANTIDAD TOTAL DE VINO DE RIOJA O ALBARIÑO QUE SE
-- LE HA SUMINISTRADO A CADA UNO DE ELLOS (SOLAMENTE DEBERÁN APARECER AQUELLOS
-- CLIENTES A LOS QUE SE LES HA SUMINISTRADO VINOS CON ESTA DENOMINACIÓN DE ORIGEN)

SELECT cl.nombre_cliente, cl.tipo_cliente, sum(rp.cantidad) AS "CANTIDAD TOTAL"
FROM v_cliente cl, v_ClienteSolicitaVinoASucursal rp, v_vino v
WHERE cl.codCliente = rp.codCliente
  AND rp.codVino = v.codVino
  AND v.denominacion_origen IN ('Rioja','Albariño')
  AND rp.codSucursal = &xCodSucursal
GROUP BY cl.nombre_cliente, cl.tipo_cliente;
