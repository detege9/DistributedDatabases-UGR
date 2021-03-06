DROP VIEW v_Cliente;
DROP VIEW v_Empleado;
DROP VIEW v_Productor;
DROP VIEW v_ClienteSolicitaVinoASucursal;
DROP VIEW v_Sucursal;
DROP VIEW v_SucursalVendeVino;
DROP VIEW v_Vino;


DROP TABLE SucursalVendeVino CASCADE CONSTRAINTS;
DROP TABLE ClienteSolicitaVinoASucursal CASCADE CONSTRAINTS;
DROP TABLE SucursalSolicitaSucursal CASCADE CONSTRAINTS;
DROP TABLE Sucursal CASCADE CONSTRAINTS;
DROP TABLE Productor CASCADE CONSTRAINTS;
DROP TABLE Vino CASCADE CONSTRAINTS;
DROP TABLE Empleado CASCADE CONSTRAINTS;
DROP TABLE Cliente CASCADE CONSTRAINTS;

DROP TRIGGER TR_PK_CLIENTE;
DROP TRIGGER TR_PK_CLIENTESOLICITA;
DROP TRIGGER TR_PK_EMPLEADO;
DROP TRIGGER TR_PK_PRODUCTOR;
DROP TRIGGER TR_PK_SUCURSAL;
DROP TRIGGER TR_PK_SUCURSAL_SUCURSAL;
DROP TRIGGER TR_PK_SUCURSALVENDEVINO;
DROP TRIGGER TR_PK_VINO;
DROP TRIGGER PR_INS_VIN_REALSUC;
DROP TRIGGER TR_DEL_PROV;
DROP TRIGGER TR_DIREC_EMPL_UNIQUE;
DROP TRIGGER TR_DIRECTOR_EMPLEADO;
DROP TRIGGER TR_FECHA_SUCUR_CLI;
DROP TRIGGER TR_FECHA_SUCURSALES;
DROP TRIGGER TR_FK_CLI_PED;
DROP TRIGGER TR_FK_EMP_SUC;
DROP TRIGGER TR_FK_PED_CLI;
DROP TRIGGER TR_FK_PED_SUC;
DROP TRIGGER TR_FK_PED_VIN;
DROP TRIGGER TR_FK_SUC_PED;
DROP TRIGGER TR_FK_SUC_SUCPEDIDO;
DROP TRIGGER TR_FK_SUC_SUCPIDE;
DROP TRIGGER TR_FK_SUCPEDIDO_PED;
DROP TRIGGER TR_FK_SUCPIDE_PED;

DROP TRIGGER TR_FK_VIN_PED;
DROP TRIGGER TR_INS_PROD_VINO;
DROP TRIGGER TR_PED_CLI_FEC_SUMI;
DROP TRIGGER TR_PED_SUC_A_SUC;
DROP TRIGGER TR_PED_SUC_CANT_INS;
DROP TRIGGER TR_PIDE_OTRA_SUCURSAL;
DROP TRIGGER TR_SALARIO_EMP;
DROP TRIGGER TR_SUCURSAL_EMP;
DROP TRIGGER TR_SUCURSAL_PED_CLI;
DROP TRIGGER TR_TIPO_CLI;
DROP TRIGGER TR_VINO_DELETE;
DROP TRIGGER TR_VINO_PROD;
DROP TRIGGER TR_VINO_STOCK;

DROP PROCEDURE PR_DEL_EMPLEADO;
DROP PROCEDURE PR_DEL_PEDIDOSUC;
DROP PROCEDURE PR_DEL_PRODUCTOR;
DROP PROCEDURE PR_DEL_REALIZAPEDIDO;
DROP PROCEDURE PR_DEL_VINO;
DROP PROCEDURE PR_DIR_SUCURSAL;
DROP PROCEDURE PR_GET_DELEGACION;
DROP PROCEDURE PR_INS_CLIENTE;
DROP PROCEDURE PR_INS_EMPLEADO;
DROP PROCEDURE PR_INS_PEDIDOSUC;
DROP PROCEDURE PR_INS_SUCURSAL;
DROP PROCEDURE PR_INS_SUMINISTRO;
DROP PROCEDURE PR_INS_VINO;
DROP PROCEDURE PR_TRAS_EMPLEADO;
DROP PROCEDURE PR_INS_VINO;





COMMIT;
