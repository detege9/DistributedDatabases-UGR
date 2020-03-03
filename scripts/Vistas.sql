CREATE OR REPLACE VIEW v_Cliente AS
    (SELECT * FROM platano1.cliente)
  UNION
    (SELECT * FROM platano2.cliente)
  UNION
    (SELECT * FROM platano3.cliente)
  UNION
    (SELECT * FROM platano4.cliente);
    -- Vista de la tabla empleado

CREATE OR REPLACE VIEW v_Empleado AS
    (SELECT * FROM platano1.empleado)
  UNION
    (SELECT * FROM platano2.empleado)
  UNION
    (SELECT * FROM platano3.empleado)
  UNION
    (SELECT * FROM platano4.empleado);

-- Vista de la tabla RealizaPedido

CREATE OR REPLACE VIEW v_ClienteSolicitaVinoASucursal AS
    (SELECT * FROM platano1.ClienteSolicitaVinoASucursal)
  UNION
    (SELECT * FROM platano2.ClienteSolicitaVinoASucursal)
  UNION
    (SELECT * FROM platano3.ClienteSolicitaVinoASucursal)
  UNION
    (SELECT * FROM platano4.ClienteSolicitaVinoASucursal);

-- Vista de la tabla Suscursal

CREATE OR REPLACE VIEW v_Sucursal AS
    (SELECT * FROM platano1.sucursal)
  UNION
    (SELECT * FROM platano2.sucursal)
  UNION
    (SELECT * FROM platano3.sucursal)
  UNION
    (SELECT * FROM platano4.sucursal);

-- Vista de la tabla Vende

CREATE OR REPLACE VIEW v_SucursalVendeVino AS
    (SELECT * FROM platano1.SucursalVendeVino)
  UNION
    (SELECT * FROM platano2.SucursalVendeVino)
  UNION
    (SELECT * FROM platano3.SucursalVendeVino)
  UNION
    (SELECT * FROM platano4.SucursalVendeVino);

-- Vista de la tabla Vino

CREATE OR REPLACE VIEW v_Vino AS
    (SELECT * FROM platano1.vino)
  UNION
    (SELECT * FROM platano2.vino)
  UNION
    (SELECT * FROM platano3.vino)
  UNION
    (SELECT * FROM platano4.vino);
COMMIT;
