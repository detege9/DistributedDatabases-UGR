SET SERVEROUTPUT ON;

SELECT * FROM SUCURSALSOLICITASUCURSAL;
SELECT * FROM VINO;
SELECT * FROM V_VINO;

BEGIN
PR_INS_PEDIDOSUC(4, 5, 4, TO_DATE('12-06-2019', 'DD/MM/YYYY'), 100);
END;
/