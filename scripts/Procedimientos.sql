SET SERVEROUTPUT ON;

-- PROCEDIMIENTOS

-- 1. DAR DE ALTA UN NUEVO EMPLEADO.
-- ARGUMENTOS: CÓDIGO DEL EMPLEADO, DNI, NOMBRE, FECHA DE INICIO DE CONTRATO,
-- SALARIO, DIRECCIÓN Y CÓDIGO DE LA SUCURSAL A LA QUE ESTÁ ASIGNADO.

CREATE OR REPLACE PROCEDURE PR_INS_EMPLEADO(xCodEmpleado NUMBER, xDNI VARCHAR2,
  xNombre VARCHAR2, xFechaContrato DATE, xSalario NUMBER, xDireccion VARCHAR2,
  xCodSucursal NUMBER)
IS
  xCA_sucursal sucursal.CA_sucursal%TYPE;
  xParticion VARCHAR(9);
  xDelegacion VARCHAR(50);
  xCont number(2);

BEGIN

  SELECT COUNT(*) INTO xCont FROM v_empleado where codEmpleado = xCodEmpleado;

  IF (xCont > 0) THEN
    RAISE_APPLICATION_ERROR(-20052, 'YA EXISTE UN EMPLEADO CON ESE CÓDIGO');
  ELSE
    -- OBTENEMOS LA COMUNIDAD DE LA SUCURSAL PARA SABER LA DELEGACIÓN
    SELECT CA_sucursal INTO xCA_sucursal FROM v_sucursal WHERE codSucursal = xCodSucursal;

    PR_GET_DELEGACION(xDelegacion, xCA_sucursal);  -- OBTENEMOS LA DELEGACIÓN

    CASE
      -- SI LA DELEGACIÓN PERTENECE A MADRID
      WHEN xDelegacion = 'Madrid' THEN
        INSERT INTO platano1.empleado
        VALUES (xCodEmpleado, xDNI, xNombre, xFechaContrato, xSalario, xDireccion,
          xCodSucursal);

      -- SI LA DELEGACIÓN PERTENECE A BARCELONA
      WHEN xDelegacion = 'Barcelona' THEN
        INSERT INTO platano2.empleado
        VALUES (xCodEmpleado, xDNI, xNombre, xFechaContrato, xSalario, xDireccion,
          xCodSucursal);

      -- SI LA DELEGACIÓN PERTENECE A LA CORUÑA
      WHEN xDelegacion = 'La Coruña' THEN
        INSERT INTO platano3.empleado
        VALUES (xCodEmpleado, xDNI, xNombre, xFechaContrato, xSalario, xDireccion,
          xCodSucursal);

      -- SI LA DELEGACIÓN PERTENECE A SEVILLA
      WHEN xDelegacion = 'Sevilla' THEN
        INSERT INTO platano4.empleado
        VALUES (xCodEmpleado, xDNI, xNombre, xFechaContrato, xSalario, xDireccion,
          xCodSucursal);
    END CASE;
    DBMS_OUTPUT.PUT_LINE('EL EMPLEADO ' || xNombre ||' FUE DADO DE ALTA CORRECTAMENTE');
  END IF;
END PR_INS_EMPLEADO;
/

-- 2. DAR DE BAJA A UN EMPLEADO.
-- ARGUMENTO: CÓDIGO DE EMPLEADO. SI EL EMEPLEADO QUE SE DA DE BAJA ES DIRECTOR
-- DE ALGUNA SUCURSAL, HABRÁ QUE REALIZAR LAS ACTUALIZACIONES NECESARIAS PARA
-- DEJAR CONSTANCIA DE QUE ESE EMPLEADO YA NO TRABAJA EN LA COMPAÑÍA


CREATE OR REPLACE PROCEDURE PR_DEL_EMPLEADO (xCodEmpleado NUMBER)
IS
  xCont NUMBER(1);
  xDelegacion VARCHAR(50);
  xDelegacion2 VARCHAR(50);
  xCA_sucursal Sucursal.CA_sucursal%TYPE;
  xCA_sucursal2 Sucursal.CA_sucursal%TYPE;
BEGIN

  -- VEMOS SI EL EMPLEADO EXISTE EN LA COMPAÑÍA.
  SELECT COUNT (*) INTO xCont FROM v_empleado WHERE
  codEmpleado = xCodEmpleado;

  IF (xCont = 0) THEN -- SI EL CODIGO DE EMPLEADO NO EXISTE
    RAISE_APPLICATION_ERROR(-20101, 'NO EXISTE NINGÚN EMPLEADO CON ESE CÓDIGO');
  ELSE

    -- COMPROBAMOS SI ES DIRECTOR DE ALGUNA SUCURSAL.
    SELECT COUNT (*) INTO xCont
    FROM v_sucursal s
    WHERE s.director_sucursal = xCodEmpleado;

    -- OBTENEMOS LA DELEGACIÓN EN LA QUE TRABAJA EL EMPLEADO.
    SELECT s.CA_sucursal INTO xCA_sucursal
    FROM v_sucursal s, v_empleado emp
    WHERE s.codSucursal = emp.codSucursal
      AND emp.codEmpleado = xCodEmpleado;

    PR_GET_DELEGACION(xDelegacion, xCA_sucursal);  -- OBTENEMOS LA DELEGACIÓN

    CASE
      -- SI LA DELEGACIÓN PERTENECE A MADRID
      WHEN xDelegacion = 'Madrid' THEN
        -- SI ES DIRECTOR DE UNA SUCURSAL LA PONEMOS A NULL Y MOSTRAMOS EL MENSAJE
        IF (xCont<>0) THEN
          -- BUSCAMOS LA SUCURSAL POR LA QUE ES DIRECTOR Y LA MODIFICAMOS.
          SELECT COUNT(*) INTO xCont FROM v_sucursal WHERE director_sucursal = xCodEmpleado;
          IF (xCont > 0) THEN

            -- OBTENEMOS LA DELEGACIÓN EN LA QUE TRABAJA EL EMPLEADO.
            SELECT s.CA_sucursal INTO xCA_sucursal2
            FROM v_sucursal s
            WHERE s.director_sucursal = xCodEmpleado;

            PR_GET_DELEGACION(xDelegacion2, xCA_sucursal2);  -- OBTENEMOS LA DELEGACIÓN

            IF (xDelegacion2 = 'Madrid') THEN -- SI LA DELEGACIÓN ES MADRID
              UPDATE platano1.sucursal SET director_sucursal = null WHERE director_sucursal = xcodempleado;
            END IF;
            IF (xDelegacion2 = 'Barcelona') THEN -- SI LA DELEGACIÓN ES BARCELONA
              UPDATE platano2.sucursal SET director_sucursal = null WHERE director_sucursal = xcodempleado;
            END IF;
            IF (xDelegacion2 = 'La Coruña') THEN -- SI LA DELEGACIÓN ES LA CORUÑA
              UPDATE platano3.sucursal SET director_sucursal = null WHERE director_sucursal = xcodempleado;
            END IF;
            IF (xDelegacion2 = 'Sevilla') THEN -- SI LA DELEGACIÓN ES SEVILLA
              UPDATE platano4.sucursal SET director_sucursal = null WHERE director_sucursal = xcodempleado;
            END IF;
            DBMS_OUTPUT.PUT_LINE('LA SUCURSAL DE LA QUE ERA DIRECTOR HA QUEDADO VACÍA');
          END IF;
        END IF;
        DELETE FROM platano1.empleado WHERE codEmpleado = xCodEmpleado;

      -- SI LA DELEGACIÓN PERTENECE A BARCELONA
      WHEN xDelegacion = 'Barcelona' THEN
        -- SI ES DIRECTOR DE UNA SUCURSAL LA PONEMOS A NULL Y MOSTRAMOS EL MENSAJE
        IF (xCont<>0) THEN
          -- BUSCAMOS LA SUCURSAL POR LA QUE ES DIRECTOR Y LA MODIFICAMOS.
          SELECT COUNT(*) INTO xCont FROM v_sucursal WHERE director_sucursal = xCodEmpleado;
          IF (xCont > 0) THEN
            -- OBTENEMOS LA DELEGACIÓN EN LA QUE TRABAJA EL EMPLEADO.
            SELECT s.CA_sucursal INTO xCA_sucursal2
            FROM v_sucursal s
            WHERE s.director_sucursal = xCodEmpleado;

            PR_GET_DELEGACION(xDelegacion2, xCA_sucursal2);  -- OBTENEMOS LA DELEGACIÓN

            IF (xDelegacion2 = 'Madrid') THEN -- SI LA DELEGACIÓN ES MADRID
              UPDATE platano1.sucursal SET director_sucursal = null WHERE director_sucursal = xcodempleado;
            END IF;
            IF (xDelegacion2 = 'Barcelona') THEN -- SI LA DELEGACIÓN ES BARCELONA
              UPDATE platano2.sucursal SET director_sucursal = null WHERE director_sucursal = xcodempleado;
            END IF;
            IF (xDelegacion2 = 'La Coruña') THEN -- SI LA DELEGACIÓN ES LA CORUÑA
              UPDATE platano3.sucursal SET director_sucursal = null WHERE director_sucursal = xcodempleado;
            END IF;
            IF (xDelegacion2 = 'Sevilla') THEN -- SI LA DELEGACIÓN ES SEVILLA
              UPDATE platano4.sucursal SET director_sucursal = null WHERE director_sucursal = xcodempleado;
            END IF;
            DBMS_OUTPUT.PUT_LINE('LA SUCURSAL DE LA QUE ERA DIRECTOR HA QUEDADO VACÍA');
          END IF;
        END IF;
        DELETE FROM platano2.empleado WHERE codEmpleado = xcodempleado;

      -- SI LA DELEGACIÓN PERTENECE A LA CORUÑA
      WHEN xDelegacion = 'La Coruña' THEN
        -- SI ES DIRECTOR DE UNA SUCURSAL LA PONEMOS A NULL Y MOSTRAMOS EL MENSAJE
        IF (xCont<>0) THEN
          -- BUSCAMOS LA SUCURSAL POR LA QUE ES DIRECTOR Y LA MODIFICAMOS.
          SELECT COUNT(*) INTO xCont FROM v_sucursal WHERE director_sucursal = xCodEmpleado;
          IF (xCont > 0) THEN
            -- OBTENEMOS LA DELEGACIÓN EN LA QUE TRABAJA EL EMPLEADO.
            SELECT s.CA_sucursal INTO xCA_sucursal2
            FROM v_sucursal s
            WHERE s.director_sucursal = xCodEmpleado;

            PR_GET_DELEGACION(xDelegacion2, xCA_sucursal2);  -- OBTENEMOS LA DELEGACIÓN
            IF (xDelegacion2 = 'Madrid') THEN -- SI LA DELEGACIÓN ES MADRID
              UPDATE platano1.sucursal SET director_sucursal = null WHERE director_sucursal = xcodempleado;
            END IF;
            IF (xDelegacion2 = 'Barcelona') THEN -- SI LA DELEGACIÓN ES BARCELONA
              UPDATE platano2.sucursal SET director_sucursal = null WHERE director_sucursal = xcodempleado;
            END IF;
            IF (xDelegacion2 = 'La Coruña') THEN -- SI LA DELEGACIÓN ES LA CORUÑA
              UPDATE platano3.sucursal SET director_sucursal = null WHERE director_sucursal = xcodempleado;
            END IF;
            IF (xDelegacion2 = 'Sevilla') THEN -- SI LA DELEGACIÓN ES SEVILLA
              UPDATE platano4.sucursal SET director_sucursal = null WHERE director_sucursal = xcodempleado;
            END IF;
            DBMS_OUTPUT.PUT_LINE('LA SUCURSAL DE LA QUE ERA DIRECTOR HA QUEDADO VACÍA');
          END IF;
        END IF;
        DELETE FROM platano3.empleado WHERE codEmpleado = xcodempleado;

      -- SI LA DELEGACIÓN PERTENECE A SEVILLA
      WHEN xDelegacion = 'Sevilla' THEN
        -- SI ES DIRECTOR DE UNA SUCURSAL LA PONEMOS A NULL Y MOSTRAMOS EL MENSAJE
        IF (xCont<>0) THEN
          -- BUSCAMOS LA SUCURSAL POR LA QUE ES DIRECTOR Y LA MODIFICAMOS.
          SELECT COUNT(*) INTO xCont FROM v_sucursal WHERE director_sucursal = xCodEmpleado;
          IF (xCont > 0) THEN
            -- OBTENEMOS LA DELEGACIÓN EN LA QUE TRABAJA EL EMPLEADO.
            SELECT s.CA_sucursal INTO xCA_sucursal2
            FROM v_sucursal s
            WHERE s.director_sucursal = xCodEmpleado;

            PR_GET_DELEGACION(xDelegacion2, xCA_sucursal2);  -- OBTENEMOS LA DELEGACIÓN
            IF (xDelegacion2 = 'Madrid') THEN -- SI LA DELEGACIÓN ES MADRID
              UPDATE platano1.sucursal SET director_sucursal = null WHERE director_sucursal = xcodempleado;
            END IF;
            IF (xDelegacion2 = 'Barcelona') THEN -- SI LA DELEGACIÓN ES BARCELONA
              UPDATE platano2.sucursal SET director_sucursal = null WHERE director_sucursal = xcodempleado;
            END IF;
            IF (xDelegacion2 = 'La Coruña') THEN -- SI LA DELEGACIÓN ES LA CORUÑA
              UPDATE platano3.sucursal SET director_sucursal = null WHERE director_sucursal = xcodempleado;
            END IF;
            IF (xDelegacion2 = 'Sevilla') THEN -- SI LA DELEGACIÓN ES SEVILLA
              UPDATE platano4.sucursal SET director_sucursal = null WHERE director_sucursal = xcodempleado;
            END IF;
            DBMS_OUTPUT.PUT_LINE('LA SUCURSAL DE LA QUE ERA DIRECTOR HA QUEDADO VACÍA');
          END IF;
        END IF;
        DELETE FROM platano4.empleado WHERE codEmpleado = xcodempleado;
    END CASE;
    DBMS_OUTPUT.PUT_LINE('EL EMPLEADO ' || xCodEmpleado ||  ' FUE DADO DE BAJA CORRECTAMENTE');
  END IF;
END PR_DEL_EMPLEADO;
/


-- 3. MODIFICAR EL SALARIO DE UN EMPLEADO.
-- ARGUMENTO: CODIGO DE EMPLEADO Y EL NUEVO SUELDO.

CREATE OR REPLACE PROCEDURE PR_UPD_SAL_EMPL (xCodEmpleado empleado.codEmpleado%TYPE, xSalario empleado.salario%TYPE)
IS
  xCont NUMBER(8);
  xDelegacion VARCHAR(50);
  xCA_sucursal Sucursal.CA_sucursal%TYPE;
BEGIN

    -- VEMOS SI EL EMPLEADO EXISTE EN LA COMPAÑÍA.
  SELECT COUNT (*) INTO xCont FROM v_EMPLEADO WHERE codEmpleado = xCodEmpleado;

  IF (xCont = 0) THEN -- SI EL CODIGO DE EMPLEADO NO EXISTE
    RAISE_APPLICATION_ERROR(-20102, 'NO EXISTE NINGÚN EMPLEADO CON ESE CÓDIGO');
  ELSE

    -- OBTENEMOS LA DELEGACIÓN EN LA QUE TRABAJA EL EMPLEADO.
    SELECT s.CA_sucursal INTO xCA_sucursal
    FROM v_sucursal s, v_empleado emp
    WHERE s.codSucursal = emp.codSucursal
      AND emp.codEmpleado = xCodEmpleado;

    PR_GET_DELEGACION(xDelegacion, xCA_sucursal);  -- OBTENEMOS LA DELEGACIÓN

    CASE
      -- SI LA DELEGACIÓN PERTENECE A MADRID
      WHEN xDelegacion = 'Madrid' THEN
        UPDATE platano1.empleado SET salario = xSalario WHERE codEmpleado = xCodEmpleado;

      -- SI LA DELEGACIÓN PERTENECE A BARCELONA
      WHEN xDelegacion = 'Barcelona' THEN
        UPDATE platano2.empleado SET salario = xSalario WHERE codEmpleado = xCodEmpleado;

      -- SI LA DELEGACIÓN PERTENECE A LA CORUÑA
      WHEN xDelegacion = 'La Coruña' THEN
        UPDATE platano3.empleado SET salario = xSalario WHERE codEmpleado = xCodEmpleado;

      -- SI LA DELEGACIÓN PERTENECE A SEVILLA
      WHEN xDelegacion = 'Sevilla' THEN
        UPDATE platano4.empleado SET salario = xSalario WHERE codEmpleado = xCodEmpleado;
    END CASE;
    DBMS_OUTPUT.PUT_LINE('EL SALARIO PARA EL EMPLEADO ' || xCodEmpleado ||  ' HA SIDO MODIFICADO CORRECTAMENTE');
  END IF;

END PR_UPD_SAL_EMPL;
/

-- 4. TRASLADAR DE SUCURSAL A UN EMPLEADO:
-- ARGUMENTOS: CÓDIGO DE EMPLEADO, CÓDIGO DE LA SUCURSAL A LA QUE ES TRASLADADO
-- Y, OPCIONAMENTE, LA NUEVA DIRECCIÓN. SI ESTE ÚLTIMO ARGUMENTO NO SE INDICA,
-- EL VALOR PARA EL ATRIBUTO CORRESPONDIENTE DEBE PONERSE A NULO. LA FECHA DE
-- INICIO DE CONTRATO Y EL SUELDO TENDRÁN LOS MISMO VALORES.

CREATE OR REPLACE PROCEDURE PR_TRAS_EMPLEADO
(xCodEmpleado empleado.codEmpleado%TYPE, xNewCodSucursal sucursal.codSucursal%TYPE, xDireccion empleado.direccion_empleado%TYPE DEFAULT NULL)
IS
	xCont NUMBER(8);
  xDelegacionOld VARCHAR(50);
  xDelegacionNew VARCHAR(50);
  xCA_Sucursal1 Sucursal.CA_sucursal%TYPE;
  xCA_Sucursal2 Sucursal.CA_sucursal%TYPE;
  CURSOR CU_EMPLEADO IS -- CURSOR PARA GUARDAR LOS DATOS DEL EMPLEADO QUE NO SE
              -- MODIFICARÁN. SE PODÍA HABER HECHO TAMBIÉN CON UN SELECT
    SELECT DNI_empleado, nombre_empleado, fecha_comienzo_contrato, salario
    FROM v_empleado
    WHERE codEmpleado = xCodEmpleado;
  xEmpleado CU_EMPLEADO%ROWTYPE;
BEGIN
  -- COMPROBAMOS QUE EL EMPLEADO EXISTE
  SELECT COUNT (*) INTO xCont FROM v_empleado WHERE codempleado = xCodEmpleado;

  IF (xCont = 0) THEN -- SI NO EXISTE EL EMPLEADO
    RAISE_APPLICATION_ERROR(-20103,'NO SE HA ENCONTRADO UN EMPLEADO CON ESE CÓDIGO');
  ELSE
    OPEN CU_EMPLEADO; -- ABRIMOS EL CURSOR

    FETCH CU_EMPLEADO INTO xEmpleado; -- LEEMOS LOS DATOS DEL EMPLEADO

    IF (CU_EMPLEADO%FOUND) THEN -- SI SE HA ENCONTRADO UN EMPLEADO
      -- SELECCIONAMOS LA DELEGACION DEL EMPLEADO PARA SABER SU UBICACIÓN
      SELECT CA_sucursal INTO xCA_Sucursal1 FROM v_sucursal s, v_empleado emp
      WHERE emp.codSucursal = s.codSucursal AND codEmpleado = xCodEmpleado;

      PR_GET_DELEGACION(xDelegacionOld, xCA_sucursal1);  -- OBTENEMOS LA DELEGACIÓN


      -- COMRPOBAMSO SI EXISTE LA NUEVA SUCURSAL.
      SELECT COUNT(*) INTO xCont FROM v_sucursal s
      WHERE s.codSucursal = xNewCodSucursal;

    IF (xCont = 0) THEN  -- SI NO EXISTE LA NUEVA SUCURSAL.
      RAISE_APPLICATION_ERROR(-20110, 'LA SUCURSAL NUEVA NO EXISTE EN EL SISTEMA');
    END IF;

    -- SELECCIONAMOS LA DELEGACION DE LA NUEVA SUCURSAL PARA EL EMPLEADO.
    SELECT CA_sucursal INTO xCA_sucursal2 FROM v_sucursal s
      WHERE s.codSucursal = xNewCodSucursal;

      PR_GET_DELEGACION(xDelegacionNew, xCA_sucursal2);  -- OBTENEMOS LA DELEGACIÓN

      CASE
        -- SI LA ANTIGUA DELEGACIÓN PERTENECE A MADRID
        WHEN xDelegacionOld = 'Madrid' THEN
          DELETE FROM platano1.empleado WHERE codEmpleado = xCodEmpleado;

        -- SI LA ANTIGUA DELEGACIÓN PERTENECE A BARCELONA
        WHEN xDelegacionOld = 'Barcelona' THEN
          DELETE FROM platano2.empleado WHERE codEmpleado = xCodEmpleado;

        -- SI LA ANTIGUA DELEGACIÓN PERTENECE A LA CORUÑA
        WHEN xDelegacionOld = 'La Coruña' THEN
          DELETE FROM platano3.empleado WHERE codEmpleado = xCodEmpleado;

        -- SI LA ANTIGUA DELEGACIÓN PERTENECE A SEVILLA
        WHEN xDelegacionOld = 'Sevilla' THEN
          DELETE FROM platano4.empleado WHERE codEmpleado = xCodEmpleado;
      END CASE;

      CASE
        -- SI LA NUEVA DELEGACIÓN PERTENECE A MADRID
        WHEN xDelegacionNew = 'Madrid' THEN
          INSERT INTO platano1.empleado
          VALUES (xCodEmpleado, xEmpleado.DNI_empleado,xEmpleado.nombre_empleado,  xEmpleado.fecha_comienzo_contrato,
            xEmpleado.SALARIO, xDireccion, xNewCodSucursal);

        -- SI LA NUEVA DELEGACIÓN PERTENECE A BARCELONA
        WHEN xDelegacionNew = 'Barcelona' THEN
          INSERT INTO platano2.empleado
          VALUES (xCodEmpleado, xEmpleado.DNI_empleado,xEmpleado.nombre_empleado,  xEmpleado.fecha_comienzo_contrato,
            xEmpleado.SALARIO, xDireccion, xNewCodSucursal);

        -- SI LA NUEVA DELEGACIÓN PERTENECE A LA CORUÑA
        WHEN xDelegacionNew = 'La Coruña' THEN
          INSERT INTO platano3.empleado
          VALUES (xCodEmpleado, xEmpleado.DNI_empleado,xEmpleado.nombre_empleado,  xEmpleado.fecha_comienzo_contrato,
            xEmpleado.SALARIO, xDireccion, xNewCodSucursal);

        -- SI LA NUEVA DELEGACIÓN PERTENECE A SEVILLA
        WHEN xDelegacionNew = 'Sevilla' THEN
          INSERT INTO platano4.empleado
          VALUES (xCodEmpleado, xEmpleado.DNI_empleado,xEmpleado.nombre_empleado,  xEmpleado.fecha_comienzo_contrato,
            xEmpleado.SALARIO, xDireccion, xNewCodSucursal);
      END CASE;
    END IF;
    CLOSE CU_EMPLEADO;
  END IF;
  DBMS_OUTPUT.PUT_LINE('EL EMPLEADO ' || xCodEmpleado || ' SE TRASLADÓ CORRECTAMENTE A LA SUCURSAL ' || xNewCodSucursal);
END PR_TRAS_EMPLEADO;
/


-- 5. DAR DE ALTA UNA NUEVA SUCURSAL.
-- ARGUMENTOS: CÓDIGO DE SUCURSAL, NOMBRE, CIUDAD,Y COMUNIDAD AUTÓNOMA Y,
-- OPCIONAMENTE, EL CÓDIGO DE EMPLEADO QUE VA A SER DIRECTORR DE LA SUCURSAL.
-- SI ESTE ÚLTIMO ARGUMENTO NO SE INDICA, EL VALOR PARA EL CORRESPONDIENTE
-- ATRIBUTO DEBE PONERSE A NULO.

CREATE OR REPLACE PROCEDURE PR_INS_SUCURSAL
(xCodSucursal sucursal.codSucursal%TYPE, xNombre sucursal.nombre_sucursal%TYPE,
xCiudad sucursal.ciudad_sucursal%TYPE, xCCAA sucursal.CA_sucursal%TYPE, xDirector empleado.codEmpleado%TYPE DEFAULT NULL)
IS
  xDelegacion VARCHAR(50);
  xCont NUMBER(1);
BEGIN

  SELECT COUNT(*) INTO xCont FROM v_sucursal where CodSucursal = xCodSucursal;

  IF (xCont > 0) THEN
    RAISE_APPLICATION_ERROR(-20052, 'YA EXISTE UNA SUCURSAL CON ESE CÓDIGO');
  ELSE

    -- OBTENEMOS LA DELEGACIÓN DE LA SUCURSAL.
    PR_GET_DELEGACION(xDelegacion, xCCAA);

    CASE
  			-- SI LA DELEGACIÓN PERTENECE A MADRID
  			WHEN xDelegacion = 'Madrid' THEN
    			INSERT INTO platano1.sucursal
          VALUES (xCodSucursal, xNombre, xCiudad, xCCAA, xDirector);

  			-- SI LA DELEGACIÓN PERTENECE A BARCELONA
  			WHEN xDelegacion = 'Barcelona' THEN
    			INSERT INTO platano2.sucursal
          VALUES (xCodSucursal, xNombre, xCiudad, xCCAA, xDirector);

  			-- SI LA DELEGACIÓN PERTENECE A LA CORUÑA
  			WHEN xDelegacion = 'La Coruña' THEN
    			INSERT INTO platano3.sucursal
          VALUES (xCodSucursal, xNombre, xCiudad, xCCAA, xDirector);

  			-- SI LA DELEGACIÓN PERTENECE A SEVILLA
  			WHEN xDelegacion = 'Sevilla' THEN
    			INSERT INTO platano4.sucursal
          VALUES (xCodSucursal, xNombre, xCiudad, xCCAA, xDirector);
  		END CASE;
    DBMS_OUTPUT.PUT_LINE ('LA NUEVA SUCURSAL ' || xNombre || ' SE HA DADO DE ALTA CON EXITO');
  END IF;
END PR_INS_SUCURSAL;
/

-- 6. CAMBIAR EL DIRECTOR DE UNA SUCURSAL. ESTA OPERACIÓN DEBE SERVIR TAMBIÉN
-- PARA NOMBRAR DIRECTOR INICIAL DE UNA SUCURSAL.
-- ARGUMENTOS: CÓDIGO DE SUCURSAL Y EK CÓDIGO DE EMPLEADO QUE SERÁ NUEVO
-- (O PRIMER) DIRECTOR.

CREATE OR REPLACE PROCEDURE PR_DIR_SUCURSAL
(xCodSucursal sucursal.codSucursal%TYPE, xCodEmpleado empleado.codEmpleado%TYPE)
IS
  xCont NUMBER(1);
  xDelegacion VARCHAR(50);
  xCA_sucursal Sucursal.CA_sucursal%TYPE;
BEGIN
  -- COMPROBAMOS SI EXISTE SUCURSALES HAY CON ESE NUMERO
  SELECT COUNT (*) INTO xCont FROM v_sucursal WHERE codSucursal = xCodSucursal;
  IF(xCont = 0) THEN
    RAISE_APPLICATION_ERROR(-20110, 'NO HAY UNA SUCURSAL CON ESE CÓDIGO');
  END IF;

  -- COMPROBAMOS SI EXISTE UN EMPLEADO CON ESE NUMERO
  SELECT COUNT (*) INTO xCont FROM v_empleado WHERE codEmpleado = xCodEmpleado;
  IF(xCont = 0) THEN
    RAISE_APPLICATION_ERROR(-20111, 'NO HAY NINGÚN EMPLEADO CON ESE CÓDIGO');
  END IF;

  -- OBTENEMOS LA DELEGACIÓN DE LA SUCURSAL PARA REALIZAR LA MODIFICACIÓN
  SELECT CA_sucursal INTO xCA_Sucursal FROM v_sucursal WHERE codSucursal = xCodSucursal;

  PR_GET_DELEGACION(xDelegacion, xCA_Sucursal);
  CASE
    -- SI LA DELEGACIÓN PERTENECE A MADRID
    WHEN xDelegacion = 'Madrid' THEN
      UPDATE platano1.sucursal SET director_sucursal = xCodEmpleado WHERE codSucursal = xCodSucursal;

    -- SI LA DELEGACIÓN PERTENECE A BARCELONA
    WHEN xDelegacion = 'Barcelona' THEN
      UPDATE platano2.sucursal SET director_sucursal = xCodEmpleado WHERE codSucursal = xCodSucursal;

    -- SI LA DELEGACIÓN PERTENECE A LA CORUÑA
    WHEN xDelegacion = 'La Coruña' THEN
      UPDATE platano3.sucursal SET director_sucursal = xCodEmpleado WHERE codSucursal = xCodSucursal;

    -- SI LA DELEGACIÓN PERTENECE A SEVILLA
    WHEN xDelegacion = 'Sevilla' THEN
      UPDATE platano4.sucursal SET director_sucursal = xCodEmpleado WHERE codSucursal = xCodSucursal;
  END CASE;
  DBMS_OUTPUT.PUT_LINE('EL EMPLEADO ' || xCodEmpleado || ' HA SIDO ASIGNADO A LA DIRECCION DE LA SUCURSAL ' || xCodSucursal || ' CORRECTAMENTE.');
END PR_DIR_SUCURSAL;
/

-- 7. DAR DE ALTA UN NUEVO CLIENTE.
-- ARGUMENTOS: CÓDIGO DE CLIENTE, DNI (O CIF), NOMBRE, DIRECCIÓN, TIPO Y
-- COMUNIDAD AUTÓNOMA.

CREATE OR REPLACE PROCEDURE PR_INS_CLIENTE
(xCodCliente cliente.codCliente%TYPE, xDNI cliente.DNI_cliente%TYPE, xNombre cliente.nombre_cliente%TYPE,
xDireccion cliente.direccion_cliente%TYPE, xTipoCliente cliente.tipo_cliente%TYPE, xCCAA cliente.CA_cliente%TYPE)
IS
  xCont NUMBER(8);
  xDelegacion VARCHAR(50);
BEGIN

  -- VEMOS SI EL CLIENTE EXISTE EN EL SISTEMA.
  SELECT COUNT (*) INTO xCont FROM v_cliente WHERE codCliente = xCodCliente;

  IF (xCont <> 0) THEN -- SI EL CODIGO DEL CLIENTE EXISTE
    RAISE_APPLICATION_ERROR(-20104, 'YA EXISTE UN CLIENTE CON ESE CÓDIGO');
  ELSE

    -- OBTENEMOS LA DELEGACIÓN EN LA QUE SE INCLUIRÁ EL CLIENTE.
    PR_GET_DELEGACION(xDelegacion, xCCAA);

    CASE
      -- SI LA DELEGACIÓN PERTENECE A MADRID
      WHEN xDelegacion = 'Madrid' THEN
        INSERT INTO platano1.cliente VALUES (xCodCliente, xDNI, xNombre, xDireccion, xTipoCliente, xCCAA);

      -- SI LA DELEGACIÓN PERTENECE A BARCELONA
      WHEN xDelegacion = 'Barcelona' THEN
        INSERT INTO platano2.cliente VALUES (xCodCliente, xDNI, xNombre, xDireccion, xTipoCliente, xCCAA);

      -- SI LA DELEGACIÓN PERTENECE A LA CORUÑA
      WHEN xDelegacion = 'La Coruña' THEN
        INSERT INTO platano3.cliente VALUES (xCodCliente, xDNI, xNombre, xDireccion, xTipoCliente, xCCAA);

      -- SI LA DELEGACIÓN PERTENECE A SEVILLA
      WHEN xDelegacion = 'Sevilla' THEN
        INSERT INTO platano4.cliente VALUES (xCodCliente, xDNI, xNombre, xDireccion, xTipoCliente, xCCAA);
    END CASE;
    DBMS_OUTPUT.PUT_LINE('EL CLIENTE ' || xNombre ||' HA SIDO DADO DE ALTA CORRECTAMENTE.');
  END IF;
END PR_INS_CLIENTE;
/

-- 8. DAR DE ALTA O ACTUALIZAR UN SUMINISTRO.
-- ARGUMENTOS: CÓDIGO DEL CLIENTE, CÓDIGO DE LA SUCURSAL QUE VA A GESTIONAR EL
-- SUMINISTRO, CÓDIGO DE VINO A SUMINISTRAR, FECHA DE SOLICITUD DE SUMINISTRO Y
-- CANTIDAD A SUMINISTRAR. SI EXISTIERA UNA SOLICITUD DE SUMINISTRO A LA MISMA
-- SUCURSAL, DEL MISMO VINO Y EN LA MISMA FECHA, SE ACTUALIZARÍA EN LA FORMA
-- ADECUADA LA CANTIDAD A SUMINISTRAR.

CREATE OR REPLACE PROCEDURE PR_INS_SUMINISTRO
(xCodcliente cliente.codCliente%TYPE, xCodSucursal sucursal.codSucursal%TYPE,
xCodVino vino.codVino%TYPE, xFecha ClienteSolicitaVinoASucursal.fecha%TYPE, xCantidad ClienteSolicitaVinoASucursal.cantidad%TYPE)
IS
  xCont NUMBER(8);
  xCCAA cliente.CA_cliente%TYPE;
  xCCAA2 cliente.CA_cliente%TYPE;
  xDelegacion VARCHAR(50);
  xDelegacionVino VARCHAR(50);
BEGIN

  -- COMPROBAMOS SI EXISTE EL CLIENTE
  SELECT COUNT(*) INTO xCont FROM v_cliente WHERE codCliente = xCodCliente;
  IF (xCont = 0) THEN
    RAISE_APPLICATION_ERROR (-20108, 'NO SE HA ENCONTRADO UN CLIENTE CON ESE CÓDIGO');
  END IF;

  -- COMPROBAMOS SI EXISTE EL VINO
  SELECT COUNT(*) INTO xCont FROM v_vino WHERE codVino = xCodVino;
  IF (xCont = 0) THEN
    RAISE_APPLICATION_ERROR (-20109, 'NO SE HA ENCONTRADO UN VINO CON ESE CÓDIGO');
  END IF;

  -- COMPROBAMOS SI EXISTE LA SUCURSAL
  SELECT COUNT(*) INTO xCont FROM v_sucursal WHERE codSucursal = xCodSucursal;
  IF (xCont = 0) THEN
    RAISE_APPLICATION_ERROR (-20109, 'NO SE HA ENCONTRADO UNA SUCURSAL CON ESE CÓDIGO');
  END IF;

  --  SELECCIONAMOS LA COMUNIDAD AUTÓNOMA DEL CLIENTE.
  SELECT CA_cliente INTO xCCAA FROM v_cliente WHERE codCliente = xCodCliente;

  PR_GET_DELEGACION(xDelegacion, xCCAA); -- OBTENEMOS LA DELEGACIÓN

  --  SELECCIONAMOS LA COMUNIDAD AUTÓNOMA DEL VINO.
  SELECT CA_vino INTO xCCAA2 FROM v_vino WHERE codVino = xCodVino;

  PR_GET_DELEGACION(xDelegacionVino, xCCAA2); -- OBTENEMOS LA DELEGACIÓN DEL VINO

  -- COMPROBAMOS QUE NO EXISTE OTRO PEDIDO IGUAL
  SELECT COUNT(*) INTO xCont FROM v_ClienteSolicitaVinoASucursal
    WHERE codCliente = xCodCliente
    AND codSucursal = xCodSucursal
    AND codVino = xCodVino
    AND fecha = xFecha;

  IF (xCont > 0) THEN -- SI EXISTE UN PEDIDO CON ESA FECHA PARA ESE CLIENTE EN
        -- ESA SUCURSAL DE UN MISMO VINO, ACTUALIZAMOS

  -- DISMINUIMOS EL STOCK DISPONIBLE DE ESE VINO EN SU LOCALIDAD.
    IF xDelegacionVino = 'Madrid' THEN
      UPDATE platano1.vino SET cantidad_stock = cantidad_stock - xCantidad WHERE codVino = xCodVino;
    ELSE
      IF xDelegacionVino = 'Barcelona' THEN
        UPDATE platano2.vino SET cantidad_stock = cantidad_stock - xCantidad WHERE codVino = xCodVino;
      ELSE
        IF xDelegacionVino = 'La Coruña' THEN
          UPDATE platano3.vino SET cantidad_stock = cantidad_stock - xCantidad WHERE codVino = xCodVino;
        ELSE
          UPDATE platano4.vino SET cantidad_stock = cantidad_stock - xCantidad WHERE codVino = xCodVino;
        END IF;
      END IF;
    END IF;

    CASE
      -- SI LA DELEGACIÓN PERTENECE A MADRID
      WHEN xDelegacion = 'Madrid' THEN
        -- SUMAMOS LA CANTIDAD QUE HABÍA A LA QUE SE VUELVE A PEDIR
        UPDATE platano1.ClienteSolicitaVinoASucursal
        SET cantidad = cantidad + xCantidad
        WHERE codCliente = xCodCliente
        AND codSucursal = xCodSucursal
        AND codVino = xCodVino
        AND fecha = xFecha;

      -- SI LA DELEGACIÓN PERTENECE A BARCELONA
      WHEN xDelegacion = 'Barcelona' THEN
        -- SUMAMOS LA CANTIDAD QUE HABÍA A LA QUE SE VUELVE A PEDIR
        UPDATE platano2.ClienteSolicitaVinoASucursal
        SET cantidad = cantidad + xCantidad
        WHERE codCliente = xCodCliente
        AND codSucursal = xCodSucursal
        AND codVino = xCodVino
        AND fecha = xFecha;

      -- SI LA DELEGACIÓN PERTENECE A LA CORUÑA
      WHEN xDelegacion = 'La Coruña' THEN
        -- SUMAMOS LA CANTIDAD QUE HABÍA A LA QUE SE VUELVE A PEDIR
        UPDATE platano3.ClienteSolicitaVinoASucursal
        SET cantidad = cantidad + xCantidad
        WHERE codCliente = xCodCliente
        AND codSucursal = xCodSucursal
        AND codVino = xCodVino
        AND fecha = xFecha;

      -- SI LA DELEGACIÓN PERTENECE A SEVILLA
      WHEN xDelegacion = 'Sevilla' THEN
        -- SUMAMOS LA CANTIDAD QUE HABÍA A LA QUE SE VUELVE A PEDIR
        UPDATE platano4.ClienteSolicitaVinoASucursal
        SET cantidad = cantidad + xCantidad
        WHERE codCliente = xCodCliente
        AND codSucursal = xCodSucursal
        AND codVino = xCodVino
        AND fecha = xFecha;

    END CASE;
    DBMS_OUTPUT.PUT_LINE('YA EXISTÍA ESE PEDIDO. LA CANTIDAD SE ACTUALIZÓ CORRECTAMENTE.');
  ELSE  -- NO EXISTE UN PEDIDO DE ESE VINO POR ESE CLIENTE, EN ESA FECHA, A ESA SUCURSAL,
                  -- ENTONCES INSERTAMOS.
    -- DISMINUIMOS EL STOCK DISPONIBLE DE ESE VINO.
    IF xDelegacionVino = 'Madrid' THEN
      UPDATE platano1.vino SET cantidad_stock = cantidad_stock - xCantidad WHERE codVino = xCodVino;
    ELSE
      IF xDelegacionVino = 'Barcelona' THEN
        UPDATE platano2.vino SET cantidad_stock = cantidad_stock - xCantidad WHERE codVino = xCodVino;
      ELSE
        IF xDelegacionVino = 'La Coruña' THEN
          UPDATE platano3.vino SET cantidad_stock = cantidad_stock - xCantidad WHERE codVino = xCodVino;
        ELSE
          UPDATE platano4.vino SET cantidad_stock = cantidad_stock - xCantidad WHERE codVino = xCodVino;
        END IF;
      END IF;
    END IF;
    CASE
      -- SI LA DELEGACIÓN PERTENECE A MADRID
      WHEN xDelegacion = 'Madrid' THEN
        -- INSERTAMOS EL NUEVO PEDIDO.
        INSERT INTO platano1.ClienteSolicitaVinoASucursal
        VALUES (xCodCliente, xCodSucursal, xCodVino, xFecha, xCantidad);

      -- SI LA DELEGACIÓN PERTENECE A BARCELONA
      WHEN xDelegacion = 'Barcelona' THEN
        -- INSERTAMOS EL NUEVO PEDIDO.
        INSERT INTO platano2.ClienteSolicitaVinoASucursal
        VALUES (xCodCliente, xCodSucursal, xCodVino, xFecha, xCantidad);

      -- SI LA DELEGACIÓN PERTENECE A LA CORUÑA
      WHEN xDelegacion = 'La Coruña' THEN
        -- INSERTAMOS EL NUEVO PEDIDO.
        INSERT INTO platano3.ClienteSolicitaVinoASucursal
        VALUES (xCodCliente, xCodSucursal, xCodVino, xFecha, xCantidad);

      -- SI LA DELEGACIÓN PERTENECE A SEVILLA
      WHEN xDelegacion = 'Sevilla' THEN
        -- INSERTAMOS EL NUEVO PEDIDO.
        INSERT INTO platano4.ClienteSolicitaVinoASucursal
        VALUES (xCodCliente, xCodSucursal, xCodVino, xFecha, xCantidad);

    END CASE;
    DBMS_OUTPUT.PUT_LINE('EL PEDIDO SE HA REALIZADO CORRECTAMENTE.');
  END IF;
END PR_INS_SUMINISTRO;
/

-- 9. DAR DE BAJA SUMINISTROS.
-- ARGUMENTOS: CÓDIGO DE CLIENTE, CÓDIGO DE LA SUCURSAL QUE GESTIONÓ EL
-- SUMINISTRO, CÓDIGO DEL VINO QUE SE SUMINISTRÓ Y, OPCIONALMENTE, FECHA DEL
-- SUMINISTRO. SI ESTE ÚLTIMO ARGUMENTO NO SE INDICA, SE ELIMINARÁN TODOS LOS
-- SUMINISTROS DE ESE VINO PROPORCIONADOS POR LA SUCURSAL AL CLIENTE EN
-- CUALQUIER FECHA.

CREATE OR REPLACE PROCEDURE PR_DEL_REALIZAPEDIDO
(xCodcliente cliente.codCliente%TYPE, xCodSucursal sucursal.codSucursal%TYPE,
xCodVino vino.codVino%TYPE, xFecha ClienteSolicitaVinoASucursal.fecha%TYPE DEFAULT NULL)
IS
  xCCAA cliente.CA_cliente%TYPE;
  xDelegacion VARCHAR(50);
  xCont NUMBER(8);
BEGIN

    -- COMPROBAMOS SI EXISTE OTRO PEDIDO DE ESE VINO, POR ESE CLIENTE EN ESA SUCURSAL
    SELECT COUNT(*) INTO xCont FROM v_ClienteSolicitaVinoASucursal
      WHERE codCliente = xCodCliente
      AND codSucursal = xCodSucursal
      AND codVino = xCodVino;

    IF (xCont = 0) THEN -- SI NO EXISTE UN PEDIDO PARA ESE CLIENTE EN ESA SUCURSAL
        -- DE ESE MISMO VINO
      RAISE_APPLICATION_ERROR(-20103,'NO EXISTE NINGUN SUMINISTRO PARA ESE
          CLIENTE EN ESA SUCURSAL PARA ESE VINO.');
    ELSE
      --  SELECCIONAMOS LA COMUNIDAD AUTÓNOMA DE LA SUCURSAL.
      SELECT CA_cliente INTO xCCAA FROM v_cliente WHERE codCliente = xCodCliente;

      PR_GET_DELEGACION(xDelegacion, xCCAA); -- OBTENEMOS LA DELEGACIÓN

      IF (xFecha IS NULL) THEN -- BORRAMOS TODOS LOS PEDIDOS DE ESE CLIENTE, DE ESE VINO
                  -- EN ESA SUCURSAL
        CASE
          -- SI LA DELEGACIÓN PERTENECE A MADRID
          WHEN xDelegacion = 'Madrid' THEN
            DELETE FROM platano1.ClienteSolicitaVinoASucursal
            WHERE codCliente = xCodCliente
            AND codSucursal = xCodSucursal
            AND codVino = xCodVino;

          -- SI LA DELEGACIÓN PERTENECE A BARCELONA
          WHEN xDelegacion = 'Barcelona' THEN
            DELETE FROM platano2.ClienteSolicitaVinoASucursal
            WHERE codCliente = xCodCliente
            AND codSucursal = xCodSucursal
            AND codVino = xCodVino;

          -- SI LA DELEGACIÓN PERTENECE A LA CORUÑA
          WHEN xDelegacion = 'La Coruña' THEN
            DELETE FROM platano3.ClienteSolicitaVinoASucursal
            WHERE codCliente = xCodCliente
            AND codSucursal = xCodSucursal
            AND codVino = xCodVino;

          -- SI LA DELEGACIÓN PERTENECE A SEVILLA
          WHEN xDelegacion = 'Sevilla' THEN
            DELETE FROM platano4.ClienteSolicitaVinoASucursal
            WHERE codCliente = xCodCliente
            AND codSucursal = xCodSucursal
            AND codVino = xCodVino;
        END CASE;
      DBMS_OUTPUT.PUT_LINE('SE BORRARON TODOS LOS PEDIDOS DE ESE CLIENTE A ESA SUCURSAL SOBRE ESE VINO.');

      ELSE  -- SI SE HA INTRODUCIDO LA FECHA.
        CASE
          -- SI LA DELEGACIÓN PERTENECE A MADRID
          WHEN xDelegacion = 'Madrid' THEN
            DELETE FROM platano1.ClienteSolicitaVinoASucursal
            WHERE codCliente = xCodCliente
            AND codSucursal = xCodSucursal
            AND codVino = xCodVino
            AND fecha = xFecha;

          -- SI LA DELEGACIÓN PERTENECE A BARCELONA
          WHEN xDelegacion = 'Barcelona' THEN
            DELETE FROM platano2.ClienteSolicitaVinoASucursal
            WHERE codCliente = xCodCliente
            AND codSucursal = xCodSucursal
            AND codVino = xCodVino
            AND fecha = xFecha;

          -- SI LA DELEGACIÓN PERTENECE A LA CORUÑA
          WHEN xDelegacion = 'La Coruña' THEN
            DELETE FROM platano3.ClienteSolicitaVinoASucursal
            WHERE codCliente = xCodCliente
            AND codSucursal = xCodSucursal
            AND codVino = xCodVino
            AND fecha = xFecha;

          -- SI LA DELEGACIÓN PERTENECE A SEVILLA
          WHEN xDelegacion = 'Sevilla' THEN
            DELETE FROM platano4.ClienteSolicitaVinoASucursal
            WHERE codCliente = xCodCliente
            AND codSucursal = xCodSucursal
            AND codVino = xCodVino
            AND fecha = xFecha;

        END CASE;
      DBMS_OUTPUT.PUT_LINE('SE HA BORRADO EL PEDIDO DE ESE CLIENTE EN ESA SUCURSAL EN ESA FECHA SOBRE ESE VINO.');
      END IF;
    END IF;
END PR_DEL_REALIZAPEDIDO;
/


-- 10. DAR DE ALTA UN PEDIDO DE UNA SUCURSAL.
-- ARGUMENTOS: CÓDIGO DE LA SUCURSAL QUE REALIZA EL PEDIDO, CÓDIGO DE LA
-- SUCURSAL QUE RECIBE EL PEDIDO, CÓDIGO DEL VINO, FECHA DE PEDIDO Y CANTIDAD
-- PEDIDA

CREATE OR REPLACE PROCEDURE PR_INS_PEDIDOSUC
(xCodSucPide SucursalSolicitaSucursal.codSucursalPide%TYPE, xCodSucPedido SucursalSolicitaSucursal.codSucursalPedido%TYPE,
xCodVino SucursalSolicitaSucursal.codVino%TYPE, xFecha SucursalSolicitaSucursal.fecha%TYPE, xCantidad SucursalSolicitaSucursal.cantidad%TYPE)
IS
  xCont NUMBER(8);
BEGIN

  -- OBTENEMOS SI EXISTEN MÁS SUMINISTROS CON LA MISMA CLAVE.
  SELECT COUNT(*) INTO xCont
  FROM SucursalSolicitaSucursal
  WHERE codSucursalPide = xCodSucPide AND codSucursalPedido = xCodSucPedido
    AND codVino = xCodVino AND Fecha = xFecha;

  IF (xCont > 0) THEN -- SI EXISTE UN PEDIDO CON ESA FECHA DE UNA SUCURSAL A OTRA DE ESE VINO, ACTUALIZAMOS.

      -- SUMAMOS LA CANTIDAD QUE HABÍA A LA QUE SE VUELVE A PEDIR
      UPDATE platano1.SucursalSolicitaSucursal
      SET cantidad = cantidad + xCantidad
      WHERE CodSucursalPide = xCodSucPide
      AND codSucursalPedido = xCodSucPedido
      AND codvino = xCodVino
      AND fecha = xFecha;

      -- SUMAMOS LA CANTIDAD QUE HABÍA A LA QUE SE VUELVE A PEDIR
      UPDATE platano2.SucursalSolicitaSucursal
      SET cantidad = cantidad + xCantidad
      WHERE CodSucursalPide = xCodSucPide
      AND codSucursalPedido = xCodSucPedido
      AND codvino = xCodVino
      AND fecha = xFecha;

      -- SUMAMOS LA CANTIDAD QUE HABÍA A LA QUE SE VUELVE A PEDIR
      UPDATE platano3.SucursalSolicitaSucursal
      SET cantidad = cantidad + xCantidad
      WHERE CodSucursalPide = xCodSucPide
      AND codSucursalPedido = xCodSucPedido
      AND codvino = xCodVino
      AND fecha = xFecha;

      -- SUMAMOS LA CANTIDAD QUE HABÍA A LA QUE SE VUELVE A PEDIR
      UPDATE platano4.SucursalSolicitaSucursal
      SET cantidad = cantidad + xCantidad
      WHERE CodSucursalPide = xCodSucPide
      AND codSucursalPedido = xCodSucPedido
      AND codvino = xCodVino
      AND fecha = xFecha;

    DBMS_OUTPUT.PUT_LINE('YA EXISTÍA ESE PEDIDO. LA CANTIDAD SE ACTUALIZÓ CORRECTAMENTE.');
  ELSE  -- NO EXISTE UN PEDIDO DE ESE VINO POR ESE CLIENTE, EN ESA FECHA A ESA SUCURSAL.

        -- INSERTAMOS EL NUEVO PEDIDO.
        INSERT INTO platano1.SucursalSolicitaSucursal
        VALUES (xCodSucPide, xcodSucPedido, xcodVino, xFecha, xCantidad);

        -- INSERTAMOS EL NUEVO PEDIDO.
        INSERT INTO platano2.SucursalSolicitaSucursal
        VALUES (xCodSucPide, xcodSucPedido, xcodVino, xFecha, xCantidad);

        -- INSERTAMOS EL NUEVO PEDIDO.
        INSERT INTO platano3.SucursalSolicitaSucursal
        VALUES (xCodSucPide, xcodSucPedido, xcodVino, xFecha, xCantidad);

        -- INSERTAMOS EL NUEVO PEDIDO.
        INSERT INTO platano4.SucursalSolicitaSucursal
        VALUES (xCodSucPide, xcodSucPedido, xcodVino, xFecha, xCantidad);

    DBMS_OUTPUT.PUT_LINE('EL PEDIDO A LA OTRA SUCURSAL SE HA REALIZADO CORRECTAMENTE.');
  END IF;
END PR_INS_PEDIDOSUC;
/

-- 11. DAR DE BAJA PEDIDOS DE UNA SUCURSAL.
-- ARGUMENTOS: CÓDIGO DE LA SUCURSAL QUE REALIZÓ EL PEDIDO, CÓDIGO DE LA
-- SUCURSAL QUE RECIBIÓ EL PEDIDO, CÓDIGO DEL VINO QUE SE SOLICITÓ Y,
-- OPCIONALMENTE, FECHA DEL PEDIDO. SI ESTE ÚLTIMO ARGUMENTOS NO SE INDICA, SE
-- ELIMINARÁN TODOS LOS PEDIDOS DE ESE VINO SOLICITADOS POR LA SUCURSAL A OTRA
-- SUCURSAL

CREATE OR REPLACE PROCEDURE PR_DEL_PEDIDOSUC
(xCodSucPide SucursalSolicitaSucursal.codSucursalPide%TYPE, xCodSucPedido SucursalSolicitaSucursal.codSucursalPedido%TYPE,
xCodVino SucursalSolicitaSucursal.codvino%TYPE, xFecha SucursalSolicitaSucursal.fecha%TYPE DEFAULT NULL)
IS

  xCont NUMBER(8);
BEGIN
  -- COMPROBAMOS SI EXISTE EL PEDIDO DE UNA SUCURSAL A OTRA
  SELECT COUNT(*) INTO xCont FROM SucursalSolicitaSucursal
    WHERE CodSucursalPide = xCodSucPide
    AND CodSucursalPedido = xCodSucPedido
    AND codvino = xCodVino;

  IF (xCont = 0) THEN -- SI NO EXISTE UN PEDIDO ENTRE ESAS SUCURSALES DE ESE MISMO VINO
    RAISE_APPLICATION_ERROR(-20104,'NO EXISTE NINGÚN PEDIDO ENTRE ESAS SUCURSALES SOBRE ESE VINO.');
  ELSE


    IF (xFecha IS NULL) THEN -- BORRAMOS TODOS LOS PEDIDOS DE ESAS SUCURSALES DE ESE VINO

        DELETE FROM platano1.SucursalSolicitaSucursal
        WHERE CodSucursalPide = xCodSucPide
        AND CodSucursalPedido = xCodSucPedido
        AND codvino = xCodVino;

        DELETE FROM platano2.SucursalSolicitaSucursal
        WHERE CodSucursalPide = xCodSucPide
        AND CodSucursalPedido = xCodSucPedido
        AND codvino = xCodVino;

        DELETE FROM platano3.SucursalSolicitaSucursal
        WHERE CodSucursalPide = xCodSucPide
        AND CodSucursalPedido = xCodSucPedido
        AND codvino = xCodVino;

        DELETE FROM platano4.SucursalSolicitaSucursal
        WHERE CodSucursalPide = xCodSucPide
        AND CodSucursalPedido = xCodSucPedido
        AND codvino = xCodVino;


    DBMS_OUTPUT.PUT_LINE('SE BORRARON TODOS LOS PEDIDOS ENTRE ESAS SUCURSALES SOBRE ESE VINO.');

    ELSE  -- SI SE HA INTRODUCIDO LA FECHA.
      -- COMPROBAMOS QUE EXISTE UN PEDIDO EN ESA FECHA
      SELECT COUNT(*) INTO xCont FROM SucursalSolicitaSucursal
          WHERE CodSucursalPide = xCodSucPide
          AND CodSucursalPedido = xCodSucPedido
          AND codvino = xCodVino
          AND fecha = xFecha;
      IF (xCont = 0) THEN -- SI NO EXISTE PEDIDO EN ESA FECHA
        RAISE_APPLICATION_ERROR (-20044, 'NO EXISTE UN PEDIDO A ESA SUCURSAL EN ESA FECHA');
      END IF;

          DELETE FROM platano1.SucursalSolicitaSucursal
          WHERE CodSucursalPide = xCodSucPide
          AND CodSucursalPedido = xCodSucPedido
          AND codvino = xCodVino
          AND fecha = xFecha;

          DELETE FROM platano2.SucursalSolicitaSucursal
          WHERE CodSucursalPide = xCodSucPide
          AND CodSucursalPedido = xCodSucPedido
          AND codvino = xCodVino
          AND fecha = xFecha;

          DELETE FROM platano3.SucursalSolicitaSucursal
          WHERE CodSucursalPide = xCodSucPide
          AND CodSucursalPedido = xCodSucPedido
          AND codvino = xCodVino
          AND fecha = xFecha;

          DELETE FROM platano4.SucursalSolicitaSucursal
          WHERE CodSucursalPide = xCodSucPide
          AND CodSucursalPedido = xCodSucPedido
          AND codvino = xCodVino
          AND fecha = xFecha;

    DBMS_OUTPUT.PUT_LINE('SE HA BORRADO EL PEDIDO ENTRE ESAS SUCURSALES EN ESA FECHA SOBRE ESE VINO.');
    END IF;
  END IF;
END PR_DEL_PEDIDOSUC;
/

-- 12. DAR DE ALTA UN NUEVO VINO:
-- ARGUMENTOS: CÓDIGO DE VINO, MARCA, AÑO DE COSECHA, DENOMINACIÓN DE ORIGEN
-- (SI LA TIENE), GRADUACIÓN, VIÑEDO DE PROCEDENCIA, COMUNIDAD AUTÓNOMA,
-- CANTIDAD PRODUCIDA Y CÓDIGO DE PRODUCTOR. SERÁ NECESARIO TAMBIÉN ALMACENAR EL
-- STOCK (INICIALMENTE ES LA CANTIDAD PRODUCIDA)

CREATE OR REPLACE PROCEDURE PR_INS_VINO
(xCodVino vino.codvino%TYPE, xMarca vino.marca_vino%TYPE, xAnio vino.anyo_vino%TYPE,
xDenominacion vino.denominacion_origen%TYPE DEFAULT NULL, xGraduacion vino.graduacion%TYPE,
xVinedo vino.vinedo_procedencia%TYPE, xCCAA vino.CA_vino%TYPE, xCantidad vino.cantidad_producida%TYPE,
xCodProductor productor.codProductor%TYPE)
IS
  xCont NUMBER(8);
  xDelegacion VARCHAR(50);
BEGIN

    -- VEMOS SI EL VINO EXISTE EN EL SISTEMA.
  SELECT COUNT (*) INTO xCont FROM v_vino WHERE codvino = xCodVino;

  IF (xCont <> 0) THEN -- SI EL CODIGO DEL VINO EXISTE
    RAISE_APPLICATION_ERROR(-20104, 'YA EXISTE UN VINO CON ESE CÓDIGO');
  ELSE

    -- OBTENEMOS LA DELEGACIÓN EN LA QUE SE INCLUIRÁ EL VINO.
    PR_GET_DELEGACION(xDelegacion, xCCAA);

    CASE
      -- SI LA DELEGACIÓN PERTENECE A MADRID
      WHEN xDelegacion = 'Madrid' THEN
        INSERT INTO platano1.vino VALUES (xCodVino, xMarca, xAnio, xDenominacion, xGraduacion,
          xCantidad, xCCAA, xVinedo, xCantidad, xCodProductor); -- INSERTAMOS

      -- SI LA DELEGACIÓN PERTENECE A BARCELONA
      WHEN xDelegacion = 'Barcelona' THEN
        INSERT INTO platano2.vino VALUES (xCodVino, xMarca, xAnio, xDenominacion, xGraduacion,
          xCantidad, xCCAA, xVinedo, xCantidad, xCodProductor); -- INSERTAMOS

      -- SI LA DELEGACIÓN PERTENECE A LA CORUÑA
      WHEN xDelegacion = 'La Coruña' THEN
        INSERT INTO platano3.vino VALUES (xCodVino, xMarca, xAnio, xDenominacion, xGraduacion,
          xCantidad, xCCAA, xVinedo, xCantidad, xCodProductor); -- INSERTAMOS

      -- SI LA DELEGACIÓN PERTENECE A SEVILLA
      WHEN xDelegacion = 'Sevilla' THEN
        INSERT INTO platano4.vino VALUES (xCodVino, xMarca, xAnio, xDenominacion, xGraduacion,
          xCantidad, xCCAA, xVinedo, xCantidad, xCodProductor); -- INSERTAMOS

    END CASE;
    DBMS_OUTPUT.PUT_LINE('EL VINO ' || xMarca ||' HA SIDO DADO DE ALTA CORRECTAMENTE.');
  END IF;
END PR_INS_VINO;
/

-- 13. DAR DE BAJA UN VINO.
-- ARGUMENTOS: CÓDIGO DE VINO

CREATE OR REPLACE PROCEDURE PR_DEL_VINO(xCodVino vino.codvino%TYPE)
IS
  xCont NUMBER(8);
  xDelegacion VARCHAR(50);
  xCCAA vino.CA_vino%TYPE;
BEGIN

    -- VEMOS SI EL VINO EXISTE EN EL SISTEMA.
  SELECT COUNT (*) INTO xCont FROM v_vino WHERE codvino = xCodVino;

  IF (xCont = 0) THEN -- SI EL CODIGO DEL VINO NO EXISTE
    RAISE_APPLICATION_ERROR(-20105, 'EL VINO NO EXISTE EN EL SISTEMA.');
  ELSE
  SELECT CA_vino INTO xCCAA FROM v_vino WHERE codvino = xCodVino;

    -- OBTENEMOS LA DELEGACIÓN DEL VINO.

    PR_GET_DELEGACION(xDelegacion, xCCAA);

    CASE
      -- SI LA DELEGACIÓN PERTENECE A MADRID
      WHEN xDelegacion = 'Madrid' THEN
        DELETE FROM platano1.SucursalVendeVino WHERE codVino = xCodVino;
        DELETE FROM platano1.vino WHERE codVino = xCodVino;

      -- SI LA DELEGACIÓN PERTENECE A BARCELONA
      WHEN xDelegacion = 'Barcelona' THEN
        DELETE FROM platano2.SucursalVendeVino WHERE codVino = xCodVino;
        DELETE FROM platano2.vino WHERE codVino = xCodVino;

      -- SI LA DELEGACIÓN PERTENECE A LA CORUÑA
      WHEN xDelegacion = 'La Coruña' THEN
        DELETE FROM platano3.SucursalVendeVino WHERE codVino = xCodVino;
        DELETE FROM platano3.vino WHERE codVino = xCodVino;

      -- SI LA DELEGACIÓN PERTENECE A SEVILLA
      WHEN xDelegacion = 'Sevilla' THEN
        DELETE FROM platano4.SucursalVendeVino WHERE codVino = xCodVino;
        DELETE FROM platano4.vino WHERE codVino = xCodVino;

    END CASE;
    DBMS_OUTPUT.PUT_LINE('EL VINO ' || xCodVino ||' HA SIDO BORRADO CORRECTAMENTE.');
  END IF;
END PR_DEL_VINO;
/

-- 14. DAR DE ALTA UN PRODUCTOR.
-- ARGUMENTOS: CÓDIGO DE PRODUCTOR, DNI (o CIF), NOMBRE Y DIRECCIÓN.

CREATE OR REPLACE PROCEDURE PR_INS_PRODUCTOR
(xCodProductor productor.codProductor%TYPE, xDNI productor.DNI_productor%TYPE, xNombre productor.nombre_productor%TYPE,
xDireccion productor.direccion_productor%TYPE)
IS

BEGIN
  INSERT INTO platano1.productor VALUES (xCodProductor, xDNI, xNombre, xDireccion);
  INSERT INTO platano2.productor VALUES (xCodProductor, xDNI, xNombre, xDireccion);
  INSERT INTO platano3.productor VALUES (xCodProductor, xDNI, xNombre, xDireccion);
  INSERT INTO platano4.productor VALUES (xCodProductor, xDNI, xNombre, xDireccion);
  DBMS_OUTPUT.PUT_LINE('SE HA INSERTADO CORRECTAMENTE EL PRODUCTOR ' || xNombre);

END PR_INS_PRODUCTOR;
/


-- 15. DAR DE BAJA UN PRODUCTOR
-- ARGUMENTO: CÓDIGO DE PRODUCTOR

CREATE OR REPLACE PROCEDURE PR_DEL_PRODUCTOR (xCodProductor productor.codProductor%TYPE)
IS
  xCont NUMBER(8);
BEGIN

-- COMPROBAMOS SI EXISTE UN PRODUCTOR CON UN VINO EN EL SISTEMA.
  SELECT COUNT (*) INTO xCont FROM Productor WHERE codProductor = xCodProductor;

  IF (xCont=0) THEN   -- SI TIENE NINGÚN VINO ASIGNADO
    RAISE_APPLICATION_ERROR(-20106, 'EL PRODUCTOR NO EXISTE.');
  ELSE
    -- COMPROBAMOS QUE NO TIENE NINGÚN VINO DADO DE ALTA
    SELECT COUNT(*) INTO xCont FROM v_vino WHERE codProductor = xCodProductor;
    IF (xCont > 0) THEN
      RAISE_APPLICATION_ERROR(-20107, 'NO SE PUEDE BORRAR UN PRODUCTOR QUE TENGA UN VINO DADO DE ALTA');
    END IF;
    DELETE FROM platano1.productor WHERE codProductor = xCodProductor;
    DELETE FROM platano2.productor WHERE codProductor = xCodProductor;
    DELETE FROM platano3.productor WHERE codProductor = xCodProductor;
    DELETE FROM platano4.productor WHERE codProductor = xCodProductor;
    DBMS_OUTPUT.PUT_LINE('SE HA BORRADO CORRECTAMENTE EL PRODUCTOR ' || xCodProductor);
  END IF;
END PR_DEL_PRODUCTOR;
/


COMMIT;
/
