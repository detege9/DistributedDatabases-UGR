CREATE TABLE Productor
(
	codProductor  NUMBER(8) NOT NULL,
	DNI_productor VARCHAR2(9) NOT NULL,
	nombre_productor VARCHAR2(50) NOT NULL,
	direccion_productor VARCHAR2(100) NOT NULL,
  PRIMARY KEY (codProductor)
)
;

CREATE TABLE Vino
(
	codVino                      NUMBER(8) NOT NULL,
	marca_vino                   VARCHAR2(50) NOT NULL,
	anyo_vino                    NUMBER(4) NOT NULL,
	denominacion_origen          VARCHAR2(100) NOT NULL,
	graduacion                   NUMBER(8,2) DEFAULT 0 NOT NULL,
	cantidad_stock               NUMBER(8) DEFAULT 0 NOT NULL,
  CA_vino                      VARCHAR2(50),
	vinedo_procedencia           VARCHAR2(50) NOT NULL,
	cantidad_producida           NUMBER(8) DEFAULT 0 NOT NULL,
	codProductor                 NUMBER(8) NOT NULL,
  PRIMARY KEY (codVino),
  CHECK (cantidad_stock between 0 and cantidad_producida),
  FOREIGN KEY (codProductor) REFERENCES Productor(codProductor)
)
;

CREATE TABLE Empleado
(
	codEmpleado              NUMBER(8) NOT NULL,
	DNI_empleado             VARCHAR2(9) NOT NULL,
	nombre_empleado          VARCHAR2(50) NOT NULL,
	fecha_comienzo_contrato  DATE NOT NULL,
	salario                  NUMBER(8,2) DEFAULT 0 NOT NULL,
	direccion_empleado       VARCHAR2(100),
	codSucursal              NUMBER(8) NOT NULL,
  PRIMARY KEY (codEmpleado)
);

CREATE TABLE Sucursal
(
	codSucursal           NUMBER(8) NOT NULL,
	nombre_sucursal       VARCHAR2(50) NOT NULL,
  ciudad_sucursal       VARCHAR2(50) NOT NULL,
	CA_sucursal           VARCHAR2(50) NOT NULL,
	director_sucursal     NUMBER(8),
  PRIMARY KEY(codSucursal),
	UNIQUE (director_sucursal),
  FOREIGN KEY (director_sucursal) REFERENCES Empleado(codEmpleado)
);

ALTER TABLE Empleado
  ADD CONSTRAINT ForeignKey FOREIGN KEY (codSucursal) REFERENCES Sucursal(codSucursal)
;

CREATE TABLE SucursalVendeVino
(
	codSucursal  NUMBER(8) NOT NULL,
	codVino      NUMBER(8) NOT NULL,
  PRIMARY KEY (codSucursal, codVino),
  FOREIGN KEY (codSucursal) REFERENCES Sucursal(codSucursal)
);

CREATE TABLE SucursalSolicitaSucursal
(
	codSucursalPide    NUMBER(8) NOT NULL,
	codSucursalPedido  NUMBER(8) NOT NULL,
	codVino            NUMBER(8) NOT NULL,
	fecha              DATE NOT NULL,
	cantidad           NUMBER(8) DEFAULT 0 NOT NULL,
  PRIMARY KEY (codSucursalPide, codSucursalPedido, codVino, fecha)
);

CREATE TABLE Cliente
(
	codCliente           NUMBER(8) NOT NULL,
	DNI_cliente          VARCHAR2(9) NOT NULL,
	nombre_cliente       VARCHAR2(50) NOT NULL,
	direccion_cliente    VARCHAR2(100) NOT NULL,
	tipo_cliente         VARCHAR2(1) NOT NULL,
	CA_cliente           VARCHAR(50) NOT NULL,
  PRIMARY KEY (codCliente),
  CHECK (tipo_cliente IN ('A', 'B', 'C'))
);

CREATE TABLE ClienteSolicitaVinoASucursal
(
	codCliente   NUMBER(8) NOT NULL,
	codSucursal  NUMBER(8) NOT NULL,
	codVino      NUMBER(8) NOT NULL,
	fecha        DATE NOT NULL,
	cantidad     NUMBER(8) DEFAULT 0 NOT NULL,
  PRIMARY KEY (codCliente, codSucursal, codVino, fecha)
);

COMMIT;
