SET SERVEROUTPUT ON;

--------------------------------------------------------------------------------
----------------------- PROCEDIMIENTOS AUXILIARES ------------------------------
--------------------------------------------------------------------------------

-- CREACIÓN DE UN PROCEDIMIENTO QUE PASANDO COMO PARÁMETRO LA COMUNIDAD AUTÓNOMA
-- NOS INDIQUE A QUÉ DELEGACIÓN PERTENECE. NOS HARÁ FALTA EN ALGUNOS TRIGGERS

CREATE OR REPLACE PROCEDURE PR_GET_DELEGACION (xDelegacion OUT VARCHAR2, xCCAA Sucursal.CA_sucursal%TYPE)
IS

BEGIN
-- SI PERTENECE A LA DELEGACIÓN DE MADRID.
  IF (xCCAA = 'Castilla-León' OR xCCAA = 'Castilla-La Mancha' OR xCCAA = 'Aragón'
      OR xCCAA = 'Madrid' OR xCCAA = 'La Rioja') THEN
         xDelegacion := 'Madrid';

  ELSE  -- SI PERTENECE A LA DELEGACIÓN DE BARCELONA.
    IF (xCCAA = 'Cataluña' OR xCCAA = 'Baleares' OR xCCAA = 'País Valenciano'
      OR xCCAA = 'Murcia') THEN
      xDelegacion := 'Barcelona';

    ELSE -- SI PERTENECE A LA DELEGACIÓN DE LA CORUÑA.
      IF (xCCAA = 'Galicia' OR xCCAA = 'Asturias' OR xCCAA = 'Cantabria'
        OR xCCAA = 'País Vasco' OR xCCAA = 'Navarra') THEN
        xDelegacion := 'La Coruña';

      ELSE  -- SI PERTENECE A LA DELEGACIÓN DE SEVILLA.
        IF (xCCAA = 'Andalucía' OR xCCAA = 'Extremadura' OR xCCAA = 'Canarias'
            OR xCCAA = 'Ceuta' OR xCCAA = 'Melilla') THEN
          xDelegacion := 'Sevilla';

        ELSE  -- SI LA COMUNIDAD AUTONOMA NO ES CORRECTA.
          RAISE_APPLICATION_ERROR(-20204, 'LA COMUNIDAD NO ES CORRECTA.');
        END IF;
      END IF;
    END IF;
  END IF;
END PR_GET_DELEGACION;
/
