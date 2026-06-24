--
-- PostgreSQL database dump
--


-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

-- Started on 2025-10-10 17:52:16


CREATE SCHEMA gestion_hotel;

ALTER SCHEMA gestion_hotel OWNER TO postgres;

CREATE DOMAIN gestion_hotel.apellido AS character varying(40) CONSTRAINT apellido_paterno_not_null NOT NULL;
CREATE DOMAIN gestion_hotel.codigo_postal AS character(5) NOT NULL;
CREATE DOMAIN gestion_hotel.descripcion AS text DEFAULT 'Sin observaciones'::text;
--
-- TOC enry 971 (class 1247 OID 40972)
-- Name: edad_empleados; Type: DOMAIN; Schema: gestion_hotel; Owner: postgres
--

CREATE DOMAIN gestion_hotel.edad_empleados AS smallint NOT NULL
	CONSTRAINT edad_permitida_trabajadores CHECK ((VALUE >= 18));


ALTER DOMAIN gestion_hotel.edad_empleados OWNER TO postgres;

--
-- TOC entry 976 (class 1247 OID 40976)
-- Name: fecha; Type: DOMAIN; Schema: gestion_hotel; Owner: postgres
--

CREATE DOMAIN gestion_hotel.fecha AS timestamp with time zone NOT NULL DEFAULT now();


ALTER DOMAIN gestion_hotel.fecha OWNER TO postgres;

--
-- TOC entry 980 (class 1247 OID 40979)
-- Name: genero; Type: DOMAIN; Schema: gestion_hotel; Owner: postgres
--

CREATE DOMAIN gestion_hotel.genero AS character(1) NOT NULL
	CONSTRAINT genero_valores_permitidos CHECK ((VALUE = ANY (ARRAY['f'::bpchar, 'm'::bpchar])));


ALTER DOMAIN gestion_hotel.genero OWNER TO postgres;

--
-- TOC entry 985 (class 1247 OID 40983)
-- Name: nombre; Type: DOMAIN; Schema: gestion_hotel; Owner: postgres
--

CREATE DOMAIN gestion_hotel.nombre AS character varying(40) NOT NULL;


ALTER DOMAIN gestion_hotel.nombre OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 40985)
-- Name: dosendos; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.dosendos
    START WITH 2
    INCREMENT BY 2
    NO MINVALUE
    MAXVALUE 1000
    CACHE 1
    CYCLE;


ALTER SEQUENCE gestion_hotel.dosendos OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 40986)
-- Name: AREAS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."AREAS" (
    id_area integer DEFAULT nextval('gestion_hotel.dosendos'::regclass) NOT NULL,
    descripcion gestion_hotel.descripcion,
    id_sucursal integer NOT NULL
);


ALTER TABLE gestion_hotel."AREAS" OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 40992)
-- Name: AUTOS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."AUTOS" (
    matricula character varying(10) NOT NULL,
    modelo character varying(25),
    id_clientes integer NOT NULL
);


ALTER TABLE gestion_hotel."AUTOS" OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 40995)
-- Name: secuenciacargoestacionamiento; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.secuenciacargoestacionamiento
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 1000
    CACHE 1;


ALTER SEQUENCE gestion_hotel.secuenciacargoestacionamiento OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 40996)
-- Name: CARGO_ESTACIONAMIENTO; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."CARGO_ESTACIONAMIENTO" (
    id_cargo_estacionamiento integer DEFAULT nextval('gestion_hotel.secuenciacargoestacionamiento'::regclass) NOT NULL,
    id_estacionamiento integer NOT NULL,
    matricula character varying(10),
    fecha_entrada character varying(20),
    fecha_salida character varying(20)
);


ALTER TABLE gestion_hotel."CARGO_ESTACIONAMIENTO" OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 41000)
-- Name: CIUDADES; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."CIUDADES" (
    id_ciudad integer NOT NULL,
    id_estado integer,
    nombre_ciudad character varying(60)
);


ALTER TABLE gestion_hotel."CIUDADES" OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 41003)
-- Name: CLIENTES; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."CLIENTES" (
    id_clientes integer NOT NULL,
    nombre gestion_hotel.nombre,
    apellido_paterno gestion_hotel.apellido NOT NULL,
    apellido_materno gestion_hotel.apellido,
    calle character varying(45),
    colonia character varying(45),
    codigo_postal character varying(45) NOT NULL,
    rfc_cliente character varying(13) NOT NULL,
    curp character varying(18) NOT NULL,
    id_ciudad integer NOT NULL,
    genero character varying(15)
);


ALTER TABLE gestion_hotel."CLIENTES" OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 41008)
-- Name: COMPRAS_INSUMOS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."COMPRAS_INSUMOS" (
    id_compra integer NOT NULL,
    id_proveedor_insumos integer NOT NULL,
    fecha_compra character varying
);


ALTER TABLE gestion_hotel."COMPRAS_INSUMOS" OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 41013)
-- Name: CONTRATO_SERVICIOS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."CONTRATO_SERVICIOS" (
    id_pago integer NOT NULL,
    id_clientes integer NOT NULL,
    cantidad_personas integer,
    id_servicio integer NOT NULL,
    fecha_inicio character varying,
    fecha_terminacion character varying
);


ALTER TABLE gestion_hotel."CONTRATO_SERVICIOS" OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 41018)
-- Name: DEDUCCIONES_FACTURA; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."DEDUCCIONES_FACTURA" (
    id_deducciones_factura integer NOT NULL,
    impuesto_iva numeric,
    impuesto_isr numeric,
    descuentos numeric
);


ALTER TABLE gestion_hotel."DEDUCCIONES_FACTURA" OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 41023)
-- Name: DETALLES_PROMOCION; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."DETALLES_PROMOCION" (
    id_detalles_promocion integer NOT NULL,
    valor_descuento numeric(10,2),
    usos_promocion text,
    fecha_inicio gestion_hotel.fecha NOT NULL,
    fecha_fin gestion_hotel.fecha NOT NULL,
    id_promocion integer NOT NULL,
    restricciones gestion_hotel.descripcion
);


ALTER TABLE gestion_hotel."DETALLES_PROMOCION" OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 41028)
-- Name: DETALLES_RESERVAS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."DETALLES_RESERVAS" (
    id_reservacion integer NOT NULL,
    numero_habitacion integer NOT NULL
);


ALTER TABLE gestion_hotel."DETALLES_RESERVAS" OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 41031)
-- Name: DETALLE_COMPRA_INSUMOS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."DETALLE_COMPRA_INSUMOS" (
    id_detalle_compra integer NOT NULL,
    cantidad integer DEFAULT 1,
    costo numeric(10,2),
    id_insumos integer NOT NULL,
    id_compra integer NOT NULL
);


ALTER TABLE gestion_hotel."DETALLE_COMPRA_INSUMOS" OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 41035)
-- Name: DETALLE_COMPRA_MOBILIARIO; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."DETALLE_COMPRA_MOBILIARIO" (
    id_detalle_compra_mobiliarios integer NOT NULL,
    cantidad integer DEFAULT 1,
    precio_unitario numeric(10,2),
    subtotal numeric(10,2),
    descuento numeric(10,2),
    estado_entrega character varying(100),
    id_mobiliario integer NOT NULL,
    id_compra integer NOT NULL
);


ALTER TABLE gestion_hotel."DETALLE_COMPRA_MOBILIARIO" OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 41039)
-- Name: DETALLE_FACTURA; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."DETALLE_FACTURA" (
    id_detalle_factura integer NOT NULL,
    concepto character varying(250),
    id_factura integer,
    id_pago integer,
    cantidad integer DEFAULT 1,
    precio_unitario integer,
    subtotal integer
);


ALTER TABLE gestion_hotel."DETALLE_FACTURA" OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 41043)
-- Name: DETALLE_PEDIDO_PROVEEDOR; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."DETALLE_PEDIDO_PROVEEDOR" (
    id_detalle_pedido_proveedor integer NOT NULL,
    producto character varying(100),
    cantidad integer,
    precio_unitario numeric(10,2),
    id_pedido_proveedor integer
);


ALTER TABLE gestion_hotel."DETALLE_PEDIDO_PROVEEDOR" OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 41046)
-- Name: DETALLE_PLATILLO; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."DETALLE_PLATILLO" (
    id_detalles_platillo integer NOT NULL,
    cantidad integer,
    id_platillo integer NOT NULL,
    id_insumos integer NOT NULL
);


ALTER TABLE gestion_hotel."DETALLE_PLATILLO" OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 41049)
-- Name: DETALLE_SERVICIO_HABITACION; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."DETALLE_SERVICIO_HABITACION" (
    id_detalle_servicio_habitacion integer NOT NULL,
    fecha gestion_hotel.fecha,
    total integer,
    id_clientes integer NOT NULL,
    id_servicio_habitacion integer NOT NULL,
    id_platillo integer NOT NULL
);


ALTER TABLE gestion_hotel."DETALLE_SERVICIO_HABITACION" OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 41052)
-- Name: DETALLE_TRANSPORTE; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."DETALLE_TRANSPORTE" (
    id_detalle_transporte integer NOT NULL,
    numero_tarjeta integer NOT NULL,
    id_transporte_empleado integer NOT NULL,
    fecha gestion_hotel.fecha,
    hora_salida integer
);


ALTER TABLE gestion_hotel."DETALLE_TRANSPORTE" OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 41055)
-- Name: EMPLEADOS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."EMPLEADOS" (
    numero_tarjeta integer NOT NULL,
    nombre gestion_hotel.nombre NOT NULL,
    apellido_paterno gestion_hotel.apellido NOT NULL,
    apellido_materno gestion_hotel.apellido NOT NULL,
    calle character varying(45),
    colonia character varying(45),
    codigo_postal gestion_hotel.codigo_postal NOT NULL,
    id_sucursal integer NOT NULL,
    id_area integer NOT NULL,
    id_puesto integer NOT NULL,
    id_ciudad integer NOT NULL,
    rfc_empleado character varying(13) NOT NULL,
    curp_empleado character varying(18) NOT NULL,
    numero_seguro_social character varying(11) NOT NULL,
    edad integer,
    genero character varying
);


ALTER TABLE gestion_hotel."EMPLEADOS" OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 41060)
-- Name: ENCABEZADO_COMPRA_MOBILIARIO; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."ENCABEZADO_COMPRA_MOBILIARIO" (
    id_compra_mobiliario integer NOT NULL,
    fecha_compra_mobiliario gestion_hotel.fecha,
    total_compra integer NOT NULL,
    id_proveedor_mobiliario integer NOT NULL
);


ALTER TABLE gestion_hotel."ENCABEZADO_COMPRA_MOBILIARIO" OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 41063)
-- Name: ENCABEZADO_PLATILLOS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."ENCABEZADO_PLATILLOS" (
    id_platillo integer NOT NULL,
    nombre character varying(50),
    costo numeric(10,2) NOT NULL,
    precio numeric(10,2) NOT NULL
);


ALTER TABLE gestion_hotel."ENCABEZADO_PLATILLOS" OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 41066)
-- Name: ESTACIONAMIENTOS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."ESTACIONAMIENTOS" (
    id_estacionamiento integer NOT NULL,
    capacidad smallint,
    numero_plazas smallint,
    id_sucursal integer NOT NULL
);


ALTER TABLE gestion_hotel."ESTACIONAMIENTOS" OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 41069)
-- Name: ESTADOS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."ESTADOS" (
    id_estado integer NOT NULL,
    nombre_estado character varying(100)
);


ALTER TABLE gestion_hotel."ESTADOS" OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 41072)
-- Name: ESTADO_HABITACION; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."ESTADO_HABITACION" (
    id_estado_habitacion integer NOT NULL,
    descripcion gestion_hotel.descripcion
);


ALTER TABLE gestion_hotel."ESTADO_HABITACION" OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 41077)
-- Name: ESTADO_MANTENIMIENTO; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."ESTADO_MANTENIMIENTO" (
    id_estado_mantenimiento integer NOT NULL,
    descripcion gestion_hotel.descripcion
);


ALTER TABLE gestion_hotel."ESTADO_MANTENIMIENTO" OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 41082)
-- Name: ESTADO_RESERVACION; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."ESTADO_RESERVACION" (
    id_estado_reservacion integer NOT NULL,
    tipo_estado_reservacion character varying(70)
);


ALTER TABLE gestion_hotel."ESTADO_RESERVACION" OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 41085)
-- Name: ESTADO_TRANSPORTE; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."ESTADO_TRANSPORTE" (
    id_estado_transporte integer NOT NULL,
    tipo_estado_transporte character varying
);


ALTER TABLE gestion_hotel."ESTADO_TRANSPORTE" OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 41090)
-- Name: ESTATUS_PAGO; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."ESTATUS_PAGO" (
    id_estatus_pago integer NOT NULL,
    descripcion gestion_hotel.descripcion
);


ALTER TABLE gestion_hotel."ESTATUS_PAGO" OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 41095)
-- Name: FACTURAS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."FACTURAS" (
    id_factura integer NOT NULL,
    id_sucursal integer NOT NULL,
    id_clientes integer NOT NULL,
    total numeric(10,2) NOT NULL,
    fecha_emision gestion_hotel.fecha,
    impuestos numeric(10,2) NOT NULL,
    subtotal numeric(10,2) NOT NULL
);


ALTER TABLE gestion_hotel."FACTURAS" OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 41098)
-- Name: HABITACIONES; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."HABITACIONES" (
    numero_habitacion integer NOT NULL,
    descripcion gestion_hotel.descripcion,
    piso integer,
    id_sucursal 
    id_estado_habitacion integer NOT NULL
);


ALTER TABLE gestion_hotel."HABITACIONES" OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 41103)
-- Name: HISTORIAL_PRECIO_HABITACIONES; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."HISTORIAL_PRECIO_HABITACIONES" (
    id_historial_precios_habitaciones integer NOT NULL,
    periodo_inicio date,
    periodo_fin date,
    precio_habitacion_anterior numeric(10,2),
    precio_habitacion_actual numeric(10,2),
    id_tipo_habitacion integer NOT NULL
);


ALTER TABLE gestion_hotel."HISTORIAL_PRECIO_HABITACIONES" OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 41106)
-- Name: HISTORIAL_PRECIO_SERVICIOS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."HISTORIAL_PRECIO_SERVICIOS" (
    id_historial_precios_servicios integer NOT NULL,
    periodo_inicio date NOT NULL,
    periodo_fin date NOT NULL,
    precio_servicio_anterior numeric(10,2),
    precio_servicio_actual numeric(10,2),
    id_servicio integer NOT NULL
);


ALTER TABLE gestion_hotel."HISTORIAL_PRECIO_SERVICIOS" OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 41109)
-- Name: HOTEL; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."HOTEL" (
    id_hotel integer NOT NULL,
    nombre character varying(50),
    razon_social character varying(50),
    telefono character varying(10),
    correo_electronico_corporativo character varying(250),
    rfc_hotel character(12)
);


ALTER TABLE gestion_hotel."HOTEL" OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 41112)
-- Name: INSUMOS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."INSUMOS" (
    id_insumos integer NOT NULL,
    nombre character varying(100),
    unidad integer,
    costo numeric(10,2)
);


ALTER TABLE gestion_hotel."INSUMOS" OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 41115)
-- Name: INVENTARIO_HABITACION; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."INVENTARIO_HABITACION" (
    id_inventario_habitacion integer NOT NULL,
    nombre_item character varying(70),
    estado character varying(50),
    descripcion gestion_hotel.descripcion,
    cantidad integer,
    numero_habitacion integer NOT NULL,
    ultima_revision date
);


ALTER TABLE gestion_hotel."INVENTARIO_HABITACION" OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 41120)
-- Name: MANTENIMIENTOS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."MANTENIMIENTOS" (
    id_mantenimiento integer NOT NULL,
    id_sucursal integer NOT NULL,
    id_tipo_mantenimiento integer NOT NULL,
    id_estado_mantenimiento integer NOT NULL,
    fecha_inicio gestion_hotel.fecha,
    fecha_fin gestion_hotel.fecha
);


ALTER TABLE gestion_hotel."MANTENIMIENTOS" OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 41123)
-- Name: MARCAS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."MARCAS" (
    id_marca integer NOT NULL,
    nombre_marca character varying(70),
    contacto character varying(255),
    estado_marca character varying(50)
);


ALTER TABLE gestion_hotel."MARCAS" OWNER TO postgres;

--
-- TOC entry 256 (class 1259 OID 41126)
-- Name: METODO_PAGO; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."METODO_PAGO" (
    id_metodo_pago integer NOT NULL,
    descripcion gestion_hotel.descripcion
);


ALTER TABLE gestion_hotel."METODO_PAGO" OWNER TO postgres;

--
-- TOC entry 257 (class 1259 OID 41131)
-- Name: MOBILIARIOS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."MOBILIARIOS" (
    id_mobiliario integer NOT NULL,
    nombre character varying(50),
    descripcion gestion_hotel.descripcion,
    id_marca integer,
    id_sucursal integer NOT NULL
);


ALTER TABLE gestion_hotel."MOBILIARIOS" OWNER TO postgres;

--
-- TOC entry 258 (class 1259 OID 41136)
-- Name: PAGOS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."PAGOS" (
    id_pago integer NOT NULL,
    id_estatus_pago integer NOT NULL,
    id_metodo_pago integer NOT NULL,
    monto numeric(10,2) NOT NULL,
    id_sucursal integer NOT NULL,
    id_clientes integer NOT NULL,
    fecha_de_pago character varying(15)
);


ALTER TABLE gestion_hotel."PAGOS" OWNER TO postgres;

--
-- TOC entry 259 (class 1259 OID 41139)
-- Name: PEDIDO_PROVEEDOR; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."PEDIDO_PROVEEDOR" (
    id_pedido_proveedor integer NOT NULL,
    fecha_pedido gestion_hotel.fecha,
    fecha_entrega gestion_hotel.fecha,
    estado character varying(50),
    total integer NOT NULL
);


ALTER TABLE gestion_hotel."PEDIDO_PROVEEDOR" OWNER TO postgres;

--
-- TOC entry 260 (class 1259 OID 41142)
-- Name: trikitrakatelas; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.trikitrakatelas
    START WITH 3
    INCREMENT BY 3
    NO MINVALUE
    MAXVALUE 1000
    CACHE 1;


ALTER SEQUENCE gestion_hotel.trikitrakatelas OWNER TO postgres;

--
-- TOC entry 261 (class 1259 OID 41143)
-- Name: PROMOCIONES; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."PROMOCIONES" (
    id_promocion integer DEFAULT nextval('gestion_hotel.trikitrakatelas'::regclass) NOT NULL,
    nombre_promocion character varying(50),
    descripcion gestion_hotel.descripcion,
    tipo_promocion character varying(50),
    id_sucursal integer NOT NULL
);


ALTER TABLE gestion_hotel."PROMOCIONES" OWNER TO postgres;

--
-- TOC entry 262 (class 1259 OID 41149)
-- Name: PROVEEDORES_INSUMOS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."PROVEEDORES_INSUMOS" (
    id_proveedor_insumos integer NOT NULL,
    nombre_proveedor character varying(100),
    razon_social character varying(50),
    correo_electronico character varying(100),
    telefono character varying(12)
);


ALTER TABLE gestion_hotel."PROVEEDORES_INSUMOS" OWNER TO postgres;

--
-- TOC entry 263 (class 1259 OID 41152)
-- Name: PROVEEDORES_MOBILIARIOS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."PROVEEDORES_MOBILIARIOS" (
    id_proveedor_mobiliario integer NOT NULL,
    razon_social character varying(50),
    nombre_proveedor character varying(50),
    correo_electronico character varying(100),
    telefono character(10)
);


ALTER TABLE gestion_hotel."PROVEEDORES_MOBILIARIOS" OWNER TO postgres;

--
-- TOC entry 264 (class 1259 OID 41155)
-- Name: PUESTOS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."PUESTOS" (
    id_puesto integer NOT NULL,
    descripcion gestion_hotel.descripcion,
    id_area integer NOT NULL,
    id_sucursal integer NOT NULL
);


ALTER TABLE gestion_hotel."PUESTOS" OWNER TO postgres;

--
-- TOC entry 265 (class 1259 OID 41160)
-- Name: RESERVACIONES; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."RESERVACIONES" (
    id_reservacion integer NOT NULL,
    id_clientes integer NOT NULL,
    id_sucursal integer NOT NULL,
    id_estado_reservacion integer NOT NULL,
    numero_tarjeta integer NOT NULL,
    fecha_check_in gestion_hotel.fecha,
    fecha_check_out gestion_hotel.fecha
);


ALTER TABLE gestion_hotel."RESERVACIONES" OWNER TO postgres;

--
-- TOC entry 266 (class 1259 OID 41163)
-- Name: SALON; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."SALON" (
    id_salon integer NOT NULL,
    nombre character varying(50),
    razon_social character varying(50),
    capacidad integer,
    tipo character varying(50),
    equipamiento text,
    estado character varying(50),
    id_sucursal integer NOT NULL
);


ALTER TABLE gestion_hotel."SALON" OWNER TO postgres;

--
-- TOC entry 267 (class 1259 OID 41168)
-- Name: SERVICIOS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."SERVICIOS" (
    id_servicio integer NOT NULL,
    nombre_servicio character varying(50),
    dias_servicio character varying(100),
    horario character varying(12),
    precio integer NOT NULL,
    id_sucursal integer NOT NULL
);


ALTER TABLE gestion_hotel."SERVICIOS" OWNER TO postgres;

--
-- TOC entry 268 (class 1259 OID 41171)
-- Name: SERVICIO_HABITACION; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."SERVICIO_HABITACION" (
    id_servicio_habitacion integer NOT NULL,
    costo numeric(10,2) NOT NULL,
    telefono character varying(10),
    hora_apertura character varying,
    hora_cierre character varying
);


ALTER TABLE gestion_hotel."SERVICIO_HABITACION" OWNER TO postgres;

--
-- TOC entry 269 (class 1259 OID 41176)
-- Name: SUCURSALES; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."SUCURSALES" (
    id_sucursal integer NOT NULL,
    nombre_sucursal character varying(100),
    colonia character varying(60),
    codigo_postal gestion_hotel.codigo_postal,
    calle character varying(45),
    numero_interior character varying(10),
    numero_exterior character varying(10),
    telefono1 character varying(13),
    telefono2 character varying(13),
    correo_electronico_contacto character varying(100),
    id_ciudad integer,
    id_estado integer,
    numero_habitaciones integer,
    capacidad_huespedes integer,
    id_hotel integer
);


ALTER TABLE gestion_hotel."SUCURSALES" OWNER TO postgres;

--
-- TOC entry 270 (class 1259 OID 41181)
-- Name: TIPO_CAMAS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."TIPO_CAMAS" (
    id_tipo_cama integer NOT NULL,
    modelo_cama character varying(50)
);


ALTER TABLE gestion_hotel."TIPO_CAMAS" OWNER TO postgres;

--
-- TOC entry 271 (class 1259 OID 41184)
-- Name: TIPO_HABITACIONES; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."TIPO_HABITACIONES" (
    id_tipo_habitacion integer NOT NULL,
    nombre_tipo_habitacion character varying(100),
    capacidad integer,
    precio numeric(10,2) NOT NULL,
    detalles gestion_hotel.descripcion,
    id_tipo_cama integer NOT NULL
);


ALTER TABLE gestion_hotel."TIPO_HABITACIONES" OWNER TO postgres;

--
-- TOC entry 272 (class 1259 OID 41189)
-- Name: TIPO_MANTENIMIENTOS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."TIPO_MANTENIMIENTOS" (
    id_tipo_mantenimiento integer NOT NULL,
    tipo_mantenimiento character varying(50),
    descripcion gestion_hotel.descripcion
);


ALTER TABLE gestion_hotel."TIPO_MANTENIMIENTOS" OWNER TO postgres;

--
-- TOC entry 273 (class 1259 OID 41194)
-- Name: TIPO_TRANSPORTE_EMPLEADOS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."TIPO_TRANSPORTE_EMPLEADOS" (
    id_tipo_transporte integer NOT NULL,
    nombre_tipo character varying(50)
);


ALTER TABLE gestion_hotel."TIPO_TRANSPORTE_EMPLEADOS" OWNER TO postgres;

--
-- TOC entry 274 (class 1259 OID 41197)
-- Name: TRANSPORTE_EMPLEADOS; Type: TABLE; Schema: gestion_hotel; Owner: postgres
--

CREATE TABLE gestion_hotel."TRANSPORTE_EMPLEADOS" (
    id_transporte_empleado integer NOT NULL,
    matricula character varying(50),
    capacidad integer,
    id_sucursal integer NOT NULL,
    id_estado_transporte integer NOT NULL,
    id_tipo_transporte integer NOT NULL,
    modelo character varying(50)
);


ALTER TABLE gestion_hotel."TRANSPORTE_EMPLEADOS" OWNER TO postgres;

--
-- TOC entry 275 (class 1259 OID 41200)
-- Name: area_id_area_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.area_id_area_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.area_id_area_seq OWNER TO postgres;

--
-- TOC entry 5538 (class 0 OID 0)
-- Dependencies: 275
-- Name: area_id_area_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.area_id_area_seq OWNED BY gestion_hotel."AREAS".id_area;


--
-- TOC entry 276 (class 1259 OID 41201)
-- Name: autos_id_clientes_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.autos_id_clientes_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.autos_id_clientes_seq OWNER TO postgres;

--
-- TOC entry 5539 (class 0 OID 0)
-- Dependencies: 276
-- Name: autos_id_clientes_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.autos_id_clientes_seq OWNED BY gestion_hotel."AUTOS".id_clientes;


--
-- TOC entry 277 (class 1259 OID 41202)
-- Name: cargo_estacionamiento_id_cargo_estacionamiento_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.cargo_estacionamiento_id_cargo_estacionamiento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.cargo_estacionamiento_id_cargo_estacionamiento_seq OWNER TO postgres;

--
-- TOC entry 5540 (class 0 OID 0)
-- Dependencies: 277
-- Name: cargo_estacionamiento_id_cargo_estacionamiento_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.cargo_estacionamiento_id_cargo_estacionamiento_seq OWNED BY gestion_hotel."CARGO_ESTACIONAMIENTO".id_cargo_estacionamiento;


--
-- TOC entry 278 (class 1259 OID 41203)
-- Name: cargo_estacionamiento_id_estacionamiento_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.cargo_estacionamiento_id_estacionamiento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.cargo_estacionamiento_id_estacionamiento_seq OWNER TO postgres;

--
-- TOC entry 5541 (class 0 OID 0)
-- Dependencies: 278
-- Name: cargo_estacionamiento_id_estacionamiento_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.cargo_estacionamiento_id_estacionamiento_seq OWNED BY gestion_hotel."CARGO_ESTACIONAMIENTO".id_estacionamiento;


--
-- TOC entry 279 (class 1259 OID 41204)
-- Name: ciudades_id_ciudad_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.ciudades_id_ciudad_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.ciudades_id_ciudad_seq OWNER TO postgres;

--
-- TOC entry 5542 (class 0 OID 0)
-- Dependencies: 279
-- Name: ciudades_id_ciudad_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.ciudades_id_ciudad_seq OWNED BY gestion_hotel."CIUDADES".id_ciudad;


--
-- TOC entry 280 (class 1259 OID 41205)
-- Name: clientes_id_clientes_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.clientes_id_clientes_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.clientes_id_clientes_seq OWNER TO postgres;

--
-- TOC entry 5543 (class 0 OID 0)
-- Dependencies: 280
-- Name: clientes_id_clientes_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.clientes_id_clientes_seq OWNED BY gestion_hotel."CLIENTES".id_clientes;


--
-- TOC entry 281 (class 1259 OID 41206)
-- Name: compras_insumos_id_compra_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.compras_insumos_id_compra_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.compras_insumos_id_compra_seq OWNER TO postgres;

--
-- TOC entry 5544 (class 0 OID 0)
-- Dependencies: 281
-- Name: compras_insumos_id_compra_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.compras_insumos_id_compra_seq OWNED BY gestion_hotel."COMPRAS_INSUMOS".id_compra;


--
-- TOC entry 282 (class 1259 OID 41207)
-- Name: deducciones_factura_id_deducciones_factura_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.deducciones_factura_id_deducciones_factura_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.deducciones_factura_id_deducciones_factura_seq OWNER TO postgres;

--
-- TOC entry 5545 (class 0 OID 0)
-- Dependencies: 282
-- Name: deducciones_factura_id_deducciones_factura_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.deducciones_factura_id_deducciones_factura_seq OWNED BY gestion_hotel."DEDUCCIONES_FACTURA".id_deducciones_factura;


--
-- TOC entry 283 (class 1259 OID 41208)
-- Name: detalle_compra_id_detalle_compra_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.detalle_compra_id_detalle_compra_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.detalle_compra_id_detalle_compra_seq OWNER TO postgres;

--
-- TOC entry 5546 (class 0 OID 0)
-- Dependencies: 283
-- Name: detalle_compra_id_detalle_compra_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.detalle_compra_id_detalle_compra_seq OWNED BY gestion_hotel."DETALLE_COMPRA_INSUMOS".id_detalle_compra;


--
-- TOC entry 284 (class 1259 OID 41209)
-- Name: detalle_compra_mobiliarios_id_detalle_compra_mobiliarios_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.detalle_compra_mobiliarios_id_detalle_compra_mobiliarios_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.detalle_compra_mobiliarios_id_detalle_compra_mobiliarios_seq OWNER TO postgres;

--
-- TOC entry 5547 (class 0 OID 0)
-- Dependencies: 284
-- Name: detalle_compra_mobiliarios_id_detalle_compra_mobiliarios_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.detalle_compra_mobiliarios_id_detalle_compra_mobiliarios_seq OWNED BY gestion_hotel."DETALLE_COMPRA_MOBILIARIO".id_detalle_compra_mobiliarios;


--
-- TOC entry 285 (class 1259 OID 41210)
-- Name: detalle_factura_id_detalle_factura_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.detalle_factura_id_detalle_factura_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.detalle_factura_id_detalle_factura_seq OWNER TO postgres;

--
-- TOC entry 5548 (class 0 OID 0)
-- Dependencies: 285
-- Name: detalle_factura_id_detalle_factura_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.detalle_factura_id_detalle_factura_seq OWNED BY gestion_hotel."DETALLE_FACTURA".id_detalle_factura;


--
-- TOC entry 286 (class 1259 OID 41211)
-- Name: detalle_pedido_proveedor_id_detalle_pedido_proveedor_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.detalle_pedido_proveedor_id_detalle_pedido_proveedor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.detalle_pedido_proveedor_id_detalle_pedido_proveedor_seq OWNER TO postgres;

--
-- TOC entry 5549 (class 0 OID 0)
-- Dependencies: 286
-- Name: detalle_pedido_proveedor_id_detalle_pedido_proveedor_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.detalle_pedido_proveedor_id_detalle_pedido_proveedor_seq OWNED BY gestion_hotel."DETALLE_PEDIDO_PROVEEDOR".id_detalle_pedido_proveedor;


--
-- TOC entry 287 (class 1259 OID 41212)
-- Name: detalle_servicio_habitacion_id_detalle_servicio_habitacion_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.detalle_servicio_habitacion_id_detalle_servicio_habitacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.detalle_servicio_habitacion_id_detalle_servicio_habitacion_seq OWNER TO postgres;

--
-- TOC entry 5550 (class 0 OID 0)
-- Dependencies: 287
-- Name: detalle_servicio_habitacion_id_detalle_servicio_habitacion_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.detalle_servicio_habitacion_id_detalle_servicio_habitacion_seq OWNED BY gestion_hotel."DETALLE_SERVICIO_HABITACION".id_detalle_servicio_habitacion;


--
-- TOC entry 288 (class 1259 OID 41213)
-- Name: detalle_transporte_id_detalle_transporte_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.detalle_transporte_id_detalle_transporte_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.detalle_transporte_id_detalle_transporte_seq OWNER TO postgres;

--
-- TOC entry 5551 (class 0 OID 0)
-- Dependencies: 288
-- Name: detalle_transporte_id_detalle_transporte_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.detalle_transporte_id_detalle_transporte_seq OWNED BY gestion_hotel."DETALLE_TRANSPORTE".id_detalle_transporte;


--
-- TOC entry 289 (class 1259 OID 41214)
-- Name: detalles_platillo_id_detalles_platillo_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.detalles_platillo_id_detalles_platillo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.detalles_platillo_id_detalles_platillo_seq OWNER TO postgres;

--
-- TOC entry 5552 (class 0 OID 0)
-- Dependencies: 289
-- Name: detalles_platillo_id_detalles_platillo_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.detalles_platillo_id_detalles_platillo_seq OWNED BY gestion_hotel."DETALLE_PLATILLO".id_detalles_platillo;


--
-- TOC entry 290 (class 1259 OID 41215)
-- Name: detalles_promocion_id_detalles_promocion_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.detalles_promocion_id_detalles_promocion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.detalles_promocion_id_detalles_promocion_seq OWNER TO postgres;

--
-- TOC entry 5553 (class 0 OID 0)
-- Dependencies: 290
-- Name: detalles_promocion_id_detalles_promocion_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.detalles_promocion_id_detalles_promocion_seq OWNED BY gestion_hotel."DETALLES_PROMOCION".id_detalles_promocion;


--
-- TOC entry 291 (class 1259 OID 41216)
-- Name: empleados_numero_tarjeta_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.empleados_numero_tarjeta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.empleados_numero_tarjeta_seq OWNER TO postgres;

--
-- TOC entry 5554 (class 0 OID 0)
-- Dependencies: 291
-- Name: empleados_numero_tarjeta_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.empleados_numero_tarjeta_seq OWNED BY gestion_hotel."EMPLEADOS".numero_tarjeta;


--
-- TOC entry 292 (class 1259 OID 41217)
-- Name: encabezado_compra_mobiliario_id_compra_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.encabezado_compra_mobiliario_id_compra_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.encabezado_compra_mobiliario_id_compra_seq OWNER TO postgres;

--
-- TOC entry 5555 (class 0 OID 0)
-- Dependencies: 292
-- Name: encabezado_compra_mobiliario_id_compra_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.encabezado_compra_mobiliario_id_compra_seq OWNED BY gestion_hotel."ENCABEZADO_COMPRA_MOBILIARIO".id_compra_mobiliario;


--
-- TOC entry 293 (class 1259 OID 41218)
-- Name: encabezado_platillos_id_platillo_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.encabezado_platillos_id_platillo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.encabezado_platillos_id_platillo_seq OWNER TO postgres;

--
-- TOC entry 5556 (class 0 OID 0)
-- Dependencies: 293
-- Name: encabezado_platillos_id_platillo_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.encabezado_platillos_id_platillo_seq OWNED BY gestion_hotel."ENCABEZADO_PLATILLOS".id_platillo;


--
-- TOC entry 294 (class 1259 OID 41219)
-- Name: estacionamiento_id_estacionamiento_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.estacionamiento_id_estacionamiento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.estacionamiento_id_estacionamiento_seq OWNER TO postgres;

--
-- TOC entry 5557 (class 0 OID 0)
-- Dependencies: 294
-- Name: estacionamiento_id_estacionamiento_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.estacionamiento_id_estacionamiento_seq OWNED BY gestion_hotel."ESTACIONAMIENTOS".id_estacionamiento;


--
-- TOC entry 295 (class 1259 OID 41220)
-- Name: estacionamiento_id_sucursal_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.estacionamiento_id_sucursal_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.estacionamiento_id_sucursal_seq OWNER TO postgres;

--
-- TOC entry 5558 (class 0 OID 0)
-- Dependencies: 295
-- Name: estacionamiento_id_sucursal_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.estacionamiento_id_sucursal_seq OWNED BY gestion_hotel."ESTACIONAMIENTOS".id_sucursal;


--
-- TOC entry 296 (class 1259 OID 41221)
-- Name: estado_habitacion_id_estado_habitacion_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.estado_habitacion_id_estado_habitacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.estado_habitacion_id_estado_habitacion_seq OWNER TO postgres;

--
-- TOC entry 5559 (class 0 OID 0)
-- Dependencies: 296
-- Name: estado_habitacion_id_estado_habitacion_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.estado_habitacion_id_estado_habitacion_seq OWNED BY gestion_hotel."ESTADO_HABITACION".id_estado_habitacion;


--
-- TOC entry 297 (class 1259 OID 41222)
-- Name: estado_id_estado_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.estado_id_estado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.estado_id_estado_seq OWNER TO postgres;

--
-- TOC entry 5560 (class 0 OID 0)
-- Dependencies: 297
-- Name: estado_id_estado_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.estado_id_estado_seq OWNED BY gestion_hotel."ESTADOS".id_estado;


--
-- TOC entry 298 (class 1259 OID 41223)
-- Name: estado_mantenimiento_id_estado_mantenimiento_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.estado_mantenimiento_id_estado_mantenimiento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.estado_mantenimiento_id_estado_mantenimiento_seq OWNER TO postgres;

--
-- TOC entry 5561 (class 0 OID 0)
-- Dependencies: 298
-- Name: estado_mantenimiento_id_estado_mantenimiento_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.estado_mantenimiento_id_estado_mantenimiento_seq OWNED BY gestion_hotel."ESTADO_MANTENIMIENTO".id_estado_mantenimiento;


--
-- TOC entry 299 (class 1259 OID 41224)
-- Name: estado_reservacion_id_estado_reservacion_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.estado_reservacion_id_estado_reservacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.estado_reservacion_id_estado_reservacion_seq OWNER TO postgres;

--
-- TOC entry 5562 (class 0 OID 0)
-- Dependencies: 299
-- Name: estado_reservacion_id_estado_reservacion_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.estado_reservacion_id_estado_reservacion_seq OWNED BY gestion_hotel."ESTADO_RESERVACION".id_estado_reservacion;


--
-- TOC entry 300 (class 1259 OID 41225)
-- Name: estado_transporte_id_estado_transporte_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.estado_transporte_id_estado_transporte_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.estado_transporte_id_estado_transporte_seq OWNER TO postgres;

--
-- TOC entry 5563 (class 0 OID 0)
-- Dependencies: 300
-- Name: estado_transporte_id_estado_transporte_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.estado_transporte_id_estado_transporte_seq OWNED BY gestion_hotel."ESTADO_TRANSPORTE".id_estado_transporte;


--
-- TOC entry 301 (class 1259 OID 41226)
-- Name: estatus_pago_id_estatus_pago_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.estatus_pago_id_estatus_pago_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.estatus_pago_id_estatus_pago_seq OWNER TO postgres;

--
-- TOC entry 5564 (class 0 OID 0)
-- Dependencies: 301
-- Name: estatus_pago_id_estatus_pago_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.estatus_pago_id_estatus_pago_seq OWNED BY gestion_hotel."ESTATUS_PAGO".id_estatus_pago;


--
-- TOC entry 302 (class 1259 OID 41227)
-- Name: factura_id_factura_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.factura_id_factura_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.factura_id_factura_seq OWNER TO postgres;

--
-- TOC entry 5565 (class 0 OID 0)
-- Dependencies: 302
-- Name: factura_id_factura_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.factura_id_factura_seq OWNED BY gestion_hotel."FACTURAS".id_factura;


--
-- TOC entry 303 (class 1259 OID 41228)
-- Name: habitacion_id_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.habitacion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.habitacion_id_seq OWNER TO postgres;

--
-- TOC entry 5566 (class 0 OID 0)
-- Dependencies: 303
-- Name: habitacion_id_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.habitacion_id_seq OWNED BY gestion_hotel."HABITACIONES".numero_habitacion;


--
-- TOC entry 304 (class 1259 OID 41229)
-- Name: historial_precios_habitacione_id_historial_precios_habitaci_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.historial_precios_habitacione_id_historial_precios_habitaci_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.historial_precios_habitacione_id_historial_precios_habitaci_seq OWNER TO postgres;

--
-- TOC entry 5567 (class 0 OID 0)
-- Dependencies: 304
-- Name: historial_precios_habitacione_id_historial_precios_habitaci_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.historial_precios_habitacione_id_historial_precios_habitaci_seq OWNED BY gestion_hotel."HISTORIAL_PRECIO_HABITACIONES".id_historial_precios_habitaciones;


--
-- TOC entry 305 (class 1259 OID 41230)
-- Name: historial_precios_habitaciones_id_tipo_habitacion_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.historial_precios_habitaciones_id_tipo_habitacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.historial_precios_habitaciones_id_tipo_habitacion_seq OWNER TO postgres;

--
-- TOC entry 5568 (class 0 OID 0)
-- Dependencies: 305
-- Name: historial_precios_habitaciones_id_tipo_habitacion_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.historial_precios_habitaciones_id_tipo_habitacion_seq OWNED BY gestion_hotel."HISTORIAL_PRECIO_HABITACIONES".id_tipo_habitacion;


--
-- TOC entry 306 (class 1259 OID 41231)
-- Name: historial_precios_servicios_id_historial_precios_servicios_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.historial_precios_servicios_id_historial_precios_servicios_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.historial_precios_servicios_id_historial_precios_servicios_seq OWNER TO postgres;

--
-- TOC entry 5569 (class 0 OID 0)
-- Dependencies: 306
-- Name: historial_precios_servicios_id_historial_precios_servicios_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.historial_precios_servicios_id_historial_precios_servicios_seq OWNED BY gestion_hotel."HISTORIAL_PRECIO_SERVICIOS".id_historial_precios_servicios;


--
-- TOC entry 307 (class 1259 OID 41232)
-- Name: historial_precios_servicios_id_servicio_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.historial_precios_servicios_id_servicio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.historial_precios_servicios_id_servicio_seq OWNER TO postgres;

--
-- TOC entry 5570 (class 0 OID 0)
-- Dependencies: 307
-- Name: historial_precios_servicios_id_servicio_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.historial_precios_servicios_id_servicio_seq OWNED BY gestion_hotel."HISTORIAL_PRECIO_SERVICIOS".id_servicio;


--
-- TOC entry 308 (class 1259 OID 41233)
-- Name: hotel_id_hotel_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.hotel_id_hotel_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.hotel_id_hotel_seq OWNER TO postgres;

--
-- TOC entry 5571 (class 0 OID 0)
-- Dependencies: 308
-- Name: hotel_id_hotel_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.hotel_id_hotel_seq OWNED BY gestion_hotel."HOTEL".id_hotel;


--
-- TOC entry 309 (class 1259 OID 41234)
-- Name: insumos_id_insumos_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.insumos_id_insumos_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.insumos_id_insumos_seq OWNER TO postgres;

--
-- TOC entry 5572 (class 0 OID 0)
-- Dependencies: 309
-- Name: insumos_id_insumos_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.insumos_id_insumos_seq OWNED BY gestion_hotel."INSUMOS".id_insumos;


--
-- TOC entry 310 (class 1259 OID 41235)
-- Name: inventario_habitacion_id_inventario_habitacion_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.inventario_habitacion_id_inventario_habitacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.inventario_habitacion_id_inventario_habitacion_seq OWNER TO postgres;

--
-- TOC entry 5573 (class 0 OID 0)
-- Dependencies: 310
-- Name: inventario_habitacion_id_inventario_habitacion_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.inventario_habitacion_id_inventario_habitacion_seq OWNED BY gestion_hotel."INVENTARIO_HABITACION".id_inventario_habitacion;


--
-- TOC entry 311 (class 1259 OID 41236)
-- Name: mantenimiento_id_mantenimiento_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.mantenimiento_id_mantenimiento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.mantenimiento_id_mantenimiento_seq OWNER TO postgres;

--
-- TOC entry 5574 (class 0 OID 0)
-- Dependencies: 311
-- Name: mantenimiento_id_mantenimiento_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.mantenimiento_id_mantenimiento_seq OWNED BY gestion_hotel."MANTENIMIENTOS".id_mantenimiento;


--
-- TOC entry 312 (class 1259 OID 41237)
-- Name: marcas_id_marca_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.marcas_id_marca_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.marcas_id_marca_seq OWNER TO postgres;

--
-- TOC entry 5575 (class 0 OID 0)
-- Dependencies: 312
-- Name: marcas_id_marca_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.marcas_id_marca_seq OWNED BY gestion_hotel."MARCAS".id_marca;


--
-- TOC entry 313 (class 1259 OID 41238)
-- Name: metodo_pago_id_metodo_pago_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.metodo_pago_id_metodo_pago_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.metodo_pago_id_metodo_pago_seq OWNER TO postgres;

--
-- TOC entry 5576 (class 0 OID 0)
-- Dependencies: 313
-- Name: metodo_pago_id_metodo_pago_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.metodo_pago_id_metodo_pago_seq OWNED BY gestion_hotel."METODO_PAGO".id_metodo_pago;


--
-- TOC entry 314 (class 1259 OID 41239)
-- Name: mobiliarios_id_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.mobiliarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.mobiliarios_id_seq OWNER TO postgres;

--
-- TOC entry 5577 (class 0 OID 0)
-- Dependencies: 314
-- Name: mobiliarios_id_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.mobiliarios_id_seq OWNED BY gestion_hotel."MOBILIARIOS".id_mobiliario;


--
-- TOC entry 315 (class 1259 OID 41240)
-- Name: pago_id_pago_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.pago_id_pago_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.pago_id_pago_seq OWNER TO postgres;

--
-- TOC entry 5578 (class 0 OID 0)
-- Dependencies: 315
-- Name: pago_id_pago_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.pago_id_pago_seq OWNED BY gestion_hotel."PAGOS".id_pago;


--
-- TOC entry 316 (class 1259 OID 41241)
-- Name: pedido_proveedor_id_pedido_proveedor_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.pedido_proveedor_id_pedido_proveedor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.pedido_proveedor_id_pedido_proveedor_seq OWNER TO postgres;

--
-- TOC entry 5579 (class 0 OID 0)
-- Dependencies: 316
-- Name: pedido_proveedor_id_pedido_proveedor_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.pedido_proveedor_id_pedido_proveedor_seq OWNED BY gestion_hotel."PEDIDO_PROVEEDOR".id_pedido_proveedor;


--
-- TOC entry 317 (class 1259 OID 41242)
-- Name: promociones_id_promocion_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.promociones_id_promocion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.promociones_id_promocion_seq OWNER TO postgres;

--
-- TOC entry 5580 (class 0 OID 0)
-- Dependencies: 317
-- Name: promociones_id_promocion_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.promociones_id_promocion_seq OWNED BY gestion_hotel."PROMOCIONES".id_promocion;


--
-- TOC entry 318 (class 1259 OID 41243)
-- Name: proveedores_id_proveedor_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.proveedores_id_proveedor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.proveedores_id_proveedor_seq OWNER TO postgres;



ALTER SEQUENCE gestion_hotel.proveedores_id_proveedor_seq OWNED BY gestion_hotel."PROVEEDORES_INSUMOS".id_proveedor_insumos;



CREATE SEQUENCE gestion_hotel.proveedores_mobiliarios_id_proveedor_mobiliario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.proveedores_mobiliarios_id_proveedor_mobiliario_seq OWNER TO postgres;



ALTER SEQUENCE gestion_hotel.proveedores_mobiliarios_id_proveedor_mobiliario_seq OWNED BY gestion_hotel."PROVEEDORES_MOBILIARIOS".id_proveedor_mobiliario;



CREATE SEQUENCE gestion_hotel.puesto_id_puesto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.puesto_id_puesto_seq OWNER TO postgres;

ALTER SEQUENCE gestion_hotel.puesto_id_puesto_seq OWNED BY gestion_hotel."PUESTOS".id_puesto;


CREATE SEQUENCE gestion_hotel.reservaciones_id_reservation_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.reservaciones_id_reservation_seq OWNER TO postgres;

--
-- TOC entry 5584 (class 0 OID 0)
-- Dependencies: 321
-- Name: reservaciones_id_reservation_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.reservaciones_id_reservation_seq OWNED BY gestion_hotel."RESERVACIONES".id_reservacion;


--
-- TOC entry 322 (class 1259 OID 41247)
-- Name: salon_id_salon_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.salon_id_salon_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.salon_id_salon_seq OWNER TO postgres;

--
-- TOC entry 5585 (class 0 OID 0)
-- Dependencies: 322
-- Name: salon_id_salon_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.salon_id_salon_seq OWNED BY gestion_hotel."SALON".id_salon;


--
-- TOC entry 323 (class 1259 OID 41248)
-- Name: salon_id_sucursal_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.salon_id_sucursal_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.salon_id_sucursal_seq OWNER TO postgres;

--
-- TOC entry 5586 (class 0 OID 0)
-- Dependencies: 323
-- Name: salon_id_sucursal_seq; Type: SEQUENCE OWNED BY; Schema: gestion_hotel; Owner: postgres
--

ALTER SEQUENCE gestion_hotel.salon_id_sucursal_seq OWNED BY gestion_hotel."SALON".id_sucursal;


--
-- TOC entry 324 (class 1259 OID 41249)
-- Name: servicio_habitacion_id_servicio_habitacion_seq; Type: SEQUENCE; Schema: gestion_hotel; Owner: postgres
--

CREATE SEQUENCE gestion_hotel.servicio_habitacion_id_servicio_habitacion_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.servicio_habitacion_id_servicio_habitacion_seq OWNER TO postgres;


ALTER SEQUENCE gestion_hotel.servicio_habitacion_id_servicio_habitacion_seq OWNED BY gestion_hotel."SERVICIO_HABITACION".id_servicio_habitacion;



CREATE SEQUENCE gestion_hotel.servicio_id_servicio_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.servicio_id_servicio_seq OWNER TO postgres;


ALTER SEQUENCE gestion_hotel.servicio_id_servicio_seq OWNED BY gestion_hotel."SERVICIOS".id_servicio;



CREATE SEQUENCE gestion_hotel.sucursales_id_sucursal_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.sucursales_id_sucursal_seq OWNER TO postgres;

ALTER SEQUENCE gestion_hotel.sucursales_id_sucursal_seq OWNED BY gestion_hotel."SUCURSALES".id_sucursal;


CREATE SEQUENCE gestion_hotel.tipo_cama_id_tipo_cama_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.tipo_cama_id_tipo_cama_seq OWNER TO postgres;


ALTER SEQUENCE gestion_hotel.tipo_cama_id_tipo_cama_seq OWNED BY gestion_hotel."TIPO_CAMAS".id_tipo_cama;



CREATE SEQUENCE gestion_hotel.tipo_habitacion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.tipo_habitacion_id_seq OWNER TO postgres;



ALTER SEQUENCE gestion_hotel.tipo_habitacion_id_seq OWNED BY gestion_hotel."TIPO_HABITACIONES".id_tipo_habitacion;



CREATE SEQUENCE gestion_hotel.tipo_mantenimiento_id_tipo_mantenimiento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.tipo_mantenimiento_id_tipo_mantenimiento_seq OWNER TO postgres;



ALTER SEQUENCE gestion_hotel.tipo_mantenimiento_id_tipo_mantenimiento_seq OWNED BY gestion_hotel."TIPO_MANTENIMIENTOS".id_tipo_mantenimiento;


CREATE SEQUENCE gestion_hotel.tipo_transporte_id_tipo_transporte_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.tipo_transporte_id_tipo_transporte_seq OWNER TO postgres;


ALTER SEQUENCE gestion_hotel.tipo_transporte_id_tipo_transporte_seq OWNED BY gestion_hotel."TIPO_TRANSPORTE_EMPLEADOS".id_tipo_transporte;



CREATE SEQUENCE gestion_hotel.transporte_empleados_id_transporte_empleado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE gestion_hotel.transporte_empleados_id_transporte_empleado_seq OWNER TO postgres;


ALTER SEQUENCE gestion_hotel.transporte_empleados_id_transporte_empleado_seq OWNED BY gestion_hotel."TRANSPORTE_EMPLEADOS".id_transporte_empleado;



ALTER TABLE gestion_hotel."AUTOS" ALTER COLUMN id_clientes SET DEFAULT nextval('gestion_hotel.autos_id_clientes_seq'::regclass);


ALTER TABLE gestion_hotel."CARGO_ESTACIONAMIENTO" ALTER COLUMN id_estacionamiento SET DEFAULT nextval('gestion_hotel.cargo_estacionamiento_id_estacionamiento_seq'::regclass);



ALTER TABLE gestion_hotel."CIUDADES" ALTER COLUMN id_ciudad SET DEFAULT nextval('gestion_hotel.ciudades_id_ciudad_seq'::regclass);



ALTER TABLE gestion_hotel."CLIENTES" ALTER COLUMN id_clientes SET DEFAULT nextval('gestion_hotel.clientes_id_clientes_seq'::regclass);



ALTER TABLE gestion_hotel."COMPRAS_INSUMOS" ALTER COLUMN id_compra SET DEFAULT nextval('gestion_hotel.compras_insumos_id_compra_seq'::regclass);



ALTER TABLE gestion_hotel."DEDUCCIONES_FACTURA" ALTER COLUMN id_deducciones_factura SET DEFAULT nextval('gestion_hotel.deducciones_factura_id_deducciones_factura_seq'::regclass);



ALTER TABLE gestion_hotel."DETALLES_PROMOCION" ALTER COLUMN id_detalles_promocion SET DEFAULT nextval('gestion_hotel.detalles_promocion_id_detalles_promocion_seq'::regclass);

ALTER TABLE gestion_hotel."DETALLE_COMPRA_INSUMOS" ALTER COLUMN id_detalle_compra SET DEFAULT nextval('gestion_hotel.detalle_compra_id_detalle_compra_seq'::regclass);


ALTER TABLE gestion_hotel."DETALLE_COMPRA_MOBILIARIO" ALTER COLUMN id_detalle_compra_mobiliarios SET DEFAULT nextval('gestion_hotel.detalle_compra_mobiliarios_id_detalle_compra_mobiliarios_seq'::regclass);



ALTER TABLE gestion_hotel."DETALLE_FACTURA" ALTER COLUMN id_detalle_factura SET DEFAULT nextval('gestion_hotel.detalle_factura_id_detalle_factura_seq'::regclass);



ALTER TABLE gestion_hotel."DETALLE_PEDIDO_PROVEEDOR" ALTER COLUMN id_detalle_pedido_proveedor SET DEFAULT nextval('gestion_hotel.detalle_pedido_proveedor_id_detalle_pedido_proveedor_seq'::regclass);



ALTER TABLE gestion_hotel."DETALLE_PLATILLO" ALTER COLUMN id_detalles_platillo SET DEFAULT nextval('gestion_hotel.detalles_platillo_id_detalles_platillo_seq'::regclass);


ALTER TABLE gestion_hotel."DETALLE_SERVICIO_HABITACION" ALTER COLUMN id_detalle_servicio_habitacion SET DEFAULT nextval('gestion_hotel.detalle_servicio_habitacion_id_detalle_servicio_habitacion_seq'::regclass);


ALTER TABLE gestion_hotel."DETALLE_TRANSPORTE" ALTER COLUMN id_detalle_transporte SET DEFAULT nextval('gestion_hotel.detalle_transporte_id_detalle_transporte_seq'::regclass);


ALTER TABLE gestion_hotel."EMPLEADOS" ALTER COLUMN numero_tarjeta SET DEFAULT nextval('gestion_hotel.empleados_numero_tarjeta_seq'::regclass);


ALTER TABLE gestion_hotel."ENCABEZADO_COMPRA_MOBILIARIO" ALTER COLUMN id_compra_mobiliario SET DEFAULT nextval('gestion_hotel.encabezado_compra_mobiliario_id_compra_seq'::regclass);


ALTER TABLE gestion_hotel."ENCABEZADO_PLATILLOS" ALTER COLUMN id_platillo SET DEFAULT nextval('gestion_hotel.encabezado_platillos_id_platillo_seq'::regclass);


ALTER TABLE gestion_hotel."ESTACIONAMIENTOS" ALTER COLUMN id_estacionamiento SET DEFAULT nextval('gestion_hotel.estacionamiento_id_estacionamiento_seq'::regclass);


ALTER TABLE gestion_hotel."ESTACIONAMIENTOS" ALTER COLUMN id_sucursal SET DEFAULT nextval('gestion_hotel.estacionamiento_id_sucursal_seq'::regclass);


ALTER TABLE gestion_hotel."ESTADOS" ALTER COLUMN id_estado SET DEFAULT nextval('gestion_hotel.estado_id_estado_seq'::regclass);



ALTER TABLE gestion_hotel."ESTADO_HABITACION" ALTER COLUMN id_estado_habitacion SET DEFAULT nextval('gestion_hotel.estado_habitacion_id_estado_habitacion_seq'::regclass);



ALTER TABLE gestion_hotel."ESTADO_MANTENIMIENTO" ALTER COLUMN id_estado_mantenimiento SET DEFAULT nextval('gestion_hotel.estado_mantenimiento_id_estado_mantenimiento_seq'::regclass);



ALTER TABLE gestion_hotel."ESTADO_RESERVACION" ALTER COLUMN id_estado_reservacion SET DEFAULT nextval('gestion_hotel.estado_reservacion_id_estado_reservacion_seq'::regclass);



ALTER TABLE gestion_hotel."ESTADO_TRANSPORTE" ALTER COLUMN id_estado_transporte SET DEFAULT nextval('gestion_hotel.estado_transporte_id_estado_transporte_seq'::regclass);



ALTER TABLE gestion_hotel."ESTATUS_PAGO" ALTER COLUMN id_estatus_pago SET DEFAULT nextval('gestion_hotel.estatus_pago_id_estatus_pago_seq'::regclass);



ALTER TABLE gestion_hotel."FACTURAS" ALTER COLUMN id_factura SET DEFAULT nextval('gestion_hotel.factura_id_factura_seq'::regclass);



ALTER TABLE gestion_hotel."HABITACIONES" ALTER COLUMN numero_habitacion SET DEFAULT nextval('gestion_hotel.habitacion_id_seq'::regclass);


ALTER TABLE gestion_hotel."HISTORIAL_PRECIO_HABITACIONES" ALTER COLUMN id_historial_precios_habitaciones SET DEFAULT nextval('gestion_hotel.historial_precios_habitacione_id_historial_precios_habitaci_seq'::regclass);


ALTER TABLE gestion_hotel."HISTORIAL_PRECIO_HABITACIONES" ALTER COLUMN id_tipo_habitacion SET DEFAULT nextval('gestion_hotel.historial_precios_habitaciones_id_tipo_habitacion_seq'::regclass);


ALTER TABLE gestion_hotel."HISTORIAL_PRECIO_SERVICIOS" ALTER COLUMN id_historial_precios_servicios SET DEFAULT nextval('gestion_hotel.historial_precios_servicios_id_historial_precios_servicios_seq'::regclass);


ALTER TABLE gestion_hotel."HISTORIAL_PRECIO_SERVICIOS" ALTER COLUMN id_servicio SET DEFAULT nextval('gestion_hotel.historial_precios_servicios_id_servicio_seq'::regclass);



ALTER TABLE gestion_hotel."HOTEL" ALTER COLUMN id_hotel SET DEFAULT nextval('gestion_hotel.hotel_id_hotel_seq'::regclass);



ALTER TABLE gestion_hotel."INSUMOS" ALTER COLUMN id_insumos SET DEFAULT nextval('gestion_hotel.insumos_id_insumos_seq'::regclass);



ALTER TABLE gestion_hotel."INVENTARIO_HABITACION" ALTER COLUMN id_inventario_habitacion SET DEFAULT nextval('gestion_hotel.inventario_habitacion_id_inventario_habitacion_seq'::regclass);


ALTER TABLE gestion_hotel."MANTENIMIENTOS" ALTER COLUMN id_mantenimiento SET DEFAULT nextval('gestion_hotel.mantenimiento_id_mantenimiento_seq'::regclass);



ALTER TABLE gestion_hotel."MARCAS" ALTER COLUMN id_marca SET DEFAULT nextval('gestion_hotel.marcas_id_marca_seq'::regclass);


ALTER TABLE gestion_hotel."METODO_PAGO" ALTER COLUMN id_metodo_pago SET DEFAULT nextval('gestion_hotel.metodo_pago_id_metodo_pago_seq'::regclass);




ALTER TABLE gestion_hotel."MOBILIARIOS" ALTER COLUMN id_mobiliario SET DEFAULT nextval('gestion_hotel.mobiliarios_id_seq'::regclass);


ALTER TABLE gestion_hotel."PAGOS" ALTER COLUMN id_pago SET DEFAULT nextval('gestion_hotel.pago_id_pago_seq'::regclass);



ALTER TABLE gestion_hotel."PEDIDO_PROVEEDOR" ALTER COLUMN id_pedido_proveedor SET DEFAULT nextval('gestion_hotel.pedido_proveedor_id_pedido_proveedor_seq'::regclass);



ALTER TABLE gestion_hotel."PROVEEDORES_INSUMOS" ALTER COLUMN id_proveedor_insumos SET DEFAULT nextval('gestion_hotel.proveedores_id_proveedor_seq'::regclass);



ALTER TABLE gestion_hotel."PROVEEDORES_MOBILIARIOS" ALTER COLUMN id_proveedor_mobiliario SET DEFAULT nextval('gestion_hotel.proveedores_mobiliarios_id_proveedor_mobiliario_seq'::regclass);


ALTER TABLE gestion_hotel."PUESTOS" ALTER COLUMN id_puesto SET DEFAULT nextval('gestion_hotel.puesto_id_puesto_seq'::regclass);


ALTER TABLE gestion_hotel."RESERVACIONES" ALTER COLUMN id_reservacion SET DEFAULT nextval('gestion_hotel.reservaciones_id_reservation_seq'::regclass);



ALTER TABLE gestion_hotel."SALON" ALTER COLUMN id_salon SET DEFAULT nextval('gestion_hotel.salon_id_salon_seq'::regclass);


ALTER TABLE gestion_hotel."SALON" ALTER COLUMN id_sucursal SET DEFAULT nextval('gestion_hotel.salon_id_sucursal_seq'::regclass);



ALTER TABLE gestion_hotel."SERVICIOS" ALTER COLUMN id_servicio SET DEFAULT nextval('gestion_hotel.servicio_id_servicio_seq'::regclass);

ALTER TABLE gestion_hotel."SERVICIO_HABITACION" ALTER COLUMN id_servicio_habitacion SET DEFAULT nextval('gestion_hotel.servicio_habitacion_id_servicio_habitacion_seq'::regclass);



ALTER TABLE gestion_hotel."SUCURSALES" ALTER COLUMN id_sucursal SET DEFAULT nextval('gestion_hotel.sucursales_id_sucursal_seq'::regclass);



ALTER TABLE gestion_hotel."TIPO_CAMAS" ALTER COLUMN id_tipo_cama SET DEFAULT nextval('gestion_hotel.tipo_cama_id_tipo_cama_seq'::regclass);



ALTER TABLE gestion_hotel."TIPO_HABITACIONES" ALTER COLUMN id_tipo_habitacion SET DEFAULT nextval('gestion_hotel.tipo_habitacion_id_seq'::regclass);



ALTER TABLE gestion_hotel."TIPO_MANTENIMIENTOS" ALTER COLUMN id_tipo_mantenimiento SET DEFAULT nextval('gestion_hotel.tipo_mantenimiento_id_tipo_mantenimiento_seq'::regclass);



ALTER TABLE gestion_hotel."TIPO_TRANSPORTE_EMPLEADOS" ALTER COLUMN id_tipo_transporte SET DEFAULT nextval('gestion_hotel.tipo_transporte_id_tipo_transporte_seq'::regclass);


ALTER TABLE gestion_hotel."TRANSPORTE_EMPLEADOS" ALTER COLUMN id_transporte_empleado SET DEFAULT nextval('gestion_hotel.transporte_empleados_id_transporte_empleado_seq'::regclass);

INSERT INTO gestion_hotel."CIUDADES" (id_estado, nombre_ciudad) VALUES
(2, 'Maxiao'),
(3, 'Ban Mai'),
(4, 'Meixian'),
(5, 'Alicia'),
(6, 'Aygavan'),
(7, 'Áthyra'),
(8, 'Łaziska Górne'),
(9, 'Enskede'),
(10, 'Lameiras'),
(11, 'Sinanju'),
(12, 'Umeå'),
(13, 'Reconquista'),
(14, 'Sabang'),
(15, 'Cabungan'),
(16, 'Ronfe'),
(17, 'Villa Gesell'),
(18, 'Stockholm'),
(19, 'San Quintin'),
(20, 'Yijing'),
(21, 'San José de Mayo'),
22, 'Machov'),
(23, 'Káto Dhiminió'),
(24, 'Gandusari'),
(25, 'Ramenki'),
(26, 'Gondifelos'),
(27, 'Lalukoen Dua'),
(28, 'Penápolis'),
(29, 'Fryčovice'),
(30, 'Youfang'),
(31, '‘Alāqahdārī Gēlān'),
(32, 'Orichi'),
(33, 'Queluz de Baixo'),
(34, 'Valbo'),
(35, 'Gävle'),
(36, 'Demir Hisar'),
(37, 'Wuci'),
(38, 'Petrodvorets'),
(39, 'Jiangchang'),
(40, 'Laau'),
(41, 'Nubma'),
(42, 'Kadurahayu'),
(43, 'Mgachi'),
(44, 'Jinghong'),
(45, 'Cicapar'),
(46, 'Bylym'),
(47, 'Seso'),
(48, 'Halden'),
(49, 'Jintao'),
(50, 'Datarkadu'),
(51, 'Lady Grey'),
(52, 'Qiankou'),
(53, 'Masarayao'),
(54, 'Medicine Hat'),
(55, 'Mandor'),
(56, 'Zambujal'),
(57, 'Pangpang'),
(58, 'Divača'),
(59, 'Novomyshastovskaya'),
(60, 'Halle'),
(61, 'Huanghua'),
(62, 'Pingqiao'),
(63, 'Xibei'),
(64, 'Casais'),
(65, 'Yidu'),
(66, 'Nal’chik'),
(67, 'Saintes'),
(68, 'Xijiao'),
(69, 'Dayton'),
(70, 'Vuzenica'),
(71, 'Temeke'),
(72, 'Cabinda'),
(73, 'Bitica'),
(74, 'Huyuan'),
(75, 'Armação'),
(76, 'Jingjiao'),
(77, 'Pitomača'),
(78, 'Aketi'),
(79, 'Babakantonggoh'),
(80, 'Skënderbegas'),
(81, 'Belén de Escobar'),
(82, 'La Plaine-Saint-Denis'),
(83, 'Zhangxi'),
(84, 'San Miguel de Tucumán'),
(85, 'Huaishu'),
(86, 'Balally'),
(87, 'Depapre'),
(88, 'Huyuan'),
(89, 'Numata'),
(90, 'Kushelevka'),
(91, 'Yecun'),
(92, 'La Libertad'),
(93, 'Santa Anita'),
(94, 'Dingbao'),
(95, 'Columbeira'),
(96, 'Regimin'),
(97, 'Kamenica'),
(98, 'Lazarat'),
(99, 'Zaječov'),
(100, 'São Bartolomeu'),
(101, 'Cimahi'),
(102, 'Candoni'),
(103, 'Spånga'),
(104, 'Eisen'),
(105, 'Rusocice'),
(106, 'Kotabaru'),
(107, 'Shōbara'),
(108, 'Xiaozhang'),
(109, 'Pervomayskaya'),
(110, 'Veselí nad Lužnicí'),
(111, 'Kansas City'),
(112, 'Huzhen'),
(113, 'Brive-la-Gaillarde'),
(114, 'Zanjān'),
(115, 'Géfyra'),
(116, 'Sebewe'),
(117, 'Bobolice'),
(118, 'Luoqiao'),
(119, 'Göteborg'),
(120, 'Huangling'),
(121, 'Motrico'),
(122, 'Huaqiao'),
(123, 'Lephalale'),
(124, 'Gaohong'),
(125, 'Mesopotam'),
(126, 'Oke Mesi'),
(127, 'Helang'),
(128, 'Zakliczyn'),
(129, 'Ait Ali'),
(130, 'Pushkino'),
(131, 'Krasnogorskoye'),
(132, 'Breda'),
(133, 'Rayevskaya'),
(134, 'Garland'),
(135, 'Boulogne-Billancourt'),
(136, 'Belogorskīy'),
(137, 'Longwan'),
(138, 'Hînceşti'),
(139, 'Ketovo'),
(140, 'Bairro'),
(141, 'Ovacik'),
(142, 'La Cruz'),
(143, 'Kahabe'),
(144, 'Taquara'),
(145, 'Xiaxihao'),
(146, 'Al Mazzūnah'),
(147, 'Baryshivka'),
(148, 'La Concepción'),
(149, 'Las Carreras'),
(150, 'Krajan Gading'),
(151, 'Quxi'),
(152, 'Peza e Madhe'),
(153, 'Xaysetha'),
(154, 'Phu Kradueng'),
(155, 'Yueyang'),
(156, 'Haczów'),
(157, 'Youngstown'),
(158, 'Ingenio'),
(159, 'El Matama'),
(160, 'Várzeas'),
(161, 'Hecun'),
(162, 'Suba'),
(163, 'Aleksandrovac'),
(164, 'Tim'),
(165, 'Marseille'),
(166, 'Thành Phố Hạ Long'),
(167, 'Ungus-Ungus'),
(168, 'Arcueil'),
(169, 'Krajan Jamprong'),
(170, 'Penalva'),
(171, 'Khon Buri'),
(172, 'Bayan Uula Sumu'),
(173, 'Ribeirão da Ilha'),
(174, 'Meaux'),
(175, 'Askaniya Nova'),
(176, 'Charenton-le-Pont'),
(177, 'Gununglarang'),
(178, 'Neochórion'),
(179, 'Meilin'),
(180, 'Cashel'),
(181, 'Sant Cugat Del Valles'),
(182, 'Khiv'),
(183, 'Longwood'),
(184, 'Agriá'),
(185, 'Sosnytsya'),
(186, 'Yermish’'),
(187, 'Kawalimukti'),
(188, 'Cibangun Tengah'),
(189, 'Alfta'),
(190, 'Jindong'),
(191, 'Shuanglu'),
(192, 'Bang Kruai'),
(193, 'San Javier'),
(194, 'Piedrancha'),
(195, 'Néos Skopós'),
(196, 'Mangere'),
(197, 'Pasirnangka'),
(198, 'Zlynka'),
(199, 'San Diego'),
(200, 'Quintela'),
(201, 'Côte-Saint-Luc'),
(202, 'Bondoufle'),
(203, 'Düsseldorf'),
(204, 'Dishnā'),
(205, 'Maputsoe'),
(206, 'Siheyuan'),
(207, 'Wangzuizi'),
(208, 'Geoktschai'),
(209, 'Düsseldorf'),
(210, 'Fosca'),
(211, 'Su-dong'),
(212, 'Oesain'),
(213, 'Gangdong'),
(214, 'Quinta do Sobrado'),
(215, 'Hangwula'),
(216, 'Mets Parni'),
(217, 'Takanabe'),
(218, 'Novo Selo'),
(219, 'Daxi'),
(220, 'Châu Thành'),
(221, 'Varėna'),
(222, 'Osvaldo Cruz'),
(223, 'Dunleer'),
(224, 'Lile'),
(225, 'Butiá'),
(226, 'Morrito'),
(227, 'Miringa'),
(228, 'Hagonoy'),
(229, 'Koropí'),
(230, 'Glubokiy'),
(231, 'Emiliano Zapata'),
(232, 'Jacaraú'),
(233, 'Novotitarovskaya'),
(234, 'Ogōri-shimogō'),
(235, 'Taotang'),
(236, 'Uman’'),
(237, 'Vélo'),
(238, 'Avon'),
(239, 'Oni'),
(240, 'Sindanghayu'),
(241, 'Cruz das Almas'),
(242, 'Keroak'),
(243, 'Jūrīsh'),
(244, 'Kirkop'),
(245, 'Asamboka'),
(246, 'Tha Mai'),
(247, 'Maba'),
(248, 'Cimişlia'),
(249, 'Himaya'),
(250, 'Hässelby'),
(251, 'Sankui'),
(252, 'Fonte Boa'),
(253, 'Alīābad'),
(254, 'Dulce Nombre de Culmí'),
(255, 'Clogherhead'),
(256, 'Helsingborg'),
(257, 'Isoka'),
(258, 'Strelka'),
(259, 'Horta'),
(260, 'Byala Slatina'),
(261, 'Bagumbayan'),
(262, 'Luanshya'),
(263, 'Tân Việt'),
(264, 'Santo Domingo Oeste'),
(265, 'Dongxi'),
(266, 'Cunliji'),
(267, 'Raman'),
(268, 'San Jose'),
(269, 'Parchal'),
(270, 'Tianfen'),
(271, 'Yanhe'),
(272, 'Lavras da Mangabeira'),
(273, 'Kuala Terengganu'),
(274, 'Pyatigorskiy'),
(275, 'Ranua'),
(276, 'Dasha'),
(277, 'Karlivka'),
(278, 'Acaraú'),
(279, 'Kiruru'),
(280, 'Taunggyi'),
(281, 'Badaogu'),
(282, 'Būrabay'),
(283, 'Kaiama'),
(284, 'Hetoudian'),
(285, 'Puyuan'),
(286, 'Narutochō-mitsuishi'),
(287, 'Dziergowice'),
(288, 'Cut-cut Primero'),
(289, 'Ejidal'),
(290, 'Trawniki'),
(291, 'Kirkop'),
(292, 'Giemdiem'),
(293, 'Shuhe'),
(294, 'Popayán'),
(295, 'Espérance Trébuchet'),
(296, 'Jibu'),
(297, 'Loúros'),
(298, 'Bāgh-e Malek'),
(299, 'Poretskoye'),
(300, 'Lantera'),
(301, 'Tomarovka'),
(302, 'Wuyang'),
(303, 'Aracataca'),
(304, 'Wakayama-shi'),
(305, 'Weihe'),
(306, 'Soutelo'),
(307, 'Kolsko'),
(308, 'Labytnangi'),
(309, 'Ganxi'),
(310, 'Pagnag'),
(311, 'Pécs'),
(312, 'Cihe'),
(313, 'Gongming'),
(314, 'Barra do Bugres'),
(315, 'Al Mālikīyah'),
(316, 'Xianghu'),
(317, 'Santiago'),
(318, 'Sulahan'),
(319, 'Palomoc'),
(320, 'Codrington'),
(321, 'Krajan'),
(322, 'Mbanza Congo'),
(323, 'Xinjiang'),
(324, 'Juru'),
(325, 'Tuchengzi'),
(326, 'Sangalhos'),
(327, 'Szynwałd'),
(328, 'Al Ya‘rubīyah'),
(329, 'Karamat'),
(330, 'Kubangsari'),
(331, 'Pánormos'),
(332, 'Roma'),
(333, 'Padurung'),
(334, 'Rožďalovice'),
(335, 'Awarawar'),
(336, 'Tacurong'),
(337, 'Kōriyama'),
(338, 'Lakkíon'),
(339, 'Taldan'),
(340, 'Petrovskoye'),
(341, 'Nanterre'),
(342, 'Tambawel'),
(343, 'Malapaubhara'),
(344, 'Wucheng'),
(345, 'São Carlos'),
(346, 'Sarapul'),
(347, 'Qionghu'),
(348, 'Ragay'),
(349, 'Mombasa'),
(350, 'Riyadh'),
(351, 'Vallegrande'),
(352, 'K’ulashi'),
(353, 'Cieplice Śląskie Zdrój'),
(354, 'Kintinku'),
(355, 'El Mirador'),
(356, 'Neklyudovo'),
(357, 'Hoeryŏng'),
(358, 'Santo Amaro'),
(359, 'San Francisco'),
(360, 'Qianjiang'),
(361, 'Skellefteå'),
(362, 'Złotniki Kujawskie'),
(363, 'Mozhaysk'),
(364, 'Áyios Yeóryios'),
(365, 'Songkar B'),
(366, 'Benhong'),
(367, 'Limulan'),
(368, 'San Francisco'),
(369, 'Villa Lugano'),
(370, 'Pivijay'),
(371, 'Luoping'),
(372, 'Ngangguk'),
(373, 'Nandulehe'),
(374, 'Meruge'),
(375, 'São Bartolomeu'),
(376, 'Youcheng'),
(377, 'Kertasari'),
(378, 'San Vicente Pacaya'),
(379, 'Padangulaktanding'),
(380, 'Krasnaya Polyana'),
(381, 'Devon'),
(382, 'Burirao'),
(383, 'Fajsławice'),
(384, 'Sosándra'),
(385, 'Balrothery'),
(386, 'Pailin'),
(387, 'Getazat'),
(388, 'Tierimu'),
(389, 'Antonio Toledo Corro'),
(390, 'Karlstad'),
(391, 'Yuchi'),
(392, 'La Dorada'),
(393, 'Arroio Grande'),
(394, 'Handaqi'),
(395, 'Biankouma'),
(396, 'Registro'),
(397, 'Czarna'),
(398, 'Pākpattan'),
(399, 'Rado'),
(400, 'Semeljci'),
(401, 'Cheqiao'),
(402, 'Dek’emhāre'),
(403, 'Kushnarënkovo'),
(404, 'Chełm'),
(405, 'Taquaritinga'),
(406, 'Vidyayevo'),
(407, 'Carregal'),
(408, 'Colonia Minga Porá'),
(409, 'Breda'),
(410, 'Žirovnica'),
(411, 'Leskovec pri Krškem'),
(412, 'Esik'),
(413, 'Sukaratu'),
(414, 'Kombësi'),
(415, 'Néa Karváli'),
(416, 'Jetak'),
(417, 'Douliu'),
(418, 'Blagodatnoye'),
(419, 'Minante Segundo'),
(420, 'Yelenendorf'),
(421, 'Naples'),
(422, 'Chartres'),
(423, 'Donomulyo'),
(424, 'Youlongchuan'),
(425, 'Orlovskiy'),
(426, 'Créteil'),
(427, 'Toledo'),
(428, 'Lyantonde'),
(429, 'Krajan Tengah'),
(430, 'Düsseldorf'),
(431, 'Marka'),
(432, 'Muheza'),
(433, 'Tojeira'),
(434, 'Bateria'),
(435, 'Basiong'),
(436, 'Bulan'),
(437, 'Minggang'),
(438, 'Tegalbuleud'),
(439, 'Sułkowice'),
(440, 'Talnakh'),
(441, 'Boljevci'),
(442, 'Paloh'),
(443, 'Las Palmas'),
(444, 'Bistrica ob Sotli'),
(445, 'Yangdenghu'),
(446, 'Eksjö'),
(447, 'Sukošan'),
(448, 'Fuling'),
(449, 'Kembangan'),
(450, 'Shebalino'),
(451, 'San Sebastian'),
(452, 'Sañgay'),
(453, 'Upton'),
(454, 'Hovtashen'),
(455, 'Ciudad Bolivia'),
(456, 'Dioknisi'),
(457, 'Aubergenville'),
(458, 'Urengoy'),
(459, 'Oliveira'),
(460, 'Margahayukencana'),
(461, 'Barentu'),
(462, 'Vetluzhskiy'),
(463, 'Shangma'),
(464, 'Nyima'),
(465, 'Erdaohe'),
(466, 'Yelyzavethradka'),
(467, 'Ústí nad Labem'),
(468, 'Cárdenas'),
(469, 'Qiganjidie'),
(470, 'Spodnja Hajdina'),
(471, 'Bununu Dass'),
(472, 'Pedrogão'),
(473, 'Podbrdo'),
(474, 'Naguilian'),
(475, 'Bagong Barrio'),
(476, 'Novoye Devyatkino'),
(477, 'Mboursou Léré'),
(478, 'Roma'),
(479, 'Shencun'),
(480, 'Dinghuo'),
(481, 'Qinghe'),
(482, 'Ocaña'),
(483, 'Lewo'),
(484, 'Ribeira Seca'),
(485, 'Coronel Fabriciano'),
(486, 'Ponce'),
(487, 'Bangbayang'),
(488, 'Pangradin Satu'),
(489, 'Gyangqai'),
(490, 'San Felipe'),
(491, 'Pingtang'),
(492, 'Sabana Grande'),
(493, 'Yerazgavors'),
(494, 'Phon Charoen'),
(495, 'Monterrey'),
(496, 'Kadugedong'),
(497, 'Janja'),
(498, 'El Corozo'),
(499, 'Mandapajaya'),
(500, 'Wongaya Kaja'),
(501, 'Guangning'),
(502, 'Duyang'),
(503, 'Rawa Satu'),
(504, 'Hino'),
(505, 'Nilanapo'),
(506, 'Pare'),
(507, 'Birātnagar'),
(508, 'Orós'),
(509, 'Modimolle'),
(510, 'Guarulhos'),
(511, 'Naifalo'),
(512, 'Partang'),
(513, 'Pasongsongan'),
(514, 'Cigadung'),
(515, 'Stare Pole'),
(516, 'Zhifang'),
(517, 'Sapeken'),
(518, 'Zhaolingpu'),
(519, 'Czchów'),
(520, 'Tabira'),
(521, 'Birmingham'),
(522, 'Bulgan'),
(523, 'Deskle'),
(524, 'Manticao'),
(525, 'Botucatu'),
(526, 'Kolbuszowa'),
(527, 'Bitam'),
(528, 'Lago dos Rodrigues'),
(529, 'Pangani'),
(530, 'Arcoverde'),
(531, 'Itanhandu'),
(532, 'Rzepiennik Strzyżewski'),
(533, 'Prilep'),
(534, 'Kuala Lumpur'),
(535, 'Dongzaogang'),
(536, 'Västra Frölunda'),
(537, 'Sanhe'),
(538, 'Wenfang'),
(539, 'Dębno'),
(540, 'Gio Linh'),
(541, 'Kopen'),
(542, 'Tân Hưng'),
(543, 'Goiás'),
(544, 'Jindaoxia'),
(545, 'Saint-Lô'),
(546, 'Chiguang'),
(547, 'Pakemitan Dua'),
(548, 'Huangben'),
(549, 'Meliau'),
(550, 'Puttalam'),
(551, 'Werasari'),
(552, 'Seremban'),
(553, 'Huaccana'),
(554, 'Tallbīsah'),
(555, 'Riyadh'),
(556, 'Mardā'),
(557, 'Sanjie'),
(558, 'Helsingborg'),
(559, 'Krzeszów'),
(560, 'Bo Phloi'),
(561, 'Marte'),
(562, 'Dhangarhi'),
(563, 'Ngulakan'),
(564, 'Gaya'),
(565, 'Khlevnoye'),
(566, 'Vale das Mós'),
(567, 'Harderwijk'),
(568, 'Guashe'),
(569, 'Espinillo'),
(570, 'Chengtou'),
(571, 'Qingshan'),
(572, 'Banjar Tiga'),
(573, 'Václavovice'),
(574, 'La Gi'),
(575, 'Powassan'),
(576, 'Várzea'),
(577, 'Santander'),
(578, 'Oumé'),
(579, 'Itapecerica da Serra'),
(580, 'Pochayiv'),
(581, 'Měřín'),
(582, 'Cangkreng'),
(583, 'Wręczyca Wielka'),
(584, 'Caen'),
(585, 'Caluya'),
(586, 'Seydi'),
(587, 'Cumanacoa'),
(588, 'Dao'),
(589, 'San Lucas'),
(590, 'Ash Shaḩānīyah'),
(591, 'Guling'),
(592, 'Shaogongzhuang'),
(593, 'Girihieum'),
(594, 'Thị Trấn Hà Trung'),
(595, 'Baisha'),
(596, 'Askiz'),
(597, 'Banjar Gunungpande'),
(598, 'Mufushan'),
(599, 'Tataouine'),
(600, 'Carice'),
(601, 'Don Chedi'),
(602, 'Glubokiy'),
(603, 'Winneba'),
(604, 'Aseri'),
(605, 'Deep River'),
(606, 'Baiquesi'),
(607, 'Sungai Raya'),
(608, 'Wufeng'),
(609, 'Cama Juan'),
(610, 'Göteborg'),
(611, 'Sakhipur'),
(612, 'Tiandian'),
(613, 'Gävle'),
(614, 'Klagen'),
(615, 'Guanshan'),
(616, 'Venezuela'),
(617, 'Manalongon'),
(618, 'Quimper'),
(619, 'Siguiri'),
(620, 'Texíguat'),
(621, 'Dijon'),
(622, 'Borås'),
(623, 'Mala Danylivka'),
(624, 'Igarapé Miri'),
(625, 'Maglaj'),
(626, 'San Miguel'),
(627, 'Tarbagatay'),
(628, 'Urambo'),
(629, 'Macamic'),
(630, 'Shani'),
(631, 'Bergen'),
(632, 'Měcholupy'),
(633, 'Baleagung'),
(634, 'Nizhniye Vyazovyye'),
(635, 'Maracanaú'),
(636, 'Qiandian'),
(637, 'Russkaya Polyana'),
(638, 'Zarzal'),
(639, 'Talanga'),
(640, 'Yeniugou'),
(641, 'Pathum Ratchawongsa'),
(642, 'Perbaungan'),
(643, 'Sampués'),
(644, 'Blois'),
(645, 'Al Maḩjal'),
(646, 'Lāchi'),
(647, 'San Felipe'),
(648, 'Chợ Gạo'),
(649, 'Mestre'),
(650, 'Jiangchang'),
(651, 'Bansalan'),
(652, 'Kapsabet'),
(653, 'Dvinskoy'),
(654, 'Los Boquerones'),
(655, 'Novoselec'),
(656, 'Kutloanong'),
(657, 'Al Ḩudaydah'),
(658, 'Vaughan'),
(659, 'Shihuiyao'),
(660, 'Libog'),
(661, 'Whistler'),
(662, 'San Rafael del Sur'),
(663, 'Novoanninskiy'),
(664, 'Bombu'),
(665, 'Malianchuan'),
(666, 'Qŭshkŭpir'),
(667, 'Antananarivo'),
(668, 'Luyi'),
(669, 'Banjar Bali'),
(670, 'Serra de Santa Marinha'),
(671, 'Heku'),
(672, 'Changtan'),
(673, 'Ngromo'),
(674, 'Baryshivka'),
(675, 'Teresita'),
(676, 'Longjiang'),
(677, 'Quimperlé'),
(678, 'João Câmara'),
(679, 'Patulul'),
(680, 'Brusyanka'),
(681, 'Viitasaari'),
(682, 'Heishui'),
(683, 'Ash Shafā'),
(684, 'Keumala'),
(685, 'Makale'),
(686, 'Francisco Beltrão'),
(687, 'Piedade'),
(688, 'Ngedhusuba'),
(689, 'Trzciana'),
(690, 'Karata'),
(691, 'Gayam'),
(692, 'Iwŏn-ŭp'),
(693, 'Ourentã'),
(694, 'Xuancheng'),
(695, 'Sieroszewice'),
(696, 'Trenggulunan'),
(697, 'Kabor'),
(698, 'Yanshi'),
(699, 'Baorixile'),
(700, 'Sundbyberg'),
(701, 'Huagu'),
(702, 'Villa del Carmen'),
(703, 'Hekou'),
(704, 'Faeanak Dua'),
(705, 'Simao'),
(706, 'Miðvágur'),
(707, 'Xinxing'),
(708, 'Kuala Lumpur'),
(709, 'Lelystad'),
(710, 'Cap Malheureux'),
(711, 'Bajram Curri'),
(712, 'Jinzhou'),
(713, 'Kukichūō'),
(714, 'Guanyinsi'),
(715, 'Fenghuangshan'),
(716, 'Wuda'),
(717, 'Malita'),
(718, 'Pejibaye'),
(719, 'Aş Şalw'),
(720, 'Tohautu'),
(721, 'Riba de Ave'),
(722, 'La Esperanza'),
(723, 'Edosaki'),
(724, 'Hengdian'),
(725, 'Pokrovskoye-Streshnëvo'),
(726, 'San Rafael'),
(727, 'Santa Justina'),
(728, 'Cruces de Anorí'),
(729, 'Voskresensk'),
(730, 'Palopo'),
(731, 'Thoen'),
(732, 'Amieira'),
(733, 'Ploemeur'),
(734, 'Fengting'),
(735, 'Kato Pyrgos'),
(736, 'Omaruru'),
(737, 'Pakxé'),
(738, 'Hasuda'),
(739, 'Itapé'),
(740, 'Awgu'),
(741, 'Ostravice'),
(742, 'Sankt Andrä-Höch'),
(743, 'Mirebalais'),
(744, 'Główczyce'),
(745, 'Denver'),
(746, 'Luzino'),
(747, 'Port Maria'),
(748, 'Bal’shavik'),
(749, 'Kaeng Khoi'),
(750, 'Bình Thủy'),
(751, 'Wenceslao Escalante'),
(752, 'Piúma'),
(753, 'Poretskoye'),
(754, 'Al Khushnīyah'),
(755, 'Ivouani'),
(756, 'Combapata'),
(757, 'Eskilstuna'),
(758, 'Qesarya'),
(759, 'Hargeysa'),
(760, 'Ordzhonikidzevskaya'),
(761, 'Telbang'),
(762, 'Muquiyauyo'),
(763, 'Dacudao'),
(764, 'Cikawunggading'),
(765, 'Balatun'),
(766, 'Huiyuan'),
(767, 'Gorno-Altaysk'),
(768, 'Lengor'),
(769, 'Yongding'),
(770, 'Suntar'),
(771, 'Yantian'),
(772, 'Gēdo'),
(773, 'Ivoti'),
(774, 'Pillpinto'),
(775, 'Xanxerê'),
(776, 'Gubu'),
(777, 'Plácido de Castro'),
(778, 'Tekeli'),
(779, 'Laiwu'),
(780, 'Ágios Pétros'),
(781, 'Getazat'),
(782, 'Denton'),
(783, 'Brzeszcze'),
(784, 'Horodok'),
(785, 'Monticello'),
(786, 'Peddie'),
(787, 'Karamat'),
(788, 'Paris 13'),
(789, 'Dushanbe'),
(790, 'La Serena'),
(791, 'Paris 06'),
(792, 'Shangsanji'),
(793, 'Dno'),
(794, 'Kuala Pilah'),
(795, 'Fukuchiyama'),
(796, 'Ad Dujayl'),
(797, 'Butha-Buthe'),
(798, 'Marovoay'),
(799, 'Bocos'),
(800, 'Binubusan'),
(801, 'Kosava'),
(802, 'Tianhe'),
(803, 'Krajan Nglinggis'),
(804, 'Puncaksari'),
(805, 'Yumbo'),
(806, 'Zhudian'),
(807, 'Buk'),
(808, 'Gambarjati'),
(809, 'Momignies'),
(810, 'As Samawah'),
(811, 'Lumbardhi'),
(812, 'Castelo'),
(813, 'San Antonio'),
(814, 'Iguatu'),
(815, 'Sampit'),
(816, 'Pervomayskoye'),
(817, 'Pedregulho'),
(818, 'Naru'),
(819, 'Nierumai'),
(820, 'Bamban'),
(821, 'Hagi'),
(822, 'El Guapinol'),
(823, 'Garanhuns'),
(824, 'Makarov'),
(825, 'Tirmiz'),
(826, 'Carayaó'),
(827, 'Nürnberg'),
(828, 'Noyon'),
(829, 'Donan'),
(830, 'Nueva Vida Sur'),
(831, 'Yuzhno-Sukhokumsk'),
(832, 'Zhumadian'),
(833, 'Stockholm'),
(834, 'Masaling'),
(835, 'Colorado Springs'),
(836, 'Karangpete'),
(837, 'Selat'),
(838, 'Tagum'),
(839, 'Yubileynyy'),
(840, 'Stockholm'),
(841, 'Bác Ái'),
(842, 'Montalegre'),
(843, 'Kantemirovka'),
(844, 'Obernai'),
(845, 'Kuching'),
(846, 'Tongjiang'),
(847, 'Corzuela'),
(848, 'Novonikol’sk'),
(849, 'Al Jahrā’'),
(850, 'Klemunan'),
(851, 'Buga'),
(852, 'Dongxing'),
(853, 'Sida'),
(854, 'Zubrzyca Dolna'),
(855, 'Menzel Bourguiba'),
(856, 'Burla'),
(857, 'Hacı Zeynalabdin'),
(858, 'Tlogowungu'),
(859, 'Matsumoto'),
(860, 'Donabate'),
(861, 'Novi Kneževac'),
(862, 'Qingshan'),
(863, 'Xinshi'),
(864, 'Isla'),
(865, 'New Agutaya'),
(866, 'Xylotymbou'),
(867, 'Karamat'),
(868, 'Spas-Klepiki'),
(869, 'Pushkino'),
(870, 'Pampas'),
(871, 'Dzhetygara'),
(872, 'Santa Ana'),
(873, 'Bīr Zayt'),
(874, 'Miramichi'),
(875, 'Iperó'),
(876, 'Boa Vista'),
(877, 'Portariá'),
(878, 'Surkhet'),
(879, 'Liuhu'),
(880, 'Bogorame'),
(881, 'Kilju'),
(882, 'Chonchi'),
(883, 'Karlovo'),
(884, 'Bhamdoun'),
(885, 'Dayr Abū Ḑa‘īf'),
(886, 'Nakhchivan'),
(887, 'Springfield'),
(888, 'Huping'),
(889, 'Trondheim'),
(890, 'Oslo'),
(891, 'Sankui'),
(892, 'Zargarān'),
(893, 'Jembayan Hitam'),
(894, 'Sicheng'),
(895, 'Xiong’erzhai'),
(896, 'Stadtbredimus'),
(897, 'Carlsbad'),
(898, 'Nguigmi'),
(899, 'Kępie Żaleszańskie'),
(900, 'Jingmen'),
(901, 'Genova'),
(902, 'Trondheim'),
(903, 'Putrajaya'),
(904, 'Pulaukijang'),
(905, 'Hondo Valle'),
(906, 'Salinas'),
(907, 'Gunungsari'),
(908, 'Mungui'),
(909, 'Stupsk'),
(910, 'Shigutang'),
(911, 'Dún Laoghaire'),
(912, 'Bobrovka'),
(913, 'Yōkaichiba'),
(914, 'Tacoma'),
(915, 'Poconé'),
(916, 'Vila Franca da Beira'),
(917, 'Waitenepang'),
(918, 'Lincoln'),
(919, 'Vista Alegre'),
(920, 'Dazhangzhuang'),
(921, 'Bolhrad'),
(922, 'Dabaozi'),
(923, 'Pasacao'),
(924, 'Memphis'),
(925, 'Leon Postigo'),
(926, 'Kasimov'),
(927, 'Cileuya'),
(928, 'Zuhu'),
(929, 'Ábrego'),
(930, 'Badāmā'),
(931, 'Tanahmerah'),
(932, 'Rudnik'),
(933, 'Borbon'),
(934, 'Sanana'),
(935, 'Huangbao'),
(936, 'Srebrenik'),
(937, 'Nicosia'),
(938, 'New Brunswick'),
(939, 'Mananjary'),
(940, 'Los Dos Caminos'),
(941, 'Palma De Mallorca'),
(942, 'Charlotte'),
(943, 'Volosovo'),
(944, 'Osieczna'),
(945, 'Keleleng'),
(946, 'Ratnapura'),
(947, 'Dhī Nā‘im'),
(948, 'Pavlovskiy Posad'),
(949, 'Maulavi Bāzār'),
(950, 'Sainte-Anne-de-Bellevue'),
(951, 'Brušperk'),
(952, 'Yangxi'),
(953, 'Maracaju'),
(954, 'Petrolina de Goiás'),
(955, 'Le Mans'),
(956, 'Ħamrun'),
(957, 'Parnamirim'),
(958, 'Dong Liang’erzhuang'),
(959, 'Klirou'),
(960, 'Petrovskiy'),
(961, 'Centenario'),
(962, 'Orimattila'),
(963, 'Shangshuai'),
(964, 'Dalongzhan'),
(965, 'Aytos'),
(966, 'Puerto Boyacá'),
(967, 'Kohāt'),
(968, 'Ōtsu-shi'),
(969, 'Vila Franca da Beira'),
(970, 'Sauce'),
(971, 'Menghai'),
(972, 'Cibodas'),
(973, 'Malawa'),
(974, 'Kaliwates'),
(975, 'Pisão'),
(976, 'Gengzhuang'),
(977, 'Arlington'),
(978, 'Żarów'),
(979, 'Sovetskiy'),
(980, 'Bumba'),
(981, 'Rozhniv'),
(982, 'Altavista'),
(983, 'Las Palmas'),
(984, 'Al ‘Awjah'),
(985, 'Poddor’ye'),
(986, 'Tashla'),
(987, 'Ndago'),
(988, 'Jianling'),
(989, 'Dogonbadan'),
(990, 'Huangbu'),
(991, 'Larreynaga'),
(992, 'Lianozovo'),
(993, 'Fada N'gourma'),
(994, 'Bacuyangan'),
(995, 'Yong’an'),
(996, 'Columbus'),
(997, 'Renhe'),
(998, 'Tanggungrejo'),
(999, 'Tymoshivka'),
(1000, 'Gangnan'),
(1, 'Maxican');

INSERT INTO gestion_hotel."AREAS" (descripcion, id_sucursal) VALUES
('Nectarinia chalybea', 2),
('Sciurus vulgaris', 3),
('Alopochen aegyptiacus', 4),
('Alcelaphus buselaphus cokii', 5),
('Trichoglossus haematodus moluccanus', 6),
('Spermophilus richardsonii', 7),
('Macropus rufogriseus', 8),
('Leptoptilus dubius', 9),
('Echimys chrysurus', 10),
('Trichoglossus chlorolepidotus', 11),
('Macaca mulatta', 12),
('Tursiops truncatus', 13),
('Otocyon megalotis', 14),
('Climacteris melanura', 15),
('Cebus nigrivittatus', 16),
('Trachyphonus vaillantii', 17),
('Sceloporus magister', 18),
('Antechinus flavipes', 19),
('Ciconia episcopus', 20),
('Equus hemionus', 21),
('Streptopelia decipiens', 22),
('Lamprotornis chalybaeus', 23),
('Cynictis penicillata', 24),
('Salvadora hexalepis', 25),
('Vulpes cinereoargenteus', 26),
('Bubo sp.', 27),
('Gyps fulvus', 28),
('Centrocercus urophasianus', 29),
('Motacilla aguimp', 30),
('Morelia spilotes variegata', 31),
('Cercopithecus aethiops', 32),
('Morelia spilotes variegata', 33),
('Ephipplorhynchus senegalensis', 34),
('Bucorvus leadbeateri', 35),
('Paradoxurus hermaphroditus', 36),
('Toxostoma curvirostre', 37),
('Aegypius tracheliotus', 38),
('Pedetes capensis', 39),
('Damaliscus dorcas', 40),
('Diomedea irrorata', 41),
('Canis lupus', 42),
('Creagrus furcatus', 43),
('Zenaida galapagoensis', 44),
('Pytilia melba', 45),
('Graspus graspus', 46),
('Macropus agilis', 47),
('Neotis denhami', 48),
('Anastomus oscitans', 49),
('Nyctereutes procyonoides', 50),
('Tayassu pecari', 51),
('Isoodon obesulus', 52),
('Sarkidornis melanotos', 53),
('Uraeginthus granatina', 54),
('Vulpes chama', 55),
('Cygnus atratus', 56),
('5Meles meles', 57),
('unavailable', 58),
('Bubalornis niger', 59),
('Larus novaehollandiae', 60),
('Colaptes campestroides', 61),
('Trachyphonus vaillantii', 62),
('Bassariscus astutus', 63),
('unavailable', 64),
('Haematopus ater', 65),
('Lutra canadensis', 66),
('Sciurus niger', 67),
('Sciurus vulgaris', 68),
('Mycteria ibis', 69),
('Chelodina longicollis', 70),
('Neophoca cinerea', 71),
('Grus rubicundus', 72),
('Varanus salvator', 73),
('Hymenolaimus malacorhynchus', 74),
('Dasyurus maculatus', 75),
('Bettongia penicillata', 76),
('Pteropus rufus', 77),
('Pelecans onocratalus', 78),
('Antechinus flavipes', 79),
('Myiarchus tuberculifer', 80),
('Dasypus novemcinctus', 81),
('Butorides striatus', 82),
('Bos taurus', 83),
('Bubo virginianus', 84),
('Speothos vanaticus', 85),
('Mellivora capensis', 86),
('Phalacrocorax carbo', 87),
('Lemur fulvus', 88),
('Bassariscus astutus', 89),
('Orcinus orca', 90),
('Ara chloroptera', 91),
('Cathartes aura', 92),
('Tayassu tajacu', 93),
('Libellula quadrimaculata', 94),
('Speothos vanaticus', 95),
('Platalea leucordia', 96),
('Haematopus ater', 97),
('Butorides striatus', 98),
('Otaria flavescens', 99),
('Alopex lagopus', 100),
('Acrantophis madagascariensis', 101),
('Sarkidornis melanotos', 102),
('Cynomys ludovicianus', 103),
('Nannopterum harrisi', 104),
('Nasua narica', 105),
('Butorides striatus', 106),
('Canis dingo', 107),
('Phalacrocorax albiventer', 108),
('unavailable', 109),
('Salvadora hexalepis', 110),
('Ovis dalli stonei', 111),
('Plegadis ridgwayi', 112),
('Macaca radiata', 113),
('Cygnus buccinator', 114),
('Naja haje', 115),
('Papio cynocephalus', 116),
('Phalaropus fulicarius', 117),
('Spermophilus richardsonii', 118),
('unavailable', 119),
('Spermophilus armatus', 120),
('Lemur fulvus', 121),
('Spheniscus mendiculus', 122),
('Alopochen aegyptiacus', 123),
('Semnopithecus entellus', 124),
('Ciconia episcopus', 125),
('Mirounga leonina', 126),
('Iguana iguana', 127),
('Aepyceros mylampus', 128),
('Otaria flavescens', 129),
('Tragelaphus scriptus', 130),
('Ceratotherium simum', 131),
('Herpestes javanicus', 132),
('Grus rubicundus', 133),
('Merops nubicus', 134),
('Diomedea irrorata', 135),
('Francolinus coqui', 136),
('Trichosurus vulpecula', 137),
('Phasianus colchicus', 138),
('Recurvirostra avosetta', 139),
('Sarcophilus harrisii', 140),
('Hymenolaimus malacorhynchus', 141),
('Corvus albicollis', 142),
('Vanellus chilensis', 143),
('Eolophus roseicapillus', 144),
('Bassariscus astutus', 145),
('Gekko gecko', 146),
('Panthera pardus', 147),
('Salvadora hexalepis', 148),
('Tamandua tetradactyla', 149),
('Vicugna vicugna', 150),
('Trichoglossus chlorolepidotus', 151),
('Amblyrhynchus cristatus', 152),
('Uraeginthus bengalus', 153),
('Francolinus coqui', 154),
('Bettongia penicillata', 155),
('Anas bahamensis', 156),
('Phalacrocorax brasilianus', 157),
('Geochelone radiata', 158),
('Marmota monax', 159),
('Trichoglossus chlorolepidotus', 160),
('Dendrocitta vagabunda', 161),
('Ardea cinerea', 162),
('Streptopelia senegalensis', 163),
('Canis mesomelas', 164),
('Gymnorhina tibicen', 165),
('Plegadis falcinellus', 166),
('Centrocercus urophasianus', 167),
('Nycticorax nycticorax', 168),
('Columba livia', 169),
('Columba livia', 170),
('Sarkidornis melanotos', 171),
('Plocepasser mahali', 172),
('Hymenolaimus malacorhynchus', 173),
('Coluber constrictor', 174),
('Canis dingo', 175),
('Varanus komodensis', 176),
('Fratercula corniculata', 177),
('Actophilornis africanus', 178),
('Halcyon smyrnesis', 179),
('Bison bison', 180),
('Spizaetus coronatus', 181),
('Phalacrocorax carbo', 182),
('Scolopax minor', 183),
('Graspus graspus', 184),
('Sylvilagus floridanus', 185),
('Macropus agilis', 186),
('Heloderma horridum', 187),
('Papio cynocephalus', 188),
('Tamiasciurus hudsonicus', 189),
('Aegypius tracheliotus', 190),
('Cereopsis novaehollandiae', 191),
('Picoides pubescens', 192),
('Ardea cinerea', 193),
('Varanus salvator', 194),
('Chamaelo sp.', 195),
('Chionis alba', 196),
('Sylvicapra grimma', 197),
('Branta canadensis', 198),
('Felis libyca', 199),
('Macropus eugenii', 200),
('Felis wiedi or Leopardus weidi', 201),
('Porphyrio porphyrio', 202),
('Alouatta seniculus', 203),
('Larus dominicanus', 204),
('Branta canadensis', 205),
('Mungos mungo', 206),
('Coracias caudata', 207),
('Spheniscus magellanicus', 208),
('Vanellus armatus', 209),
('Macropus rufogriseus', 210),
('Gymnorhina tibicen', 211),
('Hystrix cristata', 212),
('Marmota monax', 213),
('Corvus albicollis', 214),
('Agkistrodon piscivorus', 215),
('Drymarchon corias couperi', 216),
('Sarcophilus harrisii', 217),
('Naja nivea', 218),
('Fregata magnificans', 219),
('Dicrostonyx groenlandicus', 220),
('Suricata suricatta', 221),
('Canis aureus', 222),
('Kobus defassa', 223),
('Merops nubicus', 224),
('Lamprotornis chalybaeus', 225),
('Lepilemur rufescens', 226),
('Phasianus colchicus', 227),
('Ctenophorus ornatus', 228),
('Phalaropus fulicarius', 229),
('Dasyurus viverrinus', 230),
('Canis lupus lycaon', 231),
('Aquila chrysaetos', 232),
('Eudyptula minor', 233),
('Myrmecophaga tridactyla', 234),
('Ephippiorhynchus mycteria', 235),
('Melursus ursinus', 236),
('Tachyglossus aculeatus', 237),
('Calyptorhynchus magnificus', 238),
('Paraxerus cepapi', 239),
('Bucorvus leadbeateri', 240),
('Phasianus colchicus', 241),
('Numida meleagris', 242),
('Phoeniconaias minor', 243),
('Ammospermophilus nelsoni', 244),
('Hymenolaimus malacorhynchus', 245),
('Mirounga angustirostris', 246),
('Phalaropus lobatus', 247),
('Ara ararauna', 248),
('Anser caerulescens', 249),
('Kobus defassa', 250),
('Nectarinia chalybea', 1);

--
-- TOC entry 5421 (class 0 OID 40992)
-- Dependencies: 220
-- Data for Name: AUTOS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--
INSERT INTO gestion_hotel."CLIENTES" (nombre, apellido_paterno, apellido_materno, calle, colonia, codigo_postal, rfc_cliente, curp, id_ciudad, genero) VALUES 
('Mónica', 'Sánchez', 'Pérez', '7699 Avenida Norte', 'Juárez', 'MX-CMX', 'AERU881026MNQ', 'RUHD950228HDFBCX70', 101, 'F'),
('Diana', 'Gutiérrez', 'Sánchez', '7699 Avenida Norte', 'Lomas', 'ES-MD', 'AMDI820712EAD', 'DIGS830501MDFPKS74', 19, 'F'),
('Javier', 'Pérez', 'Martínez', '9502 Bulevar de la Paz', 'Reforma', 'CL-RM', 'APMA850210U09', 'JAPM901007HTLGH8F', 242, 'M'),
('Mónica', 'Torres', 'López', '5126 Calzada de la Paz', 'Condesa', 'US-CA', 'RAGU920919K3N', 'MOTL981013MTLAAS8B', 211, 'F'),
('Fernando', 'Jiménez', 'Gómez', '6048 Avenida Este', 'Polanco', 'BR-SP', 'HUHE831201Z0R', 'FEJG970525HZSWS0L4', 29, 'M'),
('Laura', 'Sánchez', 'Fernández', '356 Avenida Central', 'Jardines', 'CA-ON', 'ANVA940822K7T', 'LASF920610MTLLJS18', 151, 'F'),
('Miguel', 'Díaz', 'Álvarez', '1668 Calzada Central', 'Juárez', 'AU-VIC', 'MIMO800109Z2T', 'MIDA900405HZSBL6Q0', 115, 'M'),
('Elena', 'Martínez', 'Jiménez', '2531 Calle Norte', 'Obrera', 'VE-J', 'MIMO800109Z2T', 'ELMJ930814MCDPNN59', 270, 'F'),
('Tomás', 'López', 'Hernández', '360 Bulevar Sur', 'Campestre', 'PT-13', 'ANVA940822K7T', 'TOLH980425HGRKSR48', 174, 'M'),
('Sofía', 'Álvarez', 'Gómez', '9335 Paseo Central', 'Reforma', 'MX-JAL', 'GUGA980315Z9V', 'SOAG960517MQSJSK0L', 212, 'F'),
('Carlos', 'Martín', 'Díaz', '1668 Calzada Central', 'Juárez', 'DE-BE', 'APMA850210U09', 'CAMD920405HTLDRN40', 87, 'M'),
('Patricia', 'Romero', 'Álvarez', '8880 Avenida Norte', 'Roma', 'GB-LND', 'RAGU920919K3N', 'PROA950620MAQBLN1K', 288, 'F'),
('Hugo', 'García', 'Rodríguez', '7984 Calle de la Paz', 'Condesa', 'CO-DC', 'HUHE831201Z0R', 'HUGI900115HCHBRJ20', 160, 'M'),
('Ana', 'Hernández', 'Martínez', '5817 Calle Este', 'Polanco', 'UY-MO', 'AMDI820712EAD', 'AHNM971122MNTQPR6Q', 204, 'F'),
('Alejandro', 'López', 'Gómez', '2531 Calle Norte', 'Narvarte', 'PE-LIM', 'GUGA980315Z9V', 'ALJG950310HZSWS0L4', 194, 'M'),
('Valeria', 'Ruiz', 'Alonso', '9502 Bulevar de la Paz', 'Campestre', 'IT-62', 'AERU881026MNQ', 'VARL930928MCDBNM8Q', 213, 'F'),
('Raúl', 'Díaz', 'Moreno', '360 Bulevar Sur', 'Lomas', 'FR-75', 'APMA850210U09', 'RUDM900418HTLSHK3E', 188, 'M'),
('Gabriela', 'Torres', 'Navarro', '7456 Paseo Central', 'Reforma', 'NZ-WGN', 'HUHE831201Z0R', 'GATN960705MAQPMX9R', 211, 'F'),
('Eduardo', 'Álvarez', 'Sánchez', '9335 Paseo Central', 'Juárez', 'MX-JAL', 'GUGA980315Z9V', 'EUAS910512HDFCKJ49', 283, 'M'),
('Isabel', 'Gutiérrez', 'Torres', '8195 Calle Sur', 'Roma', 'US-FL', 'RAGU920919K3N', 'IGT940228MNTECN4B', 221, 'F'),
('Miguel', 'López', 'Rodríguez', '5126 Calzada de la Paz', 'Condesa', 'PT-13', 'ANVA940822K7T', 'MOLR921101HJCQPS7C', 119, 'M'),
('Mónica', 'Pérez', 'Hernández', '6048 Avenida Este', 'Polanco', 'IT-62', 'AMDI820712EAD', 'MOPH980719MBSLKN3A', 268, 'F'),
('Fernando', 'Martínez', 'Sánchez', '356 Avenida Central', 'Jardines', 'FR-75', 'GUGA980315Z9V', 'FEMS940307HDFPLQ2E', 104, 'M'),
('Laura', 'Gómez', 'Fernández', '1668 Calzada Central', 'Juárez', 'DE-BE', 'AERU881026MNQ', 'LAGF930522MNTWSP1R', 236, 'F'),
('Nicolás', 'Ruiz', 'Díaz', '2531 Calle Norte', 'Obrera', 'GB-LND', 'APMA850210U09', 'NRD900829HCOSQR7W', 148, 'M'),
('Sofía', 'Hernández', 'Moreno', '360 Bulevar Sur', 'Campestre', 'CA-ON', 'HUHE831201Z0R', 'SHM960105MCDKLS6R', 162, 'F'),
('Tomás', 'Álvarez', 'Romero', '9335 Paseo Central', 'Reforma', 'AU-VIC', 'AMDI820712EAD', 'TARO910717HDFRSP9E', 280, 'M'),
('Valeria', 'Jiménez', 'Navarro', '7456 Paseo Central', 'Roma', 'NZ-WGN', 'GUGA980315Z9V', 'VAGN951203MNTWST8Q', 164, 'F'),
('Carlos', 'López', 'Torres', '8195 Calle Sur', 'Condesa', 'MX-JAL', 'RAGU920919K3N', 'CLTO970614HBSCRJ5W', 127, 'M'),
('Patricia', 'Sánchez', 'Díaz', '5126 Calzada de la Paz', 'Polanco', 'US-FL', 'ANVA940822K7T', 'PSDI941026MCDMNR6D', 245, 'F'),
('Hugo', 'Gutiérrez', 'Martínez', '6048 Avenida Este', 'Jardines', 'PT-13', 'HUHE831201Z0R', 'HUJM900908HDFBLR2B', 108, 'M'),
('Ana', 'Pérez', 'Rodríguez', '356 Avenida Central', 'Juárez', 'IT-62', 'GUGA980315Z9V', 'APAR960211MNTJSQ7E', 127, 'F'),
('Alejandro', 'Martín', 'Hernández', '1668 Calzada Central', 'Obrera', 'FR-75', 'AERU881026MNQ', 'ALMH930419HCOSPL4P', 245, 'M'),
('Valeria', 'Romero', 'López', '2531 Calle Norte', 'Campestre', 'DE-BE', 'APMA850210U09', 'VARL980806MBSLRQ3G', 164, 'F'),
('Raúl', 'Álvarez', 'Sánchez', '360 Bulevar Sur', 'Lomas', 'GB-LND', 'RAGU920919K3N', 'RAAS910325HDFDSD9S', 270, 'M'),
('Gabriela', 'Jiménez', 'Torres', '9335 Paseo Central', 'Reforma', 'CA-ON', 'ANVA940822K7T', 'GAJT970902MCDKMR8P', 229, 'F'),
('Eduardo', 'López', 'Moreno', '7456 Paseo Central', 'Roma', 'AU-VIC', 'HUHE831201Z0R', 'ELMO921216HBSLRS6L', 142, 'M'),
('Isabel', 'Sánchez', 'Fernández', '8195 Calle Sur', 'Condesa', 'NZ-WGN', 'AMDI820712EAD', 'ISF940121MNTWSP1R', 280, 'F'),
('Miguel', 'Gutiérrez', 'Martínez', '5126 Calzada de la Paz', 'Polanco', 'MX-JAL', 'GUGA980315Z9V', 'MIGM901103HDFPJS8B', 164, 'M'),
('Mónica', 'Pérez', 'Rodríguez', '6048 Avenida Este', 'Jardines', 'US-FL', 'RAGU920919K3N', 'MOPR980515MBSQRR7A', 229, 'F'),
('Fernando', 'Martín', 'Díaz', '356 Avenida Central', 'Juárez', 'PT-13', 'HUHE831201Z0R', 'FEMD940620HTLPLS5C', 142, 'M'),
('Laura', 'Romero', 'Hernández', '1668 Calzada Central', 'Obrera', 'IT-62', 'AMDI820712EAD', 'LARH931109MCDKLP4B', 280, 'F'),
('Nicolás', 'Díaz', 'Moreno', '2531 Calle Norte', 'Campestre', 'FR-75', 'GUGA980315Z9V', 'NDM900201HCOSQR7W', 164, 'M'),
('Sofía', 'Álvarez', 'Sánchez', '360 Bulevar Sur', 'Lomas', 'DE-BE', 'AERU881026MNQ', 'SASS960810MBSHRL9E', 245, 'F'),
('Tomás', 'Jiménez', 'Torres', '9335 Paseo Central', 'Reforma', 'GB-LND', 'APMA850210U09', 'TJIT910903HTLSLK3A', 270, 'M'),
('Valeria', 'López', 'Navarro', '7456 Paseo Central', 'Roma', 'CA-ON', 'RAGU920919K3N', 'VLNA951112MNTQPS2E', 127, 'F'),
('Carlos', 'Sánchez', 'Díaz', '8195 Calle Sur', 'Condesa', 'AU-VIC', 'ANVA940822K7T', 'CSDI970725HDFMNR6D', 245, 'M'),
('Patricia', 'Gutiérrez', 'Martínez', '5126 Calzada de la Paz', 'Polanco', 'NZ-WGN', 'HUHE831201Z0R', 'PGJM941201MBSLRS6L', 164, 'F'),
('Hugo', 'Pérez', 'Rodríguez', '6048 Avenida Este', 'Jardines', 'MX-JAL', 'AMDI820712EAD', 'HUPR900310HCOSPL4P', 270, 'M'),
('Ana', 'Martín', 'Díaz', '356 Avenida Central', 'Juárez', 'US-FL', 'GUGA980315Z9V', 'AMD960928MNTJSQ7E', 229, 'F'),
('Alejandro', 'Romero', 'Hernández', '1668 Calzada Central', 'Obrera', 'PT-13', 'RAGU920919K3N', 'AROH931015HDFDSD9S', 142, 'M'),
('Valeria', 'Álvarez', 'Sánchez', '2531 Calle Norte', 'Campestre', 'IT-62', 'ANVA940822K7T', 'VASS980706MCDKLP4B', 280, 'F'),
('Raúl', 'Jiménez', 'Torres', '360 Bulevar Sur', 'Lomas', 'FR-75', 'HUHE831201Z0R', 'RJIT910103HTLSLK3A', 164, 'M'),
('Gabriela', 'López', 'Navarro', '9335 Paseo Central', 'Reforma', 'DE-BE', 'AMDI820712EAD', 'GLNA970802MBSHRL9E', 245, 'F'),
('Eduardo', 'Sánchez', 'Díaz', '7456 Paseo Central', 'Roma', 'GB-LND', 'GUGA980315Z9V', 'ESDI920512HDFMNR6D', 270, 'M'),
('Isabel', 'Gutiérrez', 'Martínez', '8195 Calle Sur', 'Condesa', 'CA-ON', 'RAGU920919K3N', 'IGM940321MNTWST8Q', 229, 'F'),
('Miguel', 'Pérez', 'Rodríguez', '5126 Calzada de la Paz', 'Polanco', 'AU-VIC', 'ANVA940822K7T', 'MIPR980404HCOSPL4P', 142, 'M'),
('Mónica', 'Martín', 'Díaz', '6048 Avenida Este', 'Jardines', 'NZ-WGN', 'HUHE831201Z0R', 'MOMD961128MCDKMR8P', 280, 'F'),
('Fernando', 'Romero', 'Hernández', '356 Avenida Central', 'Juárez', 'MX-JAL', 'AMDI820712EAD', 'FRHH940707HTLPLS5C', 164, 'M'),
('Laura', 'Álvarez', 'Sánchez', '1668 Calzada Central', 'Obrera', 'US-FL', 'GUGA980315Z9V', 'LASS930809MBSLKN3A', 245, 'F'),
('Nicolás', 'Jiménez', 'Torres', '2531 Calle Norte', 'Campestre', 'PT-13', 'RAGU920919K3N', 'NJIT900603HDFDSD9S', 270, 'M'),
('Sofía', 'López', 'Navarro', '360 Bulevar Sur', 'Lomas', 'IT-62', 'ANVA940822K7T', 'SLNA951012MCDKLP4B', 229, 'F'),
('Tomás', 'Sánchez', 'Díaz', '9335 Paseo Central', 'Reforma', 'FR-75', 'HUHE831201Z0R', 'TSDI910817HTLSLK3A', 142, 'M'),
('Valeria', 'Gutiérrez', 'Martínez', '7456 Paseo Central', 'Roma', 'DE-BE', 'AMDI820712EAD', 'VIGM940121MBSHRL9E', 280, 'F'),
('Carlos', 'Pérez', 'Rodríguez', '8195 Calle Sur', 'Condesa', 'GB-LND', 'GUGA980315Z9V', 'CPPR970505HDFMNR6D', 164, 'M'),
('Patricia', 'Martín', 'Díaz', '5126 Calzada de la Paz', 'Polanco', 'CA-ON', 'RAGU920919K3N', 'PMD940401MNTWST8Q', 245, 'F'),
('Hugo', 'Romero', 'Hernández', '6048 Avenida Este', 'Jardines', 'AU-VIC', 'ANVA940822K7T', 'HRH900710HCOSPL4P', 270, 'M'),
('Ana', 'Álvarez', 'Sánchez', '356 Avenida Central', 'Juárez', 'NZ-WGN', 'HUHE831201Z0R', 'AAS961228MCDKMR8P', 229, 'F'),
('Alejandro', 'Jiménez', 'Torres', '1668 Calzada Central', 'Obrera', 'MX-JAL', 'AMDI820712EAD', 'AJIT930215HTLPLS5C', 142, 'M'),
('Valeria', 'López', 'Navarro', '2531 Calle Norte', 'Campestre', 'US-FL', 'GUGA980315Z9V', 'VLNA980906MBSLKN3A', 280, 'F'),
('Raúl', 'Sánchez', 'Díaz', '360 Bulevar Sur', 'Lomas', 'PT-13', 'RAGU920919K3N', 'RSD910703HDFDSD9S', 164, 'M'),
('Gabriela', 'Gutiérrez', 'Martínez', '9335 Paseo Central', 'Reforma', 'IT-62', 'ANVA940822K7T', 'GIGM970322MCDKLP4B', 245, 'F'),
('Eduardo', 'Pérez', 'Rodríguez', '7456 Paseo Central', 'Roma', 'FR-75', 'HUHE831201Z0R', 'EUPR920412HTLSLK3A', 270, 'M'),
('Isabel', 'Martín', 'Díaz', '8195 Calle Sur', 'Condesa', 'DE-BE', 'AMDI820712EAD', 'IMD940621MBSHRL9E', 229, 'F'),
('Miguel', 'Romero', 'Hernández', '5126 Calzada de la Paz', 'Polanco', 'GB-LND', 'GUGA980315Z9V', 'MIRH980104HDFMNR6D', 142, 'M'),
('Mónica', 'Álvarez', 'Sánchez', '6048 Avenida Este', 'Jardines', 'CA-ON', 'RAGU920919K3N', 'MAS961028MNTWST8Q', 280, 'F'),
('Fernando', 'Jiménez', 'Torres', '356 Avenida Central', 'Juárez', 'AU-VIC', 'ANVA940822K7T', 'FJT940520HCOSPL4P', 164, 'M'),
('Laura', 'López', 'Navarro', '1668 Calzada Central', 'Obrera', 'NZ-WGN', 'HUHE831201Z0R', 'LLNA930709MCDKMR8P', 245, 'F'),
('Nicolás', 'Sánchez', 'Díaz', '2531 Calle Norte', 'Campestre', 'MX-JAL', 'AMDI820712EAD', 'NSD900503HTLPLS5C', 270, 'M'),
('Sofía', 'Gutiérrez', 'Martínez', '360 Bulevar Sur', 'Lomas', 'US-FL', 'GUGA980315Z9V', 'SIGM950912MBSLKN3A', 229, 'F'),
('Tomás', 'Pérez', 'Rodríguez', '9335 Paseo Central', 'Reforma', 'PT-13', 'RAGU920919K3N', 'TPPR910617HDFDSD9S', 142, 'M'),
('Valeria', 'Romero', 'Hernández', '7456 Paseo Central', 'Roma', 'IT-62', 'ANVA940822K7T', 'VRH980306MCDKLP4B', 280, 'F'),
('Carlos', 'Álvarez', 'Sánchez', '8195 Calle Sur', 'Condesa', 'FR-75', 'HUHE831201Z0R', 'CAS970825HTLSLK3A', 164, 'M'),
('Patricia', 'Jiménez', 'Torres', '5126 Calzada de la Paz', 'Polanco', 'DE-BE', 'AMDI820712EAD', 'PJIT940201MBSHRL9E', 245, 'F'),
('Hugo', 'López', 'Navarro', '6048 Avenida Este', 'Jardines', 'GB-LND', 'GUGA980315Z9V', 'HULN900810HDFMNR6D', 270, 'M'),
('Ana', 'Sánchez', 'Díaz', '356 Avenida Central', 'Juárez', 'CA-ON', 'RAGU920919K3N', 'ASD960728MNTWST8Q', 229, 'F'),
('Alejandro', 'Gutiérrez', 'Martínez', '1668 Calzada Central', 'Obrera', 'AU-VIC', 'ANVA940822K7T', 'AGM930115HCOSPL4P', 142, 'M'),
('Valeria', 'Pérez', 'Rodríguez', '2531 Calle Norte', 'Campestre', 'NZ-WGN', 'HUHE831201Z0R', 'VAPR980206MCDKMR8P', 280, 'F'),
('Raúl', 'Romero', 'Hernández', '360 Bulevar Sur', 'Lomas', 'MX-JAL', 'AMDI820712EAD', 'RRH910503HTLPLS5C', 164, 'M'),
('Gabriela', 'Álvarez', 'Sánchez', '9335 Paseo Central', 'Reforma', 'US-FL', 'GUGA980315Z9V', 'GASS970422MBSLKN3A', 245, 'F'),
('Eduardo', 'Jiménez', 'Torres', '7456 Paseo Central', 'Roma', 'PT-13', 'RAGU920919K3N', 'EJI920312HDFDSD9S', 270, 'M'),
('Isabel', 'López', 'Navarro', '8195 Calle Sur', 'Condesa', 'IT-62', 'ANVA940822K7T', 'ILN940521MCDKLP4B', 229, 'F'),
('Miguel', 'Sánchez', 'Díaz', '5126 Calzada de la Paz', 'Polanco', 'FR-75', 'HUHE831201Z0R', 'MSD980704HTLSLK3A', 142, 'M'),
('Mónica', 'Gutiérrez', 'Martínez', '6048 Avenida Este', 'Jardines', 'DE-BE', 'AMDI820712EAD', 'MIGM960928MBSHRL9E', 280, 'F'),
('Fernando', 'Pérez', 'Rodríguez', '356 Avenida Central', 'Juárez', 'GB-LND', 'GUGA980315Z9V', 'FPPR940420HDFMNR6D', 164, 'M'),
('Laura', 'Romero', 'Hernández', '1668 Calzada Central', 'Obrera', 'CA-ON', 'RAGU920919K3N', 'LARH930909MNTWST8Q', 245, 'F'),
('Nicolás', 'Álvarez', 'Sánchez', '2531 Calle Norte', 'Campestre', 'AU-VIC', 'ANVA940822K7T', 'NAS900703HCOSPL4P', 270, 'M'),
('Sofía', 'Jiménez', 'Torres', '360 Bulevar Sur', 'Lomas', 'NZ-WGN', 'HUHE831201Z0R', 'SJIT950812MCDKMR8P', 229, 'F'),
('Tomás', 'López', 'Navarro', '9335 Paseo Central', 'Reforma', 'MX-JAL', 'AMDI820712EAD', 'TLN910717HTLPLS5C', 142, 'M'),
('Valeria', 'Sánchez', 'Díaz', '7456 Paseo Central', 'Roma', 'US-FL', 'GUGA980315Z9V', 'VSD940221MBSLKN3A', 280, 'F'),
('Carlos', 'Gutiérrez', 'Martínez', '8195 Calle Sur', 'Condesa', 'PT-13', 'RAGU920919K3N', 'CGM970625HDFDSD9S', 164, 'M'),
('Patricia', 'Pérez', 'Rodríguez', '5126 Calzada de la Paz', 'Polanco', 'IT-62', 'ANVA940822K7T', 'PPR940501MCDKLP4B', 245, 'F'),
('Hugo', 'Álvarez', 'Sánchez', '6048 Avenida Este', 'Jardines', 'FR-75', 'HUHE831201Z0R', 'HAS901010HTLSLK3A', 270, 'M'),
('Ana', 'Jiménez', 'Torres', '356 Avenida Central', 'Juárez', 'DE-BE', 'AMDI820712EAD', 'AJIT960828MBSHRL9E', 229, 'F'),
('Alejandro', 'López', 'Navarro', '1668 Calzada Central', 'Obrera', 'GB-LND', 'GUGA980315Z9V', 'ALN930415HDFMNR6D', 142, 'M'),
('Valeria', 'Sánchez', 'Díaz', '2531 Calle Norte', 'Campestre', 'CA-ON', 'RAGU920919K3N', 'VSD980806MNTWST8Q', 280, 'F'),
('Raúl', 'Gutiérrez', 'Martínez', '360 Bulevar Sur', 'Lomas', 'AU-VIC', 'ANVA940822K7T', 'RGM910303HCOSPL4P', 164, 'M'),
('Gabriela', 'Pérez', 'Rodríguez', '9335 Paseo Central', 'Reforma', 'NZ-WGN', 'HUHE831201Z0R', 'GPPR970522MCDKMR8P', 245, 'F'),
('Eduardo', 'Álvarez', 'Sánchez', '7456 Paseo Central', 'Roma', 'MX-JAL', 'AMDI820712EAD', 'EAS920612HTLPLS5C', 270, 'M'),
('Isabel', 'Jiménez', 'Torres', '8195 Calle Sur', 'Condesa', 'US-FL', 'GUGA980315Z9V', 'IJIT940721MBSLKN3A', 229, 'F'),
('Miguel', 'López', 'Navarro', '5126 Calzada de la Paz', 'Polanco', 'PT-13', 'RAGU920919K3N', 'MLN980504HDFDSD9S', 142, 'M'),
('Mónica', 'Sánchez', 'Díaz', '6048 Avenida Este', 'Jardines', 'IT-62', 'ANVA940822K7T', 'MSD961128MCDKLP4B', 280, 'F'),
('Fernando', 'Gutiérrez', 'Martínez', '356 Avenida Central', 'Juárez', 'FR-75', 'HUHE831201Z0R', 'FGM940420HTLSLK3A', 164, 'M'),
('Laura', 'Pérez', 'Rodríguez', '1668 Calzada Central', 'Obrera', 'DE-BE', 'AMDI820712EAD', 'LAPR930609MBSHRL9E', 245, 'F'),
('Nicolás', 'Álvarez', 'Sánchez', '2531 Calle Norte', 'Campestre', 'GB-LND', 'GUGA980315Z9V', 'NAS900703HDFMNR6D', 270, 'M'),
('Sofía', 'Jiménez', 'Torres', '360 Bulevar Sur', 'Lomas', 'CA-ON', 'RAGU920919K3N', 'SJIT950812MNTWST8Q', 229, 'F'),
('Tomás', 'López', 'Navarro', '9335 Paseo Central', 'Reforma', 'AU-VIC', 'ANVA940822K7T', 'TLN910717HCOSPL4P', 142, 'M'),
('Valeria', 'Sánchez', 'Díaz', '7456 Paseo Central', 'Roma', 'NZ-WGN', 'HUHE831201Z0R', 'VSD940221MCDKMR8P', 280, 'F'),
('Carlos', 'Gutiérrez', 'Martínez', '8195 Calle Sur', 'Condesa', 'MX-JAL', 'AMDI820712EAD', 'CGM970625HTLPLS5C', 164, 'M'),
('Patricia', 'Pérez', 'Rodríguez', '5126 Calzada de la Paz', 'Polanco', 'US-FL', 'GUGA980315Z9V', 'PPR940501MBSLKN3A', 245, 'F'),
('Hugo', 'Álvarez', 'Sánchez', '6048 Avenida Este', 'Jardines', 'PT-13', 'RAGU920919K3N', 'HAS901010HDFDSD9S', 270, 'M'),
('Ana', 'Jiménez', 'Torres', '356 Avenida Central', 'Juárez', 'IT-62', 'ANVA940822K7T', 'AJIT960828MCDKLP4B', 229, 'F'),
('Alejandro', 'López', 'Navarro', '1668 Calzada Central', 'Obrera', 'FR-75', 'HUHE831201Z0R', 'ALN930415HTLSLK3A', 142, 'M'),
('Valeria', 'Sánchez', 'Díaz', '2531 Calle Norte', 'Campestre', 'DE-BE', 'AMDI820712EAD', 'VSD980806MBSHRL9E', 280, 'F'),
('Raúl', 'Gutiérrez', 'Martínez', '360 Bulevar Sur', 'Lomas', 'GB-LND', 'GUGA980315Z9V', 'RGM910303HDFMNR6D', 164, 'M'),
('Gabriela', 'Pérez', 'Rodríguez', '9335 Paseo Central', 'Reforma', 'CA-ON', 'RAGU920919K3N', 'GPPR970522MNTWST8Q', 245, 'F'),
('Eduardo', 'Álvarez', 'Sánchez', '7456 Paseo Central', 'Roma', 'AU-VIC', 'ANVA940822K7T', 'EAS920612HCOSPL4P', 270, 'M'),
('Isabel', 'Jiménez', 'Torres', '8195 Calle Sur', 'Condesa', 'NZ-WGN', 'HUHE831201Z0R', 'IJIT940721MCDKMR8P', 229, 'F'),
('Miguel', 'López', 'Navarro', '5126 Calzada de la Paz', 'Polanco', 'MX-JAL', 'AMDI820712EAD', 'MLN980504HTLPLS5C', 142, 'M'),
('Mónica', 'Sánchez', 'Díaz', '6048 Avenida Este', 'Jardines', 'US-FL', 'GUGA980315Z9V', 'MSD961128MBSLKN3A', 280, 'F'),
('Fernando', 'Gutiérrez', 'Martínez', '356 Avenida Central', 'Juárez', 'PT-13', 'RAGU920919K3N', 'FGM940420HDFDSD9S', 164, 'M'),
('Laura', 'Pérez', 'Rodríguez', '1668 Calzada Central', 'Obrera', 'IT-62', 'ANVA940822K7T', 'LAPR930609MCDKLP4B', 245, 'F'),
('Nicolás', 'Álvarez', 'Sánchez', '2531 Calle Norte', 'Campestre', 'FR-75', 'HUHE831201Z0R', 'NAS900703HTLSLK3A', 270, 'M'),
('Sofía', 'Jiménez', 'Torres', '360 Bulevar Sur', 'Lomas', 'DE-BE', 'AMDI820712EAD', 'SJIT950812MBSHRL9E', 229, 'F'),
('Tomás', 'López', 'Navarro', '9335 Paseo Central', 'Reforma', 'GB-LND', 'GUGA980315Z9V', 'TLN910717HDFMNR6D', 142, 'M'),
('Valeria', 'Sánchez', 'Díaz', '7456 Paseo Central', 'Roma', 'CA-ON', 'RAGU920919K3N', 'VSD940221MNTWST8Q', 280, 'F'),
('Carlos', 'Gutiérrez', 'Martínez', '8195 Calle Sur', 'Condesa', 'AU-VIC', 'ANVA940822K7T', 'CGM970625HCOSPL4P', 164, 'M'),
('Patricia', 'Pérez', 'Rodríguez', '5126 Calzada de la Paz', 'Polanco', 'NZ-WGN', 'HUHE831201Z0R', 'PPR940501MCDKMR8P', 245, 'F'),
('Hugo', 'Álvarez', 'Sánchez', '6048 Avenida Este', 'Jardines', 'MX-JAL', 'AMDI820712EAD', 'HAS901010HTLPLS5C', 270, 'M'),
('Ana', 'Jiménez', 'Torres', '356 Avenida Central', 'Juárez', 'US-FL', 'GUGA980315Z9V', 'AJIT960828MBSLKN3A', 229, 'F'),
('Alejandro', 'López', 'Navarro', '1668 Calzada Central', 'Obrera', 'PT-13', 'RAGU920919K3N', 'ALN930415HDFDSD9S', 142, 'M'),
('Valeria', 'Sánchez', 'Díaz', '2531 Calle Norte', 'Campestre', 'IT-62', 'ANVA940822K7T', 'VSD980806MCDKLP4B', 280, 'F'),
('Raúl', 'Gutiérrez', 'Martínez', '360 Bulevar Sur', 'Lomas', 'FR-75', 'HUHE831201Z0R', 'RGM910303HTLSLK3A', 164, 'M'),
('Gabriela', 'Pérez', 'Rodríguez', '9335 Paseo Central', 'Reforma', 'DE-BE', 'AMDI820712EAD', 'GPPR970522MBSHRL9E', 245, 'F'),
('Eduardo', 'Álvarez', 'Sánchez', '7456 Paseo Central', 'Roma', 'GB-LND', 'GUGA980315Z9V', 'EAS920612HDFMNR6D', 270, 'M'),
('Isabel', 'Jiménez', 'Torres', '8195 Calle Sur', 'Condesa', 'CA-ON', 'RAGU920919K3N', 'IJIT940721MNTWST8Q', 229, 'F'),
('Miguel', 'López', 'Navarro', '5126 Calzada de la Paz', 'Polanco', 'AU-VIC', 'ANVA940822K7T', 'MLN980504HCOSPL4P', 142, 'M'),
('Mónica', 'Sánchez', 'Díaz', '6048 Avenida Este', 'Jardines', 'NZ-WGN', 'HUHE831201Z0R', 'MSD961128MCDKMR8P', 280, 'F'),
('Fernando', 'Gutiérrez', 'Martínez', '356 Avenida Central', 'Juárez', 'MX-JAL', 'AMDI820712EAD', 'FGM940420HTLPLS5C', 164, 'M'),
('Laura', 'Pérez', 'Rodríguez', '1668 Calzada Central', 'Obrera', 'US-FL', 'GUGA980315Z9V', 'LAPR930609MBSLKN3A', 245, 'F'),
('Nicolás', 'Álvarez', 'Sánchez', '2531 Calle Norte', 'Campestre', 'PT-13', 'RAGU920919K3N', 'NAS900703HDFDSD9S', 270, 'M'),
('Sofía', 'Jiménez', 'Torres', '360 Bulevar Sur', 'Lomas', 'IT-62', 'ANVA940822K7T', 'SJIT950812MCDKLP4B', 229, 'F'),
('Tomás', 'López', 'Navarro', '9335 Paseo Central', 'Reforma', 'FR-75', 'HUHE831201Z0R', 'TLN910717HTLSLK3A', 142, 'M'),
('Valeria', 'Sánchez', 'Díaz', '7456 Paseo Central', 'Roma', 'DE-BE', 'AMDI820712EAD', 'VSD940221MBSHRL9E', 280, 'F'),
('Carlos', 'Gutiérrez', 'Martínez', '8195 Calle Sur', 'Condesa', 'GB-LND', 'GUGA980315Z9V', 'CGM970625HDFMNR6D', 164, 'M'),
('Patricia', 'Pérez', 'Rodríguez', '5126 Calzada de la Paz', 'Polanco', 'CA-ON', 'RAGU920919K3N', 'PPR940501MNTWST8Q', 245, 'F'),
('Hugo', 'Álvarez', 'Sánchez', '6048 Avenida Este', 'Jardines', 'AU-VIC', 'ANVA940822K7T', 'HAS901010HCOSPL4P', 270, 'M'),
('Ana', 'Jiménez', 'Torres', '356 Avenida Central', 'Juárez', 'NZ-WGN', 'HUHE831201Z0R', 'AJIT960828MCDKMR8P', 229, 'F'),
('Alejandro', 'López', 'Navarro', '1668 Calzada Central', 'Obrera', 'MX-JAL', 'AMDI820712EAD', 'ALN930415HTLPLS5C', 142, 'M'),
('Valeria', 'Sánchez', 'Díaz', '2531 Calle Norte', 'Campestre', 'US-FL', 'GUGA980315Z9V', 'VSD980806MBSLKN3A', 280, 'F'),
('Raúl', 'Gutiérrez', 'Martínez', '360 Bulevar Sur', 'Lomas', 'PT-13', 'RAGU920919K3N', 'RGM910303HDFDSD9S', 164, 'M'),
('Gabriela', 'Pérez', 'Rodríguez', '9335 Paseo Central', 'Reforma', 'IT-62', 'ANVA940822K7T', 'GPPR970522MCDKLP4B', 245, 'F'),
('Eduardo', 'Álvarez', 'Sánchez', '7456 Paseo Central', 'Roma', 'FR-75', 'HUHE831201Z0R', 'EAS920612HTLSLK3A', 270, 'M'),
('Isabel', 'Jiménez', 'Torres', '8195 Calle Sur', 'Condesa', 'DE-BE', 'AMDI820712EAD', 'IJIT940721MBSHRL9E', 229, 'F'),
('Miguel', 'López', 'Navarro', '5126 Calzada de la Paz', 'Polanco', 'GB-LND', 'GUGA980315Z9V', 'MLN980504HDFMNR6D', 142, 'M'),
('Mónica', 'Sánchez', 'Díaz', '6048 Avenida Este', 'Jardines', 'CA-ON', 'RAGU920919K3N', 'MSD961128MNTWST8Q', 280, 'F'),
('Fernando', 'Gutiérrez', 'Martínez', '356 Avenida Central', 'Juárez', 'AU-VIC', 'ANVA940822K7T', 'FGM940420HCOSPL4P', 164, 'M'),
('Laura', 'Pérez', 'Rodríguez', '1668 Calzada Central', 'Obrera', 'NZ-WGN', 'HUHE831201Z0R', 'LAPR930609MCDKMR8P', 245, 'F'),
('Nicolás', 'Álvarez', 'Sánchez', '2531 Calle Norte', 'Campestre', 'MX-JAL', 'AMDI820712EAD', 'NAS900703HTLPLS5C', 270, 'M'),
('Sofía', 'Jiménez', 'Torres', '360 Bulevar Sur', 'Lomas', 'US-FL', 'GUGA980315Z9V', 'SJIT950812MBSLKN3A', 229, 'F'),
('Tomás', 'López', 'Navarro', '9335 Paseo Central', 'Reforma', 'PT-13', 'RAGU920919K3N', 'TLN910717HDFDSD9S', 142, 'M'),
('Valeria', 'Sánchez', 'Díaz', '7456 Paseo Central', 'Roma', 'IT-62', 'ANVA940822K7T', 'VSD940221MCDKLP4B', 280, 'F'),
('Carlos', 'Gutiérrez', 'Martínez', '8195 Calle Sur', 'Condesa', 'FR-75', 'HUHE831201Z0R', 'CGM970625HTLSLK3A', 164, 'M'),
('Patricia', 'Pérez', 'Rodríguez', '5126 Calzada de la Paz', 'Polanco', 'DE-BE', 'AMDI820712EAD', 'PPR940501MBSHRL9E', 245, 'F'),
('Hugo', 'Álvarez', 'Sánchez', '6048 Avenida Este', 'Jardines', 'GB-LND', 'GUGA980315Z9V', 'HAS901010HDFMNR6D', 270, 'M'),
('Ana', 'Jiménez', 'Torres', '356 Avenida Central', 'Juárez', 'CA-ON', 'RAGU920919K3N', 'AJIT960828MNTWST8Q', 229, 'F'),
('Alejandro', 'López', 'Navarro', '1668 Calzada Central', 'Obrera', 'AU-VIC', 'ANVA940822K7T', 'ALN930415HCOSPL4P', 142, 'M'),
('Valeria', 'Sánchez', 'Díaz', '2531 Calle Norte', 'Campestre', 'NZ-WGN', 'HUHE831201Z0R', 'VSD980806MCDKMR8P', 280, 'F'),
('Raúl', 'Gutiérrez', 'Martínez', '360 Bulevar Sur', 'Lomas', 'MX-JAL', 'AMDI820712EAD', 'RGM910303HTLPLS5C', 164, 'M'),
('Gabriela', 'Pérez', 'Rodríguez', '9335 Paseo Central', 'Reforma', 'US-FL', 'GUGA980315Z9V', 'GPPR970522MBSLKN3A', 245, 'F'),
('Eduardo', 'Álvarez', 'Sánchez', '7456 Paseo Central', 'Roma', 'PT-13', 'RAGU920919K3N', 'EAS920612HDFDSD9S', 270, 'M'),
('Isabel', 'Jiménez', 'Torres', '8195 Calle Sur', 'Condesa', 'IT-62', 'ANVA940822K7T', 'IJIT940721MCDKLP4B', 229, 'F'),
('Miguel', 'López', 'Navarro', '5126 Calzada de la Paz', 'Polanco', 'FR-75', 'HUHE831201Z0R', 'MLN980504HTLSLK3A', 142, 'M'),
('Mónica', 'Sánchez', 'Díaz', '6048 Avenida Este', 'Jardines', 'DE-BE', 'AMDI820712EAD', 'MSD961128MBSHRL9E', 280, 'F'),
('Fernando', 'Gutiérrez', 'Martínez', '356 Avenida Central', 'Juárez', 'GB-LND', 'GUGA980315Z9V', 'FGM940420HDFMNR6D', 164, 'M'),
('Laura', 'Pérez', 'Rodríguez', '1668 Calzada Central', 'Obrera', 'CA-ON', 'RAGU920919K3N', 'LAPR930609MNTWST8Q', 245, 'F'),
('Nicolás', 'Álvarez', 'Sánchez', '2531 Calle Norte', 'Campestre', 'AU-VIC', 'ANVA940822K7T', 'NAS900703HCOSPL4P', 270, 'M'),
('Sofía', 'Jiménez', 'Torres', '360 Bulevar Sur', 'Lomas', 'NZ-WGN', 'HUHE831201Z0R', 'SJIT950812MCDKMR8P', 229, 'F'),
('Tomás', 'López', 'Navarro', '9335 Paseo Central', 'Reforma', 'MX-JAL', 'AMDI820712EAD', 'TLN910717HTLPLS5C', 142, 'M'),
('Valeria', 'Sánchez', 'Díaz', '7456 Paseo Central', 'Roma', 'US-FL', 'GUGA980315Z9V', 'VSD940221MBSLKN3A', 280, 'F'),
('Carlos', 'Gutiérrez', 'Martínez', '8195 Calle Sur', 'Condesa', 'PT-13', 'RAGU920919K3N', 'CGM970625HDFDSD9S', 164, 'M'),
('Patricia', 'Pérez', 'Rodríguez', '5126 Calzada de la Paz', 'Polanco', 'IT-62', 'ANVA940822K7T', 'PPR940501MCDKLP4B', 245, 'F'),
('Hugo', 'Álvarez', 'Sánchez', '6048 Avenida Este', 'Jardines', 'FR-75', 'HUHE831201Z0R', 'HAS901010HTLSLK3A', 270, 'M'),
('Ana', 'Jiménez', 'Torres', '356 Avenida Central', 'Juárez', 'DE-BE', 'AMDI820712EAD', 'AJIT960828MBSHRL9E', 229, 'F'),
('Alejandro', 'López', 'Navarro', '1668 Calzada Central', 'Obrera', 'GB-LND', 'GUGA980315Z9V', 'ALN930415HDFMNR6D', 142, 'M'),
('Valeria', 'Sánchez', 'Díaz', '2531 Calle Norte', 'Campestre', 'CA-ON', 'RAGU920919K3N', 'VSD980806MNTWST8Q', 280, 'F'),
('Raúl', 'Gutiérrez', 'Martínez', '360 Bulevar Sur', 'Lomas', 'AU-VIC', 'ANVA940822K7T', 'RGM910303HCOSPL4P', 164, 'M'),
('Gabriela', 'Pérez', 'Rodríguez', '9335 Paseo Central', 'Reforma', 'NZ-WGN', 'HUHE831201Z0R', 'GPPR970522MCDKMR8P', 245, 'F'),
('Eduardo', 'Álvarez', 'Sánchez', '7456 Paseo Central', 'Roma', 'MX-JAL', 'AMDI820712EAD', 'EAS920612HTLPLS5C', 270, 'M'),
('Isabel', 'Jiménez', 'Torres', '8195 Calle Sur', 'Condesa', 'US-FL', 'GUGA980315Z9V', 'IJIT940721MBSLKN3A', 229, 'F'),
('Miguel', 'López', 'Navarro', '5126 Calzada de la Paz', 'Polanco', 'PT-13', 'RAGU920919K3N', 'MLN980504HDFDSD9S', 142, 'M'),
('Mónica', 'Sánchez', 'Díaz', '6048 Avenida Este', 'Jardines', 'IT-62', 'ANVA940822K7T', 'MSD961128MCDKLP4B', 280, 'F'),
('Fernando', 'Gutiérrez', 'Martínez', '356 Avenida Central', 'Juárez', 'FR-75', 'HUHE831201Z0R', 'FGM940420HTLSLK3A', 164, 'M'),
('Laura', 'Pérez', 'Rodríguez', '1668 Calzada Central', 'Obrera', 'DE-BE', 'AMDI820712EAD', 'LAPR930609MBSHRL9E', 245, 'F'),
('Nicolás', 'Álvarez', 'Sánchez', '2531 Calle Norte', 'Campestre', 'GB-LND', 'GUGA980315Z9V', 'NAS900703HDFMNR6D', 270, 'M'),
('Sofía', 'Jiménez', 'Torres', '360 Bulevar Sur', 'Lomas', 'CA-ON', 'RAGU920919K3N', 'SJIT950812MNTWST8Q', 229, 'F'),
('Tomás', 'López', 'Navarro', '9335 Paseo Central', 'Reforma', 'AU-VIC', 'ANVA940822K7T', 'TLN910717HCOSPL4P', 142, 'M'),
('Valeria', 'Sánchez', 'Díaz', '7456 Paseo Central', 'Roma', 'NZ-WGN', 'HUHE831201Z0R', 'VSD940221MCDKMR8P', 280, 'F'),
('Carlos', 'Gutiérrez', 'Martínez', '8195 Calle Sur', 'Condesa', 'MX-JAL', 'AMDI820712EAD', 'CGM970625HTLPLS5C', 164, 'M'),
('Patricia', 'Pérez', 'Rodríguez', '5126 Calzada de la Paz', 'Polanco', 'US-FL', 'GUGA980315Z9V', 'PPR940501MBSLKN3A', 245, 'F'),
('Hugo', 'Álvarez', 'Sánchez', '6048 Avenida Este', 'Jardines', 'PT-13', 'RAGU920919K3N', 'HAS901010HDFDSD9S', 270, 'M'),
('Ana', 'Jiménez', 'Torres', '356 Avenida Central', 'Juárez', 'IT-62', 'ANVA940822K7T', 'AJIT960828MCDKLP4B', 229, 'F'),
('Alejandro', 'López', 'Navarro', '1668 Calzada Central', 'Obrera', 'FR-75', 'HUHE831201Z0R', 'ALN930415HTLSLK3A', 142, 'M'),
('Valeria', 'Sánchez', 'Díaz', '2531 Calle Norte', 'Campestre', 'DE-BE', 'AMDI820712EAD', 'VSD980806MBSHRL9E', 280, 'F'),
('Raúl', 'Gutiérrez', 'Martínez', '360 Bulevar Sur', 'Lomas', 'GB-LND', 'GUGA980315Z9V', 'RGM910303HDFMNR6D', 164, 'M'),
('Gabriela', 'Pérez', 'Rodríguez', '9335 Paseo Central', 'Reforma', 'CA-ON', 'RAGU920919K3N', 'GPPR970522MNTWST8Q', 245, 'F'),
('Eduardo', 'Álvarez', 'Sánchez', '7456 Paseo Central', 'Roma', 'AU-VIC', 'ANVA940822K7T', 'EAS920612HCOSPL4P', 270, 'M'),
('Isabel', 'Jiménez', 'Torres', '8195 Calle Sur', 'Condesa', 'NZ-WGN', 'HUHE831201Z0R', 'IJIT940721MCDKMR8P', 229, 'F'),
('Miguel', 'López', 'Navarro', '5126 Calzada de la Paz', 'Polanco', 'MX-JAL', 'AMDI820712EAD', 'MLN980504HTLPLS5C', 142, 'M'),
('Mónica', 'Sánchez', 'Díaz', '6048 Avenida Este', 'Jardines', 'US-FL', 'GUGA980315Z9V', 'MSD961128MBSLKN3A', 280, 'F'),
('Fernando', 'Gutiérrez', 'Martínez', '356 Avenida Central', 'Juárez', 'PT-13', 'RAGU920919K3N', 'FGM940420HDFDSD9S', 164, 'M'),
('Laura', 'Pérez', 'Rodríguez', '1668 Calzada Central', 'Obrera', 'IT-62', 'ANVA940822K7T', 'LAPR930609MCDKLP4B', 245, 'F'),
('Nicolás', 'Álvarez', 'Sánchez', '2531 Calle Norte', 'Campestre', 'FR-75', 'HUHE831201Z0R', 'NAS900703HTLSLK3A', 270, 'M'),
('Sofía', 'Jiménez', 'Torres', '360 Bulevar Sur', 'Lomas', 'DE-BE', 'AMDI820712EAD', 'SJIT950812MBSHRL9E', 229, 'F'),
('Tomás', 'López', 'Navarro', '9335 Paseo Central', 'Reforma', 'GB-LND', 'GUGA980315Z9V', 'TLN910717HDFMNR6D', 142, 'M'),
('Valeria', 'Sánchez', 'Díaz', '7456 Paseo Central', 'Roma', 'CA-ON', 'RAGU920919K3N', 'VSD940221MNTWST8Q', 280, 'F'),
('Carlos', 'Gutiérrez', 'Martínez', '8195 Calle Sur', 'Condesa', 'AU-VIC', 'ANVA940822K7T', 'CGM970625HCOSPL4P', 164, 'M'),
('Patricia', 'Pérez', 'Rodríguez', '5126 Calzada de la Paz', 'Polanco', 'NZ-WGN', 'HUHE831201Z0R', 'PPR940501MCDKMR8P', 245, 'F'),
('Hugo', 'Álvarez', 'Sánchez', '6048 Avenida Este', 'Jardines', 'MX-JAL', 'AMDI820712EAD', 'HAS901010HTLPLS5C', 270, 'M'),
('Ana', 'Jiménez', 'Torres', '356 Avenida Central', 'Juárez', 'US-FL', 'GUGA980315Z9V', 'AJIT960828MBSLKN3A', 229, 'F'),
('Alejandro', 'López', 'Navarro', '1668 Calzada Central', 'Obrera', 'PT-13', 'RAGU920919K3N', 'ALN930415HDFDSD9S', 142, 'M'),
('Valeria', 'Sánchez', 'Díaz', '2531 Calle Norte', 'Campestre', 'IT-62', 'ANVA940822K7T', 'VSD980806MCDKLP4B', 280, 'F'),
('Raúl', 'Gutiérrez', 'Martínez', '360 Bulevar Sur', 'Lomas', 'FR-75', 'HUHE831201Z0R', 'RGM910303HTLSLK3A', 164, 'M'),
('Gabriela', 'Pérez', 'Rodríguez', '9335 Paseo Central', 'Reforma', 'DE-BE', 'AMDI820712EAD', 'GPPR970522MBSHRL9E', 245, 'F'),
('Eduardo', 'Álvarez', 'Sánchez', '7456 Paseo Central', 'Roma', 'GB-LND', 'GUGA980315Z9V', 'EAS920612HDFMNR6D', 270, 'M'),
('Isabel', 'Jiménez', 'Torres', '8195 Calle Sur', 'Condesa', 'CA-ON', 'RAGU920919K3N', 'IJIT940721MNTWST8Q', 229, 'F'),
('Miguel', 'López', 'Navarro', '5126 Calzada de la Paz', 'Polanco', 'AU-VIC', 'ANVA940822K7T', 'MLN980504HCOSPL4P', 142, 'M'),
('Mónica', 'Sánchez', 'Díaz', '6048 Avenida Este', 'Jardines', 'NZ-WGN', 'HUHE831201Z0R', 'MSD961128MCDKMR8P', 280, 'F'),
('Fernando', 'Gutiérrez', 'Martínez', '356 Avenida Central', 'Juárez', 'MX-JAL', 'AMDI820712EAD', 'FGM940420HTLPLS5C', 164, 'M'),
('Laura', 'Pérez', 'Rodríguez', '1668 Calzada Central', 'Obrera', 'US-FL', 'GUGA980315Z9V', 'LAPR930609MBSLKN3A', 245, 'F'),
('Nicolás', 'Álvarez', 'Sánchez', '2531 Calle Norte', 'Campestre', 'PT-13', 'RAGU920919K3N', 'NAS900703HDFDSD9S', 270, 'M'),
('Sofía', 'Jiménez', 'Torres', '360 Bulevar Sur', 'Lomas', 'IT-62', 'ANVA940822K7T', 'SJIT950812MCDKLP4B', 229, 'F'),
('Tomás', 'López', 'Navarro', '9335 Paseo Central', 'Reforma', 'FR-75', 'HUHE831201Z0R', 'TLN910717HTLSLK3A', 142, 'M'),
('Valeria', 'Sánchez', 'Díaz', '7456 Paseo Central', 'Roma', 'DE-BE', 'AMDI820712EAD', 'VSD940221MBSHRL9E', 280, 'F'),
('Carlos', 'Gutiérrez', 'Martínez', '8195 Calle Sur', 'Condesa', 'GB-LND', 'GUGA980315Z9V', 'CGM970625HDFMNR6D', 164, 'M'),
('Patricia', 'Pérez', 'Rodríguez', '5126 Calzada de la Paz', 'Polanco', 'CA-ON', 'RAGU920919K3N', 'PPR940501MNTWST8Q', 245, 'F'),
('Hugo', 'Álvarez', 'Sánchez', '6048 Avenida Este', 'Jardines', 'AU-VIC', 'ANVA940822K7T', 'HAS901010HCOSPL4P', 270, 'M'),
('Ana', 'Jiménez', 'Torres', '356 Avenida Central', 'Juárez', 'NZ-WGN', 'HUHE831201Z0R', 'AJIT960828MCDKMR8P', 229, 'F'),
('Alejandro', 'López', 'Navarro', '1668 Calzada Central', 'Obrera', 'MX-JAL', 'AMDI820712EAD', 'ALN930415HTLPLS5C', 142, 'M'),
('Valeria', 'Sánchez', 'Díaz', '2531 Calle Norte', 'Campestre', 'US-FL', 'GUGA980315Z9V', 'VSD980806MBSLKN3A', 280, 'F'),
('Raúl', 'Gutiérrez', 'Martínez', '360 Bulevar Sur', 'Lomas', 'PT-13', 'RAGU920919K3N', 'RGM910303HDFDSD9S', 164, 'M'),
('Gabriela', 'Pérez', 'Rodríguez', '9335 Paseo Central', 'Reforma', 'IT-62', 'ANVA940822K7T', 'GPPR970522MCDKLP4B', 245, 'F'),
('Eduardo', 'Álvarez', 'Sánchez', '7456 Paseo Central', 'Roma', 'FR-75', 'HUHE831201Z0R', 'EAS920612HTLSLK3A', 270, 'M'),
('Isabel', 'Jiménez', 'Torres', '8195 Calle Sur', 'Condesa', 'DE-BE', 'AMDI820712EAD', 'IJIT940721MBSHRL9E', 229, 'F'),
('Miguel', 'López', 'Navarro', '5126 Calzada de la Paz', 'Polanco', 'GB-LND', 'GUGA980315Z9V', 'MLN980504HDFMNR6D', 142, 'M'),
('Mónica', 'Sánchez', 'Díaz', '6048 Avenida Este', 'Jardines', 'CA-ON', 'RAGU920919K3N', 'MSD961128MNTWST8Q', 280, 'F'),
('Fernando', 'Gutiérrez', 'Martínez', '356 Avenida Central', 'Juárez', 'AU-VIC', 'ANVA940822K7T', 'FGM940420HCOSPL4P', 164, 'M'),
('Laura', 'Pérez', 'Rodríguez', '1668 Calzada Central', 'Obrera', 'NZ-WGN', 'HUHE831201Z0R', 'LAPR930609MCDKMR8P', 245, 'F'),
('Nicolás', 'Álvarez', 'Sánchez', '2531 Calle Norte', 'Campestre', 'MX-JAL', 'AMDI820712EAD', 'NAS900703HTLPLS5C', 270, 'M'),
('Sofía', 'Jiménez', 'Torres', '360 Bulevar Sur', 'Lomas', 'US-FL', 'GUGA980315Z9V', 'SJIT950812MBSLKN3A', 229, 'F'),
('Tomás', 'López', 'Navarro', '9335 Paseo Central', 'Reforma', 'PT-13', 'RAGU920919K3N', 'TLN910717HDFDSD9S', 142, 'M'),
('Valeria', 'Sánchez', 'Díaz', '7456 Paseo Central', 'Roma', 'IT-62', 'ANVA940822K7T', 'VSD940221MCDKLP4B', 280, 'F'),
('Carlos', 'Gutiérrez', 'Martínez', '8195 Calle Sur', 'Condesa', 'FR-75', 'HUHE831201Z0R', 'CGM970625HTLSLK3A', 164, 'M'),
('Patricia', 'Pérez', 'Rodríguez', '5126 Calzada de la Paz', 'Polanco', 'DE-BE', 'AMDI820712EAD', 'PPR940501MBSHRL9E', 245, 'F'),
('Hugo', 'Álvarez', 'Sánchez', '6048 Avenida Este', 'Jardines', 'GB-LND', 'GUGA980315Z9V', 'HAS901010HDFMNR6D', 270, 'M'),
('Ana', 'Jiménez', 'Torres', '356 Avenida Central', 'Juárez', 'CA-ON', 'RAGU920919K3N', 'AJIT960828MNTWST8Q', 229, 'F'),
('Alejandro', 'López', 'Navarro', '1668 Calzada Central', 'Obrera', 'AU-VIC', 'ANVA940822K7T', 'ALN930415HCOSPL4P', 142, 'M'),
('Valeria', 'Sánchez', 'Díaz', '2531 Calle Norte', 'Campestre', 'NZ-WGN', 'HUHE831201Z0R', 'VSD980806MCDKMR8P', 280, 'F'),
('Raúl', 'Gutiérrez', 'Martínez', '360 Bulevar Sur', 'Lomas', 'MX-JAL', 'AMDI820712EAD', 'RGM910303HTLPLS5C', 164, 'M'),
('Gabriela', 'Pérez', 'Rodríguez', '9335 Paseo Central', 'Reforma', 'US-FL', 'GUGA980315Z9V', 'GPPR970522MBSLKN3A', 245, 'F'),
('Eduardo', 'Álvarez', 'Sánchez', '7456 Paseo Central', 'Roma', 'PT-13', 'RAGU920919K3N', 'EAS920612HDFDSD9S', 270, 'M'),
('Isabel', 'Jiménez', 'Torres', '8195 Calle Sur', 'Condesa', 'IT-62', 'ANVA940822K7T', 'IJIT940721MCDKLP4B', 229, 'F'),
('Miguel', 'López', 'Navarro', '5126 Calzada de la Paz', 'Polanco', 'FR-75', 'HUHE831201Z0R', 'MLN980504HTLSLK3A', 142, 'M'),
('Mónica', 'Sánchez', 'Díaz', '6048 Avenida Este', 'Jardines', 'DE-BE', 'AMDI820712EAD', 'MSD961128MBSHRL9E', 280, 'F'),
('Fernando', 'Gutiérrez', 'Martínez', '356 Avenida Central', 'Juárez', 'GB-LND', 'GUGA980315Z9V', 'FGM940420HDFMNR6D', 164, 'M'),
('Laura', 'Pérez', 'Rodríguez', '1668 Calzada Central', 'Obrera', 'CA-ON', 'RAGU920919K3N', 'LAPR930609MNTWST8Q', 245, 'F'),
('Nicolás', 'Álvarez', 'Sánchez', '2531 Calle Norte', 'Campestre', 'AU-VIC', 'ANVA940822K7T', 'NAS900703HCOSPL4P', 270, 'M'),
('Sofía', 'Jiménez', 'Torres', '360 Bulevar Sur', 'Lomas', 'NZ-WGN', 'HUHE831201Z0R', 'SJIT950812MCDKMR8P', 229, 'F'),
('Tomás', 'López', 'Navarro', '9335 Paseo Central', 'Reforma', 'MX-JAL', 'AMDI820712EAD', 'TLN910717HTLPLS5C', 142, 'M'),
('Valeria', 'Sánchez', 'Díaz', '7456 Paseo Central', 'Roma', 'US-FL', 'GUGA980315Z9V', 'VSD940221MBSLKN3A', 280, 'F'),
('Carlos', 'Gutiérrez', 'Martínez', '8195 Calle Sur', 'Condesa', 'PT-13', 'RAGU920919K3N', 'CGM970625HDFDSD9S', 164, 'M'),
('Patricia', 'Pérez', 'Rodríguez', '5126 Calzada de la Paz', 'Polanco', 'IT-62', 'ANVA940822K7T', 'PPR940501MCDKLP4B', 245, 'F'),
('Hugo', 'Álvarez', 'Sánchez', '6048 Avenida Este', 'Jardines', 'FR-75', 'HUHE831201Z0R', 'HAS901010HTLSLK3A', 270, 'M'),
('Ana', 'Jiménez', 'Torres', '356 Avenida Central', 'Juárez', 'DE-BE', 'AMDI820712EAD', 'AJIT960828MBSHRL9E', 229, 'F'),
('Alejandro', 'López', 'Navarro', '1668 Calzada Central', 'Obrera', 'GB-LND', 'GUGA980315Z9V', 'ALN930415HDFMNR6D', 142, 'M'),
('Valeria', 'Sánchez', 'Díaz', '2531 Calle Norte', 'Campestre', 'CA-ON', 'RAGU920919K3N', 'VSD980806MNTWST8Q', 280, 'F'),
('Raúl', 'Gutiérrez', 'Martínez', '360 Bulevar Sur', 'Lomas', 'AU-VIC', 'ANVA940822K7T', 'RGM910303HCOSPL4P', 164, 'M'),
('Gabriela', 'Pérez', 'Rodríguez', '9335 Paseo Central', 'Reforma', 'NZ-WGN', 'HUHE831201Z0R', 'GPPR970522MCDKMR8P', 245, 'F'),
('Eduardo', 'Álvarez', 'Sánchez', '7456 Paseo Central', 'Roma', 'MX-JAL', 'AMDI820712EAD', 'EAS920612HTLPLS5C', 270, 'M'),
('Isabel', 'Jiménez', 'Torres', '8195 Calle Sur', 'Condesa', 'US-FL', 'GUGA980315Z9V', 'IJIT940721MBSLKN3A', 229, 'F'),
('Miguel', 'López', 'Navarro', '5126 Calzada de la Paz', 'Polanco', 'PT-13', 'RAGU920919K3N', 'MLN980504HDFDSD9S', 142, 'M'),
('Mónica', 'Sánchez', 'Díaz', '6048 Avenida Este', 'Jardines', 'IT-62', 'ANVA940822K7T', 'MSD961128MCDKLP4B', 280, 'F'),
('Fernando', 'Gutiérrez', 'Martínez', '356 Avenida Central', 'Juárez', 'FR-75', 'HUHE831201Z0R', 'FGM940420HTLSLK3A', 164, 'M'),
('Laura', 'Pérez', 'Rodríguez', '1668 Calzada Central', 'Obrera', 'DE-BE', 'AMDI820712EAD', 'LAPR930609MBSHRL9E', 245, 'F'),
('Nicolás', 'Álvarez', 'Sánchez', '2531 Calle Norte', 'Campestre', 'GB-LND', 'GUGA980315Z9V', 'NAS900703HDFMNR6D', 270, 'M'),
('Sofía', 'Jiménez', 'Torres', '360 Bulevar Sur', 'Lomas', 'CA-ON', 'RAGU920919K3N', 'SJIT950812MNTWST8Q', 229, 'F'),
('Tomás', 'López', 'Navarro', '9335 Paseo Central', 'Reforma', 'AU-VIC', 'ANVA940822K7T', 'TLN910717HCOSPL4P', 142, 'M'),
('Valeria', 'Sánchez', 'Díaz', '7456 Paseo Central', 'Roma', 'NZ-WGN', 'HUHE831201Z0R', 'VSD940221MCDKMR8P', 280, 'F'),
('Alejandro', 'López', 'Rodríguez', '8880 Avenida Norte', 'Juárez', 'MX-CMX', 'LORA850525K3A', 'LORA850525HDFPDL09', 101, 'M'),
('Ana', 'Sánchez', 'Pérez', '7699 Avenida Norte', 'Lomas', 'ES-MD', 'SAPA880310Y5E', 'SAPA880310MDFNRN03', 19, 'F'),
('Carlos', 'Martínez', 'Gómez', '9502 Bulevar de la Paz', 'Reforma', 'CL-RM', 'MAGC920919K3N', 'MAGC920919HDFRTM06', 242, 'M'),
('Diana', 'Gutiérrez', 'Fernández', '5126 Calzada de la Paz', 'Condesa', 'US-CA', 'GUFD831201Z0R', 'GUFD831201MDFRTN08', 211, 'F'),
('Eduardo', 'Pérez', 'López', '6048 Avenida Este', 'Polanco', 'BR-SP', 'PELE820712EAD', 'PELE820712HDFRZL02', 29, 'M'),
('Elena', 'Romero', 'Sánchez', '356 Avenida Central', 'Jardines', 'CA-ON', 'ROSE980315Z9V', 'ROSE980315MDFRML04', 151, 'F'),
('Fernando', 'Álvarez', 'Jiménez', '1668 Calzada Central', 'Juárez', 'AU-VIC', 'ALJF881026MNQ', 'ALJF881026HDFRVN07', 115, 'M'),
('Gabriela', 'Torres', 'Navarro', '2531 Calle Norte', 'Obrera', 'VE-J', 'TONG850210U09', 'TONG850210MDFRTB05', 270, 'F'),
('Hugo', 'Díaz', 'Moreno', '360 Bulevar Sur', 'Campestre', 'PT-13', 'DIMH920919K3N', 'DIMH920919HDFRZM09', 174, 'M'),
('Isabel', 'Gómez', 'Ruiz', '9335 Paseo Central', 'Lomas', 'ES-MD', 'GORI831201Z0R', 'GORI831201MDFMZB01', 212, 'F'),
('Javier', 'Hernández', 'Castro', '4521 Calle Sur', 'Roma Norte', 'MX-CMX', 'HECJ910625P2K', 'HECJ910625HDFRSV03', 102, 'M'),
('Karen', 'Ramírez', 'Vargas', '8734 Avenida Poniente', 'Santa Fe', 'US-NY', 'RAVK870918Q4L', 'RAVK870918MDFMGR06', 215, 'F'),
('Luis', 'Flores', 'Mendoza', '1234 Paseo Norte', 'Insurgentes', 'AR-B', 'FOML940522R8M', 'FOML940522HDFNDS08', 45, 'M'),
('María', 'Cruz', 'Silva', '5678 Bulevar Este', 'Del Valle', 'CO-DC', 'CRSM860404S1N', 'CRSM860404MDFRLV02', 89, 'F'),
('Nicolás', 'Ramos', 'Ortiz', '9012 Calzada Oeste', 'Narvarte', 'PE-LIM', 'RAON930717T3O', 'RAON930717HDFMRT05', 167, 'M'),
('Olivia', 'Morales', 'Domínguez', '3456 Avenida Sur', 'Coyoacán', 'MX-JAL', 'MODO891103U5P', 'MODO891103MDFRLC07', 103, 'F'),
('Pablo', 'Castro', 'Guerrero', '7890 Calle Central', 'Lindavista', 'ES-BCN', 'CAGP950826V7Q', 'CAGP950826HDFSTR09', 213, 'M'),
('Paola', 'Vega', 'Mendez', '2345 Paseo Poniente', 'Azcapotzalco', 'FR-IDF', 'VEMP881215W9R', 'VEMP881215MDFGND04', 132, 'F'),
('Rafael', 'Reyes', 'Salazar', '6789 Bulevar Norte', 'Tlalpan', 'IT-RM', 'RESR920508X2S', 'RESR920508HDFYZL06', 145, 'M'),
('Rosa', 'Jiménez', 'Rojas', '1357 Calzada Sur', 'Xochimilco', 'DE-BE', 'JIRR870630Y4T', 'JIRR870630MDFMJS08', 128, 'F'),
('Sergio', 'Núñez', 'Herrera', '2468 Avenida Este', 'Iztapalapa', 'GB-LND', 'NUHS940919Z6U', 'NUHS940919HDFNRH01', 138, 'M'),
('Sofía', 'Medina', 'Aguilar', '3579 Calle Oeste', 'Gustavo A. Madero', 'JP-13', 'MEAS851204A8V', 'MEAS851204MDFLFS03', 155, 'F'),
('Tomás', 'Chávez', 'Cordero', '4680 Paseo Este', 'Cuauhtémoc', 'CN-11', 'CHCT930417B1W', 'CHCT930417HDFRVS05', 78, 'M'),
('Valeria', 'Domínguez', 'Ríos', '5791 Bulevar Oeste', 'Venustiano Carranza', 'IN-DL', 'DORV880723C3X', 'DORV880723MDFMRL07', 149, 'F'),
('Vicente', 'Ruiz', 'Luna', '6802 Calzada Norte', 'Benito Juárez', 'RU-MOW', 'RULV960512D5Y', 'RULV960512HDFNZL09', 182, 'M'),
('Victoria', 'Herrera', 'Montoya', '7913 Avenida Sur', 'Miguel Hidalgo', 'AU-NSW', 'HEMV891028E7Z', 'HEMV891028MDFRTM02', 116, 'F'),
('Walter', 'Ortiz', 'Ponce', '8024 Calle Central', 'Álvaro Obregón', 'NZ-AUK', 'ORPW920603F9A', 'ORPW920603HDFNCP04', 161, 'M'),
('Ximena', 'Garza', 'Campos', '9135 Paseo Poniente', 'Tláhuac', 'ZA-GT', 'GACX870819G2B', 'GACX870819MDFRZM06', 191, 'F'),
('Yolanda', 'Soto', 'Vázquez', '1246 Bulevar Este', 'Milpa Alta', 'EG-C', 'SOVY950205H4C', 'SOVY950205MDFTZL08', 122, 'F'),
('Zacarías', 'Mendoza', 'Morales', '2357 Calzada Oeste', 'Magdalena Contreras', 'NG-LA', 'MEMZ881117I6D', 'MEMZ881117HDFNDM01', 163, 'M'),
('Adriana', 'Vargas', 'Peña', '3468 Avenida Norte', 'Cuajimalpa', 'KE-NBO', 'VAPA940622J8E', 'VAPA940622MDFRNP03', 153, 'F'),
('Alberto', 'Silva', 'Robles', '4579 Calle Sur', 'Roma Sur', 'MX-NLE', 'SIRA910914K1F', 'SIRA910914HDFLLR05', 104, 'M'),
('Alicia', 'Cortés', 'Torres', '5680 Paseo Central', 'Doctores', 'CL-AN', 'COTA860508L3G', 'COTA860508MDFRTT07', 243, 'F'),
('Andrés', 'Aguilar', 'Guzmán', '6791 Bulevar Poniente', 'Escandón', 'UY-MO', 'AGGA930726M5H', 'AGGA930726HDFGZN09', 265, 'M'),
('Angélica', 'Ponce', 'Santos', '7802 Calzada Este', 'San Rafael', 'PY-ASU', 'POSA880311N7I', 'POSA880311MDFNTS02', 169, 'F'),
('Antonio', 'León', 'Ávila', '8913 Avenida Oeste', 'Tabacalera', 'BO-SC', 'LEAA951203O9J', 'LEAA951203HDFNVL04', 56, 'M'),
('Beatriz', 'Cabrera', 'Castillo', '9024 Calle Norte', 'Cuauhtémoc Centro', 'EC-P', 'CACB870629P2K', 'CACB870629MDFSTL06', 118, 'F'),
('Benjamín', 'Pacheco', 'Morales', '1135 Paseo Sur', 'Anzures', 'GT-GUA', 'PAMB920415Q4L', 'PAMB920415HDFCRM08', 141, 'M'),
('Brenda', 'Santos', 'Padilla', '2246 Bulevar Central', 'Peralvillo', 'HN-FM', 'SAPB941127R6M', 'SAPB941127MDFTDL01', 143, 'F'),
('Bruno', 'Ríos', 'Gutiérrez', '3357 Calzada Poniente', 'Morelos', 'SV-SS', 'RIGB860903S8N', 'RIGB860903HDFSGT03', 196, 'M'),
('Camila', 'Delgado', 'Ramírez', '4468 Avenida Este', 'Obrera Centro', 'NI-MN', 'DERC931219T1O', 'DERC931219MDFGMR05', 162, 'F'),
('César', 'Campos', 'Flores', '5579 Calle Oeste', 'Guerrero', 'CR-SJ', 'CAFC880504U3P', 'CAFC880504HDFMLF07', 93, 'M'),
('Claudia', 'Fuentes', 'Lozano', '6680 Paseo Norte', 'Buenavista', 'PA-8', 'FULC951026V5Q', 'FULC951026MDFLZN09', 165, 'F'),
('Cristian', 'Salinas', 'Herrera', '7791 Bulevar Sur', 'Santa María la Ribera', 'CU-03', 'SAHC870812W7R', 'SAHC870812HDFNRR02', 98, 'M'),
('Cristina', 'Guevara', 'Domínguez', '8802 Calzada Central', 'Atlampa', 'DO-01', 'GUDC920628X9S', 'GUDC920628MDFDMC04', 114, 'F'),
('Daniel', 'Lara', 'Núñez', '9913 Avenida Poniente', 'San Simón Tolnáhuac', 'JM-14', 'LAND941114Y2T', 'LAND941114HDFRNZ06', 152, 'M'),
('Daniela', 'Miranda', 'Medina', '1024 Calle Este', 'Magdalena Mixhuca', 'TT-POS', 'MIMD860430Z4U', 'MIMD860430MDFRDM08', 257, 'F'),
('David', 'Carrillo', 'Chávez', '2135 Paseo Oeste', 'Moctezuma', 'BB-BB', 'CACD930716A6V', 'CACD930716HDFRHV01', 50, 'M'),
('Débora', 'Paredes', 'Ruiz', '3246 Bulevar Norte', 'Aeronáutica', 'LC-10', 'PARD881002B8W', 'PARD881002MDFRZ03', 198, 'F'),
('Diego', 'Marín', 'Ortiz', '4357 Calzada Sur', 'Mártires de Río Blanco', 'VC-06', 'MAOD951218C1X', 'MAOD951218HDFRTD05', 267, 'M'),
('Dulce', 'Estrada', 'Castro', '5468 Avenida Central', 'Merced Balbuena', 'GD-04', 'ESCD870504D3Y', 'ESCD870504MDFSCT07', 140, 'F'),
('Edgar', 'Ibáñez', 'Vega', '6579 Calle Poniente', 'Pensador Mexicano', 'AG-AG', 'IBVE920820E5Z', 'IBVE920820HDFBGV09', 11, 'M'),
('Edith', 'Cárdenas', 'Mendoza', '7680 Paseo Este', 'Jardín Balbuena', 'BC-BCN', 'CAME941106F7A', 'CAME941106MDFRDM02', 12, 'F'),
('Eduardo', 'Gallegos', 'Aguilar', '8791 Bulevar Oeste', 'Federal', 'BCS-LAP', 'GAAE860622G9B', 'GAAE860622HDFGGL04', 13, 'M'),
('Elisa', 'Montes', 'Ponce', '9802 Calzada Norte', 'Aeropuerto', 'CAMP-CAM', 'MOPE931008H2C', 'MOPE931008MDFNTP06', 14, 'F'),
('Emilio', 'Figueroa', 'León', '1913 Avenida Sur', 'Peñón de los Baños', 'CHIS-TGZ', 'FOLE880724I4D', 'FOLE880724HDFLGN08', 15, 'M'),
('Emma', 'Ochoa', 'Cabrera', '2024 Calle Central', 'Pantitlán', 'CHIH-CHH', 'OCCE951210J6E', 'OCCE951210MDFHCM01', 16, 'F'),
('Enrique', 'Sandoval', 'Pacheco', '3135 Paseo Poniente', 'Moctezuma 2a Sección', 'COAH-SLT', 'SAPE870926K8F', 'SAPE870926HDFNCP03', 17, 'M'),
('Erika', 'Maldonado', 'Santos', '4246 Bulevar Este', 'Romero Rubio', 'COL-COL', 'MASE920712L1G', 'MASE920712MDFLTS05', 18, 'F'),
('Ernesto', 'Navarro', 'Ríos', '5357 Calzada Oeste', 'Morelos Ampliación', 'DGO-DGO', 'NARE941028M3H', 'NARE941028HDFVRS07', 20, 'M'),
('Esmeralda', 'Peña', 'Delgado', '6468 Avenida Norte', 'Hidalgo', 'GTO-LEO', 'PEDE860814N5I', 'PEDE860814MDFNDL09', 21, 'F'),
('Esteban', 'Escobar', 'Campos', '7579 Calle Sur', 'Felipe Ángeles', 'HGO-PAC', 'ESEC930630O7J', 'ESEC930630HDFSCM02', 22, 'M'),
('Estrella', 'Velázquez', 'Fuentes', '8680 Paseo Central', 'Ampliación Peñón', 'JAL-GDL', 'VEFE881116P9K', 'VEFE881116MDFZFT04', 23, 'F'),
('Fabián', 'Villanueva', 'Salinas', '9791 Bulevar Poniente', 'El Rodeo', 'MEX-TLC', 'VISF951002Q2L', 'VISF951002HDFLSL06', 24, 'M'),
('Fabiola', 'Contreras', 'Guevara', '1802 Calzada Este', 'Emiliano Zapata', 'MICH-MOR', 'COGF870418R4M', 'COGF870418MDFNTV08', 25, 'F'),
('Federico', 'Rojas', 'Lara', '2913 Avenida Oeste', 'Ignacio Zaragoza', 'MOR-CVX', 'ROLF920804S6N', 'ROLF920804HDFJLR01', 26, 'M'),
('Fernanda', 'Moreno', 'Miranda', '3024 Calle Norte', 'Agrícola Pantitlán', 'NAY-TEP', 'MOMF941120T8O', 'MOMF941120MDFRRD03', 27, 'F'),
('Francisco', 'Zamora', 'Carrillo', '4135 Paseo Sur', 'Santa Cruz Meyehualco', 'NLE-MTY', 'ZACF860706U1P', 'ZACF860706HDFMRC05', 28, 'M'),
('Gabriela', 'Vázquez', 'Paredes', '5246 Bulevar Central', 'Tepalcates', 'OAX-OAX', 'VAPG931022V3Q', 'VAPG931022MDFZRD07', 30, 'F'),
('Gerardo', 'Blanco', 'Marín', '6357 Calzada Poniente', 'Valle Gómez', 'PUE-PUE', 'BLMG880608W5R', 'BLMG880608HDFNMR09', 31, 'M'),
('Gisela', 'Torres', 'Estrada', '7468 Avenida Este', 'Jardín Azpeitia', 'QRO-QRO', 'TOEG951124X7S', 'TOEG951124MDFRTD02', 32, 'F'),
('Gloria', 'Guerrero', 'Ibáñez', '8579 Calle Oeste', 'Tlazintla', 'QROO-CHE', 'GUIG870410Y9T', 'GUIG870410MDFRB04', 33, 'F'),
('Gonzalo', 'Rivas', 'Cárdenas', '9680 Paseo Norte', 'Lomas de Zaragoza', 'SLP-SLP', 'RICG920926Z2U', 'RICG920926HDFVRD06', 34, 'M'),
('Graciela', 'Coronado', 'Gallegos', '1791 Bulevar Sur', 'La Perla', 'SIN-CUL', 'COGG941012A4V', 'COGG941012MDFRLG08', 35, 'F'),
('Guillermo', 'Duarte', 'Montes', '2802 Calzada Central', 'Ixtlahuacan', 'SON-HMO', 'DUMG860628B6W', 'DUMG860628HDFRTT01', 36, 'M'),
('Gustavo', 'Trejo', 'Figueroa', '3913 Avenida Poniente', 'San Miguel Teotongo', 'TAB-VSA', 'TRIG930814C8X', 'TRIG930814HDFRJF03', 37, 'M'),
('Hilda', 'Suárez', 'Ochoa', '4024 Calle Este', 'Predio San Juan de Aragón', 'TAMS-TAM', 'SUOH881130D1Y', 'SUOH881130MDFZCH05', 38, 'F'),
('Horacio', 'Nava', 'Sandoval', '5135 Paseo Oeste', 'Carlos Zapata Vela', 'TLAX-TLA', 'NASH951016E3Z', 'NASH951016HDFVSD07', 39, 'M'),
('Ignacio', 'Méndez', 'Maldonado', '6246 Bulevar Norte', 'Ampliación Gabriel Ramos', 'VER-XAL', 'MEMI870702F5A', 'MEMI870702HDFNDM09', 40, 'M'),
('Ingrid', 'Olvera', 'Navarro', '7357 Calzada Sur', 'Las Peñas', 'YUC-MID', 'OLON920518G7B', 'OLON920518MDFLVN02', 41, 'F'),
('Irene', 'Arias', 'Peña', '8468 Avenida Central', 'Santiago Acahualtepec', 'ZAC-ZAC', 'ARPI941104H9C', 'ARPI941104MDFRSP04', 42, 'F'),
('Isaac', 'Barrera', 'Escobar', '9579 Calle Poniente', 'El Caracol', 'MX-CMX', 'BAEI860920I2D', 'BAEI860920HDFRSC06', 105, 'M'),
('Isabel', 'Cordero', 'Velázquez', '1680 Paseo Este', 'Miravalle', 'ES-MD', 'COVI931006J4E', 'COVI931006MDFRDL08', 214, 'F'),
('Isidro', 'Galván', 'Villanueva', '2791 Bulevar Oeste', 'Lomas de San Lorenzo', 'AR-C', 'GAVI880722K6F', 'GAVI880722HDFLVL01', 46, 'M'),
('Ivana', 'Prieto', 'Contreras', '3802 Calzada Norte', 'Agrícola Oriental', 'CO-AMA', 'PRCI951208L8G', 'PRCI951208MDFRTC03', 90, 'F'),
('Iván', 'Ugalde', 'Rojas', '4913 Avenida Sur', 'Cuchilla Agrícola Oriental', 'PE-CUS', 'UGRI870624M1H', 'UGRI870624HDFGLR05', 168, 'M'),
('Jacinto', 'Hurtado', 'Moreno', '5024 Calle Central', 'José María Morelos y Pavón', 'UR-MO', 'HUMJ921010N3I', 'HUMJ921010HDFRTM07', 264, 'M'),
('Jacqueline', 'Santillán', 'Zamora', '6135 Paseo Poniente', 'Ampliación Casas Alemán', 'PY-11', 'SAZJ940826O5J', 'SAZJ940826MDFTLM09', 170, 'F'),
('Jaime', 'Salas', 'Vázquez', '7246 Bulevar Este', 'Casas Alemán', 'BO-LPZ', 'SAVJ860512P7K', 'SAVJ860512HDFLVZ02', 57, 'M'),
('Jazmín', 'Solís', 'Blanco', '8357 Calzada Oeste', 'Progresista', 'EC-G', 'SOBJ930728Q9L', 'SOBJ930728MDFLLB04', 119, 'F'),
('Jesús', 'Luna', 'Torres', '9468 Avenida Norte', '7 de Julio', 'GT-01', 'LUTJ881214R2M', 'LUTJ881214HDFNRT06', 142, 'M'),
('Jimena', 'Cervantes', 'Guerrero', '1579 Calle Sur', 'Ampliación Caracol', 'HN-AT', 'CEGJ951030S4N', 'CEGJ951030MDFRVG08', 144, 'F'),
('Joaquín', 'Camacho', 'Rivas', '2680 Paseo Central', 'Emilio Carranza', 'SV-AH', 'CARJ870616T6O', 'CARJ870616HDFMRV01', 197, 'M'),
('Jorge', 'Godínez', 'Coronado', '3791 Bulevar Poniente', '10 de Mayo', 'NI-AS', 'GOCJ920902U8P', 'GOCJ920902HDFNRC03', 164, 'M'),
('Josefina', 'Ayala', 'Duarte', '4802 Calzada Este', 'Providencia', 'CR-A', 'AYDJ941118V1Q', 'AYDJ941118MDFYLT05', 94, 'F'),
('José', 'Bravo', 'Trejo', '5913 Avenida Oeste', 'Magdalena Atlazolpa', 'PA-3', 'BATJ860404W3R', 'BATJ860404HDFRVT07', 166, 'M'),
('Josué', 'Cervera', 'Suárez', '6024 Calle Norte', 'Ermita Zaragoza', 'CU-HAB', 'CESJ931020X5S', 'CESJ931020HDFRVZ09', 99, 'M'),
('Juan', 'Ibarra', 'Nava', '7135 Paseo Sur', 'Agua Prieta', 'DO-32', 'IBAJ880706Y7T', 'IBAJ880706HDFBRN02', 113, 'M'),
('Juana', 'Espinoza', 'Méndez', '8246 Bulevar Central', 'Unidad Habitacional Vicente Guerrero', 'JM-13', 'ESMJ951122Z9U', 'ESMJ951122MDFSPD04', 154, 'F'),
('Judith', 'Palacios', 'Olvera', '9357 Calzada Poniente', 'Santa Martha Acatitla Norte', 'TT-SFO', 'PAOJ870608A2V', 'PAOJ870608MDFLVR06', 258, 'F'),
('Julia', 'Quintero', 'Arias', '1468 Avenida Este', 'Ejército de Oriente', 'BB-05', 'QUAJ920924B4W', 'QUAJ920924MDFRRS08', 51, 'F'),
('Julián', 'Roldán', 'Barrera', '2579 Calle Oeste', 'Chinampac de Juárez', 'LC-02', 'ROBJ941210C6X', 'ROBJ941210HDFLLR01', 199, 'M'),
('Julio', 'Esquivel', 'Cordero', '3680 Paseo Norte', 'El Prado', 'VC-01', 'ESCJ860826D8Y', 'ESCJ860826HDFSQD03', 268, 'M'),
('Karla', 'Pineda', 'Galván', '4791 Bulevar Sur', 'Lomas de la Estancia', 'GD-06', 'PIGK930712E1Z', 'PIGK930712MDFLVN05', 139, 'F'),
('Katia', 'Arellano', 'Prieto', '5802 Calzada Central', 'Santa Cruz Meyehualco Prim', 'AG-ASG', 'ARPK881028F3A', 'ARPK881028MDFRLT07', 10, 'F'),
('Kevin', 'Tovar', 'Ugalde', '6913 Avenida Poniente', 'Lomas de Zaragoza Sur', 'BC-TIJ', 'TOUK951114G5B', 'TOUK951114HDFVGL09', 43, 'M'),
('Kimberly', 'Nieto', 'Hurtado', '7024 Calle Este', 'Reforma Política', 'BCS-CSL', 'NIHK870630H7C', 'NIHK870630MDFTRH02', 44, 'F'),
('Laura', 'Rosales', 'Santillán', '8135 Paseo Oeste', 'Valle de Luces', 'CAMP-CPM', 'ROSL920916I9D', 'ROSL920916MDFSSL04', 47, 'F'),
('Leonardo', 'Tapia', 'Salas', '9246 Bulevar Norte', 'México 68', 'CHIS-TUX', 'TASL941202J2E', 'TASL941202HDFTPL06', 48, 'M'),
('Leticia', 'Bautista', 'Solís', '1357 Calzada Sur', 'Evolución', 'CHIH-JUA', 'BASL860518K4F', 'BASL860518MDFTSL08', 49, 'F'),
('Liliana', 'Olivares', 'Luna', '2468 Avenida Central', 'La Regadera', 'COAH-TRC', 'OLLL930804L6G', 'OLLL930804MDFLLN01', 52, 'F'),
('Lorenzo', 'Valle', 'Cervantes', '3579 Calle Poniente', 'Leyes de Reforma 1a Sección', 'COL-MZT', 'VALC881120M8H', 'VALC881120HDFLRC03', 53, 'M'),
('Lorena', 'Murillo', 'Camacho', '4680 Paseo Este', 'Jardines de Churubusco', 'DGO-GOM', 'MUCL951006N1I', 'MUCL951006MDFRMH05', 54, 'F'),
('Lucas', 'Farías', 'Godínez', '5791 Bulevar Oeste', 'Ampliación Los Reyes', 'GTO-CEL', 'FAGL870622O3J', 'FAGL870622HDFRSD07', 55, 'M'),
('Lucía', 'Becerra', 'Ayala', '6802 Calzada Norte', 'El Triángulo', 'HGO-TUL', 'BEAL920908P5K', 'BEAL920908MDFCYL09', 58, 'F'),
('Luciano', 'Cisneros', 'Bravo', '7913 Avenida Sur', 'Los Reyes Culhuacán', 'JAL-PVR', 'CIBL941124Q7L', 'CIBL941124HDFSBR02', 59, 'M'),
('Luisa', 'Uribe', 'Cervera', '8024 Calle Central', 'Ampliación Juventino Rosas', 'MEX-ECT', 'URCL860610R9M', 'URCL860610MDFRBC04', 60, 'F'),
('Manuel', 'Zavala', 'Ibarra', '9135 Paseo Poniente', 'Santa Isabel Industrial', 'MICH-LAZ', 'ZAIM930826S2N', 'ZAIM930826HDFVBR06', 61, 'M'),
('Manuela', 'Bustamante', 'Espinoza', '1246 Bulevar Este', 'Aculco', 'MOR-CUE', 'BUEM881112T4O', 'BUEM881112MDFSTS08', 62, 'F'),
('Marcela', 'Garduño', 'Palacios', '2357 Calzada Oeste', 'Chinampac', 'NAY-BAH', 'GAPM951028U6P', 'GAPM951028MDFRDL01', 63, 'F'),
('Marcelo', 'Hidalgo', 'Quintero', '3468 Avenida Norte', 'Ampliación Santa Isabel', 'NLE-APO', 'HIQM870714V8Q', 'HIQM870714HDFDLT03', 64, 'M'),
('Marco', 'Zúñiga', 'Roldán', '4579 Calle Sur', 'Bellavista', 'OAX-JUC', 'ZURM920930W1R', 'ZURM920930HDFNLD05', 65, 'M'),
('Marcos', 'Elizondo', 'Esquivel', '5680 Paseo Central', 'Ampliación Emiliano Zapata', 'PUE-TEH', 'ELEM941016X3S', 'ELEM941016HDFLSQ07', 66, 'M'),
('Margarita', 'Rentería', 'Pineda', '6791 Bulevar Poniente', 'Gabriel Ramos Millán', 'QRO-SJR', 'REPM860702Y5T', 'REPM860702MDFNTD09', 67, 'F'),
('María', 'Valdivia', 'Arellano', '7802 Calzada Este', 'Ampliación Tepepan', 'QROO-OTH', 'VAAM930918Z7U', 'VAAM930918MDFLDR02', 68, 'F'),
('Mariana', 'Ávalos', 'Tovar', '8913 Avenida Oeste', 'El Sifón', 'SLP-MTH', 'AVTM881204A9V', 'AVTM881204MDFVLV04', 69, 'F'),
('Marina', 'Fonseca', 'Nieto', '9024 Calle Norte', 'Ampliación Torre Blanca', 'SIN-MAZ', 'FONM951020B2W', 'FONM951020MDFNST06', 70, 'F'),
('Mario', 'Jaramillo', 'Rosales', '1135 Paseo Sur', 'Churubusco Tepeyac', 'SON-OBR', 'JARM870606C4X', 'JARM870606HDFRRS08', 71, 'M'),
('Marta', 'Ledezma', 'Tapia', '2246 Bulevar Central', 'Barrio San Marcos', 'TAB-CDE', 'LETM920922D6Y', 'LETM920922MDFDTP01', 72, 'F'),
('Martín', 'Alcántara', 'Bautista', '3357 Calzada Poniente', 'San Lorenzo Tezonco', 'TAMS-REY', 'ALBM941108E8Z', 'ALBM941108HDFLBT03', 73, 'M'),
('Mateo', 'Peralta', 'Olivares', '4468 Avenida Este', 'Pueblo de San Miguel Teotongo', 'TLAX-CHI', 'PEOM860624F1A', 'PEOM860624HDFRLL05', 74, 'M'),
('Mauricio', 'Segura', 'Valle', '5579 Calle Oeste', 'Culhuacán', 'VER-COR', 'SEVM930810G3B', 'SEVM930810HDFGLL07', 75, 'M'),
('Mauro', 'Trujillo', 'Murillo', '6680 Paseo Norte', 'Héroes de Churubusco', 'YUC-TIZ', 'TRMM881126H5C', 'TRMM881126HDFRRM09', 76, 'M'),
('Maximiliano', 'Ordóñez', 'Farías', '7791 Bulevar Sur', 'Presidentes Ejidales 1a Sección', 'ZAC-FRE', 'ORFM951012I7D', 'ORFM951012HDFRD02', 77, 'M'),
('Melissa', 'Aguirre', 'Becerra', '8802 Calzada Central', 'Presidentes Ejidales 2a Sección', 'MX-CHI', 'AGBM870628J9E', 'AGBM870628MDFRBC04', 79, 'F'),
('Mercedes', 'Acosta', 'Cisneros', '9913 Avenida Poniente', 'Unidad Habitacional Ejército Constitucionalista', 'ES-BCN', 'ACCM921014K2F', 'ACCM921014MDFCSR06', 80, 'F'),
('Miguel', 'Duran', 'Uribe', '1024 Calle Este', 'Ampliación Torre Blanca Sur', 'AR-SF', 'DUUM941230L4G', 'DUUM941230HDFRRC08', 81, 'M'),
('Miriam', 'Espino', 'Zavala', '2135 Paseo Oeste', 'Culhuacán CTM Sección IX-A', 'CO-BOL', 'ESZM860516M6H', 'ESZM860516MDFSVL01', 82, 'F'),
('Mirna', 'Lovera', 'Bustamante', '3246 Bulevar Norte', 'Granjas Estrella', 'PE-AYA', 'LOBM931002N8I', 'LOBM931002MDFVST03', 83, 'F'),
('Mónica', 'Saucedo', 'Garduño', '4357 Calzada Sur', 'Campestre Potrero', 'UR-CAN', 'SAGM880718O1J', 'SAGM880718MDFCDN05', 84, 'F'),
('Natalia', 'Amador', 'Hidalgo', '5468 Avenida Central', 'San Pedro Mártir', 'PY-CE', 'AMHN951104P3K', 'AMHN951104MDFLDT07', 85, 'F'),
('Natalicio', 'Franco', 'Zúñiga', '6579 Calle Poniente', 'Cafetales', 'BO-CBB', 'FRZN870620Q5L', 'FRZN870620HDFRNZ09', 86, 'M'),
('Néstor', 'Macías', 'Elizondo', '7680 Paseo Este', 'Paseos de Taxqueña', 'EC-ESM', 'MAEN920906R7M', 'MAEN920906HDFCLS02', 87, 'M'),
('Nicolás', 'Villa', 'Rentería', '8791 Bulevar Oeste', 'Coapa', 'GT-HUE', 'VIRN941122S9N', 'VIRN941122HDFLLT04', 88, 'M'),
('Nora', 'Maldonado', 'Valdivia', '9802 Calzada Norte', 'Ex-Ejido de San Francisco Culhuacán', 'HN-CH', 'MAVN860608T2O', 'MAVN860608MDFLDL06', 91, 'F'),
('Norma', 'Rosas', 'Ávalos', '1913 Avenida Sur', 'Progreso Tizapán', 'SV-UN', 'ROAN931024U4P', 'ROAN931024MDFSVL08', 92, 'F'),
('Octavio', 'Cano', 'Fonseca', '2024 Calle Central', 'Los Girasoles', 'NI-RI', 'CAFO880810V6Q', 'CAFO880810HDFNNS01', 95, 'M'),
('Ofelia', 'Madera', 'Jaramillo', '3135 Paseo Poniente', 'Magisterial', 'CR-G', 'MAJO951126W8R', 'MAJO951126MDFDRL03', 96, 'F'),
('Olga', 'Rico', 'Ledezma', '4246 Bulevar Este', 'San Lorenzo Huipulco', 'PA-5', 'RILO870712X1S', 'RILO870712MDFCDZ05', 97, 'F'),
('Omar', 'Castellanos', 'Alcántara', '5357 Calzada Oeste', 'Villa Quietud', 'CU-SC', 'CAAO921028Y3T', 'CAAO921028HDFSLL07', 100, 'M'),
('Orlando', 'Zavala', 'Peralta', '6468 Avenida Norte', 'Culhuacán CTM Canal Nacional', 'DO-22', 'ZAPO941114Z5U', 'ZAPO941114HDFVRL09', 106, 'M'),
('Óscar', 'Luna', 'Segura', '7579 Calle Sur', 'CTM Atzacoalcos', 'JM-KIN', 'LUSO860630A7V', 'LUSO860630HDFNGS02', 107, 'M'),
('Osvaldo', 'Cortés', 'Trujillo', '8680 Paseo Central', 'Avante', 'TT-CHG', 'COTO931016B9W', 'COTO931016HDFRRT04', 108, 'M'),
('Pablo', 'Marín', 'Ordóñez', '9791 Bulevar Poniente', 'Paraje San Juan', 'BB-CH', 'MAOP880802C2X', 'MAOP880802HDFRD06', 109, 'M'),
('Paloma', 'Ávila', 'Aguirre', '1802 Calzada Este', 'Villa Lázaro Cárdenas', 'LC-VIF', 'AVAP951118D4Y', 'AVAP951118MDFVGR08', 110, 'F'),
('Pamela', 'Dávila', 'Acosta', '2913 Avenida Oeste', 'El Rosedal', 'VC-KIN', 'DAAP870604E6Z', 'DAAP870604MDFVCS01', 111, 'F'),
('Patricia', 'Briones', 'Duran', '3024 Calle Norte', 'La Esperanza', 'GD-STG', 'BRDP920920F8A', 'BRDP920920MDFRNR03', 112, 'F'),
('Patricio', 'Carmona', 'Espino', '4135 Paseo Sur', 'Culhuacán CTM Sección IX-B', 'MX-JAL', 'CAEP941206G1B', 'CAEP941206HDFRMN05', 117, 'M'),
('Paula', 'Salazar', 'Lovera', '5246 Bulevar Central', 'Los Cedros', 'CL-BI', 'SALP860522H3C', 'SALP860522MDFLLV07', 120, 'F'),
('Paulina', 'Durán', 'Saucedo', '6357 Calzada Poniente', 'Santa Cecilia', 'UY-CA', 'DUSP931008I5D', 'DUSP931008MDFRNC09', 121, 'F'),
('Pedro', 'Mora', 'Amador', '7468 Avenida Este', 'Pedregal de Carrasco', 'BR-RJ', 'MOAP880724J7E', 'MOAP880724HDFRMM02', 123, 'M'),
('Penélope', 'Padilla', 'Franco', '8579 Calle Oeste', 'Campestre Coyoacán', 'CA-BC', 'PAFP951010K9F', 'PAFP951010MDFDLR04', 124, 'F'),
('Petra', 'Barrios', 'Macías', '9680 Paseo Norte', 'San Pablo Tepetlapa', 'AU-QLD', 'BAMP870626L2G', 'BAMP870626MDFRRC06', 125, 'F'),
('Pilar', 'Medrano', 'Villa', '1791 Bulevar Sur', 'Ciudad Jardín', 'NZ-WGN', 'MEVP921012M4H', 'MEVP921012MDFDLL08', 126, 'F'),
('Porfirio', 'Calderón', 'Maldonado', '2802 Calzada Central', 'Pedregal de Santa Úrsula Xitla', 'ZA-EC', 'CAMP941228N6I', 'CAMP941228HDFLLD01', 127, 'M'),
('Priscila', 'Lugo', 'Rosas', '3913 Avenida Poniente', 'Atlántida', 'EG-ALX', 'LURP860814O8J', 'LURP860814MDFLGS03', 129, 'F'),
('Quetzali', 'Olmos', 'Cano', '4024 Calle Este', 'Jalalpa Tepito', 'NG-LAG', 'OLCQ930630P1K', 'OLCQ930630MDFMNS05', 130, 'F'),
('Rafael', 'Andrade', 'Madera', '5135 Paseo Oeste', 'Pedregal de San Nicolás 3A Sección', 'KE-MSA', 'ANMR880916Q3L', 'ANMR880916HDFNDR07', 131, 'M'),
('Ramiro', 'Serna', 'Rico', '6246 Bulevar Norte', 'Pueblo de Santa Úrsula Coapa', 'FR-ARA', 'SERR951102R5M', 'SERR951102HDFNRC09', 133, 'M'),
('Ramón', 'Miranda', 'Castellanos', '7357 Calzada Sur', 'Pedregal de Carrasco Sección 3A', 'IT-MI', 'MICR870618S7N', 'MICR870618HDFRNL02', 134, 'M'),
('Raquel', 'Bonilla', 'Zavala', '8468 Avenida Central', 'Arboledas del Sur', 'DE-HH', 'BOZR921004T9O', 'BOZR921004MDFNVL04', 135, 'F'),
('Raúl', 'Arteaga', 'Luna', '9579 Calle Poniente', 'Vergel de Coyoacán', 'GB-ENG', 'ARLR941120U2P', 'ARLR941120HDFRTL06', 136, 'M'),
('Rebeca', 'Aparicio', 'Cortés', '1680 Paseo Este', 'Rinconada del Sur', 'JP-40', 'APCR860606V4Q', 'APCR860606MDFPRT08', 137, 'F'),
('Regina', 'Montoya', 'Marín', '2791 Bulevar Oeste', 'Santa Cecilia Tepetlapa', 'CN-31', 'MOMR930922W6R', 'MOMR930922MDFNTR01', 146, 'F'),
('Reinaldo', 'Lozano', 'Ávila', '3802 Calzada Norte', 'Los Reyes', 'IN-MH', 'LOAR880808X8S', 'LOAR880808HDFZVL03', 147, 'M'),
('René', 'Velasco', 'Dávila', '4913 Avenida Sur', 'San Bartolo El Chico', 'RU-SPE', 'VEDR951024Y1T', 'VEDR951024HDFLVL05', 148, 'M'),
('Ricardo', 'Alfaro', 'Briones', '5024 Calle Central', 'La Noria', 'US-TX', 'ALBR870710Z3U', 'ALBR870710HDFLRN07', 150, 'M'),
('Rigoberto', 'Paz', 'Carmona', '6135 Paseo Poniente', 'Hermosillo', 'US-FL', 'PACR921126A5V', 'PACR921126HDFZRM09', 156, 'M'),
('Rita', 'Cazares', 'Salazar', '7246 Bulevar Este', 'San Andrés Totoltepec', 'US-IL', 'CASR941012B7W', 'CASR941012MDFZLZ02', 157, 'F'),
('Roberto', 'Leal', 'Durán', '8357 Calzada Oeste', 'Miguel Hidalgo 1a Sección', 'US-AZ', 'LEDR860728C9X', 'LEDR860728HDFLRN04', 158, 'M'),
('Rocío', 'Ponce', 'Mora', '9468 Avenida Norte', 'Miguel Hidalgo 2a Sección', 'US-WA', 'POMR930814D2Y', 'POMR930814MDFNCR06', 159, 'F'),
('Rodrigo', 'Téllez', 'Padilla', '1579 Calle Sur', 'Miguel Hidalgo 3a Sección', 'CA-QC', 'TEPR881130E4Z', 'TEPR881130HDFLLD08', 160, 'M'),
('Rogelio', 'Bermúdez', 'Barrios', '2680 Paseo Central', 'Miguel Hidalgo 4a Sección', 'MX-NLE', 'BEBR951016F6A', 'BEBR951016HDFRMR01', 171, 'M'),
('Rosa', 'Guzmán', 'Medrano', '3791 Bulevar Poniente', 'Xalpa', 'CL-LI', 'GUMR870702G8B', 'GUMR870702MDFZMD03', 172, 'F'),
('Rosalía', 'Félix', 'Calderón', '4802 Calzada Este', 'La Joya', 'UY-FD', 'FECR920918H1C', 'FECR920918MDFLLD05', 173, 'F'),
('Rosario', 'Mejía', 'Lugo', '5913 Avenida Oeste', 'Lomas de Padierna', 'BR-MG', 'MELR941104I3D', 'MELR941104MDFGJG07', 175, 'F'),
('Rubén', 'Cuevas', 'Olmos', '6024 Calle Norte', 'Tepeximilpa', 'CA-AB', 'CUOR860620J5E', 'CUOR860620HDFVLM09', 176, 'M'),
('Ruth', 'Santana', 'Andrade', '7135 Paseo Sur', 'Miguel Hidalgo', 'AU-SA', 'SAAR930906K7F', 'SAAR930906MDFNND02', 177, 'F'),
('Sabrina', 'Ocampo', 'Serna', '8246 Bulevar Central', 'Pedregal de San Nicolás 1A Sección', 'NZ-NSN', 'OCOS880722L9G', 'OCOS880722MDFCMR04', 178, 'F'),
('Salvador', 'Arana', 'Miranda', '9357 Calzada Poniente', 'Pedregal de San Nicolás 2A Sección', 'ZA-JNB', 'ARMS951008M2H', 'ARMS951008HDFRNR06', 179, 'M'),
('Samuel', 'Carrasco', 'Bonilla', '1468 Avenida Este', 'Pedregal de San Nicolás 4A Sección', 'EG-SUE', 'CABS870624N4I', 'CABS870624HDFRNL08', 180, 'M'),
('Sandra', 'Gil', 'Arteaga', '2579 Calle Oeste', 'San Lorenzo Acopilco', 'NG-FC', 'GIAS921010O6J', 'GIAS921010MDFLTG01', 181, 'F'),
('Santiago', 'Orozco', 'Aparicio', '3680 Paseo Norte', 'Cultura Maya', 'KE-MBA', 'ORAS941226P8K', 'ORAS941226HDFRPR03', 183, 'M'),
('Sara', 'Vega', 'Montoya', '4791 Bulevar Sur', 'Pueblo de San Mateo Tlaltenango', 'MX-PUE', 'VEMS860812Q1L', 'VEMS860812MDFGMT05', 184, 'F'),
('Saúl', 'Macias', 'Lozano', '5802 Calzada Central', 'Torres de Padierna', 'ES-AN', 'MALS930628R3M', 'MALS930628HDFCZN07', 185, 'M'),
('Sebastián', 'Peña', 'Velasco', '6913 Avenida Poniente', 'Lomas de Cuilotepec', 'AR-K', 'PEVS880914S5N', 'PEVS880914HDFNLS09', 186, 'M'),
('Selena', 'Santillán', 'Alfaro', '7024 Calle Este', 'San Lorenzo La Cebada', 'CO-CUN', 'SAAS951130T7O', 'SAAS951130MDFTLL02', 187, 'F'),
('Sergio', 'Álvarez', 'Paz', '8135 Paseo Oeste', 'Barrio San Francisco', 'PE-ARE', 'ALPS870616U9P', 'ALPS870616HDFLVZ04', 188, 'M'),
('Silvia', 'Alvarado', 'Cazares', '9246 Bulevar Norte', 'Pueblo de Tetelpan', 'UR-RV', 'ALCS921002V2Q', 'ALCS921002MDFLVZ06', 189, 'F'),
('Simón', 'Campos', 'Leal', '1357 Calzada Sur', 'Las Águilas', 'PY-PH', 'CALS941118W4R', 'CALS941118HDFMPL08', 190, 'M'),
('Sofía', 'Rodríguez', 'Ponce', '2468 Avenida Central', 'Lomas de Guadalupe', 'BO-OR', 'ROPS860604X6S', 'ROPS860604MDFDNC01', 192, 'F'),
('Sonia', 'García', 'Téllez', '3579 Calle Poniente', 'Alcantarilla', 'EC-GUA', 'GATS930920Y8T', 'GATS930920MDFRCL03', 193, 'F'),
('Susana', 'López', 'Bermúdez', '4680 Paseo Este', 'Presidentes Ejidales', 'GT-QUE', 'LOBS880806Z1U', 'LOBS880806MDFPZR05', 194, 'F'),
('Tatiana', 'Martínez', 'Guzmán', '5791 Bulevar Oeste', 'Lomas de los Cedros', 'HN-IB', 'MAGT951122A3V', 'MAGT951122MDFRZM07', 195, 'F'),
('Teresa', 'Hernández', 'Félix', '6802 Calzada Norte', 'Ampliación Presidentes', 'SV-SO', 'HEFT870608B5W', 'HEFT870608MDFRRL09', 200, 'F'),
('Timoteo', 'Sánchez', 'Mejía', '7913 Avenida Sur', 'La Palma', 'NI-JI', 'SAMT920924C7X', 'SAMT920924HDFNJM02', 201, 'M'),
('Tomás', 'Pérez', 'Cuevas', '8024 Calle Central', 'Lomas de San Bernabé', 'CR-P', 'PECT941210D9Y', 'PECT941210HDFRCV04', 202, 'M'),
('Trinidad', 'Gutiérrez', 'Santana', '9135 Paseo Poniente', 'Lomas de Memetla', 'PA-7', 'GUST860826E2Z', 'GUST860826MDFTRN06', 203, 'F'),
('Ulises', 'Romero', 'Ocampo', '1246 Bulevar Este', 'Rinconada Las Hadas', 'CU-VC', 'ROOU930712F4A', 'ROOU930712HDFMCP08', 204, 'M'),
('Uriel', 'Álvarez', 'Arana', '2357 Calzada Oeste', 'Lomas Axomiatla', 'DO-15', 'ALAU880628G6B', 'ALAU880628HDFLRR01', 205, 'M'),
('Valentina', 'Torres', 'Carrasco', '3468 Avenida Norte', 'Ampliación Lomas de San Bernabé', 'JM-02', 'TOCV951114H8C', 'TOCV951114MDFRRR03', 206, 'F'),
('Vanesa', 'Díaz', 'Gil', '4579 Calle Sur', 'Lomas de Padierna Sur', 'TT-WTO', 'DIGV870530I1D', 'DIGV870530MDFZGL05', 207, 'F'),
('Verónica', 'Gómez', 'Orozco', '5680 Paseo Central', 'San Bartolo Ameyalco', 'BB-19', 'GOOV921016J3E', 'GOOV921016MDFMRC07', 208, 'F'),
('Vicente', 'Jiménez', 'Vega', '6791 Bulevar Poniente', 'La Estrella', 'LC-06', 'JIVV941202K5F', 'JIVV941202HDFMGV09', 209, 'M'),
('Víctor', 'Navarro', 'Macias', '7802 Calzada Este', 'Cove', 'VC-03', 'NAMV860918L7G', 'NAMV860918HDFVRC02', 210, 'M'),
('Victoria', 'Morales', 'Peña', '8913 Avenida Oeste', 'Santa Rosa Xochiac', 'GD-01', 'MOPV931004M9H', 'MOPV931004MDFRLÑ04', 216, 'F'),
('Violeta', 'Castro', 'Santillán', '9024 Calle Norte', 'Cuevitas', 'MX-QUE', 'CASV880720N2I', 'CASV880720MDFSTL06', 217, 'F'),
('Virginia', 'Vega', 'Álvarez', '1135 Paseo Sur', 'Lomas de Chamontoya', 'ES-VAL', 'VEAV951006O4J', 'VEAV951006MDFGLV08', 218, 'F'),
('Walter', 'Reyes', 'Alvarado', '2246 Bulevar Central', 'La Mexicana', 'AR-T', 'REAW870622P6K', 'REAW870622HDFYLV01', 219, 'M'),
('Wendy', 'Jiménez', 'Campos', '3357 Calzada Poniente', 'Tlacoyaque', 'CO-ANT', 'JICW920908Q8L', 'JICW920908MDFMMP03', 220, 'F'),
('Ximena', 'Herrera', 'Rodríguez', '4468 Avenida Este', 'Pueblo Nuevo Bajo', 'PE-CAL', 'HERX941124R1M', 'HERX941124MDFRRX05', 221, 'F'),
('Yahaira', 'Ortiz', 'García', '5579 Calle Oeste', 'La Cascada', 'UR-SO', 'ORGY860610S3N', 'ORGY860610MDFRTG07', 222, 'F'),
('Yanet', 'Garza', 'López', '6680 Paseo Norte', 'Olivar del Conde 1a Sección', 'PY-15', 'GALY930926T5O', 'GALY930926MDFRLP09', 223, 'F'),
('Yolanda', 'Soto', 'Martínez', '7791 Bulevar Sur', 'Olivar del Conde 2a Sección', 'BO-PT', 'SOMY881112U7P', 'SOMY881112MDFTRT02', 224, 'F'),
('Yuliana', 'Mendoza', 'Hernández', '8802 Calzada Central', 'Ampliación Alpes', 'EC-MAN', 'MEHY951028V9Q', 'MEHY951028MDFNDR04', 225, 'F'),
('Zacarías', 'Vargas', 'Sánchez', '9913 Avenida Poniente', 'Alpes', 'GT-SMA', 'VASZ870714W2R', 'VASZ870714HDFRNS06', 226, 'M'),
('Zoe', 'Silva', 'Pérez', '1024 Calle Este', 'Lomas de Becerra', 'HN-AT', 'SIPZ921030X4S', 'SIPZ921030MDFLRZ08', 227, 'F'),
('Aarón', 'Cortés', 'Gutiérrez', '2135 Paseo Oeste', 'Molino de Rosas', 'SV-LI', 'COGA941216Y6T', 'COGA941216HDFRTT01', 228, 'M'),
('Abigail', 'Aguilar', 'Romero', '3246 Bulevar Norte', 'Lomas de Plateros', 'NI-LE', 'AGRA860602Z8U', 'AGRA860602MDFGLR03', 229, 'F'),
('Abraham', 'Ponce', 'Álvarez', '4357 Calzada Sur', 'Las Águilas 1a Sección', 'CR-L', 'POAA930918A1V', 'POAA930918HDFNCL05', 230, 'M'),
('Ada', 'León', 'Torres', '5468 Avenida Central', 'Las Águilas 2a Sección', 'PA-1', 'LETA881104B3W', 'LETA881104MDFNTR07', 231, 'F'),
('Adalberto', 'Cabrera', 'Díaz', '6579 Calle Poniente', 'Las Águilas 3a Sección', 'CU-11', 'CADA951020C5X', 'CADA951020HDFBRZ09', 232, 'M'),
('Adán', 'Pacheco', 'Gómez', '7680 Paseo Este', 'Ampliación Las Águilas', 'DO-25', 'PAGA870606D7Y', 'PAGA870606HDFCHM02', 233, 'M'),
('Adelaida', 'Santos', 'Jiménez', '8791 Bulevar Oeste', 'Piloto Adolfo López Mateos', 'JM-11', 'SAJA920922E9Z', 'SAJA920922MDFTJM04', 234, 'F'),
('Adelina', 'Ríos', 'Navarro', '9802 Calzada Norte', 'Colina del Sur', 'TT-SFG', 'RIAN941108F2A', 'RIAN941108MDFSRV06', 235, 'F'),
('Adolfo', 'Delgado', 'Morales', '1913 Avenida Sur', 'Lomas de Guadalupe', 'BB-25', 'DEMA860624G4B', 'DEMA860624HDFLGR08', 236, 'M'),
('Adrián', 'Campos', 'Castro', '2024 Calle Central', 'Ampliación Piloto Adolfo López Mateos', 'LC-SOU', 'CACA931010H6C', 'CACA931010HDFMPS01', 237, 'M'),
('Adriana', 'Fuentes', 'Vega', '3135 Paseo Poniente', 'Lomas de las Águilas', 'VC-GEO', 'FUVA880826I8D', 'FUVA880826MDFNTG03', 238, 'F'),
('Agustín', 'Salinas', 'Reyes', '4246 Bulevar Este', 'Presidentes', 'GD-GRE', 'SARA951112J1E', 'SARA951112HDFLLY05', 239, 'M'),
('Aída', 'Guevara', 'Jiménez', '5357 Calzada Oeste', 'Atlamaya', 'AG-CAL', 'GUJA870628K3F', 'GUJA870628MDFVJM07', 240, 'F'),
('Aimé', 'Lara', 'Herrera', '6468 Avenida Norte', 'Plateros', 'BC-MXL', 'LAHA920914L5G', 'LAHA920914MDFRRR09', 241, 'F'),
('Alba', 'Miranda', 'Ortiz', '7579 Calle Sur', 'Flor de María', 'BCS-SJC', 'MIOA941130M7H', 'MIOA941130MDFRRT02', 244, 'F'),
('Alberto', 'Carrillo', 'Garza', '8680 Paseo Central', 'Cruz Manca', 'CAMP-ESC', 'CAGA860616N9I', 'CAGA860616HDFRRZ04', 245, 'M'),
('Alejandra', 'Paredes', 'Soto', '9791 Bulevar Poniente', 'Tlacoquemécatl', 'CHIS-COM', 'PASA931002O2J', 'PASA931002MDFRDST06', 246, 'F'),
('Alejandro', 'Marín', 'Mendoza', '1802 Calzada Este', 'Insurgentes San Borja', 'CHIH-CUU', 'MAMA880818P4K', 'MAMA880818HDFRNM08', 247, 'M'),
('Alejo', 'Estrada', 'Vargas', '2913 Avenida Oeste', 'Nápoles', 'COAH-MON', 'ESVA951104Q6L', 'ESVA951104HDFSTV01', 248, 'M'),
('Alessandra', 'Ibáñez', 'Silva', '3024 Calle Norte', 'Del Valle Centro', 'COL-TEC', 'IBSA870620R8M', 'IBSA870620MDFBNS03', 249, 'F'),
('Alex', 'Cárdenas', 'Cortés', '4135 Paseo Sur', 'Del Valle Norte', 'DGO-VIC', 'CACA920906S1N', 'CACA920906HDFRD05', 250, 'M'),
('Alexander', 'Gallegos', 'Aguilar', '5246 Bulevar Central', 'Del Valle Sur', 'GTO-GUA', 'GAAA941122T3O', 'GAAA941122HDFGGL07', 251, 'M'),
('Alexandra', 'Montes', 'Ponce', '6357 Calzada Poniente', 'Portales Norte', 'HGO-TUL', 'MOPA860608U5P', 'MOPA860608MDFNTP09', 252, 'F'),
('Alexis', 'Figueroa', 'León', '7468 Avenida Este', 'Portales Sur', 'JAL-TLA', 'FILA931024V7Q', 'FILA931024HDFGLN02', 253, 'M'),
('Alfonso', 'Ochoa', 'Cabrera', '8579 Calle Oeste', 'Portales Oriente', 'MEX-NCA', 'OCCA880810W9R', 'OCCA880810HDFHCB04', 254, 'M'),
('Alfredo', 'Sandoval', 'Pacheco', '9680 Paseo Norte', 'Algarín', 'MICH-URU', 'SAPA951126X2S', 'SAPA951126HDFNCP06', 255, 'M'),
('Alicia', 'Maldonado', 'Santos', '1791 Bulevar Sur', 'Ampliación Nápoles', 'MOR-JUT', 'MASA870712Y4T', 'MASA870712MDFLTS08', 256, 'F'),
('Alina', 'Navarro', 'Ríos', '2802 Calzada Central', 'Atenor Salas', 'NAY-XAL', 'NARA920928Z6U', 'NARA920928MDFVRS01', 259, 'F'),
('Alma', 'Peña', 'Delgado', '3913 Avenida Poniente', 'Américas Unidas', 'NLE-GAR', 'PEDA941214A8V', 'PEDA941214MDFNDL03', 260, 'F'),
('Almendra', 'Escobar', 'Campos', '4024 Calle Este', 'Letrán Valle', 'OAX-SLU', 'ESCA860630B1W', 'ESCA860630MDFSCM05', 261, 'F'),
('Alonso', 'Velázquez', 'Fuentes', '5135 Paseo Oeste', 'Niños Héroes', 'PUE-AJA', 'VEFA930916C3X', 'VEFA930916HDFLZF07', 262, 'M'),
('Alondra', 'Villanueva', 'Salinas', '6246 Bulevar Norte', 'Xoco', 'QRO-JLP', 'VISA881102D5Y', 'VISA881102MDFLLS09', 263, 'F'),
('Alvaro', 'Contreras', 'Guevara', '7357 Calzada Sur', 'Santa Cruz Atoyac', 'QROO-FCP', 'COGA951018E7Z', 'COGA951018HDFNTV02', 266, 'M'),
('Amado', 'Rojas', 'Lara', '8468 Avenida Central', 'Coyuya', 'SLP-CRD', 'ROLA870704F9A', 'ROLA870704HDFJLR04', 269, 'M'),
('Amalia', 'Moreno', 'Miranda', '9579 Calle Poniente', 'Parque San Andrés', 'SIN-LMO', 'MOMA921020G2B', 'MOMA921020MDFRRD06', 271, 'F'),
('Amanda', 'Zamora', 'Carrillo', '1680 Paseo Este', 'San Simón Ticumac', 'SON-NAI', 'ZACA941206H4C', 'ZACA941206MDFMRC08', 272, 'F'),
('Amara', 'Vázquez', 'Paredes', '2791 Bulevar Oeste', 'Los Cipreses', 'TAB-TAB', 'VAPA860622I6D', 'VAPA860622MDFZRD01', 273, 'F'),
('Amelia', 'Blanco', 'Marín', '3802 Calzada Norte', 'Moderna', 'TAMS-MPE', 'BLMA931008J8E', 'BLMA931008MDFLNR03', 274, 'F'),
('América', 'Torres', 'Estrada', '4913 Avenida Sur', 'San José Insurgentes', 'TLAX-APZ', 'TOEA880824K1F', 'TOEA880824MDFRTD05', 275, 'F'),
('Amílcar', 'Guerrero', 'Ibáñez', '5024 Calle Central', 'Piedad Narvarte', 'VER-BAN', 'GUIA951110L3G', 'GUIA951110HDFRRB07', 276, 'M'),
('Amparo', 'Rivas', 'Cárdenas', '6135 Paseo Poniente', 'Narvarte Oriente', 'YUC-VAL', 'RICA870626M5H', 'RICA870626MDFVRD09', 277, 'F'),
('Ana', 'Coronado', 'Gallegos', '7246 Bulevar Este', 'Narvarte Poniente', 'ZAC-SOM', 'COGA920912N7I', 'COGA920912MDFRLG02', 278, 'F'),
('Anabel', 'Duarte', 'Montes', '8357 Calzada Oeste', 'Vértiz Narvarte', 'MX-CMX', 'DUMA941128O9J', 'DUMA941128MDFRTT04', 279, 'F'),
('Anahí', 'Trejo', 'Figueroa', '9468 Avenida Norte', 'General Anaya', 'ES-MD', 'TRFA860614P2K', 'TRFA860614MDFRGF06', 280, 'F'),
('Anastasia', 'Suárez', 'Ochoa', '1579 Calle Sur', 'La Perla', 'AR-B', 'SUOA931030Q4L', 'SUOA931030MDFZCH08', 281, 'F'),
('Anderson', 'Nava', 'Sandoval', '2680 Paseo Central', 'Postal', 'CO-DC', 'NASA880916R6M', 'NASA880916HDFVSD01', 282, 'M'),
('Andrés', 'Méndez', 'Maldonado', '3791 Bulevar Poniente', 'Merced Gómez', 'PE-LIM', 'MEMA951102S8N', 'MEMA951102HDFNDM03', 283, 'M'),
('Ángel', 'Olvera', 'Navarro', '4802 Calzada Este', 'Militar Marte', 'BR-SP', 'OLON870618T1O', 'OLON870618HDFLVN05', 284, 'M'),
('Ángela', 'Arias', 'Peña', '5913 Avenida Oeste', 'Actipan', 'CA-ON', 'ARPA921004U3P', 'ARPA921004MDFRSP07', 285, 'F'),
('Angélica', 'Barrera', 'Escobar', '6024 Calle Norte', 'Del Carmen', 'AU-VIC', 'BAEE941120V5Q', 'BAEE941120MDFRRSC09', 286, 'F'),
('Angélico', 'Cordero', 'Velázquez', '7135 Paseo Sur', 'Campestre Churubusco', 'NZ-AUK', 'COVA860606W7R', 'COVA860606HDFRDL02', 287, 'M'),
('Aníbal', 'Galván', 'Villanueva', '8246 Bulevar Central', 'Country Club Churubusco', 'ZA-GT', 'GAVA931022X9S', 'GAVA931022HDFLVL04', 288, 'M'),
('Anita', 'Prieto', 'Contreras', '9357 Calzada Poniente', 'Los Reyes Coyoacán', 'EG-C', 'PRCA880808Y2T', 'PRCA880808MDFRTC06', 289, 'F'),
('Anselmo', 'Ugalde', 'Rojas', '1468 Avenida Este', 'Villa Coyoacán', 'NG-LA', 'UGRR951124Z4U', 'UGRR951124HDFGLR08', 290, 'M'),
('Antonia', 'Hurtado', 'Moreno', '2579 Calle Oeste', 'Educación', 'KE-NBO', 'HUMA870610A6V', 'HUMA870610MDFRTM01', 291, 'F'),
('Antonio', 'Santillán', 'Zamora', '3680 Paseo Norte', 'Churubusco Country Club', 'MX-GRO', 'SAZA920926B8W', 'SAZA920926HDFTLM03', 292, 'M'),
('Apolinar', 'Salas', 'Vázquez', '4791 Bulevar Sur', 'Avante Coyoacán', 'ES-CAT', 'SAVA941212C1X', 'SAVA941212HDFLVZ05', 293, 'M'),
('Araceli', 'Solís', 'Blanco', '5802 Calzada Central', 'Prado Churubusco', 'AR-X', 'SOBA860628D3Y', 'SOBA860628MDFLLB07', 294, 'F'),
('Aracely', 'Luna', 'Torres', '6913 Avenida Poniente', 'Carmen Serdán', 'CO-VAC', 'LUTA931014E5Z', 'LUTA931014MDFNRT09', 295, 'F'),
('Arantxa', 'Cervantes', 'Guerrero', '7024 Calle Este', 'San Francisco Culhuacán Barrio de Santa Ana', 'PE-PIU', 'CEGA880830F7A', 'CEGA880830MDFRVG02', 296, 'F'),
('Arcadio', 'Camacho', 'Rivas', '8135 Paseo Oeste', 'San Francisco Culhuacán Barrio de San Juan', 'UY-MON', 'CARA951116G9B', 'CARA951116HDFMRV04', 297, 'M'),
('Ariadna', 'Godínez', 'Coronado', '9246 Bulevar Norte', 'San Francisco Culhuacán Barrio de La Magdalena', 'PY-ASU', 'GOCA870702H2C', 'GOCA870702MDFNRC06', 298, 'F'),
('Ariel', 'Ayala', 'Duarte', '1357 Calzada Sur', 'Campestre San Juan', 'BO-SC', 'AYDA921018I4D', 'AYDA921018HDFYLT08', 299, 'M'),
('Arleth', 'Bravo', 'Trejo', '2468 Avenida Central', 'CTM Culhuacán', 'EC-P', 'BRAT941204J6E', 'BRAT941204MDFRVT01', 300, 'F');


INSERT INTO gestion_hotel."AUTOS" (matricula, modelo, id_clientes) VALUES
('9847245401', 'Skylark', 1),
('7572199518', 'S-Class', 2),
('2076047409', 'Voyager', 3),
('1105809773', 'Sorento', 4),
('6796702921', 'Golf', 5),
('5636055315', 'Elise', 6),
('6387229588', 'RS4', 7),
('2118138148', '5 Series', 8),
('1567085725', '928', 9),
('3061282610', 'Charger', 10),
('6617883608', 'Cougar', 11),
('1366231007', 'Quest', 12),
('1140080237', 'Mulsanne', 13),
('5117376145', 'Santa Fe', 14),
('6687681311', 'Forester', 15),
('4564995855', 'Aurora', 16),
('7563513264', 'Civic', 17),
('1644993112', 'Suburban 1500', 18),
('8678348224', 'Corolla', 19),
('4298407020', 'Avalon', 20),
('7653994792', 'Intrepid', 21),
('2317583893', 'TSX', 22),
('2590333226', 'Cooper Clubman', 23),
('5570427848', 'TT', 24),
('9902641202', 'Murciélago', 25),
('3126830870', 'Festiva', 26),
('5195184569', 'Range Rover Evoque', 27),
('5359381256', 'Escalade ESV', 28),
('7870732885', 'Grand Prix', 29),
('4889572570', 'Fox', 30),
('7529777432', 'Aveo', 31),
('3887530403', 'Arnage', 32),
('2908290219', 'Diablo', 33),
('0512072957', 'Sierra 3500', 34),
('0546335233', 'PT Cruiser', 35),
('4903841596', 'Mark VIII', 36),
('2784214397', 'X3', 37),
('9867242378', 'Mountaineer', 38),
('2500668819', 'Z3', 39),
('7878116865', 'i-280', 40),
('7236968870', 'Sunbird', 41),
('6234421229', 'CTS', 42),
('0183611187', 'A4', 43),
('2084952026', 'Regal', 44),
('1157968945', 'Legacy', 45),
('9215749985', 'Terrain', 46),
('4478226814', 'Avalon', 47),
('5586725401', 'Quest', 48),
('5657980271', 'Sparrow', 49),
('1968844732', 'Fusion', 50),
('3961585229', 'MPV', 51),
('6038723579', 'Ram 1500', 52),
('1582188262', 'TL', 53),
('3256460968', 'Jetta', 54),
('8449808235', 'Grand Cherokee', 55),
('7075154923', 'riolet', 56),
('3936198721', 'Town & Country', 57),
('2850858722', 'RS6', 58),
('6707131052', 'tC', 59),
('0636522350', 'Range Rover', 60),
('0870159119', '2500', 61),
('7999122890', 'SLK-Class', 62),
('8233423629', 'Colorado', 63),
('9854369099', 'Sunfire', 64),
('2469334829', 'Vandura 3500', 65),
('8287144728', 'Elantra', 66),
('5231078093', 'Jimmy', 67),
('5564951913', 'Cirrus', 68),
('9681667727', 'Park Avenue', 69),
('0648117790', 'Rainier', 70),
('6910248473', 'Swift', 71),
('2089432055', 'Explorer', 72),
('6039841028', 'Discovery', 73),
('2538376823', 'M5', 74),
('9836176128', 'Spectra', 75),
('0957045905', 'Eldorado', 76),
('7058938091', 'B2600', 77),
('9973141881', 'Sentra', 78),
('6487562742', 'Magnum', 79),
('5838412224', 'Tucson', 80),
('5410709497', 'Justy', 81),
('1513461540', 'Entourage', 82),
('8664075050', 'Regal', 83),
('6972368944', 'Soul', 84),
('5875916540', 'CTS', 85),
('7709002978', 'Forester', 86),
('1271152150', 'RL', 87),
('1355784603', 'E-Class', 88),
('8451543340', 'Escalade EXT', 89),
('5866475898', '3500', 90),
('5895613144', 'Defender 110', 91),
('3025049022', 'RX-7', 92),
('8680582298', 'Flex', 93),
('6675755153', 'V8 Vantage S', 94),
('5384145781', 'Miata MX-5', 95),
('9228109106', 'QX', 96),
('8075132661', 'Discovery', 97),
('5643118696', 'C-Class', 98),
('1823866115', 'RX Hybrid', 99),
('2148393316', 'Intrigue', 100),
('2688142577', 'Skyhawk', 101),
('6465061627', 'Aspen', 102),
('7751799536', 'Rabbit', 103),
('4576599194', 'Neon', 104),
('3129757961', 'Town & Country', 105),
('6456119960', 'Golf', 106),
('4957366322', 'Versa', 107),
('2007590190', 'RX', 108),
('0445094591', 'LeSabre', 109),
('5786573737', 'Savana 2500', 110),
('2656582547', 'Passport', 111),
('6595156849', 'Tredia', 112),
('3888003296', 'E250', 113),
('1697745369', 'Ram Van 2500', 114),
('3383708535', 'Exige', 115),
('2670312241', 'A8', 116),
('2653882558', '300ZX', 117),
('0839048181', 'IS', 118),
('7446333111', 'RL', 119),
('4638844375', 'Avalon', 120),
('7869618586', 'Dakota', 121),
('9787200121', 'Laser', 122),
('3893272232', 'Grand Vitara', 123),
('6492075110', 'Explorer Sport Trac', 124),
('8595035148', 'Corvette', 125),
('5533802908', 'X3', 126),
('5920916583', 'Fiesta', 127),
('7784798423', 'Acadia', 128),
('0676067697', '2500 Club Coupe', 129),
('0059103728', 'Avalon', 130),
('8460464326', 'Cayenne', 131),
('5863039787', 'MPV', 132),
('7145131285', '300ZX', 133),
('2247463053', 'Tracer', 134),
('3518253859', 'A8', 135),
('2486307257', 'Continental', 136),
('7487184986', 'Millenia', 137),
('1731832117', 'SL-Class', 138),
('6821223297', 'S10', 139),
('2252659947', 'Yaris', 140),
('9349836831', 'Blazer', 141),
('1296942694', 'Ram Wagon B350', 142),
('5458249526', 'Highlander', 143),
('4535690359', 'Express 1500', 144),
('2044485273', 'XLR', 145),
('5306883192', 'Interceptor', 146),
('4807347861', '430', 147),
('1390624463', 'Ram Van 3500', 148),
('1528336631', 'Supra', 149),
('9375063895', 'Phantom', 150),
('0569668034', 'XC70', 151),
('8081995951', 'Eldorado', 152),
('5461178480', 'Regal', 153),
('9026508980', 'Silverado 3500', 154),
('4001004445', 'B-Series', 155),
('5936035697', 'Golf III', 156),
('3805146639', '62', 157),
('9166087783', 'Sierra 2500', 158),
('1438664826', 'Century', 159),
('6300021114', 'F-Series', 160),
('3322757218', 'Intrigue', 161),
('4736192178', 'Ram', 162),
('6754495472', 'Accent', 163),
('1565829638', 'F430', 164),
('4521057322', 'M3', 165),
('5223890124', 'Bronco', 166),
('4915441016', '911', 167),
('9498874549', 'Land Cruiser', 168),
('5758413585', 'Focus', 169),
('2552342353', 'Town & Country', 170),
('7702219459', 'Rodeo Sport', 171),
('1096908247', 'Sierra 3500', 172),
('8561986336', 'Trans Sport', 173),
('0039655857', 'D350', 174),
('9370444564', '7 Series', 175),
('6790672818', 'LR2', 176),
('1673263801', 'ES', 177),
('2103377060', 'C-Class', 178),
('7061090596', 'Pathfinder', 179),
('2097074685', 'Tacoma Xtra', 180),
('3545853489', 'E150', 181),
('6172151290', 'Continental Mark VII', 182),
('9860027358', 'Continental Flying Spur', 183),
('7718465713', 'Cruze', 184),
('3753125377', 'Ram 3500', 185),
('8034911623', '9-5', 186),
('9207064227', 'G3', 187),
('5824449082', 'New Beetle', 188),
('0773470441', 'Bravada', 189),
('6219270703', 'Freestyle', 190),
('8399087238', '599 GTB Fiorano', 191),
('9843994647', 'MGB', 192),
('2941936866', 'Maxima', 193),
('5127409232', 'Grand Caravan', 194),
('1011219522', 'Ridgeline', 195),
('8735492767', 'Dakota Club', 196),
('8739979954', 'Tribeca', 197),
('7121070383', 'M-Class', 198),
('8021217251', 'Edge', 199),
('1422020789', 'Liberty', 200),
('0566191679', 'Escape', 201),
('6232772881', 'Amanti', 202),
('3405771552', 'Endeavor', 203),
('5853584189', 'Corvette', 204),
('7018731674', 'Samurai', 205),
('6600147539', 'Intrigue', 206),
('7487822664', 'Impala', 207),
('3841618413', 'Silverado 3500', 208),
('6911274834', 'Explorer Sport', 209),
('4601899818', 'Express 3500', 210),
('9835226806', 'Silverado 2500', 211),
('0807072354', 'Tempest', 212),
('4129026585', 'Prius', 213),
('7489588464', 'Bonneville', 214),
('1510240810', 'FJ Cruiser', 215),
('4845941155', 'Tahoe', 216),
('9737367057', 'Firefly', 217),
('9942310649', 'Avalon', 218),
('7688573106', 'S60', 219),
('6946025237', 'TSX', 220),
('1415314721', 'Eldorado', 221),
('1787537927', 'Odyssey', 222),
('6834375708', 'Intrepid', 223),
('8974458772', 'Esprit', 224),
('2269944895', 'Camaro', 225),
('1491299207', 'Crossfire Roadster', 226),
('8268747315', '2500', 227),
('7874375246', 'i-370', 228),
('4768442692', 'Amigo', 229),
('4725178349', 'Elantra', 230),
('0525435549', 'Sebring', 231),
('3734794722', 'Avalon', 232),
('8447270114', '458 Italia', 233),
('8268342870', 'Truck', 234),
('1927126495', 'Rio', 235),
('0993027644', 'Aerostar', 236),
('7250459503', 'CL-Class', 237),
('0426096924', 'Equinox', 238),
('5475499357', 'GS', 239),
('8359108048', 'New Beetle', 240),
('8985187929', 'Galaxie', 241),
('5582753311', 'Jetta', 242),
('4362012095', 'V50', 243),
('3441596420', 'Avalanche', 244),
('3343308951', 'Corvette', 245),
('3568335654', 'Savana 2500', 246),
('6178304544', '525', 247),
('8664619859', 'Pilot', 248),
('4384299443', 'Sprinter', 249),
('5975330165', 'Land Cruiser', 250);

--
-- TOC entry 5423 (class 0 OID 40996)
-- Dependencies: 222
-- Data for Name: CARGO_ESTACIONAMIENTO; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--
INSERT INTO gestion_hotel."CARGO_ESTACIONAMIENTO" (id_estacionamiento, matricula, fecha_entrada, fecha_salida) VALUES
(1, '9847245401', '19/7/2025', '16/10/2024'),
(2, '7572199518', '9/11/2024', '11/11/2024'),
(3, '2076047409', '16/9/2025', '13/6/2025'),
(4, '1105809773', '17/9/2025', '10/3/2025'),
(5, '6796702921', '23/11/2024', '11/5/2025'),
(6, '5636055315', '11/4/2025', '24/1/2025'),
(7, '6387229588', '24/12/2024', '24/11/2024'),
(8, '2118138148', '14/10/2024', '19/8/2025'),
(9, '1567085725', '12/1/2025', '13/12/2024'),
(10, '3061282610', '17/10/2024', '19/5/2025'),
(11, '6617883608', '29/11/2024', '21/5/2025'),
(12, '1366231007', '30/8/2025', '23/8/2025'),
(13, '1140080237', '22/10/2024', '5/7/2025'),
(14, '5117376145', '18/1/2025', '19/11/2024'),
(15, '6687681311', '2/3/2025', '19/8/2025'),
(16, '4564995855', '29/5/2025', '25/3/2025'),
(17, '7563513264', '24/10/2024', '21/6/2025'),
(18, '1644993112', '22/6/2025', '18/4/2025'),
(19, '8678348224', '23/6/2025', '19/4/2025'),
(20, '4298407020', '4/2/2025', '15/3/2025'),
(21, '7653994792', '10/4/2025', '16/7/2025'),
(22, '2317583893', '29/9/2024', '10/2/2025'),
(23, '2590333226', '22/4/2025', '19/6/2025'),
(24, '5570427848', '27/9/2025', '26/1/2025'),
(25, '9902641202', '13/12/2024', '30/1/2025'),
(26, '3126830870', '23/3/2025', '17/8/2025'),
(27, '5195184569', '31/1/2025', '28/10/2024'),
(28, '5359381256', '10/1/2025', '1/6/2025'),
(29, '7870732885', '1/1/2025', '20/5/2025'),
(30, '4889572570', '19/11/2024', '3/1/2025'),
(31, '7529777432', '12/10/2024', '16/1/2025'),
(32, '3887530403', '1/12/2024', '24/6/2025'),
(33, '2908290219', '29/11/2024', '16/4/2025'),
(34, '0512072957', '2/2/2025', '20/3/2025'),
(35, '0546335233', '22/2/2025', '7/8/2025'),
(36, '4903841596', '26/7/2025', '12/4/2025'),
(37, '2784214397', '13/2/2025', '4/5/2025'),
(38, '9867242378', '15/3/2025', '19/3/2025'),
(39, '2500668819', '4/2/2025', '15/5/2025'),
(40, '7878116865', '17/9/2025', '10/3/2025'),
(41, '7236968870', '24/10/2024', '26/1/2025'),
(42, '6234421229', '4/4/2025', '26/12/2024'),
(43, '0183611187', '27/2/2025', '1/5/2025'),
(44, '2084952026', '4/5/2025', '12/12/2024'),
(45, '1157968945', '19/11/2024', '3/3/2025'),
(46, '9215749985', '9/2/2025', '13/4/2025'),
(47, '4478226814', '13/10/2024', '18/2/2025'),
(48, '5586725401', '27/3/2025', '17/2/2025'),
(49, '5657980271', '29/11/2024', '22/6/2025'),
(50, '1968844732', '21/4/2025', '6/10/2024'),
(51, '3961585229', '28/11/2024', '19/1/2025'),
(52, '6038723579', '9/9/2025', '14/8/2025'),
(53, '1582188262', '6/7/2025', '22/4/2025'),
(54, '3256460968', '29/10/2024', '20/3/2025'),
(55, '8449808235', '4/10/2024', '6/5/2025'),
(56, '7075154923', '14/5/2025', '15/6/2025'),
(57, '3936198721', '16/12/2024', '30/8/2025'),
(58, '2850858722', '5/7/2025', '21/6/2025'),
(59, '6707131052', '29/6/2025', '4/9/2025'),
(60, '0636522350', '7/10/2024', '16/3/2025'),
(61, '0870159119', '7/11/2024', '7/5/2025'),
(62, '7999122890', '27/7/2025', '18/4/2025'),
(63, '8233423629', '2/9/2025', '8/4/2025'),
(64, '9854369099', '31/1/2025', '9/11/2024'),
(65, '2469334829', '25/9/2025', '28/6/2025'),
(66, '8287144728', '29/5/2025', '7/10/2024'),
(67, '5231078093', '13/3/2025', '12/5/2025'),
(68, '5564951913', '28/2/2025', '24/9/2025'),
(69, '9681667727', '4/8/2025', '2/12/2024'),
(70, '0648117790', '10/6/2025', '21/10/2024'),
(71, '6910248473', '3/2/2025', '16/5/2025'),
(72, '2089432055', '15/1/2025', '25/8/2025'),
(73, '6039841028', '15/8/2025', '2/2/2025'),
(74, '2538376823', '16/8/2025', '28/11/2024'),
(75, '9836176128', '12/2/2025', '2/4/2025'),
(76, '0957045905', '8/2/2025', '19/5/2025'),
(77, '7058938091', '14/8/2025', '22/1/2025'),
(78, '9973141881', '22/12/2024', '15/6/2025'),
(79, '6487562742', '12/12/2024', '2/8/2025'),
(80, '5838412224', '27/5/2025', '7/12/2024'),
(81, '5410709497', '23/6/2025', '5/4/2025'),
(82, '1513461540', '17/2/2025', '23/9/2025'),
(83, '8664075050', '11/7/2025', '14/7/2025'),
(84, '6972368944', '10/7/2025', '26/10/2024'),
(85, '5875916540', '11/6/2025', '8/6/2025'),
(86, '7709002978', '15/1/2025', '4/12/2024'),
(87, '1271152150', '28/11/2024', '16/3/2025'),
(88, '1355784603', '19/4/2025', '24/4/2025'),
(89, '8451543340', '9/1/2025', '18/9/2025'),
(90, '5866475898', '23/9/2025', '30/8/2025'),
(91, '5895613144', '23/10/2024', '1/11/2024'),
(92, '3025049022', '30/12/2024', '16/11/2024'),
(93, '8680582298', '3/4/2025', '11/3/2025'),
(94, '6675755153', '22/12/2024', '28/5/2025'),
(95, '5384145781', '29/8/2025', '17/4/2025'),
(96, '9228109106', '6/1/2025', '7/4/2025'),
(97, '8075132661', '24/6/2025', '7/2/2025'),
(98, '5643118696', '26/9/2025', '24/5/2025'),
(99, '1823866115', '9/10/2024', '25/3/2025'),
(100, '2148393316', '13/3/2025', '20/9/2025'),
(101, '2688142577', '25/5/2025', '6/10/2024'),
(102, '6465061627', '9/7/2025', '26/10/2024'),
(103, '7751799536', '12/4/2025', '2/6/2025'),
(104, '4576599194', '5/5/2025', '14/5/2025'),
(105, '3129757961', '20/2/2025', '25/10/2024'),
(106, '6456119960', '26/5/2025', '15/4/2025'),
(107, '4957366322', '28/3/2025', '4/11/2024'),
(108, '2007590190', '8/8/2025', '16/5/2025'),
(109, '0445094591', '12/6/2025', '6/12/2024'),
(110, '5786573737', '17/5/2025', '8/4/2025'),
(111, '2656582547', '29/1/2025', '11/4/2025'),
(112, '6595156849', '26/10/2024', '7/5/2025'),
(113, '3888003296', '10/11/2024', '26/10/2024'),
(114, '1697745369', '13/8/2025', '6/11/2024'),
(115, '3383708535', '27/4/2025', '7/11/2024'),
(116, '2670312241', '27/1/2025', '1/8/2025'),
(117, '2653882558', '11/12/2024', '5/11/2024'),
(118, '0839048181', '2/6/2025', '7/5/2025'),
(119, '7446333111', '16/1/2025', '14/3/2025'),
(120, '4638844375', '5/8/2025', '24/11/2024'),
(121, '7869618586', '18/5/2025', '21/3/2025'),
(122, '9787200121', '2/10/2024', '10/5/2025'),
(123, '3893272232', '27/11/2024', '15/10/2024'),
(124, '6492075110', '16/9/2025', '17/4/2025'),
(125, '8595035148', '4/1/2025', '11/9/2025'),
(126, '5533802908', '12/12/2024', '8/12/2024'),
(127, '5920916583', '18/12/2024', '24/11/2024'),
(128, '7784798423', '8/8/2025', '30/12/2024'),
(129, '0676067697', '30/4/2025', '25/4/2025'),
(130, '0059103728', '16/11/2024', '24/10/2024'),
(131, '8460464326', '17/6/2025', '19/1/2025'),
(132, '5863039787', '26/5/2025', '14/6/2025'),
(133, '7145131285', '30/5/2025', '21/7/2025'),
(134, '2247463053', '16/7/2025', '3/2/2025'),
(135, '3518253859', '21/7/2025', '18/8/2025'),
(136, '2486307257', '1/2/2025', '19/11/2024'),
(137, '7487184986', '14/2/2025', '21/11/2024'),
(138, '1731832117', '9/12/2024', '19/6/2025'),
(139, '6821223297', '17/7/2025', '13/5/2025'),
(140, '2252659947', '1/4/2025', '23/3/2025'),
(141, '9349836831', '14/1/2025', '27/9/2025'),
(142, '1296942694', '10/5/2025', '30/6/2025'),
(143, '5458249526', '29/5/2025', '18/7/2025'),
(144, '4535690359', '2/7/2025', '30/9/2024'),
(145, '2044485273', '19/7/2025', '1/10/2024'),
(146, '5306883192', '11/10/2024', '14/9/2025'),
(147, '4807347861', '28/10/2024', '27/8/2025'),
(148, '1390624463', '7/2/2025', '24/2/2025'),
(149, '1528336631', '22/4/2025', '28/3/2025'),
(150, '9375063895', '26/6/2025', '21/6/2025'),
(151, '0569668034', '27/1/2025', '19/4/2025'),
(152, '8081995951', '14/4/2025', '10/4/2025'),
(153, '5461178480', '30/9/2024', '26/9/2025'),
(154, '9026508980', '19/8/2025', '28/4/2025'),
(155, '4001004445', '25/3/2025', '12/3/2025'),
(156, '5936035697', '30/4/2025', '27/2/2025'),
(157, '3805146639', '4/9/2025', '19/12/2024'),
(158, '9166087783', '4/11/2024', '12/12/2024'),
(159, '1438664826', '11/4/2025', '25/2/2025'),
(160, '6300021114', '6/9/2025', '30/1/2025'),
(161, '3322757218', '1/5/2025', '25/11/2024'),
(162, '4736192178', '5/6/2025', '5/5/2025'),
(163, '6754495472', '23/9/2025', '16/7/2025'),
(164, '1565829638', '6/2/2025', '7/6/2025'),
(165, '4521057322', '8/2/2025', '5/9/2025'),
(166, '5223890124', '19/3/2025', '26/5/2025'),
(167, '4915441016', '20/9/2025', '24/9/2025'),
(168, '9498874549', '11/1/2025', '27/12/2024'),
(169, '5758413585', '1/3/2025', '4/8/2025'),
(170, '2552342353', '27/11/2024', '28/3/2025'),
(171, '7702219459', '13/7/2025', '18/12/2024'),
(172, '1096908247', '25/6/2025', '21/2/2025'),
(173, '8561986336', '11/1/2025', '8/10/2024'),
(174, '0039655857', '3/10/2024', '31/5/2025'),
(175, '9370444564', '10/1/2025', '25/1/2025'),
(176, '6790672818', '24/9/2025', '3/8/2025'),
(177, '1673263801', '3/1/2025', '25/1/2025'),
(178, '2103377060', '16/2/2025', '11/2/2025'),
(179, '7061090596', '25/6/2025', '16/3/2025'),
(180, '2097074685', '31/3/2025', '3/3/2025'),
(181, '3545853489', '17/9/2025', '2/1/2025'),
(182, '6172151290', '25/9/2025', '19/2/2025'),
(183, '9860027358', '27/12/2024', '23/8/2025'),
(184, '7718465713', '14/8/2025', '22/7/2025'),
(185, '3753125377', '12/9/2025', '29/3/2025'),
(186, '8034911623', '5/6/2025', '5/3/2025'),
(187, '9207064227', '15/10/2024', '11/1/2025'),
(188, '5824449082', '21/5/2025', '19/6/2025'),
(189, '0773470441', '24/1/2025', '19/7/2025'),
(190, '6219270703', '6/8/2025', '13/6/2025'),
(191, '8399087238', '2/11/2024', '5/7/2025'),
(192, '9843994647', '24/3/2025', '8/11/2024'),
(193, '2941936866', '9/5/2025', '21/4/2025'),
(194, '5127409232', '30/9/2024', '6/10/2024'),
(195, '1011219522', '1/5/2025', '5/8/2025'),
(196, '8735492767', '10/1/2025', '2/12/2024'),
(197, '8739979954', '8/4/2025', '11/4/2025'),
(198, '7121070383', '11/9/2025', '18/8/2025'),
(199, '8021217251', '26/5/2025', '14/11/2024'),
(200, '1422020789', '13/10/2024', '13/4/2025'),
(201, '0566191679', '28/6/2025', '6/7/2025'),
(202, '6232772881', '15/6/2025', '12/7/2025'),
(203, '3405771552', '6/1/2025', '10/3/2025'),
(204, '5853584189', '3/5/2025', '3/12/2024'),
(205, '7018731674', '9/12/2024', '10/5/2025'),
(206, '6600147539', '2/11/2024', '1/4/2025'),
(207, '7487822664', '29/9/2024', '2/4/2025'),
(208, '3841618413', '21/8/2025', '8/8/2025'),
(209, '6911274834', '9/7/2025', '20/9/2025'),
(210, '4601899818', '13/4/2025', '15/11/2024'),
(211, '9835226806', '31/5/2025', '27/7/2025'),
(212, '0807072354', '28/5/2025', '18/4/2025'),
(213, '4129026585', '14/12/2024', '30/8/2025'),
(214, '7489588464', '29/5/2025', '28/7/2025'),
(215, '1510240810', '27/5/2025', '21/2/2025'),
(216, '4845941155', '18/3/2025', '18/3/2025'),
(217, '9737367057', '1/11/2024', '29/7/2025'),
(218, '9942310649', '24/11/2024', '1/1/2025'),
(219, '7688573106', '23/11/2024', '2/12/2024'),
(220, '6946025237', '17/4/2025', '19/9/2025'),
(221, '1415314721', '11/11/2024', '21/10/2024'),
(222, '1787537927', '19/5/2025', '30/1/2025'),
(223, '6834375708', '27/5/2025', '30/10/2024'),
(224, '8974458772', '3/7/2025', '15/5/2025'),
(225, '2269944895', '22/12/2024', '25/9/2025'),
(226, '1491299207', '18/5/2025', '28/4/2025'),
(227, '8268747315', '26/8/2025', '8/1/2025'),
(228, '7874375246', '30/9/2024', '18/9/2025'),
(229, '4768442692', '24/6/2025', '26/12/2024'),
(230, '4725178349', '20/5/2025', '29/11/2024'),
(231, '0525435549', '26/2/2025', '18/7/2025'),
(232, '3734794722', '6/8/2025', '18/8/2025'),
(233, '8447270114', '30/9/2024', '8/3/2025'),
(234, '8268342870', '25/2/2025', '2/1/2025'),
(235, '1927126495', '13/12/2024', '12/4/2025'),
(236, '0993027644', '2/3/2025', '29/8/2025'),
(237, '7250459503', '31/12/2024', '1/7/2025'),
(238, '0426096924', '15/8/2025', '7/6/2025'),
(239, '5475499357', '4/10/2024', '5/12/2024'),
(240, '8359108048', '22/12/2024', '16/7/2025'),
(241, '8985187929', '11/2/2025', '8/7/2025'),
(242, '5582753311', '16/4/2025', '21/5/2025'),
(243, '4362012095', '13/4/2025', '25/2/2025'),
(244, '3441596420', '1/12/2024', '28/1/2025'),
(245, '3343308951', '15/11/2024', '5/6/2025'),
(246, '3568335654', '20/3/2025', '6/1/2025'),
(247, '6178304544', '31/1/2025', '21/4/2025'),
(248, '8664619859', '13/4/2025', '9/3/2025'),
(249, '4384299443', '27/1/2025', '8/3/2025'),
(250, '5975330165', '18/1/2025', '2/12/2024');

--
-- TOC entry 5426 (class 0 OID 41008)
-- Dependencies: 225
-- Data for Name: COMPRAS_INSUMOS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."COMPRAS_INSUMOS" (id_compra, id_proveedor_insumos, fecha_compra) FROM stdin;
1	1	26/5/2025
2	2	29/10/2024
3	3	11/2/2025
4	4	28/11/2024
5	5	14/7/2025
6	6	5/12/2024
7	7	31/12/2024
8	8	3/11/2024
9	9	29/6/2025
10	10	16/11/2024
11	11	11/5/2025
12	12	24/5/2025
13	13	15/8/2025
14	14	29/11/2024
15	15	23/7/2025
16	16	16/12/2024
17	17	17/11/2024
18	18	30/8/2025
19	19	31/10/2024
20	20	4/9/2025
21	21	26/5/2025
22	22	1/1/2025
23	23	14/2/2025
24	24	7/8/2025
25	25	17/8/2025
26	26	30/4/2025
27	27	3/2/2025
28	28	5/7/2025
29	29	25/9/2025
30	30	15/9/2025
31	31	23/7/2025
32	32	1/7/2025
33	33	1/7/2025
34	34	4/7/2025
35	35	21/1/2025
36	36	13/9/2025
37	37	10/10/2024
38	38	13/1/2025
39	39	14/3/2025
40	40	24/11/2024
41	41	26/6/2025
42	42	22/2/2025
43	43	22/4/2025
44	44	1/2/2025
45	45	7/7/2025
46	46	31/12/2024
47	47	6/9/2025
48	48	4/5/2025
49	49	24/11/2024
50	50	8/7/2025
51	51	18/2/2025
52	52	31/1/2025
53	53	12/8/2025
54	54	10/6/2025
55	55	11/4/2025
56	56	22/8/2025
57	57	3/12/2024
58	58	28/11/2024
59	59	5/5/2025
60	60	25/4/2025
61	61	14/8/2025
62	62	15/10/2024
63	63	11/5/2025
64	64	20/10/2024
65	65	3/5/2025
66	66	6/12/2024
67	67	30/3/2025
68	68	26/8/2025
69	69	27/5/2025
70	70	3/10/2024
71	71	27/1/2025
72	72	20/10/2024
73	73	10/4/2025
74	74	28/8/2025
75	75	20/6/2025
76	76	30/1/2025
77	77	26/8/2025
78	78	7/3/2025
79	79	22/8/2025
80	80	16/1/2025
81	81	2/11/2024
82	82	14/8/2025
83	83	8/3/2025
84	84	17/6/2025
85	85	22/3/2025
86	86	22/1/2025
87	87	7/6/2025
88	88	5/9/2025
89	89	25/11/2024
90	90	22/3/2025
91	91	7/1/2025
92	92	13/3/2025
93	93	25/12/2024
94	94	6/4/2025
95	95	19/1/2025
96	96	27/6/2025
97	97	3/2/2025
98	98	14/6/2025
99	99	26/1/2025
100	100	10/10/2024
101	101	9/12/2024
102	102	4/10/2024
103	103	13/9/2025
104	104	21/5/2025
105	105	18/10/2024
106	106	25/5/2025
107	107	15/6/2025
108	108	13/8/2025
109	109	1/11/2024
110	110	3/9/2025
111	111	13/11/2024
112	112	9/11/2024
113	113	10/3/2025
114	114	24/5/2025
115	115	27/1/2025
116	116	2/6/2025
117	117	26/6/2025
118	118	27/7/2025
119	119	7/2/2025
120	120	26/2/2025
121	121	17/1/2025
122	122	23/2/2025
123	123	15/8/2025
124	124	24/2/2025
125	125	24/2/2025
126	126	3/1/2025
127	127	26/12/2024
128	128	2/5/2025
129	129	8/12/2024
130	130	30/9/2024
131	131	12/6/2025
132	132	19/6/2025
133	133	6/4/2025
134	134	13/3/2025
135	135	4/7/2025
136	136	2/12/2024
137	137	19/1/2025
138	138	29/7/2025
139	139	12/4/2025
140	140	17/12/2024
141	141	5/6/2025
142	142	20/3/2025
143	143	13/1/2025
144	144	5/1/2025
145	145	5/1/2025
146	146	10/3/2025
147	147	28/12/2024
148	148	6/11/2024
149	149	12/5/2025
150	150	29/10/2024
151	151	18/7/2025
152	152	2/11/2024
153	153	16/3/2025
154	154	12/11/2024
155	155	26/11/2024
156	156	3/4/2025
157	157	2/10/2024
158	158	9/8/2025
159	159	6/10/2024
160	160	27/4/2025
161	161	15/7/2025
162	162	8/9/2025
163	163	11/6/2025
164	164	19/2/2025
165	165	3/9/2025
166	166	6/10/2024
167	167	2/12/2024
168	168	29/4/2025
169	169	3/1/2025
170	170	24/10/2024
171	171	2/4/2025
172	172	17/8/2025
173	173	15/1/2025
174	174	18/5/2025
175	175	18/12/2024
176	176	27/11/2024
177	177	14/4/2025
178	178	17/12/2024
179	179	9/5/2025
180	180	29/8/2025
181	181	22/11/2024
182	182	20/1/2025
183	183	29/5/2025
184	184	2/5/2025
185	185	22/4/2025
186	186	9/4/2025
187	187	23/5/2025
188	188	24/10/2024
189	189	3/5/2025
190	190	23/9/2025
191	191	1/12/2024
192	192	8/11/2024
193	193	4/7/2025
194	194	31/7/2025
195	195	19/7/2025
196	196	27/5/2025
197	197	21/4/2025
198	198	8/12/2024
199	199	28/7/2025
200	200	29/11/2024
201	201	14/10/2024
202	202	21/11/2024
203	203	12/4/2025
204	204	13/12/2024
205	205	11/4/2025
206	206	2/1/2025
207	207	19/6/2025
208	208	7/11/2024
209	209	9/4/2025
210	210	30/10/2024
211	211	22/8/2025
212	212	7/4/2025
213	213	19/10/2024
214	214	5/2/2025
215	215	29/1/2025
216	216	2/12/2024
217	217	7/7/2025
218	218	10/1/2025
219	219	2/3/2025
220	220	17/10/2024
221	221	24/4/2025
222	222	15/4/2025
223	223	15/10/2024
224	224	11/8/2025
225	225	22/7/2025
226	226	15/11/2024
227	227	9/3/2025
228	228	28/1/2025
229	229	28/9/2024
230	230	1/12/2024
231	231	25/7/2025
232	232	10/1/2025
233	233	13/7/2025
234	234	27/4/2025
235	235	7/3/2025
236	236	11/4/2025
237	237	6/4/2025
238	238	5/11/2024
239	239	10/8/2025
240	240	3/12/2024
241	241	31/5/2025
242	242	2/1/2025
243	243	26/7/2025
244	244	28/4/2025
245	245	12/6/2025
246	246	3/5/2025
247	247	8/6/2025
248	248	5/12/2024
249	249	14/7/2025
250	250	15/3/2025
\.


--
-- TOC entry 5427 (class 0 OID 41013)
-- Dependencies: 226
-- Data for Name: CONTRATO_SERVICIOS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."CONTRATO_SERVICIOS" (id_pago, id_clientes, cantidad_personas, id_servicio, fecha_inicio, fecha_terminacion) FROM stdin;
1	1	1	1	16/11/2024	26/1/2025
2	2	2	2	8/7/2025	19/12/2024
3	3	3	3	28/1/2025	6/3/2025
4	4	4	4	1/1/2025	28/7/2025
5	5	5	5	15/6/2025	19/6/2025
6	6	6	6	8/5/2025	7/3/2025
7	7	7	7	13/9/2025	29/8/2025
8	8	8	8	12/2/2025	3/4/2025
9	9	9	9	31/10/2024	10/8/2025
10	10	10	10	1/10/2024	24/8/2025
11	11	11	11	5/1/2025	28/2/2025
12	12	12	12	16/11/2024	22/8/2025
13	13	13	13	3/5/2025	17/3/2025
14	14	14	14	21/3/2025	22/7/2025
15	15	15	15	27/7/2025	1/7/2025
16	16	16	16	16/7/2025	24/10/2024
17	17	17	17	15/12/2024	12/10/2024
18	18	18	18	23/9/2025	24/12/2024
19	19	19	19	31/3/2025	8/11/2024
20	20	20	20	20/11/2024	10/8/2025
21	21	21	21	20/10/2024	5/8/2025
22	22	22	22	16/6/2025	21/11/2024
23	23	23	23	21/11/2024	9/7/2025
24	24	24	24	13/4/2025	16/10/2024
25	25	25	25	6/3/2025	4/9/2025
26	26	26	26	24/1/2025	26/12/2024
27	27	27	27	16/5/2025	13/9/2025
28	28	28	28	6/4/2025	8/2/2025
29	29	29	29	27/9/2025	16/4/2025
30	30	30	30	13/11/2024	16/10/2024
31	31	31	31	12/11/2024	24/1/2025
32	32	32	32	27/9/2025	10/4/2025
33	33	33	33	22/10/2024	6/10/2024
34	34	34	34	29/10/2024	27/8/2025
35	35	35	35	2/10/2024	25/4/2025
36	36	36	36	22/10/2024	23/10/2024
37	37	37	37	10/3/2025	8/9/2025
38	38	38	38	14/4/2025	10/6/2025
39	39	39	39	26/3/2025	29/9/2024
40	40	40	40	10/2/2025	18/4/2025
41	41	41	41	23/11/2024	9/2/2025
42	42	42	42	2/1/2025	27/7/2025
43	43	43	43	31/10/2024	8/5/2025
44	44	44	44	13/9/2025	5/4/2025
45	45	45	45	11/6/2025	5/4/2025
46	46	46	46	20/7/2025	17/10/2024
47	47	47	47	14/1/2025	14/4/2025
48	48	48	48	18/1/2025	30/5/2025
49	49	49	49	20/7/2025	25/7/2025
50	50	50	50	14/3/2025	22/9/2025
51	51	51	51	17/4/2025	15/3/2025
52	52	52	52	23/8/2025	21/12/2024
53	53	53	53	4/12/2024	12/6/2025
54	54	54	54	21/12/2024	20/2/2025
55	55	55	55	24/4/2025	13/3/2025
56	56	56	56	12/11/2024	2/9/2025
57	57	57	57	16/12/2024	18/7/2025
58	58	58	58	11/6/2025	13/10/2024
59	59	59	59	17/5/2025	1/8/2025
60	60	60	60	5/12/2024	31/1/2025
61	61	61	61	14/6/2025	8/3/2025
62	62	62	62	27/4/2025	27/8/2025
63	63	63	63	15/8/2025	8/2/2025
64	64	64	64	23/1/2025	3/1/2025
65	65	65	65	29/4/2025	31/12/2024
66	66	66	66	11/6/2025	29/11/2024
67	67	67	67	11/4/2025	14/10/2024
68	68	68	68	9/8/2025	19/12/2024
69	69	69	69	30/7/2025	16/9/2025
70	70	70	70	27/11/2024	30/8/2025
71	71	71	71	14/6/2025	7/3/2025
72	72	72	72	25/11/2024	31/12/2024
73	73	73	73	8/11/2024	20/8/2025
74	74	74	74	12/5/2025	12/3/2025
75	75	75	75	7/2/2025	24/12/2024
76	76	76	76	11/2/2025	20/10/2024
77	77	77	77	30/1/2025	17/12/2024
78	78	78	78	28/5/2025	14/12/2024
79	79	79	79	27/4/2025	24/6/2025
80	80	80	80	2/9/2025	5/9/2025
81	81	81	81	9/6/2025	26/9/2025
82	82	82	82	12/5/2025	28/8/2025
83	83	83	83	7/12/2024	8/8/2025
84	84	84	84	22/3/2025	22/1/2025
85	85	85	85	19/3/2025	17/2/2025
86	86	86	86	18/7/2025	22/8/2025
87	87	87	87	13/12/2024	24/1/2025
88	88	88	88	5/1/2025	20/9/2025
89	89	89	89	20/9/2025	17/5/2025
90	90	90	90	22/9/2025	20/4/2025
91	91	91	91	20/8/2025	14/7/2025
92	92	92	92	23/10/2024	22/2/2025
93	93	93	93	15/11/2024	9/8/2025
94	94	94	94	14/10/2024	6/5/2025
95	95	95	95	9/7/2025	26/3/2025
96	96	96	96	9/2/2025	27/7/2025
97	97	97	97	20/8/2025	14/11/2024
98	98	98	98	28/9/2024	21/11/2024
99	99	99	99	21/2/2025	9/11/2024
100	100	100	100	1/12/2024	11/6/2025
101	101	101	101	14/6/2025	29/8/2025
102	102	102	102	27/2/2025	8/11/2024
103	103	103	103	14/10/2024	1/10/2024
104	104	104	104	19/9/2025	4/10/2024
105	105	105	105	12/5/2025	13/11/2024
106	106	106	106	30/8/2025	17/3/2025
107	107	107	107	9/9/2025	18/8/2025
108	108	108	108	3/12/2024	5/12/2024
109	109	109	109	15/6/2025	1/5/2025
110	110	110	110	13/6/2025	16/9/2025
111	111	111	111	22/6/2025	8/12/2024
112	112	112	112	8/12/2024	29/8/2025
113	113	113	113	19/2/2025	27/7/2025
114	114	114	114	9/11/2024	17/9/2025
115	115	115	115	16/11/2024	31/8/2025
116	116	116	116	22/6/2025	30/12/2024
117	117	117	117	11/2/2025	3/7/2025
118	118	118	118	21/11/2024	26/1/2025
119	119	119	119	29/11/2024	4/1/2025
120	120	120	120	20/10/2024	6/1/2025
121	121	121	121	9/11/2024	2/8/2025
122	122	122	122	8/9/2025	28/7/2025
123	123	123	123	26/7/2025	10/10/2024
124	124	124	124	3/3/2025	15/5/2025
125	125	125	125	10/3/2025	14/3/2025
126	126	126	126	16/9/2025	14/1/2025
127	127	127	127	10/4/2025	8/4/2025
128	128	128	128	31/3/2025	9/10/2024
129	129	129	129	25/4/2025	13/6/2025
130	130	130	130	24/6/2025	3/3/2025
131	131	131	131	24/12/2024	1/1/2025
132	132	132	132	19/11/2024	24/4/2025
133	133	133	133	31/10/2024	2/5/2025
134	134	134	134	13/11/2024	23/4/2025
135	135	135	135	8/8/2025	12/12/2024
136	136	136	136	11/5/2025	4/3/2025
137	137	137	137	23/5/2025	1/8/2025
138	138	138	138	14/4/2025	16/5/2025
139	139	139	139	8/10/2024	6/10/2024
140	140	140	140	29/11/2024	31/3/2025
141	141	141	141	6/11/2024	14/4/2025
142	142	142	142	10/8/2025	1/5/2025
143	143	143	143	11/8/2025	27/3/2025
144	144	144	144	1/11/2024	27/10/2024
145	145	145	145	17/8/2025	26/12/2024
146	146	146	146	1/9/2025	4/2/2025
147	147	147	147	19/6/2025	14/9/2025
148	148	148	148	14/10/2024	6/11/2024
149	149	149	149	26/3/2025	7/4/2025
150	150	150	150	30/10/2024	4/1/2025
151	151	151	151	1/7/2025	25/4/2025
152	152	152	152	21/5/2025	7/4/2025
153	153	153	153	18/10/2024	29/6/2025
154	154	154	154	26/9/2025	11/11/2024
155	155	155	155	28/10/2024	24/7/2025
156	156	156	156	19/12/2024	22/11/2024
157	157	157	157	1/11/2024	1/4/2025
158	158	158	158	14/12/2024	20/10/2024
159	159	159	159	1/5/2025	27/6/2025
160	160	160	160	29/10/2024	21/10/2024
161	161	161	161	29/10/2024	4/5/2025
162	162	162	162	11/1/2025	24/7/2025
163	163	163	163	29/1/2025	1/2/2025
164	164	164	164	3/3/2025	28/1/2025
165	165	165	165	22/2/2025	24/2/2025
166	166	166	166	10/6/2025	9/4/2025
167	167	167	167	15/3/2025	19/12/2024
168	168	168	168	8/11/2024	6/3/2025
169	169	169	169	15/12/2024	24/2/2025
170	170	170	170	27/7/2025	6/10/2024
171	171	171	171	9/4/2025	27/10/2024
172	172	172	172	1/6/2025	27/5/2025
173	173	173	173	26/7/2025	24/6/2025
174	174	174	174	26/8/2025	16/7/2025
175	175	175	175	13/1/2025	3/4/2025
176	176	176	176	21/11/2024	27/4/2025
177	177	177	177	20/2/2025	21/8/2025
178	178	178	178	2/1/2025	11/7/2025
179	179	179	179	19/2/2025	22/12/2024
180	180	180	180	27/2/2025	24/1/2025
181	181	181	181	16/12/2024	3/9/2025
182	182	182	182	27/5/2025	1/1/2025
183	183	183	183	16/11/2024	10/10/2024
184	184	184	184	3/4/2025	28/1/2025
185	185	185	185	24/11/2024	18/7/2025
186	186	186	186	14/2/2025	18/4/2025
187	187	187	187	7/6/2025	16/11/2024
188	188	188	188	23/6/2025	12/9/2025
189	189	189	189	28/12/2024	3/4/2025
190	190	190	190	7/3/2025	25/4/2025
191	191	191	191	13/4/2025	9/7/2025
192	192	192	192	7/6/2025	9/1/2025
193	193	193	193	4/4/2025	17/8/2025
194	194	194	194	30/8/2025	16/6/2025
195	195	195	195	28/10/2024	19/10/2024
196	196	196	196	22/7/2025	6/9/2025
197	197	197	197	19/10/2024	7/7/2025
198	198	198	198	20/7/2025	1/10/2024
199	199	199	199	11/12/2024	28/8/2025
200	200	200	200	12/11/2024	19/2/2025
201	201	201	201	18/7/2025	27/9/2025
202	202	202	202	13/7/2025	12/6/2025
203	203	203	203	29/1/2025	3/4/2025
204	204	204	204	18/5/2025	8/3/2025
205	205	205	205	10/12/2024	6/9/2025
206	206	206	206	25/6/2025	4/11/2024
207	207	207	207	6/10/2024	18/4/2025
208	208	208	208	26/12/2024	14/9/2025
209	209	209	209	3/2/2025	7/8/2025
210	210	210	210	24/12/2024	20/3/2025
211	211	211	211	26/12/2024	24/1/2025
212	212	212	212	19/10/2024	5/10/2024
213	213	213	213	16/2/2025	2/8/2025
214	214	214	214	29/6/2025	23/9/2025
215	215	215	215	13/10/2024	9/6/2025
216	216	216	216	2/6/2025	24/1/2025
217	217	217	217	30/3/2025	20/7/2025
218	218	218	218	8/2/2025	22/1/2025
219	219	219	219	7/9/2025	12/12/2024
220	220	220	220	5/12/2024	15/2/2025
221	221	221	221	13/6/2025	3/7/2025
222	222	222	222	16/8/2025	30/9/2024
223	223	223	223	11/1/2025	22/5/2025
224	224	224	224	15/11/2024	8/7/2025
225	225	225	225	10/9/2025	28/11/2024
226	226	226	226	20/1/2025	30/8/2025
227	227	227	227	26/12/2024	18/2/2025
228	228	228	228	5/5/2025	18/3/2025
229	229	229	229	7/5/2025	4/8/2025
230	230	230	230	1/5/2025	10/1/2025
231	231	231	231	16/6/2025	12/10/2024
232	232	232	232	20/10/2024	27/3/2025
233	233	233	233	9/5/2025	26/7/2025
234	234	234	234	8/3/2025	26/4/2025
235	235	235	235	29/10/2024	22/1/2025
236	236	236	236	12/7/2025	17/6/2025
237	237	237	237	31/10/2024	26/11/2024
238	238	238	238	15/8/2025	17/9/2025
239	239	239	239	21/10/2024	24/3/2025
240	240	240	240	6/1/2025	24/10/2024
241	241	241	241	14/8/2025	25/11/2024
242	242	242	242	16/6/2025	31/8/2025
243	243	243	243	24/11/2024	15/5/2025
244	244	244	244	15/4/2025	7/4/2025
245	245	245	245	18/8/2025	16/7/2025
246	246	246	246	11/3/2025	11/9/2025
247	247	247	247	14/3/2025	12/4/2025
248	248	248	248	18/4/2025	29/11/2024
249	249	249	249	12/3/2025	22/8/2025
250	250	250	250	20/9/2025	25/6/2025
\.


--
-- TOC entry 5428 (class 0 OID 41018)
-- Dependencies: 227
-- Data for Name: DEDUCCIONES_FACTURA; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."DEDUCCIONES_FACTURA" (id_deducciones_factura, impuesto_iva, impuesto_isr, descuentos) FROM stdin;
1	16	13	30
\.


--
-- TOC entry 5429 (class 0 OID 41023)
-- Dependencies: 228
-- Data for Name: DETALLES_PROMOCION; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."DETALLES_PROMOCION" (id_detalles_promocion, valor_descuento, usos_promocion, fecha_inicio, fecha_fin, id_promocion, restricciones) FROM stdin;
1	11.00	Perfectly balanced sweet and tangy BBQ sauce for dipping or grilling.	2025-08-14 00:00:00-06	2025-04-24 00:00:00-06	1	Pancake mix infused with seasonal pumpkin spice flavor.
2	4.00	Spacious duffle bag for weekend getaways.	2025-04-14 00:00:00-06	2025-02-24 00:00:00-06	2	A hearty soup filled with vegetables and herbs, perfect for a light meal.
3	6.00	Cold-pressed coconut oil, perfect for cooking, baking, or skin care.	2025-07-16 00:00:00-06	2025-09-14 00:00:00-06	3	Refreshing coconut water, perfect for hydration.
4	6.00	Marinated beef strips in teriyaki sauce for easy grilling.	2024-12-19 00:00:00-06	2025-02-11 00:00:00-06	4	Creamy chickpea dip infused with zesty garlic flavor.
5	2.00	Beginner-friendly acoustic guitar with natural finish.	2024-10-22 00:00:00-06	2025-04-25 00:00:00-06	5	Juicy peach slices in light syrup, in convenient cups.
6	11.00	Set of resistance bands for home workouts.	2025-06-14 00:00:00-06	2025-04-27 00:00:00-06	6	Rich and flavorful pasta sauce made with ripe tomatoes and basil.
7	6.00	Electric food steamer for healthy cooking.	2025-04-20 00:00:00-06	2025-04-23 00:00:00-06	7	Bell peppers stuffed with rice and vegetables
8	6.00	Classic leather photo album for keepsakes.	2025-08-31 00:00:00-06	2025-02-24 00:00:00-06	8	A fitted ribbed knit dress that hugs your curves perfectly.
9	2.00	Crunchy granola clusters mixed with nuts and honey.	2025-09-05 00:00:00-06	2025-06-26 00:00:00-06	9	Filters allergens and pollutants from the air for a healthier home.
10	8.00	A fresh salad made with black beans, corn, and a zesty dressing, great for summer cookouts.	2025-01-23 00:00:00-06	2024-11-20 00:00:00-06	10	Delicious ravioli filled with creamy ricotta and fresh spinach.
11	7.00	Nutritious chia seeds great for smoothies	2025-08-06 00:00:00-06	2024-12-31 00:00:00-06	11	Stylish hooks to easily hang shower curtains.
12	6.00	Frozen zucchini slices coated in parmesan cheese, perfect for baking or frying.	2025-04-18 00:00:00-06	2025-05-11 00:00:00-06	12	Sustainable foam blocks for yoga practice.
13	11.00	High-carbon stainless steel chef knife for precision cutting.	2025-01-27 00:00:00-06	2024-10-24 00:00:00-06	13	Ready-to-eat beet salad with dressing, great side dish.
14	8.00	Fresh and crunchy cucumbers, great for salads.	2025-05-20 00:00:00-06	2025-01-07 00:00:00-06	14	Rich and creamy smoked Gouda cheese perfect for snacking.
15	3.00	Stream HD video wirelessly to your TV.	2025-02-23 00:00:00-06	2025-05-30 00:00:00-06	15	Set of flexible molds for baking cakes and pastries.
16	11.00	Beginner telescope for stargazing and exploring.	2025-05-27 00:00:00-06	2024-10-10 00:00:00-06	16	Timeless black trousers for a smart and sophisticated look.
17	2.00	Water bottle designed to infuse flavors from fruits.	2024-10-04 00:00:00-06	2024-12-10 00:00:00-06	17	Wireless earbuds designed for immersive sound experience.
18	10.00	Soft and chewy cookies made with creamy peanut butter.	2025-08-25 00:00:00-06	2025-06-05 00:00:00-06	18	Floating lounger for relaxation in swimming pools or lakes.
19	1.00	Lightweight hammock with a sturdy stand for relaxation anywhere.	2025-07-25 00:00:00-06	2024-10-21 00:00:00-06	19	Frozen shrimp seasoned with chili and lime, perfect for quick dinners.
20	2.00	A stylish midi dress with stylish pleats, suitable for any occasion.	2025-05-22 00:00:00-06	2025-08-04 00:00:00-06	20	Rich and buttery mashed potatoes with roasted garlic.
21	12.00	A refreshing blend of peaches and mangoes for a delicious smoothie.	2025-01-02 00:00:00-06	2025-06-22 00:00:00-06	21	Savory bacon jerky coated with maple flavoring.
22	6.00	Creamy dip made with real onions and spices, great for chips and veggies.	2024-12-14 00:00:00-06	2025-08-03 00:00:00-06	22	Creamy yogurt made with maple and almond flavors.
23	8.00	Authentic Italian pasta, perfect for a classic meal.	2025-02-12 00:00:00-06	2025-01-16 00:00:00-06	23	A creamy and flavorful hummus made with roasted red peppers.
24	6.00	Activity workbook for early learning and fun.	2025-02-09 00:00:00-06	2025-03-01 00:00:00-06	24	Stylish watering can for plants with easy pouring nozzle.
25	13.00	A creamy pumpkin soup with a blend of warm spices, ready to heat and serve.	2025-05-17 00:00:00-06	2025-09-24 00:00:00-06	25	Classic wooden train set for imaginative play.
26	5.00	Convert your desk to a standing desk easily.	2025-05-26 00:00:00-06	2025-07-23 00:00:00-06	26	A tangy and spicy BBQ sauce that's perfect for grilling.
27	8.00	Crunchy and sweet banana chips, a great on-the-go snack.	2025-04-05 00:00:00-06	2025-01-15 00:00:00-06	27	Complete watercolor set with paints and brushes.
28	12.00	A comfortable henley shirt made of soft cotton, perfect for casual outings.	2025-08-13 00:00:00-06	2025-09-25 00:00:00-06	28	A mix of fresh vegetables for quick stir-fries.
29	7.00	Creamy risotto made with mushrooms and herbs, perfect as a side dish or main course.	2024-11-17 00:00:00-06	2025-06-27 00:00:00-06	29	Extra layer of comfort for your mattress.
30	13.00	Flavorful chicken wings marinated in a sweet teriyaki glaze.	2025-08-02 00:00:00-06	2025-08-05 00:00:00-06	30	The perfect seafood snack, ready to eat and delicious.
31	6.00	Supportive yoga wheel for deep stretching and balance.	2024-10-23 00:00:00-06	2025-01-29 00:00:00-06	31	A hearty soup made with lentils, a variety of vegetables, and spices, ideal for a nutritious meal.
32	13.00	Golden crispy chicken tenders coated with honey mustard flavor.	2025-09-10 00:00:00-06	2025-04-13 00:00:00-06	32	Advanced electric toothbrush for effective cleaning.
33	3.00	Easy-to-make pancake mix with chocolate chips included.	2025-09-02 00:00:00-06	2024-12-26 00:00:00-06	33	Secure digital wireless security camera system.
34	13.00	Versatile air fryer that also roasts, bakes, and broils.	2025-02-08 00:00:00-06	2025-06-01 00:00:00-06	34	A flavorful sauce for stir-frying vegetables and meats.
35	12.00	Programmable pet feeder for scheduled meals.	2025-09-27 00:00:00-06	2025-02-14 00:00:00-06	35	Nutritious blend of wild rice and quinoa, perfect as a side dish.
36	3.00	A refreshing sparkling beverage with a bold blood orange flavor.	2025-05-22 00:00:00-06	2025-05-04 00:00:00-06	36	Rich and creamy almond milk with a hint of chocolate.
37	11.00	Delicious pasta shells filled with spinach and cheese	2025-08-14 00:00:00-06	2025-02-14 00:00:00-06	37	Eco-friendly string lights for outdoor decor.
38	2.00	Stylish desk lamp featuring a USB charging port.	2025-02-11 00:00:00-06	2025-01-21 00:00:00-06	38	Safe cleaning solution and tools for electronics screens.
39	1.00	Juicy chicken breast stuffed with spinach and feta cheese, seasoned to perfection.	2024-10-11 00:00:00-06	2025-09-14 00:00:00-06	39	Freshly baked artisan bread with a crisp crust and soft center.
40	8.00	Pasta tossed with fresh basil pesto, simple and delicious.	2024-11-25 00:00:00-06	2025-07-31 00:00:00-06	40	Instant-read thermometer for precise cooking temperatures.
41	6.00	A seasonal creamer that adds pumpkin spice flavor to coffee or tea.	2025-06-08 00:00:00-06	2024-11-06 00:00:00-06	41	Countertop dishwasher for small kitchens.
42	9.00	Durable and shatterproof silicone glasses for outdoor use.	2024-12-12 00:00:00-06	2025-09-17 00:00:00-06	42	Durable jump rope with built-in counter for workouts.
43	8.00	Single-serve coffee maker with a built-in grinder.	2025-05-05 00:00:00-06	2025-07-15 00:00:00-06	43	Frozen shrimp sautéed in garlic butter, ready to thaw and serve over pasta or rice.
44	9.00	Foldable mat for jigsaw puzzle assembly.	2025-05-12 00:00:00-06	2024-10-17 00:00:00-06	44	Heavy-duty rope suitable for boating, camping, and general use.
45	5.00	Durable 50-foot garden hose with nozzle.	2025-08-06 00:00:00-06	2025-04-28 00:00:00-06	45	Comfortable carrier for small pets during travel.
46	8.00	Crunchy granola clusters, perfect for snacking or topping yogurt.	2025-04-27 00:00:00-06	2025-02-15 00:00:00-06	46	Pancake mix infused with seasonal pumpkin spice flavor.
47	7.00	Chewy cookies made with coconut, perfect for sweet cravings.	2025-02-22 00:00:00-06	2024-12-20 00:00:00-06	47	Protective case for wireless earbuds.
48	2.00	Heavy-duty grill pan for indoor grilling.	2025-05-15 00:00:00-06	2025-09-07 00:00:00-06	48	Compact digital camera with 20MP resolution.
49	10.00	Add a smoky flavor to your dishes.	2025-05-11 00:00:00-06	2025-01-08 00:00:00-06	49	A mix of nuts, pretzels, and crackers, seasoned just right for snacking.
50	5.00	Tender sweet corn kernels, ready to eat or add to dishes.	2025-05-21 00:00:00-06	2025-02-19 00:00:00-06	50	Sweet and crunchy honey-flavored graham crackers.
51	10.00	Hearty chili made with beans and vegetables, a savory meal option.	2024-10-22 00:00:00-06	2025-03-22 00:00:00-06	51	Stylish ankle strap heels for a classy look at any event.
52	10.00	A flavorful rice side dish seasoned with herbs and spices.	2024-10-24 00:00:00-06	2025-02-25 00:00:00-06	52	Waterproof rain jacket with adjustable hood.
53	7.00	Crispy chips made from taro root, a wonderful snack.	2025-05-01 00:00:00-06	2024-11-11 00:00:00-06	53	Essential tools for bike maintenance and repair.
54	12.00	Compact electronic drum kit for musicians of all levels.	2025-06-12 00:00:00-06	2025-07-28 00:00:00-06	54	Indoor Wi-Fi camera for home security.
55	6.00	Refreshing dessert bars made with pineapple and coconut.	2024-12-02 00:00:00-06	2025-04-27 00:00:00-06	55	Compact projector for movies and presentations on the go.
56	13.00	Easy-to-use portable grill for barbecues.	2025-05-17 00:00:00-06	2025-09-08 00:00:00-06	56	Wireless trackpad for enhanced laptop navigation.
57	6.00	Flavorful chicken sausage, low in fat and fully cooked.	2025-07-15 00:00:00-06	2025-04-15 00:00:00-06	57	Sweet and nutritious potatoes, great for roasting.
58	7.00	Non-stick baking mat for easy cooking and cleanup.	2024-12-28 00:00:00-06	2025-01-16 00:00:00-06	58	Crumbled feta cheese, perfect for salads and Mediterranean dishes.
59	8.00	Plant-based sausage links with spices and herbs.	2025-01-06 00:00:00-06	2025-04-06 00:00:00-06	59	Grow herbs indoors with this easy-to-use hydroponic garden system.
60	10.00	Stackable steamers for healthy cooking of vegetables and seafood.	2025-09-03 00:00:00-06	2024-09-28 00:00:00-06	60	A mix of strawberries, blueberries, and raspberries, great for smoothies or desserts.
61	7.00	Delicious apple sauce with a hint of cinnamon	2025-02-16 00:00:00-06	2025-01-25 00:00:00-06	61	Complete kit for crafting your own scented soaps.
62	11.00	Battery-operated blender for smoothies on the go.	2025-02-05 00:00:00-06	2024-10-10 00:00:00-06	62	Portable solar shower for camping and outdoor use.
63	7.00	Low-carb zucchini noodles, perfect for a healthy alternative to pasta.	2024-10-01 00:00:00-06	2025-02-13 00:00:00-06	63	Savory sausage with a blend of spices, perfect for pasta dishes.
64	11.00	Multi-level scratching post to keep your cat entertained.	2024-11-14 00:00:00-06	2025-08-30 00:00:00-06	64	Portable case to organize and protect jewelry on trips.
65	5.00	Savory pizza rolls filled with pepperoni and cheese, ready to bake and enjoy in minutes.	2025-09-26 00:00:00-06	2025-01-25 00:00:00-06	65	A zesty marinade made with lemon juice and garlic, ideal for chicken or fish.
66	10.00	Spicy and creamy dip made with shredded chicken, perfect for parties.	2025-04-22 00:00:00-06	2025-05-30 00:00:00-06	66	Wearable diffuser for scenting your space and body.
67	10.00	Control lights remotely with this smart switch.	2025-09-19 00:00:00-06	2025-05-06 00:00:00-06	67	Essential attachments for pressure washing.
68	2.00	Timeless belted trench coat for a polished look during fall.	2025-05-24 00:00:00-06	2025-05-15 00:00:00-06	68	Genuine leather wallet with multiple compartments.
69	8.00	A flavorful lentil curry cooked with vegetables and spices.	2025-02-26 00:00:00-06	2024-10-04 00:00:00-06	69	Versatile puff pastry for pies and pastries.
70	11.00	A feminine wrap top with a beautiful floral print.	2025-04-09 00:00:00-06	2025-09-01 00:00:00-06	70	Set of roller bottles for blending and applying essential oils.
71	7.00	Vegetable spiralizer for healthy meals.	2025-03-11 00:00:00-06	2025-08-17 00:00:00-06	71	Plant-based sausage links with spices and herbs.
72	10.00	Flavorful lentil soup, perfect for a quick meal.	2025-06-08 00:00:00-06	2025-07-08 00:00:00-06	72	Comfortable wireless headphones designed for sleeping.
73	12.00	Perfectly designed pan for making crepes and pancakes.	2025-08-29 00:00:00-06	2025-08-28 00:00:00-06	73	Durable, unbreakable wine glasses for outdoor use.
74	5.00	Custom cutting board made from high-quality wood.	2024-11-11 00:00:00-06	2024-10-11 00:00:00-06	74	Protects car interior from sun damage and heat.
75	10.00	Premium potting soil for indoor plants.	2025-07-15 00:00:00-06	2025-06-13 00:00:00-06	75	Challenging and fun puzzle game for all ages.
76	9.00	Durable gardening gloves with reinforced fingertips.	2025-04-24 00:00:00-06	2025-08-23 00:00:00-06	76	Soft and plush robe for comfort after the shower.
77	4.00	Roasted pistachios, a healthy and tasty snack.	2025-06-06 00:00:00-06	2024-10-16 00:00:00-06	77	Compact keyboard for tablets and smartphones.
78	6.00	Eco-friendly sealer for protecting concrete surfaces.	2025-01-29 00:00:00-06	2025-05-11 00:00:00-06	78	Reversible bamboo chopping board for food prep.
79	10.00	Compact hand mixer for easy baking.	2025-05-15 00:00:00-06	2024-10-24 00:00:00-06	79	Durable, unbreakable wine glasses for outdoor use.
80	7.00	Chic suede ankle booties, perfect for dressing up or down.	2024-12-15 00:00:00-06	2025-02-10 00:00:00-06	80	Portable desk that can be adjusted for sitting or standing.
81	11.00	Fresh kale salad with a zesty lemon dressing, great as a side dish.	2024-12-15 00:00:00-06	2025-06-25 00:00:00-06	81	Portable car vacuum cleaner with strong suction.
82	5.00	Durable and non-stick ceramic cookware for healthy cooking.	2025-07-25 00:00:00-06	2025-04-18 00:00:00-06	82	Spicy cauliflower bites for a vegetarian snack.
83	3.00	Sturdy mobile workbench with storage options.	2024-11-28 00:00:00-06	2024-12-07 00:00:00-06	83	Fresh and juicy cherry tomatoes for salads and snacking.
84	4.00	Freshly baked artisan bread, perfect for sandwiches or toasting.	2025-02-11 00:00:00-06	2025-07-14 00:00:00-06	84	Juicy raisins coated in rich dark chocolate.
85	5.00	Wide range of flavored wings, perfect for parties or casual snacking.	2024-12-15 00:00:00-06	2024-11-15 00:00:00-06	85	Frozen mini meatballs that are great as a snack or in pasta dishes.
86	2.00	Freshly baked whole wheat bread, rich in fiber.	2025-02-22 00:00:00-06	2025-08-24 00:00:00-06	86	A timeless wardrobe staple crafted from soft cotton with a perfect fit.
87	11.00	Tool for measuring perfect pasta portions every time.	2025-08-16 00:00:00-06	2025-07-29 00:00:00-06	87	Extra virgin olive oil, ideal for cooking and salads.
88	8.00	A classic white button-up shirt for a polished appearance.	2024-12-10 00:00:00-06	2024-10-19 00:00:00-06	88	A smoky barbecue sauce, ideal for grilling and dipping.
89	7.00	Fresh organic blueberries perfect for snacking or baking.	2024-10-13 00:00:00-06	2025-04-18 00:00:00-06	89	Reusable wraps for food storage, replacing plastic wraps.
90	8.00	Stackable measuring cups made from stainless steel.	2024-12-18 00:00:00-06	2025-03-22 00:00:00-06	90	Convenient and low-carb alternative to traditional rice.
91	7.00	Versatile slicer for meats, cheeses, and vegetables.	2025-02-23 00:00:00-06	2025-06-12 00:00:00-06	91	Convenient strap for carrying yoga mats to class.
92	5.00	Fresh salsa made with tomatoes, onions, and cilantro.	2025-04-23 00:00:00-06	2025-06-21 00:00:00-06	92	Non-stick utensils for safe and easy cooking.
93	3.00	Quick oatmeal packets infused with apple and cinnamon, perfect for breakfast.	2025-01-27 00:00:00-06	2025-02-13 00:00:00-06	93	A crunchy collection of flavored kettle chips in a convenient pack.
94	7.00	Sweet peach halves packed in juice, great for desserts.	2025-01-01 00:00:00-06	2025-01-26 00:00:00-06	94	Baking mix to create your favorite Samoa-style cookies at home.
95	2.00	Stainless steel travel mug with spill-proof lid.	2025-02-03 00:00:00-06	2025-04-24 00:00:00-06	95	Electric food steamer for healthy cooking.
96	5.00	Reusable tote bags for shopping and eco-friendly living.	2024-11-17 00:00:00-06	2025-07-17 00:00:00-06	96	Rich cocoa powder for baking and chocolate recipes.
97	3.00	A classic soup combining tomatoes and basil, great with grilled cheese sandwiches.	2025-06-01 00:00:00-06	2025-07-20 00:00:00-06	97	A classic denim jacket that never goes out of style.
98	4.00	Delicious cookies flavored with pumpkin and spices.	2025-07-08 00:00:00-06	2025-07-01 00:00:00-06	98	Cozy wool sweater to keep you warm on chilly days.
99	6.00	Crispy and chewy granola bars, perfect for on-the-go.	2025-03-31 00:00:00-06	2024-10-30 00:00:00-06	99	Heavy-duty rope suitable for boating, camping, and general use.
100	9.00	Fresh green cabbage, great for salads and slaws.	2025-04-08 00:00:00-06	2025-03-04 00:00:00-06	100	Hearty beef chili, ready to heat and eat.
101	6.00	All ingredients included for delicious chicken fajitas.	2025-03-19 00:00:00-06	2024-09-29 00:00:00-06	101	Rechargeable massage gun for relieving muscle soreness.
102	5.00	Chewy granola bars made with honey and almonds.	2025-05-27 00:00:00-06	2024-10-23 00:00:00-06	102	Refreshing coconut water, perfect for hydration.
103	5.00	Video baby monitor with night vision.	2024-09-30 00:00:00-06	2024-12-19 00:00:00-06	103	Short-grain sushi rice for perfect rolls.
104	11.00	Lightweight bike helmet with adjustable fit.	2024-11-30 00:00:00-06	2025-03-05 00:00:00-06	104	Safe and fun trampoline for children.
105	8.00	Precision cooker for perfect sous vide cooking.	2024-12-18 00:00:00-06	2024-10-13 00:00:00-06	105	Lightweight water filter for outdoor adventures.
106	6.00	Pre-seasoned beef mix for delicious tacos, just heat and serve.	2025-09-20 00:00:00-06	2024-12-22 00:00:00-06	106	Chilled noodles dressed in sesame sauce, ready to eat.
107	8.00	Soft blanket that provides warmth with adjustable settings.	2025-04-29 00:00:00-06	2025-06-19 00:00:00-06	107	Electric foot massager for relaxation and relief.
108	9.00	Savory sausage links with a hint of maple flavor.	2025-03-22 00:00:00-06	2025-07-12 00:00:00-06	108	Non-slip yoga mat for optimal grip and comfort.
109	13.00	A flavorful blend of Italian sausage with sautéed peppers and onions.	2025-01-20 00:00:00-06	2025-02-18 00:00:00-06	109	Handheld frother for creating frothed milk for coffee.
110	7.00	A blend of nuts, seeds, and dried fruits for snacking.	2025-05-28 00:00:00-06	2024-12-16 00:00:00-06	110	Nutty, crunchy pecans great for baking.
111	8.00	Stylish two-tone windbreaker, perfect for active days.	2025-07-11 00:00:00-06	2025-01-22 00:00:00-06	111	Tangy sour cream, perfect for dips and toppings.
112	7.00	Marinated beef strips in teriyaki sauce for easy grilling.	2025-09-23 00:00:00-06	2025-09-16 00:00:00-06	112	Timeless analog watch with a leather strap.
113	5.00	A retro-style button-down shirt with a relaxed fit.	2025-03-14 00:00:00-06	2025-02-17 00:00:00-06	113	Decadent tart made with rich dark chocolate.
114	9.00	Comfortable carrier for small pets during travel.	2025-02-16 00:00:00-06	2025-05-19 00:00:00-06	114	Comfortable headset with surround sound for immersive gaming.
115	7.00	Creamy risotto made with mushrooms and herbs, perfect as a side dish or main course.	2024-09-28 00:00:00-06	2025-05-15 00:00:00-06	115	Quick and easy rice pilaf mix for side dishes.
116	7.00	Spicy ginger cookies that are crunchy and delicious.	2024-11-14 00:00:00-06	2025-05-29 00:00:00-06	116	Tangy green salsa made with tomatillos, perfect for tacos.
117	13.00	Wi-Fi smart scale for tracking weight and BMI.	2024-12-11 00:00:00-06	2024-11-01 00:00:00-06	117	String lights for decorating holiday trees.
118	9.00	Water-resistant blanket for picnics and outdoor events.	2025-03-05 00:00:00-06	2025-09-24 00:00:00-06	118	Tofu stir-fried with fresh vegetables in teriyaki sauce.
119	12.00	A nutritious salad with kale, quinoa, and a zesty lemon dressing.	2025-07-08 00:00:00-06	2024-11-09 00:00:00-06	119	Ergonomic desk that adjusts height for standing or sitting.
120	13.00	Water bottle that tracks hydration levels and adds electrolytes.	2025-08-20 00:00:00-06	2024-11-13 00:00:00-06	120	A wholesome granola with bits of apple and a touch of cinnamon.
121	11.00	Instant hot water dispenser for tea and cooking.	2025-07-29 00:00:00-06	2024-11-06 00:00:00-06	121	Tender ribs smothered in a honey barbecue sauce.
122	13.00	Rich and sweet paprika spice for seasoning.	2024-11-25 00:00:00-06	2024-11-23 00:00:00-06	122	Floating lounger for relaxation in swimming pools or lakes.
123	1.00	Floral and refreshing herbal tea, great hot or iced.	2024-11-09 00:00:00-06	2025-02-18 00:00:00-06	123	Foldable reclining camping chair with cup holder.
124	12.00	Cozy faux fur blanket to add warmth and style to your home.	2025-04-26 00:00:00-06	2025-04-21 00:00:00-06	124	Simple tool to train your pet with positive reinforcement.
125	13.00	Hearty casserole with beef and enchilada sauce.	2024-09-29 00:00:00-06	2025-07-01 00:00:00-06	125	Delicious clusters of peanuts and chocolate for a sweet treat.
126	8.00	Fun and colorful gardening tools designed for children.	2024-11-05 00:00:00-06	2025-03-05 00:00:00-06	126	Handy belt for carrying garden tools while working.
127	10.00	Quick-cooking ramen for instant meals.	2025-09-04 00:00:00-06	2025-01-07 00:00:00-06	127	Space-saving shoe organizer for tight spaces.
128	2.00	Ceramic incense holder for a calming atmosphere.	2025-08-25 00:00:00-06	2024-12-03 00:00:00-06	128	Ergonomic wireless mouse with adjustable DPI.
129	1.00	A flavorful garlic butter blend, perfect for cooking or baking.	2025-09-10 00:00:00-06	2025-03-27 00:00:00-06	129	DIY LED strip lights with remote control.
130	5.00	Flavorful dressing made with miso paste	2025-09-23 00:00:00-06	2024-12-05 00:00:00-06	130	Quality scissors designed for easy pet grooming.
131	5.00	Suction cup bird feeder for close-up bird watching.	2024-10-13 00:00:00-06	2025-03-12 00:00:00-06	131	Delicious turkey bacon, a healthier alternative.
132	7.00	Fun kit for aspiring explorers with binoculars and a compass.	2025-06-14 00:00:00-06	2024-12-07 00:00:00-06	132	Rich basil pesto sauce for pasta and more.
133	5.00	Bluetooth speakers with excellent sound quality.	2025-01-29 00:00:00-06	2025-06-04 00:00:00-06	133	Spicy sauce made with chipotle peppers
134	13.00	A spicy glaze made with sriracha and honey, perfect for meats.	2025-09-05 00:00:00-06	2024-12-10 00:00:00-06	134	Qi-certified wireless charger for fast charging.
135	5.00	Color-changing 3D night light for kids' rooms.	2025-04-17 00:00:00-06	2024-12-23 00:00:00-06	135	Energy-efficient LED bulbs that can be controlled via smartphone.
136	9.00	Delicious homemade style blackberry jam.	2024-12-20 00:00:00-06	2025-02-11 00:00:00-06	136	Versatile holder that can be used on desks, cars, and more.
137	2.00	Compact and stylish indoor/outdoor fire pit for ambiance.	2025-04-30 00:00:00-06	2025-03-24 00:00:00-06	137	Smooth and creamy smoothie made with peanut butter and banana.
138	6.00	Bottle with infuser for brewing loose-leaf tea on the go.	2025-04-09 00:00:00-06	2024-12-06 00:00:00-06	138	Supportive pillow designed for a good night's sleep.
139	5.00	Refreshing coconut water packed with electrolytes for hydration.	2025-03-27 00:00:00-06	2024-09-29 00:00:00-06	139	A creamy and flavorful hummus made with roasted red peppers.
140	9.00	Easy setup tent perfect for camping and outdoor festivals.	2025-06-03 00:00:00-06	2025-07-02 00:00:00-06	140	Salmon fillets seasoned with lemon and dill, perfect for grilling.
141	1.00	Versatile electric skillet for stir-frying and searing.	2025-03-15 00:00:00-06	2025-07-22 00:00:00-06	141	Classic wooden building blocks for toddlers.
142	12.00	Thermos that tracks your water intake and temperature.	2025-04-02 00:00:00-06	2025-07-04 00:00:00-06	142	STEM-based kit for kids featuring cool science experiments.
143	2.00	Gluten-free flour made from ground chickpeas, great for cooking.	2025-02-06 00:00:00-06	2025-09-02 00:00:00-06	143	Thermos that tracks your water intake and temperature.
144	6.00	Personalized calendar with your favorite photos.	2025-02-10 00:00:00-06	2025-05-21 00:00:00-06	144	Creamy, dairy-free Alfredo sauce
145	2.00	Mesh drying rack for preserving herbs and flowers.	2025-08-21 00:00:00-06	2025-08-05 00:00:00-06	145	A comfortable henley shirt made of soft cotton, perfect for casual outings.
146	8.00	Eco-friendly solar lights for pathways and gardens.	2025-02-16 00:00:00-06	2025-04-11 00:00:00-06	146	A hearty soup filled with vegetables and herbs, perfect for a light meal.
147	9.00	Bright flashlight with rechargeable batteries included.	2025-02-26 00:00:00-06	2025-06-18 00:00:00-06	147	Compact air compressor for inflating tires and sports equipment.
148	2.00	Polarized sunglasses with UV protection.	2025-08-03 00:00:00-06	2025-03-24 00:00:00-06	148	Engaging kit with science experiments for children.
149	6.00	Rich and tangy balsamic vinegar, perfect for dressings.	2024-11-15 00:00:00-06	2025-09-26 00:00:00-06	149	A sweet and spicy sauce for dipping or cooking.
150	2.00	Sweet bread with cinnamon and raisins, great for breakfast or snacks.	2024-10-16 00:00:00-06	2025-09-18 00:00:00-06	150	Hearty minestrone soup loaded with vegetables and pasta.
151	13.00	Canned chickpeas, perfect for hummus or salads.	2025-08-31 00:00:00-06	2025-06-02 00:00:00-06	151	Delicious clusters of peanuts and chocolate for a sweet treat.
152	11.00	Sand-resistant and compact for outdoor and beach use.	2025-04-02 00:00:00-06	2025-08-28 00:00:00-06	152	Space-saving cup that folds flat for easy storage.
153	5.00	Aromatic long-grain basmati rice, perfect for curries.	2025-07-17 00:00:00-06	2025-05-28 00:00:00-06	153	Variety pack of sticky notes in different colors and sizes.
154	4.00	Handy keychain that emits a loud alarm for personal safety.	2025-06-22 00:00:00-06	2024-11-27 00:00:00-06	154	Chewy bars made with peanut butter and chocolate chips.
155	7.00	Savory quiche loaded with spinach and cheese.	2025-05-19 00:00:00-06	2025-07-06 00:00:00-06	155	Relieve muscle tension and soreness with this foam roller.
156	1.00	A blend of peach and mango for a tropical smoothie.	2025-04-18 00:00:00-06	2024-10-24 00:00:00-06	156	A hearty vegetable curry for a quick and satisfying meal.
157	8.00	A refreshing salad made with quinoa and seasonal veggies.	2025-06-09 00:00:00-06	2024-12-14 00:00:00-06	157	Set of flexible molds for baking cakes and pastries.
158	7.00	Whole grain oats that are perfect for breakfast or baking.	2024-12-19 00:00:00-06	2024-10-03 00:00:00-06	158	Frozen vegan tacos filled with plant-based protein and spices.
159	13.00	Wearable device to track fitness activities and heart rate.	2025-09-18 00:00:00-06	2025-04-22 00:00:00-06	159	Rich and tangy balsamic vinegar, perfect for dressings.
160	13.00	Crunchy peanuts coated in honey, perfect for snacking.	2024-12-28 00:00:00-06	2025-07-23 00:00:00-06	160	Chewy granola bars made with honey and almonds.
161	5.00	Frozen berries blend perfect for smoothies, just add yogurt.	2025-01-05 00:00:00-06	2024-11-28 00:00:00-06	161	Creamy honey mustard sauce for dipping or dressing.
162	8.00	Comfortable carrier for small pets during travel.	2025-04-26 00:00:00-06	2024-12-20 00:00:00-06	162	Connect your phone to the car's audio system via Bluetooth.
163	12.00	Complete meal kit with everything needed to make beef stroganoff in under 30 minutes.	2025-04-04 00:00:00-06	2024-12-31 00:00:00-06	163	Rechargeable massage gun for relieving muscle soreness.
164	5.00	Finely ground flour from dried coconut meat.	2025-01-02 00:00:00-06	2025-06-05 00:00:00-06	164	Creamy macaroni and cheese baked to perfection.
165	8.00	Quick oatmeal with various flavors	2025-09-22 00:00:00-06	2025-06-11 00:00:00-06	165	Fresh organic cucumber perfect for salads or snacking.
166	4.00	Creamy ice cream made with real vanilla beans, perfect for desserts.	2025-04-24 00:00:00-06	2025-07-05 00:00:00-06	166	Nutty-scented oil for stir-fry and marinades.
167	1.00	Portable folding table for outdoor events.	2025-07-22 00:00:00-06	2025-05-09 00:00:00-06	167	Complete set of gardening tools for all your needs.
168	7.00	A comfortable henley shirt made of soft cotton, perfect for casual outings.	2025-01-21 00:00:00-06	2024-11-04 00:00:00-06	168	Oatmeal made with savory spices and vegetables.
169	3.00	Multi-function pressure cooker that can sauté, steam, and slow cook.	2025-02-09 00:00:00-06	2025-08-05 00:00:00-06	169	A meal kit featuring tender chicken with honey sesame sauce.
170	5.00	Durable cover to protect your grill from the elements.	2024-11-14 00:00:00-06	2024-11-18 00:00:00-06	170	Convenient carrier for transporting yoga mat.
171	12.00	A stylish midi dress with stylish pleats, suitable for any occasion.	2025-06-03 00:00:00-06	2025-08-07 00:00:00-06	171	Nutritious protein bars for on-the-go snacking.
172	2.00	Wi-Fi enabled thermostat that learns your habits.	2024-12-28 00:00:00-06	2025-03-18 00:00:00-06	172	Fragrant jasmine rice, perfect as a side dish.
173	1.00	Compact wireless set for easy computer usability.	2025-07-21 00:00:00-06	2025-08-03 00:00:00-06	173	Durable gloves with built-in claws for digging and planting.
174	12.00	Firm tofu, a great plant-based protein option.	2025-05-26 00:00:00-06	2025-09-02 00:00:00-06	174	Creamy yogurt made with coconut milk
175	13.00	Freshly ground cinnamon spice for baking or seasoning.	2025-01-29 00:00:00-06	2025-03-16 00:00:00-06	175	Healthy chia pudding made with mango and coconut milk.
176	6.00	Crunchy granola with chocolate and coconut, great for breakfast or snacks.	2025-06-02 00:00:00-06	2025-07-24 00:00:00-06	176	Stylish watering can for plants with easy pouring nozzle.
177	1.00	Delicate ravioli filled with roasted butternut squash and spices, perfect with a sage butter sauce.	2025-03-15 00:00:00-06	2024-10-19 00:00:00-06	177	A whole free-range chicken, ready for roasting.
178	8.00	Space-saving bike for indoor workouts.	2025-07-29 00:00:00-06	2024-12-23 00:00:00-06	178	Refreshing sparkling water with lemon and lime flavor
179	2.00	Stainless steel travel mug with spill-proof lid.	2025-06-19 00:00:00-06	2024-10-27 00:00:00-06	179	Fun light that creates a disco atmosphere for parties.
180	10.00	Pack of ultra-soft microfiber cloths for cleaning.	2025-03-26 00:00:00-06	2025-06-10 00:00:00-06	180	Hearty lentil soup for a quick meal.
181	10.00	Precision pencils for drawing, sketching, and writing.	2025-09-23 00:00:00-06	2025-09-04 00:00:00-06	181	Creamy hummus made with sweet peas and tahini.
182	6.00	Stylish case with magnetic closure for smartphones.	2025-08-17 00:00:00-06	2025-03-31 00:00:00-06	182	A savory marinade for meats, perfect for grilling.
183	2.00	Strategic board game for family game nights.	2025-01-11 00:00:00-06	2025-02-01 00:00:00-06	183	A hearty salad with grains, dried fruits, and nuts.
184	1.00	Complete outdoor kit for camping and hiking.	2025-03-21 00:00:00-06	2025-01-31 00:00:00-06	184	Creamy goat cheese infused with herbs and garlic, perfect for spreading on crackers.
185	10.00	Clip-on guitar tuner with LCD display.	2025-03-02 00:00:00-06	2025-08-08 00:00:00-06	185	Sweet and spicy salsa made with fresh peaches.
186	9.00	Extra virgin olive oil infused with fresh basil.	2024-10-02 00:00:00-06	2025-06-28 00:00:00-06	186	Rich cocoa powder for baking and chocolate recipes.
187	1.00	Easy-to-read digital kitchen timer with alarms.	2024-12-07 00:00:00-06	2025-08-06 00:00:00-06	187	Essential kit for taking care of your pets' health emergencies.
188	13.00	Multi-functional gloves for planting and digging without tools.	2024-11-04 00:00:00-06	2025-05-30 00:00:00-06	188	Spacious 2-person camping tent with waterproof cover.
189	4.00	Adjustable laptop stand for better ergonomics.	2025-03-06 00:00:00-06	2025-06-16 00:00:00-06	189	Easy-to-set-up picnic table for outdoor dining.
190	9.00	Crunchy, toasted coconut chips for snacking.	2025-06-10 00:00:00-06	2025-06-29 00:00:00-06	190	A gluten-free pizza crust made from cauliflower.
191	8.00	Organize coffee capsules with this stylish dispenser.	2025-06-11 00:00:00-06	2024-11-02 00:00:00-06	191	Classic chicken noodle soup with tender chicken and vegetables.
192	12.00	Healthier way to make popcorn in the microwave without oil.	2025-09-18 00:00:00-06	2025-02-27 00:00:00-06	192	Control appliances remotely using your smartphone.
193	1.00	Multiple USB ports for charging devices simultaneously.	2025-05-18 00:00:00-06	2024-10-06 00:00:00-06	193	Frozen green peas, a great addition to meals.
194	13.00	Instant ramen cups with flavor-packed broth.	2025-01-12 00:00:00-06	2025-05-21 00:00:00-06	194	Personalize your calendar with photos and special dates.
195	4.00	A luxurious faux fur coat that adds glamour to any outfit.	2025-05-26 00:00:00-06	2024-11-05 00:00:00-06	195	Oven-roasted sliced turkey, perfect for sandwiches.
196	12.00	Chewy granola bars with maple and cinnamon flavor.	2025-03-04 00:00:00-06	2024-11-30 00:00:00-06	196	A zesty marinade made with lemon juice and garlic, ideal for chicken or fish.
197	9.00	Ready-to-eat tuna salad with a spicy kick, perfect for sandwiches.	2025-02-05 00:00:00-06	2025-01-22 00:00:00-06	197	Easy-to-prepare rice with cilantro and lime flavors, great as a side.
198	10.00	A staple v-neck t-shirt that pairs well with anything.	2025-07-27 00:00:00-06	2025-01-17 00:00:00-06	198	Tool to check car engine codes and performance issues.
199	1.00	Delicious waffles infused with pumpkin and spices.	2025-08-11 00:00:00-06	2024-12-06 00:00:00-06	199	Rich and creamy almond milk with a hint of chocolate.
200	12.00	Fluffy and delicious pancake mix, perfect for a gluten-free breakfast.	2025-02-26 00:00:00-06	2025-07-14 00:00:00-06	200	Activity workbook for early learning and fun.
201	9.00	Nutty flavored chia seeds, packed with nutrients.	2025-01-05 00:00:00-06	2024-09-29 00:00:00-06	201	A mix of tropical fruits for a refreshing snack or dessert.
202	12.00	Instant miso soup mix, just add hot water for a warm meal.	2025-03-09 00:00:00-06	2024-11-06 00:00:00-06	202	Complete karaoke system with microphones and speakers.
203	10.00	Rechargeable electric razor for a smooth shave.	2025-06-23 00:00:00-06	2025-08-26 00:00:00-06	203	Complete outdoor kit for camping and hiking.
204	12.00	A soothing herbal tea made from ginger root.	2025-09-25 00:00:00-06	2025-06-23 00:00:00-06	204	Crispy baked radish chips, a healthy snack alternative.
205	9.00	A classic soup combining tomatoes and basil, great with grilled cheese sandwiches.	2025-09-22 00:00:00-06	2025-04-22 00:00:00-06	205	Soft pita bread, perfect for sandwiches or dips.
206	6.00	Premium potting soil for indoor plants.	2025-05-13 00:00:00-06	2024-12-14 00:00:00-06	206	Pasta alternative made from sweet potatoes, gluten-free and rich in flavor.
207	4.00	Crunchy granola mixed with coconut flakes.	2024-11-24 00:00:00-06	2024-12-19 00:00:00-06	207	Sweet and chewy dried mango slices, perfect for snacking.
208	6.00	Versatile multi-cooker for pressure cooking and slow cooking.	2025-09-10 00:00:00-06	2024-11-25 00:00:00-06	208	Creamy, sweet pie mix to make the perfect coconut cream pie.
209	7.00	Tangy dressing perfect for salads and marinades, with sesame and ginger flavors.	2024-12-11 00:00:00-06	2025-07-28 00:00:00-06	209	Versatile electric skillet for stir-frying and searing.
210	10.00	Oven-roasted potatoes tossed in garlic and parmesan cheese seasoning.	2024-10-31 00:00:00-06	2025-08-23 00:00:00-06	210	Savory soup made with leeks and potatoes.
211	7.00	Stay warm with this stylish knit beanie in various colors.	2025-03-17 00:00:00-06	2025-01-17 00:00:00-06	211	Lightweight hammock with a sturdy stand for relaxation anywhere.
212	11.00	Cozy wool sweater to keep you warm on chilly days.	2025-07-13 00:00:00-06	2024-12-31 00:00:00-06	212	Compact and stylish indoor/outdoor fire pit for ambiance.
213	5.00	Make delightful blueberry muffins at home with this easy mix.	2025-05-13 00:00:00-06	2025-05-28 00:00:00-06	213	Layered Greek yogurt with granola and mixed berries, ready to enjoy.
214	8.00	String lights for decorating holiday trees.	2024-10-16 00:00:00-06	2024-11-09 00:00:00-06	214	Advanced electric toothbrush for effective cleaning.
215	7.00	Special attachment for vacuum cleaners to remove pet hair easily.	2025-07-20 00:00:00-06	2025-01-15 00:00:00-06	215	Wireless headphones with noise-canceling features.
216	4.00	Moisturizing body wash with natural ingredients.	2024-11-01 00:00:00-06	2025-02-13 00:00:00-06	216	Burr coffee grinder for fresh ground coffee.
217	8.00	Wild-caught tuna in olive oil, perfect for salads.	2025-08-12 00:00:00-06	2025-07-29 00:00:00-06	217	A sweet and spicy sauce for dipping or glazing.
218	7.00	Space-saving cup that folds flat for easy storage.	2025-01-05 00:00:00-06	2024-10-17 00:00:00-06	218	Prevent water damage with drip trays for potted plants.
219	3.00	Stream HD video wirelessly from devices to TV.	2024-10-04 00:00:00-06	2025-02-13 00:00:00-06	219	Eco-friendly bamboo toothbrush for sustainable living.
220	1.00	Rich basil pesto sauce for pasta and more.	2025-05-12 00:00:00-06	2025-01-05 00:00:00-06	220	Comfortable wireless headphones designed for sleeping.
221	2.00	GPS pet collar that helps locate your pet via smartphone app.	2025-01-09 00:00:00-06	2025-09-25 00:00:00-06	221	Creamy peach-flavored yogurt with real fruit.
222	3.00	Delicious turkey bacon, a healthier alternative.	2025-05-10 00:00:00-06	2025-09-25 00:00:00-06	222	Microwaveable heat pad for soothing muscle aches.
223	4.00	Creamy peach-flavored yogurt with real fruit.	2025-09-03 00:00:00-06	2025-08-09 00:00:00-06	223	Extra virgin olive oil, ideal for cooking and salads.
224	2.00	Eye-catching mini dress with sequins, ideal for party nights out.	2025-01-02 00:00:00-06	2025-04-13 00:00:00-06	224	Essential kit for taking care of your pets' health emergencies.
225	12.00	A spicy marinade perfect for chicken and fish.	2025-07-26 00:00:00-06	2025-07-10 00:00:00-06	225	Fresh pomegranate juice, rich in antioxidants.
226	9.00	Spreadable cream cheese blended with garlic and herbs.	2025-06-22 00:00:00-06	2025-02-13 00:00:00-06	226	Convenient magnetic jars for easy spice storage.
227	4.00	A rich pesto made with sun-dried tomatoes and pine nuts.	2025-07-08 00:00:00-06	2025-06-10 00:00:00-06	227	Classic V-neck sweater crafted from soft wool for warmth and style.
228	7.00	Hearty beef chili, ready to heat and eat.	2025-01-10 00:00:00-06	2025-05-17 00:00:00-06	228	Versatile canned black beans, ready to add to any dish.
229	12.00	Nutritious bars packed with protein for energy	2025-06-02 00:00:00-06	2024-12-13 00:00:00-06	229	Gluten-free pasta made from red lentils, packed with protein.
230	11.00	Ready-to-eat salad with quinoa and kale, drizzled with vinaigrette.	2025-05-03 00:00:00-06	2025-02-01 00:00:00-06	230	Durable and adjustable jump box for effective workouts.
231	9.00	Comfortable over-ear headphones with deep bass.	2024-11-03 00:00:00-06	2025-05-21 00:00:00-06	231	A zesty salad with black beans, corn, and chipotle dressing.
232	5.00	Wireless headphones with noise-canceling features.	2024-12-27 00:00:00-06	2025-05-19 00:00:00-06	232	Compact digital camera with 20MP resolution.
233	5.00	Reusable silicone lids for covering food in bowls and storage containers.	2025-04-29 00:00:00-06	2024-10-18 00:00:00-06	233	Upgrade your phone photography with this lens kit that includes wide-angle and macro lenses.
234	4.00	Planter with self-watering feature for easy plant care.	2025-02-25 00:00:00-06	2025-05-30 00:00:00-06	234	Fun tourist magnets from around the world for your fridge.
235	6.00	Chewy granola bars made with honey and almonds.	2024-12-16 00:00:00-06	2025-03-08 00:00:00-06	235	Compact yoga mat that folds for easy storage and transport.
236	9.00	A healthy mix of assorted dried fruits and nuts for snacking.	2025-05-17 00:00:00-06	2024-12-23 00:00:00-06	236	Fun inflatable float for lounging in the pool or beach.
237	2.00	Creative building set for kids to spark imagination.	2025-02-25 00:00:00-06	2024-10-19 00:00:00-06	237	Universal mount for smartphones on motorcycles.
238	12.00	Fast and compact external solid state drive, 1TB.	2025-09-14 00:00:00-06	2025-05-24 00:00:00-06	238	Durable scoop for perfectly shaped ice cream servings.
239	11.00	Durable speaker designed for outdoor use with water resistance.	2025-06-26 00:00:00-06	2024-11-23 00:00:00-06	239	A smoky barbecue sauce, ideal for grilling and dipping.
240	2.00	Lightweight and durable tent for camping trips.	2025-01-01 00:00:00-06	2025-07-26 00:00:00-06	240	High-carbon stainless steel chef knife for precision cutting.
241	2.00	Seasoned and roasted to perfection, ready to eat.	2025-07-30 00:00:00-06	2025-03-27 00:00:00-06	241	Versatile chair that easily folds up for carrying.
242	12.00	Natural fruit spread bursting with real strawberry flavor.	2025-04-24 00:00:00-06	2025-08-08 00:00:00-06	242	A variety pack of classic, roasted red pepper, and garlic hummus.
243	4.00	Yogurt with the flavors of coconut cream pie, nice and indulgent.	2025-06-13 00:00:00-06	2025-09-11 00:00:00-06	243	Battery-operated blender for smoothies on the go.
244	4.00	Rich and flavorful pasta sauce made with ripe tomatoes and basil.	2024-12-13 00:00:00-06	2024-10-21 00:00:00-06	244	No-bake energy bites made with peanut butter and oats.
245	12.00	Colorful LED strip lights for home decoration.	2025-09-25 00:00:00-06	2025-05-15 00:00:00-06	245	Lentils cooked in a coconut curry for a hearty meal.
246	2.00	Luxurious satin slip dress for an elegant evening look.	2024-11-13 00:00:00-06	2024-11-08 00:00:00-06	246	Chilled noodles dressed in sesame sauce, ready to eat.
247	6.00	Creamy and smooth peanut butter, perfect for sandwiches.	2025-03-29 00:00:00-06	2024-11-11 00:00:00-06	247	Crunchy chips made from blue corn, perfect for dipping.
248	11.00	Warmer for heating baby bottles and food jars.	2025-05-28 00:00:00-06	2025-05-20 00:00:00-06	248	Pizza topped with barbecue chicken, cheese, and red onions.
249	3.00	Flexible molds perfect for baking cakes and pastries.	2025-05-13 00:00:00-06	2025-06-18 00:00:00-06	249	A timeless wardrobe staple crafted from soft cotton with a perfect fit.
250	2.00	Safe and fun trampoline for children.	2025-09-19 00:00:00-06	2024-10-10 00:00:00-06	250	Fresh zucchini, versatile for grilling or sautéing.
\.


--
-- TOC entry 5430 (class 0 OID 41028)
-- Dependencies: 229
-- Data for Name: DETALLES_RESERVAS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."DETALLES_RESERVAS" (id_reservacion, numero_habitacion) FROM stdin;
1	1
2	2
3	3
4	4
5	5
6	6
7	7
8	8
9	9
10	10
11	11
12	12
13	13
14	14
15	15
16	16
17	17
18	18
19	19
20	20
21	21
22	22
23	23
24	24
25	25
26	26
27	27
28	28
29	29
30	30
31	31
32	32
33	33
34	34
35	35
36	36
37	37
38	38
39	39
40	40
41	41
42	42
43	43
44	44
45	45
46	46
47	47
48	48
49	49
50	50
51	51
52	52
53	53
54	54
55	55
56	56
57	57
58	58
59	59
60	60
61	61
62	62
63	63
64	64
65	65
66	66
67	67
68	68
69	69
70	70
71	71
72	72
73	73
74	74
75	75
76	76
77	77
78	78
79	79
80	80
81	81
82	82
83	83
84	84
85	85
86	86
87	87
88	88
89	89
90	90
91	91
92	92
93	93
94	94
95	95
96	96
97	97
98	98
99	99
100	100
101	101
102	102
103	103
104	104
105	105
106	106
107	107
108	108
109	109
110	110
111	111
112	112
113	113
114	114
115	115
116	116
117	117
118	118
119	119
120	120
121	121
122	122
123	123
124	124
125	125
126	126
127	127
128	128
129	129
130	130
131	131
132	132
133	133
134	134
135	135
136	136
137	137
138	138
139	139
140	140
141	141
142	142
143	143
144	144
145	145
146	146
147	147
148	148
149	149
150	150
151	151
152	152
153	153
154	154
155	155
156	156
157	157
158	158
159	159
160	160
161	161
162	162
163	163
164	164
165	165
166	166
167	167
168	168
169	169
170	170
171	171
172	172
173	173
174	174
175	175
176	176
177	177
178	178
179	179
180	180
181	181
182	182
183	183
184	184
185	185
186	186
187	187
188	188
189	189
190	190
191	191
192	192
193	193
194	194
195	195
196	196
197	197
198	198
199	199
200	200
201	201
202	202
203	203
204	204
205	205
206	206
207	207
208	208
209	209
210	210
211	211
212	212
213	213
214	214
215	215
216	216
217	217
218	218
219	219
220	220
221	221
222	222
223	223
224	224
225	225
226	226
227	227
228	228
229	229
230	230
231	231
232	232
233	233
234	234
235	235
236	236
237	237
238	238
239	239
240	240
241	241
242	242
243	243
244	244
245	245
246	246
247	247
248	248
249	249
250	250
\.


--
-- TOC entry 5431 (class 0 OID 41031)
-- Dependencies: 230
-- Data for Name: DETALLE_COMPRA_INSUMOS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."DETALLE_COMPRA_INSUMOS" (id_detalle_compra, cantidad, costo, id_insumos, id_compra) FROM stdin;
1	5	59.00	1	1
2	7	31.00	2	2
3	35	46.00	3	3
4	15	78.00	4	4
5	40	98.00	5	5
6	5	77.00	6	6
7	3	17.00	7	7
8	4	65.00	8	8
9	5	21.00	9	9
10	5	4.00	10	10
11	2	10.00	11	11
12	30	6.00	12	12
13	35	10.00	13	13
14	5	82.00	14	14
15	6	5.00	15	15
16	4	44.00	16	16
17	3	65.00	17	17
18	10	8.00	18	18
19	4	26.00	19	19
20	6	18.00	20	20
21	15	61.00	21	21
22	8	39.00	22	22
23	2	22.00	23	23
24	2	21.00	24	24
25	900	23.00	25	25
26	9	78.00	26	26
27	10	7.00	27	27
28	3	14.00	28	28
29	1	41.00	29	29
30	35	75.00	30	30
31	5	19.00	31	31
32	13	56.00	32	32
33	4	38.00	33	33
34	2	60.00	34	34
35	4	75.00	35	35
36	3	2.00	36	36
37	20	68.00	37	37
38	40	20.00	38	38
39	6	36.00	39	39
40	6	77.00	40	40
41	100	78.00	41	41
42	4	95.00	42	42
43	2	97.00	43	43
44	45	93.00	44	44
45	4	26.00	45	45
46	6	66.00	46	46
47	30	46.00	47	47
48	25	61.00	48	48
49	80	6.00	49	49
50	3	45.00	50	50
51	3	3.00	51	51
52	7	20.00	52	52
53	40	54.00	53	53
54	8	44.00	54	54
55	4	43.00	55	55
56	40	46.00	56	56
57	25	87.00	57	57
58	20	18.00	58	58
59	80	11.00	59	59
60	5	73.00	60	60
61	9	8.00	61	61
62	80	27.00	62	62
63	15	43.00	63	63
64	50	6.00	64	64
65	25	16.00	65	65
66	45	68.00	66	66
67	5	63.00	67	67
68	100	27.00	68	68
69	60	77.00	69	69
70	15	14.00	70	70
71	40	46.00	71	71
72	300	84.00	72	72
73	90	61.00	73	73
74	50	19.00	74	74
75	5	99.00	75	75
76	5	69.00	76	76
77	16	29.00	77	77
78	9	88.00	78	78
79	3	20.00	79	79
80	30	21.00	80	80
81	35	69.00	81	81
82	1	13.00	82	82
83	6	26.00	83	83
84	20	94.00	84	84
85	100	86.00	85	85
86	13	19.00	86	86
87	8	39.00	87	87
88	60	48.00	88	88
89	3	42.00	89	89
90	3	42.00	90	90
91	20	26.00	91	91
92	50	83.00	92	92
93	15	55.00	93	93
94	30	28.00	94	94
95	33	68.00	95	95
96	40	72.00	96	96
97	6	83.00	97	97
98	3	97.00	98	98
99	6	64.00	99	99
100	60	53.00	100	100
101	45	28.00	101	101
102	8	39.00	102	102
103	70	4.00	103	103
104	40	55.00	104	104
105	2	57.00	105	105
106	40	4.00	106	106
107	20	97.00	107	107
108	17	46.00	108	108
109	90	20.00	109	109
110	30	4.00	110	110
111	4	71.00	111	111
112	130	74.00	112	112
113	100	92.00	113	113
114	3	63.00	114	114
115	5	5.00	115	115
116	6	60.00	116	116
117	23	45.00	117	117
118	20	71.00	118	118
119	200	81.00	119	119
120	30	90.00	120	120
121	13	68.00	121	121
122	4	50.00	122	122
123	20	45.00	123	123
124	100	26.00	124	124
125	70	27.00	125	125
126	20	66.00	126	126
127	25	17.00	127	127
128	3	11.00	128	128
129	30	32.00	129	129
130	2	57.00	130	130
131	26	81.00	131	131
132	3	18.00	132	132
133	55	60.00	133	133
134	40	63.00	134	134
135	13	23.00	135	135
136	35	21.00	136	136
137	100	81.00	137	137
138	2	60.00	138	138
139	300	81.00	139	139
140	50	30.00	140	140
141	30	26.00	141	141
142	13	28.00	142	142
143	35	12.00	143	143
144	5	53.00	144	144
145	25	15.00	145	145
146	6	95.00	146	146
147	4	94.00	147	147
148	15	28.00	148	148
149	5	46.00	149	149
150	5	60.00	150	150
151	3	41.00	151	151
152	20	52.00	152	152
153	30	16.00	153	153
154	25	33.00	154	154
155	2	91.00	155	155
156	5	71.00	156	156
157	4	71.00	157	157
158	3	85.00	158	158
159	20	94.00	159	159
160	60	69.00	160	160
161	3	29.00	161	161
162	150	26.00	162	162
163	150	67.00	163	163
164	4	18.00	164	164
165	5	79.00	165	165
166	60	34.00	166	166
167	5	90.00	167	167
168	3	37.00	168	168
169	4	37.00	169	169
170	100	25.00	170	170
171	2	55.00	171	171
172	5	32.00	172	172
173	55	49.00	173	173
174	80	75.00	174	174
175	50	27.00	175	175
176	45	60.00	176	176
177	2	20.00	177	177
178	26	10.00	178	178
179	15	71.00	179	179
180	6	76.00	180	180
181	25	83.00	181	181
182	4	73.00	182	182
183	3	83.00	183	183
184	5	61.00	184	184
185	2	54.00	185	185
186	40	10.00	186	186
187	15	41.00	187	187
188	2	57.00	188	188
189	5	35.00	189	189
190	3	92.00	190	190
191	3	67.00	191	191
192	3	65.00	192	192
193	13	48.00	193	193
194	6	38.00	194	194
195	50	80.00	195	195
196	4	97.00	196	196
197	50	27.00	197	197
198	50	36.00	198	198
199	8	25.00	199	199
200	30	32.00	200	200
201	4	11.00	201	201
202	13	78.00	202	202
203	15	2.00	203	203
204	4	64.00	204	204
205	3	13.00	205	205
206	13	47.00	206	206
207	3	60.00	207	207
208	25	66.00	208	208
209	130	58.00	209	209
210	46	72.00	210	210
211	20	66.00	211	211
212	16	25.00	212	212
213	2	50.00	213	213
214	6	2.00	214	214
215	46	65.00	215	215
216	25	29.00	216	216
217	70	45.00	217	217
218	4	28.00	218	218
219	30	79.00	219	219
220	5	7.00	220	220
221	100	22.00	221	221
222	5	69.00	222	222
223	3	4.00	223	223
224	4	94.00	224	224
225	20	69.00	225	225
226	35	90.00	226	226
227	4	19.00	227	227
228	11	72.00	228	228
229	15	85.00	229	229
230	70	31.00	230	230
231	20	53.00	231	231
232	15	53.00	232	232
233	35	97.00	233	233
234	40	45.00	234	234
235	5	54.00	235	235
236	300	14.00	236	236
237	21	66.00	237	237
238	3	14.00	238	238
239	16	44.00	239	239
240	4	46.00	240	240
241	20	34.00	241	241
242	250	44.00	242	242
243	10	15.00	243	243
244	20	71.00	244	244
245	13	49.00	245	245
246	40	42.00	246	246
247	4	20.00	247	247
248	6	94.00	248	248
249	8	66.00	249	249
250	6	40.00	250	250
\.


--
-- TOC entry 5432 (class 0 OID 41035)
-- Dependencies: 231
-- Data for Name: DETALLE_COMPRA_MOBILIARIO; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."DETALLE_COMPRA_MOBILIARIO" (id_detalle_compra_mobiliarios, cantidad, precio_unitario, subtotal, descuento, estado_entrega, id_mobiliario, id_compra) FROM stdin;
1	1	27.99	4.49	8.00	MA	1	1
2	2	14.99	79.99	5.00	KS	2	2
3	3	159.99	89.99	2.00	AR	3	3
4	4	24.99	15.99	10.00	LA	4	4
5	5	3.99	39.99	7.00	TX	5	5
6	6	5.49	14.99	12.00	FL	6	6
7	7	3.99	3.59	12.00	FL	7	7
8	8	3.29	8.49	5.00	WI	8	8
9	9	4.99	14.99	4.00	MT	9	9
10	10	8.49	19.99	7.00	LA	10	10
11	11	89.99	39.99	8.00	SC	11	11
12	12	9.99	12.99	2.00	TX	12	12
13	13	11.99	14.99	4.00	GA	13	13
14	14	22.99	49.99	15.00	NY	14	14
15	15	24.99	3.49	4.00	CA	15	15
16	16	4.99	79.99	4.00	WA	16	16
17	17	2.79	5.99	2.00	NC	17	17
18	18	3.79	6.99	6.00	NE	18	18
19	19	129.99	29.99	8.00	NY	19	19
20	20	2.99	9.99	10.00	TN	20	20
21	21	25.99	1.29	9.00	PA	21	21
22	22	69.99	3.29	15.00	MI	22	22
23	23	89.99	49.99	7.00	IL	23	23
24	24	3.99	10.99	1.00	FL	24	24
25	25	39.99	249.99	1.00	PA	25	25
26	26	39.99	12.99	7.00	VA	26	26
27	27	34.99	24.99	14.00	NC	27	27
28	28	4.29	29.99	8.00	IA	28	28
29	29	39.99	14.99	15.00	WV	29	29
30	30	2.49	9.99	14.00	NE	30	30
31	31	39.99	129.99	5.00	MI	31	31
32	32	2.49	22.99	6.00	TX	32	32
33	33	29.99	99.99	1.00	SC	33	33
34	34	3.99	29.99	13.00	CA	34	34
35	35	2.49	4.29	13.00	CA	35	35
36	36	4.49	119.99	15.00	MI	36	36
37	37	34.99	12.99	5.00	NY	37	37
38	38	22.99	4.49	8.00	CA	38	38
39	39	2.99	59.99	12.00	CA	39	39
40	40	2.89	4.49	8.00	LA	40	40
41	41	79.99	12.99	3.00	CA	41	41
42	42	29.99	2.59	1.00	TN	42	42
43	43	34.99	29.99	15.00	UT	43	43
44	44	12.99	19.99	12.00	OK	44	44
45	45	29.99	49.99	2.00	GA	45	45
46	46	19.99	3.49	5.00	CA	46	46
47	47	59.99	49.99	7.00	PA	47	47
48	48	15.99	4.49	15.00	FL	48	48
49	49	14.99	39.99	7.00	MO	49	49
50	50	149.99	3.99	6.00	TX	50	50
51	51	3.99	5.29	1.00	MI	51	51
52	52	5.99	59.99	9.00	NH	52	52
53	53	3.49	24.99	5.00	AL	53	53
54	54	89.99	19.99	7.00	NY	54	54
55	55	2.49	3.79	4.00	PA	55	55
56	56	24.99	34.99	15.00	IL	56	56
57	57	1.49	6.29	15.00	NY	57	57
58	58	4.99	49.99	9.00	MD	58	58
59	59	49.99	3.99	14.00	GA	59	59
60	60	24.99	34.99	4.00	PA	60	60
61	61	4.99	19.99	4.00	MI	61	61
62	62	4.79	39.99	3.00	CA	62	62
63	63	39.99	24.99	10.00	CA	63	63
64	64	3.49	24.99	5.00	MI	64	64
65	65	3.49	5.49	4.00	OH	65	65
66	66	5.49	299.99	8.00	TN	66	66
67	67	27.99	39.99	8.00	ME	67	67
68	68	3.49	22.99	14.00	TX	68	68
69	69	4.79	4.99	6.00	IN	69	69
70	70	59.99	3.99	1.00	MO	70	70
71	71	2.99	3.99	4.00	NJ	71	71
72	72	12.99	34.99	7.00	OH	72	72
73	73	18.99	79.99	1.00	MO	73	73
74	74	49.99	3.99	15.00	MA	74	74
75	75	9.99	149.99	7.00	IN	75	75
76	76	6.49	2.69	8.00	CT	76	76
77	77	4.99	12.99	3.00	MI	77	77
78	78	2.99	34.99	15.00	KS	78	78
79	79	4.49	9.99	10.00	NC	79	79
80	80	8.99	24.99	2.00	OH	80	80
81	81	2.79	69.99	9.00	MI	81	81
82	82	4.49	1.49	2.00	FL	82	82
83	83	3.29	3.99	5.00	TX	83	83
84	84	8.99	49.99	1.00	MA	84	84
85	85	4.99	5.99	10.00	CA	85	85
86	86	3.99	34.99	3.00	TN	86	86
87	87	1.89	3.29	12.00	OH	87	87
88	88	3.59	3.29	1.00	OK	88	88
89	89	59.99	3.99	6.00	TX	89	89
90	90	4.99	59.99	1.00	UT	90	90
91	91	49.99	59.99	12.00	WI	91	91
92	92	2.49	10.99	15.00	CO	92	92
93	93	19.99	14.99	2.00	IL	93	93
94	94	79.99	69.99	14.00	NC	94	94
95	95	19.99	7.99	12.00	WY	95	95
96	96	7.49	5.49	11.00	NY	96	96
97	97	59.99	3.49	3.00	IL	97	97
98	98	6.49	3.99	15.00	NY	98	98
99	99	24.99	29.99	14.00	ME	99	99
100	100	12.99	15.99	12.00	TN	100	100
101	101	15.99	14.99	8.00	IL	101	101
102	102	14.99	3.99	8.00	VT	102	102
103	103	4.29	34.99	6.00	LA	103	103
104	104	34.99	18.99	2.00	IL	104	104
105	105	22.99	22.99	7.00	WV	105	105
106	106	39.99	39.99	1.00	MI	106	106
107	107	3.29	129.99	1.00	MD	107	107
108	108	8.49	3.59	7.00	LA	108	108
109	109	4.79	3.99	4.00	OR	109	109
110	110	4.99	1.99	11.00	CA	110	110
111	111	2.49	2.79	8.00	FL	111	111
112	112	9.99	17.99	10.00	MA	112	112
113	113	2.49	7.99	8.00	LA	113	113
114	114	3.79	29.99	11.00	TX	114	114
115	115	9.99	1.89	2.00	TX	115	115
116	116	79.99	4.99	11.00	FL	116	116
117	117	69.99	29.99	15.00	NV	117	117
118	118	9.99	34.99	6.00	OH	118	118
119	119	3.99	4.49	2.00	PA	119	119
120	120	22.99	10.99	15.00	NC	120	120
121	121	2.99	59.99	10.00	UT	121	121
122	122	7.99	4.29	12.00	WA	122	122
123	123	2.49	3.19	2.00	TX	123	123
124	124	14.99	49.99	11.00	WV	124	124
125	125	39.99	89.99	13.00	WV	125	125
126	126	39.99	19.99	1.00	MD	126	126
127	127	49.99	3.49	5.00	MI	127	127
128	128	3.99	59.99	1.00	CA	128	128
129	129	39.99	1.89	4.00	AL	129	129
130	130	59.99	39.99	1.00	AL	130	130
131	131	99.99	12.99	6.00	IN	131	131
132	132	79.99	29.99	3.00	OH	132	132
133	133	6.99	49.99	9.00	PA	133	133
134	134	29.99	49.99	1.00	TN	134	134
135	135	4.49	299.99	8.00	LA	135	135
136	136	22.99	8.99	1.00	PA	136	136
137	137	4.49	89.99	12.00	MI	137	137
138	138	4.49	99.99	3.00	NY	138	138
139	139	34.99	49.99	12.00	NC	139	139
140	140	99.99	14.99	6.00	NC	140	140
141	141	8.49	12.99	7.00	MO	141	141
142	142	25.99	3.99	12.00	VA	142	142
143	143	5.99	25.99	10.00	CA	143	143
144	144	22.99	199.99	10.00	KY	144	144
145	145	34.99	3.69	3.00	NC	145	145
146	146	4.50	54.99	2.00	KY	146	146
147	147	2.59	3.39	4.00	OR	147	147
148	148	49.99	4.29	13.00	FL	148	148
149	149	3.69	79.99	7.00	KS	149	149
150	150	19.99	24.99	14.00	NY	150	150
151	151	2.99	29.99	14.00	KS	151	151
152	152	29.99	24.99	3.00	TN	152	152
153	153	14.99	24.99	11.00	WA	153	153
154	154	3.49	2.99	3.00	TX	154	154
155	155	24.99	4.99	11.00	IN	155	155
156	156	2.49	5.49	2.00	FL	156	156
157	157	4.99	29.99	11.00	PR	157	157
158	158	34.99	12.99	14.00	WA	158	158
159	159	14.99	3.99	2.00	PA	159	159
160	160	2.79	29.99	15.00	NC	160	160
161	161	12.99	99.99	8.00	CA	161	161
162	162	12.99	22.99	1.00	KY	162	162
163	163	34.99	5.99	9.00	NY	163	163
164	164	39.99	39.99	15.00	FL	164	164
165	165	54.99	5.99	10.00	IN	165	165
166	166	2.79	59.99	9.00	AL	166	166
167	167	9.99	29.99	2.00	MI	167	167
168	168	3.49	89.99	8.00	TX	168	168
169	169	2.99	1.99	4.00	UT	169	169
170	170	2.29	12.99	14.00	AK	170	170
171	171	59.99	6.99	2.00	CA	171	171
172	172	34.99	2.99	14.00	NC	172	172
173	173	39.99	3.99	6.00	WA	173	173
174	174	24.99	3.49	1.00	WI	174	174
175	175	2.19	39.99	7.00	WA	175	175
176	176	39.99	3.49	5.00	PA	176	176
177	177	10.99	34.99	9.00	IL	177	177
178	178	3.49	34.99	10.00	NY	178	178
179	179	5.49	24.99	7.00	OR	179	179
180	180	4.29	99.99	3.00	DC	180	180
181	181	24.99	129.99	6.00	TX	181	181
182	182	44.99	3.29	9.00	RI	182	182
183	183	4.49	49.99	13.00	MA	183	183
184	184	2.50	39.99	1.00	GA	184	184
185	185	24.99	89.99	12.00	TN	185	185
186	186	24.99	49.99	15.00	NJ	186	186
187	187	1.99	18.99	1.00	MA	187	187
188	188	3.49	3.99	7.00	OH	188	188
189	189	24.99	0.79	9.00	WV	189	189
190	190	89.99	299.99	1.00	MI	190	190
191	191	149.99	39.99	12.00	WI	191	191
192	192	4.49	79.99	9.00	PA	192	192
193	193	29.99	9.99	12.00	NV	193	193
194	194	29.99	1.99	14.00	IL	194	194
195	195	19.99	14.99	5.00	TX	195	195
196	196	59.99	19.99	7.00	NY	196	196
197	197	24.99	1.29	1.00	HI	197	197
198	198	19.99	22.99	7.00	CA	198	198
199	199	6.49	3.99	11.00	TX	199	199
200	200	24.99	299.99	12.00	WA	200	200
201	201	12.99	5.49	12.00	MO	201	201
202	202	49.99	4.49	15.00	WI	202	202
203	203	24.99	49.99	10.00	NE	203	203
204	204	9.99	3.99	13.00	VT	204	204
205	205	5.29	29.99	2.00	IL	205	205
206	206	1.99	69.99	5.00	NY	206	206
207	207	39.99	12.99	15.00	IL	207	207
208	208	2.29	19.99	13.00	MS	208	208
209	209	15.99	3.79	6.00	IL	209	209
210	210	39.99	59.99	8.00	FL	210	210
211	211	49.99	39.99	14.00	FL	211	211
212	212	3.29	25.99	2.00	TX	212	212
213	213	6.99	12.99	15.00	IL	213	213
214	214	6.49	14.99	1.00	AK	214	214
215	215	49.99	2.99	15.00	AL	215	215
216	216	3.49	4.59	6.00	PA	216	216
217	217	199.99	4.99	10.00	CA	217	217
218	218	39.99	19.99	3.00	TN	218	218
219	219	2.49	5.29	15.00	IA	219	219
220	220	34.99	1.99	6.00	WV	220	220
221	221	3.29	34.99	7.00	IN	221	221
222	222	29.99	19.99	4.00	TX	222	222
223	223	24.99	29.99	4.00	CO	223	223
224	224	2.49	5.49	10.00	FL	224	224
225	225	49.99	29.99	12.00	TN	225	225
226	226	39.99	29.99	4.00	TX	226	226
227	227	39.99	29.99	15.00	PA	227	227
228	228	79.99	22.99	7.00	LA	228	228
229	229	3.29	19.99	7.00	IN	229	229
230	230	2.79	12.99	4.00	CA	230	230
231	231	2.99	8.99	12.00	FL	231	231
232	232	27.99	49.99	9.00	MS	232	232
233	233	29.99	5.49	4.00	GA	233	233
234	234	79.99	24.99	3.00	IL	234	234
235	235	22.99	14.99	1.00	MD	235	235
236	236	6.49	49.99	6.00	NC	236	236
237	237	5.49	6.49	9.00	IL	237	237
238	238	2.29	29.99	15.00	OK	238	238
239	239	19.99	39.99	13.00	MS	239	239
240	240	19.99	39.99	7.00	LA	240	240
241	241	24.99	2.99	6.00	MI	241	241
242	242	3.79	22.99	14.00	MI	242	242
243	243	99.99	59.99	5.00	DE	243	243
244	244	19.99	4.99	11.00	NH	244	244
245	245	149.99	2.89	10.00	MI	245	245
246	246	18.99	5.99	7.00	LA	246	246
247	247	1.99	79.99	6.00	IN	247	247
248	248	29.99	49.99	15.00	NC	248	248
249	249	2.99	7.99	6.00	FL	249	249
250	250	15.99	3.49	3.00	MS	250	250
\.


--
-- TOC entry 5433 (class 0 OID 41039)
-- Dependencies: 232
-- Data for Name: DETALLE_FACTURA; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."DETALLE_FACTURA" (id_detalle_factura, concepto, id_factura, id_pago, cantidad, precio_unitario, subtotal) FROM stdin;
1	Supervisor	1	1	63	82	30
2	Project Manager	2	2	67	44	77
3	Construction Foreman	3	3	83	3	92
4	Construction Foreman	4	4	88	29	96
5	Construction Foreman	5	5	43	83	78
6	Project Manager	6	6	48	61	31
7	Architect	7	7	8	30	52
8	Construction Foreman	8	8	53	16	34
9	Construction Expeditor	9	9	27	17	72
10	Project Manager	10	10	46	4	17
11	Engineer	11	11	77	50	46
12	Engineer	12	12	84	57	83
13	Surveyor	13	13	13	49	96
14	Project Manager	14	14	46	57	1
15	Estimator	15	15	21	87	27
16	Electrician	16	16	88	92	83
17	Construction Worker	17	17	4	97	88
18	Construction Manager	18	18	37	20	84
19	Electrician	19	19	1	57	36
20	Subcontractor	20	20	17	16	38
21	Construction Expeditor	21	21	2	78	54
22	Construction Worker	22	22	3	46	14
23	Electrician	23	23	1	76	59
24	Electrician	24	24	64	35	9
25	Surveyor	25	25	16	47	8
26	Construction Manager	26	26	73	57	54
27	Electrician	27	27	70	23	43
28	Engineer	28	28	53	54	85
29	Construction Manager	29	29	11	55	81
30	Surveyor	30	30	90	37	91
31	Construction Worker	31	31	45	17	86
32	Surveyor	32	32	17	12	69
33	Construction Expeditor	33	33	68	87	53
34	Engineer	34	34	64	93	42
35	Construction Worker	35	35	20	78	39
36	Estimator	36	36	60	36	44
37	Construction Expeditor	37	37	40	70	72
38	Architect	38	38	18	72	12
39	Supervisor	39	39	8	16	36
40	Supervisor	40	40	53	6	68
41	Surveyor	41	41	25	8	74
42	Subcontractor	42	42	29	54	97
43	Construction Foreman	43	43	91	91	56
44	Engineer	44	44	65	72	20
45	Architect	45	45	47	32	94
46	Construction Foreman	46	46	75	95	15
47	Electrician	47	47	64	93	22
48	Supervisor	48	48	83	77	55
49	Construction Manager	49	49	26	45	18
50	Construction Expeditor	50	50	99	89	26
51	Surveyor	51	51	44	81	65
52	Estimator	52	52	45	41	55
53	Subcontractor	53	53	69	91	54
54	Construction Worker	54	54	30	98	7
55	Project Manager	55	55	95	82	51
56	Project Manager	56	56	83	56	44
57	Surveyor	57	57	60	55	44
58	Construction Expeditor	58	58	98	68	48
59	Estimator	59	59	6	30	24
60	Project Manager	60	60	82	38	9
61	Construction Manager	61	61	86	75	71
62	Engineer	62	62	96	67	64
63	Supervisor	63	63	7	66	97
64	Architect	64	64	65	47	70
65	Project Manager	65	65	53	47	33
66	Architect	66	66	70	17	4
67	Construction Foreman	67	67	27	85	46
68	Subcontractor	68	68	99	98	74
69	Supervisor	69	69	14	9	70
70	Surveyor	70	70	35	69	73
71	Engineer	71	71	16	5	61
72	Estimator	72	72	74	34	35
73	Subcontractor	73	73	19	90	67
74	Project Manager	74	74	59	23	45
75	Construction Foreman	75	75	9	34	30
76	Supervisor	76	76	23	96	2
77	Architect	77	77	51	68	25
78	Supervisor	78	78	36	6	12
79	Project Manager	79	79	54	38	47
80	Architect	80	80	91	20	36
81	Construction Foreman	81	81	10	22	94
82	Project Manager	82	82	36	59	27
83	Construction Worker	83	83	11	71	89
84	Construction Manager	84	84	59	31	84
85	Construction Worker	85	85	7	60	36
86	Project Manager	86	86	42	36	52
87	Architect	87	87	84	12	40
88	Surveyor	88	88	53	36	96
89	Engineer	89	89	41	97	32
90	Subcontractor	90	90	23	37	81
91	Subcontractor	91	91	38	64	46
92	Project Manager	92	92	63	22	57
93	Supervisor	93	93	1	89	77
94	Construction Worker	94	94	79	81	56
95	Estimator	95	95	77	6	70
96	Surveyor	96	96	11	41	99
97	Surveyor	97	97	16	62	14
98	Construction Worker	98	98	7	26	87
99	Estimator	99	99	39	1	27
100	Construction Expeditor	100	100	30	96	97
101	Construction Expeditor	101	101	43	55	52
102	Architect	102	102	80	37	76
103	Construction Foreman	103	103	38	94	52
104	Estimator	104	104	18	95	45
105	Construction Worker	105	105	61	34	50
106	Construction Foreman	106	106	20	82	34
107	Project Manager	107	107	91	82	1
108	Engineer	108	108	73	21	27
109	Supervisor	109	109	77	3	59
110	Surveyor	110	110	91	85	34
111	Construction Manager	111	111	52	2	67
112	Construction Expeditor	112	112	56	78	3
113	Project Manager	113	113	83	37	65
114	Electrician	114	114	65	5	27
115	Subcontractor	115	115	4	71	55
116	Engineer	116	116	97	49	86
117	Construction Worker	117	117	36	65	25
118	Project Manager	118	118	77	51	38
119	Surveyor	119	119	13	59	62
120	Engineer	120	120	10	16	40
121	Electrician	121	121	30	62	92
122	Surveyor	122	122	58	73	28
123	Estimator	123	123	55	45	85
124	Engineer	124	124	34	9	45
125	Estimator	125	125	92	36	42
126	Supervisor	126	126	32	69	32
127	Project Manager	127	127	93	80	5
128	Construction Expeditor	128	128	12	47	9
129	Subcontractor	129	129	8	93	64
130	Construction Expeditor	130	130	78	55	68
131	Construction Expeditor	131	131	10	13	91
132	Construction Foreman	132	132	13	42	97
133	Project Manager	133	133	52	38	24
134	Surveyor	134	134	88	35	71
135	Construction Worker	135	135	11	56	47
136	Construction Manager	136	136	92	31	90
137	Construction Manager	137	137	32	21	54
138	Electrician	138	138	95	64	43
139	Surveyor	139	139	6	61	53
140	Construction Expeditor	140	140	44	29	72
141	Architect	141	141	63	30	37
142	Architect	142	142	22	60	26
143	Estimator	143	143	73	44	89
144	Estimator	144	144	29	92	59
145	Engineer	145	145	37	17	45
146	Construction Manager	146	146	21	1	3
147	Subcontractor	147	147	2	61	88
148	Electrician	148	148	38	67	45
149	Construction Expeditor	149	149	25	96	73
150	Architect	150	150	51	76	2
151	Construction Manager	151	151	46	79	90
152	Construction Worker	152	152	62	36	38
153	Engineer	153	153	82	52	90
154	Project Manager	154	154	29	85	1
155	Estimator	155	155	10	74	59
156	Estimator	156	156	69	54	92
157	Architect	157	157	3	74	85
158	Construction Worker	158	158	77	40	38
159	Project Manager	159	159	11	71	61
160	Construction Worker	160	160	41	36	15
161	Project Manager	161	161	24	66	25
162	Surveyor	162	162	20	36	20
163	Construction Expeditor	163	163	27	72	18
164	Engineer	164	164	40	95	25
165	Construction Worker	165	165	71	7	98
166	Surveyor	166	166	18	75	35
167	Construction Expeditor	167	167	11	41	68
168	Electrician	168	168	18	7	77
169	Subcontractor	169	169	89	31	42
170	Construction Worker	170	170	60	45	84
171	Surveyor	171	171	23	57	74
172	Estimator	172	172	16	75	18
173	Subcontractor	173	173	14	33	61
174	Construction Expeditor	174	174	20	94	72
175	Construction Manager	175	175	65	11	97
176	Electrician	176	176	78	81	19
177	Project Manager	177	177	23	4	27
178	Construction Manager	178	178	63	39	11
179	Surveyor	179	179	58	32	29
180	Electrician	180	180	90	73	65
181	Construction Expeditor	181	181	26	22	66
182	Electrician	182	182	80	48	22
183	Construction Foreman	183	183	65	10	35
184	Surveyor	184	184	59	26	21
185	Electrician	185	185	13	57	30
186	Construction Manager	186	186	74	44	56
187	Engineer	187	187	76	40	91
188	Electrician	188	188	52	57	14
189	Electrician	189	189	65	49	96
190	Architect	190	190	54	74	29
191	Surveyor	191	191	33	19	66
192	Electrician	192	192	38	62	90
193	Construction Expeditor	193	193	47	37	69
194	Subcontractor	194	194	9	30	90
195	Surveyor	195	195	86	17	86
196	Construction Expeditor	196	196	30	52	83
197	Construction Foreman	197	197	10	34	62
198	Subcontractor	198	198	97	53	80
199	Subcontractor	199	199	31	48	49
200	Construction Worker	200	200	75	51	78
201	Surveyor	201	201	62	74	74
202	Subcontractor	202	202	80	79	9
203	Construction Foreman	203	203	92	83	59
204	Construction Worker	204	204	62	15	51
205	Architect	205	205	77	40	82
206	Engineer	206	206	53	94	72
207	Engineer	207	207	92	72	94
208	Construction Expeditor	208	208	3	62	45
209	Construction Expeditor	209	209	62	46	42
210	Construction Expeditor	210	210	41	82	53
211	Construction Manager	211	211	22	77	76
212	Construction Worker	212	212	31	62	34
213	Estimator	213	213	10	34	2
214	Construction Manager	214	214	12	43	16
215	Supervisor	215	215	35	22	11
216	Subcontractor	216	216	8	82	15
217	Engineer	217	217	49	63	96
218	Architect	218	218	17	32	13
219	Architect	219	219	86	94	15
220	Construction Manager	220	220	37	72	5
221	Construction Worker	221	221	30	43	96
222	Construction Expeditor	222	222	14	7	85
223	Project Manager	223	223	86	61	97
224	Construction Manager	224	224	56	96	76
225	Construction Manager	225	225	51	75	6
226	Surveyor	226	226	88	50	99
227	Engineer	227	227	21	22	68
228	Surveyor	228	228	26	87	39
229	Construction Manager	229	229	68	39	11
230	Supervisor	230	230	25	13	1
231	Construction Manager	231	231	19	12	79
232	Project Manager	232	232	51	74	81
233	Estimator	233	233	13	1	37
234	Engineer	234	234	13	41	29
235	Construction Expeditor	235	235	72	17	83
236	Project Manager	236	236	80	47	6
237	Architect	237	237	44	42	6
238	Electrician	238	238	12	57	63
239	Architect	239	239	30	27	45
240	Architect	240	240	78	99	9
241	Engineer	241	241	59	84	4
242	Subcontractor	242	242	90	2	76
243	Construction Manager	243	243	81	29	74
244	Project Manager	244	244	61	41	69
245	Construction Worker	245	245	49	11	5
246	Construction Worker	246	246	82	1	7
247	Surveyor	247	247	72	39	50
248	Supervisor	248	248	57	26	57
249	Estimator	249	249	88	94	22
250	Supervisor	250	250	33	1	91
\.


--
-- TOC entry 5434 (class 0 OID 41043)
-- Dependencies: 233
-- Data for Name: DETALLE_PEDIDO_PROVEEDOR; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."DETALLE_PEDIDO_PROVEEDOR" (id_detalle_pedido_proveedor, producto, cantidad, precio_unitario, id_pedido_proveedor) FROM stdin;
1	Brussels Sprouts	3	98.00	1
2	Garlic Herb Seasoning	2	13.00	2
3	Matcha Green Tea Powder	15	17.00	3
4	Essential White Button-Up	45	55.00	4
5	Coffee Capsule Dispenser	25	77.00	5
6	Insulated Lunch Box	25	54.00	6
7	Rustic Wooden Picture Frame	20	26.00	7
8	Puzzle 3D Model Kit	23	28.00	8
9	Bock Beer Mustard	2	49.00	9
10	Laundry Detergent	13	28.00	10
11	Home Cleaning Robot	250	98.00	11
12	Savory Trail Mix	4	43.00	12
13	Tandoori Chicken Skewers	8	91.00	13
14	Yoga Mat	25	67.00	14
15	Pest Control Traps	23	71.00	15
16	Chocolate Chip Cliff Bars	2	75.00	16
17	Car Windshield Sun Shade	20	36.00	17
18	Mayonnaise	3	36.00	18
19	Outdoor Mosquito Repellent Lantern	35	24.00	19
20	Truffle Parmesan Fries	5	18.00	20
21	Two-Tone Windbreaker	60	72.00	21
22	Multi-Layer Food Steamer	40	14.00	22
23	Protein Pancake Mix	4	82.00	23
24	Organic Quinoa	4	70.00	24
25	Wireless Smart Plug	20	41.00	25
26	Smart Wi-Fi Light Bulbs	20	55.00	26
27	Ice Pack	9	79.00	27
28	Patterned Knit Scarf	26	34.00	28
29	Pork Tenderloin	11	99.00	29
30	Fleece Lined Leggings	30	97.00	30
31	Plant Pot Drip Trays	10	92.00	31
32	Classic Cheeseburger Mix	5	75.00	32
33	Cacao Powder	4	81.00	33
34	Green Tea Matcha Powder	16	40.00	34
35	Nutty Quinoa Salad	5	89.00	35
36	Mini Projector	170	96.00	36
37	Crispy Rice Treats	4	58.00	37
38	Electric Meat Grinder	90	31.00	38
39	Organic Granola	5	76.00	39
40	Peanut Butter Cookies	3	79.00	40
41	LED Christmas Tree Lights	35	64.00	41
42	Bird Feeder	25	29.00	42
43	Smashed Avocado with Lime	2	91.00	43
44	Cable Knit Cardigan	50	58.00	44
45	Snack Container Set	20	22.00	45
46	Puzzle	28	38.00	46
47	Dish Soap Dispenser	19	37.00	47
48	Adjustable Dumbbells	250	49.00	48
49	Low-Fat Cottage Cheese	3	72.00	49
50	Savory Oatmeal Cups	2	12.00	50
51	Incense Holder	15	67.00	51
52	Roasted Garlic Pasta Sauce	5	54.00	52
53	Lasagna Noodles	2	42.00	53
54	Electric Griddle	55	79.00	54
55	Maple Almond Butter	5	48.00	55
56	Sweet Potatoes (organic)	2	78.00	56
57	Classic White T-Shirt	20	73.00	57
58	Chocolate Raspberry Tart	10	88.00	58
59	Cauliflower Rice Stir-Fry	5	84.00	59
60	Herbed Goat Cheese	5	52.00	60
61	Dried Mango Slices	3	98.00	61
62	Pet Travel Bed	27	84.00	62
63	Hiking Water Bottle with Filter	30	12.00	63
64	Vegetable Potstickers	6	68.00	64
65	Spicy Hummus	3	85.00	65
66	Frozen Burritos	9	30.00	66
67	Classic Slim Fit Shirt	50	20.00	67
68	Pineapple Salsa	4	23.00	68
69	Lentil Soup (canned)	2	53.00	69
70	Electric Knife	40	31.00	70
71	Cabbage	1	37.00	71
72	Graphic Tee	20	15.00	72
73	Strawberry Fruit Spread	4	54.00	73
74	Knitted Infinity Scarf	30	41.00	74
75	Interchangeable Watch Bands	25	40.00	75
76	Butternut Squash Ravioli	6	77.00	76
77	Classic Pesto Sauce	4	34.00	77
78	Plant Watering Spikes	13	92.00	78
79	Chunky Knit Sweater	60	86.00	79
80	Almond Flour Biscuits	6	68.00	80
81	Pasta Maker Machine	60	32.00	81
82	Whole Wheat Pasta	2	69.00	82
83	Digital Food Scale	23	57.00	83
84	Vegan Mac & Cheese	9	93.00	84
85	Buffalo Chicken Wraps	6	70.00	85
86	Orange Ginger Vinaigrette	4	73.00	86
87	Mini Indoor Hydroponic Garden	60	70.00	87
88	Beard Grooming Kit	35	33.00	88
89	Insulated Lunch Box	25	16.00	89
90	Organic Black Rice	4	60.00	90
91	Frozen Chicken Nuggets	4	77.00	91
92	Wall-Mounted Spice Rack	40	25.00	92
93	Garlic Herb Marinade	3	97.00	93
94	Collapsible Water Bottle	13	50.00	94
95	Gluten-Free Pancake Mix	6	50.00	95
96	Pizza Stone	30	44.00	96
97	Savory Mushroom Risotto	6	72.00	97
98	Tea Set with Infuser	35	51.00	98
99	Dried Mango Slices	3	32.00	99
100	Pasta Salad Kit	6	92.00	100
101	Cream Cheese	3	29.00	101
102	Eco-Friendly Cleaning Cloths	13	60.00	102
103	Portable Solar Charger	30	17.00	103
104	Peanut Butter Banana Smoothie	4	92.00	104
105	Glass Food Containers	35	33.00	105
106	Electric Nail File Kit	35	40.00	106
107	Window Blinds	60	88.00	107
108	Key Finder	20	78.00	108
109	Basketball	30	84.00	109
110	Spinach and Cheese Quiche	5	94.00	110
111	Teriyaki Tofu Stir-Fry	7	47.00	111
112	Indoor Grill	60	28.00	112
113	Car Sunshade	20	46.00	113
114	Whole Wheat Pita Bread	3	72.00	114
115	Indestructible Dog Toy	16	86.00	115
116	Cocktail Shaker and Mixing Glass Set	40	76.00	116
117	Eco-Friendly Stainless Steel Straws	13	89.00	117
118	Collapsible Colander	15	49.00	118
119	Italian Pasta	2	33.00	119
120	Samoas Cookie Mix	6	97.00	120
121	LED Desk Light	35	90.00	121
122	Solar Charger	40	65.00	122
123	Watering Can with Nozzle	20	16.00	123
124	Multi-Purpose Marine Rope	20	12.00	124
125	Artisan Cornbread Mix	2	18.00	125
126	Running Shorts	35	16.00	126
127	Electric Butter Churn	50	22.00	127
128	Smart Plug	20	76.00	128
129	Sweet Potato Noodles	4	70.00	129
130	Durable Hiking Boots	90	15.00	130
131	Wireless HDMI Transmitter	80	20.00	131
132	Pet Hair Remover	10	33.00	132
133	Memory Foam Mattress Topper	110	94.00	133
134	Car Diagnostic Scanner	50	80.00	134
135	Mixed Nuts	6	20.00	135
136	Mini Hand Gesture Drone	30	84.00	136
137	Over-The-Door Shoe Organizer	26	88.00	137
138	Rice Cakes	2	73.00	138
139	Hand Crank Blender	19	54.00	139
140	Hot Salsa	2	78.00	140
141	Silicone Baking Mat	16	74.00	141
142	Smartphone Stand	15	37.00	142
143	Frozen Vegetarian Pizza	6	75.00	143
144	Insulated Lunch Box	25	88.00	144
145	Pepperoni Pizza Rolls	7	27.00	145
146	Cilantro Lime Rice	3	92.00	146
147	Sketchbook	15	35.00	147
148	Creamy Spinach Dip	6	83.00	148
149	Traditional Hummus	3	93.00	149
150	Avocado Oil	8	23.00	150
151	Cauliflower Crust Pizza	8	18.00	151
152	Chocolate Avocado Pudding	5	22.00	152
153	Car Escape Tool	13	70.00	153
154	Puzzle Game Set	35	16.00	154
155	Outdoor String Lights	25	91.00	155
156	Tea Infuser Bottle	20	13.00	156
157	Sustainable Wooden Toys	30	81.00	157
158	Chocolate Chip Pancake Mix	4	50.00	158
159	Cream Cheese	3	70.00	159
160	Green Smoothie Mix	6	25.00	160
161	Honey Butter Popcorn	3	17.00	161
162	Kid's Fruit Snacks	2	93.00	162
163	Smart Home Hub	100	10.00	163
164	Cranberry Citrus Sauce	4	89.00	164
165	Apple Cinnamon Breakfast Muffins	3	12.00	165
166	Maxi Wrap Dress	50	32.00	166
167	Fleece Throw Blanket	30	80.00	167
168	Teriyaki Chicken Bowl	6	57.00	168
169	Cinnamon Raisin Bread	4	33.00	169
170	Home Karaoke System	130	57.00	170
171	Almond Coconut Granola	4	20.00	171
172	Free-Range Eggs	4	71.00	172
173	Electric Kettle	40	31.00	173
174	Chocolate Chip Cookie Mix	2	80.00	174
175	Air Fryer Oven	150	63.00	175
176	Ergonomic Gaming Chair	200	93.00	176
177	Pretzel Bites	5	30.00	177
178	Berries Medley	7	69.00	178
179	Spinach and Cheese Quiche	5	56.00	179
180	Ramen Noodles	1	33.00	180
181	Raspberry Vanilla Greek Yogurt	3	42.00	181
182	Insulated Sport Tumbler	23	77.00	182
183	Foam Muscle Roller	25	41.00	183
184	Cinnamon Roll Protein Bar	3	32.00	184
185	Fruit Infuser Water Bottle	16	21.00	185
186	Herb Drying Rack	23	24.00	186
187	Leek and Potato Soup	3	92.00	187
188	Maple Almond Butter	5	91.00	188
189	Rechargeable Electric Screwdriver	40	67.00	189
190	Wire Shelving Unit	70	82.00	190
191	Mixed Nuts	6	36.00	191
192	Granola Bars	5	99.00	192
193	Running Shorts	35	62.00	193
194	Puzzle	28	67.00	194
195	Kids' Activity Book	15	48.00	195
196	Dried Fruit Medley	5	43.00	196
197	Magnetic Chess Set	20	18.00	197
198	Italian Sausage and Peppers	9	66.00	198
199	Chocolate Chip Pancake Mix	4	25.00	199
200	Chili Powder	2	96.00	200
201	Adjustable Window Blind	50	93.00	201
202	Wooden Kitchen Utensil Set	20	37.00	202
203	Beach Cover-Up	30	74.00	203
204	Children's Art Set	35	28.00	204
205	Honey Butter Popcorn	3	94.00	205
206	Bamboo Cutting Board Set	35	98.00	206
207	Compact Hair Dryer	30	43.00	207
208	Apple Cinnamon Instant Oatmeal	3	75.00	208
209	Portable Speakers	70	41.00	209
210	Coconut Milk	2	12.00	210
211	Kale & Quinoa Salad Mix	4	36.00	211
212	Bluetooth Sleep Headphones	30	80.00	212
213	Cotton Pajama Set	50	45.00	213
214	Stainless Steel Mixing Bowls	30	56.00	214
215	Memory Foam Mattress Pad	70	50.00	215
216	Travel Laundry Bag	10	12.00	216
217	Tailored Dress Pants	80	60.00	217
218	Plant-Based Cookbook	30	88.00	218
219	Pasta Primavera Kit	7	82.00	219
220	Electric Knife	40	64.00	220
221	Cushion Covers	35	78.00	221
222	Honey Roasted Almonds	5	70.00	222
223	Puzzle	28	94.00	223
224	Pumpkin Spice Granola	5	95.00	224
225	Organic Quinoa Chips	4	59.00	225
226	Spicy Kimchi	5	40.00	226
227	Sliced Turkey Breast	5	40.00	227
228	Organic Coconut Oil	9	23.00	228
229	Dill Pickle Chips	2	73.00	229
230	Biodegradable Trash Bags	13	67.00	230
231	Portable Projector	200	58.00	231
232	Kids' Gardening Tools Set	23	59.00	232
233	Vegetarian Stuffed Peppers	5	83.00	233
234	Pet Grooming Scissors	17	39.00	234
235	Streaming Device	50	70.00	235
236	Wireless Keyboard and Mouse Combo	35	10.00	236
237	Reusable Food Storage Bags	20	22.00	237
238	Cranberry Pecan Granola	4	87.00	238
239	Skincare Fridge	40	16.00	239
240	Puzzle	28	41.00	240
241	Wireless HDMI Transmitter	80	76.00	241
242	Honey Sesame Chicken	9	26.00	242
243	Kids' Outdoor Explorer Kit	25	35.00	243
244	Whole Wheat Pita Bread	3	51.00	244
245	Spicy Tuna Rolls	6	84.00	245
246	Mango Chunks	5	20.00	246
247	Portable Pet Pooper Scooper	13	59.00	247
248	Foot Massager	80	87.00	248
249	Chili Lime Corn Chips	3	28.00	249
250	Cinnamon Raisin Bread	4	52.00	250
\.


--
-- TOC entry 5435 (class 0 OID 41046)
-- Dependencies: 234
-- Data for Name: DETALLE_PLATILLO; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."DETALLE_PLATILLO" (id_detalles_platillo, cantidad, id_platillo, id_insumos) FROM stdin;
1	18	1	1
2	18	2	2
3	16	3	3
4	9	4	4
5	24	5	5
6	6	6	6
7	2	7	7
8	22	8	8
9	30	9	9
10	21	10	10
11	29	11	11
12	28	12	12
13	2	13	13
14	3	14	14
15	3	15	15
16	23	16	16
17	19	17	17
18	25	18	18
19	24	19	19
20	1	20	20
21	19	21	21
22	27	22	22
23	12	23	23
24	2	24	24
25	22	25	25
26	27	26	26
27	8	27	27
28	6	28	28
29	25	29	29
30	12	30	30
31	11	31	31
32	16	32	32
33	17	33	33
34	27	34	34
35	20	35	35
36	16	36	36
37	28	37	37
38	7	38	38
39	25	39	39
40	6	40	40
41	29	41	41
42	8	42	42
43	11	43	43
44	29	44	44
45	12	45	45
46	27	46	46
47	11	47	47
48	22	48	48
49	5	49	49
50	22	50	50
51	4	51	51
52	25	52	52
53	27	53	53
54	23	54	54
55	15	55	55
56	5	56	56
57	25	57	57
58	25	58	58
59	9	59	59
60	8	60	60
61	29	61	61
62	30	62	62
63	4	63	63
64	20	64	64
65	17	65	65
66	10	66	66
67	3	67	67
68	19	68	68
69	19	69	69
70	21	70	70
71	17	71	71
72	23	72	72
73	16	73	73
74	3	74	74
75	2	75	75
76	18	76	76
77	27	77	77
78	29	78	78
79	22	79	79
80	18	80	80
81	9	81	81
82	19	82	82
83	25	83	83
84	12	84	84
85	8	85	85
86	20	86	86
87	29	87	87
88	1	88	88
89	24	89	89
90	8	90	90
91	26	91	91
92	5	92	92
93	14	93	93
94	30	94	94
95	23	95	95
96	5	96	96
97	6	97	97
98	8	98	98
99	18	99	99
100	17	100	100
101	21	101	101
102	7	102	102
103	21	103	103
104	21	104	104
105	25	105	105
106	8	106	106
107	20	107	107
108	11	108	108
109	4	109	109
110	26	110	110
111	24	111	111
112	22	112	112
113	22	113	113
114	24	114	114
115	4	115	115
116	23	116	116
117	14	117	117
118	11	118	118
119	6	119	119
120	11	120	120
121	6	121	121
122	16	122	122
123	20	123	123
124	13	124	124
125	2	125	125
126	26	126	126
127	16	127	127
128	7	128	128
129	10	129	129
130	19	130	130
131	21	131	131
132	9	132	132
133	20	133	133
134	12	134	134
135	20	135	135
136	16	136	136
137	22	137	137
138	4	138	138
139	5	139	139
140	20	140	140
141	27	141	141
142	18	142	142
143	9	143	143
144	24	144	144
145	16	145	145
146	8	146	146
147	30	147	147
148	1	148	148
149	26	149	149
150	10	150	150
151	23	151	151
152	23	152	152
153	17	153	153
154	24	154	154
155	21	155	155
156	16	156	156
157	25	157	157
158	4	158	158
159	20	159	159
160	13	160	160
161	11	161	161
162	23	162	162
163	18	163	163
164	21	164	164
165	21	165	165
166	12	166	166
167	25	167	167
168	25	168	168
169	19	169	169
170	15	170	170
171	22	171	171
172	4	172	172
173	19	173	173
174	8	174	174
175	27	175	175
176	2	176	176
177	11	177	177
178	24	178	178
179	22	179	179
180	7	180	180
181	30	181	181
182	1	182	182
183	28	183	183
184	3	184	184
185	4	185	185
186	26	186	186
187	27	187	187
188	19	188	188
189	22	189	189
190	27	190	190
191	19	191	191
192	30	192	192
193	25	193	193
194	19	194	194
195	3	195	195
196	13	196	196
197	14	197	197
198	26	198	198
199	9	199	199
200	6	200	200
201	30	201	201
202	1	202	202
203	2	203	203
204	8	204	204
205	6	205	205
206	14	206	206
207	7	207	207
208	27	208	208
209	27	209	209
210	26	210	210
211	9	211	211
212	24	212	212
213	26	213	213
214	2	214	214
215	27	215	215
216	18	216	216
217	14	217	217
218	11	218	218
219	27	219	219
220	18	220	220
221	4	221	221
222	1	222	222
223	18	223	223
224	28	224	224
225	5	225	225
226	28	226	226
227	22	227	227
228	6	228	228
229	21	229	229
230	19	230	230
231	15	231	231
232	13	232	232
233	26	233	233
234	14	234	234
235	4	235	235
236	12	236	236
237	26	237	237
238	15	238	238
239	25	239	239
240	5	240	240
241	7	241	241
242	18	242	242
243	5	243	243
244	13	244	244
245	4	245	245
246	2	246	246
247	5	247	247
248	4	248	248
249	16	249	249
250	18	250	250
\.


--
-- TOC entry 5436 (class 0 OID 41049)
-- Dependencies: 235
-- Data for Name: DETALLE_SERVICIO_HABITACION; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."DETALLE_SERVICIO_HABITACION" (id_detalle_servicio_habitacion, fecha, total, id_clientes, id_servicio_habitacion, id_platillo) FROM stdin;
1	2025-06-27 00:00:00-06	3	1	1	1
2	2025-05-27 00:00:00-06	4	2	2	2
3	2025-08-17 00:00:00-06	40	3	3	3
4	2024-12-02 00:00:00-06	6	4	4	4
5	2025-08-02 00:00:00-06	25	5	5	5
6	2025-01-20 00:00:00-06	20	6	6	6
7	2025-03-05 00:00:00-06	20	7	7	7
8	2025-08-10 00:00:00-06	4	8	8	8
9	2024-12-28 00:00:00-06	3	9	9	9
10	2025-08-10 00:00:00-06	2	10	10	10
11	2025-01-08 00:00:00-06	40	11	11	11
12	2025-09-12 00:00:00-06	80	12	12	12
13	2025-07-16 00:00:00-06	5	13	13	13
14	2025-09-13 00:00:00-06	7	14	14	14
15	2025-07-08 00:00:00-06	4	15	15	15
16	2024-12-11 00:00:00-06	4	16	16	16
17	2025-03-12 00:00:00-06	50	17	17	17
18	2025-05-04 00:00:00-06	30	18	18	18
19	2024-10-28 00:00:00-06	25	19	19	19
20	2025-03-13 00:00:00-06	70	20	20	20
21	2025-05-13 00:00:00-06	15	21	21	21
22	2025-06-05 00:00:00-06	30	22	22	22
23	2025-07-08 00:00:00-06	3	23	23	23
24	2025-05-12 00:00:00-06	15	24	24	24
25	2025-04-04 00:00:00-06	4	25	25	25
26	2025-01-19 00:00:00-06	90	26	26	26
27	2025-04-26 00:00:00-06	90	27	27	27
28	2024-12-25 00:00:00-06	60	28	28	28
29	2025-07-19 00:00:00-06	6	29	29	29
30	2025-01-23 00:00:00-06	15	30	30	30
31	2025-01-19 00:00:00-06	2	31	31	31
32	2025-07-11 00:00:00-06	60	32	32	32
33	2024-10-02 00:00:00-06	80	33	33	33
34	2025-03-11 00:00:00-06	9	34	34	34
35	2024-11-28 00:00:00-06	90	35	35	35
36	2025-02-24 00:00:00-06	3	36	36	36
37	2025-05-29 00:00:00-06	23	37	37	37
38	2025-06-09 00:00:00-06	60	38	38	38
39	2024-10-02 00:00:00-06	40	39	39	39
40	2025-08-25 00:00:00-06	19	40	40	40
41	2025-07-02 00:00:00-06	40	41	41	41
42	2025-01-13 00:00:00-06	23	42	42	42
43	2024-11-20 00:00:00-06	4	43	43	43
44	2024-12-24 00:00:00-06	10	44	44	44
45	2024-10-18 00:00:00-06	11	45	45	45
46	2025-03-24 00:00:00-06	13	46	46	46
47	2024-11-10 00:00:00-06	15	47	47	47
48	2025-09-19 00:00:00-06	6	48	48	48
49	2025-09-17 00:00:00-06	4	49	49	49
50	2025-06-18 00:00:00-06	15	50	50	50
51	2024-10-27 00:00:00-06	5	51	51	51
52	2025-02-05 00:00:00-06	30	52	52	52
53	2025-01-11 00:00:00-06	2	53	53	53
54	2025-03-09 00:00:00-06	30	54	54	54
55	2024-10-04 00:00:00-06	30	55	55	55
56	2024-10-22 00:00:00-06	80	56	56	56
57	2025-04-19 00:00:00-06	3	57	57	57
58	2025-04-02 00:00:00-06	6	58	58	58
59	2025-09-26 00:00:00-06	3	59	59	59
60	2025-05-19 00:00:00-06	1	60	60	60
61	2025-08-17 00:00:00-06	300	61	61	61
62	2025-08-19 00:00:00-06	4	62	62	62
63	2024-10-01 00:00:00-06	28	63	63	63
64	2025-07-20 00:00:00-06	1	64	64	64
65	2025-09-14 00:00:00-06	7	65	65	65
66	2025-03-15 00:00:00-06	130	66	66	66
67	2025-09-07 00:00:00-06	80	67	67	67
68	2025-08-05 00:00:00-06	6	68	68	68
69	2024-11-28 00:00:00-06	3	69	69	69
70	2024-11-24 00:00:00-06	50	70	70	70
71	2025-01-31 00:00:00-06	20	71	71	71
72	2025-03-20 00:00:00-06	40	72	72	72
73	2025-07-14 00:00:00-06	110	73	73	73
74	2025-09-03 00:00:00-06	50	74	74	74
75	2025-06-07 00:00:00-06	25	75	75	75
76	2025-01-10 00:00:00-06	3	76	76	76
77	2025-09-05 00:00:00-06	30	77	77	77
78	2024-10-19 00:00:00-06	40	78	78	78
79	2024-11-02 00:00:00-06	28	79	79	79
80	2025-02-28 00:00:00-06	2	80	80	80
81	2025-05-26 00:00:00-06	3	81	81	81
82	2024-10-04 00:00:00-06	50	82	82	82
83	2025-06-09 00:00:00-06	3	83	83	83
84	2025-09-13 00:00:00-06	5	84	84	84
85	2024-12-21 00:00:00-06	5	85	85	85
86	2024-10-29 00:00:00-06	9	86	86	86
87	2025-05-02 00:00:00-06	3	87	87	87
88	2024-12-05 00:00:00-06	36	88	88	88
89	2025-09-20 00:00:00-06	9	89	89	89
90	2025-04-01 00:00:00-06	50	90	90	90
91	2025-07-23 00:00:00-06	6	91	91	91
92	2025-06-21 00:00:00-06	40	92	92	92
93	2025-01-08 00:00:00-06	3	93	93	93
94	2025-01-12 00:00:00-06	4	94	94	94
95	2025-08-06 00:00:00-06	25	95	95	95
96	2025-08-15 00:00:00-06	2	96	96	96
97	2025-01-20 00:00:00-06	2	97	97	97
98	2025-01-09 00:00:00-06	13	98	98	98
99	2025-03-20 00:00:00-06	6	99	99	99
100	2025-07-21 00:00:00-06	4	100	100	100
101	2024-12-22 00:00:00-06	25	101	101	101
102	2025-08-30 00:00:00-06	4	102	102	102
103	2025-09-17 00:00:00-06	5	103	103	103
104	2024-10-06 00:00:00-06	3	104	104	104
105	2025-08-18 00:00:00-06	15	105	105	105
106	2024-12-20 00:00:00-06	25	106	106	106
107	2025-04-01 00:00:00-06	3	107	107	107
108	2025-02-11 00:00:00-06	4	108	108	108
109	2025-03-22 00:00:00-06	50	109	109	109
110	2025-02-07 00:00:00-06	100	110	110	110
111	2025-04-30 00:00:00-06	6	111	111	111
112	2025-05-12 00:00:00-06	7	112	112	112
113	2025-06-12 00:00:00-06	25	113	113	113
114	2025-09-15 00:00:00-06	80	114	114	114
115	2025-03-07 00:00:00-06	30	115	115	115
116	2024-10-02 00:00:00-06	2	116	116	116
117	2025-03-09 00:00:00-06	2	117	117	117
118	2024-10-10 00:00:00-06	4	118	118	118
119	2025-03-22 00:00:00-06	21	119	119	119
120	2025-04-26 00:00:00-06	2	120	120	120
121	2025-06-23 00:00:00-06	7	121	121	121
122	2025-06-26 00:00:00-06	25	122	122	122
123	2024-11-05 00:00:00-06	4	123	123	123
124	2025-02-21 00:00:00-06	4	124	124	124
125	2025-06-11 00:00:00-06	40	125	125	125
126	2025-02-20 00:00:00-06	60	126	126	126
127	2025-08-06 00:00:00-06	40	127	127	127
128	2025-01-02 00:00:00-06	20	128	128	128
129	2025-03-26 00:00:00-06	200	129	129	129
130	2025-05-08 00:00:00-06	35	130	130	130
131	2025-02-04 00:00:00-06	70	131	131	131
132	2025-09-23 00:00:00-06	13	132	132	132
133	2025-04-07 00:00:00-06	2	133	133	133
134	2025-08-14 00:00:00-06	10	134	134	134
135	2024-10-25 00:00:00-06	6	135	135	135
136	2024-11-09 00:00:00-06	11	136	136	136
137	2025-09-21 00:00:00-06	4	137	137	137
138	2025-07-19 00:00:00-06	40	138	138	138
139	2024-11-18 00:00:00-06	20	139	139	139
140	2024-11-03 00:00:00-06	40	140	140	140
141	2025-09-27 00:00:00-06	30	141	141	141
142	2024-12-27 00:00:00-06	21	142	142	142
143	2025-01-27 00:00:00-06	6	143	143	143
144	2025-05-12 00:00:00-06	19	144	144	144
145	2025-07-12 00:00:00-06	4	145	145	145
146	2025-05-15 00:00:00-06	25	146	146	146
147	2025-07-08 00:00:00-06	5	147	147	147
148	2025-04-21 00:00:00-06	9	148	148	148
149	2025-01-09 00:00:00-06	5	149	149	149
150	2025-07-10 00:00:00-06	3	150	150	150
151	2024-11-20 00:00:00-06	25	151	151	151
152	2024-10-13 00:00:00-06	16	152	152	152
153	2025-09-14 00:00:00-06	2	153	153	153
154	2025-04-11 00:00:00-06	35	154	154	154
155	2024-10-06 00:00:00-06	4	155	155	155
156	2025-07-30 00:00:00-06	3	156	156	156
157	2025-08-25 00:00:00-06	4	157	157	157
158	2025-04-11 00:00:00-06	110	158	158	158
159	2025-06-18 00:00:00-06	1	159	159	159
160	2025-05-26 00:00:00-06	70	160	160	160
161	2025-09-23 00:00:00-06	30	161	161	161
162	2025-07-29 00:00:00-06	5	162	162	162
163	2024-12-09 00:00:00-06	3	163	163	163
164	2025-05-05 00:00:00-06	2	164	164	164
165	2025-06-26 00:00:00-06	13	165	165	165
166	2024-12-28 00:00:00-06	2	166	166	166
167	2024-10-08 00:00:00-06	300	167	167	167
168	2025-09-06 00:00:00-06	20	168	168	168
169	2024-12-21 00:00:00-06	40	169	169	169
170	2025-03-10 00:00:00-06	3	170	170	170
171	2025-06-19 00:00:00-06	15	171	171	171
172	2025-01-30 00:00:00-06	1	172	172	172
173	2025-06-22 00:00:00-06	100	173	173	173
174	2025-04-02 00:00:00-06	90	174	174	174
175	2025-03-18 00:00:00-06	3	175	175	175
176	2025-06-19 00:00:00-06	5	176	176	176
177	2025-01-22 00:00:00-06	50	177	177	177
178	2025-07-03 00:00:00-06	23	178	178	178
179	2025-07-10 00:00:00-06	3	179	179	179
180	2025-04-23 00:00:00-06	300	180	180	180
181	2025-04-19 00:00:00-06	7	181	181	181
182	2024-12-28 00:00:00-06	6	182	182	182
183	2024-11-29 00:00:00-06	50	183	183	183
184	2024-10-31 00:00:00-06	2	184	184	184
185	2025-03-04 00:00:00-06	6	185	185	185
186	2025-09-02 00:00:00-06	13	186	186	186
187	2024-10-28 00:00:00-06	4	187	187	187
188	2025-08-19 00:00:00-06	20	188	188	188
189	2025-05-07 00:00:00-06	70	189	189	189
190	2025-01-07 00:00:00-06	13	190	190	190
191	2025-07-29 00:00:00-06	100	191	191	191
192	2024-12-02 00:00:00-06	4	192	192	192
193	2025-06-16 00:00:00-06	4	193	193	193
194	2025-08-17 00:00:00-06	5	194	194	194
195	2025-05-25 00:00:00-06	150	195	195	195
196	2025-03-23 00:00:00-06	15	196	196	196
197	2024-12-20 00:00:00-06	40	197	197	197
198	2025-07-06 00:00:00-06	26	198	198	198
199	2025-02-28 00:00:00-06	50	199	199	199
200	2025-04-30 00:00:00-06	15	200	200	200
201	2025-08-28 00:00:00-06	300	201	201	201
202	2025-03-25 00:00:00-06	10	202	202	202
203	2024-10-09 00:00:00-06	50	203	203	203
204	2025-07-27 00:00:00-06	15	204	204	204
205	2025-05-27 00:00:00-06	80	205	205	205
206	2025-08-22 00:00:00-06	50	206	206	206
207	2025-06-26 00:00:00-06	11	207	207	207
208	2025-08-14 00:00:00-06	60	208	208	208
209	2025-05-05 00:00:00-06	3	209	209	209
210	2024-12-24 00:00:00-06	35	210	210	210
211	2025-03-22 00:00:00-06	30	211	211	211
212	2025-07-06 00:00:00-06	13	212	212	212
213	2024-12-21 00:00:00-06	50	213	213	213
214	2025-08-20 00:00:00-06	35	214	214	214
215	2025-01-31 00:00:00-06	70	215	215	215
216	2025-06-01 00:00:00-06	4	216	216	216
217	2024-12-23 00:00:00-06	23	217	217	217
218	2025-09-07 00:00:00-06	23	218	218	218
219	2025-01-11 00:00:00-06	15	219	219	219
220	2025-09-08 00:00:00-06	30	220	220	220
221	2025-09-03 00:00:00-06	1	221	221	221
222	2024-12-25 00:00:00-06	3	222	222	222
223	2025-01-28 00:00:00-06	4	223	223	223
224	2025-02-15 00:00:00-06	5	224	224	224
225	2025-01-12 00:00:00-06	5	225	225	225
226	2025-07-13 00:00:00-06	40	226	226	226
227	2025-05-06 00:00:00-06	4	227	227	227
228	2025-09-23 00:00:00-06	19	228	228	228
229	2025-01-04 00:00:00-06	3	229	229	229
230	2025-03-25 00:00:00-06	25	230	230	230
231	2025-06-04 00:00:00-06	6	231	231	231
232	2025-05-30 00:00:00-06	3	232	232	232
233	2024-10-06 00:00:00-06	25	233	233	233
234	2024-12-31 00:00:00-06	4	234	234	234
235	2025-04-25 00:00:00-06	3	235	235	235
236	2025-01-01 00:00:00-06	4	236	236	236
237	2025-07-15 00:00:00-06	4	237	237	237
238	2024-12-27 00:00:00-06	360	238	238	238
239	2024-11-27 00:00:00-06	16	239	239	239
240	2025-08-03 00:00:00-06	5	240	240	240
241	2024-10-14 00:00:00-06	3	241	241	241
242	2025-01-24 00:00:00-06	1	242	242	242
243	2025-05-31 00:00:00-06	3	243	243	243
244	2025-09-17 00:00:00-06	90	244	244	244
245	2025-09-01 00:00:00-06	46	245	245	245
246	2025-07-24 00:00:00-06	4	246	246	246
247	2024-10-17 00:00:00-06	7	247	247	247
248	2025-02-13 00:00:00-06	50	248	248	248
249	2025-06-23 00:00:00-06	35	249	249	249
250	2025-07-06 00:00:00-06	3	250	250	250
\.


--
-- TOC entry 5437 (class 0 OID 41052)
-- Dependencies: 236
-- Data for Name: DETALLE_TRANSPORTE; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."DETALLE_TRANSPORTE" (id_detalle_transporte, numero_tarjeta, id_transporte_empleado, fecha, hora_salida) FROM stdin;
1	1	1	2024-12-16 00:00:00-06	2
2	2	2	2025-07-11 00:00:00-06	3
3	3	3	2025-08-27 00:00:00-06	3
4	4	4	2025-08-02 00:00:00-06	3
5	5	5	2025-07-19 00:00:00-06	5
6	6	6	2024-11-18 00:00:00-06	3
7	7	7	2025-09-01 00:00:00-06	3
8	8	8	2025-03-23 00:00:00-06	2
9	9	9	2025-09-16 00:00:00-06	4
10	10	10	2025-06-27 00:00:00-06	3
11	11	11	2024-09-30 00:00:00-06	4
12	12	12	2025-05-25 00:00:00-06	11
13	13	13	2025-01-09 00:00:00-06	3
14	14	14	2025-08-10 00:00:00-06	3
15	15	15	2025-08-19 00:00:00-06	4
16	16	16	2025-06-04 00:00:00-06	12
17	17	17	2025-07-10 00:00:00-06	3
18	18	18	2025-09-04 00:00:00-06	4
19	19	19	2025-08-09 00:00:00-06	2
20	20	20	2025-08-26 00:00:00-06	16
21	21	21	2025-03-14 00:00:00-06	3
22	22	22	2025-03-08 00:00:00-06	6
23	23	23	2025-05-31 00:00:00-06	13
24	24	24	2025-02-06 00:00:00-06	14
25	25	25	2025-07-28 00:00:00-06	3
26	26	26	2025-03-12 00:00:00-06	3
27	27	27	2025-02-08 00:00:00-06	3
28	28	28	2024-12-22 00:00:00-06	14
29	29	29	2025-05-25 00:00:00-06	3
30	30	30	2025-08-10 00:00:00-06	3
31	31	31	2025-03-08 00:00:00-06	13
32	32	32	2025-03-04 00:00:00-06	3
33	33	33	2024-10-01 00:00:00-06	3
34	34	34	2024-12-24 00:00:00-06	3
35	35	35	2025-02-02 00:00:00-06	3
36	36	36	2025-07-24 00:00:00-06	3
37	37	37	2025-04-06 00:00:00-06	12
38	38	38	2025-03-30 00:00:00-06	3
39	39	39	2024-11-19 00:00:00-06	2
40	40	40	2025-08-31 00:00:00-06	2
41	41	41	2025-09-26 00:00:00-06	3
42	42	42	2024-11-14 00:00:00-06	10
43	43	43	2024-12-25 00:00:00-06	3
44	44	44	2025-04-21 00:00:00-06	3
45	45	45	2024-11-15 00:00:00-06	2
46	46	46	2024-10-04 00:00:00-06	4
47	47	47	2024-10-07 00:00:00-06	4
48	48	48	2024-12-12 00:00:00-06	6
49	49	49	2025-07-13 00:00:00-06	3
50	50	50	2025-05-20 00:00:00-06	15
51	51	51	2025-02-16 00:00:00-06	3
52	52	52	2025-07-22 00:00:00-06	2
53	53	53	2025-03-27 00:00:00-06	3
54	54	54	2025-01-13 00:00:00-06	3
55	55	55	2025-05-16 00:00:00-06	3
56	56	56	2025-06-13 00:00:00-06	3
57	57	57	2025-02-10 00:00:00-06	22
58	58	58	2025-01-02 00:00:00-06	3
59	59	59	2025-07-14 00:00:00-06	12
60	60	60	2025-03-09 00:00:00-06	4
61	61	61	2024-10-24 00:00:00-06	10
62	62	62	2025-02-03 00:00:00-06	2
63	63	63	2025-08-22 00:00:00-06	2
64	64	64	2025-08-20 00:00:00-06	3
65	65	65	2025-08-01 00:00:00-06	3
66	66	66	2025-02-25 00:00:00-06	3
67	67	67	2024-12-30 00:00:00-06	3
68	68	68	2025-06-05 00:00:00-06	3
69	69	69	2025-07-21 00:00:00-06	3
70	70	70	2025-01-08 00:00:00-06	2
71	71	71	2025-09-01 00:00:00-06	3
72	72	72	2025-05-26 00:00:00-06	14
73	73	73	2025-02-24 00:00:00-06	3
74	74	74	2025-08-27 00:00:00-06	2
75	75	75	2025-01-10 00:00:00-06	3
76	76	76	2025-09-13 00:00:00-06	5
77	77	77	2025-09-07 00:00:00-06	2
78	78	78	2024-11-02 00:00:00-06	4
79	79	79	2024-11-16 00:00:00-06	3
80	80	80	2024-11-10 00:00:00-06	3
81	81	81	2025-01-27 00:00:00-06	2
82	82	82	2025-03-22 00:00:00-06	2
83	83	83	2024-10-15 00:00:00-06	2
84	84	84	2025-01-01 00:00:00-06	3
85	85	85	2025-04-05 00:00:00-06	3
86	86	86	2025-08-02 00:00:00-06	3
87	87	87	2025-01-22 00:00:00-06	3
88	88	88	2025-05-28 00:00:00-06	3
89	89	89	2025-07-28 00:00:00-06	10
90	90	90	2025-06-22 00:00:00-06	4
91	91	91	2025-05-23 00:00:00-06	4
92	92	92	2025-02-14 00:00:00-06	14
93	93	93	2025-04-05 00:00:00-06	3
94	94	94	2024-11-10 00:00:00-06	2
95	95	95	2024-10-27 00:00:00-06	3
96	96	96	2025-03-27 00:00:00-06	11
97	97	97	2025-02-20 00:00:00-06	2
98	98	98	2025-08-03 00:00:00-06	4
99	99	99	2025-06-27 00:00:00-06	2
100	100	100	2025-03-20 00:00:00-06	15
101	101	101	2024-10-18 00:00:00-06	3
102	102	102	2024-10-21 00:00:00-06	3
103	103	103	2024-11-22 00:00:00-06	3
104	104	104	2025-01-30 00:00:00-06	3
105	105	105	2024-10-20 00:00:00-06	4
106	106	106	2025-09-25 00:00:00-06	4
107	107	107	2025-01-05 00:00:00-06	3
108	108	108	2024-10-09 00:00:00-06	3
109	109	109	2025-08-16 00:00:00-06	2
110	110	110	2025-02-08 00:00:00-06	3
111	111	111	2024-12-10 00:00:00-06	3
112	112	112	2025-07-03 00:00:00-06	3
113	113	113	2025-02-11 00:00:00-06	5
114	114	114	2025-09-03 00:00:00-06	2
115	115	115	2025-03-17 00:00:00-06	2
116	116	116	2024-11-27 00:00:00-06	2
117	117	117	2025-09-17 00:00:00-06	2
118	118	118	2025-04-16 00:00:00-06	10
119	119	119	2025-06-13 00:00:00-06	2
120	120	120	2024-10-21 00:00:00-06	3
121	121	121	2024-12-24 00:00:00-06	3
122	122	122	2025-07-07 00:00:00-06	4
123	123	123	2025-05-11 00:00:00-06	3
124	124	124	2025-05-30 00:00:00-06	2
125	125	125	2024-10-26 00:00:00-06	2
126	126	126	2025-02-27 00:00:00-06	3
127	127	127	2025-02-19 00:00:00-06	3
128	128	128	2025-05-03 00:00:00-06	3
129	129	129	2025-06-02 00:00:00-06	3
130	130	130	2025-08-11 00:00:00-06	3
131	131	131	2025-04-11 00:00:00-06	4
132	132	132	2024-11-20 00:00:00-06	3
133	133	133	2025-08-05 00:00:00-06	4
134	134	134	2025-04-07 00:00:00-06	3
135	135	135	2025-06-07 00:00:00-06	5
136	136	136	2025-08-09 00:00:00-06	3
137	137	137	2025-09-20 00:00:00-06	4
138	138	138	2025-08-06 00:00:00-06	5
139	139	139	2025-02-04 00:00:00-06	2
140	140	140	2024-12-20 00:00:00-06	3
141	141	141	2025-05-16 00:00:00-06	12
142	142	142	2025-07-04 00:00:00-06	3
143	143	143	2025-03-26 00:00:00-06	3
144	144	144	2025-07-27 00:00:00-06	5
145	145	145	2025-08-11 00:00:00-06	3
146	146	146	2024-12-05 00:00:00-06	2
147	147	147	2025-09-12 00:00:00-06	12
148	148	148	2025-07-18 00:00:00-06	3
149	149	149	2025-04-17 00:00:00-06	4
150	150	150	2024-11-04 00:00:00-06	3
151	151	151	2025-09-02 00:00:00-06	4
152	152	152	2024-12-19 00:00:00-06	6
153	153	153	2025-07-02 00:00:00-06	3
154	154	154	2025-03-15 00:00:00-06	5
155	155	155	2025-08-08 00:00:00-06	4
156	156	156	2025-09-23 00:00:00-06	3
157	157	157	2025-03-31 00:00:00-06	3
158	158	158	2025-04-19 00:00:00-06	3
159	159	159	2024-12-13 00:00:00-06	3
160	160	160	2025-09-27 00:00:00-06	2
161	161	161	2025-01-25 00:00:00-06	2
162	162	162	2025-04-10 00:00:00-06	2
163	163	163	2024-11-23 00:00:00-06	3
164	164	164	2025-08-19 00:00:00-06	3
165	165	165	2025-06-18 00:00:00-06	3
166	166	166	2025-09-14 00:00:00-06	3
167	167	167	2025-06-08 00:00:00-06	3
168	168	168	2024-11-15 00:00:00-06	3
169	169	169	2025-09-21 00:00:00-06	3
170	170	170	2025-09-24 00:00:00-06	3
171	171	171	2025-03-10 00:00:00-06	2
172	172	172	2025-01-30 00:00:00-06	3
173	173	173	2025-01-04 00:00:00-06	3
174	174	174	2024-12-04 00:00:00-06	4
175	175	175	2024-12-21 00:00:00-06	3
176	176	176	2025-03-09 00:00:00-06	3
177	177	177	2025-01-14 00:00:00-06	4
178	178	178	2025-08-27 00:00:00-06	3
179	179	179	2024-12-04 00:00:00-06	2
180	180	180	2025-08-02 00:00:00-06	2
181	181	181	2025-04-04 00:00:00-06	5
182	182	182	2024-12-15 00:00:00-06	3
183	183	183	2025-07-01 00:00:00-06	3
184	184	184	2025-03-08 00:00:00-06	12
185	185	185	2025-01-18 00:00:00-06	3
186	186	186	2025-04-04 00:00:00-06	3
187	187	187	2025-06-19 00:00:00-06	3
188	188	188	2025-01-28 00:00:00-06	2
189	189	189	2025-04-22 00:00:00-06	3
190	190	190	2024-11-03 00:00:00-06	3
191	191	191	2025-02-17 00:00:00-06	2
192	192	192	2024-10-15 00:00:00-06	3
193	193	193	2024-10-26 00:00:00-06	5
194	194	194	2025-07-20 00:00:00-06	3
195	195	195	2025-05-01 00:00:00-06	2
196	196	196	2024-11-03 00:00:00-06	4
197	197	197	2025-03-18 00:00:00-06	3
198	198	198	2025-06-11 00:00:00-06	3
199	199	199	2025-04-07 00:00:00-06	12
200	200	200	2025-03-14 00:00:00-06	2
201	201	201	2025-01-10 00:00:00-06	3
202	202	202	2025-01-01 00:00:00-06	5
203	203	203	2025-05-22 00:00:00-06	2
204	204	204	2025-05-01 00:00:00-06	2
205	205	205	2024-12-26 00:00:00-06	2
206	206	206	2025-07-10 00:00:00-06	4
207	207	207	2024-10-01 00:00:00-06	3
208	208	208	2025-04-28 00:00:00-06	3
209	209	209	2025-07-14 00:00:00-06	3
210	210	210	2025-02-16 00:00:00-06	2
211	211	211	2024-12-05 00:00:00-06	3
212	212	212	2025-07-11 00:00:00-06	3
213	213	213	2025-09-04 00:00:00-06	11
214	214	214	2025-04-10 00:00:00-06	3
215	215	215	2024-10-18 00:00:00-06	3
216	216	216	2024-11-09 00:00:00-06	5
217	217	217	2025-01-15 00:00:00-06	3
218	218	218	2025-08-21 00:00:00-06	3
219	219	219	2024-12-25 00:00:00-06	2
220	220	220	2025-06-02 00:00:00-06	3
221	221	221	2025-08-11 00:00:00-06	3
222	222	222	2025-07-13 00:00:00-06	2
223	223	223	2025-07-19 00:00:00-06	4
224	224	224	2024-11-09 00:00:00-06	3
225	225	225	2025-04-04 00:00:00-06	3
226	226	226	2025-01-22 00:00:00-06	2
227	227	227	2024-10-23 00:00:00-06	6
228	228	228	2025-04-13 00:00:00-06	2
229	229	229	2025-07-25 00:00:00-06	4
230	230	230	2025-06-07 00:00:00-06	2
231	231	231	2025-02-23 00:00:00-06	2
232	232	232	2024-10-07 00:00:00-06	2
233	233	233	2025-04-18 00:00:00-06	3
234	234	234	2024-12-12 00:00:00-06	3
235	235	235	2025-04-17 00:00:00-06	4
236	236	236	2025-05-28 00:00:00-06	2
237	237	237	2025-04-17 00:00:00-06	15
238	238	238	2024-11-15 00:00:00-06	3
239	239	239	2025-02-16 00:00:00-06	2
240	240	240	2025-04-05 00:00:00-06	22
241	241	241	2025-06-15 00:00:00-06	3
242	242	242	2025-05-20 00:00:00-06	2
243	243	243	2025-09-07 00:00:00-06	13
244	244	244	2024-10-25 00:00:00-06	3
245	245	245	2025-02-15 00:00:00-06	2
246	246	246	2025-01-05 00:00:00-06	3
247	247	247	2025-08-24 00:00:00-06	3
248	248	248	2024-10-29 00:00:00-06	2
249	249	249	2025-04-11 00:00:00-06	4
250	250	250	2025-06-21 00:00:00-06	5
\.


--
-- TOC entry 5438 (class 0 OID 41055)
-- Dependencies: 237
-- Data for Name: EMPLEADOS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."EMPLEADOS" (numero_tarjeta, nombre, apellido_paterno, apellido_materno, calle, colonia, codigo_postal, id_sucursal, id_area, id_puesto, id_ciudad, rfc_empleado, curp_empleado, numero_seguro_social, edad, genero) FROM stdin;
1	Sashenka	Fleet	Darinton	25 Porter Place	Linden	4690 	1	1	1	1	3327865663	6133773928	4746463581	102	Female
2	Robinson	Wilmington	Keble	58 Hanson Way	International	68   	2	2	2	2	1217562168	4567541464	9493252434	49	Male
3	Sheeree	Woehler	Jaulmes	5 5th Lane	Hauk	6    	3	3	3	3	1601943997	2478058308	0557685702	95	Female
4	Harley	Quinnet	Alloisi	6773 Gateway Center	Holy Cross	5    	4	4	4	4	9182383359	7686976548	4907645201	42	Agender
5	Etty	Braganca	Harbison	2195 Anniversary Drive	Blue Bill Park	312  	5	5	5	5	7107344498	0301149364	7713539182	61	Female
6	Nikola	Oliveira	Cowherd	1 Clyde Gallagher Hill	Gale	95674	6	6	6	6	0533245125	7159170113	0949536288	120	Male
7	Berty	Powys	Rummery	9 Eagan Road	Forest Run	90908	7	7	7	7	5616503967	7388004319	7993192137	11	Female
8	Corabel	Artz	Muckersie	92659 Carpenter Junction	Spohn	06   	8	8	8	8	3002097985	9537452085	0612956148	6	Female
9	Palmer	Bottinelli	Dinzey	489 American Ash Terrace	Barby	7036 	9	9	9	9	7615342864	0780664035	9818663454	71	Male
10	Reeta	Yeandel	O'Lahy	328 Anhalt Alley	Lakewood Gardens	964  	10	10	10	10	4905346681	3754671286	8417852018	104	Female
11	Meghan	Dabel	Theis	3987 Ohio Park	Caliangt	09   	11	11	11	11	1262849942	2788654960	0601796985	12	Female
12	Berta	Charrier	Neighbour	6 Sloan Crossing	Kensington	39   	12	12	12	12	4219228233	1000883043	7488929705	48	Female
13	Michaelina	Orgee	Larn	34934 Alpine Hill	Sherman	5    	13	13	13	13	3813365727	3175446426	0957722249	62	Female
14	Matthus	Nelligan	Gibberd	6895 Hoard Trail	Oakridge	8102 	14	14	14	14	6158732184	1743694350	8130745224	20	Male
15	Brewster	Binks	Gregolin	3 Nobel Hill	Monterey	3411 	15	15	15	15	0334152704	8512445483	0079990584	48	Male
16	Mace	Ovid	Ritter	9667 Loftsgordon Terrace	Arkansas	49   	16	16	16	16	1305277376	6771010651	8409086921	79	Genderfluid
17	Uriah	Luttgert	Claussen	7 Riverside Park	Aberg	2934 	17	17	17	17	2564339344	6813137247	9422263492	118	Male
18	Pincus	Kale	Nightingale	85 Karstens Parkway	Scoville	2    	18	18	18	18	9662927727	5935835274	8175817739	115	Bigender
19	Hobard	Jennens	Crocroft	4 Straubel Avenue	Ridge Oak	18   	19	19	19	19	6732041126	9857562264	8554188640	117	Male
20	Mateo	Ewington	Ebbs	7 Reinke Terrace	Pierstorff	5    	20	20	20	20	2134759550	8801884605	3019741602	47	Male
21	Tricia	Davidovits	Gorries	429 Duke Circle	Washington	1800 	21	21	21	21	8803584234	1994086882	4209422614	78	Female
22	Leann	Edgecombe	Suthren	27 Debs Center	Schiller	1    	22	22	22	22	3736091257	9699116994	5184502521	93	Female
23	Mayor	Boriston	Pach	6141 Haas Center	Talisman	26   	23	23	23	23	5829223198	4264169909	6120908757	52	Male
24	Annaliese	Heighton	Laws	2987 Jay Road	Morrow	88542	24	24	24	24	2004835427	6408854109	6978547077	44	Female
25	Avery	Gonnelly	Arthan	1245 Dottie Place	Waubesa	41081	25	25	25	25	1794608508	9438964339	2533730742	74	Male
26	Vinson	Waples	Ricold	04685 Hayes Avenue	Grayhawk	55   	26	26	26	26	3919791789	8002007891	9901283248	94	Male
27	Sondra	Samter	Kidwell	62 High Crossing Point	Hanover	3342 	27	27	27	27	1441609814	6529921303	2056492091	70	Non-binary
28	Jim	Bigly	Cradoc	58 Coolidge Alley	Westport	02302	28	28	28	28	6851186837	5176069725	9959407152	107	Male
29	Anna-maria	Toler	Bertl	51637 Barnett Trail	Tony	572  	29	29	29	29	2419364392	2525063686	0059293713	95	Female
30	Lyn	Berryman	Rothschild	2 Sutherland Place	Sage	7058 	30	30	30	30	8604310347	9142281210	1060907852	20	Non-binary
31	Lay	Brooke	Kingzet	20 Leroy Plaza	Kingsford	74   	31	31	31	31	0280055560	9281274035	5343271146	91	Male
32	Shannon	Ragdale	Rolles	16330 Marquette Drive	Sherman	238  	32	32	32	32	6992291394	9547411365	7884552051	29	Male
33	Stevana	Lob	Fessions	0754 North Hill	Village	585  	33	33	33	33	7265753143	5547493686	5253158898	93	Female
34	Becka	McEnteggart	Swansborough	5 Tony Pass	Stoughton	543  	34	34	34	34	6371176544	0365966053	9882605699	18	Non-binary
35	Kinsley	McIlvoray	Teather	3 Elgar Circle	Sullivan	12   	35	35	35	35	7712064628	4259504622	2930989173	79	Bigender
36	Zsazsa	Ciciotti	Lapsley	79 Kipling Point	Fremont	8    	36	36	36	36	4923433140	4233959738	8362034661	44	Female
37	Rae	Dorkins	Bilbrooke	483 Basil Crossing	Buena Vista	7852 	37	37	37	37	3468990413	6220853393	1670913031	6	Female
38	Myrtia	Roff	Pottberry	37 Loeprich Junction	Mayer	3    	38	38	38	38	8515602725	0957055722	3682999434	6	Female
39	Hobart	Frankham	Duxbarry	1 La Follette Point	Eagan	8    	39	39	39	39	8988025482	1048865479	6379134557	23	Male
40	Hannah	Haithwaite	Walley	534 Declaration Plaza	Elka	3    	40	40	40	40	2715101880	6570855220	5053605432	32	Female
41	Maddie	Knappitt	Comrie	9065 Montana Alley	Melby	4    	41	41	41	41	0018104703	4386346228	0594928648	60	Male
42	Leighton	Shacklady	Eldershaw	3 Buell Plaza	Larry	75535	42	42	42	42	7681663401	1374903035	7600205998	69	Male
43	Valencia	Swires	Mayhou	11316 Dottie Trail	4th	86383	43	43	43	43	7410979593	2523459485	0359527450	86	Female
44	Lynnette	Malyj	Beasley	217 1st Street	Ronald Regan	3    	44	44	44	44	3957166691	1647382106	1848360320	1	Female
45	Slade	Ivashnyov	Bloomer	3 Canary Circle	Corry	86467	45	45	45	45	2165523028	9572673564	3100929004	92	Male
46	Micheil	Cotty	Waterhous	46057 David Junction	Portage	08806	46	46	46	46	6586947537	0735117187	5883399614	7	Male
47	Theodore	Andreone	Else	06518 Birchwood Point	Bunting	362  	47	47	47	47	0418800863	2153505542	8472188531	115	Male
48	Lurlene	Benz	Sepey	54675 Judy Trail	Rigney	037  	48	48	48	48	1105194248	8230522480	9700944972	15	Female
49	Gregorio	McNeely	Fulun	54848 Marcy Junction	Messerschmidt	581  	49	49	49	49	0110474600	2942017902	0606768173	72	Male
50	Seline	Dorton	Waind	90 Nelson Parkway	Hollow Ridge	25   	50	50	50	50	1226117678	8715884708	0931699398	52	Female
51	Izzy	Thebeaud	McQuillan	9 American Ash Trail	Trailsway	94   	51	51	51	51	1371465339	6205018373	6797378990	47	Male
52	Cordie	Bresnen	Agglio	1 School Junction	Anniversary	1846 	52	52	52	52	2527137814	6396747952	1980291152	39	Female
53	Gino	Forsard	Sallan	7 Atwood Drive	Del Sol	06   	53	53	53	53	0254324827	0149645481	3356090313	25	Male
54	Bria	Mosey	Sparrow	869 Banding Pass	Springs	90   	54	54	54	54	5454649872	6866987393	0147914329	24	Female
55	Abbot	Burman	Bisp	8 Fair Oaks Way	Oneill	0    	55	55	55	55	9634336191	0873996445	9267952781	118	Male
56	Hyman	Stansby	Schubart	2 Macpherson Parkway	Dahle	14   	56	56	56	56	2405890380	3125069475	6177484972	55	Male
57	Deloris	GiacobbiniJacob	Hasluck	057 Shasta Drive	International	55   	57	57	57	57	8143288811	6664944251	9522382892	84	Female
58	Kippy	Titterton	Tremathack	70 Drewry Plaza	Talisman	14   	58	58	58	58	7751814896	0730270440	2820620914	50	Male
59	Torrance	Vaar	Eirwin	9 Fairview Place	Di Loreto	78574	59	59	59	59	4991223601	5433698041	9210901584	97	Male
60	Barnebas	Stonhewer	Benedtti	484 Kipling Lane	Paget	329  	60	60	60	60	6024195044	0925670715	9964886225	75	Male
61	Francisca	Halbert	Scyone	7 Marcy Way	Toban	39   	61	61	61	61	7394678245	3894832134	6183812986	6	Female
62	Virginie	Heinel	Crowcombe	1 Ridge Oak Way	Johnson	99   	62	62	62	62	0652264999	4772141766	5332272693	22	Female
63	Ferrel	Bettison	Jiricka	64 Golf Course Parkway	Eastlawn	832  	63	63	63	63	3216246957	2217608851	0263394581	35	Male
64	Aloise	Keigher	Irwin	01 Lindbergh Way	Clove	08665	64	64	64	64	2558394878	0394823192	8410306425	79	Female
65	Angelico	Hindrich	Vigus	54 Del Sol Plaza	Florence	70   	65	65	65	65	1794904166	2465617737	2964430470	53	Male
66	Gillie	Fishby	Calan	968 Grover Point	American Ash	068  	66	66	66	66	2583012770	5932755539	3567543482	57	Female
67	Anitra	Tinman	Donoghue	20906 Express Center	Mccormick	2968 	67	67	67	67	3603268962	1649921233	1833223993	32	Female
68	Adey	Foulger	Peyntue	0 Stuart Alley	Elka	472  	68	68	68	68	8860567416	0925659215	1188923129	93	Female
69	Zenia	Stammler	Campey	65301 Riverside Street	Judy	4145 	69	69	69	69	9305499546	4249857360	2741714355	110	Female
70	Daniella	Gillooly	Antyshev	94 Northridge Terrace	Nobel	20867	70	70	70	70	7106324213	2958576698	6171032174	34	Female
71	Kaspar	Sollner	Endicott	3327 Lukken Avenue	Milwaukee	1    	71	71	71	71	8120820487	8385349928	5181844294	115	Male
72	Tom	Higbin	Eskriet	4694 Dennis Parkway	Stang	4638 	72	72	72	72	9058847284	2394778709	9724863301	39	Agender
73	Joane	Tift	Pendleton	1 Stephen Center	Straubel	40367	73	73	73	73	6283492436	9864334964	6447630313	80	Female
74	Susette	Calfe	Boncore	99 Canary Junction	Monica	84   	74	74	74	74	6318534857	4902623889	1634901479	6	Female
75	Molli	Wehnerr	Kissell	065 International Point	Fisk	88   	75	75	75	75	2838473069	4857489589	3772605737	20	Female
76	Milli	Reaman	Radki	7536 Burning Wood Hill	David	363  	76	76	76	76	0208947159	4606016124	4105956345	82	Female
77	Loretta	Satch	Simison	8292 Stang Park	Vidon	4162 	77	77	77	77	1935383744	4721802900	2208994566	26	Female
78	Ara	Mulvey	Corah	8 Rockefeller Center	Nova	84118	78	78	78	78	5651303154	9196130970	7916882876	5	Male
79	Barde	Mcmanaman	Burth	3246 Cherokee Lane	Rockefeller	7653 	79	79	79	79	2574101979	5651614982	7494389318	35	Agender
80	Sigrid	Hambribe	Austing	1893 Vermont Crossing	Vidon	79   	80	80	80	80	9250590547	2861718900	2940774439	91	Female
81	Sabine	Queripel	Sancroft	799 Center Circle	High Crossing	20   	81	81	81	81	5078673865	2830768566	9337642220	63	Female
82	Sissy	Dun	Khristoforov	4 Merchant Court	Veith	2188 	82	82	82	82	3983884024	0139137459	5129556208	108	Female
83	Harriott	Greeveson	Blackwood	595 Bay Parkway	Clarendon	1507 	83	83	83	83	4032084920	2283350166	9203922954	69	Genderqueer
84	Gardiner	Odney	Rodenburg	126 Caliangt Center	Maple Wood	03698	84	84	84	84	7634245399	7591090399	1084796279	84	Male
85	Sawyer	Bambury	Jackalin	4 Dapin Terrace	Pearson	69829	85	85	85	85	8914206181	2045246345	3531657550	46	Male
86	Teri	Affron	Dower	8 Rowland Alley	Ridge Oak	724  	86	86	86	86	7940018035	1793285489	7792085848	68	Female
87	Lynette	Robiot	Dollard	7 Menomonie Lane	Elgar	784  	87	87	87	87	8042115083	8620498118	5484264979	46	Female
88	Tandy	Larcher	Lamprecht	7 Arkansas Street	Fair Oaks	088  	88	88	88	88	0277538041	2623064210	6836278858	16	Female
89	Charmian	Setterthwait	Brewis	937 Hintze Court	Ramsey	08   	89	89	89	89	6616473635	7584987893	3553907533	71	Female
90	Bayard	Fortie	Durban	568 Havey Center	Del Mar	53776	90	90	90	90	6512479505	2511313669	9248009492	22	Male
91	Heath	Kinglake	Croydon	5644 Tomscot Point	East	508  	91	91	91	91	4793231306	1517002877	4931572413	21	Male
92	Winfred	Barkaway	Lawlings	261 Ruskin Crossing	Kings	89982	92	92	92	92	2586832744	1384198814	7214180669	112	Male
93	Chery	Vittet	Riceards	51196 Stone Corner Park	Parkside	1639 	93	93	93	93	1589433726	8422485443	9856088704	1	Female
94	Israel	O'Currane	Parren	983 Sherman Hill	Maryland	34   	94	94	94	94	6738160038	3109842718	8328968576	65	Male
95	Sebastian	Bittleson	Boom	8 Kings Alley	Farmco	24   	95	95	95	95	1984753711	8391515451	3427361950	10	Male
96	Marie-jeanne	Sparkwell	Fenna	7 Northport Junction	Atwood	06   	96	96	96	96	2640710966	9504439357	3669678778	25	Non-binary
97	Pietro	Wennington	Crunkhorn	973 Tennessee Drive	Ohio	7    	97	97	97	97	4352332585	9786023137	7891984824	99	Male
98	Deina	Oglevie	Keveren	262 Sachtjen Road	Clarendon	70683	98	98	98	98	5129204263	0804953120	3649359898	57	Female
99	Mable	Yude	Voden	9 Moose Park	Browning	83   	99	99	99	99	9110177078	0332394158	9846383010	44	Bigender
100	Byran	Rapin	Thow	29364 East Junction	Mesta	085  	100	100	100	100	2655293576	1122117108	7870621447	53	Male
101	Demeter	Renner	Braun	179 Forest Crossing	Mifflin	044  	101	101	101	101	5940466311	1921371528	1543036783	67	Genderfluid
102	Kev	Probets	Fiddymont	2 Springs Park	Longview	77   	102	102	102	102	7994230288	1915091101	0716175908	36	Male
103	Tobey	Ferebee	Firby	21265 Service Center	Birchwood	64203	103	103	103	103	4417723796	0543320758	2631804317	23	Female
104	Conroy	Keward	Giamo	8184 Hanover Road	Carpenter	1030 	104	104	104	104	3648194372	2340969352	8737976435	116	Male
105	Granthem	Flieg	Gonsalvo	842 Chive Terrace	Sunfield	3308 	105	105	105	105	7903427830	4090974062	6826609746	37	Male
106	Cyrus	Bonsul	Brownsmith	32 Longview Drive	Scott	109  	106	106	106	106	4047443174	8598641790	9377501660	71	Polygender
107	Jenilee	Trimming	Sainsbury-Brown	7194 Hollow Ridge Place	Laurel	60   	107	107	107	107	1735090484	7334565339	1730602061	75	Agender
108	Rufe	MacCafferky	Hiorn	986 Park Meadow Circle	Fremont	590  	108	108	108	108	7793493273	8508513577	5023078868	45	Genderfluid
109	Dell	Truran	Atmore	9876 Messerschmidt Way	Mccormick	1920 	109	109	109	109	8882754669	0309706807	6673888237	68	Polygender
110	Demott	Regardsoe	Crookes	94900 Homewood Way	Algoma	7    	110	110	110	110	3785231644	7285000612	8626443498	91	Male
111	Natalee	Dinley	Blaasch	7384 Portage Alley	1st	0    	111	111	111	111	6853178092	7063678477	9756138386	98	Female
112	Nicholas	Duddle	Alexandrou	76543 Blaine Lane	Loeprich	18667	112	112	112	112	2025871198	9942589430	9357505652	89	Male
113	Flossie	Cowcha	Croneen	73 Nelson Parkway	Hallows	6076 	113	113	113	113	9094446944	7519136302	5796716484	101	Female
114	Sandro	Carress	Scrammage	3103 Carpenter Lane	Dunning	9    	114	114	114	114	6563525547	9279659774	2637879572	53	Male
115	Hilda	Adrienne	Powe	7795 Hooker Street	Hollow Ridge	899  	115	115	115	115	0875317308	1234488337	8988093054	50	Female
116	Jerad	Lugard	Kingsnode	4359 Schlimgen Place	Hooker	70   	116	116	116	116	4624276868	2735032094	3538170207	81	Non-binary
117	Chrysa	Aspell	Antrack	35 Huxley Terrace	Union	2    	117	117	117	117	7637844587	9426645160	6623071547	83	Female
118	Lennard	Santore	Giacubbo	4045 Springview Court	Killdeer	91   	118	118	118	118	4885506778	6607423329	7131572810	46	Male
119	Starlin	Girk	Fuller	40 Hoepker Lane	Forest Run	2    	119	119	119	119	7776771236	2312803054	1187600652	46	Female
120	Ly	Alpin	Conelly	3590 Longview Circle	Ridgeview	790  	120	120	120	120	3228035050	0917518861	4099439070	102	Male
121	Kale	Cubuzzi	Seear	4260 Towne Trail	Susan	6    	121	121	121	121	4155919958	4914239264	9386641143	31	Male
122	Melony	Bacher	Stolli	4 Ridgeview Avenue	Katie	170  	122	122	122	122	0345099311	6405204189	6228494961	81	Female
123	Hi	Midlane	Chadwen	84 Pepper Wood Avenue	Gina	2876 	123	123	123	123	7642453639	9698319352	3612761048	48	Male
124	Cristie	Trevaskis	Villalta	902 Saint Paul Trail	Cordelia	32   	124	124	124	124	1671205685	6062326169	0228939313	58	Female
125	Gustavus	Brownhall	Kreuzer	46 Tomscot Park	Carpenter	3    	125	125	125	125	7889068603	9856150590	5817339927	103	Male
126	Brnaby	Riccelli	Sabin	092 Lyons Drive	Granby	822  	126	126	126	126	3005987388	6694441703	8634779602	26	Male
127	Tallie	Dmtrovic	Colloff	42 Evergreen Avenue	Northview	4651 	127	127	127	127	7058952914	6598260418	8650031889	50	Bigender
128	Hayward	Kuscha	Kyne	4 Marquette Circle	Summerview	7    	128	128	128	128	1849360731	5818105946	3010404859	49	Male
129	Cloris	Lilliman	Letessier	6 Del Sol Pass	Namekagon	5    	129	129	129	129	5778342071	7094915721	4171986761	68	Female
130	Patience	Muino	Longhorne	47051 Lakeland Crossing	Beilfuss	9    	130	130	130	130	2012017126	3480844014	2027330984	23	Female
131	Skipton	Loachhead	Guerri	9449 Crownhardt Court	Fremont	7    	131	131	131	131	8509176779	3572295521	7302569266	100	Male
132	Brand	Marxsen	Watters	3 Waxwing Street	South	910  	132	132	132	132	4496889404	3507440652	7384534550	82	Bigender
133	Skippy	L' Estrange	Sant	79 Sutteridge Point	Ridgeway	24   	133	133	133	133	1719722102	7089469549	2599710650	82	Male
134	Monah	Pembry	Shackesby	16 Declaration Street	Hoffman	0235 	134	134	134	134	0734277326	3342201371	7829007969	71	Female
135	Roanna	Passion	Eustice	1 Arizona Terrace	Kingsford	3941 	135	135	135	135	5280652725	3786106452	4552788175	97	Female
136	Sandro	Fourman	Challiss	0 Cascade Crossing	Center	6223 	136	136	136	136	4883811395	1425054137	9908992015	53	Non-binary
137	Leopold	Qualtrough	Spatarul	87210 Lerdahl Park	Hudson	4    	137	137	137	137	0109288963	0988458136	5583202246	47	Male
138	Trumaine	Cicculi	Bullant	2894 East Street	American Ash	234  	138	138	138	138	9641415107	7928284472	6360960621	51	Male
139	Jobie	Vogeller	Rainey	74 Russell Drive	Sauthoff	36   	139	139	139	139	6202534230	8114449705	4505487997	56	Female
140	Hasheem	Daffern	McIlwraith	36 Troy Junction	Graceland	10486	140	140	140	140	7305499838	9343581246	0297793462	114	Male
141	Abran	Clendennen	Sarjent	7370 2nd Road	Hovde	245  	141	141	141	141	9465405906	6193745130	3806073341	28	Male
142	Malynda	Wilbraham	Elnaugh	30 Algoma Parkway	Sage	2    	142	142	142	142	7287009676	3046172230	7134862291	58	Genderqueer
143	Robenia	Celiz	Readwin	54 Warner Plaza	Buell	04   	143	143	143	143	5992311564	4460247194	3807985565	25	Female
144	Godart	Henstone	Qusklay	2373 Union Center	Blackbird	46299	144	144	144	144	5512396722	2876450976	9764164803	52	Male
145	Doyle	Thomazin	O'Dooghaine	028 Lighthouse Bay Junction	Carpenter	7755 	145	145	145	145	7509254469	2872823654	0031644147	95	Male
146	Cynthea	Panyer	Neligan	86 Manitowish Trail	Esch	38444	146	146	146	146	5785479389	4466385165	3302105649	37	Female
147	Pattie	McCaughen	Oen	5 Ryan Street	Huxley	53   	147	147	147	147	0721345131	7807972769	3951913762	81	Male
148	Garner	Eckery	Mulvenna	28936 Debra Terrace	Johnson	86319	148	148	148	148	4829189487	4755606020	6031712121	87	Male
149	Allan	Akred	Purdon	04274 Doe Crossing Way	Glendale	1    	149	149	149	149	6255306402	2316161464	1383810117	111	Male
150	Skell	Bensen	Flaunders	233 Elmside Circle	Stone Corner	27425	150	150	150	150	8896657903	9310518855	2991652039	116	Male
151	Sabine	Bazoge	Ockland	5 Nelson Trail	Mesta	311  	151	151	151	151	8170247004	6677259889	8791112508	35	Female
152	Christian	Spurden	Robathon	6 Ruskin Plaza	Anniversary	360  	152	152	152	152	6473036032	7518811626	4798680494	21	Male
153	Suzann	Tomaszkiewicz	Jzak	973 Grover Center	Chinook	93   	153	153	153	153	0346350808	1284932591	0968091024	41	Female
154	Katha	Balle	Jedrzejewsky	7118 Welch Place	Autumn Leaf	159  	154	154	154	154	9398827514	8210143751	3338163673	41	Female
155	Camille	Johnes	Scourgie	456 Burning Wood Street	Sherman	43449	155	155	155	155	2705587195	3418153739	7550908079	12	Genderqueer
156	Elnora	Shovel	Langran	42600 Grasskamp Avenue	Golf View	65   	156	156	156	156	6970785769	8876959963	5479407007	67	Female
157	Korella	Augur	Child	9 Marquette Pass	Golf Course	48   	157	157	157	157	4411631393	5060194280	7263221942	46	Non-binary
158	Esmeralda	Mattisson	Ricarde	44 Nelson Drive	Caliangt	07464	158	158	158	158	5976176259	4836550300	5200179432	16	Female
159	Gregg	McKennan	Prynne	54514 Grasskamp Center	Quincy	557  	159	159	159	159	6819431821	6100576570	4235455451	70	Male
160	Hilton	Smewing	Wynes	16709 Melby Plaza	Ruskin	4001 	160	160	160	160	5266146192	7310469380	3170584820	72	Male
161	Amberly	Ferrey	Sapp	2 Independence Court	Jackson	5    	161	161	161	161	8617685751	2061607322	4460828383	86	Female
162	Adrien	Dowtry	Rich	3 Fairview Junction	Spohn	01137	162	162	162	162	4860238451	8517039335	2532619996	48	Male
163	Esma	Butcher	Rasor	061 Caliangt Junction	Marcy	00   	163	163	163	163	5722879169	7903001787	1748134108	15	Female
164	Dela	Ludvigsen	Ledger	87208 Golf Course Avenue	Linden	03690	164	164	164	164	0199434581	2840880504	7850574079	29	Female
165	Poppy	McQuilliam	Choat	41204 Old Shore Court	Heffernan	874  	165	165	165	165	1559363304	6678792270	4102963170	37	Female
166	Crichton	Bougourd	Amort	177 Schmedeman Drive	Corben	73   	166	166	166	166	5947975289	4671425599	2696460396	84	Male
167	Janeva	Kwietek	Bedells	2 Shelley Terrace	Farmco	031  	167	167	167	167	5123936505	2889915808	1558957944	111	Female
168	Noella	O' Cloney	Orae	93 Bellgrove Junction	Norway Maple	81545	168	168	168	168	4394467713	1383524440	2226267247	14	Female
169	Carlynn	Richardeau	Follacaro	37339 Esker Park	Atwood	5293 	169	169	169	169	9719656603	9251905746	0630567662	70	Female
170	Chadd	Ochterlony	MacKibbon	0556 Talisman Crossing	Acker	6    	170	170	170	170	4718331633	1249970237	5866111462	45	Male
171	Rodrique	Ingry	Hamberstone	7570 Morningstar Junction	Del Mar	78195	171	171	171	171	2854160584	4720351581	1043325697	109	Bigender
172	Morly	Redwall	Stoker	94839 Artisan Point	Fairview	2701 	172	172	172	172	5906299246	2510935585	3495470859	77	Male
173	Marji	Tatterton	Rutigliano	04 Lunder Way	Hayes	8664 	173	173	173	173	4651535178	4092978790	7849744888	76	Female
174	Shelton	Bleasdale	Oxberry	18 Debs Crossing	Sheridan	778  	174	174	174	174	5933897965	6988886273	8692906174	108	Male
175	Douglas	Verralls	Assaf	00 Arrowood Avenue	Susan	9303 	175	175	175	175	1490514007	2116273927	8519052800	12	Male
176	Chuck	Merryman	Trevon	2424 Fisk Terrace	Cordelia	20   	176	176	176	176	9203549366	3290143031	7463771091	83	Male
177	Violetta	Benitez	Danilin	599 Truax Hill	Shelley	27374	177	177	177	177	4474507347	7162282245	4264964636	109	Female
178	Ilaire	Easeman	Teacy	612 Dayton Pass	Sunfield	071  	178	178	178	178	5505933440	1652535373	5683878616	75	Male
179	Ilario	Tickel	Hutchason	4822 Nancy Terrace	Spaight	7    	179	179	179	179	5513121972	2181310661	9375718891	11	Male
180	Othelia	Vaughten	Jaycox	83 Prentice Trail	Burning Wood	1    	180	180	180	180	2180164548	1237986893	8740501132	7	Female
181	Orelia	Goose	Barltrop	8990 Northport Hill	Dahle	2    	181	181	181	181	5632437949	5169512414	5731055815	74	Female
182	Timi	Dominichetti	Richmont	04440 Raven Pass	Dunning	921  	182	182	182	182	9744846046	5511133647	8103707945	4	Female
183	Coralyn	McOwan	Darrington	24852 Anderson Trail	Tennessee	759  	183	183	183	183	3472787260	2670590330	2126530191	29	Female
184	Eduardo	Folds	Cadamy	36159 Erie Avenue	Butternut	784  	184	184	184	184	8396248001	8208441813	6308608181	72	Male
185	Catlin	Boays	Kleinmintz	83012 Caliangt Court	Sullivan	78015	185	185	185	185	2943177598	6526949053	5798480992	12	Female
186	Dolores	Degoey	Von Salzberg	4721 Menomonie Circle	Dayton	2709 	186	186	186	186	0947957812	6638965735	6175343026	110	Female
187	Dirk	Ramble	Flood	439 Washington Drive	Dovetail	8    	187	187	187	187	9123498323	9636094470	4813100279	38	Genderfluid
188	Wendell	Fentem	Locket	69390 Helena Park	Maple Wood	206  	188	188	188	188	6189417736	6228166816	6133324201	75	Male
189	Hal	Girodias	Ivy	9 Kennedy Point	Petterle	61445	189	189	189	189	9713185838	8752527271	0556720881	99	Male
190	Grannie	Qualtrough	Kemmett	514 Golden Leaf Drive	Springs	65   	190	190	190	190	2185031309	5809012647	9110125094	26	Male
191	Lanni	Tees	Dumke	1478 Beilfuss Crossing	3rd	129  	191	191	191	191	7301132980	2171530405	3956983130	102	Female
192	Syman	Alcorn	Dennert	1850 Burrows Point	Browning	62   	192	192	192	192	7201360108	8857162540	4386327339	39	Male
193	Asa	Bayly	Samways	272 Thackeray Pass	Harbort	15   	193	193	193	193	6022438225	8073260743	7609687642	41	Male
194	Esther	Ubanks	Kix	1 Ilene Center	Ilene	0    	194	194	194	194	2853731383	6472149240	0276373057	16	Female
195	Woodie	Blasdale	Buesnel	5 Boyd Drive	Duke	312  	195	195	195	195	3597411703	6905773166	5764396212	92	Male
196	Wandis	Bellelli	Bernlin	64639 Butterfield Junction	Anzinger	79112	196	196	196	196	4566995526	3727189169	1978064756	24	Female
197	Hobey	Strodder	Chavez	61 Mcguire Way	Golf View	93   	197	197	197	197	4256902058	7729205483	7433124373	31	Male
198	Niles	Wrightim	Kirby	95 Amoth Hill	Meadow Valley	60558	198	198	198	198	6850834851	8340091506	6115421705	9	Male
199	Binny	Precious	Mc Dermid	8482 Merry Hill	Starling	02   	199	199	199	199	3427151743	5992773533	9442788728	88	Female
200	Ernesta	Masdon	Spray	44 Redwing Hill	Graedel	5    	200	200	200	200	2622473036	4246792500	0559337027	22	Female
201	Karia	Keasey	Winward	9414 Novick Way	Shelley	3644 	201	201	201	201	0400580349	4589920379	8281163038	44	Female
202	Alfonso	Trehearne	Hawlgarth	492 Summerview Avenue	Debs	90459	202	202	202	202	5131449529	2361923300	1349708550	87	Male
203	Clyde	Kleinmintz	Serck	94727 Debra Road	Mcbride	5305 	203	203	203	203	2408589606	4010436514	1879444259	83	Male
204	Nicko	Eagers	Manuaud	5 Dexter Plaza	Nova	09886	204	204	204	204	8669891794	4350928936	9318537255	16	Male
205	Karry	Stansall	Tweede	9 Jackson Crossing	Declaration	42736	205	205	205	205	2778042210	6888460207	9972744124	34	Female
206	Stepha	Confort	Daniele	9021 Almo Court	Tennyson	6293 	206	206	206	206	7367174754	7775497319	2021369625	52	Female
207	Jeno	Donnison	Bradane	7065 Buhler Pass	Declaration	211  	207	207	207	207	7316841931	0927484129	6089500321	77	Male
208	Skippie	Muffett	Blonden	668 Garrison Place	Old Shore	53556	208	208	208	208	7932927390	8936033700	9299211876	111	Non-binary
209	Giralda	Kloisner	Tumulty	69947 Reindahl Hill	Barby	9    	209	209	209	209	0351130160	3211780114	1706098170	44	Female
210	Bourke	McVanamy	Pickersgill	9749 Hintze Pass	Schlimgen	6    	210	210	210	210	0933565755	3026107727	8796333235	49	Genderqueer
211	Nollie	Trusse	Undy	1 Buhler Trail	Birchwood	471  	211	211	211	211	4736073365	0442044437	8933808272	117	Male
212	Berne	Duxbury	Nock	75 Bunting Crossing	Westerfield	265  	212	212	212	212	3372405439	7320770733	6495548435	16	Male
213	Adan	Fairpo	Dissman	9 Tomscot Avenue	Morrow	520  	213	213	213	213	2708084100	7103324298	1108315216	108	Male
214	Sallee	Anthes	Gronou	4228 Boyd Pass	Lakewood	35440	214	214	214	214	1044592087	2995880281	4886934293	73	Female
215	Shepherd	Cullnean	MacKain	2098 Havey Circle	Dixon	7281 	215	215	215	215	8373514198	6599212182	9483541255	4	Male
216	Hilton	Iacopo	Beldom	43 5th Park	Alpine	0838 	216	216	216	216	5799007972	1434982041	6047413617	41	Male
217	Patricio	Templeman	Streatfield	83528 Grim Terrace	Calypso	291  	217	217	217	217	1000975592	8035280589	9409523478	29	Male
218	Sande	Filyukov	Kunc	64 Calypso Hill	Gerald	0856 	218	218	218	218	3866613474	9759677342	4352047554	103	Female
219	Myca	Cartledge	Grimshaw	4 Golf View Park	Warbler	2325 	219	219	219	219	8153596659	5224789842	7661048116	56	Male
220	Abby	Sugars	Leel	6 Cardinal Drive	Eastwood	787  	220	220	220	220	0390731110	3654071414	9136217395	90	Male
221	Johan	Kitto	Natt	78 Pepper Wood Pass	Mcguire	40321	221	221	221	221	4580390210	8089785735	1044104643	84	Male
222	Linet	Lillo	Frankes	3975 Fallview Hill	Kings	2    	222	222	222	222	6281925408	7395890981	0285692755	25	Female
223	Dame	Luxton	Cussen	0 Nancy Hill	Bay	2772 	223	223	223	223	6855566537	8106615235	2780277440	72	Male
224	Brenna	Teaz	Moorhouse	71108 Monument Park	Bluejay	15   	224	224	224	224	7486814099	3587785775	3476398978	46	Female
225	Chere	Barbosa	Huckabe	67790 Schurz Road	Dottie	003  	225	225	225	225	9682950678	7653903541	8865341858	32	Female
226	Jasen	Vasyutochkin	Casino	470 Mariners Cove Drive	Grim	19   	226	226	226	226	6979521365	1648099408	5689130613	23	Male
227	Dorian	Patkin	List	7090 Ludington Drive	Corscot	17   	227	227	227	227	8884353343	9600126062	6419410789	83	Female
228	Christiane	Oehme	Di Pietro	14 Ruskin Terrace	Gerald	69   	228	228	228	228	7680675074	0456067760	3454648610	72	Female
229	Adan	St. John	Yashanov	28834 Chinook Trail	Blackbird	55   	229	229	229	229	9119237340	7745872464	2634873379	70	Male
230	Margery	Parncutt	Dudman	720 Everett Street	Meadow Ridge	9    	230	230	230	230	0677372299	3221944098	6467587456	76	Female
231	Trudy	Caron	Cavaney	16466 Rusk Terrace	Buena Vista	121  	231	231	231	231	9386936275	5022871556	0476805449	55	Female
232	Rowney	McKiernan	Dudbridge	02778 Shoshone Trail	Manley	58   	232	232	232	232	5789813798	9589800025	7044674984	13	Male
233	Bradly	Trigwell	Dorrance	6 Green Trail	Spohn	4377 	233	233	233	233	2925721613	1903047129	0924844086	59	Male
234	Janina	Louche	Kohn	749 Katie Crossing	Raven	40   	234	234	234	234	5045799665	4838954387	7468991529	96	Female
235	Cyndi	Hamill	Barlee	56285 Coleman Hill	Hermina	137  	235	235	235	235	8919994722	8622233987	8152981818	14	Female
236	Karole	Matschuk	Bachshell	30894 Kennedy Park	Esker	6    	236	236	236	236	4476680224	9332247145	7280144306	25	Genderfluid
237	Joly	Cattel	Aiken	0 Cordelia Lane	Dakota	223  	237	237	237	237	9664051144	0429200323	1093243538	7	Female
238	Alberik	Duval	Elderkin	415 Cherokee Drive	Parkside	2359 	238	238	238	238	3878012543	5502184579	8541145417	100	Male
239	Marla	Giabucci	MacCallion	3 Dryden Road	Farmco	6    	239	239	239	239	7817517533	4528614391	7301219997	114	Genderqueer
240	Dugald	Mawne	Rossbrooke	85 Stoughton Point	Lakewood	3334 	240	240	240	240	0476004969	8400838157	9130043573	40	Male
241	Carrol	Rawlyns	Janouch	96979 Vermont Park	High Crossing	8901 	241	241	241	241	8580161517	8683627799	8910999195	114	Male
242	Cleo	Mecozzi	Comi	4 Manley Parkway	Hallows	18   	242	242	242	242	0861197410	5529377785	5916018614	103	Female
243	Delainey	Snadden	Swatton	3 Esker Plaza	Memorial	78   	243	243	243	243	6100618443	3968830334	6808009422	120	Male
244	Zorana	Cosstick	McAster	044 1st Parkway	American	528  	244	244	244	244	9517813910	1610782631	1643018515	45	Polygender
245	Konstanze	Hagart	Spellicy	52 Transport Crossing	Mockingbird	9458 	245	245	245	245	0161226531	5897919674	9979937904	14	Female
246	Sheena	Belham	Shearme	077 Prentice Parkway	Kingsford	0    	246	246	246	246	2131936451	7805120889	3997837848	99	Female
247	Jacquetta	Aubury	Butterfint	0523 Haas Crossing	Carey	5684 	247	247	247	247	0119868598	3500738478	8814643709	79	Female
248	Oby	Meek	De Bischof	41341 Pine View Lane	Acker	533  	248	248	248	248	9211277957	7866636052	4708499655	68	Male
249	Josie	Batram	Duffer	26299 Redwing Place	Mockingbird	18551	249	249	249	249	2462199012	9978867546	3495106049	75	Agender
250	Waiter	Pocke	Malan	449 Maple Center	Moose	2620 	250	250	250	250	4145331818	9437053243	4226352017	71	Bigender
\.


--
-- TOC entry 5439 (class 0 OID 41060)
-- Dependencies: 238
-- Data for Name: ENCABEZADO_COMPRA_MOBILIARIO; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."ENCABEZADO_COMPRA_MOBILIARIO" (id_compra_mobiliario, fecha_compra_mobiliario, total_compra, id_proveedor_mobiliario) FROM stdin;
1	2025-02-06 00:00:00-06	20	1
2	2025-03-10 00:00:00-06	3	2
3	2025-02-11 00:00:00-06	50	3
4	2025-02-04 00:00:00-06	20	4
5	2024-11-08 00:00:00-06	15	5
6	2024-12-13 00:00:00-06	7	6
7	2025-01-19 00:00:00-06	5	7
8	2025-06-18 00:00:00-06	6	8
9	2025-01-28 00:00:00-06	2	9
10	2024-10-08 00:00:00-06	30	10
11	2024-11-26 00:00:00-06	5	11
12	2025-03-28 00:00:00-06	15	12
13	2025-06-30 00:00:00-06	20	13
14	2025-06-17 00:00:00-06	100	14
15	2025-05-06 00:00:00-06	1	15
16	2025-01-15 00:00:00-06	4	16
17	2025-06-05 00:00:00-06	4	17
18	2025-09-14 00:00:00-06	1	18
19	2025-06-08 00:00:00-06	9	19
20	2025-08-23 00:00:00-06	40	20
21	2025-08-24 00:00:00-06	59	21
22	2024-12-25 00:00:00-06	90	22
23	2025-08-19 00:00:00-06	25	23
24	2025-06-30 00:00:00-06	200	24
25	2025-07-21 00:00:00-06	130	25
26	2025-06-30 00:00:00-06	6	26
27	2025-06-29 00:00:00-06	5	27
28	2025-08-08 00:00:00-06	15	28
29	2025-01-13 00:00:00-06	23	29
30	2025-02-26 00:00:00-06	1	30
31	2024-10-19 00:00:00-06	20	31
32	2025-03-09 00:00:00-06	2	32
33	2024-10-06 00:00:00-06	40	33
34	2025-06-23 00:00:00-06	4	34
35	2025-02-27 00:00:00-06	40	35
36	2024-12-28 00:00:00-06	40	36
37	2025-03-31 00:00:00-06	4	37
38	2025-03-28 00:00:00-06	3	38
39	2025-06-08 00:00:00-06	15	39
40	2025-04-13 00:00:00-06	25	40
41	2025-07-13 00:00:00-06	40	41
42	2025-01-01 00:00:00-06	40	42
43	2025-07-06 00:00:00-06	3	43
44	2025-06-22 00:00:00-06	25	44
45	2025-04-08 00:00:00-06	30	45
46	2024-10-01 00:00:00-06	15	46
47	2025-09-09 00:00:00-06	25	47
48	2025-04-07 00:00:00-06	3	48
49	2025-07-10 00:00:00-06	3	49
50	2024-12-10 00:00:00-06	3	50
51	2024-10-19 00:00:00-06	50	51
52	2025-05-02 00:00:00-06	2	52
53	2025-05-03 00:00:00-06	40	53
54	2025-05-27 00:00:00-06	40	54
55	2024-12-05 00:00:00-06	16	55
56	2025-04-22 00:00:00-06	50	56
57	2024-10-05 00:00:00-06	30	57
58	2025-05-06 00:00:00-06	20	58
59	2025-02-15 00:00:00-06	3	59
60	2025-02-28 00:00:00-06	4	60
61	2025-05-09 00:00:00-06	30	61
62	2025-08-25 00:00:00-06	3	62
63	2025-02-06 00:00:00-06	16	63
64	2025-07-20 00:00:00-06	7	64
65	2025-05-17 00:00:00-06	3	65
66	2025-08-04 00:00:00-06	8	66
67	2025-03-12 00:00:00-06	8	67
68	2025-04-25 00:00:00-06	30	68
69	2025-09-26 00:00:00-06	25	69
70	2024-12-07 00:00:00-06	35	70
71	2024-10-03 00:00:00-06	19	71
72	2025-07-26 00:00:00-06	3	72
73	2025-09-19 00:00:00-06	70	73
74	2025-02-02 00:00:00-06	60	74
75	2025-02-05 00:00:00-06	13	75
76	2025-07-16 00:00:00-06	30	76
77	2025-05-30 00:00:00-06	13	77
78	2025-08-14 00:00:00-06	3	78
79	2024-11-21 00:00:00-06	18	79
80	2025-04-20 00:00:00-06	5	80
81	2024-11-01 00:00:00-06	25	81
82	2025-05-12 00:00:00-06	5	82
83	2025-04-25 00:00:00-06	5	83
84	2025-07-31 00:00:00-06	7	84
85	2025-07-25 00:00:00-06	9	85
86	2025-06-04 00:00:00-06	30	86
87	2024-12-18 00:00:00-06	10	87
88	2024-12-31 00:00:00-06	1	88
89	2025-09-11 00:00:00-06	6	89
90	2025-01-17 00:00:00-06	4	90
91	2024-10-30 00:00:00-06	35	91
92	2025-05-23 00:00:00-06	13	92
93	2024-11-30 00:00:00-06	15	93
94	2024-12-02 00:00:00-06	7	94
95	2025-07-24 00:00:00-06	20	95
96	2025-01-08 00:00:00-06	3	96
97	2024-12-22 00:00:00-06	60	97
98	2025-09-21 00:00:00-06	100	98
99	2024-12-17 00:00:00-06	40	99
100	2025-07-23 00:00:00-06	50	100
101	2025-02-28 00:00:00-06	30	101
102	2024-11-30 00:00:00-06	30	102
103	2024-12-01 00:00:00-06	4	103
104	2025-01-11 00:00:00-06	70	104
105	2024-11-14 00:00:00-06	80	105
106	2025-08-28 00:00:00-06	6	106
107	2025-09-03 00:00:00-06	35	107
108	2025-06-28 00:00:00-06	4	108
109	2024-10-12 00:00:00-06	250	109
110	2025-03-12 00:00:00-06	20	110
111	2025-03-07 00:00:00-06	20	111
112	2025-04-05 00:00:00-06	30	112
113	2025-02-08 00:00:00-06	60	113
114	2025-01-06 00:00:00-06	20	114
115	2024-10-23 00:00:00-06	35	115
116	2025-07-19 00:00:00-06	2	116
117	2025-09-18 00:00:00-06	30	117
118	2025-02-07 00:00:00-06	35	118
119	2024-12-26 00:00:00-06	19	119
120	2025-09-24 00:00:00-06	5	120
121	2024-11-17 00:00:00-06	7	121
122	2024-12-12 00:00:00-06	7	122
123	2024-10-11 00:00:00-06	3	123
124	2025-06-19 00:00:00-06	60	124
125	2025-07-21 00:00:00-06	30	125
126	2025-02-05 00:00:00-06	100	126
127	2025-03-22 00:00:00-06	20	127
128	2024-11-25 00:00:00-06	2	128
129	2025-02-20 00:00:00-06	7	129
130	2024-12-24 00:00:00-06	26	130
131	2025-07-26 00:00:00-06	6	131
132	2025-06-04 00:00:00-06	3	132
133	2024-10-07 00:00:00-06	15	133
134	2025-04-29 00:00:00-06	4	134
135	2025-08-19 00:00:00-06	4	135
136	2024-10-25 00:00:00-06	30	136
137	2024-10-21 00:00:00-06	4	137
138	2025-09-13 00:00:00-06	100	138
139	2025-04-04 00:00:00-06	20	139
140	2024-12-19 00:00:00-06	3	140
141	2025-08-17 00:00:00-06	40	141
142	2025-02-13 00:00:00-06	45	142
143	2025-05-10 00:00:00-06	3	143
144	2024-10-17 00:00:00-06	4	144
145	2025-03-19 00:00:00-06	3	145
146	2025-07-26 00:00:00-06	3	146
147	2025-01-17 00:00:00-06	2	147
148	2024-10-05 00:00:00-06	50	148
149	2024-11-10 00:00:00-06	6	149
150	2025-02-05 00:00:00-06	25	150
151	2025-05-11 00:00:00-06	25	151
152	2025-08-29 00:00:00-06	4	152
153	2025-01-24 00:00:00-06	5	153
154	2025-02-26 00:00:00-06	200	154
155	2025-07-02 00:00:00-06	6	155
156	2024-12-02 00:00:00-06	40	156
157	2025-07-13 00:00:00-06	40	157
158	2025-05-15 00:00:00-06	70	158
159	2025-05-01 00:00:00-06	35	159
160	2025-07-20 00:00:00-06	3	160
161	2025-03-13 00:00:00-06	1	161
162	2025-07-28 00:00:00-06	25	162
163	2025-02-18 00:00:00-06	2	163
164	2025-04-22 00:00:00-06	50	164
165	2025-05-02 00:00:00-06	4	165
166	2025-02-21 00:00:00-06	5	166
167	2025-05-09 00:00:00-06	16	167
168	2025-02-26 00:00:00-06	50	168
169	2025-06-11 00:00:00-06	2	169
170	2024-11-29 00:00:00-06	20	170
171	2025-01-11 00:00:00-06	20	171
172	2025-05-27 00:00:00-06	3	172
173	2025-07-21 00:00:00-06	5	173
174	2024-10-20 00:00:00-06	4	174
175	2024-11-17 00:00:00-06	15	175
176	2024-12-04 00:00:00-06	5	176
177	2025-01-22 00:00:00-06	19	177
178	2024-11-10 00:00:00-06	4	178
179	2025-06-07 00:00:00-06	250	179
180	2025-01-24 00:00:00-06	50	180
181	2025-09-11 00:00:00-06	60	181
182	2025-02-24 00:00:00-06	4	182
183	2025-08-18 00:00:00-06	90	183
184	2024-12-07 00:00:00-06	25	184
185	2025-09-24 00:00:00-06	5	185
186	2025-07-15 00:00:00-06	5	186
187	2025-05-12 00:00:00-06	4	187
188	2025-05-12 00:00:00-06	23	188
189	2025-04-13 00:00:00-06	30	189
190	2025-05-24 00:00:00-06	3	190
191	2025-06-11 00:00:00-06	4	191
192	2024-12-01 00:00:00-06	4	192
193	2025-04-16 00:00:00-06	3	193
194	2025-08-31 00:00:00-06	50	194
195	2025-07-25 00:00:00-06	35	195
196	2025-02-08 00:00:00-06	25	196
197	2024-11-26 00:00:00-06	45	197
198	2025-05-10 00:00:00-06	70	198
199	2025-03-20 00:00:00-06	3	199
200	2025-09-20 00:00:00-06	15	200
201	2025-03-17 00:00:00-06	5	201
202	2025-06-09 00:00:00-06	30	202
203	2024-12-01 00:00:00-06	16	203
204	2025-01-28 00:00:00-06	50	204
205	2025-01-16 00:00:00-06	11	205
206	2024-12-26 00:00:00-06	5	206
207	2025-07-06 00:00:00-06	30	207
208	2024-12-25 00:00:00-06	70	208
209	2025-06-11 00:00:00-06	60	209
210	2024-12-24 00:00:00-06	30	210
211	2025-01-30 00:00:00-06	40	211
212	2025-02-19 00:00:00-06	45	212
213	2025-03-27 00:00:00-06	30	213
214	2025-04-09 00:00:00-06	20	214
215	2025-04-26 00:00:00-06	3	215
216	2024-12-17 00:00:00-06	100	216
217	2024-12-07 00:00:00-06	6	217
218	2025-08-27 00:00:00-06	35	218
219	2024-10-25 00:00:00-06	4	219
220	2025-05-30 00:00:00-06	2	220
221	2025-06-27 00:00:00-06	35	221
222	2025-05-03 00:00:00-06	3	222
223	2025-03-18 00:00:00-06	30	223
224	2024-12-09 00:00:00-06	13	224
225	2025-09-23 00:00:00-06	2	225
226	2025-05-05 00:00:00-06	3	226
227	2025-06-11 00:00:00-06	80	227
228	2025-04-23 00:00:00-06	30	228
229	2025-01-04 00:00:00-06	100	229
230	2025-02-15 00:00:00-06	50	230
231	2024-11-18 00:00:00-06	50	231
232	2025-08-18 00:00:00-06	2	232
233	2025-07-07 00:00:00-06	50	233
234	2024-10-30 00:00:00-06	20	234
235	2025-03-13 00:00:00-06	16	235
236	2025-07-17 00:00:00-06	10	236
237	2024-10-19 00:00:00-06	3	237
238	2025-07-12 00:00:00-06	17	238
239	2025-05-04 00:00:00-06	30	239
240	2025-01-29 00:00:00-06	25	240
241	2025-04-30 00:00:00-06	5	241
242	2024-12-08 00:00:00-06	60	242
243	2025-02-24 00:00:00-06	80	243
244	2025-05-29 00:00:00-06	40	244
245	2025-02-28 00:00:00-06	40	245
246	2025-04-11 00:00:00-06	5	246
247	2025-04-22 00:00:00-06	30	247
248	2025-08-02 00:00:00-06	4	248
249	2025-06-04 00:00:00-06	13	249
250	2025-02-05 00:00:00-06	4	250
\.


--
-- TOC entry 5440 (class 0 OID 41063)
-- Dependencies: 239
-- Data for Name: ENCABEZADO_PLATILLOS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."ENCABEZADO_PLATILLOS" (id_platillo, nombre, costo, precio) FROM stdin;
1	Mercedes-Benz	3.99	299.99
2	Ford	1.99	7.99
3	Dodge	6.99	69.99
4	Dodge	7.49	29.99
5	Chevrolet	7.99	79.99
6	BMW	29.99	5.49
7	Ford	5.99	9.49
8	Volkswagen	19.99	79.99
9	Ford	16.99	3.99
10	Lexus	3.79	5.99
11	Chevrolet	24.99	0.79
12	GMC	1.79	14.99
13	Maybach	3.99	5.99
14	Geo	54.99	34.99
15	Volvo	49.99	18.99
16	Dodge	34.99	3.49
17	Ford	3.99	7.19
18	GMC	12.99	14.99
19	Dodge	7.99	4.29
20	Buick	39.99	3.99
21	Chrysler	35.00	2.79
22	Infiniti	34.99	29.99
23	Land Rover	49.99	19.99
24	Hyundai	29.99	9.99
25	Ford	22.99	29.99
26	Subaru	6.49	3.49
27	Maserati	4.49	8.99
28	Mercedes-Benz	12.99	59.99
29	Lotus	59.99	49.99
30	Buick	19.99	3.49
31	Mercury	2.99	99.99
32	Mitsubishi	29.99	9.99
33	Chevrolet	8.99	39.99
34	Chevrolet	34.99	6.49
35	Ford	3.49	4.99
36	Chevrolet	2.79	2.99
37	Infiniti	3.29	15.99
38	Toyota	22.99	8.99
39	Mazda	49.99	14.99
40	Ford	1.29	3.79
41	GMC	3.49	29.99
42	Mitsubishi	2.99	24.99
43	Chevrolet	9.99	29.99
44	Pontiac	49.99	59.99
45	Mitsubishi	5.29	899.99
46	Subaru	2.99	19.99
47	Ford	15.99	2.29
48	Volvo	5.99	29.99
49	Lamborghini	199.99	1.29
50	Pontiac	49.99	2.99
51	Porsche	2.99	3.49
52	Toyota	29.99	1.99
53	Ford	4.29	19.99
54	Pontiac	24.99	14.99
55	Acura	29.99	12.99
56	Chevrolet	19.99	3.29
57	Nissan	5.49	3.49
58	Chevrolet	4.99	2.99
59	Nissan	15.99	3.49
60	Toyota	49.99	79.99
61	Oldsmobile	24.99	3.99
62	Lamborghini	34.99	14.99
63	Ford	4.99	129.99
64	Nissan	29.99	3.79
65	Dodge	2.49	4.99
66	Mercedes-Benz	8.49	49.99
67	Chevrolet	49.99	22.99
68	Ford	45.00	2.49
69	Ford	14.99	15.99
70	Chrysler	8.99	5.99
71	Mercedes-Benz	2.99	2.59
72	Porsche	5.49	25.00
73	Lamborghini	3.49	14.99
74	Lincoln	15.99	3.99
75	BMW	1.99	4.29
76	Oldsmobile	4.49	59.99
77	Toyota	3.29	3.99
78	Dodge	49.99	19.99
79	Suzuki	3.69	299.99
80	Land Rover	24.99	22.99
81	Jaguar	249.99	3.29
82	Saab	3.19	39.99
83	Mercury	2.49	2.29
84	Ford	3.99	4.99
85	Toyota	2.49	4.50
86	Buick	4.99	39.99
87	Volkswagen	12.99	5.49
88	Honda	19.99	29.99
89	Dodge	6.49	49.99
90	Mitsubishi	19.99	44.99
91	Ford	1.50	24.99
92	Aston Martin	44.99	15.99
93	Mazda	18.99	22.99
94	Ford	39.99	2.99
95	Buick	2.49	18.99
96	Pontiac	0.79	19.99
97	Cadillac	34.99	19.99
98	Mercedes-Benz	34.99	49.99
99	Audi	34.99	59.99
100	Rolls-Royce	3.49	2.99
101	Mitsubishi	19.99	139.99
102	Volkswagen	199.99	3.49
103	GMC	6.29	49.99
104	Honda	49.99	30.00
105	Toyota	39.99	3.99
106	GMC	49.99	59.99
107	Mercedes-Benz	29.99	6.99
108	Pontiac	5.99	24.99
109	Cadillac	39.99	4.50
110	Nissan	109.99	14.99
111	Volkswagen	7.49	29.99
112	Volvo	18.99	3.59
113	Mercury	6.99	39.99
114	Chevrolet	14.99	29.99
115	Jeep	0.99	4.49
116	Chevrolet	25.99	18.99
117	Mitsubishi	3.99	2.79
118	Land Rover	14.99	34.99
119	Lincoln	2.79	79.99
120	Nissan	4.29	1.99
121	Toyota	11.99	3.99
122	Toyota	79.99	49.99
123	Suzuki	19.99	19.99
124	Nissan	4.99	3.79
125	Kia	3.79	89.99
126	Chevrolet	15.99	4.49
127	Mercedes-Benz	3.99	2.49
128	Pontiac	1.99	5.99
129	Mitsubishi	35.00	249.99
130	Dodge	2.49	39.99
131	MINI	3.29	39.99
132	Oldsmobile	8.49	19.99
133	Mercury	3.49	2.79
134	Oldsmobile	34.99	39.99
135	Plymouth	29.99	59.99
136	Infiniti	4.29	3.49
137	Volkswagen	24.99	14.99
138	Toyota	1.79	3.29
139	Chrysler	19.99	2.49
140	Pontiac	19.99	89.99
141	Lexus	4.49	49.99
142	Audi	6.99	99.99
143	Dodge	22.99	8.49
144	Mercedes-Benz	4.99	3.79
145	Mazda	6.99	14.99
146	Toyota	79.99	8.99
147	Mercedes-Benz	3.50	3.29
148	Ford	39.99	19.99
149	Isuzu	9.99	15.99
150	Chevrolet	24.99	2.99
151	Mercury	3.99	4.99
152	Porsche	25.00	19.99
153	Ford	39.99	22.99
154	Toyota	4.19	3.49
155	Mazda	4.99	199.99
156	Chrysler	29.99	3.79
157	Toyota	59.99	39.99
158	Toyota	79.99	19.99
159	Toyota	29.99	2.79
160	Volkswagen	2.99	49.99
161	Porsche	2.99	3.49
162	GMC	5.99	19.99
163	Ford	39.99	99.99
164	Mitsubishi	79.99	4.99
165	Chevrolet	19.99	2.99
166	Chrysler	34.99	15.99
167	Infiniti	39.99	2.99
168	Mazda	4.99	34.99
169	Nissan	3.99	22.99
170	Buick	39.99	3.29
171	Saturn	3.59	3.49
172	Chevrolet	34.99	2.49
173	Dodge	49.99	12.99
174	Nissan	39.99	99.99
175	BMW	14.99	2.29
176	Dodge	3.19	25.99
177	Chevrolet	4.29	12.99
178	Ford	3.79	24.99
179	Land Rover	129.99	3.49
180	Cadillac	24.99	59.99
181	BMW	39.99	69.99
182	Mitsubishi	6.99	4.29
183	Pontiac	6.49	3.49
184	GMC	3.29	89.99
185	Dodge	3.79	899.99
186	Saab	18.99	29.99
187	Infiniti	5.49	2.50
188	Nissan	15.99	6.49
189	Chevrolet	89.99	29.99
190	Cadillac	24.99	8.99
191	Mercedes-Benz	89.99	7.99
192	Ford	89.99	22.99
193	GMC	8.99	15.99
194	Mercury	2.49	59.99
195	Mercury	34.99	7.99
196	Mercedes-Benz	5.99	89.99
197	Cadillac	15.99	3.99
198	Kia	22.99	6.99
199	Chevrolet	19.99	22.99
200	Mitsubishi	19.99	39.99
201	Jeep	2.99	4.99
202	Kia	3.99	1.29
203	Mitsubishi	59.99	19.99
204	Chevrolet	109.99	3.29
205	Nissan	19.99	3.29
206	Buick	4.99	29.99
207	Mitsubishi	44.99	59.99
208	Mitsubishi	129.99	4.19
209	Subaru	19.99	6.49
210	Mitsubishi	5.49	59.99
211	Mercury	14.99	4.29
212	Suzuki	2.89	44.99
213	Subaru	49.99	3.99
214	Alfa Romeo	3.59	99.99
215	Dodge	3.99	5.99
216	GMC	25.00	14.99
217	Chevrolet	49.99	2.49
218	Chevrolet	24.99	26.99
219	Mercedes-Benz	29.99	1.99
220	Honda	69.99	22.99
221	Mercury	45.99	34.99
222	Toyota	3.29	15.99
223	Lexus	2.49	29.99
224	Volkswagen	89.99	4.99
225	Nissan	4.99	24.99
226	Ford	3.99	3.49
227	Porsche	4.29	49.99
228	Toyota	399.99	129.99
229	Hyundai	69.99	4.99
230	Acura	39.99	24.99
231	Chevrolet	79.99	29.99
232	Mazda	3.29	49.99
233	Chevrolet	4.49	22.99
234	Lexus	3.79	79.99
235	Chevrolet	5.99	8.49
236	Ford	3.99	14.99
237	BMW	2.49	34.99
238	Nissan	3.49	18.99
239	Toyota	34.99	8.99
240	Toyota	6.29	2.39
241	MINI	29.99	3.49
242	Acura	2.49	129.99
243	Dodge	25.00	3.99
244	Toyota	29.99	99.99
245	BMW	89.99	2.99
246	Chevrolet	59.99	24.99
247	Mazda	3.49	2.99
248	Mercury	15.99	49.99
249	Lexus	44.99	18.99
250	Nissan	29.99	39.99
\.


--
-- TOC entry 5441 (class 0 OID 41066)
-- Dependencies: 240
-- Data for Name: ESTACIONAMIENTOS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."ESTACIONAMIENTOS" (id_estacionamiento, capacidad, numero_plazas, id_sucursal) FROM stdin;
1	22	1	1
2	28	3	2
3	15	20	3
4	21	13	4
5	21	1	5
6	30	9	6
7	9	11	7
8	41	4	8
9	24	16	9
10	38	16	10
11	47	20	11
12	45	18	12
13	28	6	13
14	49	2	14
15	17	13	15
16	28	10	16
17	38	14	17
18	34	8	18
19	5	6	19
20	38	20	20
21	43	10	21
22	23	19	22
23	7	18	23
24	16	2	24
25	22	11	25
26	21	4	26
27	39	18	27
28	9	5	28
29	43	7	29
30	2	10	30
31	32	13	31
32	42	1	32
33	33	19	33
34	38	10	34
35	23	9	35
36	17	13	36
37	5	16	37
38	30	18	38
39	2	8	39
40	9	20	40
41	30	13	41
42	22	9	42
43	38	5	43
44	18	8	44
45	31	19	45
46	19	15	46
47	42	5	47
48	40	11	48
49	16	8	49
50	10	19	50
51	2	8	51
52	25	8	52
53	3	1	53
54	3	4	54
55	6	20	55
56	12	17	56
57	4	17	57
58	15	15	58
59	50	4	59
60	30	9	60
61	19	9	61
62	30	1	62
63	29	10	63
64	11	8	64
65	2	2	65
66	36	16	66
67	42	12	67
68	36	3	68
69	4	14	69
70	3	10	70
71	28	2	71
72	26	19	72
73	12	8	73
74	24	13	74
75	12	9	75
76	1	15	76
77	11	19	77
78	9	12	78
79	23	3	79
80	28	9	80
81	47	5	81
82	23	7	82
83	11	7	83
84	41	19	84
85	45	10	85
86	50	6	86
87	22	8	87
88	8	2	88
89	13	20	89
90	41	11	90
91	35	11	91
92	7	16	92
93	31	6	93
94	25	1	94
95	25	16	95
96	11	7	96
97	19	19	97
98	12	17	98
99	33	6	99
100	15	7	100
101	8	2	101
102	20	1	102
103	28	17	103
104	26	7	104
105	36	2	105
106	21	13	106
107	35	13	107
108	43	5	108
109	5	17	109
110	47	19	110
111	47	4	111
112	46	16	112
113	40	2	113
114	18	13	114
115	43	8	115
116	36	5	116
117	27	13	117
118	12	1	118
119	49	1	119
120	15	2	120
121	10	1	121
122	6	5	122
123	3	5	123
124	6	20	124
125	39	16	125
126	16	2	126
127	47	1	127
128	27	14	128
129	9	3	129
130	43	9	130
131	41	4	131
132	30	1	132
133	39	3	133
134	17	7	134
135	3	12	135
136	45	18	136
137	9	2	137
138	18	4	138
139	22	13	139
140	17	16	140
141	33	7	141
142	36	8	142
143	5	20	143
144	8	14	144
145	11	15	145
146	27	2	146
147	11	17	147
148	24	14	148
149	6	5	149
150	48	20	150
151	35	14	151
152	50	11	152
153	45	3	153
154	18	6	154
155	31	8	155
156	40	18	156
157	20	11	157
158	44	1	158
159	24	11	159
160	31	17	160
161	48	20	161
162	49	8	162
163	25	6	163
164	34	15	164
165	40	9	165
166	41	4	166
167	42	10	167
168	48	19	168
169	46	9	169
170	12	17	170
171	20	3	171
172	39	8	172
173	28	2	173
174	39	7	174
175	33	14	175
176	39	1	176
177	21	10	177
178	42	19	178
179	48	20	179
180	43	8	180
181	48	9	181
182	19	10	182
183	12	12	183
184	48	2	184
185	16	5	185
186	1	18	186
187	12	8	187
188	20	3	188
189	4	12	189
190	4	5	190
191	46	9	191
192	48	3	192
193	28	17	193
194	38	5	194
195	50	9	195
196	38	7	196
197	10	11	197
198	12	2	198
199	17	10	199
200	50	16	200
201	31	12	201
202	1	1	202
203	2	6	203
204	43	18	204
205	33	13	205
206	2	10	206
207	48	3	207
208	1	20	208
209	1	3	209
210	48	12	210
211	30	18	211
212	11	2	212
213	17	3	213
214	50	6	214
215	23	9	215
216	28	5	216
217	21	9	217
218	2	9	218
219	29	11	219
220	5	12	220
221	38	16	221
222	41	7	222
223	37	12	223
224	2	7	224
225	20	13	225
226	45	9	226
227	3	17	227
228	25	15	228
229	46	10	229
230	22	13	230
231	8	13	231
232	32	10	232
233	34	18	233
234	10	6	234
235	9	1	235
236	22	15	236
237	46	15	237
238	27	15	238
239	28	11	239
240	26	17	240
241	16	20	241
242	27	20	242
243	27	4	243
244	29	1	244
245	38	15	245
246	43	16	246
247	34	3	247
248	44	15	248
249	27	15	249
250	48	11	250
\.


--
-- TOC entry 5442 (class 0 OID 41069)
-- Dependencies: 241
-- Data for Name: ESTADOS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."ESTADOS" (id_estado, nombre_estado) FROM stdin;
2	Mexico
3	Mexico
4	Mexico
5	Mexico
6	Mexico
7	Mexico
8	Mexico
9	Mexico
10	Mexico
11	Mexico
12	Mexico
13	Mexico
14	Mexico
15	Mexico
16	Mexico
17	Mexico
18	Mexico
19	Mexico
20	Mexico
21	Mexico
22	Mexico
23	Mexico
24	Mexico
25	Mexico
26	Mexico
27	Mexico
28	Mexico
29	Mexico
30	Mexico
31	Mexico
32	Mexico
33	Mexico
34	Mexico
35	Mexico
36	Mexico
37	Mexico
38	Mexico
39	Mexico
40	Mexico
41	Mexico
42	Mexico
43	Mexico
44	Mexico
45	Mexico
46	Mexico
47	Mexico
48	Mexico
49	Mexico
50	Mexico
51	Mexico
52	Mexico
53	Mexico
54	Mexico
55	Mexico
56	Mexico
57	Mexico
58	Mexico
59	Mexico
60	Mexico
61	Mexico
62	Mexico
63	Mexico
64	Mexico
65	Mexico
66	Mexico
67	Mexico
68	Mexico
69	Mexico
70	Mexico
71	Mexico
72	Mexico
73	Mexico
74	Mexico
75	Mexico
76	Mexico
77	Mexico
78	Mexico
79	Mexico
80	Mexico
81	Mexico
82	Mexico
83	Mexico
84	Mexico
85	Mexico
86	Mexico
87	Mexico
88	Mexico
89	Mexico
90	Mexico
91	Mexico
92	Mexico
93	Mexico
94	Mexico
95	Mexico
96	Mexico
97	Mexico
98	Mexico
99	Mexico
100	Mexico
101	Mexico
102	Mexico
103	Mexico
104	Mexico
105	Mexico
106	Mexico
107	Mexico
108	Mexico
109	Mexico
110	Mexico
111	Mexico
112	Mexico
113	Mexico
114	Mexico
115	Mexico
116	Mexico
117	Mexico
118	Mexico
119	Mexico
120	Mexico
121	Mexico
122	Mexico
123	Mexico
124	Mexico
125	Mexico
126	Mexico
127	Mexico
128	Mexico
129	Mexico
130	Mexico
131	Mexico
132	Mexico
133	Mexico
134	Mexico
135	Mexico
136	Mexico
137	Mexico
138	Mexico
139	Mexico
140	Mexico
141	Mexico
142	Mexico
143	Mexico
144	Mexico
145	Mexico
146	Mexico
147	Mexico
148	Mexico
149	Mexico
150	Mexico
151	Mexico
152	Mexico
153	Mexico
154	Mexico
155	Mexico
156	Mexico
157	Mexico
158	Mexico
159	Mexico
160	Mexico
161	Mexico
162	Mexico
163	Mexico
164	Mexico
165	Mexico
166	Mexico
167	Mexico
168	Mexico
169	Mexico
170	Mexico
171	Mexico
172	Mexico
173	Mexico
174	Mexico
175	Mexico
176	Mexico
177	Mexico
178	Mexico
179	Mexico
180	Mexico
181	Mexico
182	Mexico
183	Mexico
184	Mexico
185	Mexico
186	Mexico
187	Mexico
188	Mexico
189	Mexico
190	Mexico
191	Mexico
192	Mexico
193	Mexico
194	Mexico
195	Mexico
196	Mexico
197	Mexico
198	Mexico
199	Mexico
200	Mexico
201	Mexico
202	Mexico
203	Mexico
204	Mexico
205	Mexico
206	Mexico
207	Mexico
208	Mexico
209	Mexico
210	Mexico
211	Mexico
212	Mexico
213	Mexico
214	Mexico
215	Mexico
216	Mexico
217	Mexico
218	Mexico
219	Mexico
220	Mexico
221	Mexico
222	Mexico
223	Mexico
224	Mexico
225	Mexico
226	Mexico
227	Mexico
228	Mexico
229	Mexico
230	Mexico
231	Mexico
232	Mexico
233	Mexico
234	Mexico
235	Mexico
236	Mexico
237	Mexico
238	Mexico
239	Mexico
240	Mexico
241	Mexico
242	Mexico
243	Mexico
244	Mexico
245	Mexico
246	Mexico
247	Mexico
248	Mexico
249	Mexico
250	Mexico
251	Mexico
252	Mexico
253	Mexico
254	Mexico
255	Mexico
256	Mexico
257	Mexico
258	Mexico
259	Mexico
260	Mexico
261	Mexico
262	Mexico
263	Mexico
264	Mexico
265	Mexico
266	Mexico
267	Mexico
268	Mexico
269	Mexico
270	Mexico
271	Mexico
272	Mexico
273	Mexico
274	Mexico
275	Mexico
276	Mexico
277	Mexico
278	Mexico
279	Mexico
280	Mexico
281	Mexico
282	Mexico
283	Mexico
284	Mexico
285	Mexico
286	Mexico
287	Mexico
288	Mexico
289	Mexico
290	Mexico
291	Mexico
292	Mexico
293	Mexico
294	Mexico
295	Mexico
296	Mexico
297	Mexico
298	Mexico
299	Mexico
300	Mexico
301	Mexico
302	Mexico
303	Mexico
304	Mexico
305	Mexico
306	Mexico
307	Mexico
308	Mexico
309	Mexico
310	Mexico
311	Mexico
312	Mexico
313	Mexico
314	Mexico
315	Mexico
316	Mexico
317	Mexico
318	Mexico
319	Mexico
320	Mexico
321	Mexico
322	Mexico
323	Mexico
324	Mexico
325	Mexico
326	Mexico
327	Mexico
328	Mexico
329	Mexico
330	Mexico
331	Mexico
332	Mexico
333	Mexico
334	Mexico
335	Mexico
336	Mexico
337	Mexico
338	Mexico
339	Mexico
340	Mexico
341	Mexico
342	Mexico
343	Mexico
344	Mexico
345	Mexico
346	Mexico
347	Mexico
348	Mexico
349	Mexico
350	Mexico
351	Mexico
352	Mexico
353	Mexico
354	Mexico
355	Mexico
356	Mexico
357	Mexico
358	Mexico
359	Mexico
360	Mexico
361	Mexico
362	Mexico
363	Mexico
364	Mexico
365	Mexico
366	Mexico
367	Mexico
368	Mexico
369	Mexico
370	Mexico
371	Mexico
372	Mexico
373	Mexico
374	Mexico
375	Mexico
376	Mexico
377	Mexico
378	Mexico
379	Mexico
380	Mexico
381	Mexico
382	Mexico
383	Mexico
384	Mexico
385	Mexico
386	Mexico
387	Mexico
388	Mexico
389	Mexico
390	Mexico
391	Mexico
392	Mexico
393	Mexico
394	Mexico
395	Mexico
396	Mexico
397	Mexico
398	Mexico
399	Mexico
400	Mexico
401	Mexico
402	Mexico
403	Mexico
404	Mexico
405	Mexico
406	Mexico
407	Mexico
408	Mexico
409	Mexico
410	Mexico
411	Mexico
412	Mexico
413	Mexico
414	Mexico
415	Mexico
416	Mexico
417	Mexico
418	Mexico
419	Mexico
420	Mexico
421	Mexico
422	Mexico
423	Mexico
424	Mexico
425	Mexico
426	Mexico
427	Mexico
428	Mexico
429	Mexico
430	Mexico
431	Mexico
432	Mexico
433	Mexico
434	Mexico
435	Mexico
436	Mexico
437	Mexico
438	Mexico
439	Mexico
440	Mexico
441	Mexico
442	Mexico
443	Mexico
444	Mexico
445	Mexico
446	Mexico
447	Mexico
448	Mexico
449	Mexico
450	Mexico
451	Mexico
452	Mexico
453	Mexico
454	Mexico
455	Mexico
456	Mexico
457	Mexico
458	Mexico
459	Mexico
460	Mexico
461	Mexico
462	Mexico
463	Mexico
464	Mexico
465	Mexico
466	Mexico
467	Mexico
468	Mexico
469	Mexico
470	Mexico
471	Mexico
472	Mexico
473	Mexico
474	Mexico
475	Mexico
476	Mexico
477	Mexico
478	Mexico
479	Mexico
480	Mexico
481	Mexico
482	Mexico
483	Mexico
484	Mexico
485	Mexico
486	Mexico
487	Mexico
488	Mexico
489	Mexico
490	Mexico
491	Mexico
492	Mexico
493	Mexico
494	Mexico
495	Mexico
496	Mexico
497	Mexico
498	Mexico
499	Mexico
500	Mexico
501	Mexico
502	Mexico
503	Mexico
504	Mexico
505	Mexico
506	Mexico
507	Mexico
508	Mexico
509	Mexico
510	Mexico
511	Mexico
512	Mexico
513	Mexico
514	Mexico
515	Mexico
516	Mexico
517	Mexico
518	Mexico
519	Mexico
520	Mexico
521	Mexico
522	Mexico
523	Mexico
524	Mexico
525	Mexico
526	Mexico
527	Mexico
528	Mexico
529	Mexico
530	Mexico
531	Mexico
532	Mexico
533	Mexico
534	Mexico
535	Mexico
536	Mexico
537	Mexico
538	Mexico
539	Mexico
540	Mexico
541	Mexico
542	Mexico
543	Mexico
544	Mexico
545	Mexico
546	Mexico
547	Mexico
548	Mexico
549	Mexico
550	Mexico
551	Mexico
552	Mexico
553	Mexico
554	Mexico
555	Mexico
556	Mexico
557	Mexico
558	Mexico
559	Mexico
560	Mexico
561	Mexico
562	Mexico
563	Mexico
564	Mexico
565	Mexico
566	Mexico
567	Mexico
568	Mexico
569	Mexico
570	Mexico
571	Mexico
572	Mexico
573	Mexico
574	Mexico
575	Mexico
576	Mexico
577	Mexico
578	Mexico
579	Mexico
580	Mexico
581	Mexico
582	Mexico
583	Mexico
584	Mexico
585	Mexico
586	Mexico
587	Mexico
588	Mexico
589	Mexico
590	Mexico
591	Mexico
592	Mexico
593	Mexico
594	Mexico
595	Mexico
596	Mexico
597	Mexico
598	Mexico
599	Mexico
600	Mexico
601	Mexico
602	Mexico
603	Mexico
604	Mexico
605	Mexico
606	Mexico
607	Mexico
608	Mexico
609	Mexico
610	Mexico
611	Mexico
612	Mexico
613	Mexico
614	Mexico
615	Mexico
616	Mexico
617	Mexico
618	Mexico
619	Mexico
620	Mexico
621	Mexico
622	Mexico
623	Mexico
624	Mexico
625	Mexico
626	Mexico
627	Mexico
628	Mexico
629	Mexico
630	Mexico
631	Mexico
632	Mexico
633	Mexico
634	Mexico
635	Mexico
636	Mexico
637	Mexico
638	Mexico
639	Mexico
640	Mexico
641	Mexico
642	Mexico
643	Mexico
644	Mexico
645	Mexico
646	Mexico
647	Mexico
648	Mexico
649	Mexico
650	Mexico
651	Mexico
652	Mexico
653	Mexico
654	Mexico
655	Mexico
656	Mexico
657	Mexico
658	Mexico
659	Mexico
660	Mexico
661	Mexico
662	Mexico
663	Mexico
664	Mexico
665	Mexico
666	Mexico
667	Mexico
668	Mexico
669	Mexico
670	Mexico
671	Mexico
672	Mexico
673	Mexico
674	Mexico
675	Mexico
676	Mexico
677	Mexico
678	Mexico
679	Mexico
680	Mexico
681	Mexico
682	Mexico
683	Mexico
684	Mexico
685	Mexico
686	Mexico
687	Mexico
688	Mexico
689	Mexico
690	Mexico
691	Mexico
692	Mexico
693	Mexico
694	Mexico
695	Mexico
696	Mexico
697	Mexico
698	Mexico
699	Mexico
700	Mexico
701	Mexico
702	Mexico
703	Mexico
704	Mexico
705	Mexico
706	Mexico
707	Mexico
708	Mexico
709	Mexico
710	Mexico
711	Mexico
712	Mexico
713	Mexico
714	Mexico
715	Mexico
716	Mexico
717	Mexico
718	Mexico
719	Mexico
720	Mexico
721	Mexico
722	Mexico
723	Mexico
724	Mexico
725	Mexico
726	Mexico
727	Mexico
728	Mexico
729	Mexico
730	Mexico
731	Mexico
732	Mexico
733	Mexico
734	Mexico
735	Mexico
736	Mexico
737	Mexico
738	Mexico
739	Mexico
740	Mexico
741	Mexico
742	Mexico
743	Mexico
744	Mexico
745	Mexico
746	Mexico
747	Mexico
748	Mexico
749	Mexico
750	Mexico
751	Mexico
752	Mexico
753	Mexico
754	Mexico
755	Mexico
756	Mexico
757	Mexico
758	Mexico
759	Mexico
760	Mexico
761	Mexico
762	Mexico
763	Mexico
764	Mexico
765	Mexico
766	Mexico
767	Mexico
768	Mexico
769	Mexico
770	Mexico
771	Mexico
772	Mexico
773	Mexico
774	Mexico
775	Mexico
776	Mexico
777	Mexico
778	Mexico
779	Mexico
780	Mexico
781	Mexico
782	Mexico
783	Mexico
784	Mexico
785	Mexico
786	Mexico
787	Mexico
788	Mexico
789	Mexico
790	Mexico
791	Mexico
792	Mexico
793	Mexico
794	Mexico
795	Mexico
796	Mexico
797	Mexico
798	Mexico
799	Mexico
800	Mexico
801	Mexico
802	Mexico
803	Mexico
804	Mexico
805	Mexico
806	Mexico
807	Mexico
808	Mexico
809	Mexico
810	Mexico
811	Mexico
812	Mexico
813	Mexico
814	Mexico
815	Mexico
816	Mexico
817	Mexico
818	Mexico
819	Mexico
820	Mexico
821	Mexico
822	Mexico
823	Mexico
824	Mexico
825	Mexico
826	Mexico
827	Mexico
828	Mexico
829	Mexico
830	Mexico
831	Mexico
832	Mexico
833	Mexico
834	Mexico
835	Mexico
836	Mexico
837	Mexico
838	Mexico
839	Mexico
840	Mexico
841	Mexico
842	Mexico
843	Mexico
844	Mexico
845	Mexico
846	Mexico
847	Mexico
848	Mexico
849	Mexico
850	Mexico
851	Mexico
852	Mexico
853	Mexico
854	Mexico
855	Mexico
856	Mexico
857	Mexico
858	Mexico
859	Mexico
860	Mexico
861	Mexico
862	Mexico
863	Mexico
864	Mexico
865	Mexico
866	Mexico
867	Mexico
868	Mexico
869	Mexico
870	Mexico
871	Mexico
872	Mexico
873	Mexico
874	Mexico
875	Mexico
876	Mexico
877	Mexico
878	Mexico
879	Mexico
880	Mexico
881	Mexico
882	Mexico
883	Mexico
884	Mexico
885	Mexico
886	Mexico
887	Mexico
888	Mexico
889	Mexico
890	Mexico
891	Mexico
892	Mexico
893	Mexico
894	Mexico
895	Mexico
896	Mexico
897	Mexico
898	Mexico
899	Mexico
900	Mexico
901	Mexico
902	Mexico
903	Mexico
904	Mexico
905	Mexico
906	Mexico
907	Mexico
908	Mexico
909	Mexico
910	Mexico
911	Mexico
912	Mexico
913	Mexico
914	Mexico
915	Mexico
916	Mexico
917	Mexico
918	Mexico
919	Mexico
920	Mexico
921	Mexico
922	Mexico
923	Mexico
924	Mexico
925	Mexico
926	Mexico
927	Mexico
928	Mexico
929	Mexico
930	Mexico
931	Mexico
932	Mexico
933	Mexico
934	Mexico
935	Mexico
936	Mexico
937	Mexico
938	Mexico
939	Mexico
940	Mexico
941	Mexico
942	Mexico
943	Mexico
944	Mexico
945	Mexico
946	Mexico
947	Mexico
948	Mexico
949	Mexico
950	Mexico
951	Mexico
952	Mexico
953	Mexico
954	Mexico
955	Mexico
956	Mexico
957	Mexico
958	Mexico
959	Mexico
960	Mexico
961	Mexico
962	Mexico
963	Mexico
964	Mexico
965	Mexico
966	Mexico
967	Mexico
968	Mexico
969	Mexico
970	Mexico
971	Mexico
972	Mexico
973	Mexico
974	Mexico
975	Mexico
976	Mexico
977	Mexico
978	Mexico
979	Mexico
980	Mexico
981	Mexico
982	Mexico
983	Mexico
984	Mexico
985	Mexico
986	Mexico
987	Mexico
988	Mexico
989	Mexico
990	Mexico
991	Mexico
992	Mexico
993	Mexico
994	Mexico
995	Mexico
996	Mexico
997	Mexico
998	Mexico
999	Mexico
1000	Mexico
1	Paris
\.


--
-- TOC entry 5443 (class 0 OID 41072)
-- Dependencies: 242
-- Data for Name: ESTADO_HABITACION; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."ESTADO_HABITACION" (id_estado_habitacion, descripcion) FROM stdin;
1	Perfect dipping sauce or stir-fry addition for a sweet and tangy flavor.
2	Reusable suction cup hooks for hanging items.
3	Classic ranch dressing for salads and dipping.
4	Compact air conditioner for personal cooling.
5	Fresh and juicy cherry tomatoes for salads and snacking.
6	Easy-to-make pancake mix with chocolate chips included.
7	Cold-pressed coconut oil, perfect for cooking, baking, or skin care.
8	Everything you need to make your own candles.
9	Creamy Greek yogurt infused with raspberry and vanilla flavors.
10	Planter with self-watering feature for easy plant care.
11	Ergonomic footrest for easier pedicure treatment.
12	Eye-catching mini dress with sequins, ideal for party nights out.
13	Juicy burger patties made with grass-fed beef
14	Compact hose reel to keep your garden tidy.
15	Stylish case with magnetic closure for smartphones.
16	Rich and creamy tomato basil soup, perfect with a grilled cheese.
17	Elegant midi skirt with a wrap design, great for both formal and casual events.
18	Educational tablet designed for preschool-age children.
19	Electric foot massager for relaxation and relief.
20	Charcoal kettle grill perfect for backyard barbecues.
21	A creamy and tangy dressing perfect for salads or as a dipping sauce.
22	Nutty flavored chia seeds, packed with nutrients.
23	Ergonomic wireless controller for gaming consoles.
24	Supportive sports bra designed for high-impact workouts, made with moisture-wicking fabric.
25	Durable and insulated water bottle to keep beverages cold.
26	Crunchy peanuts coated in honey, perfect for snacking.
27	Fresh salsa made with pineapple and spices
28	Eco-friendly LED lights for festive decorations.
29	Ergonomic monitor stand for improved workspace organization.
30	Classic V-neck sweater crafted from soft wool for warmth and style.
31	A pre-packaged salad kit with noodles and Asian-style dressing.
32	Frozen cauliflower rice blended with mixed vegetables and seasonings.
33	A flavorful barbecue sauce with a sweet and spicy kick.
34	Rich chocolate cups filled with almond butter, a delicious treat.
35	Seal food and maintain freshness longer.
36	Electric kettle that offers precise temperature settings.
37	A spicy glaze made with sriracha and honey, perfect for meats.
38	Fun light that creates a disco atmosphere for parties.
39	Marinated chicken thighs with smoked paprika for a smoky flavor.
40	Collapsible dish rack for kitchen countertop use.
41	Soft cookies made with almond butter
42	A nutritious shake with rich chocolate and refreshing mint flavors.
43	Multifunctional smartwatch for fitness tracking.
44	Rich and creamy Caesar dressing for salads and wraps.
45	Reusable microfiber cloths for environmentally friendly cleaning.
46	Effective brush for removing loose hair from pets.
47	Pasta tossed with fresh basil pesto, simple and delicious.
48	Elegant glass decanter for aerating wine.
49	Crispy pastry filled with seasoned vegetables.
50	Crispy mini pretzels, a great snack any time of day.
51	Versatile puff pastry for pies and pastries.
52	Bartender kit with shaker, jigger, and strainer.
53	Fast and convenient air pump for inflating toys and furniture.
54	Stylish digital journaling app for notes and organizing tasks.
55	Set of three aromatic candles with various scents.
56	Spicy sauce made with chipotle peppers
57	Refreshing sparkling water infused with cranberry and lime flavors.
58	Comprehensive first aid kit for home or travel emergencies.
59	A mix of brined Mediterranean olives for snacking.
60	Plant-based mayonnaise for a creamy taste.
61	Unsweetened coconut flakes for baking and topping.
62	Soft silicone earbud covers for comfort and fit.
63	Savory hash made with sweet potatoes and kale, a perfect side dish.
64	Refreshing juice blend made with various fresh fruits.
65	Crispy baked radish chips, a healthy snack alternative.
66	Space-saving colander for rinsing fruits and vegetables.
67	Frozen green peas, a great addition to meals.
68	True wireless earbuds with touch control.
69	Custom cutting board made from high-quality wood.
70	Color-changing smart LED bulbs compatible with Alexa.
71	Comfortable wireless headphones designed for sleeping.
72	Easy-to-use portable grill for barbecues.
73	Adjustable tripod with remote shutter for smartphones.
74	Delicious noodles tossed in a sesamegarlic sauce.
75	Water bottle that tracks your hydration levels.
76	A mix of nuts roasted with spicy seasonings, perfect for snacking.
77	Soft and chewy cookies made with creamy peanut butter.
78	Sweet and spicy salsa made with fresh peaches.
79	Comfortable carry for pets while hiking or traveling.
80	Fresh and juicy cherry tomatoes for salads and snacking.
81	Convert your desk to a standing desk easily.
82	A warm and stylish puffer coat perfect for winter weather.
83	Spicy sauce made with chili peppers and garlic, great for stir-frying.
84	Creamy vegetable curry enriched with spices.
85	Refreshing tea with honey and lemon flavor, perfect for a warm drink.
86	Everything you need to make your own scented candles at home.
87	Trendy high-top canvas sneakers for a stylish streetwear look.
88	Nutty granola bars for healthy snacking.
89	Assorted collection of herbal teas for relaxation and wellness.
90	Lightly salted frozen edamame, a protein-packed snack.
91	Unsweetened apple sauce, great for snacks or baking.
92	Gourmet potato skins loaded with cheddar cheese and bacon.
93	Stackable containers for organizing snacks and treats.
94	Automatic water fountain for pets with filtration.
95	Fun robot that engages kids with games and activities.
96	Comfortable pet bed for small to medium-sized dogs.
97	Durable cover to protect your grill from the elements.
98	All-in-one mix for easy homemade cheeseburgers, just add ground beef.
99	A blend of mixed nuts for snacking.
100	Dimmable LED desk lamp with USB charging port.
101	Rechargeable electric wine opener for effortless uncorking.
102	Comfortable pet bed for small to medium-sized dogs.
103	Grow herbs indoors with this easy-to-use hydroponic garden system.
104	A gluten-free pizza crust made from cauliflower.
105	Compact USB fan for personal cooling.
106	Everything you need to bake delicious chocolate chip cookies.
107	Rich and smooth cold brew coffee concentrate, just add water or milk.
108	Assorted nail polish set for vibrant nails.
109	Electric rice cooker with multiple cooking settings for perfect rice.
110	Illuminated vanity mirror with adjustable brightness settings.
111	Nutty and chewy black rice, high in antioxidants.
112	Classic fit blue jeans with a slight stretch for comfort and durability.
113	A delicious tart filled with fresh raspberry filling.
114	Durable toy designed for heavy chewers.
115	Assorted collection of herbal teas for relaxation and wellness.
116	Comfy pet bed with washable cover for easy cleaning.
117	Pizza topped with barbecue chicken, cheese, and red onions.
118	Delicious vegetable dumplings, perfect for steaming or frying.
119	Stylish baskets for organizing various items in your home.
120	Whole wheat wraps filled with spinach, feta, and herbs.
121	Comfortable harness designed to keep pets safe in the car.
122	A convenient powder mix combining greens and fruits for smoothies.
123	A hearty soup made with lentils, coconut milk, and a blend of spices for a tropical flavor.
124	Spicy buffalo sauce ideal for wings or dipping.
125	Delicious cookies made with almond flour for a gluten-free treat.
126	Sweet and gooey cinnamon rolls, ready to bake.
127	Compact towels that expand when wet, ideal for travel.
128	Comprehensive camera and alert system for home security.
129	Easy-to-install lights to brighten kitchen cabinets and workspaces.
130	Collapsible dish rack for kitchen countertop use.
131	Smart speaker with Alexa and music streaming features.
132	Water-resistant blanket for picnics and outdoor events.
133	A convenient meal kit for making a delicious beef taco skillet at home.
134	Elegant chiffon blouse perfect for work or outings.
135	Crunchy granola with chocolate and coconut, great for breakfast or snacks.
136	Tangy goat cheese infused with herbs, perfect for snacking.
137	Complete kit for growing herbs indoors.
138	Delicate green tea leaves for a refreshing beverage.
139	Ear protection for shooting and industrial use.
140	Sweet and tangy honey mustard dip for snacks.
141	Supportive pillow designed for a good night's sleep.
142	7-in-1 multi-cooker for versatile cooking.
143	Lightweight tennis racket for beginners and advanced players.
144	Crispy on the outside, tender on the inside, perfect for stir-fries or salads.
145	Complete kit for crafting your own scented soaps.
146	Wild-caught salmon filets, perfect for grilling or baking.
147	Classic ranch dressing for salads and dipping.
148	Crunchy granola clusters mixed with nuts and honey.
149	Pack of ultra-soft microfiber cloths for cleaning.
150	Rich cocoa powder for baking and chocolate recipes.
151	Rechargeable water flosser for dental hygiene.
152	A mix of brined Mediterranean olives for snacking.
153	Adjustable tripod for smartphones and cameras.
154	Fresh organic cucumber perfect for salads or snacking.
155	A fashion-forward bomber jacket to elevate your casual looks.
156	Savory wraps with buffalo chicken and fresh vegetables.
157	Bell peppers stuffed with rice and vegetables
158	Set of resistance bands for home workouts.
159	A flavorful pasta sauce made with roasted garlic.
160	Fresh and crunchy baby carrots ready for snacking.
161	Reusable wraps for food storage, replacing plastic wraps.
162	Convenient electric screwdriver for DIY projects at home.
163	Powerful blender for smoothies and soups.
164	Frozen cauliflower bites coated in spicy buffalo sauce, ready to bake and enjoy as an appetizer.
165	Durable speaker designed for outdoor use with water resistance.
166	Lightweight tennis racket for beginners and advanced players.
167	Durable gardening gloves with reinforced fingertips.
168	Stylish desk lamp featuring a USB charging port.
169	Healthy snack bars packed with oats and fruit.
170	Fresh baby spinach leaves, great for salads and smoothies.
171	Nutty-scented oil for stir-fry and marinades.
172	A trendy fanny pack, perfect for hands-free outings.
173	Digital scale for precise cooking measurements.
174	Spiralized zucchini, a healthy alternative to pasta.
175	Colorful and child-friendly gardening tools for little hands.
176	Set of brush pens for colorful and creative painting.
177	Leak-proof cooler bag ideal for picnics and camping.
178	A zesty seasoning for meats and vegetables
179	Healthy snack bars packed with oats and fruit.
180	Baking mix to create your favorite Samoa-style cookies at home.
181	Portable and lightweight umbrella for protection from rain.
182	Farm fresh eggs, essential for breakfast.
183	Convenient holder for drinks and phones while driving.
184	Stay dry with these stylish waterproof rain boots.
185	Healthy energy bites made with oats and natural sweeteners.
186	Whole wheat wraps filled with spinach, feta, and herbs.
187	Set of decorative cushion covers for home decor.
188	Make delightful blueberry muffins at home with this easy mix.
189	Durable bag for carrying your yoga mat and accessories.
190	Lightweight cover-up perfect for the beach, with a breezy design.
191	Durable apron to keep clothes clean while cooking.
192	Keep bugs out while allowing fresh air in during summer.
193	Supportive yoga wheel for deep stretching and balance.
194	Versatile organic coconut oil for cooking and baking.
195	Colorful building blocks for creative play.
196	Thick and durable mat for workouts and yoga.
197	Track your meals and nutrition with this handy food journal.
198	Smooth and creamy, ideal for spreads or baking.
199	Tangy feta cheese, perfect for salads and sandwiches.
200	Non-slip mat designed for yoga and fitness exercises.
201	Crunchy granola with almonds and coconut.
202	Eco-friendly bamboo holder for toothbrushes.
203	Assorted herbal teas, perfect for a warm and relaxing drink.
204	Soft hamburger buns made with whole grains.
205	Advanced electric toothbrush for effective cleaning.
206	A nutritious salad with quinoa and black beans
207	Compact sewing kit for travel emergencies.
208	Assorted cloths for cleaning electronics and delicate surfaces.
209	Rechargeable lantern with multiple brightness settings for outdoors.
210	Tangy feta cheese, perfect for salads and sandwiches.
211	Bell peppers stuffed with rice, beans, and spices, ready to bake.
212	Regulate water temperature for safe and comfortable showers.
213	Professional grooming table with adjustable height.
214	Quick and easy side dish with buttery flavor.
215	Heavy-duty grill pan for indoor grilling.
216	A quick and easy fried rice mix with colorful veggies and savory seasoning.
217	Versatile slicer for meats, cheeses, and vegetables.
218	Set of resistance bands for versatile strength training workouts.
219	Eco-friendly bags for picking up after your pet.
220	Interactive kitchen set for imaginative play.
221	Crunchy granola with toasted coconut flakes, perfect for breakfast or snacks.
222	Practical organizer for keeping your home tidy and clutter-free.
223	Dimmable LED desk lamp with USB charging port.
224	Tangy salsa made from tomatillos and peppers.
225	Reusable gel ice pack for injuries and cooling.
226	A staple v-neck t-shirt that pairs well with anything.
227	Frozen smoothie pack with strawberries and bananas.
228	Nutritious energy bars packed with chocolate chips.
229	Multi-functional gloves for planting and digging without tools.
230	Memory foam travel pillow for neck support.
231	Classic wooden train set for imaginative play.
232	Space-saving colander for rinsing fruits and vegetables.
233	Warm and stylish jacket for cold weather.
234	All-in-one kit for growing herbs in your kitchen.
235	Tangy vinaigrette with orange and ginger flavors.
236	Fine granulated sugar for all your baking needs.
237	Compact, waterproof blanket for picnics and events.
238	Durable and shatterproof silicone glasses for outdoor use.
239	Battery-operated air purifier for small spaces.
240	Delicious homemade style blackberry jam.
241	Fun inflatable cooler to keep drinks cold at parties.
242	Adjustable weighted jump rope for workouts.
243	Beautifully crafted jewelry box with compartments for storage.
244	Customizable RGB LED light strip, perfect for mood lighting.
245	Safe cleaning solution and tools for electronics screens.
246	Comfortable eye mask that includes noise-canceling ear plugs.
247	Space-saving broom holder for organized cleaning supplies.
248	Versatile canvas sneakers suitable for everyday wear with a comfortable fit.
249	Eco-friendly cutting board that is safe for dishwashers.
250	Tool to check car engine codes and performance issues.
\.


--
-- TOC entry 5444 (class 0 OID 41077)
-- Dependencies: 243
-- Data for Name: ESTADO_MANTENIMIENTO; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."ESTADO_MANTENIMIENTO" (id_estado_mantenimiento, descripcion) FROM stdin;
1	Easy-to-prepare rice with cilantro and lime flavors, great as a side.
2	Set of resistance bands for strength training at home.
3	Microwaveable heating pad for muscle pain relief and relaxation.
4	Creamy yogurt made from almond milk, vegan-friendly.
5	A creamy blend of avocados and lime juice, great for spreads or dips.
6	Oven-roasted sliced turkey, perfect for sandwiches.
7	A classic white button-up shirt for a polished appearance.
8	Classic A-line skirt that flatters every figure, perfect for work or play.
9	A zero-calorie coconut oil spray for cooking and baking.
10	Adjustable shelving unit for home or garage storage.
11	All-in-one kit for growing herbs in your kitchen.
12	Fresh and juicy cherry tomatoes for salads and snacking.
13	Set of magnetic jars for convenient spice organization.
14	Creamy hummus with a kick of spice, great for dipping.
15	Compostable plates suitable for various occasions.
16	Refreshing apple juice, 100% juice with no added sugar.
17	Ziti pasta baked with marinara and parmesan cheese
18	Cozy cable knit cardigan to layer during chilly evenings.
19	Heavy-duty rake with adjustable width for different gardening needs.
20	Tool for measuring perfect pasta portions every time.
21	Nutty flavored chia seeds, packed with nutrients.
22	Nutty, crunchy pecans great for baking.
23	Lightweight fishing rod suitable for beginners.
24	Crispy dill pickles that are perfect for snacking or sandwiches.
25	Mix to create a delicious chia seed pudding in just a few minutes.
26	Colorful and child-friendly gardening tools for little hands.
27	Creamy ice cream with a warm cinnamon flavor, perfect for dessert.
28	Eco-friendly bamboo cutting boards in various sizes.
29	Wireless headphones with noise-canceling features.
30	Refreshing tea with honey and lemon flavor, perfect for a warm drink.
31	Savory sauce for vegetable and meat stir-fries.
32	Stylish wall art to enhance home decor.
33	Creamy ice cream with refreshing mint flavor and chocolate chips.
34	Lightweight and breathable running shorts for your workouts.
35	Salted sunflower seeds perfect for snacking.
36	Ergonomic memory foam pillow for better sleep.
37	Foam yoga block for enhancing poses and stability.
38	Control lights remotely with this smart switch.
39	Marinated shrimp in a garlic and lemon sauce, perfect for grilling.
40	Crispy sweet potato fries, a delicious side dish.
41	A spicy glaze made with sriracha and honey, perfect for meats.
42	Rich and flavorful tomato sauce for pasta or pizza.
43	A pack of assorted nut and protein bars for a quick energy boost.
44	Creamy yogurt made from coconut milk, dairy-free and delicious.
45	Crunchy, seasoned chickpeas for a wholesome snack.
46	Creamy pumpkin soup with spices
47	Creamy and rich vanilla ice cream, a classic dessert.
48	Complete cleaning kit for camera lenses.
49	Whole wheat wraps filled with spinach, feta, and herbs.
50	Instant noodles with a spicy Thai sauce for quick meals.
51	Electric indoor grill for quick meals.
52	Essential kit for taking care of your pets' health emergencies.
53	Ready-to-eat beet salad with dressing, great side dish.
54	Customizable window cover for light control and privacy.
55	A ready-to-eat soup with coconut milk, spices, and vegetables.
56	Reusable whiteboard for notes and reminders with magnetic backing.
57	Ergonomic monitor stand for improved workspace organization.
58	Instant-read thermometer for precise cooking temperatures.
59	Wi-Fi enabled thermostat that learns your habits.
60	Savory quiche loaded with spinach and cheese.
61	Non-slip yoga mat for optimal grip and comfort.
62	Reusable suction cup hooks for hanging items.
63	Personal massager for muscle recovery.
64	Make delicious ice cream at home with this user-friendly machine.
65	Durable lunch box designed to keep food fresh and cool.
66	Frozen pizza rolls stuffed with spinach and cheese, perfect for snacking.
67	Complete set to brew coffee with different methods.
68	Ergonomic mouse designed for gamers with high DPI.
69	Ergonomic stand for laptops to improve posture while working.
70	Non-slip yoga mat for optimal grip and comfort.
71	Frozen shrimp sautéed in garlic butter, ready to thaw and serve over pasta or rice.
72	Non-contact thermometer for checking temperatures instantly.
73	Frozen smoothie pack with strawberries and bananas.
74	Soft throw blanket for cozy home decor.
75	Assorted cloths for cleaning electronics and delicate surfaces.
76	Healthy fruit snacks, made with real fruit.
77	Sweet and crisp apples, perfect for snacking.
78	Creamy and smooth peanut butter, perfect for sandwiches.
79	Personalize your calendar with photos and special dates.
80	Versatile organic coconut oil for cooking and baking.
81	Flavorful mustard with a tangy kick, perfect for hot dogs and sandwiches.
82	A flavorful lentil curry cooked with vegetables and spices.
83	Soft cookies made with almond butter
84	Set of reusable baking cups for muffins and cupcakes.
85	Firm tofu, a great plant-based protein option.
86	Comfortable gaming chair for long hours of play.
87	Hearty beef chili, ready to heat and eat.
88	Creamy ice cream with refreshing mint flavor and chocolate chips.
89	A gluten-free pizza crust made from cauliflower.
90	Strategic board game for family game nights.
91	Foldable table for working with laptops anywhere.
92	Easy-to-read digital kitchen timer with alarms.
93	Fresh fruit salad, ready to eat and refreshing.
94	Pasta tossed with fresh basil pesto, simple and delicious.
95	Protects surfaces while baking or cooking with hot items.
96	A zesty salad with black beans, corn, and chipotle dressing.
97	Multi-functional grater for cheese and vegetables.
98	Powerful hand blender for soups and smoothies.
99	Wi-Fi enabled plug for controlling devices from your smartphone.
100	Protective gaiters to keep dirt and debris out of shoes during hikes.
101	Cordless handheld vacuum for quick cleanups.
102	Spiralized zucchini, a healthy alternative to pasta.
103	Creamy macaroni and cheese baked to perfection.
104	Flavorful rice mixed with coconut and lime, a tropical side dish.
105	Eco-friendly bamboo holder for toothbrushes.
106	USB hub for expanding ports on computers and laptops.
107	Zesty seasoning great for tacos and grilling.
108	Anti-fog ski goggles for winter sports.
109	Classic marshmallow treats made with crispy rice.
110	Popcorn tossed with sweet or savory flavors for a tasty snack.
111	Control home appliances remotely using your smartphone app.
112	A classic soup combining tomatoes and basil, great with grilled cheese sandwiches.
113	Soft flannel shirt with a timeless plaid pattern, perfect for layering.
114	Charcoal kettle grill perfect for backyard barbecues.
115	Freshly cut carrot sticks, perfect for snacking.
116	Boosts your Wi-Fi coverage for better connectivity.
117	A comfortable sweatshirt featuring a bold graphic print.
118	All-in-one kit for growing herbs in your kitchen.
119	Lentils cooked in a coconut curry for a hearty meal.
120	Sweetened powder for refreshing lemonade.
121	Classic wooden train set for imaginative play.
122	Foam yoga block for enhancing poses and stability.
123	Freshly ground cinnamon spice for baking or seasoning.
124	Space-saving adjustable dumbbells for strength training.
125	A timeless wardrobe staple crafted from soft cotton with a perfect fit.
126	Crispy chicken bites, perfect for dipping.
127	A nutritious salad with kale, quinoa, and a zesty lemon dressing.
128	Rich almond butter encased in dark chocolate.
129	Soft oatmeal cookies with maple and pecans.
130	Classic marinara sauce for pasta, pizza, or dipping.
131	Bold combat boots that make a statement with any outfit.
132	Automatic churner for making butter at home.
133	Crunchy granola full of peanut butter flavor and oats.
134	Deliciously smoked salmon, great for bagels.
135	Waterproof cover to protect car seats from pet hair and dirt.
136	Spicy black bean burgers, great on the grill.
137	Eye-catching mini dress with sequins, ideal for party nights out.
138	Spicy cauliflower bites for a vegetarian snack.
139	Large wall planner for organizing schedules.
140	Set of stylish throw pillows for home decor.
141	Powerful electric pressure washer for deep cleaning.
142	Crunchy corn chips flavored with chili and lime for a zesty kick.
143	Synthetic crab meat sticks, great for salads and sushi.
144	Multi-port USB-C hub for connecting devices.
145	Skillet that can fry, grill, and sauté with ease.
146	Wi-Fi enabled thermostat that learns your habits.
147	Smooth Greek yogurt infused with vanilla bean flavor.
148	STEM-based kit for kids featuring cool science experiments.
149	Nutty flavor perfect for pesto and salads.
150	A delicious pizza loaded with vegetables
151	Reusable wraps for food storage, replacing plastic wraps.
152	A fitted ribbed knit dress that hugs your curves perfectly.
153	Automatic water fountain for pets with filtration.
154	Warm and stylish jacket for cold weather.
155	A soothing tea blend with turmeric and ginger for wellness.
156	Frozen smoothie pack with strawberries and bananas.
157	Durable gloves with built-in claws for digging and planting.
158	Non-stick griddle for pancakes, burgers, and more.
159	Complete set of gardening tools for all your needs.
160	Eco-friendly meal prep containers for healthy eating.
161	Sturdy mobile workbench with storage options.
162	A mix of carrots, peas, and corn, easy to stir-fry.
163	Compact air conditioner for personal cooling.
164	A sweet and tangy dressing made with figs and balsamic vinegar, great on salads.
165	Rechargeable LED camping lantern for outdoor use.
166	Portable folding camping chair with cup holder.
167	Set of roller bottles for blending and applying essential oils.
168	GPS pet collar that helps locate your pet via smartphone app.
169	Layers of pasta, veggies, and cheese baked to perfection.
170	Eco-friendly toys for learning and imaginative play.
171	Roasted Brussels sprouts drizzled with balsamic glaze.
172	Personalized wooden puzzles for children that encourage learning.
173	Steamed edamame tossed in a spicy garlic sauce, great for snacking.
174	Durable and versatile food storage containers.
175	Savory pizza rolls filled with pepperoni and cheese, ready to bake and enjoy in minutes.
176	Custom keychain with engraved text.
177	Lightweight leaf blower for maintaining outdoor spaces.
178	Convenient magnetic jars for easy spice storage.
179	Heat-sensitive mug that changes color when filled with hot liquid.
180	Thin and crispy flatbreads, perfect for dips.
181	Set of magnetic jars for convenient spice organization.
182	A perfect blend of pineapple and teriyaki for stir-fry.
183	Protective gaiters to keep dirt and debris out of shoes during hikes.
184	Compact food processor for quick meal prep.
185	Crispy sweet potato bites, delicious as a side or snack.
186	Mini refrigerator ideal for small spaces.
187	Instant mix for delicious pumpkin spice lattes at home.
188	Delicious veggie burgers loaded with grilled vegetables.
189	Healthy energy bites made with oats and natural sweeteners.
190	Illuminated vanity mirror with adjustable brightness settings.
191	A lightweight tank dress, ideal for warm weather outings.
192	Wireless microphone for singing and performances.
193	Variety pack of sticky notes in different colors and sizes.
194	Creamy macaroni and cheese baked to perfection.
195	Rechargeable massage gun for relieving muscle soreness.
196	Compact camp stove for outdoor cooking.
197	Adjustable shower head for a luxurious shower experience.
198	Extra virgin olive oil, ideal for cooking and salads.
199	Savory sausage links with a hint of maple flavor.
200	A mix of frozen berries for smoothies or desserts
201	Spicy buffalo sauce ideal for wings or dipping.
202	Classic wooden building blocks for toddlers.
203	A delicious savory quinoa pudding, great as a side dish.
204	Comprehensive camera and alert system for home security.
205	Custom engraved ID tags for pets with your contact information.
206	Tender chicken coated in a sweet and savory honey garlic sauce.
207	Essential attachments for pressure washing.
208	Organize travel documents, passport, and cards.
209	High-density, non-slip yoga mat for stability and comfort.
210	Soft, cuddly toy that interacts with children.
211	Instant-read thermometer for precise cooking temperatures.
212	Soft and warm corn tortillas, perfect for tacos and burritos.
213	Stylish ripped boyfriend jeans for a relaxed, effortlessly cool vibe.
214	Crunchy granola with oats, nuts, and honey.
215	Set with various resistance bands for workouts.
216	Frozen pizza rolls filled with vegetables and cheese, perfect for snacks.
217	Rich and creamy dressing with garlic flavor, perfect for salads.
218	Electric rice cooker with multiple cooking settings for perfect rice.
219	Dairy-free cheese alternative for your favorite dishes.
220	Mini refrigerator ideal for small spaces.
221	Ergonomic desk that adjusts height for standing or sitting.
222	Modern desk lamp that features a built-in USB charging port.
223	A calming blanket that provides gentle pressure for relaxation.
224	A flavorful barbecue sauce with a sweet and spicy kick.
225	Pure and natural honey, great for sweetening.
226	Electric indoor grill for quick meals.
227	A savory marinade for meats, perfect for grilling.
228	A cozy cable knit beanie to keep your head warm in winter.
229	Fresh and tart organic green apples, great for snacking or baking.
230	Space-saving crates for easy organization at home or while traveling.
231	32GB USB flash drive with fast data transfer speeds.
232	A seasonal creamer that adds pumpkin spice flavor to coffee or tea.
233	Classic wooden puzzle game for kids and adults.
234	A simple, no-bake cheesecake mix to create your own delicious cheesecake.
235	Foldable kneeler that doubles as a seat for gardening convenience.
236	Space-saving collapsible bottle for outdoor activities.
237	Natural mineral salt with a subtle flavor, ideal for cooking and seasoning.
238	Creamy pumpkin soup with spices
239	Durable and insulated water bottle to keep beverages cold.
240	Complete meal kit with everything needed to make beef stroganoff in under 30 minutes.
241	Lint roller designed specifically for removing pet hair from furniture.
242	Frozen pizza loaded with fresh vegetables and mozzarella cheese.
243	Energy-efficient lights to illuminate outdoor areas.
244	Light and crispy baked chips, a healthier snack option.
245	Elegant glass decanter for aerating wine.
246	Color-changing LED lights for home decoration with remote.
247	Classic wooden puzzle game for kids and adults.
248	Organize your board games with this storage bin.
249	64GB SD memory card for cameras and devices.
250	Refreshing apple juice, 100% juice with no added sugar.
\.


--
-- TOC entry 5445 (class 0 OID 41082)
-- Dependencies: 244
-- Data for Name: ESTADO_RESERVACION; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."ESTADO_RESERVACION" (id_estado_reservacion, tipo_estado_reservacion) FROM stdin;
1	Span
2	Bitchip
3	Aerified
4	Asoka
5	Fix San
6	Hatity
7	Home Ing
8	Overhold
9	Tempsoft
10	Veribet
11	Fintone
12	Lotlux
13	Treeflex
14	Stronghold
15	Job
16	Span
17	Cardguard
18	Zaam-Dox
19	Zathin
20	Job
21	Mat Lam Tam
22	Home Ing
23	Subin
24	Trippledex
25	Bigtax
26	Lotstring
27	Fix San
28	Vagram
29	Keylex
30	Sub-Ex
31	Kanlam
32	Treeflex
33	Ronstring
34	Alpha
35	Transcof
36	Ventosanzap
37	Redhold
38	Domainer
39	Regrant
40	Pannier
41	Temp
42	Gembucket
43	Veribet
44	Sonair
45	Y-Solowarm
46	Cardguard
47	Konklux
48	Gembucket
49	Wrapsafe
50	Alphazap
51	Solarbreeze
52	Veribet
53	Vagram
54	Aerified
55	Home Ing
56	Fix San
57	Alpha
58	Bigtax
59	Hatity
60	Greenlam
61	Gembucket
62	Stim
63	Tresom
64	Toughjoyfax
65	Mat Lam Tam
66	Holdlamis
67	Trippledex
68	Aerified
69	Opela
70	Keylex
71	Daltfresh
72	Opela
73	Otcom
74	Hatity
75	Toughjoyfax
76	Bigtax
77	Trippledex
78	Zontrax
79	Solarbreeze
80	Aerified
81	Tresom
82	Temp
83	Stim
84	Namfix
85	Tampflex
86	Kanlam
87	Job
88	Zamit
89	Voyatouch
90	Fix San
91	Rank
92	Temp
93	Bigtax
94	Tresom
95	Tres-Zap
96	Bitchip
97	Tresom
98	Transcof
99	Stringtough
100	Mat Lam Tam
101	Konklab
102	Overhold
103	Subin
104	Vagram
105	Namfix
106	It
107	Temp
108	Solarbreeze
109	Alphazap
110	Cookley
111	Sub-Ex
112	Veribet
113	Bamity
114	Andalax
115	Vagram
116	Flowdesk
117	Overhold
118	Flowdesk
119	Flowdesk
120	Opela
121	Alphazap
122	Matsoft
123	Span
124	Domainer
125	Mat Lam Tam
126	Wrapsafe
127	Zoolab
128	It
129	Zathin
130	Quo Lux
131	Treeflex
132	It
133	Konklab
134	Andalax
135	Voyatouch
136	Wrapsafe
137	Greenlam
138	Sub-Ex
139	Sonair
140	Sonsing
141	Tresom
142	Tresom
143	Toughjoyfax
144	Namfix
145	Opela
146	Greenlam
147	Bitchip
148	Sonsing
149	Fixflex
150	Holdlamis
151	It
152	Bitwolf
153	Greenlam
154	Lotlux
155	Cardguard
156	Konklux
157	Aerified
158	Solarbreeze
159	Zontrax
160	Keylex
161	Treeflex
162	Subin
163	Regrant
164	Kanlam
165	Pannier
166	Bitchip
167	Zathin
168	Greenlam
169	Matsoft
170	Vagram
171	Matsoft
172	Veribet
173	Konklab
174	Stringtough
175	Subin
176	Y-find
177	Sub-Ex
178	Mat Lam Tam
179	Bamity
180	Bitwolf
181	Treeflex
182	Biodex
183	Tempsoft
184	Konklab
185	Vagram
186	Overhold
187	Tresom
188	Y-find
189	Trippledex
190	Mat Lam Tam
191	Stronghold
192	Temp
193	Wrapsafe
194	Zaam-Dox
195	Lotstring
196	Stringtough
197	Daltfresh
198	Stronghold
199	Fintone
200	Subin
201	Cardguard
202	Domainer
203	Y-Solowarm
204	Zaam-Dox
205	Daltfresh
206	Ronstring
207	Holdlamis
208	Toughjoyfax
209	Sub-Ex
210	Solarbreeze
211	Stronghold
212	Prodder
213	Duobam
214	Tin
215	Zaam-Dox
216	Bamity
217	Bamity
218	Bitwolf
219	Flowdesk
220	Toughjoyfax
221	Cardify
222	Y-Solowarm
223	Bitwolf
224	Quo Lux
225	Zoolab
226	Lotstring
227	Alphazap
228	Mat Lam Tam
229	It
230	Andalax
231	Alpha
232	Sonair
233	Latlux
234	Job
235	Tresom
236	Zaam-Dox
237	Zamit
238	Trippledex
239	Kanlam
240	Keylex
241	Transcof
242	Gembucket
243	Hatity
244	Konklab
245	Alphazap
246	Voyatouch
247	Stim
248	Tres-Zap
249	Cardguard
250	Asoka
\.


--
-- TOC entry 5446 (class 0 OID 41085)
-- Dependencies: 245
-- Data for Name: ESTADO_TRANSPORTE; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."ESTADO_TRANSPORTE" (id_estado_transporte, tipo_estado_transporte) FROM stdin;
1	Gordon Downs
2	Chizhou
3	Kaneohe
4	Daporijo
5	Perth
6	Kraków
7	Constanţa
8	Cordillo Downs
9	\N
10	Tanegashima
11	Nizhnekamsk
12	Lexington
13	Imperatriz
14	Heraklion
15	Island Lake
16	Samarkand
17	Monywar
18	Oak Harbor
19	Mount Pocono
20	Nakuru
21	Tsiroanomandidy
22	Obo
23	Saint Martin
24	Kirov
25	Hyderabad
26	Santa Monica
27	Lindi
28	Pittsburgh
29	Caçapava Do Sul
30	Bergamo
31	\N
32	Jiagedaqi
33	Wotje Atoll
34	Anaco
35	\N
36	Ottumwa
37	\N
38	Mazamari
39	Tawa
40	Decatur
41	Sumenep-Madura Island
42	Cáceres
43	Mariupol
44	Araak
45	Gebe Island
46	Devonport
47	Coningsby
48	Katmai National Park
49	Wiarton
50	\N
51	Mytilene
52	Cafunfo
53	Paulo Afonso
54	Funter Bay
55	Ada
56	Pontiac
57	Maniitsoq
58	Freeport
59	Supai Village
60	St Jean
61	Helenvale
62	Rongelap Island
63	Taiping
64	Eastover
65	Port Bergé
66	Hat Yai
67	\N
68	\N
69	Soldotna
70	Stebbins
71	Narsarsuaq
72	\N
73	\N
74	Danbury
75	Karpathos Island
76	Carbondale/Murphysboro
77	\N
78	Lanai City
79	Oudtshoorn
80	Yuma Proving Ground(Yuma)
81	Rifle
82	Great Falls
83	Shilavo
84	Gisborne
85	Moscow
86	Petropavlovsk-Kamchatsky
87	\N
88	Torrance
89	Beica
90	Council Bluffs
91	Natchez
92	Dakar
93	Njombe
94	Norderney
95	Wadi Halfa
96	Houston
97	Surigao City
98	Xuzhou
99	Wahiawa
100	Beatrice
101	Livermore
102	Balemartine
103	Ampanihy
104	Makurdi
105	Essington
106	Gobabis
107	Mérida
108	Fort Lauderdale
109	Mobile
110	Granville
111	Skwentna
112	Chignik
113	Longnan
114	Kao-Celebes Island
115	Tena
116	Apia
117	Hue
118	Fort Madison
119	Juruena
120	Timbuktu
121	Cleveland
122	\N
123	\N
124	Senipah
125	Lüliang
126	Deer Park
127	Rankin Inlet
128	\N
129	Bahawalpur
130	Marks
131	\N
132	Hat Yai
133	Naga
134	Corcoran
135	Blacksburg
136	Brownsville
137	Fort Lauderdale
138	\N
139	Sønderborg
140	Enejit Island
141	Nelson
142	Kaiser Lake Ozark
143	Rahim Yar Khan
144	Piseo-ri (Muan)
145	Tucumã
146	Del Carmen
147	Lhasa
148	Mangungaya-Sumatra Island
149	Augusta
150	Neyveli
151	Tok
152	Maxton
153	Iguatu
154	Thetis Island
155	Kabalega Falls
156	Paraguaçu
157	\N
158	North Bend
159	Kassala
160	Ambato
161	Cahokia/St Louis
162	Manurewa
163	Pituffik
164	Tessenei
165	Austin
166	Riyadh
167	Aydın
168	\N
169	Yecheon-ri
170	Sicogon Island
171	Sandringham Station
172	Hacienda Borrero
173	Koyukuk
174	Tampa
175	Petropavlosk
176	Lawrence
177	Bikaner
178	Vava'u Island
179	Beijing
180	Codrington
181	Talang Gudang-Sumatra Island
182	Saarbrücken
183	Joaçaba
184	Aswan
185	Carnarvon
186	Davao City
187	\N
188	Fontanges
189	Gorna Oryahovitsa
190	\N
191	Salida
192	Logan
193	Oristano
194	Khan Yunis
195	Heraklion
196	Pumululu National Park
197	Mboki
198	Rogers
199	Hatay
200	Sheghnan
201	Rørvik
202	Dipolog City
203	Willmar
204	Kuri
205	Central
206	Miri
207	Foz Do Iguaçu
208	Detroit
209	Makini
210	Paragould
211	\N
212	\N
213	Waycross
214	Chennai
215	Montreal
216	Zhangjiakou
217	Rio Grande
218	Tum
219	Evansville
220	Kigoma
221	Kärdla
222	Västervik
223	Pinehouse Lake
224	\N
225	Robinson River
226	San Ignacio
227	Las Perlas
228	Opapimiskan Lake
229	Beckwourth
230	Chicago
231	Auckland
232	Letterkenny
233	Ruidoso
234	Ketchikan
235	Chicago/Waukegan
236	El Debba
237	Tapachula
238	Aldan
239	Toledo
240	Beckley
241	Paris
242	Golovin
243	\N
244	Montgomery
245	Fayetteville
246	Invercargill
247	Norilsk
248	Velikiy Novgorod
249	Appleton
250	Basco
\.


--
-- TOC entry 5447 (class 0 OID 41090)
-- Dependencies: 246
-- Data for Name: ESTATUS_PAGO; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."ESTATUS_PAGO" (id_estatus_pago, descripcion) FROM stdin;
1	Fun inflatable cooler to keep drinks cold at parties.
2	A blend of roasted red peppers and spices, perfect for dipping.
3	Lightweight and moisture-wicking racerback tank for workouts.
4	Reusable silicone mats for non-stick baking.
5	Versatile organic coconut oil for cooking and baking.
6	Juicy chicken breast stuffed with spinach and feta cheese, seasoned to perfection.
7	Delicate ravioli filled with roasted butternut squash and spices, perfect with a sage butter sauce.
8	Everything you need for a fresh and delicious Caesar salad.
9	Bottle that allows you to infuse your water with fruits.
10	Freshly roasted coffee beans with rich flavor.
11	Compact electric pot for hot pot dining at home.
12	Stylish and functional backpack for school or trips.
13	Track steps, heart rate, and sleep patterns.
14	Fresh kale salad with a zesty lemon dressing, great as a side dish.
15	Complete set to brew coffee with different methods.
16	Insulated water bottle for keeping drinks cold.
17	Eco-friendly string lights for outdoor decor.
18	Gluten-free tortillas made from almond flour, perfect for various wraps and meals.
19	Creamy cheddar cheese slices, perfect for sandwiches and snacks.
20	Sweet and tangy balsamic reduction for drizzling.
21	Vacuum-insulated tumbler for beverages on the go.
22	Heavy-duty rake with adjustable width for different gardening needs.
23	Multi-functional tool for emergency situations in the car.
24	Stylish and spacious case for makeup and beauty products.
25	A mix of strawberries, blueberries, and raspberries.
26	A healthy vegan cheese alternative packed with nutrients and flavor.
27	Fun tourist magnets from around the world for your fridge.
28	Lightly salted rice cakes, perfect for a healthy snack.
29	Rich cocoa powder for baking and chocolate recipes.
30	Essential ingredient for baking fluffy cakes and pastries.
31	Hearty chili made with premium ground beef and kidney beans.
32	Finely ground almonds for baking or cooking
33	Elegant glass teapot for brewing loose tea.
34	A tangy marinade for meats and veggies, packed with garlic flavor.
35	Moisturizing body wash with natural ingredients.
36	A nutritious shake with rich chocolate and refreshing mint flavors.
37	True wireless earbuds with excellent sound quality.
38	Electric foot massager for relaxation and relief.
39	Elegant glass decanter for aerating wine.
40	Compact hair dryer with multiple heat settings.
41	Fiery hot sauce made with fresh habaneros and spices.
42	A hearty salad with grains, dried fruits, and nuts.
43	Couscous salad with cucumbers, tomatoes, feta, and olives, ready to eat.
44	Authentic Indian curry sauce for quick meals.
45	Oven-roasted potatoes tossed in garlic and parmesan cheese seasoning.
46	Unsweetened frozen acai purée for smoothies and bowls.
47	Interactive kitchen set for imaginative play.
48	Cordless electric knife for effortless slicing.
49	Timeless analog watch with a leather strap.
50	Set of baking sheets for effortless baking.
51	Creamy mashed potatoes infused with roasted garlic flavor.
52	A hearty salad with grains, dried fruits, and nuts.
53	High-density, non-slip yoga mat for stability and comfort.
54	Crunchy granola with chocolate and hazelnuts for breakfast.
55	Automatically cooks eggs to your desired level.
56	Natural air purifiers to absorb odors and moisture.
57	Creamy vanilla fudge, a sweet treat for all occasions.
58	Hearty beef chili, ready to heat and eat.
59	Soft and chewy cookies made with creamy peanut butter.
60	Compact keyboard for tablets and smartphones.
61	Soft and fluffy whole wheat pita bread, great for wraps.
62	Creamy yogurt made from coconut milk, dairy-free and delicious.
63	500-piece jigsaw puzzle featuring beautiful scenery.
64	Supportive pillow that provides comfort while traveling.
65	Lightweight backpack with an insulated water reservoir for hydration on the go.
66	Pre-cooked vegetable fried rice, just heat and serve.
67	Rich and creamy smoked Gouda cheese perfect for snacking.
68	Sweet and tangy raspberry lime beverage
69	Complete karaoke system with microphones and speakers.
70	Compact air conditioner for personal cooling.
71	Set of decorative ceramic planters for indoor plants.
72	A tangy sauce that combines lemon zest and basil for a refreshing flavor.
73	Lightweight tripod designed for smartphone photography.
74	Comfortable trainers with mesh inserts for breathability.
75	Spice blend for creating flavorful vegan taco filling.
76	RFID-blocking slim wallet for cards and cash.
77	Crunchy and sweet banana chips, a great on-the-go snack.
78	Savory bacon jerky coated with maple flavoring.
79	Soft and cozy bathrobe perfect for relaxing at home.
80	A comforting soup filled with chicken and noodles in broth.
81	Ready-to-bake cookie dough packed with chocolate chips.
82	Delicious dark chocolate cups filled with creamy peanut butter.
83	Crispy and juicy chicken tenders, perfect for dipping.
84	Chic wrap jumpsuit that flatters the body and is perfect for any occasion.
85	Foldable mat for jigsaw puzzle assembly.
86	A gluten-free pizza crust made from cauliflower.
87	Crunchy chips made from blue corn, perfect for dipping.
88	Whole grain oats that are perfect for breakfast or baking.
89	Chocolate-covered candy bars with coconut and almonds.
90	Automated stirring for your drinks with just a press of a button.
91	Savory sausage links seasoned with Italian spices.
92	Tofu stir-fried with fresh vegetables in teriyaki sauce.
93	Flavorful lentil soup, perfect for a quick meal.
94	Fun and educational puzzle set for kids.
95	Chic wrap jumpsuit that flatters the body and is perfect for any occasion.
96	Multi-level cat tree for play and scratching.
97	Electric food steamer for healthy cooking.
98	Spicy and flavorful soup made with black beans, perfect as a meal or starter.
99	Spicy sauce made with chipotle peppers
100	Wi-Fi enabled thermostat that learns your habits.
101	A mix of fresh raspberries, blueberries, and blackberries.
102	Complete kit for crafting your own scented soaps.
103	Complete crafting kit for kids and adults.
104	Fun tourist magnets from around the world for your fridge.
105	Multi-level cat tree for play and scratching.
106	Space-saving broom holder for organized cleaning supplies.
107	Rich basil pesto sauce for pasta and more.
108	Maintain freshness and dispense cereal easily.
109	Creamy mashed sweet potatoes, ready to heat and serve.
110	Refreshing coconut water packed with electrolytes for hydration.
111	Automated litter box that cleans itself after each use.
112	Crunchy granola with almonds and a hint of vanilla, perfect for breakfast.
113	Fresh Brussels sprouts, great for roasting or steaming.
114	Eco-friendly bamboo holder for toothbrushes.
115	Compact air conditioner for personal cooling.
116	True wireless earbuds with excellent sound quality.
117	Everything you need to make your own candles.
118	Versatile electric skillet for stir-frying and searing.
119	Retro-style graphic tee with a soft wash for a vintage feel.
120	Eco-friendly trash bags that break down naturally.
121	Marinated chicken skewers with lemon and dill flavor, grilled to perfection.
122	Protective goggles for DIY and construction work.
123	Cozy beanie hat to keep your head warm in the cold.
124	Manual blender for smoothies and mixing ingredients on the go.
125	The perfect seafood snack, ready to eat and delicious.
126	Practical organizer for keeping your home tidy and clutter-free.
127	Moisturizing body wash with natural ingredients.
128	Delicious cookies with rich chocolate flavor and a hint of mint.
129	Golden-brown fritters made with sweet corn.
130	Flavored aioli made with roasted garlic
131	Skillet that can fry, grill, and sauté with ease.
132	Rich and creamy Caesar dressing for salads and wraps.
133	Corn on the cob seasoned with chili and lime for a spicy kick.
134	Nutty flavor perfect for pesto and salads.
135	A mix of tropical fruits for a refreshing snack or dessert.
136	A staple v-neck t-shirt that pairs well with anything.
137	Fresh walnut halves for baking or snacking.
138	Ready-to-eat tuna salad with a spicy kick, perfect for sandwiches.
139	Spicy chili in a can, ready to eat for a filling meal.
140	Complete kit for starting your own organic garden.
141	Compact jump starter for emergency vehicle starts.
142	Convenient shower system for camping and outdoor activities.
143	High-density, non-slip yoga mat for stability and comfort.
144	Eco-friendly sealer for protecting concrete surfaces.
145	Vegetable spiralizer for healthy meals.
146	Layered Greek yogurt with granola and mixed berries, ready to enjoy.
147	Tender grilled chicken marinated in lemon herbs.
148	Portable ring light that enhances your photos with perfect lighting.
149	Instant pressure cooker with multiple cooking settings.
150	Savory pizza rolls filled with pepperoni and cheese, ready to bake and enjoy in minutes.
151	Crispy sweet potato fries, a delicious side dish.
152	Durable speaker designed for outdoor use with water resistance.
153	Bold combat boots that make a statement with any outfit.
154	Comfortable trainers with mesh inserts for breathability.
155	Frozen salmon fillets marinated in teriyaki sauce, ready to grill or bake.
156	Stylish baskets for organizing various items in your home.
157	Shower head designed for a strong spray and complete coverage.
158	High-quality matcha powder for smoothies and baking.
159	Instant mix for creamy vanilla pudding.
160	A natural sweetener made from coconut sap, a healthier alternative to sugar.
161	A warm knitted scarf to keep you cozy in winter.
162	Professional sharpening system for kitchen knives.
163	Moist and flavorful muffins packed with fall spices and pumpkin puree.
164	Stream HD video wirelessly to your TV.
165	Breathable polo shirt designed for both style and comfort on the greens.
166	Delicious dark chocolate cups filled with creamy peanut butter.
167	Portable desk that can be adjusted for sitting or standing.
168	Fresh green cabbage, great for salads and slaws.
169	Lightweight and breathable running shorts for your workouts.
170	Creamy ranch dressing, perfect for salads and dips.
171	Durable lunch box designed to keep food fresh and cool.
172	Portable induction cooktop for quick heating.
173	Healthy frozen acai bowl with toppings.
174	Protects surfaces while baking or cooking with hot items.
175	Healthy snack bars packed with oats and fruit.
176	Peel and stick wallpaper for easy home decor changes.
177	Freshly baked whole wheat bread, rich in fiber.
178	Energy-efficient window air conditioner for cooling.
179	A warming blend of ginger and turmeric for lattes.
180	A hearty salad with lentils, veggies, and curry dressing.
181	Journal to record workouts and nutrition.
182	Set of stylish watch bands to customize your look.
183	Indoor putting green for practicing your putting skills.
184	Creamy macaroni and cheese baked to perfection.
185	All-in-one kit for brewing beer at home.
186	Convert your desk to a standing desk easily.
187	Breathable polo shirt designed for both style and comfort on the greens.
188	Extra layer of comfort for your mattress.
189	Heavy-duty scissors for crafting and office use.
190	Savory sardines packed in olive oil.
191	Beginner-friendly acoustic guitar with natural finish.
192	32GB USB flash drive with fast data transfer speeds.
193	Healthy whole grain cereal, great for breakfast.
194	Decadent brownies made without gluten, rich and chocolatey.
195	Creamy yogurt made from coconut milk, dairy-free and delicious.
196	Stackable steamers for healthy cooking of vegetables and seafood.
197	Light and crispy baked chips, a healthier snack option.
198	Creamy pumpkin soup with spices
199	HEPA air purifier for clean indoor air.
200	Compact knife with safety lock for everyday use.
201	Eco-friendly bamboo toothbrush for sustainable living.
202	Compact hand mixer for easy baking.
203	Bright safety vest for outdoor visibility during any activity.
204	Space-saving crates for easy organization at home or while traveling.
205	Deliciously rich brownies made with almond flour.
206	Sweet and tender peach slices preserved in syrup, great for desserts.
207	Soft flannel shirt with a timeless plaid pattern, perfect for layering.
208	Soft and breathable pillowcase for body pillows.
209	Crunchy granola with oats, nuts, and honey.
210	Sleek wireless charging pad for smartphones.
211	Extra soft electric blanket with adjustable heat settings.
212	Reusable tote bags for shopping and eco-friendly living.
213	Moist brownie topped with sea salt and caramel drizzle.
214	500-piece jigsaw puzzle featuring beautiful scenery.
215	A delicious sauce perfect for stir-frying or glazing meats.
216	Healthy energy bites made with oats and natural sweeteners.
217	A blend of herbs and garlic for seasoning meats and vegetables.
218	Beginner telescope for stargazing and exploring.
219	Roasted Brussels sprouts drizzled with balsamic glaze.
220	Passive noise reduction headphones for focus.
221	A zesty salsa made with peaches and mangos, great for chips.
222	Sleek wireless charging pad for smartphones.
223	Compact pocket tool with various built-in functions.
224	Stylish stand to hold your recipes while cooking.
225	Compact and portable projector for watching videos anywhere.
226	Bright and fragrant cilantro, great for garnishes.
227	Frozen vegetable primavera for quick meals.
228	Maintain freshness and dispense cereal easily.
229	Ready-to-bake garlic breadsticks, perfect with pasta dishes.
230	Delicate green tea leaves for a refreshing beverage.
231	Comfortable pet bed for small to medium-sized dogs.
232	Relaxing paint kit with pre-printed canvas for painting.
233	Set of brush pens for colorful and creative painting.
234	Powerful grinder for making sausage and burgers at home.
235	Portable car vacuum cleaner with strong suction.
236	Eco-friendly bags for picking up after your pet.
237	Bright, vibrant sign to add flair to any space.
238	Powerful electric pressure washer for deep cleaning.
239	Manual pasta maker for homemade pasta.
240	Natural mineral salt with a subtle flavor, ideal for cooking and seasoning.
241	A flavorful blend of rice with tropical pineapple and coconut flavors.
242	Eco-friendly bags for picking up after your pet.
243	Low-calorie rice cake for snacks.
244	Fun light that creates a disco atmosphere for parties.
245	Quote wall art to inspire and motivate.
246	Multi-functional gloves for planting and digging without tools.
247	Fun fridge magnets to decorate your kitchen.
248	Lightly salted frozen edamame, a protein-packed snack.
249	Adjustable shower head for a luxurious shower experience.
250	Compact sewing kit for travel emergencies.
\.


--
-- TOC entry 5448 (class 0 OID 41095)
-- Dependencies: 247
-- Data for Name: FACTURAS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."FACTURAS" (id_factura, id_sucursal, id_clientes, total, fecha_emision, impuestos, subtotal) FROM stdin;
1	1	1	29.00	2024-11-07 00:00:00-06	39.00	94.00
2	2	2	26.00	2025-02-10 00:00:00-06	46.00	56.00
3	3	3	62.00	2025-07-22 00:00:00-06	26.00	74.00
4	4	4	30.00	2025-02-12 00:00:00-06	24.00	44.00
5	5	5	54.00	2025-07-19 00:00:00-06	16.00	30.00
6	6	6	99.00	2024-11-29 00:00:00-06	24.00	38.00
7	7	7	86.00	2025-04-16 00:00:00-06	61.00	77.00
8	8	8	41.00	2025-01-20 00:00:00-06	15.00	9.00
9	9	9	82.00	2024-11-02 00:00:00-06	75.00	4.00
10	10	10	36.00	2025-09-19 00:00:00-06	33.00	3.00
11	11	11	31.00	2025-07-20 00:00:00-06	93.00	4.00
12	12	12	15.00	2025-07-12 00:00:00-06	59.00	34.00
13	13	13	68.00	2025-06-16 00:00:00-06	98.00	67.00
14	14	14	73.00	2025-05-18 00:00:00-06	26.00	80.00
15	15	15	42.00	2025-06-10 00:00:00-06	50.00	33.00
16	16	16	61.00	2025-01-09 00:00:00-06	55.00	45.00
17	17	17	59.00	2025-02-25 00:00:00-06	86.00	20.00
18	18	18	58.00	2024-11-30 00:00:00-06	33.00	60.00
19	19	19	97.00	2024-11-12 00:00:00-06	65.00	93.00
20	20	20	70.00	2025-03-22 00:00:00-06	21.00	87.00
21	21	21	19.00	2025-09-01 00:00:00-06	97.00	45.00
22	22	22	18.00	2024-12-30 00:00:00-06	1.00	66.00
23	23	23	31.00	2025-09-10 00:00:00-06	85.00	58.00
24	24	24	27.00	2025-01-09 00:00:00-06	97.00	84.00
25	25	25	17.00	2025-08-25 00:00:00-06	99.00	32.00
26	26	26	12.00	2025-05-02 00:00:00-06	80.00	79.00
27	27	27	26.00	2024-11-23 00:00:00-06	19.00	67.00
28	28	28	46.00	2024-10-16 00:00:00-06	96.00	29.00
29	29	29	16.00	2025-05-02 00:00:00-06	7.00	56.00
30	30	30	20.00	2025-05-19 00:00:00-06	12.00	45.00
31	31	31	94.00	2024-11-11 00:00:00-06	38.00	37.00
32	32	32	9.00	2024-09-29 00:00:00-06	80.00	78.00
33	33	33	48.00	2025-03-13 00:00:00-06	34.00	56.00
34	34	34	13.00	2025-05-14 00:00:00-06	28.00	76.00
35	35	35	77.00	2025-08-27 00:00:00-06	78.00	93.00
36	36	36	33.00	2024-10-24 00:00:00-06	25.00	42.00
37	37	37	80.00	2025-08-03 00:00:00-06	50.00	64.00
38	38	38	18.00	2024-11-11 00:00:00-06	23.00	87.00
39	39	39	47.00	2025-07-15 00:00:00-06	73.00	4.00
40	40	40	15.00	2025-03-03 00:00:00-06	97.00	29.00
41	41	41	83.00	2025-08-07 00:00:00-06	58.00	30.00
42	42	42	4.00	2025-03-19 00:00:00-06	34.00	60.00
43	43	43	11.00	2025-01-04 00:00:00-06	2.00	62.00
44	44	44	50.00	2025-07-09 00:00:00-06	88.00	19.00
45	45	45	52.00	2025-08-19 00:00:00-06	35.00	29.00
46	46	46	26.00	2024-10-14 00:00:00-06	43.00	27.00
47	47	47	54.00	2025-05-31 00:00:00-06	26.00	53.00
48	48	48	56.00	2024-12-20 00:00:00-06	46.00	25.00
49	49	49	97.00	2025-07-04 00:00:00-06	18.00	34.00
50	50	50	84.00	2025-08-27 00:00:00-06	13.00	75.00
51	51	51	21.00	2025-03-27 00:00:00-06	81.00	59.00
52	52	52	34.00	2025-04-01 00:00:00-06	5.00	73.00
53	53	53	76.00	2025-09-17 00:00:00-06	13.00	27.00
54	54	54	64.00	2025-06-03 00:00:00-06	63.00	50.00
55	55	55	25.00	2025-01-24 00:00:00-06	22.00	20.00
56	56	56	34.00	2025-09-27 00:00:00-06	41.00	93.00
57	57	57	3.00	2025-06-25 00:00:00-06	69.00	6.00
58	58	58	41.00	2024-11-14 00:00:00-06	54.00	72.00
59	59	59	66.00	2025-06-18 00:00:00-06	52.00	35.00
60	60	60	30.00	2025-04-08 00:00:00-06	85.00	30.00
61	61	61	90.00	2025-08-16 00:00:00-06	47.00	80.00
62	62	62	59.00	2025-04-16 00:00:00-06	94.00	85.00
63	63	63	38.00	2025-07-02 00:00:00-06	86.00	95.00
64	64	64	75.00	2025-03-20 00:00:00-06	84.00	50.00
65	65	65	96.00	2025-09-06 00:00:00-06	50.00	85.00
66	66	66	74.00	2025-02-21 00:00:00-06	86.00	28.00
67	67	67	65.00	2025-04-25 00:00:00-06	15.00	6.00
68	68	68	90.00	2025-05-28 00:00:00-06	37.00	38.00
69	69	69	45.00	2025-09-03 00:00:00-06	10.00	98.00
70	70	70	65.00	2025-07-27 00:00:00-06	75.00	77.00
71	71	71	25.00	2025-06-05 00:00:00-06	14.00	63.00
72	72	72	32.00	2025-06-25 00:00:00-06	50.00	67.00
73	73	73	47.00	2024-10-09 00:00:00-06	98.00	97.00
74	74	74	98.00	2025-05-27 00:00:00-06	50.00	99.00
75	75	75	26.00	2025-01-01 00:00:00-06	22.00	61.00
76	76	76	41.00	2025-08-22 00:00:00-06	14.00	85.00
77	77	77	69.00	2025-05-22 00:00:00-06	64.00	68.00
78	78	78	66.00	2025-04-20 00:00:00-06	42.00	62.00
79	79	79	55.00	2025-06-29 00:00:00-06	76.00	35.00
80	80	80	88.00	2025-07-26 00:00:00-06	99.00	83.00
81	81	81	45.00	2025-04-03 00:00:00-06	86.00	97.00
82	82	82	63.00	2025-04-27 00:00:00-06	88.00	7.00
83	83	83	62.00	2025-05-13 00:00:00-06	79.00	54.00
84	84	84	8.00	2024-12-30 00:00:00-06	65.00	29.00
85	85	85	18.00	2025-04-27 00:00:00-06	2.00	22.00
86	86	86	43.00	2025-06-16 00:00:00-06	68.00	4.00
87	87	87	70.00	2025-02-13 00:00:00-06	97.00	3.00
88	88	88	65.00	2025-01-10 00:00:00-06	57.00	25.00
89	89	89	82.00	2025-03-15 00:00:00-06	31.00	63.00
90	90	90	48.00	2025-08-20 00:00:00-06	96.00	51.00
91	91	91	80.00	2024-10-12 00:00:00-06	26.00	76.00
92	92	92	69.00	2025-09-18 00:00:00-06	25.00	21.00
93	93	93	86.00	2024-10-25 00:00:00-06	17.00	22.00
94	94	94	47.00	2025-05-03 00:00:00-06	9.00	63.00
95	95	95	7.00	2025-07-29 00:00:00-06	70.00	18.00
96	96	96	77.00	2024-10-11 00:00:00-06	77.00	76.00
97	97	97	88.00	2024-10-29 00:00:00-06	9.00	58.00
98	98	98	52.00	2025-06-12 00:00:00-06	63.00	88.00
99	99	99	76.00	2024-12-03 00:00:00-06	24.00	47.00
100	100	100	7.00	2025-03-03 00:00:00-06	65.00	19.00
101	101	101	37.00	2025-01-09 00:00:00-06	65.00	35.00
102	102	102	74.00	2025-05-22 00:00:00-06	92.00	97.00
103	103	103	57.00	2025-05-06 00:00:00-06	22.00	57.00
104	104	104	76.00	2025-06-29 00:00:00-06	45.00	76.00
105	105	105	17.00	2025-04-11 00:00:00-06	91.00	89.00
106	106	106	92.00	2025-02-06 00:00:00-06	71.00	53.00
107	107	107	52.00	2024-12-18 00:00:00-06	24.00	23.00
108	108	108	14.00	2025-06-06 00:00:00-06	86.00	85.00
109	109	109	75.00	2025-07-13 00:00:00-06	48.00	34.00
110	110	110	33.00	2025-08-05 00:00:00-06	20.00	26.00
111	111	111	9.00	2025-05-31 00:00:00-06	71.00	69.00
112	112	112	67.00	2025-04-09 00:00:00-06	26.00	43.00
113	113	113	9.00	2024-11-20 00:00:00-06	22.00	91.00
114	114	114	78.00	2025-05-01 00:00:00-06	31.00	22.00
115	115	115	97.00	2025-07-12 00:00:00-06	31.00	72.00
116	116	116	31.00	2025-07-01 00:00:00-06	13.00	63.00
117	117	117	75.00	2025-02-21 00:00:00-06	50.00	78.00
118	118	118	63.00	2025-05-05 00:00:00-06	48.00	11.00
119	119	119	54.00	2025-02-11 00:00:00-06	38.00	69.00
120	120	120	68.00	2025-07-28 00:00:00-06	16.00	52.00
121	121	121	51.00	2025-02-24 00:00:00-06	70.00	37.00
122	122	122	68.00	2024-10-18 00:00:00-06	57.00	41.00
123	123	123	41.00	2024-10-09 00:00:00-06	60.00	3.00
124	124	124	38.00	2025-04-06 00:00:00-06	43.00	93.00
125	125	125	59.00	2024-11-20 00:00:00-06	20.00	75.00
126	126	126	22.00	2025-01-06 00:00:00-06	96.00	97.00
127	127	127	51.00	2025-03-05 00:00:00-06	27.00	94.00
128	128	128	58.00	2025-01-26 00:00:00-06	11.00	57.00
129	129	129	74.00	2025-09-22 00:00:00-06	59.00	36.00
130	130	130	72.00	2025-07-15 00:00:00-06	91.00	65.00
131	131	131	84.00	2024-12-26 00:00:00-06	10.00	29.00
132	132	132	19.00	2024-10-10 00:00:00-06	70.00	7.00
133	133	133	80.00	2025-06-15 00:00:00-06	7.00	6.00
134	134	134	19.00	2024-12-11 00:00:00-06	24.00	94.00
135	135	135	55.00	2025-01-21 00:00:00-06	8.00	95.00
136	136	136	44.00	2025-04-17 00:00:00-06	60.00	74.00
137	137	137	56.00	2025-06-09 00:00:00-06	66.00	90.00
138	138	138	47.00	2025-07-26 00:00:00-06	20.00	82.00
139	139	139	26.00	2025-08-15 00:00:00-06	33.00	83.00
140	140	140	66.00	2025-09-22 00:00:00-06	7.00	28.00
141	141	141	69.00	2025-02-11 00:00:00-06	31.00	27.00
142	142	142	78.00	2025-02-14 00:00:00-06	32.00	84.00
143	143	143	57.00	2025-07-09 00:00:00-06	75.00	77.00
144	144	144	96.00	2024-12-10 00:00:00-06	93.00	1.00
145	145	145	1.00	2025-03-30 00:00:00-06	91.00	98.00
146	146	146	74.00	2025-03-15 00:00:00-06	62.00	81.00
147	147	147	86.00	2025-03-16 00:00:00-06	10.00	69.00
148	148	148	56.00	2025-03-14 00:00:00-06	46.00	2.00
149	149	149	3.00	2025-01-27 00:00:00-06	69.00	69.00
150	150	150	25.00	2025-06-15 00:00:00-06	32.00	52.00
151	151	151	78.00	2024-12-25 00:00:00-06	89.00	99.00
152	152	152	29.00	2025-06-10 00:00:00-06	23.00	2.00
153	153	153	99.00	2025-05-01 00:00:00-06	25.00	85.00
154	154	154	41.00	2024-12-31 00:00:00-06	10.00	13.00
155	155	155	92.00	2025-03-26 00:00:00-06	20.00	79.00
156	156	156	74.00	2025-04-05 00:00:00-06	71.00	41.00
157	157	157	40.00	2025-03-25 00:00:00-06	90.00	95.00
158	158	158	84.00	2025-05-19 00:00:00-06	7.00	95.00
159	159	159	33.00	2025-06-29 00:00:00-06	59.00	82.00
160	160	160	3.00	2025-03-08 00:00:00-06	45.00	21.00
161	161	161	1.00	2025-03-06 00:00:00-06	74.00	17.00
162	162	162	47.00	2024-10-07 00:00:00-06	21.00	15.00
163	163	163	22.00	2025-01-31 00:00:00-06	18.00	16.00
164	164	164	25.00	2025-08-10 00:00:00-06	97.00	52.00
165	165	165	94.00	2025-06-12 00:00:00-06	88.00	93.00
166	166	166	21.00	2025-07-13 00:00:00-06	70.00	84.00
167	167	167	23.00	2025-06-07 00:00:00-06	62.00	49.00
168	168	168	24.00	2025-05-25 00:00:00-06	2.00	4.00
169	169	169	82.00	2024-11-22 00:00:00-06	98.00	52.00
170	170	170	24.00	2025-06-08 00:00:00-06	45.00	96.00
171	171	171	77.00	2025-01-16 00:00:00-06	65.00	18.00
172	172	172	82.00	2025-01-22 00:00:00-06	30.00	57.00
173	173	173	97.00	2025-02-15 00:00:00-06	78.00	21.00
174	174	174	46.00	2025-08-08 00:00:00-06	61.00	36.00
175	175	175	97.00	2024-12-13 00:00:00-06	51.00	96.00
176	176	176	46.00	2025-03-29 00:00:00-06	49.00	85.00
177	177	177	4.00	2025-09-19 00:00:00-06	11.00	65.00
178	178	178	61.00	2025-03-22 00:00:00-06	75.00	11.00
179	179	179	13.00	2024-09-28 00:00:00-06	5.00	66.00
180	180	180	78.00	2024-11-10 00:00:00-06	99.00	16.00
181	181	181	4.00	2025-01-19 00:00:00-06	40.00	51.00
182	182	182	83.00	2025-05-04 00:00:00-06	21.00	14.00
183	183	183	73.00	2025-05-14 00:00:00-06	36.00	18.00
184	184	184	72.00	2025-08-17 00:00:00-06	76.00	76.00
185	185	185	75.00	2025-03-17 00:00:00-06	11.00	98.00
186	186	186	44.00	2024-11-14 00:00:00-06	67.00	95.00
187	187	187	82.00	2025-09-24 00:00:00-06	9.00	92.00
188	188	188	99.00	2025-06-27 00:00:00-06	58.00	19.00
189	189	189	81.00	2025-05-06 00:00:00-06	25.00	2.00
190	190	190	40.00	2025-07-06 00:00:00-06	62.00	10.00
191	191	191	52.00	2025-08-16 00:00:00-06	84.00	71.00
192	192	192	72.00	2025-05-29 00:00:00-06	1.00	62.00
193	193	193	13.00	2025-01-19 00:00:00-06	98.00	75.00
194	194	194	37.00	2025-02-10 00:00:00-06	65.00	64.00
195	195	195	38.00	2025-08-20 00:00:00-06	32.00	79.00
196	196	196	77.00	2025-04-05 00:00:00-06	87.00	79.00
197	197	197	23.00	2025-04-28 00:00:00-06	40.00	39.00
198	198	198	73.00	2025-04-06 00:00:00-06	79.00	5.00
199	199	199	3.00	2025-07-03 00:00:00-06	51.00	33.00
200	200	200	87.00	2025-05-27 00:00:00-06	94.00	98.00
201	201	201	90.00	2025-01-20 00:00:00-06	50.00	36.00
202	202	202	9.00	2025-05-19 00:00:00-06	42.00	18.00
203	203	203	32.00	2025-05-06 00:00:00-06	80.00	9.00
204	204	204	40.00	2024-10-23 00:00:00-06	76.00	75.00
205	205	205	27.00	2025-06-17 00:00:00-06	43.00	13.00
206	206	206	33.00	2025-09-14 00:00:00-06	82.00	48.00
207	207	207	68.00	2025-06-27 00:00:00-06	96.00	83.00
208	208	208	77.00	2024-10-08 00:00:00-06	39.00	96.00
209	209	209	82.00	2025-02-21 00:00:00-06	62.00	4.00
210	210	210	57.00	2025-09-05 00:00:00-06	76.00	30.00
211	211	211	5.00	2025-05-23 00:00:00-06	50.00	91.00
212	212	212	46.00	2024-12-13 00:00:00-06	82.00	8.00
213	213	213	57.00	2025-07-06 00:00:00-06	66.00	11.00
214	214	214	21.00	2025-09-10 00:00:00-06	12.00	11.00
215	215	215	71.00	2025-09-11 00:00:00-06	85.00	48.00
216	216	216	25.00	2025-08-04 00:00:00-06	99.00	56.00
217	217	217	14.00	2025-03-24 00:00:00-06	65.00	61.00
218	218	218	18.00	2025-08-22 00:00:00-06	93.00	73.00
219	219	219	47.00	2025-03-12 00:00:00-06	34.00	28.00
220	220	220	28.00	2025-07-27 00:00:00-06	58.00	72.00
221	221	221	54.00	2025-04-28 00:00:00-06	87.00	83.00
222	222	222	82.00	2025-02-09 00:00:00-06	29.00	31.00
223	223	223	18.00	2025-08-29 00:00:00-06	82.00	2.00
224	224	224	95.00	2024-11-30 00:00:00-06	80.00	63.00
225	225	225	82.00	2024-10-18 00:00:00-06	12.00	63.00
226	226	226	51.00	2025-03-14 00:00:00-06	97.00	14.00
227	227	227	16.00	2025-08-25 00:00:00-06	75.00	90.00
228	228	228	53.00	2024-09-29 00:00:00-06	39.00	39.00
229	229	229	37.00	2025-02-13 00:00:00-06	1.00	28.00
230	230	230	10.00	2025-08-19 00:00:00-06	47.00	17.00
231	231	231	70.00	2024-10-12 00:00:00-06	87.00	63.00
232	232	232	42.00	2025-06-18 00:00:00-06	50.00	17.00
233	233	233	28.00	2025-07-05 00:00:00-06	5.00	61.00
234	234	234	12.00	2024-11-25 00:00:00-06	12.00	17.00
235	235	235	1.00	2025-05-03 00:00:00-06	26.00	67.00
236	236	236	28.00	2025-01-06 00:00:00-06	19.00	67.00
237	237	237	70.00	2025-01-24 00:00:00-06	35.00	44.00
238	238	238	27.00	2024-11-11 00:00:00-06	91.00	6.00
239	239	239	22.00	2025-01-08 00:00:00-06	2.00	96.00
240	240	240	31.00	2025-03-30 00:00:00-06	58.00	4.00
241	241	241	81.00	2024-10-02 00:00:00-06	40.00	87.00
242	242	242	66.00	2025-03-24 00:00:00-06	85.00	88.00
243	243	243	54.00	2025-06-22 00:00:00-06	47.00	50.00
244	244	244	62.00	2025-05-15 00:00:00-06	85.00	19.00
245	245	245	71.00	2025-05-14 00:00:00-06	13.00	93.00
246	246	246	5.00	2025-06-26 00:00:00-06	66.00	47.00
247	247	247	14.00	2025-03-22 00:00:00-06	32.00	71.00
248	248	248	8.00	2025-01-17 00:00:00-06	64.00	24.00
249	249	249	91.00	2025-05-10 00:00:00-06	56.00	41.00
250	250	250	68.00	2025-02-19 00:00:00-06	7.00	65.00
\.


--
-- TOC entry 5449 (class 0 OID 41098)
-- Dependencies: 248
-- Data for Name: HABITACIONES; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."HABITACIONES" (numero_habitacion, descripcion, piso, id_estado_habitacion) FROM stdin;
1	Crispy breadsticks seasoned with herbs and garlic.	6	1
2	Crunchy granola full of peanut butter flavor and oats.	33	2
3	Non-stick baking mat for easy cooking and cleanup.	3	3
4	Supportive yoga wheel for deep stretching and balance.	14	4
5	All-natural skincare set for daily use.	41	5
6	Comfortable camping mattress that inflates automatically.	15	6
7	Fragrant jasmine rice, perfect as a side dish.	45	7
8	Refreshing sparkling water infused with cranberry and lime flavors.	12	8
9	Spicy salsa made with fresh ingredients.	29	9
10	Dairy-free ice cream made with coconut milk, creamy and delicious.	23	10
11	High-precision oven thermometer for accurate cooking.	30	11
12	Compact campfire for grilling and warmth during camping trips.	24	12
13	Unsweetened coconut flakes for baking and snacking.	34	13
14	A delicious tart filled with fresh raspberry filling.	34	14
15	Modern lamp featuring a USB port for convenient charging.	34	15
16	Lightweight cover-up perfect for the beach, with a breezy design.	34	16
17	Stylish ankle strap heels for a classy look at any event.	10	17
18	Retro instant camera for capturing and printing photos instantly.	22	18
19	A trendy fanny pack, perfect for hands-free outings.	9	19
20	Spicy black bean burgers, great on the grill.	25	20
21	Compact hand mixer for easy baking.	14	21
22	Wi-Fi enabled doorbell with HD camera and two-way audio.	6	22
23	Premium potting soil for indoor plants.	45	23
24	Custom engraved ID tags for pets with your contact information.	24	24
25	Compact camp stove for outdoor cooking.	3	25
26	Practical organizer for keeping your home tidy and clutter-free.	32	26
27	Comprehensive camera and alert system for home security.	3	27
28	Wireless earbuds designed for immersive sound experience.	26	28
29	Compact towels that expand when wet, ideal for travel.	45	29
30	Crunchy seeds perfect for toppings and baking.	34	30
31	Fresh sushi rolls filled with a variety of vegetables.	5	31
32	Travel-friendly water bottle for pets on the go.	47	32
33	Soft and cozy slippers for indoor wear.	31	33
34	Delicious pie filled with coconut cream and topped with whipped cream.	26	34
35	Easy-to-make pancake mix with pumpkin spice flavor.	26	35
36	Relax and soothe tired feet with this foot spa.	11	36
37	Pitted black olives, perfect for salads and pizzas.	44	37
38	Stackable containers for organizing snacks and treats.	50	38
39	Manual pasta maker for creating fresh pasta at home.	13	39
40	Tender chicken coated in a sweet and savory honey garlic sauce.	40	40
41	Challenging puzzle game set for family entertainment.	45	41
42	UV-blocking clothing for outdoor activities.	31	42
43	Sweet mixture of cinnamon and sugar for sprinkling.	11	43
44	A blend of peach and mango for a tropical smoothie.	48	44
45	Ergonomic wireless controller for gaming consoles.	18	45
46	Classic marinara sauce for pasta, pizza, or dipping.	50	46
47	Spicy and tangy chili sauce for adding heat to any dish.	21	47
48	Space-saving bike for indoor workouts.	40	48
49	Tangy sour cream, perfect for dips and toppings.	21	49
50	Chic high-waisted skirt, perfect for professional or casual settings.	31	50
51	Sweet and savory carrots glazed in honey, perfect as a side dish.	29	51
52	Sweet and gooey cinnamon rolls, ready to bake.	6	52
53	Crispy tortilla chips, perfect for dipping.	24	53
54	Chic wrap jumpsuit that flatters the body and is perfect for any occasion.	30	54
55	Freshly baked bagels, perfect for breakfast or snacks.	2	55
56	Frozen pizza rolls stuffed with spinach and cheese, perfect for snacking.	22	56
57	Comfortable pet carrier for travel and vet visits.	20	57
58	Eco-friendly yoga mat made from sustainable materials.	12	58
59	Stainless steel measuring spoons set for cooking.	17	59
60	DIY LED strip lights with remote control.	21	60
61	Durable and spacious backpack for travel and school.	3	61
62	Wax warmer for creating a soothing atmosphere with fragrances.	18	62
63	Versatile canvas sneakers suitable for everyday wear with a comfortable fit.	21	63
64	Eco-friendly silicone bags for food storage and snacks.	23	64
65	Wide range of flavored wings, perfect for parties or casual snacking.	38	65
66	A ready-to-eat salad made with chickpeas and veggies.	2	66
67	A zesty salsa made with peaches and mangos, great for chips.	45	67
68	Classic chino shorts in a versatile color for summer adventures.	9	68
69	A delicious chicken dish featuring honey and sesame flavors.	38	69
70	A timeless baseball cap that adds a sporty touch to any outfit.	8	70
71	Comfortable over-ear headphones with deep bass.	48	71
72	Everything you need for maintaining a healthy beard.	24	72
73	Stylish ankle strap heels for a classy look at any event.	24	73
74	Learning tablet with kid-friendly educational apps.	21	74
75	A delicious salad with quinoa, nuts, and cranberries.	30	75
76	Chic slingback sandals for a relaxed summer vibe.	32	76
77	Canned chickpeas, perfect for hummus or salads.	32	77
78	Frozen onion rings, crispy and ready to bake.	43	78
79	Lightweight and moisture-wicking racerback tank for workouts.	45	79
80	3D model puzzle kit for creative builders.	15	80
81	A classic denim jacket that never goes out of style.	5	81
82	Light and fluffy popcorn coated in sweet honey butter.	41	82
83	Fruits dipped in rich chocolate, perfect for desserts.	20	83
84	Spicy and creamy dip made with shredded chicken, perfect for parties.	31	84
85	Complete meal kit with everything needed to make beef stroganoff in under 30 minutes.	50	85
86	Stackable steamers for healthy cooking of vegetables and seafood.	7	86
87	Waterproof rain jacket with adjustable hood.	11	87
88	High-capacity power bank for charging devices on the go.	7	88
89	Multi-port USB-C hub for connecting devices.	38	89
90	A blend of dried herbs commonly used in Italian cooking.	12	90
91	Noise-cancelling Bluetooth headphones for immersive sound.	9	91
92	Reversible bamboo chopping board for food prep.	15	92
93	Challenging 1000-piece jigsaw puzzle for all ages.	4	93
94	Fresh button mushrooms, great for cooking.	43	94
95	Seasoned and roasted to perfection, ready to eat.	15	95
96	Refreshing dessert bars made with pineapple and coconut.	16	96
97	Complete kit to make your own flavored lip balms at home.	44	97
98	Manual pasta maker for creating fresh pasta at home.	24	98
99	Classic fit blue jeans with a slight stretch for comfort and durability.	15	99
100	Rich and creamy smoked Gouda cheese perfect for snacking.	20	100
101	A seasoning blend of garlic and herbs to enhance any dish.	3	101
102	Mix for homemade cornbread, just add water and bake for a delicious side.	37	102
103	Seal food and maintain freshness longer.	15	103
104	All ingredients included for delicious chicken fajitas.	45	104
105	Shredded potatoes, perfect for breakfasts.	35	105
106	8oz water bottle with built-in filter for clean drinking water.	12	106
107	Adjustable footrest for improved comfort while sitting.	48	107
108	Professional sharpening system for kitchen knives.	7	108
109	Convenient carrier for transporting yoga mat.	49	109
110	Pure and natural honey, great for sweetening.	32	110
111	Spicy and flavorful soup made with black beans, perfect as a meal or starter.	8	111
112	A light and tangy dressing with poppy seeds, perfect for salads.	29	112
113	Portable bed for pets while traveling.	36	113
114	Fruits dipped in rich chocolate, perfect for desserts.	21	114
115	Comfortable slim fit chinos for a polished look.	42	115
116	Set of flexible molds for baking cakes and pastries.	11	116
117	Quick oatmeal packets infused with apple and cinnamon, perfect for breakfast.	23	117
118	Oven-roasted potatoes tossed in garlic and parmesan cheese seasoning.	9	118
119	Stylish wine rack to store and display bottles.	29	119
120	Eco-friendly yoga mat made from sustainable materials.	41	120
121	A mix of frozen roasted vegetables for an easy side dish.	11	121
122	Comfortable pet bed for small to medium-sized dogs.	50	122
123	True wireless earbuds with touch control.	24	123
124	Qi-certified wireless charger for fast charging.	1	124
125	A nourishing bowl of sweet potatoes and chickpeas with spices.	42	125
126	Smoothie mix combining peanut butter and banana, great for a quick breakfast.	19	126
127	Space-saving crates for easy organization at home or while traveling.	20	127
128	Collapsible travel bowl for pets on the go.	4	128
129	Creamy dessert made with rice and cinnamon.	16	129
130	A sweet and spicy sauce ideal for spring rolls or chicken nuggets.	26	130
131	Qi-certified charger for fast wireless charging of smartphones.	26	131
132	Fragrant fried rice with authentic Thai basil and veggies.	4	132
133	Fun lunchbox for kids with a sturdy design.	18	133
134	A pack of assorted nut and protein bars for a quick energy boost.	49	134
135	Crunchy and nutritious almonds, perfect for snacking.	24	135
136	Flavorful lentil soup, perfect for a quick meal.	35	136
137	Set of stylish watch bands to customize your look.	37	137
138	Lightweight and breathable running shorts for your workouts.	43	138
139	Complete kit for emergency situations including food and water.	24	139
140	Creamy Greek yogurt infused with raspberry and vanilla flavors.	24	140
141	Compact air purifier to improve indoor air quality.	10	141
142	Chocolate coconut protein bars inspired by the classic candy bar.	14	142
143	HEPA air purifier for clean indoor air.	14	143
144	Homemade jam made with blueberries and chia seeds, no added sugar.	13	144
145	True wireless earbuds with touch control.	19	145
146	Stylish and spacious case for makeup and beauty products.	35	146
147	Crispy and chewy granola bars, perfect for on-the-go.	25	147
148	Unique coffee brewing method for a flavorful experience.	12	148
149	Multi-functional grater for cheese and vegetables.	23	149
150	Fresh and organic sweet potatoes, ideal for roasting.	18	150
151	Oven-roasted potatoes tossed in garlic and parmesan cheese seasoning.	45	151
152	Crunchy chips made from blue corn, perfect for dipping.	48	152
153	Fresh sliced bell peppers for salads or stir-fries.	48	153
154	A seasoning blend of garlic and herbs to enhance any dish.	12	154
155	Crunchy pretzel bites filled with peanut butter	35	155
156	Automated stirring for your drinks with just a press of a button.	23	156
157	Crunchy and sweet banana chips, a great on-the-go snack.	41	157
158	Portable and lightweight umbrella for protection from rain.	31	158
159	Stylish black leather jacket featuring a zip-up front and multiple pockets.	36	159
160	Durable bag for carrying your yoga mat and accessories.	40	160
161	Stylish watering can for plants with easy pouring nozzle.	16	161
162	Creamy risotto made with mushrooms and herbs, perfect as a side dish or main course.	18	162
163	Secure phone mount for your vehicle's dashboard.	45	163
164	A delightful mix of dried fruits for trail mix or snacks.	44	164
165	Custom keychain with engraved text.	10	165
166	Crunchy pretzels coated in rich chocolate, a sweet treat.	1	166
167	Elegant chiffon blouse perfect for work or outings.	13	167
168	Durable jump rope with built-in counter for workouts.	6	168
169	Relaxing paint kit with pre-printed canvas for painting.	29	169
170	Spreadable cream cheese blended with garlic and herbs.	45	170
171	Marinated beef strips in teriyaki sauce for easy grilling.	18	171
172	Stylish faux leather leggings for a trendy outfit.	26	172
173	Clip-on guitar tuner with LCD display.	31	173
174	Bluetooth speakers with excellent sound quality.	40	174
175	Sweet relish made from cucumbers, perfect for sandwiches.	50	175
176	Snooze function and LED display for easy reading.	10	176
177	Flavorful dressing made with miso paste	48	177
178	Expandable caddy for holding books, phones, and snacks while in the bath.	48	178
179	Corn on the cob seasoned with chili and lime for a spicy kick.	50	179
180	Durable and shatterproof silicone glasses for outdoor use.	3	180
181	Rechargeable training collar for effective behavior training.	32	181
182	Assorted fruit-flavored gummy snacks that kids love.	3	182
183	Crispy and sweet dried apple slices	14	183
184	Handy keychain that emits a loud alarm for personal safety.	2	184
185	Instant hot water dispenser for tea and cooking.	9	185
186	A stylish midi dress with stylish pleats, suitable for any occasion.	38	186
187	Comfortable and breathable backpack for carrying small pets.	49	187
188	Leak-proof bottles for travel-sized toiletries.	17	188
189	Sweet and tangy mango chutney for a flavorful dip.	32	189
190	Hanging bird feeder for backyard birds.	16	190
191	Ergonomic desk that adjusts height for standing or sitting.	23	191
192	Fresh and crunchy cucumbers, great for salads.	46	192
193	A tangy and spicy BBQ sauce that's perfect for grilling.	40	193
194	A zero-calorie coconut oil spray for cooking and baking.	29	194
195	Quick oatmeal packets infused with apple and cinnamon, perfect for breakfast.	14	195
196	Comfortable and warm leggings perfect for colder weather.	2	196
197	Delicious frozen pizza with a variety of toppings.	44	197
198	Chewy snack bars with coconut and almonds coated in chocolate.	47	198
199	Lightweight and portable picnic table for outdoor use.	38	199
200	A creamy and tangy dressing perfect for salads or as a dipping sauce.	43	200
201	Adjustable laptop stand for better ergonomics.	3	201
202	Stainless steel travel mug that keeps drinks hot or cold.	23	202
203	Chickpeas mixed with fresh vegetables and herbs, a nutritious snack or salad.	9	203
204	Rich spaghetti sauce, a perfect pasta sauce.	28	204
205	GPS collar that monitors your pet's location and activity level.	27	205
206	Frozen falafel balls made from chickpeas and herbs, perfect for quick meals or salads.	48	206
207	Personalize your calendar with photos and special dates.	26	207
208	Deliciously smoked salmon, great for bagels.	27	208
209	Fresh basil pesto, perfect for pasta or as a sandwich spread.	47	209
210	Soft flannel shirt with a timeless plaid pattern, perfect for layering.	1	210
211	Creamy peanut butter with no added sugar or oils.	44	211
212	Warm and stylish jacket for cold weather.	5	212
213	Bold graphic hoodie featuring a comfortable fit and soft fabric.	12	213
214	Upgrade your phone photography with this lens kit that includes wide-angle and macro lenses.	44	214
215	Crunchy, toasted coconut chips for snacking.	29	215
216	Rechargeable water flosser for dental hygiene.	8	216
217	Variety pack of craft supplies for kids' projects.	7	217
218	Comprehensive first aid kit for home or travel emergencies.	14	218
219	Safety collar with flashing lights for pets during night walks.	3	219
220	Soft and plush robe for comfort after the shower.	24	220
221	Ultrasonic essential oil diffuser with LED lights.	17	221
222	Vegan sushi filled with spicy vegetables and avocado.	1	222
223	Advanced electric toothbrush for effective cleaning.	44	223
224	GPS pet collar that helps locate your pet via smartphone app.	20	224
225	Advanced electric toothbrush for effective cleaning.	11	225
226	Warm oatmeal flavored with apple and cinnamon.	31	226
227	Multifunctional smartwatch for fitness tracking.	10	227
228	A refreshing salad made with quinoa and seasonal veggies.	13	228
229	Non-slip yoga mat for optimal grip and comfort.	47	229
230	Instant noodles with a spicy Thai sauce for quick meals.	27	230
231	Ergonomic memory foam pillow for better sleep.	18	231
232	Pure maple syrup for pancakes and more.	2	232
233	Juicy raisins coated in rich dark chocolate.	28	233
234	Non-slip yoga mat for optimal grip and comfort.	16	234
235	Reversible bamboo chopping board for food prep.	39	235
236	Crispy apple chips drizzled with caramel for a sweet treat.	17	236
237	Spicy cauliflower bites for a vegetarian snack.	36	237
238	Relaxing paint kit with pre-printed canvas for painting.	3	238
239	Efficient juicer for fresh fruit and vegetable juices.	31	239
240	Delicious cookies made with almond flour for a gluten-free treat.	32	240
241	Portable projector with 1080p resolution for movies.	39	241
242	Set of elegant wine glasses for special occasions.	1	242
243	Savory teriyaki sauce for stir-frying veggies or meats.	47	243
244	Handheld sprayer designed for washing pets easily.	18	244
245	Rich vegetable stock for cooking soups and stews.	12	245
246	Compact scooper for easy waste clean-up during walks.	50	246
247	Shredded cabbage and carrots for coleslaw.	38	247
248	Creamy and smooth peanut butter, perfect for sandwiches.	43	248
249	Gentle grooming gloves for shedding pets.	43	249
250	Nutty-scented oil for stir-fry and marinades.	26	250
\.


--
-- TOC entry 5450 (class 0 OID 41103)
-- Dependencies: 249
-- Data for Name: HISTORIAL_PRECIO_HABITACIONES; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."HISTORIAL_PRECIO_HABITACIONES" (id_historial_precios_habitaciones, periodo_inicio, periodo_fin, precio_habitacion_anterior, precio_habitacion_actual, id_tipo_habitacion) FROM stdin;
1	2025-06-13	2025-08-31	4.49	8.49	1
2	2024-11-03	2025-04-29	5.59	89.99	2
3	2025-09-26	2025-03-01	3.99	2.99	3
4	2024-10-24	2025-02-14	34.99	8.49	4
5	2025-08-30	2025-02-27	49.99	3.99	5
6	2025-09-18	2025-08-10	54.99	19.99	6
7	2024-10-01	2025-02-23	3.29	44.99	7
8	2024-12-02	2024-11-11	4.29	5.49	8
9	2025-01-18	2025-02-22	3.99	2.99	9
10	2025-09-20	2025-08-14	29.99	1.99	10
11	2025-09-16	2025-07-13	3.29	59.99	11
12	2025-01-16	2025-03-19	6.99	69.99	12
13	2025-07-27	2025-01-23	19.99	3.49	13
14	2025-01-09	2024-12-08	39.99	12.99	14
15	2025-03-30	2024-10-12	24.99	4.99	15
16	2025-02-27	2025-01-23	24.99	34.99	16
17	2025-01-07	2025-05-21	34.99	199.99	17
18	2025-06-20	2025-08-23	3.89	89.99	18
19	2025-05-29	2025-07-15	2.99	3.99	19
20	2025-01-10	2024-10-23	3.49	3.99	20
21	2024-10-23	2024-09-29	19.99	5.49	21
22	2025-05-09	2025-02-13	1.89	25.99	22
23	2025-07-27	2025-05-13	1.99	3.99	23
24	2025-08-12	2025-02-10	89.99	89.99	24
25	2025-01-27	2025-04-16	199.99	2.29	25
26	2025-01-05	2025-07-19	6.49	5.99	26
27	2025-03-23	2025-07-12	39.99	39.99	27
28	2024-12-04	2025-08-17	4.49	4.19	28
29	2025-07-10	2024-10-19	249.99	3.49	29
30	2025-06-12	2025-03-31	899.99	19.99	30
31	2025-04-27	2024-12-12	99.99	15.99	31
32	2024-11-25	2024-11-20	9.99	2.79	32
33	2025-05-05	2025-01-22	1.99	69.99	33
34	2024-12-09	2025-09-07	14.99	24.99	34
35	2025-03-18	2025-03-07	39.99	2.99	35
36	2024-10-25	2025-07-11	39.99	4.99	36
37	2025-04-16	2025-05-12	59.99	2.99	37
38	2024-10-14	2025-05-17	5.99	29.99	38
39	2025-07-26	2025-03-11	109.99	15.99	39
40	2024-11-29	2025-05-29	29.99	99.99	40
41	2025-05-01	2025-05-19	3.99	39.99	41
42	2025-05-15	2025-02-19	49.99	79.99	42
43	2025-07-05	2025-02-07	4.49	24.99	43
44	2025-06-28	2025-08-03	149.99	19.99	44
45	2024-09-30	2025-01-27	39.99	1.99	45
46	2025-02-02	2024-11-16	79.99	39.99	46
47	2024-11-17	2025-05-10	19.99	3.79	47
48	2024-12-17	2024-12-30	3.99	2.79	48
49	2024-10-03	2025-08-17	5.99	24.99	49
50	2025-01-14	2024-12-30	24.99	49.99	50
51	2025-09-27	2025-08-28	39.99	14.99	51
52	2024-12-28	2024-10-06	6.99	24.99	52
53	2024-11-20	2025-03-11	24.99	99.99	53
54	2025-08-06	2025-05-01	2.29	49.99	54
55	2024-11-11	2025-08-09	2.49	18.99	55
56	2025-06-17	2025-04-08	3.99	3.99	56
57	2024-10-04	2025-01-31	3.29	39.99	57
58	2024-10-10	2025-05-30	34.99	10.99	58
59	2025-01-11	2025-05-17	12.99	39.99	59
60	2025-08-08	2025-09-09	49.99	19.99	60
61	2025-08-06	2024-12-02	14.99	34.99	61
62	2024-11-29	2025-02-20	3.99	49.99	62
63	2025-07-10	2025-01-24	4.19	79.99	63
64	2025-08-17	2025-01-27	12.99	22.99	64
65	2024-10-10	2025-02-17	2.99	19.99	65
66	2025-03-30	2025-09-06	22.99	49.99	66
67	2025-07-09	2025-02-04	49.99	2.99	67
68	2024-11-27	2024-10-26	59.99	4.99	68
69	2025-09-21	2025-09-20	19.99	4.49	69
70	2025-05-24	2025-07-21	3.29	3.99	70
71	2025-05-10	2025-01-29	39.99	129.99	71
72	2025-04-19	2025-02-12	5.99	3.49	72
73	2025-02-03	2025-06-09	4.49	24.99	73
74	2025-09-05	2024-12-02	29.99	89.99	74
75	2025-04-20	2025-02-18	3.99	4.99	75
76	2025-01-15	2025-03-21	2.99	39.99	76
77	2025-07-16	2024-10-23	12.99	49.99	77
78	2025-02-17	2025-09-05	34.99	14.99	78
79	2025-02-16	2024-12-31	22.99	17.99	79
80	2024-12-11	2025-02-18	6.99	1.99	80
81	2025-05-31	2025-06-29	14.99	6.99	81
82	2025-09-05	2025-07-21	8.99	9.99	82
83	2025-02-13	2025-07-30	29.99	19.99	83
84	2025-02-08	2025-01-14	4.29	5.49	84
85	2025-09-23	2025-09-16	59.99	34.99	85
86	2025-09-07	2025-09-10	34.99	34.99	86
87	2025-08-07	2025-06-03	34.99	1.49	87
88	2024-10-08	2025-05-21	34.99	5.99	88
89	2025-01-25	2025-02-05	1.79	39.99	89
90	2024-11-23	2025-05-03	3.99	34.99	90
91	2025-01-13	2025-04-26	4.99	1.99	91
92	2025-04-09	2024-12-22	19.99	4.79	92
93	2025-04-18	2025-08-21	24.99	3.79	93
94	2025-02-06	2024-11-21	3.79	69.99	94
95	2025-03-29	2025-05-30	3.49	7.49	95
96	2025-07-02	2024-10-29	89.99	119.99	96
97	2025-03-05	2025-03-14	3.99	15.99	97
98	2025-08-01	2025-09-23	3.29	2.99	98
99	2025-03-04	2025-05-15	29.99	4.99	99
100	2024-11-14	2025-06-21	19.99	199.99	100
101	2025-07-02	2025-07-12	12.99	79.99	101
102	2025-01-08	2025-05-20	5.99	6.49	102
103	2024-09-28	2025-03-05	89.99	19.99	103
104	2025-03-20	2025-09-22	34.99	4.99	104
105	2025-04-05	2025-07-06	49.99	39.99	105
106	2025-03-22	2025-06-29	1.79	2.49	106
107	2024-12-01	2025-03-23	5.99	2.29	107
108	2025-02-03	2025-09-11	24.99	3.99	108
109	2024-12-03	2025-01-31	39.99	24.99	109
110	2024-09-30	2025-02-28	39.99	24.99	110
111	2025-01-12	2025-08-20	3.99	3.29	111
112	2025-03-18	2025-07-30	45.00	2.99	112
113	2024-10-05	2025-03-13	5.99	4.99	113
114	2025-06-27	2025-07-24	3.59	3.79	114
115	2025-03-28	2025-03-03	39.99	22.99	115
116	2025-02-15	2025-04-30	29.99	24.99	116
117	2025-02-04	2024-09-28	7.49	3.49	117
118	2025-07-07	2025-05-29	2.29	34.99	118
119	2025-05-14	2025-08-03	99.99	3.99	119
120	2025-02-27	2025-06-15	5.49	2.49	120
121	2024-11-08	2025-05-09	4.49	49.99	121
122	2025-05-18	2025-09-14	19.99	14.99	122
123	2024-11-28	2025-09-01	79.99	6.99	123
124	2025-09-06	2024-11-26	2.59	3.29	124
125	2025-05-02	2025-03-26	99.99	3.99	125
126	2025-09-14	2024-11-29	7.49	39.99	126
127	2025-02-24	2025-09-22	6.49	10.99	127
128	2025-09-12	2025-05-13	49.99	1.99	128
129	2024-11-09	2025-07-22	24.99	4.29	129
130	2024-11-06	2024-10-10	5.99	12.99	130
131	2025-05-03	2025-07-29	7.49	0.99	131
132	2025-04-01	2025-01-28	4.49	29.99	132
133	2024-10-05	2024-10-30	39.99	16.99	133
134	2025-08-18	2025-03-02	44.99	34.99	134
135	2025-08-10	2025-03-24	19.99	4.99	135
136	2025-06-10	2024-12-19	4.19	89.99	136
137	2025-02-16	2025-05-13	79.99	29.99	137
138	2025-08-14	2025-09-10	79.99	3.69	138
139	2025-08-09	2025-07-10	3.79	19.99	139
140	2025-08-01	2025-08-25	5.99	2.99	140
141	2025-05-13	2025-01-17	119.99	22.99	141
142	2025-09-01	2025-07-13	5.49	59.99	142
143	2025-01-07	2024-10-14	4.29	34.99	143
144	2025-03-22	2025-03-10	7.19	14.99	144
145	2025-02-01	2024-12-13	4.99	39.99	145
146	2025-01-01	2024-10-20	49.99	1.29	146
147	2025-09-04	2025-07-11	4.29	4.49	147
148	2025-09-20	2025-01-06	59.99	29.99	148
149	2025-02-17	2024-09-30	19.99	2.29	149
150	2024-11-21	2025-02-21	4.29	19.99	150
151	2025-02-15	2025-06-22	4.29	3.99	151
152	2024-12-20	2025-01-05	2.49	7.99	152
153	2024-10-18	2025-09-13	5.99	39.99	153
154	2024-12-17	2025-05-16	29.99	2.29	154
155	2025-07-17	2024-11-23	5.99	29.99	155
156	2025-06-06	2025-01-30	45.00	5.99	156
157	2025-08-22	2024-10-27	3.49	1.89	157
158	2025-02-27	2025-08-29	3.99	2.49	158
159	2025-08-05	2025-03-12	29.99	0.75	159
160	2025-01-07	2025-01-22	99.99	39.99	160
161	2025-08-28	2025-09-08	2.49	19.99	161
162	2025-08-26	2024-10-27	3.50	99.99	162
163	2024-12-06	2025-09-15	2.49	99.99	163
164	2024-12-25	2025-02-19	4.99	22.99	164
165	2025-03-31	2025-02-19	4.19	2.49	165
166	2024-11-01	2024-12-14	25.99	19.99	166
167	2025-03-23	2025-08-14	14.99	29.99	167
168	2024-11-26	2025-05-28	0.75	34.99	168
169	2025-04-03	2024-12-08	59.99	14.99	169
170	2025-05-23	2025-08-24	29.99	59.99	170
171	2025-08-08	2025-04-21	249.99	2.89	171
172	2025-09-22	2025-05-05	5.49	15.99	172
173	2025-02-19	2024-10-03	24.99	19.99	173
174	2025-01-15	2024-12-08	2.29	22.99	174
175	2025-06-25	2025-04-26	6.49	49.99	175
176	2024-12-25	2025-03-03	3.99	1.39	176
177	2024-11-27	2025-06-07	29.99	3.99	177
178	2024-11-06	2025-03-03	69.99	79.99	178
179	2025-09-01	2025-04-22	24.99	3.99	179
180	2025-02-05	2024-10-13	24.99	12.99	180
181	2025-02-08	2025-01-30	7.99	3.99	181
182	2025-01-27	2025-01-21	22.99	5.99	182
183	2025-08-29	2025-06-05	3.29	44.99	183
184	2025-08-25	2024-10-09	4.99	3.29	184
185	2025-03-05	2025-06-15	39.99	149.99	185
186	2025-02-27	2024-11-21	3.79	24.99	186
187	2025-03-15	2025-03-25	3.50	2.99	187
188	2025-02-20	2025-01-20	34.99	14.99	188
189	2025-06-21	2025-03-06	3.49	3.99	189
190	2025-04-15	2025-08-16	25.99	29.99	190
191	2025-06-11	2024-12-16	5.99	199.99	191
192	2025-03-06	2025-05-22	14.99	3.49	192
193	2024-11-12	2024-12-02	4.29	34.99	193
194	2025-07-02	2025-04-28	89.99	89.99	194
195	2024-12-12	2024-11-10	109.99	3.79	195
196	2024-11-27	2024-12-27	9.99	19.99	196
197	2025-08-01	2025-09-22	5.99	99.99	197
198	2024-10-27	2025-06-01	3.99	69.99	198
199	2025-04-19	2024-11-08	89.99	4.99	199
200	2025-05-27	2025-06-28	5.49	19.99	200
201	2025-03-05	2025-08-11	299.99	2.29	201
202	2024-12-28	2025-08-31	79.99	5.49	202
203	2025-04-17	2025-04-28	15.99	34.99	203
204	2024-10-17	2025-06-09	39.99	3.49	204
205	2024-12-25	2025-01-04	19.99	1.89	205
206	2024-12-29	2025-01-12	3.99	3.99	206
207	2025-01-17	2025-03-07	1.99	45.99	207
208	2025-07-08	2025-09-14	5.49	14.99	208
209	2025-03-02	2025-08-16	49.99	29.99	209
210	2025-07-02	2025-01-20	5.49	14.99	210
211	2025-07-24	2025-05-30	4.99	4.49	211
212	2025-04-12	2024-12-30	29.99	10.99	212
213	2024-11-30	2025-08-16	8.99	49.99	213
214	2025-01-03	2025-08-01	29.99	22.99	214
215	2025-09-02	2025-01-12	4.19	34.99	215
216	2025-09-24	2025-04-27	4.99	79.99	216
217	2024-11-28	2025-09-12	29.99	4.29	217
218	2025-02-12	2024-12-20	5.99	1.50	218
219	2025-04-20	2025-04-22	3.59	5.49	219
220	2025-02-16	2025-04-03	2.49	89.99	220
221	2025-03-16	2025-01-19	29.99	39.99	221
222	2025-07-19	2024-10-17	99.99	54.99	222
223	2025-09-09	2025-06-29	6.99	59.99	223
224	2025-03-23	2025-01-21	24.99	29.99	224
225	2025-04-20	2025-06-04	29.99	4.99	225
226	2025-09-26	2025-08-14	3.49	3.99	226
227	2025-04-19	2025-05-20	7.49	5.99	227
228	2025-02-25	2025-05-30	3.99	4.79	228
229	2025-03-23	2025-05-29	19.99	15.99	229
230	2025-08-07	2025-08-06	4.99	3.29	230
231	2025-06-22	2025-01-07	39.99	4.99	231
232	2024-10-04	2025-05-19	39.99	59.99	232
233	2025-04-16	2025-05-12	32.99	4.29	233
234	2024-11-30	2025-01-21	3.29	4.99	234
235	2024-09-28	2025-04-18	19.99	14.99	235
236	2025-06-29	2024-12-10	39.99	24.99	236
237	2024-11-09	2024-12-30	29.99	34.99	237
238	2024-11-19	2025-01-28	2.99	19.99	238
239	2025-04-10	2024-12-26	39.00	24.99	239
240	2025-06-18	2025-03-12	44.99	1.29	240
241	2024-10-09	2025-02-20	3.99	3.49	241
242	2025-01-29	2025-09-06	3.99	12.99	242
243	2025-05-30	2025-07-22	19.99	29.99	243
244	2024-11-23	2025-07-19	49.99	3.79	244
245	2024-10-01	2025-02-04	19.99	12.99	245
246	2025-04-21	2025-08-02	4.49	8.99	246
247	2025-09-03	2025-08-09	5.99	59.99	247
248	2025-05-30	2024-11-17	199.99	4.49	248
249	2025-04-04	2025-01-01	3.49	3.19	249
250	2025-08-16	2025-06-01	4.29	5.29	250
\.


--
-- TOC entry 5451 (class 0 OID 41106)
-- Dependencies: 250
-- Data for Name: HISTORIAL_PRECIO_SERVICIOS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."HISTORIAL_PRECIO_SERVICIOS" (id_historial_precios_servicios, periodo_inicio, periodo_fin, precio_servicio_anterior, precio_servicio_actual, id_servicio) FROM stdin;
1	2024-10-04	2025-07-07	4.99	24.99	1
2	2025-09-17	2024-10-25	44.99	29.99	2
3	2024-10-07	2025-04-28	4.49	299.99	3
4	2025-02-28	2025-06-06	9.99	1.89	4
5	2024-09-29	2025-01-16	2.49	2.99	5
6	2024-12-14	2025-05-01	49.99	15.99	6
7	2025-09-26	2024-10-30	1.99	2.99	7
8	2024-10-04	2025-01-29	29.99	19.99	8
9	2025-01-25	2025-04-08	29.99	12.99	9
10	2025-01-28	2024-10-08	4.99	3.29	10
11	2025-09-18	2025-01-28	139.99	24.99	11
12	2025-08-24	2025-05-25	299.99	3.99	12
13	2025-02-23	2025-06-12	19.99	199.99	13
14	2025-07-04	2024-10-31	3.99	5.49	14
15	2025-03-29	2025-08-25	149.99	39.99	15
16	2024-11-15	2024-11-07	14.99	6.49	16
17	2024-11-20	2025-03-05	15.99	29.99	17
18	2024-12-10	2025-07-25	2.49	29.99	18
19	2024-10-14	2025-08-18	39.99	5.49	19
20	2025-08-13	2024-12-15	1.99	2.99	20
21	2025-01-01	2024-09-30	4.99	39.99	21
22	2025-07-05	2025-06-10	79.99	89.99	22
23	2025-05-09	2024-12-22	59.99	24.99	23
24	2025-03-09	2025-01-12	45.00	4.29	24
25	2025-01-16	2024-11-30	64.99	2.49	25
26	2025-09-26	2024-12-08	299.99	79.99	26
27	2025-04-30	2025-03-25	19.99	29.99	27
28	2024-12-08	2025-03-24	12.99	7.99	28
29	2025-09-27	2024-10-15	69.99	7.99	29
30	2024-12-29	2025-02-25	3.49	9.99	30
31	2025-05-04	2025-02-20	69.99	19.99	31
32	2025-02-20	2025-09-03	99.99	2.49	32
33	2025-09-24	2025-09-17	2.79	24.99	33
34	2025-02-06	2025-03-10	3.29	2.49	34
35	2024-12-21	2025-02-18	2.29	24.99	35
36	2025-01-09	2025-01-13	22.99	34.99	36
37	2025-05-16	2024-10-17	5.49	4.99	37
38	2025-07-09	2024-12-29	99.99	4.29	38
39	2025-03-03	2025-03-12	24.99	49.99	39
40	2025-03-27	2025-01-14	24.99	1.99	40
41	2024-10-29	2025-07-23	22.99	2.49	41
42	2025-05-26	2024-11-13	3.79	4.49	42
43	2025-06-12	2025-07-09	4.29	19.99	43
44	2024-11-27	2024-11-01	24.99	79.99	44
45	2025-04-08	2024-11-23	24.99	4.99	45
46	2025-05-26	2025-02-10	19.99	4.99	46
47	2025-01-07	2025-01-16	1.99	5.99	47
48	2025-02-01	2025-06-26	4.49	2.19	48
49	2025-07-28	2025-04-20	39.99	3.29	49
50	2024-10-31	2025-07-11	14.99	2.99	50
51	2024-09-28	2025-09-05	4.99	49.99	51
52	2024-10-29	2024-10-13	45.99	3.29	52
53	2025-09-23	2025-08-08	5.99	4.19	53
54	2024-12-01	2024-10-25	1.79	3.99	54
55	2025-06-02	2024-10-20	9.99	3.50	55
56	2025-02-25	2025-02-20	19.99	19.99	56
57	2024-12-27	2025-08-10	29.99	99.99	57
58	2025-03-15	2025-09-20	4.49	24.99	58
59	2025-04-29	2025-06-01	3.59	2.99	59
60	2025-03-21	2024-12-21	19.99	24.99	60
61	2025-08-03	2025-03-06	5.49	34.99	61
62	2024-12-24	2025-05-12	34.99	2.49	62
63	2024-10-06	2025-02-15	11.99	2.99	63
64	2025-05-05	2025-01-09	149.99	24.99	64
65	2025-06-06	2024-12-29	2.79	59.99	65
66	2025-08-10	2025-01-04	39.99	6.99	66
67	2024-10-17	2025-03-11	199.00	5.49	67
68	2025-02-15	2025-01-11	54.99	9.99	68
69	2025-05-17	2024-12-11	39.99	14.99	69
70	2025-01-26	2025-08-20	4.99	12.99	70
71	2024-11-24	2025-06-09	4.99	24.99	71
72	2025-03-25	2025-02-27	14.99	19.99	72
73	2025-03-18	2025-03-21	39.00	24.99	73
74	2025-06-23	2025-03-26	2.99	14.99	74
75	2025-02-23	2025-04-23	15.99	29.99	75
76	2024-12-20	2024-10-29	34.99	4.49	76
77	2025-05-12	2025-05-22	59.99	3.29	77
78	2024-11-09	2025-07-26	1.99	3.99	78
79	2025-04-06	2025-04-17	29.99	39.99	79
80	2025-04-26	2024-12-11	99.99	18.99	80
81	2025-04-10	2025-03-14	2.79	99.99	81
82	2025-01-24	2025-04-22	3.29	12.99	82
83	2024-10-01	2025-05-02	3.49	3.99	83
84	2025-09-24	2025-07-28	5.99	39.99	84
85	2025-07-03	2025-02-19	8.49	39.99	85
86	2024-11-17	2024-11-17	3.79	14.99	86
87	2025-08-17	2024-10-31	39.99	49.99	87
88	2024-10-10	2025-09-06	2.49	19.99	88
89	2025-04-20	2025-04-05	129.99	49.99	89
90	2025-03-27	2025-02-09	2.99	3.49	90
91	2025-06-20	2025-01-20	3.49	19.99	91
92	2025-09-27	2025-04-06	4.99	2.49	92
93	2025-01-03	2024-12-19	4.29	4.99	93
94	2024-09-29	2024-11-29	3.49	19.99	94
95	2025-06-27	2025-09-11	49.99	2.29	95
96	2025-06-08	2025-04-13	99.99	34.99	96
97	2025-06-12	2025-01-06	39.99	29.99	97
98	2025-05-09	2025-07-05	2.99	399.99	98
99	2025-08-19	2025-02-20	29.99	24.99	99
100	2024-12-22	2024-12-28	2.59	119.99	100
101	2025-09-05	2025-07-26	34.99	3.49	101
102	2024-12-18	2025-02-21	39.99	39.99	102
103	2024-11-29	2025-05-03	3.69	79.99	103
104	2024-12-26	2025-06-16	29.99	0.75	104
105	2024-10-12	2025-07-03	89.99	2.79	105
106	2024-12-21	2025-03-14	79.99	2.49	106
107	2024-11-09	2025-09-01	39.99	6.99	107
108	2025-09-18	2025-02-06	19.99	12.99	108
109	2025-02-01	2025-02-21	4.99	2.99	109
110	2025-03-09	2025-01-25	12.99	3.29	110
111	2025-03-21	2025-05-30	15.99	15.99	111
112	2025-05-03	2025-01-05	2.99	79.99	112
113	2024-10-16	2025-05-16	22.99	3.99	113
114	2025-01-31	2025-03-18	34.99	29.99	114
115	2025-05-12	2025-04-04	6.99	15.49	115
116	2025-07-28	2025-02-21	4.19	3.99	116
117	2025-08-22	2025-07-28	3.49	39.99	117
118	2024-10-23	2025-05-17	19.99	29.99	118
119	2025-06-25	2025-03-16	1.89	44.99	119
120	2025-03-08	2025-09-01	6.99	5.99	120
121	2025-06-28	2025-08-26	3.49	4.99	121
122	2025-09-23	2025-01-23	39.99	2.79	122
123	2025-06-06	2025-02-24	34.99	14.99	123
124	2024-12-30	2025-04-24	4.99	39.99	124
125	2025-05-07	2024-12-01	4.99	3.50	125
126	2025-04-05	2025-07-08	69.99	2.49	126
127	2025-04-01	2024-12-31	29.99	89.99	127
128	2025-05-29	2024-11-12	9.99	29.99	128
129	2025-04-05	2025-02-17	59.99	29.99	129
130	2024-11-20	2025-08-26	34.99	12.99	130
131	2025-07-27	2025-07-31	3.29	39.99	131
132	2025-01-02	2024-10-01	22.99	19.99	132
133	2025-06-17	2024-11-07	2.29	169.99	133
134	2025-01-24	2025-06-18	19.99	169.99	134
135	2024-10-27	2024-10-31	99.99	89.99	135
136	2025-01-11	2024-11-19	39.99	89.99	136
137	2024-11-27	2025-09-20	4.99	59.99	137
138	2025-02-06	2025-02-22	2.99	8.99	138
139	2025-07-14	2025-02-05	34.99	3.49	139
140	2025-03-11	2025-01-24	10.99	3.99	140
141	2024-11-07	2025-08-03	3.49	3.99	141
142	2025-03-29	2025-03-02	3.49	10.99	142
143	2025-01-09	2025-08-23	24.99	4.99	143
144	2025-02-07	2025-05-26	14.99	2.49	144
145	2025-07-12	2025-01-31	2.29	22.99	145
146	2025-08-01	2025-01-25	5.49	28.99	146
147	2025-03-30	2024-11-20	24.99	3.99	147
148	2025-04-16	2025-07-04	2.99	3.29	148
149	2025-05-19	2025-03-24	3.99	29.99	149
150	2024-12-07	2025-09-23	34.99	3.69	150
151	2025-03-31	2025-08-03	2.49	22.99	151
152	2025-03-02	2025-06-11	14.99	25.99	152
153	2024-10-05	2025-01-19	8.49	10.99	153
154	2025-01-09	2025-09-08	34.99	5.49	154
155	2025-07-19	2024-12-08	39.99	2.69	155
156	2025-01-16	2025-08-11	39.99	49.99	156
157	2025-06-17	2025-06-15	3.49	5.99	157
158	2025-05-22	2025-01-10	39.99	22.99	158
159	2025-01-19	2025-08-27	39.99	39.99	159
160	2025-08-24	2025-06-29	2.69	1.99	160
161	2024-10-17	2025-07-18	3.99	3.49	161
162	2025-03-06	2024-12-30	3.49	19.99	162
163	2025-09-11	2025-02-12	5.99	2.99	163
164	2025-05-02	2024-10-03	3.59	29.99	164
165	2024-12-12	2024-12-11	29.99	1.39	165
166	2025-04-21	2025-02-24	12.99	29.99	166
167	2025-04-30	2025-07-05	5.79	2.99	167
168	2025-04-26	2025-07-03	199.99	29.99	168
169	2025-06-11	2025-04-20	12.99	49.99	169
170	2024-12-08	2025-09-13	3.89	2.29	170
171	2025-04-15	2025-04-30	2.99	34.99	171
172	2025-02-14	2025-05-07	44.99	9.99	172
173	2024-10-20	2025-09-14	1.99	79.99	173
174	2025-06-06	2025-09-23	34.99	2.49	174
175	2025-05-17	2025-06-16	3.50	3.29	175
176	2025-09-14	2025-04-27	129.99	4.99	176
177	2024-12-28	2024-11-30	39.99	12.99	177
178	2025-09-14	2025-04-18	29.99	3.99	178
179	2025-03-31	2025-08-17	39.99	19.99	179
180	2024-12-22	2025-07-28	19.99	45.99	180
181	2025-08-01	2024-12-07	39.99	3.79	181
182	2024-10-28	2024-12-09	29.99	3.79	182
183	2025-01-23	2025-04-28	49.99	12.99	183
184	2025-02-15	2025-06-25	29.99	2.49	184
185	2024-10-29	2024-10-23	39.99	22.99	185
186	2025-08-25	2025-05-18	39.99	59.99	186
187	2025-02-18	2025-08-15	22.00	4.89	187
188	2025-04-07	2025-05-16	39.99	59.99	188
189	2025-07-05	2025-01-17	23.99	44.99	189
190	2025-02-24	2025-07-28	3.89	8.99	190
191	2024-10-26	2025-05-15	19.99	2.49	191
192	2024-11-16	2025-03-23	2.49	2.99	192
193	2025-01-20	2025-06-05	39.99	1.29	193
194	2024-10-12	2024-11-02	24.99	19.99	194
195	2024-11-15	2025-01-14	4.99	2.99	195
196	2025-03-04	2025-07-11	2.99	3.29	196
197	2025-07-08	2024-11-13	3.50	8.99	197
198	2025-01-05	2024-10-22	4.19	99.99	198
199	2025-04-25	2025-06-27	5.99	39.99	199
200	2025-04-21	2025-09-05	19.99	39.99	200
201	2025-02-20	2024-10-30	3.79	39.99	201
202	2025-07-10	2025-08-19	29.99	4.99	202
203	2025-02-11	2025-05-10	34.99	1.29	203
204	2025-08-22	2024-10-01	1.99	6.99	204
205	2025-09-24	2025-06-05	24.99	2.49	205
206	2025-01-08	2025-07-09	1.29	1.29	206
207	2025-04-07	2025-07-01	3.79	6.49	207
208	2025-01-08	2025-07-29	2.49	29.99	208
209	2025-04-07	2025-07-17	3.49	4.99	209
210	2025-03-20	2025-05-07	5.99	1.89	210
211	2024-09-30	2024-11-14	1.99	8.49	211
212	2025-09-09	2025-07-14	3.29	5.79	212
213	2025-05-03	2024-10-25	1.99	99.99	213
214	2024-10-29	2025-02-20	59.99	3.99	214
215	2024-12-01	2025-04-30	59.99	4.79	215
216	2025-02-08	2024-11-20	3.69	49.99	216
217	2024-10-26	2025-02-01	15.99	29.99	217
218	2025-04-09	2024-10-19	5.49	19.99	218
219	2024-09-28	2025-06-26	4.99	6.99	219
220	2025-01-07	2025-09-22	69.99	3.29	220
221	2025-03-06	2025-04-29	3.99	3.99	221
222	2025-06-12	2025-02-13	25.99	6.99	222
223	2025-02-03	2025-01-14	2.49	24.99	223
224	2024-10-31	2024-10-27	39.99	59.99	224
225	2025-04-15	2025-03-31	5.29	5.99	225
226	2025-01-27	2025-09-23	19.99	7.49	226
227	2025-06-04	2025-03-24	15.99	4.79	227
228	2025-05-14	2025-06-29	1.49	3.49	228
229	2024-10-02	2025-07-11	22.99	14.99	229
230	2024-10-28	2025-08-10	22.99	54.99	230
231	2025-01-10	2025-04-03	4.29	44.99	231
232	2025-02-23	2025-07-01	29.99	2.29	232
233	2025-03-24	2025-06-29	3.79	3.49	233
234	2025-04-29	2025-02-02	39.99	249.99	234
235	2025-04-19	2025-02-26	29.99	5.99	235
236	2025-01-27	2024-12-25	4.99	79.99	236
237	2024-10-02	2025-08-01	4.29	2.99	237
238	2025-05-19	2024-11-23	24.99	3.29	238
239	2025-03-23	2025-06-23	3.49	12.99	239
240	2025-06-10	2025-09-02	2.99	39.99	240
241	2025-04-09	2025-04-23	4.99	19.99	241
242	2025-06-02	2025-08-27	2.99	2.99	242
243	2025-06-13	2024-12-03	5.49	3.59	243
244	2025-03-05	2025-09-06	6.99	3.49	244
245	2025-02-01	2024-10-09	19.99	16.99	245
246	2024-11-23	2024-11-04	29.99	14.99	246
247	2024-12-04	2025-06-02	99.99	89.99	247
248	2025-05-24	2024-12-07	1.29	25.00	248
249	2025-02-21	2025-03-18	5.99	34.99	249
250	2024-12-14	2025-06-06	15.99	14.99	250
\.


--
-- TOC entry 5452 (class 0 OID 41109)
-- Dependencies: 251
-- Data for Name: HOTEL; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."HOTEL" (id_hotel, nombre, razon_social, telefono, correo_electronico_corporativo, rfc_hotel) FROM stdin;
1	Byrann	Imelda	9874880893	ideware0@prnewswire.com	7582459458  
2	Ofilia	Edythe	3462221267	eelverston1@people.com.cn	1149860936  
3	Mercie	Ellerey	8085984433	ezack2@netscape.com	5411043786  
4	Jolene	Tommy	7351320691	tpowell3@jimdo.com	6839891356  
5	Inge	Carolann	4533263868	cabrams4@forbes.com	5206520853  
6	Renado	Ruth	8002101907	rrawstorn5@creativecommons.org	9888552430  
7	Thain	Herbert	8435133973	hreams6@eventbrite.com	8413645867  
8	Willyt	Gregory	6387818165	gmcphail7@pcworld.com	0656276983  
9	Culley	Olva	6763399819	olankham8@china.com.cn	6845785775  
10	Denna	Darsie	5046453633	dadamczewski9@oakley.com	3237391697  
11	Delila	Florina	9625019969	fbotleya@cdc.gov	8246286765  
12	Lindy	Harwell	4752047799	hdewburyb@quantcast.com	2476543179  
13	Elmira	Collin	4466694767	ckennifeckc@goo.ne.jp	8956377642  
14	Kirbee	Betteann	4326893207	bfulepd@cbsnews.com	0939374684  
15	Juli	Mireille	4964635304	mmacallane@sun.com	4814560419  
16	Cesaro	Angeli	5384116101	aaxtensf@tmall.com	9002917651  
17	Grove	Cordie	6313176709	claidlawg@google.de	1972907530  
18	Lindsay	Dennie	2713917927	dcusheh@liveinternet.ru	2773965663  
19	Sharity	Taddeusz	4564932612	trigardi@blogger.com	8548991178  
20	Corey	Penni	6934870250	pfaggej@economist.com	0563503106  
21	Hakim	Moira	1362853214	meltunek@tamu.edu	9566705107  
22	Rhody	Bernard	2027325266	bsifletl@sohu.com	8205427461  
23	Janette	Claudia	6266310439	ccrosierm@hostgator.com	1884916791  
24	Meggi	Rochell	6234217682	rharkenn@harvard.edu	1486010881  
25	Mikael	Sarene	3373080856	scorkano@prnewswire.com	0239411749  
26	Elyssa	Sherry	8871813861	srosebyp@squidoo.com	3740492341  
27	Olia	Karie	9713004035	kcomportq@etsy.com	2691882837  
28	Fawn	Edythe	1764417064	ecampaneller@unblog.fr	2604097044  
29	Wini	Reena	6393430665	rkitchensides@nifty.com	8905418805  
30	Tann	Kahlil	9233009113	kbarockt@acquirethisname.com	0813392837  
31	Ashley	Toby	6366445524	tforkanu@engadget.com	9393449147  
32	Elana	Leonore	9635357568	lkesterv@squarespace.com	9074636209  
33	Aileen	Jedd	9691007980	jchermw@ibm.com	2817132661  
34	Star	Camille	8924483038	cwalewskix@ovh.net	2387611519  
35	Tarrah	Milicent	2617089671	mpettersy@netscape.com	3066989216  
36	Cathee	Luce	9187374450	loffnerz@dropbox.com	9298402910  
37	Carl	Bev	5907685961	bteesdale10@fema.gov	1619414678  
38	Niels	Rogers	4003528596	rzettoi11@va.gov	7253614623  
39	Braden	Adey	2745948332	acourse12@infoseek.co.jp	7558335205  
40	Jessika	Ingram	3518702068	iiannazzi13@google.de	2678582035  
41	Antin	Nicolette	3224264592	nbuist14@princeton.edu	3293326374  
42	Bobbette	Imogen	3401741662	icliffe15@odnoklassniki.ru	4352957860  
43	Carmelina	Renato	9985057259	rarundel16@dyndns.org	4266999003  
44	Mile	Tremain	9411090685	trouzet17@ft.com	1841229288  
45	Gaby	Martino	7712665527	mbickerstaffe18@jiathis.com	2228426415  
46	Si	Orelie	1985866944	opoyner19@discuz.net	8697769701  
47	Janet	Frannie	3029117804	fhaydn1a@jalbum.net	1766791794  
48	Codi	Bonni	7755753692	bsconce1b@sina.com.cn	0238699609  
49	Jocelin	Erminia	2272021166	econdie1c@japanpost.jp	4500969772  
50	Hallsy	Everard	7197664500	eclare1d@indiegogo.com	2745652613  
51	Julie	Traci	2994370733	tsimononsky1e@columbia.edu	8947712485  
52	Berne	Raimundo	1964102203	rtonkin1f@icq.com	0455103739  
53	Laurie	Ulises	2044911896	uadderley1g@fastcompany.com	3767540541  
54	Zared	Lynnett	4738848278	lrichemond1h@furl.net	3547402654  
55	Kirk	Rachel	6934143892	rboleyn1i@chicagotribune.com	3882511664  
56	Erin	Sandor	7033851206	strimby1j@seesaa.net	3597073808  
57	Mel	Donn	3183789085	djeakins1k@amazon.co.jp	4509339283  
58	Laurella	Mackenzie	4056853392	mantonsson1l@kickstarter.com	6441494329  
59	Laurice	Zia	9937913177	zurpeth1m@mapquest.com	5895661556  
60	Jimmie	Joel	9013132924	jredmire1n@comcast.net	6092180529  
61	Eugenius	Law	6016964206	lpentycost1o@reddit.com	7465132835  
62	Brit	Yuri	5174745631	yklee1p@vk.com	3843353751  
63	Joellen	Hyacinthie	2534442947	hdudney1q@nps.gov	8930703259  
64	Manfred	Rayshell	9495724822	rduckers1r@vimeo.com	8876294775  
65	Madelene	Thatch	1939165586	tmoriarty1s@joomla.org	9702069122  
66	Tedie	Eileen	6933511028	eredshaw1t@dedecms.com	3712320728  
67	Aridatha	Mack	7031551695	mcaddell1u@elegantthemes.com	3871205664  
68	Scot	Marven	7866889717	mbangle1v@indiegogo.com	9265555610  
69	Olly	Evangeline	5832702398	eworvill1w@reuters.com	3104258066  
70	Crissie	Packston	1101582927	pkubczak1x@sciencedirect.com	4868934252  
71	Gretta	Si	4264837287	skobieriecki1y@lulu.com	6816267613  
72	Jillene	Elbertina	6343936494	eeilhersen1z@cdc.gov	1408603713  
73	Rosalynd	Elyssa	2574447205	eaccum20@angelfire.com	1268095192  
74	Bourke	Edy	7769000508	escriviner21@cdc.gov	2601092009  
75	Graig	Matteo	8272607591	mesh22@cnbc.com	4637856604  
76	Urson	Clayson	3342688487	cbottleson23@ted.com	0435248235  
77	Casar	Augustina	6276814906	asondon24@reverbnation.com	8144486021  
78	Claire	Bianca	6271523307	bpassy25@people.com.cn	1665098988  
79	Regen	Garnet	7918773252	gcancutt26@mysql.com	5074996880  
80	Jacklyn	Jacky	3121742758	jchampkin27@vimeo.com	7840248330  
81	Othelia	Car	1394668750	cwasselin28@over-blog.com	6805528313  
82	Buffy	Jesse	5774336556	jyarham29@prnewswire.com	5260311728  
83	Ruby	Shir	6112637014	sbaxendale2a@kickstarter.com	6642307011  
84	Ches	Zared	8685685883	zbamsey2b@prnewswire.com	8537198455  
85	Saul	Nancy	3323269234	nrubra2c@so-net.ne.jp	4168735036  
86	Onfroi	Felicity	4332563968	fesparza2d@bloomberg.com	9827296035  
87	Lucine	Caesar	2545961561	cgrabham2e@economist.com	0857345141  
88	Cloris	Doug	9728737952	dmutlow2f@blog.com	5127873729  
89	Issie	Foster	5892867651	flafaye2g@cpanel.net	4437457633  
90	Tracey	Issy	1645895512	ielson2h@columbia.edu	1205904158  
91	Dulcine	Archambault	9702130080	ahallowes2i@gizmodo.com	7728037307  
92	Arly	Arney	7645344355	atrundler2j@privacy.gov.au	7913496282  
93	Adham	Reed	4677817581	rdorow2k@mapquest.com	6055129299  
94	Gladi	Anneliese	2554322225	akeyte2l@nba.com	9709070045  
95	Brenn	Cathyleen	7349953297	cdesforges2m@nymag.com	3894527676  
96	Alasdair	Bud	2405236743	blowseley2n@e-recht24.de	8873209998  
97	Rivy	Dev	8242008932	dperrot2o@1und1.de	9264822666  
98	Em	Arvy	5998331737	abullick2p@bravesites.com	0937046493  
99	Norrie	Pia	6542883516	pbeevor2q@irs.gov	9700249778  
100	Rhys	Kale	8179045643	kcleever2r@google.com.br	9542784333  
101	Hurley	Terrance	5064304420	tdeware2s@angelfire.com	0198909497  
102	Bobbette	Siouxie	9636230456	sprahm2t@elegantthemes.com	3955040569  
103	Myrtie	Packston	3077937541	pmammatt2u@tinypic.com	6084452108  
104	Ulrica	Allison	5076323819	avernazza2v@mail.ru	2736839005  
105	Esther	Velvet	8828836251	vmaddick2w@live.com	8732795270  
106	Rutter	Tull	3661489165	tfossord2x@cnbc.com	1756827699  
107	Sarena	Lorri	8232718869	ldurrance2y@theatlantic.com	7280570585  
108	Malva	Dolley	7527698471	dormrod2z@wp.com	5690089834  
109	Enrika	Jake	6897194269	jlyfield30@amazon.com	5684152198  
110	Belicia	Chandal	6562009797	cchristaeas31@answers.com	7489934443  
111	Tabbatha	Maribel	8345961045	mrudgard32@miibeian.gov.cn	6455003004  
112	Constantino	Fairleigh	3973661307	fgyurkovics33@opensource.org	6997394515  
113	Thor	Byrle	2182858396	bnathon34@vkontakte.ru	7068364020  
114	Molli	Bernie	1853440692	bstephenson35@youtube.com	0314403140  
115	Bertrand	Thomas	3832478697	tmoney36@bravesites.com	7950505745  
116	Verena	Alexandre	1347014889	abottomley37@gov.uk	1974828182  
117	Fredek	Lynne	8916343570	lmullaney38@china.com.cn	2343975949  
118	Eleanora	Karlik	1567937578	kyukhnevich39@naver.com	9685960666  
119	Hobard	Rayna	6913369214	rbenaine3a@ucla.edu	7616390315  
120	Eb	Ivor	9869703774	ihigounet3b@wsj.com	5095666944  
121	Ally	Marlena	7042955373	mbiesinger3c@dedecms.com	9401987033  
122	Bran	Layla	3911112759	ldymock3d@dagondesign.com	0980695473  
123	Townie	Hurlee	7015271890	hfurse3e@blinklist.com	7026109510  
124	Jerrold	Ulrika	7741559265	ukrabbe3f@examiner.com	3747284809  
125	Artie	Deonne	7825591808	dgoodnow3g@earthlink.net	2027265066  
126	Major	Mirelle	4793211332	mcarey3h@printfriendly.com	3161697332  
127	Aurore	Laurie	3207016525	lpadrick3i@behance.net	5466672777  
128	Page	Augustine	2481506399	ahalbeard3j@loc.gov	1218165022  
129	Waylan	Tarrah	3467047506	tpanks3k@e-recht24.de	3427496287  
130	Phylys	Jefferey	9051580319	jheaps3l@de.vu	3752475013  
131	Gwenny	Krishna	4329470219	kmartignoni3m@nba.com	5391594472  
132	Kacie	Myrwyn	8547021455	mfantin3n@icq.com	0779988736  
133	Cristie	Linet	7236957038	lpourveer3o@sciencedaily.com	5109582505  
134	Marya	Ozzie	1322576789	oadame3p@icq.com	2617701557  
135	Filbert	Kylen	6823795668	kfyldes3q@npr.org	8761779911  
136	Vonny	Claude	5255650334	csherr3r@stanford.edu	6936521436  
137	Allyn	Eva	7277464339	eedghinn3s@google.com.au	4611576426  
138	Retha	Win	6585217222	wpyzer3t@merriam-webster.com	7651638654  
139	Emmett	Katinka	7068885767	kamsden3u@delicious.com	3687935507  
140	Maisey	Nathan	8564672703	nbridie3v@i2i.jp	1728205344  
141	Gaylor	Randie	5985894532	rshelsher3w@taobao.com	5971936646  
142	Hunfredo	Spence	9653529419	schin3x@nih.gov	5932568526  
143	Paolina	Wilie	8216522963	wgottelier3y@yahoo.com	7123714431  
144	Orlando	Garrett	8534217488	geverwin3z@google.ca	9460636594  
145	Clyde	Anni	7694403727	aledgley40@wordpress.org	1536708348  
146	Edmon	Mirelle	7824928596	mfryman41@tinypic.com	0601239164  
147	Reba	Kristofer	6525585822	kduligall42@gnu.org	8137849890  
148	Sherill	Fifi	7819359243	flapish43@bigcartel.com	3969010004  
149	Ashton	Chandler	2054895679	cburdell44@wired.com	7023886664  
150	Cinnamon	Felita	7266166950	fvarey45@washington.edu	2920126326  
151	Bruno	Virgie	7007958465	vbillingsly46@unc.edu	7070137362  
152	Filip	Oates	7739040888	oledamun47@amazonaws.com	8722997989  
153	Harris	Mart	9596833938	medgcombe48@123-reg.co.uk	2888767546  
154	Sherill	Temp	5165975904	tbirch49@nydailynews.com	3395739066  
155	Rosabelle	Virgil	1134124801	vsangar4a@go.com	9459513832  
156	Millie	Walther	8935612850	wpranger4b@infoseek.co.jp	5221471655  
157	Morna	Nedi	1867922410	nbellamy4c@adobe.com	4838186355  
158	Nanni	Cosette	4645219622	ctreharne4d@yahoo.com	9243625691  
159	Saunder	Abagael	5776753953	afadden4e@europa.eu	2049501978  
160	Elane	Manny	4722161449	merickssen4f@nasa.gov	5652480009  
161	Tammara	Ricky	1554034149	rcalyton4g@so-net.ne.jp	4513831413  
162	Lief	Catlin	4669318022	cgonnard4h@elpais.com	6354799083  
163	Baldwin	Augustine	9429972755	adjurisic4i@yellowbook.com	4535539154  
164	Hamnet	Trenton	2433595003	treily4j@salon.com	9616361147  
165	Evita	Nathalie	4671977311	ngeard4k@surveymonkey.com	6667730740  
166	Adore	Richy	4268830619	rdami4l@independent.co.uk	8332306337  
167	Starlin	Byrom	8191382713	bfigg4m@smugmug.com	3467192483  
168	Ros	Farr	3613999658	fbrouard4n@vk.com	5253033238  
169	Ode	Rikki	7168240399	ralthrope4o@reverbnation.com	0058969667  
170	Elbertine	Mitchael	3404757050	mjakeman4p@house.gov	9603824534  
171	Maurizia	Gigi	2107708215	gdiloway4q@rediff.com	1299807070  
172	Tait	Marion	5546816806	mbastian4r@nymag.com	9322430923  
173	Rebekkah	Ofelia	6284151609	oskamell4s@bigcartel.com	3426948265  
174	Junie	Rene	3491685965	rmcgonigal4t@wikipedia.org	4863832400  
175	Bronny	Deane	7827797816	dmattiato4u@geocities.com	8042381468  
176	Ricki	Garnette	5037885525	gemblin4v@rambler.ru	1824772742  
177	Dena	Carissa	1749596625	cgiurio4w@un.org	1587630753  
178	Morrie	Viki	4683210709	vnyssen4x@mashable.com	2532707518  
179	Faun	Corilla	7781531046	cplester4y@dailymail.co.uk	1499702450  
180	Beitris	Nollie	7423279404	nchallis4z@house.gov	1246974576  
181	Gerrie	Junie	3197886535	jwinward50@symantec.com	5123568603  
182	Lenka	Sharline	3992733493	struckett51@spiegel.de	2825982679  
183	Edgard	Alberik	2607187614	akirkhouse52@example.com	7574999600  
184	Charmane	Tabby	6108663677	tpolack53@washingtonpost.com	1594211124  
185	Lyon	Elga	8256361738	ejoseff54@ihg.com	2937002129  
186	Laurice	Cheston	9293161993	cdaldan55@myspace.com	1704029155  
187	Donnie	Cissy	8272819540	cgovini56@irs.gov	3385180767  
188	Cinderella	Georgy	1479032303	gdubois57@nbcnews.com	6399989906  
189	Carolynn	Alfie	2452324755	aairs58@mac.com	0521807492  
190	Mikol	Jarrad	8813681957	jadamovicz59@cdbaby.com	8089300944  
191	Kurt	Adele	8018160335	apugh5a@chron.com	7362578385  
192	Janice	Min	9586614829	melliss5b@archive.org	1779285469  
193	Towny	Cherie	1566146494	ccranstoun5c@europa.eu	0281844003  
194	Cleavland	Vyky	5477727889	vrablan5d@tiny.cc	6189241204  
195	Adah	Sonnnie	3561513926	sbicker5e@shop-pro.jp	3667382588  
196	Gabe	Hammad	6407050685	hwreath5f@msu.edu	8941027861  
197	Thorin	Brittne	9706106837	bchuter5g@dell.com	7278444772  
198	Lenci	Bearnard	7344280981	bfrancescuccio5h@cdc.gov	1963208226  
199	Lowell	Linnea	3491252870	lscouller5i@whitehouse.gov	8480543663  
200	Jerrine	Michaeline	8747001681	malvin5j@ftc.gov	1345671180  
201	Lenore	Bronson	2872069700	bisabell5k@europa.eu	8682361906  
202	Lucien	Katie	7549648668	kmeers5l@instagram.com	4754172787  
203	Caron	Angeli	5793804088	agillani5m@sina.com.cn	7490494486  
204	Karlotte	Kevyn	1444873000	kbenoist5n@marketwatch.com	2026684596  
205	Brianna	Ramsay	3974479372	rwarrick5o@taobao.com	1539000370  
206	Evyn	Virginie	1383790784	vgeldard5p@mozilla.com	1946590711  
207	Teressa	Carry	9792966528	cgemmell5q@unesco.org	5689924814  
208	Tye	Tudor	9971988174	tbeedham5r@exblog.jp	0828673098  
209	Evita	Faber	4679787530	fpattingson5s@blogger.com	8655381136  
210	Jarid	Romy	3264418112	rshearston5t@amazon.de	1154992985  
211	Adi	Hali	7474701466	hruzek5u@ft.com	7783334679  
212	Astrix	Mandie	7641392612	mmower5v@ebay.com	9122445110  
213	Malynda	Dasie	6129787982	dkohler5w@sohu.com	1539557731  
214	Herculie	Merridie	9539340439	mbartley5x@photobucket.com	4783255962  
215	Lowell	Falkner	8935426221	fshimwell5y@furl.net	7630497385  
216	Calla	Dell	7975652937	dhinchshaw5z@gmpg.org	6465160439  
217	Briggs	Ninnetta	3268459698	npietz60@businessweek.com	7810505572  
218	Felicio	Mella	6069901461	mbisterfeld61@typepad.com	8504460835  
219	Eda	Libbi	4779114767	lvarsey62@dagondesign.com	5149120634  
220	Michel	Hurleigh	6628800946	hnewens63@hexun.com	0623387034  
221	Emelita	Renault	4576992616	rslemming64@msn.com	4232273131  
222	Morey	Nadine	9523176653	nfrascone65@state.gov	5209582965  
223	Kari	Malinda	1758737229	mkosiada66@fastcompany.com	6687657496  
224	Alexina	Kathy	5306086576	kambridge67@topsy.com	2340966531  
225	Kriste	Bryanty	2451566003	brobardet68@redcross.org	3527780084  
226	Otes	Verene	3016825159	vmandal69@google.es	1242094148  
227	Tobit	Roberto	9133496932	rsarfatti6a@upenn.edu	6488851063  
228	Shurlocke	Marmaduke	5204902010	mbeddingham6b@si.edu	2523088320  
229	Renault	Douglas	8646231855	dorteaux6c@opensource.org	0994278888  
230	Wittie	Laverne	6769841024	lnani6d@squarespace.com	5981444495  
231	Devland	Bethany	2713683201	bdishman6e@studiopress.com	2488977187  
232	Yorker	Nerte	8411385097	nsollas6f@example.com	6240499757  
233	Garrot	Mylo	4986185766	mskrines6g@dion.ne.jp	8924022431  
234	Tera	Vaclav	6929503338	vmohring6h@bravesites.com	3331631264  
235	Hebert	Eben	5436154227	eailward6i@time.com	2292668629  
236	Nydia	Stearne	2362304535	sfritzer6j@dagondesign.com	6253422634  
237	Helsa	Jorrie	8333408749	jselcraig6k@usatoday.com	3846662488  
238	Alejandra	Rossie	3575298651	rfarre6l@linkedin.com	6152699916  
239	Liz	Antony	3894635196	abasford6m@wikia.com	7809204971  
240	Fredrika	Conney	5484264161	cjanman6n@free.fr	4269318821  
241	Page	Aubree	8081048408	abuckenhill6o@cbsnews.com	5702004310  
242	Emelyne	Jacinthe	7056339026	jabeles6p@vk.com	9927840934  
243	Marcos	Nan	4794648628	nlambeth6q@ucsd.edu	2478903822  
244	Tabby	Bernetta	2421606193	bbattman6r@stanford.edu	1735276332  
245	Maynard	Dorella	9296001755	dpoleye6s@archive.org	4548216413  
246	Karolina	Chiquita	2028192204	cbarkly6t@wordpress.org	3407870582  
247	Randell	Calv	4328870117	cwingate6u@nytimes.com	7431515049  
248	Marietta	Colene	6728712524	cpipping6v@blogger.com	5854479249  
249	Tabbatha	Gweneth	6129040331	gpechold6w@who.int	2865326098  
250	Johann	Karola	4465894849	kforson6x@domainmarket.com	0937354902  
\.


--
-- TOC entry 5453 (class 0 OID 41112)
-- Dependencies: 252
-- Data for Name: INSUMOS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."INSUMOS" (id_insumos, nombre, unidad, costo) FROM stdin;
1	33	50	78.00
2	13	87	74.00
3	45	52	97.00
4	20	54	69.00
5	48	98	52.00
6	30	98	42.00
7	13	83	98.00
8	8	50	28.00
9	13	31	30.00
10	33	87	45.00
11	21	51	26.00
12	10	61	41.00
13	23	41	30.00
14	8	60	62.00
15	3	51	80.00
16	3	70	15.00
17	4	59	89.00
18	38	100	28.00
19	21	61	61.00
20	34	75	75.00
21	8	76	60.00
22	19	85	89.00
23	33	68	84.00
24	30	93	50.00
25	45	57	47.00
26	34	50	61.00
27	22	79	64.00
28	9	72	62.00
29	30	85	65.00
30	18	79	53.00
31	38	83	49.00
32	11	66	37.00
33	10	94	20.00
34	19	58	92.00
35	19	96	61.00
36	29	55	33.00
37	44	62	67.00
38	46	49	94.00
39	36	54	32.00
40	47	84	94.00
41	47	61	41.00
42	48	89	95.00
43	37	67	62.00
44	45	31	78.00
45	39	48	59.00
46	12	60	20.00
47	14	53	97.00
48	20	71	43.00
49	9	94	46.00
50	19	41	36.00
51	41	50	56.00
52	39	74	12.00
53	18	39	46.00
54	28	90	95.00
55	39	98	78.00
56	34	42	81.00
57	4	79	33.00
58	34	84	96.00
59	12	96	35.00
60	47	68	43.00
61	28	89	59.00
62	21	44	94.00
63	15	40	44.00
64	8	83	67.00
65	40	76	96.00
66	18	41	32.00
67	44	87	59.00
68	13	72	81.00
69	34	58	24.00
70	10	61	21.00
71	5	96	21.00
72	7	60	10.00
73	48	51	81.00
74	25	66	22.00
75	14	32	40.00
76	27	97	55.00
77	47	36	74.00
78	45	49	79.00
79	35	46	98.00
80	19	64	48.00
81	40	53	77.00
82	12	30	67.00
83	48	74	61.00
84	28	54	88.00
85	14	49	42.00
86	38	58	33.00
87	39	41	80.00
88	34	94	40.00
89	33	67	10.00
90	46	65	26.00
91	24	59	62.00
92	28	91	10.00
93	18	68	28.00
94	39	91	52.00
95	19	48	27.00
96	5	72	87.00
97	45	37	24.00
98	18	52	36.00
99	44	64	94.00
100	26	48	88.00
101	37	48	43.00
102	10	79	33.00
103	7	55	46.00
104	32	64	65.00
105	26	95	20.00
106	24	38	59.00
107	46	78	33.00
108	27	71	81.00
109	27	59	28.00
110	14	93	19.00
111	4	32	59.00
112	19	78	55.00
113	32	92	56.00
114	22	92	91.00
115	15	92	75.00
116	31	44	11.00
117	15	47	57.00
118	42	39	89.00
119	44	97	37.00
120	29	88	59.00
121	25	31	12.00
122	23	41	60.00
123	29	76	86.00
124	10	34	46.00
125	41	36	26.00
126	10	81	61.00
127	11	47	56.00
128	18	74	31.00
129	30	33	14.00
130	34	87	16.00
131	3	49	30.00
132	23	57	38.00
133	41	48	56.00
134	9	67	10.00
135	13	80	16.00
136	5	44	93.00
137	36	37	90.00
138	18	73	39.00
139	40	48	81.00
140	35	44	93.00
141	50	73	30.00
142	19	66	39.00
143	18	70	51.00
144	43	41	44.00
145	50	35	85.00
146	46	61	81.00
147	22	100	46.00
148	27	53	57.00
149	42	52	49.00
150	31	64	89.00
151	14	68	87.00
152	46	98	28.00
153	22	49	93.00
154	19	72	97.00
155	30	93	93.00
156	19	54	85.00
157	16	45	83.00
158	5	82	37.00
159	41	70	27.00
160	22	70	95.00
161	31	43	41.00
162	11	72	37.00
163	29	84	43.00
164	4	79	56.00
165	4	31	60.00
166	49	63	82.00
167	24	35	71.00
168	30	65	33.00
169	31	53	35.00
170	16	98	88.00
171	7	96	10.00
172	31	51	28.00
173	3	98	45.00
174	49	76	84.00
175	20	48	84.00
176	30	33	15.00
177	19	61	90.00
178	11	88	49.00
179	6	84	27.00
180	30	36	17.00
181	31	64	67.00
182	10	78	69.00
183	35	81	77.00
184	29	72	49.00
185	21	70	28.00
186	24	45	37.00
187	49	88	79.00
188	28	37	14.00
189	7	33	82.00
190	14	79	75.00
191	39	84	28.00
192	6	52	24.00
193	45	98	79.00
194	45	97	86.00
195	19	70	41.00
196	29	77	61.00
197	30	50	36.00
198	21	89	60.00
199	38	70	18.00
200	23	88	40.00
201	13	47	85.00
202	15	86	67.00
203	10	78	66.00
204	24	71	60.00
205	50	48	77.00
206	11	55	47.00
207	22	56	61.00
208	7	35	18.00
209	50	59	72.00
210	15	31	10.00
211	44	62	33.00
212	46	93	66.00
213	26	57	90.00
214	8	44	85.00
215	40	64	12.00
216	32	50	80.00
217	29	59	64.00
218	33	94	20.00
219	7	64	37.00
220	34	68	15.00
221	34	45	24.00
222	30	30	19.00
223	42	56	98.00
224	11	68	78.00
225	20	32	64.00
226	48	54	71.00
227	32	56	35.00
228	41	68	25.00
229	48	59	51.00
230	20	82	29.00
231	49	100	49.00
232	27	31	60.00
233	40	47	76.00
234	39	34	50.00
235	35	96	31.00
236	40	92	16.00
237	12	65	77.00
238	37	33	26.00
239	11	63	90.00
240	25	84	58.00
241	11	50	16.00
242	40	86	92.00
243	15	53	49.00
244	44	72	82.00
245	14	44	80.00
246	12	81	56.00
247	45	43	42.00
248	19	62	96.00
249	42	95	46.00
250	32	82	56.00
\.


--
-- TOC entry 5454 (class 0 OID 41115)
-- Dependencies: 253
-- Data for Name: INVENTARIO_HABITACION; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."INVENTARIO_HABITACION" (id_inventario_habitacion, nombre_item, estado, descripcion, cantidad, numero_habitacion, ultima_revision) FROM stdin;
1	Fatz	KY	Portable fire pit for backyard gatherings.	12	1	2025-01-29
2	Plambee	LA	Manual pasta maker for creating fresh pasta at home.	39	2	2025-08-10
3	Gigashots	GA	Decorative table runner perfect for autumn gatherings.	14	3	2025-03-15
4	Fiveclub	NY	Safety vest for pets during nighttime walks.	17	4	2024-11-24
5	Gabcube	NY	Spicy and tangy chili sauce for adding heat to any dish.	8	5	2025-01-29
6	Oyope	TN	Space-saving adjustable dumbbells for strength training.	14	6	2025-01-06
7	Livetube	NY	Rich tart filled with chocolate and raspberry, a gourmet dessert.	10	7	2025-02-26
8	Twiyo	WY	Stackable containers for organizing snacks and treats.	29	8	2024-12-26
9	Avamba	AR	Tempered glass screen protector for smartphones.	31	9	2025-07-13
10	Fadeo	TX	Organize your board games with this storage bin.	29	10	2025-03-18
11	Twitterworks	LA	Assorted indoor plants for home decor.	7	11	2025-02-24
12	Youbridge	NY	Float through the day in this beautiful floor-length skirt.	24	12	2025-06-12
13	Edgeclub	IN	Crunchy and nutritious almonds, perfect for snacking.	27	13	2025-03-12
14	Brightbean	NY	Upgrade your phone photography with this lens kit that includes wide-angle and macro lenses.	5	14	2025-08-05
15	Skaboo	IL	Control lights remotely with this smart switch.	24	15	2025-05-15
16	Fivechat	IL	Marinated chicken skewers with lemon and dill flavor, grilled to perfection.	40	16	2024-11-02
17	Ailane	SC	Tangy goat cheese infused with herbs, perfect for snacking.	12	17	2025-06-24
18	Divanoodle	NY	Essential cotton tank top, perfect for layering.	25	18	2025-02-19
19	Realblab	PA	No-bake protein balls with chocolate and coconut flavors.	22	19	2025-03-19
20	DabZ	NM	Durable cover to protect your grill from the elements.	32	20	2025-09-27
21	Rhybox	OK	Lightweight and durable hammock for relaxing in nature.	19	21	2024-11-11
22	Kayveo	CT	Traditional Korean fermented vegetables, packed with flavor.	21	22	2024-11-26
23	Yoveo	FL	Fresh organic blueberries perfect for snacking or baking.	19	23	2025-06-10
24	Cogibox	PA	Pancake mix infused with seasonal pumpkin spice flavor.	37	24	2024-10-19
25	Zoombox	TX	Elegant midi skirt with a wrap design, great for both formal and casual events.	33	25	2025-07-07
26	Gigaclub	CA	A flavorful blend of rice with tropical pineapple and coconut flavors.	17	26	2025-02-24
27	Quire	TX	Creative building set for kids to spark imagination.	7	27	2025-01-04
28	Shuffledrive	TX	Adjustable LED desk light with brightness settings.	18	28	2025-08-04
29	Dabshots	NV	Refreshing tea with honey and lemon flavor, perfect for a warm drink.	28	29	2025-06-06
30	Wikibox	MI	Extra soft electric blanket with adjustable heat settings.	9	30	2025-03-08
31	Jaxnation	CA	Savory oatmeal ready to eat, great for breakfast or a snack.	30	31	2025-04-06
32	Tazzy	CT	Durable backpack for hiking or travel.	8	32	2024-11-21
33	Tagcat	PA	Creamy dessert made with rice and cinnamon.	7	33	2025-02-06
34	Mydeo	VA	Bluetooth scale that tracks body composition through an app.	25	34	2024-12-28
35	Edgepulse	MO	Water-resistant Bluetooth speaker for showers.	28	35	2025-05-10
36	Jabbertype	TX	Lightweight and durable hammock for relaxing in nature.	10	36	2025-03-06
37	Avamba	FL	Tangy whole grain mustard for sandwiches and dressings.	24	37	2024-10-18
38	Meetz	FL	Classic wooden train set for imaginative play.	18	38	2025-06-05
39	Youopia	NY	Pancake mix infused with seasonal pumpkin spice flavor.	20	39	2025-08-15
40	Flipbug	MN	Reusable silicone lids for covering food in bowls and storage containers.	20	40	2025-03-26
41	Flashspan	PA	Refreshing sparkling water infused with cranberry and lime flavors.	20	41	2025-08-24
42	Yodoo	TX	Indoor Wi-Fi camera for home security.	29	42	2025-03-19
43	Reallinks	IL	Comfortable gaming chair for long hours of play.	23	43	2024-11-14
44	Youspan	IN	Eco-friendly electric bike with a 30-mile range.	38	44	2025-05-24
45	Brightdog	OH	Creamy hummus with a kick of spice, great for dipping.	36	45	2024-12-21
46	Tagopia	PR	Expandable caddy for holding books, phones, and snacks while in the bath.	37	46	2025-01-28
47	Avavee	SC	Fresh thyme, perfect for seasoning dishes.	5	47	2024-10-15
48	Blogtags	FL	All-in-one tool for measuring soil moisture, light, and pH.	19	48	2025-03-21
49	Dazzlesphere	AR	Advanced wristband that tracks daily activities and sleep.	13	49	2025-09-06
50	Dazzlesphere	CO	Mini refrigerator ideal for small spaces.	13	50	2024-12-26
51	Lazz	PA	Polarized sunglasses with UV protection.	14	51	2025-05-12
52	Brightdog	NC	Fresh greens and veggies for a quick Asian-inspired salad.	14	52	2024-11-09
53	Muxo	NC	Multiple USB ports for charging devices simultaneously.	20	53	2025-07-14
54	Dynabox	NC	A rich marinade perfect for meats and vegetables, infused with Italian herbs and balsamic vinegar.	35	54	2025-02-27
55	Avamm	IN	Soft and fluffy whole wheat pita bread, great for wraps.	34	55	2025-09-25
56	Twiyo	MD	Nutty flavored lentils, perfect for soups and salads.	32	56	2025-06-17
57	Lazzy	WV	Complete set of gardening tools for all your needs.	24	57	2025-07-18
58	Flashset	OR	Versatile multi-cooker for pressure cooking and slow cooking.	28	58	2025-09-25
59	Feednation	GA	Wireless headphones with noise-canceling features.	31	59	2025-04-23
60	Quimm	OH	Canned pumpkin puree, perfect for pies and soups.	17	60	2025-03-14
61	Buzzdog	FL	Adjustable stand for smartphones and tablets.	17	61	2025-08-13
62	Lazz	LA	Refreshing dessert bars made with pineapple and coconut.	24	62	2024-10-03
63	Dabtype	CO	Hearty chili made with premium ground beef and kidney beans.	6	63	2025-08-17
64	Riffpedia	LA	Fresh basil pesto, perfect for pasta or as a sandwich spread.	25	64	2024-11-24
65	Fadeo	TN	Convenient water bottle for pets on the go.	31	65	2024-12-15
66	Zoovu	GA	Delicious ravioli filled with creamy ricotta and fresh spinach.	9	66	2025-05-14
67	Gigazoom	OH	Delicious dark chocolate cups filled with creamy peanut butter.	33	67	2025-03-25
68	Feedspan	AR	Durable jump rope for cardio workouts.	21	68	2024-11-20
69	Tagopia	TX	Durable gloves with built-in claws for digging and planting.	16	69	2025-05-10
70	Kwilith	IA	Manual pasta maker for homemade pasta.	30	70	2025-03-27
71	Ailane	NY	Fresh mango salsa with a hint of lime for a zesty topping.	15	71	2025-02-07
72	Blogtag	NC	Fresh mango salsa with a hint of lime for a zesty topping.	32	72	2025-01-02
73	Kwinu	OH	Color-changing LED lights for home decoration with remote.	19	73	2025-09-09
74	Mymm	NH	Complete set for garden care with a handy carrying bag.	35	74	2025-02-10
75	Twimbo	MD	Instant hot water dispenser for tea and cooking.	23	75	2025-05-02
76	Oyoba	TX	Memory foam travel pillow for neck support.	22	76	2024-11-29
77	Bluezoom	TN	Ergonomic desk that adjusts height for standing or sitting.	39	77	2025-06-28
78	Fliptune	CA	A delicious tart filled with fresh raspberry filling.	9	78	2025-05-28
79	Photobean	MA	Compact wireless printer for home use.	24	79	2025-08-04
80	Oyope	NY	Spicy salsa made with black beans and tomatoes.	13	80	2025-08-29
81	Geba	WA	A tangy sauce made with cranberries and citrus zest, perfect for turkey and chicken dishes.	35	81	2025-01-25
82	Oozz	VA	Designed for comfort and performance during workouts.	25	82	2025-04-11
83	Quamba	PA	Set of stylish watch bands to customize your look.	20	83	2025-05-26
84	Brainbox	PR	Quick oatmeal cups with banana and nut flavor, great for breakfast.	7	84	2025-09-06
85	Tagcat	TX	A smoky barbecue sauce, ideal for grilling and dipping.	9	85	2025-01-30
86	Brightbean	MS	Creamy hummus with a kick of spice, great for dipping.	31	86	2025-08-25
87	Blogtag	NE	Creamy dip made with caramelized onions, perfect for chips or veggies.	18	87	2025-01-25
88	Wikido	FL	Ziti pasta baked with marinara and parmesan cheese	5	88	2025-01-26
89	Quinu	MI	Assorted indoor plants for home decor.	30	89	2025-08-13
90	Npath	WI	Instant oatmeal cups with blueberries for an easy breakfast.	39	90	2025-08-18
91	Zoomlounge	NE	Instant oatmeal cups with blueberries for an easy breakfast.	33	91	2025-06-28
92	Trunyx	FL	Convenient magnetic jars for easy spice storage.	24	92	2024-11-18
93	Brainsphere	IL	Crunchy granola with almonds and coconut.	23	93	2025-03-05
94	Mydeo	AE	Bluetooth scale that tracks body composition through an app.	29	94	2024-11-14
95	Jetpulse	MO	Universal mount for smartphones on motorcycles.	30	95	2024-11-24
96	Jetpulse	IN	Compact hand mixer for easy baking.	14	96	2024-10-11
97	Realcube	NY	Plain white rice, a staple for any meal.	17	97	2025-06-15
98	Meezzy	FL	Energy-efficient LED bulbs that can be controlled via smartphone.	16	98	2025-06-26
99	Brainbox	FL	Colorful LED strip lights for home decoration.	36	99	2024-10-20
100	Livefish	GA	Flavored aioli made with roasted garlic	16	100	2025-08-16
101	Tavu	TN	A mix of strawberries, blueberries, and raspberries.	31	101	2025-04-30
102	Kwilith	MI	Crispy breadsticks seasoned with herbs and garlic.	7	102	2025-02-02
103	Yambee	OH	A blend of nuts, seeds, and dried fruits for snacking.	21	103	2025-06-07
104	Wikizz	NY	Everything you need for maintaining a healthy beard.	30	104	2024-10-24
105	Zava	MD	Classic fit blue jeans with a slight stretch for comfort and durability.	13	105	2025-07-26
106	Izio	TX	Just add water for a hearty cheese and broccoli soup in minutes.	16	106	2025-01-24
107	Muxo	VA	Crisp and sweet Honeycrisp apples, freshly picked.	24	107	2025-08-10
108	Mybuzz	MN	Sweet and chewy taffy flavored like caramel apples, great for fall.	28	108	2025-09-01
109	Teklist	PA	Sweet and tangy balsamic reduction for drizzling.	23	109	2024-11-02
110	Vimbo	PA	Scented bath salts for relaxation and self-care.	34	110	2025-06-05
111	Shuffletag	FL	Water-resistant Bluetooth speaker for showers.	5	111	2025-05-06
112	Flipopia	CA	Handheld vacuum cleaner for quick and easy cleaning.	18	112	2025-06-29
113	Ailane	MI	Lightweight water filter for outdoor adventures.	26	113	2025-02-19
114	Eazzy	CO	Spicy chili sauce for an extra kick in your meals.	23	114	2024-12-23
115	Mynte	PR	Soft cookies made with almond butter	14	115	2025-05-20
116	Fanoodle	IL	Compact and portable backpack for day trips and travel.	12	116	2025-09-15
117	Eazzy	PA	Compact and portable projector for watching videos anywhere.	36	117	2024-11-07
118	Oyoyo	KS	Safe cleaning solution and tools for electronics screens.	17	118	2025-09-10
119	Npath	OH	Tripod with wireless remote for effortless photo-taking.	24	119	2025-05-09
120	Tagchat	MI	Lightweight leaf blower for maintaining outdoor spaces.	21	120	2025-01-18
121	Viva	CA	Personalize your calendar with photos and special dates.	27	121	2024-11-23
122	Layo	MN	Eco-friendly LED lights for festive decorations.	20	122	2025-02-23
123	Skimia	MN	Creamy almond butter made from roasted almonds.	27	123	2024-11-25
124	Edgewire	GA	Crunchy pretzel sticks made with honey and whole wheat.	7	124	2024-10-18
125	Oyoba	AR	Fresh basil pesto, perfect for pasta or as a sandwich spread.	32	125	2025-03-31
126	Topiclounge	MT	Creamy cheese with a spicy kick, perfect for sandwiches.	39	126	2025-02-04
127	Leexo	FL	Light and fluffy cream cheese, perfect for bagels or cooking.	12	127	2025-01-07
128	Fivespan	NY	Lint roller designed specifically for removing pet hair from furniture.	30	128	2025-06-30
129	Oyoyo	MI	Smooth soup made from carrots and ginger, great for cold days.	34	129	2025-08-07
130	Leenti	PA	A flavorful rice side dish seasoned with herbs and spices.	9	130	2025-02-02
131	Thoughtblab	CA	Rugged phone case for drop protection.	28	131	2025-09-13
132	Kazio	FL	Durable backpack designed for hiking and outdoor excursions.	12	132	2024-11-08
133	Podcat	UT	Genuine leather wallet with multiple compartments.	18	133	2025-05-12
134	Gabtype	FL	Freshly baked bagels, perfect for breakfast or snacks.	13	134	2024-12-14
135	Tazzy	IN	Kitchen tool for tenderizing meat to enhance flavors.	12	135	2025-01-19
136	Photobug	SC	Fluffy rice cooked with coconut milk for a tropical twist.	34	136	2025-04-14
137	Gigazoom	NC	Set of stylish watch bands to customize your look.	11	137	2025-05-05
138	Tanoodle	IL	Crunchy roasted pumpkin seeds, great for snacking.	18	138	2025-06-01
139	Wikido	TN	DIY projector that magnifies your smartphone screen for movie nights.	40	139	2025-08-04
140	Eire	VA	A trendy oversized denim shirt perfect for layering.	22	140	2025-07-01
141	Voonte	IN	Perfectly designed pan for making crepes and pancakes.	6	141	2024-10-15
142	Gigashots	OH	A fluffy pancake mix infused with maple and pecans, perfect for a hearty breakfast.	40	142	2024-10-29
143	Yakidoo	NY	Intricate designs for adults to relax and unwind.	37	143	2025-04-21
144	DabZ	NJ	Multi-function pressure cooker that can sauté, steam, and slow cook.	29	144	2024-12-09
145	Layo	NC	Stylish leather ankle boots with a block heel, perfect for fall styling.	31	145	2025-01-07
146	Skipfire	ME	Extra soft electric blanket with adjustable heat settings.	10	146	2024-12-16
147	Agivu	PR	Polarized sunglasses with UV protection.	18	147	2025-01-15
148	Kwideo	CA	Chilled noodles dressed in sesame sauce, ready to eat.	6	148	2025-02-07
149	Cogilith	AR	Whole grain oats that are perfect for breakfast or baking.	17	149	2025-01-30
150	Zoonder	KY	Insulated pitcher to keep beverages cold or hot.	20	150	2025-02-28
151	Eamia	MI	Portable induction cooktop for quick heating.	22	151	2025-07-26
152	Trunyx	FL	Non-slip mat designed for yoga and fitness exercises.	6	152	2025-08-23
153	Youspan	FL	Polarized sunglasses with UV protection.	23	153	2025-09-09
154	Camimbo	MI	Creamy tahini made from ground sesame seeds.	23	154	2025-07-22
155	Tazz	MO	Creamy yogurt blended with fresh pineapple and coconut pieces.	14	155	2024-12-11
156	Thoughtworks	FL	Frozen pizza loaded with fresh vegetables and mozzarella cheese.	33	156	2025-01-27
157	Zava	PA	Unique handcrafted utensils for cooking and serving.	12	157	2024-11-27
158	Digitube	WI	Traditional basil pesto made with extra virgin olive oil.	26	158	2025-07-04
159	Fadeo	ND	All-in-one kit for making delicious chicken salad.	31	159	2025-07-25
160	Lajo	ID	Compact travel organizer for accessories and toiletries.	31	160	2024-12-31
161	Muxo	CO	Classic marinara sauce for pasta, pizza, or dipping.	21	161	2025-04-29
162	Oyope	VA	Tender jackfruit cooked in BBQ sauce, a delicious plant-based alternative.	22	162	2025-09-20
163	Gabcube	GA	Plant-based mix for a rich chocolate cake.	27	163	2025-07-22
164	Yodo	TX	Fun lunchbox for kids with a sturdy design.	28	164	2025-08-07
165	Tambee	CA	Fresh Brussels sprouts, great for roasting or steaming.	12	165	2024-10-28
166	Centizu	TX	Fun tourist magnets from around the world for your fridge.	17	166	2025-06-18
167	Gabtype	TN	Creamy and crumbly cheese for salads and dishes.	25	167	2025-07-24
168	Skipfire	IA	Layers of pasta, veggies, and cheese baked to perfection.	9	168	2024-11-03
169	Riffpath	CA	Sleek and protective sleeve for laptops and tablets.	21	169	2024-10-13
170	Teklist	CA	Fast and compact external solid state drive, 1TB.	19	170	2025-06-23
171	Blogspan	LA	A comforting soup filled with chicken and noodles in broth.	27	171	2025-08-19
172	Kaymbo	AR	Lightly salted rice cakes, perfect for a healthy snack.	14	172	2025-05-11
173	Eazzy	GA	A zero-calorie coconut oil spray for cooking and baking.	34	173	2025-09-11
174	Livetube	FL	A casual striped long sleeve shirt that's perfect for layering.	24	174	2025-06-16
175	Fiveclub	IA	Premium potting soil for indoor plants.	30	175	2025-02-18
176	Oloo	GA	A mix of brined Mediterranean olives for snacking.	21	176	2025-06-04
177	Nlounge	OH	Durable and insulated water bottle to keep beverages cold.	32	177	2025-02-13
178	Ainyx	NM	Delicate green tea leaves for a refreshing beverage.	10	178	2025-01-21
179	Rooxo	WI	Nutritious and hearty pasta made from whole wheat flour.	18	179	2025-06-17
180	Wordify	TX	Frozen smoothie mix with bananas and peanut butter for a quick drink.	18	180	2025-05-06
181	Twimm	IA	Sleek and protective sleeve for laptops and tablets.	8	181	2025-03-17
182	Midel	PA	Charcoal kettle grill perfect for backyard barbecues.	12	182	2025-09-20
183	Browseblab	OK	Nutty and wholesome brown rice.	5	183	2025-07-22
184	Zoonder	OH	Planters with a self-watering feature for easy care.	27	184	2025-04-11
185	Lazz	FL	Durable cover to protect your grill from the elements.	11	185	2025-03-05
186	Rhynyx	MI	Genuine leather wallet with multiple compartments.	18	186	2025-01-22
187	Devify	AZ	Fresh salsa made with tomatoes, onions, and cilantro.	15	187	2025-04-23
188	Jabbertype	TX	Set of unique wooden coasters for drinks and decor.	40	188	2025-01-11
189	Bluezoom	TX	Set of ceramic knives for precision slicing.	6	189	2025-09-09
190	Agivu	GA	Cute fairy figurines to decorate your garden or potted plants.	30	190	2025-07-19
191	Oozz	WV	Complete meal kit with everything needed to make beef stroganoff in under 30 minutes.	14	191	2025-08-02
192	Jatri	CT	A mix of grilled vegetables, ready to heat for quick side dishes.	40	192	2025-02-16
193	Livefish	GA	Fresh seedless red grapes, perfect for snacking.	10	193	2024-10-26
194	Dynazzy	MO	Leak-proof bottles for travel-sized toiletries.	17	194	2025-01-10
195	Dabfeed	LA	Blender designed for smoothies and shakes on the go.	39	195	2025-04-27
196	Kwinu	IN	Versatile air fryer that also roasts, bakes, and broils.	19	196	2025-05-28
197	Quire	NY	Frozen shrimp sautéed in garlic butter, ready to thaw and serve over pasta or rice.	34	197	2025-02-23
198	Zoomlounge	OH	Quick oatmeal packets infused with apple and cinnamon, perfect for breakfast.	28	198	2024-10-10
199	Mudo	IL	Durable gardening gloves with reinforced fingertips.	17	199	2025-06-10
200	Realcube	NJ	Essential tools for on-the-go bike maintenance.	11	200	2025-02-21
201	Twiyo	NY	Professional sharpening system for kitchen knives.	38	201	2025-06-19
202	Edgepulse	FL	Energy-efficient LED bulbs that can be controlled via smartphone.	9	202	2025-06-08
203	Flashset	PA	A mix of wild rice with herbs and spices, ready to serve.	14	203	2025-04-06
204	Wordify	MI	Rich sauce for desserts and ice cream.	36	204	2024-12-31
205	Dynazzy	CA	Bright and fragrant cilantro, great for garnishes.	28	205	2025-01-10
206	Dabshots	LA	Decorative table runner perfect for autumn gatherings.	20	206	2025-02-21
207	Dazzlesphere	FL	A blend of dried Italian herbs for cooking.	37	207	2025-08-27
208	Jaloo	MI	Essential attachments for pressure washing.	19	208	2025-03-27
209	Quinu	MS	Spicy sauce made with chipotle peppers	26	209	2025-04-12
210	Yabox	NJ	Dairy-free yogurt made from coconut milk.	20	210	2025-08-22
211	Gevee	CA	Low-carb vegetable for pasta alternatives.	10	211	2025-07-14
212	Voolith	MO	Convenient and low-carb alternative to traditional rice.	11	212	2025-03-15
213	Jaxbean	PA	Fresh eggs from free-range chickens.	26	213	2025-01-25
214	Fivespan	NY	Non-contact thermometer for checking temperatures instantly.	11	214	2024-11-04
215	Mydo	MI	Crunchy granola with toasted coconut flakes, perfect for breakfast or snacks.	5	215	2025-07-27
216	Riffpath	NY	Water-resistant activity tracker and smartwatch features.	11	216	2025-02-15
217	Jamia	PA	Stylish and functional backpack for school or trips.	20	217	2025-05-23
218	Jayo	SC	Portable projector with 1080p resolution for movies.	37	218	2024-10-02
219	Tazzy	MS	A classic soup combining tomatoes and basil, great with grilled cheese sandwiches.	31	219	2025-07-25
220	Kwinu	OH	Weighted jump rope that counts jumps and calories burned.	14	220	2025-06-23
221	Flashspan	PA	Rich tomato soup flavored with fresh basil, ready to heat up.	27	221	2024-11-15
222	Buzzster	NY	Creamy ice cream made with real vanilla beans, perfect for desserts.	36	222	2025-09-08
223	Gabspot	AZ	Trendy leggings with a unique graphic print, versatile for workouts and casual wear.	37	223	2025-07-04
224	Gabcube	MI	Savory potato chips with a hint of maple sweetness and crispy bacon flavor.	25	224	2025-03-17
225	Photojam	VA	Set of decorative pillow covers to enhance your home decor.	36	225	2024-12-05
226	Fadeo	CA	Compact yoga mat that folds for easy storage and transport.	16	226	2025-03-21
227	Flipstorm	NY	Silicone oven mitts designed for safe cooking and baking.	9	227	2025-07-06
228	Tazzy	FL	Wide range of flavored wings, perfect for parties or casual snacking.	33	228	2025-08-12
229	Cogidoo	CA	Fluffy biscuits made without gluten	9	229	2024-11-18
230	Voomm	KY	Reusable silicone mats for non-stick baking.	5	230	2025-08-02
231	Npath	CA	Soft pita bread, perfect for sandwiches or dips.	38	231	2025-02-20
232	Jaxbean	OH	Manual blender for smoothies and mixing ingredients on the go.	14	232	2025-01-30
233	Tagopia	VA	A sweet and spicy salsa made with mangoes and a hint of chili, great with chips or grilled chicken.	5	233	2025-08-23
234	Meevee	TN	A rich pesto made with sun-dried tomatoes and pine nuts.	17	234	2025-03-25
235	Quinu	MS	Compact hair straightener for travel.	36	235	2025-04-12
236	Zoomzone	NV	Connect your phone to the car's audio system via Bluetooth.	33	236	2025-07-09
237	Feedfire	MI	Satisfy your sweet tooth with these dark chocolate-covered raisins.	21	237	2025-05-03
238	Pixoboo	KY	Juicy raisins coated in rich dark chocolate.	9	238	2024-10-06
239	Zoonoodle	TX	Healthy snack bars packed with oats and fruit.	19	239	2025-09-06
240	Babbleopia	GA	A refreshing salad made with quinoa and seasonal veggies.	6	240	2025-02-21
241	Mydeo	IL	Delicious dark chocolate cups filled with creamy peanut butter.	23	241	2025-05-27
242	Tagopia	MS	Essential oil blends for a soothing atmosphere in your home.	39	242	2025-01-24
243	Zoomlounge	OH	Crispy chips with a sweet twist, perfect for dipping.	24	243	2025-01-26
244	Camido	LA	Complete meal kit with everything needed to make beef stroganoff in under 30 minutes.	5	244	2025-07-14
245	Jaxbean	GA	Tablet for digital drawing and illustration work.	14	245	2025-03-11
246	Skalith	CO	Creamy and crumbly cheese for salads and dishes.	29	246	2025-07-13
247	Babbleblab	FL	Cordless handheld vacuum for quick cleanups.	28	247	2025-08-18
248	Riffwire	ND	Variety pack of craft supplies for kids' projects.	31	248	2024-11-03
249	Vimbo	NY	Portable chess set with magnetic pieces for travel.	36	249	2025-09-27
250	Oyoyo	MS	Hearty tomato soup made from organic ingredients.	22	250	2025-05-29
\.


--
-- TOC entry 5455 (class 0 OID 41120)
-- Dependencies: 254
-- Data for Name: MANTENIMIENTOS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."MANTENIMIENTOS" (id_mantenimiento, id_sucursal, id_tipo_mantenimiento, id_estado_mantenimiento, fecha_inicio, fecha_fin) FROM stdin;
1	1	7	1	2025-05-24 00:00:00-06	2024-11-20 00:00:00-06
2	2	3	2	2025-04-04 00:00:00-06	2025-03-08 00:00:00-06
3	3	3	3	2025-02-05 00:00:00-06	2025-07-29 00:00:00-06
4	4	3	4	2025-07-21 00:00:00-06	2025-07-04 00:00:00-06
5	5	16	5	2025-05-23 00:00:00-06	2024-11-05 00:00:00-06
6	6	16	6	2025-01-28 00:00:00-06	2025-06-01 00:00:00-06
7	7	7	7	2025-05-27 00:00:00-06	2025-03-20 00:00:00-06
8	8	17	8	2024-11-16 00:00:00-06	2024-09-30 00:00:00-06
9	9	2	9	2024-12-16 00:00:00-06	2024-10-09 00:00:00-06
10	10	8	10	2025-05-22 00:00:00-06	2025-07-30 00:00:00-06
11	11	11	11	2025-02-27 00:00:00-06	2024-11-26 00:00:00-06
12	12	10	12	2025-01-02 00:00:00-06	2025-03-27 00:00:00-06
13	13	2	13	2024-11-29 00:00:00-06	2025-04-10 00:00:00-06
14	14	20	14	2025-05-16 00:00:00-06	2024-10-04 00:00:00-06
15	15	16	15	2025-05-28 00:00:00-06	2025-07-04 00:00:00-06
16	16	5	16	2025-08-09 00:00:00-06	2025-06-13 00:00:00-06
17	17	10	17	2025-05-21 00:00:00-06	2025-01-31 00:00:00-06
18	18	1	18	2025-04-08 00:00:00-06	2024-12-25 00:00:00-06
19	19	6	19	2025-07-24 00:00:00-06	2024-12-14 00:00:00-06
20	20	14	20	2025-08-15 00:00:00-06	2025-04-14 00:00:00-06
21	21	8	21	2024-11-20 00:00:00-06	2025-07-13 00:00:00-06
22	22	1	22	2025-06-23 00:00:00-06	2025-04-03 00:00:00-06
23	23	20	23	2025-03-04 00:00:00-06	2024-10-01 00:00:00-06
24	24	13	24	2024-11-22 00:00:00-06	2025-06-06 00:00:00-06
25	25	9	25	2025-03-29 00:00:00-06	2024-10-18 00:00:00-06
26	26	3	26	2025-04-07 00:00:00-06	2024-11-05 00:00:00-06
27	27	5	27	2025-06-08 00:00:00-06	2024-11-17 00:00:00-06
28	28	20	28	2025-04-04 00:00:00-06	2025-09-04 00:00:00-06
29	29	14	29	2025-05-07 00:00:00-06	2025-06-02 00:00:00-06
30	30	14	30	2025-06-27 00:00:00-06	2025-08-20 00:00:00-06
31	31	2	31	2024-10-24 00:00:00-06	2025-01-24 00:00:00-06
32	32	2	32	2025-03-23 00:00:00-06	2025-02-13 00:00:00-06
33	33	4	33	2024-11-03 00:00:00-06	2024-11-06 00:00:00-06
34	34	15	34	2024-10-06 00:00:00-06	2025-03-15 00:00:00-06
35	35	4	35	2025-05-03 00:00:00-06	2025-08-12 00:00:00-06
36	36	17	36	2025-04-26 00:00:00-06	2025-09-17 00:00:00-06
37	37	20	37	2025-01-11 00:00:00-06	2024-11-18 00:00:00-06
38	38	1	38	2025-04-11 00:00:00-06	2025-02-15 00:00:00-06
39	39	16	39	2025-08-04 00:00:00-06	2024-11-05 00:00:00-06
40	40	17	40	2025-08-25 00:00:00-06	2024-10-31 00:00:00-06
41	41	7	41	2025-09-09 00:00:00-06	2025-07-20 00:00:00-06
42	42	15	42	2025-09-22 00:00:00-06	2024-11-05 00:00:00-06
43	43	9	43	2025-02-06 00:00:00-06	2025-04-23 00:00:00-06
44	44	1	44	2025-01-26 00:00:00-06	2025-03-20 00:00:00-06
45	45	20	45	2025-01-07 00:00:00-06	2025-02-27 00:00:00-06
46	46	17	46	2025-01-03 00:00:00-06	2024-12-27 00:00:00-06
47	47	6	47	2025-01-10 00:00:00-06	2025-02-22 00:00:00-06
48	48	17	48	2025-06-17 00:00:00-06	2025-07-21 00:00:00-06
49	49	19	49	2025-08-09 00:00:00-06	2024-11-21 00:00:00-06
50	50	5	50	2025-08-05 00:00:00-06	2025-07-21 00:00:00-06
51	51	20	51	2025-01-31 00:00:00-06	2024-11-09 00:00:00-06
52	52	13	52	2025-02-07 00:00:00-06	2025-09-06 00:00:00-06
53	53	12	53	2025-08-08 00:00:00-06	2025-03-23 00:00:00-06
54	54	20	54	2025-03-08 00:00:00-06	2025-02-11 00:00:00-06
55	55	15	55	2024-10-30 00:00:00-06	2025-06-05 00:00:00-06
56	56	1	56	2025-05-27 00:00:00-06	2025-01-14 00:00:00-06
57	57	8	57	2024-10-16 00:00:00-06	2025-04-15 00:00:00-06
58	58	20	58	2024-10-03 00:00:00-06	2024-11-08 00:00:00-06
59	59	2	59	2025-06-21 00:00:00-06	2025-06-08 00:00:00-06
60	60	14	60	2024-10-02 00:00:00-06	2024-11-24 00:00:00-06
61	61	3	61	2024-11-12 00:00:00-06	2025-07-25 00:00:00-06
62	62	16	62	2025-08-28 00:00:00-06	2025-01-17 00:00:00-06
63	63	4	63	2025-02-14 00:00:00-06	2024-12-17 00:00:00-06
64	64	4	64	2025-01-07 00:00:00-06	2025-05-21 00:00:00-06
65	65	10	65	2025-02-28 00:00:00-06	2025-06-07 00:00:00-06
66	66	19	66	2024-11-07 00:00:00-06	2025-07-20 00:00:00-06
67	67	2	67	2025-08-02 00:00:00-06	2025-07-11 00:00:00-06
68	68	13	68	2025-09-01 00:00:00-06	2025-05-01 00:00:00-06
69	69	15	69	2024-12-18 00:00:00-06	2024-12-18 00:00:00-06
70	70	3	70	2025-03-09 00:00:00-06	2025-08-30 00:00:00-06
71	71	1	71	2024-10-11 00:00:00-06	2024-10-25 00:00:00-06
72	72	5	72	2025-03-01 00:00:00-06	2025-01-19 00:00:00-06
73	73	12	73	2025-03-30 00:00:00-06	2025-02-20 00:00:00-06
74	74	18	74	2024-10-04 00:00:00-06	2025-07-27 00:00:00-06
75	75	20	75	2025-06-27 00:00:00-06	2025-05-28 00:00:00-06
76	76	10	76	2025-03-21 00:00:00-06	2025-09-01 00:00:00-06
77	77	3	77	2025-07-11 00:00:00-06	2025-05-11 00:00:00-06
78	78	15	78	2025-08-25 00:00:00-06	2024-10-01 00:00:00-06
79	79	18	79	2025-05-26 00:00:00-06	2025-07-07 00:00:00-06
80	80	1	80	2025-09-17 00:00:00-06	2025-05-24 00:00:00-06
81	81	12	81	2025-05-17 00:00:00-06	2025-06-14 00:00:00-06
82	82	8	82	2025-02-14 00:00:00-06	2025-09-07 00:00:00-06
83	83	9	83	2025-06-23 00:00:00-06	2024-10-26 00:00:00-06
84	84	7	84	2024-11-24 00:00:00-06	2025-05-24 00:00:00-06
85	85	4	85	2025-03-15 00:00:00-06	2024-11-28 00:00:00-06
86	86	18	86	2024-12-22 00:00:00-06	2024-11-20 00:00:00-06
87	87	12	87	2025-08-02 00:00:00-06	2025-02-19 00:00:00-06
88	88	4	88	2025-05-24 00:00:00-06	2024-12-25 00:00:00-06
89	89	10	89	2025-01-28 00:00:00-06	2024-11-23 00:00:00-06
90	90	18	90	2025-03-30 00:00:00-06	2025-03-07 00:00:00-06
91	91	9	91	2025-08-27 00:00:00-06	2025-06-05 00:00:00-06
92	92	11	92	2024-11-01 00:00:00-06	2024-10-22 00:00:00-06
93	93	9	93	2025-06-19 00:00:00-06	2025-03-21 00:00:00-06
94	94	8	94	2025-07-24 00:00:00-06	2024-10-23 00:00:00-06
95	95	6	95	2025-02-14 00:00:00-06	2025-09-03 00:00:00-06
96	96	19	96	2025-02-26 00:00:00-06	2025-09-08 00:00:00-06
97	97	17	97	2025-02-20 00:00:00-06	2025-03-02 00:00:00-06
98	98	4	98	2024-12-20 00:00:00-06	2025-06-02 00:00:00-06
99	99	8	99	2025-03-20 00:00:00-06	2024-11-18 00:00:00-06
100	100	8	100	2025-01-09 00:00:00-06	2025-04-14 00:00:00-06
101	101	4	101	2024-12-07 00:00:00-06	2025-03-24 00:00:00-06
102	102	16	102	2025-05-24 00:00:00-06	2024-10-25 00:00:00-06
103	103	2	103	2025-08-17 00:00:00-06	2025-05-18 00:00:00-06
104	104	19	104	2025-06-20 00:00:00-06	2025-03-10 00:00:00-06
105	105	11	105	2025-06-17 00:00:00-06	2025-01-31 00:00:00-06
106	106	4	106	2025-01-28 00:00:00-06	2025-05-19 00:00:00-06
107	107	14	107	2025-07-18 00:00:00-06	2025-02-06 00:00:00-06
108	108	8	108	2025-04-05 00:00:00-06	2024-11-15 00:00:00-06
109	109	18	109	2025-03-06 00:00:00-06	2024-12-12 00:00:00-06
110	110	9	110	2024-12-17 00:00:00-06	2025-06-27 00:00:00-06
111	111	1	111	2025-03-22 00:00:00-06	2025-06-22 00:00:00-06
112	112	3	112	2025-06-04 00:00:00-06	2024-11-17 00:00:00-06
113	113	12	113	2024-12-06 00:00:00-06	2025-01-04 00:00:00-06
114	114	19	114	2025-04-13 00:00:00-06	2025-05-08 00:00:00-06
115	115	8	115	2024-12-12 00:00:00-06	2025-01-08 00:00:00-06
116	116	19	116	2024-12-12 00:00:00-06	2024-12-17 00:00:00-06
117	117	14	117	2025-04-23 00:00:00-06	2025-06-05 00:00:00-06
118	118	10	118	2025-05-17 00:00:00-06	2025-04-15 00:00:00-06
119	119	14	119	2025-03-04 00:00:00-06	2025-01-08 00:00:00-06
120	120	12	120	2024-12-02 00:00:00-06	2025-03-11 00:00:00-06
121	121	9	121	2025-05-22 00:00:00-06	2025-05-24 00:00:00-06
122	122	13	122	2025-03-27 00:00:00-06	2024-12-25 00:00:00-06
123	123	6	123	2025-09-16 00:00:00-06	2025-02-21 00:00:00-06
124	124	11	124	2024-10-16 00:00:00-06	2024-10-05 00:00:00-06
125	125	18	125	2024-12-11 00:00:00-06	2025-02-09 00:00:00-06
126	126	13	126	2025-02-24 00:00:00-06	2025-01-07 00:00:00-06
127	127	15	127	2025-07-27 00:00:00-06	2025-08-12 00:00:00-06
128	128	12	128	2024-10-30 00:00:00-06	2025-04-17 00:00:00-06
129	129	16	129	2025-01-05 00:00:00-06	2024-10-29 00:00:00-06
130	130	3	130	2025-06-27 00:00:00-06	2024-11-01 00:00:00-06
131	131	6	131	2024-10-18 00:00:00-06	2025-06-04 00:00:00-06
132	132	15	132	2025-08-01 00:00:00-06	2025-02-02 00:00:00-06
133	133	19	133	2025-06-26 00:00:00-06	2024-12-08 00:00:00-06
134	134	16	134	2024-11-30 00:00:00-06	2024-12-30 00:00:00-06
135	135	18	135	2025-03-15 00:00:00-06	2024-12-24 00:00:00-06
136	136	17	136	2025-06-08 00:00:00-06	2024-11-26 00:00:00-06
137	137	2	137	2025-08-20 00:00:00-06	2025-06-14 00:00:00-06
138	138	8	138	2025-07-17 00:00:00-06	2025-07-10 00:00:00-06
139	139	17	139	2025-05-02 00:00:00-06	2024-11-19 00:00:00-06
140	140	19	140	2025-02-26 00:00:00-06	2025-07-02 00:00:00-06
141	141	17	141	2024-10-04 00:00:00-06	2024-11-23 00:00:00-06
142	142	3	142	2025-02-11 00:00:00-06	2025-08-30 00:00:00-06
143	143	8	143	2025-05-07 00:00:00-06	2024-12-26 00:00:00-06
144	144	7	144	2024-10-04 00:00:00-06	2025-04-30 00:00:00-06
145	145	17	145	2025-06-16 00:00:00-06	2024-12-15 00:00:00-06
146	146	3	146	2024-11-22 00:00:00-06	2024-10-05 00:00:00-06
147	147	12	147	2025-07-31 00:00:00-06	2025-08-09 00:00:00-06
148	148	8	148	2024-12-29 00:00:00-06	2024-12-24 00:00:00-06
149	149	13	149	2025-05-04 00:00:00-06	2025-04-24 00:00:00-06
150	150	3	150	2025-07-01 00:00:00-06	2025-03-09 00:00:00-06
151	151	2	151	2025-02-15 00:00:00-06	2025-08-07 00:00:00-06
152	152	15	152	2025-08-17 00:00:00-06	2025-03-09 00:00:00-06
153	153	2	153	2025-01-18 00:00:00-06	2025-03-28 00:00:00-06
154	154	5	154	2025-06-14 00:00:00-06	2025-05-09 00:00:00-06
155	155	8	155	2025-07-20 00:00:00-06	2024-10-19 00:00:00-06
156	156	8	156	2025-08-18 00:00:00-06	2025-04-15 00:00:00-06
157	157	11	157	2025-07-22 00:00:00-06	2025-04-01 00:00:00-06
158	158	11	158	2025-02-17 00:00:00-06	2025-08-05 00:00:00-06
159	159	14	159	2025-01-22 00:00:00-06	2025-02-14 00:00:00-06
160	160	19	160	2025-02-06 00:00:00-06	2024-11-01 00:00:00-06
161	161	10	161	2025-07-28 00:00:00-06	2025-04-20 00:00:00-06
162	162	8	162	2025-03-27 00:00:00-06	2025-08-02 00:00:00-06
163	163	3	163	2025-01-18 00:00:00-06	2025-09-27 00:00:00-06
164	164	11	164	2025-01-16 00:00:00-06	2025-03-24 00:00:00-06
165	165	19	165	2025-04-23 00:00:00-06	2025-05-22 00:00:00-06
166	166	9	166	2025-06-17 00:00:00-06	2025-03-22 00:00:00-06
167	167	6	167	2024-10-09 00:00:00-06	2025-04-14 00:00:00-06
168	168	2	168	2025-07-03 00:00:00-06	2025-03-25 00:00:00-06
169	169	18	169	2024-11-10 00:00:00-06	2025-03-03 00:00:00-06
170	170	5	170	2025-03-31 00:00:00-06	2025-05-10 00:00:00-06
171	171	6	171	2025-08-24 00:00:00-06	2024-11-12 00:00:00-06
172	172	10	172	2025-07-08 00:00:00-06	2025-02-16 00:00:00-06
173	173	14	173	2025-03-01 00:00:00-06	2025-07-17 00:00:00-06
174	174	19	174	2025-03-06 00:00:00-06	2025-02-04 00:00:00-06
175	175	7	175	2025-07-31 00:00:00-06	2025-02-12 00:00:00-06
176	176	10	176	2025-09-26 00:00:00-06	2025-05-18 00:00:00-06
177	177	1	177	2025-09-16 00:00:00-06	2025-04-16 00:00:00-06
178	178	5	178	2025-09-15 00:00:00-06	2024-11-10 00:00:00-06
179	179	20	179	2025-03-28 00:00:00-06	2025-01-07 00:00:00-06
180	180	16	180	2025-03-16 00:00:00-06	2025-04-02 00:00:00-06
181	181	3	181	2025-02-08 00:00:00-06	2025-04-08 00:00:00-06
182	182	11	182	2024-10-15 00:00:00-06	2025-02-24 00:00:00-06
183	183	17	183	2025-07-20 00:00:00-06	2025-03-31 00:00:00-06
184	184	15	184	2025-06-08 00:00:00-06	2024-11-16 00:00:00-06
185	185	14	185	2025-07-14 00:00:00-06	2025-04-25 00:00:00-06
186	186	9	186	2024-12-12 00:00:00-06	2025-06-22 00:00:00-06
187	187	13	187	2025-08-08 00:00:00-06	2025-01-21 00:00:00-06
188	188	17	188	2025-08-24 00:00:00-06	2024-12-08 00:00:00-06
189	189	1	189	2025-04-20 00:00:00-06	2025-04-24 00:00:00-06
190	190	16	190	2025-04-28 00:00:00-06	2025-07-12 00:00:00-06
191	191	10	191	2024-11-12 00:00:00-06	2025-03-13 00:00:00-06
192	192	5	192	2024-11-01 00:00:00-06	2024-10-02 00:00:00-06
193	193	1	193	2025-02-05 00:00:00-06	2025-04-04 00:00:00-06
194	194	5	194	2024-12-14 00:00:00-06	2024-09-29 00:00:00-06
195	195	13	195	2025-03-18 00:00:00-06	2025-01-22 00:00:00-06
196	196	11	196	2025-04-23 00:00:00-06	2024-11-10 00:00:00-06
197	197	7	197	2025-02-14 00:00:00-06	2025-05-09 00:00:00-06
198	198	2	198	2025-09-24 00:00:00-06	2025-01-07 00:00:00-06
199	199	18	199	2025-07-14 00:00:00-06	2024-10-18 00:00:00-06
200	200	12	200	2024-10-18 00:00:00-06	2025-06-17 00:00:00-06
201	201	2	201	2025-05-08 00:00:00-06	2025-07-28 00:00:00-06
202	202	8	202	2025-01-30 00:00:00-06	2025-02-23 00:00:00-06
203	203	9	203	2025-01-04 00:00:00-06	2025-09-13 00:00:00-06
204	204	13	204	2025-01-27 00:00:00-06	2025-06-16 00:00:00-06
205	205	2	205	2025-08-06 00:00:00-06	2025-04-17 00:00:00-06
206	206	20	206	2025-06-27 00:00:00-06	2025-02-05 00:00:00-06
207	207	5	207	2024-12-05 00:00:00-06	2025-01-11 00:00:00-06
208	208	10	208	2025-07-03 00:00:00-06	2024-12-16 00:00:00-06
209	209	9	209	2025-07-24 00:00:00-06	2025-06-27 00:00:00-06
210	210	16	210	2025-07-05 00:00:00-06	2025-09-06 00:00:00-06
211	211	5	211	2025-09-03 00:00:00-06	2024-11-07 00:00:00-06
212	212	4	212	2025-01-12 00:00:00-06	2025-04-08 00:00:00-06
213	213	19	213	2024-12-03 00:00:00-06	2025-05-16 00:00:00-06
214	214	13	214	2024-12-17 00:00:00-06	2025-03-22 00:00:00-06
215	215	10	215	2025-03-07 00:00:00-06	2025-07-15 00:00:00-06
216	216	4	216	2025-08-02 00:00:00-06	2025-06-02 00:00:00-06
217	217	18	217	2025-07-25 00:00:00-06	2024-12-10 00:00:00-06
218	218	19	218	2025-06-19 00:00:00-06	2024-12-16 00:00:00-06
219	219	2	219	2025-06-11 00:00:00-06	2025-07-23 00:00:00-06
220	220	5	220	2024-10-05 00:00:00-06	2025-02-26 00:00:00-06
221	221	2	221	2025-06-01 00:00:00-06	2025-09-26 00:00:00-06
222	222	4	222	2024-11-10 00:00:00-06	2025-07-30 00:00:00-06
223	223	19	223	2024-10-10 00:00:00-06	2025-03-17 00:00:00-06
224	224	13	224	2025-06-01 00:00:00-06	2025-01-04 00:00:00-06
225	225	13	225	2024-12-21 00:00:00-06	2025-05-14 00:00:00-06
226	226	4	226	2025-06-15 00:00:00-06	2025-01-30 00:00:00-06
227	227	2	227	2025-07-23 00:00:00-06	2025-06-03 00:00:00-06
228	228	12	228	2025-04-11 00:00:00-06	2025-04-09 00:00:00-06
229	229	13	229	2024-12-28 00:00:00-06	2025-01-24 00:00:00-06
230	230	17	230	2025-07-28 00:00:00-06	2025-09-06 00:00:00-06
231	231	1	231	2025-05-28 00:00:00-06	2024-11-19 00:00:00-06
232	232	13	232	2025-01-28 00:00:00-06	2024-11-27 00:00:00-06
233	233	19	233	2025-07-09 00:00:00-06	2024-10-08 00:00:00-06
234	234	17	234	2025-08-29 00:00:00-06	2025-02-01 00:00:00-06
235	235	18	235	2025-03-30 00:00:00-06	2025-08-28 00:00:00-06
236	236	13	236	2025-04-03 00:00:00-06	2025-09-05 00:00:00-06
237	237	10	237	2024-10-18 00:00:00-06	2024-11-08 00:00:00-06
238	238	2	238	2025-01-17 00:00:00-06	2025-01-13 00:00:00-06
239	239	1	239	2024-11-23 00:00:00-06	2025-08-23 00:00:00-06
240	240	7	240	2025-02-22 00:00:00-06	2025-03-17 00:00:00-06
241	241	13	241	2024-10-18 00:00:00-06	2024-11-24 00:00:00-06
242	242	11	242	2025-06-30 00:00:00-06	2025-03-07 00:00:00-06
243	243	9	243	2025-09-24 00:00:00-06	2025-05-08 00:00:00-06
244	244	2	244	2025-01-26 00:00:00-06	2024-11-19 00:00:00-06
245	245	13	245	2025-07-09 00:00:00-06	2025-04-18 00:00:00-06
246	246	6	246	2025-02-18 00:00:00-06	2025-02-05 00:00:00-06
247	247	9	247	2024-10-02 00:00:00-06	2025-01-20 00:00:00-06
248	248	2	248	2025-02-18 00:00:00-06	2025-03-21 00:00:00-06
249	249	3	249	2025-01-12 00:00:00-06	2024-11-29 00:00:00-06
250	250	2	250	2025-08-08 00:00:00-06	2025-05-28 00:00:00-06
\.


--
-- TOC entry 5456 (class 0 OID 41123)
-- Dependencies: 255
-- Data for Name: MARCAS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."MARCAS" (id_marca, nombre_marca, contacto, estado_marca) FROM stdin;
1	Brandyn	6618706849	Bar River
2	Darya	1194293365	Wuzhou
3	Dniren	1897201291	North Platte
4	Othilia	6622199861	Nicoya
5	Janek	2335372639	Linden
6	Aurea	4286000300	West Memphis
7	Gerrard	9986978728	Pompano Beach
8	Hank	2255813178	Preveza/Lefkada
9	Eloise	1408530359	Bongsan-ri, Uljin
10	Quincey	3253206337	Tioga
11	Horatia	4114883103	\N
12	Lindsey	7992835574	Cooma
13	Ambros	7188438537	Campo Do Meio
14	Jennica	3987660477	Russell
15	Irwin	4277468848	Burlington/Mount Vernon
16	Sophia	4241798039	Newman
17	Skipton	3074575906	Le Castellet
18	Arleta	3385227925	Santorini Island
19	Chuck	4932178285	Palu-Celebes Island
20	Gaylord	2487493175	Dayton
21	Issiah	3909154354	Tenerife Island
22	Rolando	6227801286	Lethem
23	Ardenia	3655051436	Denham
24	Berenice	3838602552	\N
25	Krissy	8182748786	Broughton Island
26	Estele	4035820337	Ebolowa
27	Kearney	5982406039	\N
28	Eugenio	3301718877	Cortina D'Ampezzo
29	Paquito	8724481136	San Luis
30	Guilbert	2356911422	Cormeilles-en-Vexin
31	Zak	4902444999	Fullerton
32	Kennett	8461093551	Ingeniero Jacobacci
33	Elizabet	2073503577	Kiev
34	Flossie	9915824747	Baltimore
35	Matthieu	7971898372	York Landing
36	Armstrong	3417395337	Ålesund
37	Chloette	5728165769	Ayacucho
38	Genevra	1146806769	Trail
39	Salome	5623498735	Marsabit
40	Raye	4973772194	Eqalugaarsuit
41	Cosmo	3273827429	Tanjung Manis
42	Neala	7193645485	Cascais
43	Gale	6307199786	Patos De Minas
44	Shalom	6839930673	Fort Leonard Wood
45	Blithe	3648266986	Guriaso
46	Indira	1838278505	Chena Hot Springs
47	Lurette	7537361282	Vorkuta
48	Isahella	5419053628	Okinoerabujima
49	Reinald	8024959922	Yiwu
50	Ottilie	6811106181	Aizawl
51	Florida	5851718200	Rutland
52	Larissa	2157298886	Salt Spring Island
53	Enrichetta	2013554028	Vinh Long
54	Chet	9253698347	Jataí
55	Lock	3197921241	Tangshan
56	Osbert	7285301942	Gamboma
57	Sigismundo	2933785939	Cherbourg/Maupertus
58	Glen	2025848029	Maramag
59	Arte	3932309161	\N
60	Selina	7756554642	Hazleton
61	Xymenes	1843058425	Saarbrücken
62	Brewer	2428333122	Tonghua
63	Neale	2622408849	Hangzhou
64	Nathanael	7867573228	Galesburg
65	Pierette	2951417919	Utila Island
66	Aylmar	6943879341	Ponta Delgada
67	Chevy	9984997211	Broome
68	Marje	9524890953	Farmington
69	Krystyna	1272530378	Lucknow
70	Ban	4019371757	Nakina
71	Alikee	3091490736	\N
72	Eduardo	6132280646	Constanţa
73	Kenton	5459336696	Clinton
74	Whit	2753981723	Parsabad
75	Boone	2323086592	Chiquimula
76	Flori	1729285566	Exeter
77	Zaneta	4418455764	Ibiza
78	Jaye	9844444022	Magnitogorsk
79	Devin	5793844876	Ahmed Al Jaber AB
80	Nicolas	7236379497	Balemartine
81	Camey	5802054878	La Dorada
82	Emlyn	9814768216	Ajmer
83	Trudey	6961818143	Arvidsjaur
84	Jerrine	8392766565	San Ramón / Mamoré
85	Rainer	7054748450	\N
86	Albie	1748452994	Central
87	Corella	7311911151	Apiay
88	Cyndy	7034956680	Chitré
89	Marion	9931336353	Gabès
90	Maryellen	4448607811	Greenville
91	Prue	1544598366	\N
92	Tomasina	6412362999	Pikeville
93	Town	5796636191	Scottsbluff
94	Dottie	4593485732	Gorkha
95	Lukas	3585997521	Shiyan
96	Bibbie	2058336139	Chachapoyas
97	Sharla	2542103033	Sliač
98	Lawton	5592568069	Port Said
99	Petr	1937180432	Surkhet
100	Roshelle	9246569429	\N
101	Pierre	4219779186	Silistra
102	Alphard	8814752336	Wainwright
103	Gilberto	6736152308	Papeete
104	Zaccaria	1823423791	\N
105	Corrinne	7382721633	Braunschweig
106	Cammy	3023002570	\N
107	Agnese	2469427967	Freeport
108	Ed	9428242362	Wendover
109	Estell	5946081355	Ostrava
110	Jammie	8768282152	Luuq
111	Roarke	8779149241	\N
112	Rod	2921520998	Quimper/Pluguffan
113	Kristoffer	6289261471	Voinjama
114	Jocko	1677259225	Ibiza
115	Kaylee	7133144403	La Palma
116	Jase	7671942178	Khoy
117	Isaiah	5367291336	Hoedspruit
118	Domini	4656433819	Vila Bela Da Santíssima Trindade
119	Jase	9741804707	Mubatuba
120	Nathanil	5883721965	Ndola
121	Thane	6478433098	\N
122	Nealson	4132615614	Njombe
123	Jennie	8388480163	Universal City
124	Bran	2282551008	Arorae Island
125	Janith	4469239502	Mary's Harbour
126	Alva	1431430729	Asmat
127	Sallee	3196371823	Arecibo
128	Arvy	8302093391	Leeuwarden
129	Estele	2713044205	\N
130	Kelcey	9618618812	Middle Caicos
131	Jacky	1223175136	Mexico City
132	Barbra	3274134769	Kaohsiung City
133	Cecilius	4583620136	Malabo
134	Romola	4402286438	Marmul
135	Inez	6181510306	Whitefield
136	Anderea	2335787334	Yevlakh
137	Timi	1058834700	Tozeur
138	Simonne	9375602778	Linares
139	Edsel	2991926300	Fairview
140	Frederich	1514624377	Greenville
141	Trixie	6739783781	Lake City
142	Nelia	2439856662	Ajaccio/Napoléon Bonaparte
143	Jermaine	4568991777	Tablas Island
144	Justinn	2489911452	Çorlu
145	Neille	8004615271	Masasi
146	Karolina	7878337448	Wabo
147	Gusta	3313032529	Santa Vitória Do Palmar
148	Verge	9852305712	Frederick
149	Janelle	7835278356	Guaíra
150	Lolly	3005430184	Ivano-Frankivsk
151	Willie	7707193314	Matthew Town
152	Hannie	5314872384	Cape Romanzof
153	Albertina	7466884989	Tahuna-Sangihe Island
154	Garrett	6802617526	Sulphur Springs
155	Glenn	9197522202	Limnos Island
156	Pietra	7433435343	Alenquer
157	Dianemarie	1952656271	Marion
158	Oswell	3106696607	Castori Islets
159	Finn	8804736284	Inyati
160	Julieta	5228384422	Pittsfield
161	Jacky	2032122582	Fort Bridger
162	Molly	1111926771	Utopia Creek
163	Byran	7244194297	Mangungaya-Sumatra Island
164	Adair	7801074524	Paris
165	Toni	6455836618	Marshall
166	Othella	5226044759	Zaqatala
167	Yettie	6094348748	Porto Alegre Do Norte
168	Pasquale	6995723210	Kamarata
169	Onfre	3416597972	Dease Lake
170	Rennie	4801371398	Oklahoma City
171	Godiva	2514351437	Xai-Xai
172	Clementina	5596643379	Omora
173	Toby	3854957610	Bacău
174	Loleta	8715868760	Colón
175	Maggie	1274139031	Jacksonville
176	Dewain	4432424496	Lusikisiki
177	Casandra	4488616337	São Lourenço
178	Jephthah	1912403793	Salmon
179	Munroe	8796330629	Cold Lake
180	Elston	7765999402	Maripasoula
181	Brett	7036261006	New Stuyahok
182	Ailbert	4267255338	Nha Trang
183	Gayel	5048577459	Salekhard
184	Claudelle	9139071741	Peshawar
185	Herta	7619849852	Corrientes
186	Warren	5204174965	\N
187	Alwin	6759110244	Wellington
188	Phillip	2207861679	\N
189	Junie	7428955134	Buon Ma Thuot
190	Beth	6648121028	Luiza
191	Amble	4233571656	Isla Tupile
192	Kienan	6422915971	\N
193	Rafaello	5969386053	San Luis Obispo
194	Raphael	1436227920	\N
195	Davon	5688685169	Mbala
196	Nester	7664002000	Podor
197	Clevie	6953364232	Kampala
198	Mendel	8015639704	Copenhagen
199	Moss	6764336740	\N
200	Geri	5644725887	Longnan
201	Ula	9711977008	Wilmington
202	Byrle	1407159882	El Dorado
203	Meris	1096942373	Ashgabat
204	Lianna	4065616257	Komaio
205	Boycie	3831457624	Ketchikan
206	Galvin	8767727678	Roosevelt
207	Sayer	7429716598	\N
208	Gladi	1019146165	\N
209	Nonnah	6192786703	Hyderabad
210	Daria	8225543799	La Isabela
211	Elli	8373161051	Camaguey
212	Enrico	5926781852	Inuvik
213	Leopold	1926468558	Geneina
214	Philipa	7952949967	Puerto Peñasco
215	Ruby	7836484616	Odiham
216	Harmon	9698185041	Minden
217	De witt	2985146428	\N
218	Silvana	1404312150	Sunyani
219	Jeanette	7998128459	Benton Harbor
220	Sandor	5062210246	Quinhagak
221	Peterus	7309540913	\N
222	Rowe	5685669118	Inyokern
223	Lorinda	9967766673	Visalia
224	Ermanno	4318677200	Silgadi Doti
225	Alexandre	5695007695	Vichy/Charmeil
226	Alexis	8565565956	Eunice
227	Tamra	7381168836	Rawlins
228	Josh	3826660022	Bequia
229	Ruy	7357863768	Dimbokro
230	Johanna	1429780828	Gardez
231	Borden	7512169611	\N
232	Chelsey	4527560868	Rio Turbio
233	Cecil	8444714198	Camocim
234	Binny	1104227351	\N
235	Lanna	3294266820	Boquira
236	Libbey	9803394782	Mc Allen
237	Ajay	1697345847	Nanuya Levu Island
238	Jere	4228255595	\N
239	Montague	2563041642	Wahpeton
240	Siffre	5914183531	La Primavera
241	Cyrus	4924153131	Batagay-Alyta
242	Bethanne	9399238699	Luzhou
243	Davine	5436840435	Hatzfeldhaven
244	Harwell	2335400947	Nachingwea
245	Ertha	7627259088	Porbandar
246	Pauletta	3801808281	Lobatse
247	Rebeka	5732130979	Crows Landing
248	Dugald	3341922227	Fort Hood(Killeen)
249	Karol	4946074190	Chicago/Romeoville
250	Genevieve	3548667317	Hickory
\.


--
-- TOC entry 5457 (class 0 OID 41126)
-- Dependencies: 256
-- Data for Name: METODO_PAGO; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."METODO_PAGO" (id_metodo_pago, descripcion) FROM stdin;
1	Lightweight leaf blower for maintaining outdoor spaces.
2	Water-resistant Bluetooth speaker for showers.
3	Mix to create a delicious chia seed pudding in just a few minutes.
4	Fresh green cabbage, great for salads and slaws.
5	A blend of roasted red peppers and spices, perfect for dipping.
6	Soft cookies made with almond butter
7	Handheld sprayer designed for washing pets easily.
8	Bottle that allows you to infuse your water with fruits.
9	Adjustable stand for portable speakers and devices.
10	Heated stool cover for extra comfort during winter.
11	Stylish two-tone windbreaker, perfect for active days.
12	Ideal for creating custom designs on t-shirts and fabrics.
13	Professional-grade nail care set for manicures and pedicures.
14	Comprehensive camera and alert system for home security.
15	Versatile organic coconut oil for cooking and baking.
16	Adjustable stand for smartphones and tablets.
17	Rechargeable LED camping lantern for outdoor use.
18	Reusable silicone lids for covering food in bowls and storage containers.
19	Polarized sunglasses with UV protection.
20	Elegant midi skirt with a wrap design, great for both formal and casual events.
21	Stylish desk lamp featuring a USB charging port.
22	Bell peppers stuffed with rice and vegetables
23	Healthy salad made with quinoa, almonds, and mixed greens, perfect for a light meal.
24	Cold pasta salad tossed with pesto and fresh vegetables.
25	High-resolution camera for stunning photos.
26	Fruits dipped in rich chocolate, perfect for desserts.
27	Instant oats with a savory twist, such as herbs and spices.
28	Decadent tart made with rich dark chocolate.
29	Adjustable weighted jump rope for workouts.
30	Lightly salted rice cakes, perfect for a healthy snack.
31	Complete set of cooking utensils made from bamboo.
32	Elegant classic pumps that add sophistication to any outfit.
33	Wide pasta sheets for making lasagna.
34	Ergonomic stand for laptops to improve posture while working.
35	Designed for comfort and performance during workouts.
36	Quote wall art to inspire and motivate.
37	Comfortable carrier for small pets during travel.
38	Ultrasonic diffuser that helps create a calming atmosphere.
39	Soft and delicious garlic-infused flatbread, perfect for dipping.
40	Instant-read thermometer for accurate cooking temperatures.
41	Refreshing sparkling water with cucumber and lime flavor.
42	Comfortable camping mattress that inflates automatically.
43	Padded laptop sleeve for protection against scratches.
44	Complete crafting kit for kids and adults.
45	Eco-friendly toys for learning and imaginative play.
46	Healthy salad made with quinoa, almonds, and mixed greens, perfect for a light meal.
47	A fragrant blend of Italian herbs for pasta sauces and marinades.
48	High-quality matcha powder for smoothies and baking.
49	Juicy burger patties made with grass-fed beef
50	Space-saving crates for easy organization at home or while traveling.
51	Fast and convenient air pump for inflating toys and furniture.
52	Fun inflatable float for lounging in the pool or beach.
53	Savory roasted garlic in a jar for easy use.
54	Convenient water bottle for pets on the go.
55	Portable and lightweight umbrella for protection from rain.
56	Rich and tangy dressing perfect for salads.
57	Delicious veggie burger patties for grilling or frying.
58	Fresh organic sweet potatoes, great for roasting or mashing.
59	Adjustable weighted jump rope for workouts.
60	Frozen zucchini slices coated in parmesan cheese, perfect for baking or frying.
61	A tangy sauce made with cranberries and citrus zest, perfect for turkey and chicken dishes.
62	A convenient meal kit for making a delicious beef taco skillet at home.
63	Fresh button mushrooms, great for cooking.
64	Crispy dill pickles that are perfect for snacking or sandwiches.
65	A sweet and spicy sauce for dipping or cooking.
66	Crisp and sweet Honeycrisp apples, freshly picked.
67	Powerful blender for smoothies and soups.
68	Designed for comfort and performance during workouts.
69	Frozen mini meatballs that are great as a snack or in pasta dishes.
70	A mix of fresh vegetables for quick stir-fries.
71	A mix of grilled vegetables, ready to heat for quick side dishes.
72	Durable jump rope with built-in counter for workouts.
73	Individually packaged bars made with dried fruits and nuts.
74	Handheld vacuum cleaner for quick and easy cleaning.
75	Passive noise reduction headphones for focus.
76	Portable chess set with magnetic pieces for travel.
77	Eco-friendly toys for learning and imaginative play.
78	Savory popcorn flavored with maple syrup and bacon bits.
79	Stay warm with this stylish knit beanie in various colors.
80	Rich vegetable broth for soups and stews.
81	Electric food steamer for healthy cooking.
82	Compact air conditioner for personal cooling.
83	Silicone tea infuser for brewing loose leaf tea.
84	Fresh organic spinach, great for salads or cooking.
85	Powerful hand blender for soups and smoothies.
86	Colorful veggie chips made from beets, carrots, and sweet potatoes.
87	Set of reusable stainless steel straws for drinks.
88	Pulled jackfruit in a smoky BBQ sauce for a tasty vegan dish.
89	1080p HD video camera with night vision.
90	Compact keyboard for tablets and smartphones.
91	Eco-friendly phone case designed to decompose safely.
92	Portable battery pack to charge laptops while on the move.
93	Mixed fresh vegetables for stir-frying or roasting.
94	Durable and spacious backpack for travel and school.
95	Space-saving colander for rinsing fruits and vegetables.
96	Super soft fleece blanket, perfect for coziness.
97	Frozen mix of colorful stir-fry veggies.
98	A high-quality protein powder perfect for smoothies and baking.
99	Creamy pistachio-flavored ice cream with real nuts.
100	A cozy long cardigan designed for layering in any season.
101	Complete sculpting tools for artists.
102	Portable solar shower for camping and outdoor use.
103	Smoky and sweet BBQ sauce for grilling and dipping.
104	Safety collar with flashing lights for pets during night walks.
105	Rich and creamy dressing with garlic flavor, perfect for salads.
106	Comfortable slim fit chinos for a polished look.
107	Multifunctional smartwatch for fitness tracking.
108	Charming frame to showcase your favorite photos.
109	Delicious waffles infused with pumpkin and spices.
110	Crispy chicken nuggets for quick meals.
111	Indoor Wi-Fi camera for home security.
112	Sweet relish made from cucumbers, perfect for sandwiches.
113	Deliciously creamy almond milk, perfect for smoothies.
114	Manual pasta maker for homemade pasta.
115	Aromatic fresh basil, perfect for Italian cooking.
116	Eco-friendly reusable bags for snacks.
117	Reusable suction cup hooks for hanging items.
118	A sweet and spicy salsa made with mangoes and a hint of chili, great with chips or grilled chicken.
119	Savory teriyaki sauce for stir-frying veggies or meats.
120	Sweet mixture of cinnamon and sugar for sprinkling.
121	Natural pink salt, perfect for seasoning.
122	All-in-one meal kit including pasta, meatballs, and sauce for a quick dinner.
123	Multiple USB ports for charging devices simultaneously.
124	Instant mix for creamy vanilla pudding.
125	Beautiful wall calendar for organizing your schedule.
126	Crunchy granola with maple syrup and pecans, great for breakfast or snacking.
127	Stylish wine rack to store and display bottles.
128	Quick meal kit with pasta and fresh vegetables.
129	Complete set for grilling and tailgating fun.
130	Versatile multi-cooker for pressure cooking and slow cooking.
131	Mixed fresh vegetables for stir-frying or roasting.
132	Refreshing apple juice, 100% juice with no added sugar.
133	Spicy seasoning mix for all your favorite dishes.
134	Insulated water bottle for keeping drinks cold.
135	Versatile slicer for meats, cheeses, and vegetables.
136	Creamy mashed sweet potatoes with a hint of cinnamon.
137	A mix of frozen berries for smoothies or desserts
138	Perfect dipping sauce or stir-fry addition for a sweet and tangy flavor.
139	Coffee blend infused with pumpkin spice, perfect for fall.
140	Spicy salsa made with black beans and tomatoes.
141	Healthy whole grain cereal, great for breakfast.
142	Silicone oven mitts for safe handling of hot cookware.
143	A rich curry paste for making authentic Thai green curry at home.
144	Insulated mug to keep drinks hot on the go.
145	The perfect seafood snack, ready to eat and delicious.
146	Electric rice cooker with multiple cooking settings for perfect rice.
147	Soft pita bread, perfect for sandwiches or dips.
148	Fun light that creates a disco atmosphere for parties.
149	Portable car vacuum cleaner with strong suction.
150	Monitor and interact with your pet remotely with this camera.
151	A refreshing drink mix that combines sweet raspberries and tart lemons, perfect for summer.
152	Rich in selenium, perfect for snacking or baking.
153	DIY LED strip lights with remote control.
154	Fruits dipped in rich chocolate, perfect for desserts.
155	Hands-free waist pack for carrying essentials while walking your dog.
156	Homemade jam made with blueberries and chia seeds, no added sugar.
157	Rich and flavorful chicken broth, great for soups.
158	Bottle with infuser for brewing loose-leaf tea on the go.
159	Eco-friendly bags for storing food without plastic waste.
160	Wearable device to track fitness activities and heart rate.
161	Crunchy granola with oats, nuts, and honey.
162	Instant miso soup mix, just add hot water for a warm meal.
163	Microwaveable heat pad for soothing muscle aches.
164	Precision digital scale for accurate cooking measurements.
165	Trendy leggings with a unique graphic print, versatile for workouts and casual wear.
166	Creamy macaroni and cheese baked to perfection.
167	Portable ring light that enhances your photos with perfect lighting.
168	Creamy pistachio-flavored ice cream with real nuts.
169	Refreshing green tea infused with peach, perfect for a hot day.
170	Single-serve coffee maker with a built-in grinder.
171	Sweet and tangy raspberry lime beverage
172	Compact yoga mat that folds for easy storage and transport.
173	Wearable diffuser for scenting your space and body.
174	A blend of spices perfect for seasoning steak.
175	Compact pocket tool with various built-in functions.
176	Delicious turkey bacon, a healthier alternative.
177	Easy-to-set up tent designed for campers and hikers.
178	A mix of carrots, peas, and corn, easy to stir-fry.
179	Complete set for grilling and tailgating fun.
180	Personalize your calendar with photos and special dates.
181	Heat-sensitive mug that changes color when filled with hot liquid.
182	Light and breezy dress perfect for summer outings with a vibrant floral pattern.
183	Creamy peanut butter with no added sugar or oils.
184	Fun inflatable cooler to keep drinks cold at parties.
185	Stabilizing gimbal for smooth video recording.
186	High-quality whey protein powder for muscle recovery.
187	Lightweight hammock with a sturdy stand for relaxation anywhere.
188	Rotating spice rack with 20 spice jars.
189	Frozen chicken bites coated in a honey sriracha glaze, spicy and sweet.
190	Cold pasta salad tossed with pesto and fresh vegetables.
191	Classic ketchup made from organic tomatoes, no added sugar.
192	Ergonomic footrest for easier pedicure treatment.
193	Chic slingback sandals for a relaxed summer vibe.
194	Sweet and fruity peach preserves, perfect for spreading on toast.
195	A sweet and spicy sauce for dipping or glazing.
196	Natural sweetener for baking and cooking.
197	Skillet that can fry, grill, and sauté with ease.
198	Stainless steel travel mug that keeps drinks hot or cold.
199	Warm oatmeal flavored with apple and cinnamon.
200	Tender ribs smothered in a honey barbecue sauce.
201	Affordable fitness tracker with heart rate monitor.
202	Adds extra comfort to your mattress for a better night's sleep.
203	Marinated grilled chicken breasts seasoned with garlic and herbs.
204	Classic V-neck sweater crafted from soft wool for warmth and style.
205	Cordless electric screwdriver for home projects.
206	Refreshing sparkling water infused with cranberry and lime flavors.
207	Instant oats with a savory twist, such as herbs and spices.
208	Compact, waterproof blanket for picnics and events.
209	Storage solutions for keeping your car tidy and organized.
210	Flavorful lentil soup, perfect for a quick meal.
211	Soft pretzel bites, perfect for dipping in mustard or cheese sauce.
212	Juicy burger patties made with grass-fed beef
213	Fresh basil pesto, perfect for pasta or as a sandwich spread.
214	Comfortable wireless headphones designed for sleeping.
215	Compact food processor for quick meal prep.
216	Stylish wine rack to store and display bottles.
217	Whole grain oats that are perfect for breakfast or baking.
218	Stainless steel measuring spoons set for cooking.
219	DIY kit to make your own lip balms in various flavors.
220	Fluffy couscous seasoned with a blend of herbs, perfect as a side dish.
221	Healthy salad made with chickpeas, vegetables, and a lemon dressing.
222	Comprehensive first aid kit for home and travel.
223	Compact travel organizer for accessories and toiletries.
224	Durable and versatile food storage containers.
225	A refreshing blend of peaches and mangoes for a delicious smoothie.
226	GPS pet collar that helps locate your pet via smartphone app.
227	Fresh organic spinach, great for salads or cooking.
228	Large stir fry pan with non-stick surface.
229	A rich marinade perfect for meats and vegetables, infused with Italian herbs and balsamic vinegar.
230	Complete tattoo kit for beginners and professionals.
231	Smooth and creamy smoothie made with peanut butter and banana.
232	A blend of roasted red peppers and spices, perfect for dipping.
233	Durable baking sheet coated for easy food release.
234	Adjustable weighted jump rope for workouts.
235	Reusable gel ice pack for injuries and cooling.
236	Challenging and fun puzzle game for all ages.
237	Eco-friendly solar lights for pathways and gardens.
238	Flexible molds perfect for baking cakes and pastries.
239	Delicious veggie burger patties for grilling or frying.
240	Creamy chickpea dip, perfect for veggies or pita.
241	A pack of assorted nut and protein bars for a quick energy boost.
242	Hearty beef chili, ready to heat and eat.
243	Compact fridge ideal for camping and road trips.
244	Juicy and tender beef sirloin steak, grass-fed.
245	A colorful printed maxi skirt for a bohemian look.
246	Sweet, chewy dried apricots, great for snacking or baking.
247	High-capacity power bank for charging devices on the go.
248	Ideal for creating custom designs on t-shirts and fabrics.
249	Self-cleaning grooming brush for cats and dogs.
250	Unique handcrafted utensils for cooking and serving.
\.


--
-- TOC entry 5458 (class 0 OID 41131)
-- Dependencies: 257
-- Data for Name: MOBILIARIOS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."MOBILIARIOS" (id_mobiliario, nombre, descripcion, id_marca, id_sucursal) FROM stdin;
1	Cissy	Salted sunflower seeds perfect for snacking.	1	1
2	Trula	Insulated water bottle for keeping drinks cold.	2	2
3	Son	Handheld sprayer designed for washing pets easily.	3	3
4	Nicola	Reversible bamboo chopping board for food prep.	4	4
5	Carolyne	Designed for comfort and performance during workouts.	5	5
6	Flossie	Set of decorative pillow covers to enhance your home decor.	6	6
7	Kassey	Crispy baked falafel balls, perfect for salads	7	7
8	Cornelle	Soft comforter set for a cozy bedroom look.	8	8
9	Dyanne	Frozen pizza loaded with fresh vegetables and mozzarella cheese.	9	9
10	Luke	500-piece jigsaw puzzle featuring beautiful scenery.	10	10
11	Weber	Floating lounger for relaxation in swimming pools or lakes.	11	11
12	Jennee	Fresh and zesty salsa, perfect for nachos.	12	12
13	Gwenneth	A flavorful sauce for stir-frying vegetables and meats.	13	13
14	Lionel	3D model puzzle kit for creative builders.	14	14
15	Kath	Complete grooming kit for dogs and cats.	15	15
16	Beltran	A protein-packed pancake mix for a nutritious breakfast.	16	16
17	Romeo	Modern desk lamp that features a built-in USB charging port.	17	17
18	Dare	Peel and stick wallpaper for easy home decor changes.	18	18
19	Willabella	Flavored couscous with herbs and spices, perfect as a side dish or a base for salads.	19	19
20	Matty	Personalize your calendar with photos and special dates.	20	20
21	Morlee	A blend of dried Italian herbs for cooking.	21	21
22	Pearla	A smoky blend of spices for grilling and roasting.	22	22
23	Marin	Seasoned and roasted to perfection, ready to eat.	23	23
24	Jordana	Spacious duffle bag for weekend getaways.	24	24
25	Bevon	Organizational cubes for easy packing and travel.	25	25
26	Gloria	Rich almond butter encased in dark chocolate.	26	26
27	Pauletta	BPA-free sports bottle with flip-top lid.	27	27
28	Anallise	Gluten-free almond flour, perfect for baking.	28	28
29	Krissie	Savory sausage links seasoned with Italian spices.	29	29
30	Lancelot	Space-saving adjustable dumbbells for strength training.	30	30
31	Alfonse	Tender sweet corn kernels, ready to eat or add to dishes.	31	31
32	Sherman	Eco-friendly bamboo toothbrush for sustainable living.	32	32
33	Caritta	Roasted almonds dipped in rich dark chocolate.	33	33
34	Kandy	Adjustable grinders for fresh spices at the table.	34	34
35	Jean	Savory lentil chips with BBQ flavor	35	35
36	Dolley	Rich tart filled with chocolate and raspberry, a gourmet dessert.	36	36
37	Lorette	Portable folding table for outdoor events.	37	37
38	Joscelin	Eco-friendly bamboo cutting board for food prep.	38	38
39	Ambrosio	Natural honey sourced from wildflowers.	39	39
40	Meggie	Lint roller designed specifically for removing pet hair from furniture.	40	40
41	Ailee	Bright LED flashlight with adjustable beam.	41	41
42	Nikkie	A mix of fresh raspberries, blueberries, and blackberries.	42	42
43	Reggie	Portable chess set with magnetic pieces for travel.	43	43
44	Giacinta	A frozen cheesy bake made with cauliflower, great as a side dish or a vegetarian meal.	44	44
45	Colas	Healthy fruit snacks, made with real fruit.	45	45
46	Gennifer	Spicy sauce perfect for chicken wings and dipping.	46	46
47	Tommy	Precision pencils for drawing, sketching, and writing.	47	47
48	Toddy	Fluffy rice cooked with coconut milk for a tropical twist.	48	48
49	Alistair	Comfortable carrier for small pets during travel.	49	49
50	Elsi	Marinated chicken breasts coated in a sweet honey mustard glaze.	50	50
51	Dene	Silicone tray for making ice cubes with a lid to prevent spills.	51	51
52	Sven	Herbal tea blend with ginger and turmeric for a soothing drink.	52	52
53	Caryl	Flavored aioli made with roasted garlic	53	53
54	Salim	Quick and easy way to remove wrinkles from clothes.	54	54
55	Roley	Durable backpack for hiking or travel.	55	55
56	Shelba	Crunchy and sweet banana chips, a great on-the-go snack.	56	56
57	Kinny	Crispy and juicy chicken tenders, perfect for dipping.	57	57
58	Virgina	Control your lights remotely with a smartphone app.	58	58
59	Leese	Pancake mix infused with seasonal pumpkin spice flavor.	59	59
60	Hayden	A zesty salsa made with peaches and mangos, great for chips.	60	60
61	Ivonne	Tangy green salsa made with tomatillos, perfect for tacos.	61	61
62	Harriette	Compact sterilizer for disinfecting small items.	62	62
63	Vick	Easy-to-read digital kitchen timer with alarms.	63	63
64	Tamas	Crunchy granola mixed with maple syrup and cinnamon, perfect for breakfast or snacks.	64	64
65	Morganne	Eco-friendly bamboo cutting boards in various sizes.	65	65
66	Averil	Nutritious snack bar made with almond butter and protein.	66	66
67	Nada	Eco-friendly bamboo cutting boards in various sizes.	67	67
68	Wakefield	Spicy sauce perfect for chicken wings and dipping.	68	68
69	Shani	Blend of cheddar and mozzarella cheese, great for recipes.	69	69
70	Bernadene	Delicate ravioli filled with roasted butternut squash and spices, perfect with a sage butter sauce.	70	70
71	Kingsley	Programmable pet feeder for scheduled meals.	71	71
72	Margie	Easy-to-prepare rice with cilantro and lime flavors, great as a side.	72	72
73	Merrel	Lightweight water filter for outdoor adventures.	73	73
74	Rik	Vegan sushi filled with spicy vegetables and avocado.	74	74
75	Michele	Crunchy granola with chocolate and coconut, great for breakfast or snacks.	75	75
76	Scott	Fresh sushi rolls filled with a variety of vegetables.	76	76
77	Marta	Pre-seasoned beef mix for delicious tacos, just heat and serve.	77	77
78	Phil	Complete kit with crayons, markers, and paper for young artists.	78	78
79	Candida	Rich and flavorful pasta sauce made with ripe tomatoes and basil.	79	79
80	Miller	High-performance compression tights designed for optimal support and comfort.	80	80
81	Harland	Fresh walnut halves for baking or snacking.	81	81
82	Salvatore	Clip-on guitar tuner with LCD display.	82	82
83	Joby	Compact electronic drum kit for musicians of all levels.	83	83
84	Carla	Crispy and crunchy snack made from assorted vegetables.	84	84
85	Calhoun	Breathable polo shirt designed for both style and comfort on the greens.	85	85
86	Adams	Portable folding table for outdoor events.	86	86
87	Hildegarde	Reusable silicone mats for non-stick baking.	87	87
88	Bob	Compact knife with safety lock for everyday use.	88	88
89	Ferdie	Decadent brownies made without gluten, rich and chocolatey.	89	89
90	Winna	High-quality whey protein powder for muscle recovery.	90	90
91	Robinett	Healthy pizza crust made from cauliflower	91	91
92	Rutger	A classic white button-up shirt for a polished appearance.	92	92
93	Shelley	Fine semolina flour, perfect for pasta and desserts.	93	93
94	Starla	Hearty tomato soup made from organic ingredients.	94	94
95	Irita	A smoky blend of spices for grilling and roasting.	95	95
96	Steve	Creamy and delicious soup made with real butternut squash, ready to heat.	96	96
97	Heddi	A flowy maxi dress perfect for both casual and semi-formal occasions.	97	97
98	Belinda	Challenging and fun puzzle game for all ages.	98	98
99	Burl	Stylish fruit basket for kitchen or dining room.	99	99
100	Travis	Unsweetened coconut flakes for baking and snacking.	100	100
101	Benjamen	Charming frame to showcase your favorite photos.	101	101
102	Dyann	Monitor and interact with your pet remotely with this camera.	102	102
103	Sonnie	Dried tomatoes packed with deep flavor for salads and pasta.	103	103
104	Cleve	Sweet corn roasted to perfection for a delightful side.	104	104
105	Eugenia	Delicious pie filled with coconut cream and topped with whipped cream.	105	105
106	Hayley	Crunchy cacao nibs, great for adding to smoothies or baking.	106	106
107	Daria	Prevent water damage with drip trays for potted plants.	107	107
108	Perren	Set of magnetic jars for convenient spice organization.	108	108
109	Inigo	Comfy pet bed with washable cover for easy cleaning.	109	109
110	Chandra	A stunning lace dress perfect for special occasions.	110	110
111	Ada	A warm and stylish puffer coat perfect for winter weather.	111	111
112	Nadiya	Eco-friendly bamboo toothbrush for sustainable living.	112	112
113	Ibrahim	Beautiful wall calendar for organizing your schedule.	113	113
114	Brian	A tailored slim fit shirt for a polished look at work.	114	114
115	Doria	Soft and comfortable robe, perfect for lounging at home.	115	115
116	Elly	Protects surfaces while baking or cooking with hot items.	116	116
117	Meriel	Rechargeable massage gun for relieving muscle soreness.	117	117
118	Meredeth	Easy-to-make pancake mix with pumpkin spice flavor.	118	118
119	Robbi	Creamy, dairy-free Alfredo sauce	119	119
120	Rolando	Wi-Fi enabled plug for controlling devices from your smartphone.	120	120
121	Beverley	A calming blanket that provides gentle pressure for relaxation.	121	121
122	Babara	A zero-calorie coconut oil spray for cooking and baking.	122	122
123	Arney	Gluten-free biscuits made with almond flour.	123	123
124	Garnet	Oversized gaming mousepad with smooth surface.	124	124
125	Gillan	Roasted almonds coated in a sweet maple and cinnamon mixture.	125	125
126	Jamesy	Moist and flavorful muffins packed with fall spices and pumpkin puree.	126	126
127	Vasilis	Ceramic incense holder for a calming atmosphere.	127	127
128	Vanni	Essential attachments for pressure washing.	128	128
129	Kathrine	Noise-cancelling Bluetooth headphones for immersive sound.	129	129
130	Veronike	A creamy and tangy dressing perfect for salads or as a dipping sauce.	130	130
131	Kellby	Stylish smartwatch with fitness tracking features.	131	131
132	Perri	Indoor Wi-Fi camera for home security.	132	132
133	Mervin	Noodles tossed in a spicy Thai peanut sauce.	133	133
134	Drugi	Comfortable harness designed to keep pets safe in the car.	134	134
135	Nadine	Rich and buttery mashed potatoes with roasted garlic.	135	135
136	Gabriell	Fresh greens and veggies for a quick Asian-inspired salad.	136	136
137	Elysha	Elegant glass decanter for aerating wine.	137	137
138	Syman	Creamy yogurt made from coconut milk, dairy-free and delicious.	138	138
139	Roze	Creamy macaroni and cheese baked to perfection.	139	139
140	Ax	Convenient hooks that utilize door space for hanging items.	140	140
141	Drusilla	Frozen chicken bites coated in a honey sriracha glaze, spicy and sweet.	141	141
142	Genna	Crispy chicken bites, perfect for dipping.	142	142
143	Lynnet	Creamy ranch dressing, perfect for salads and dips.	143	143
144	Orrin	A blend of nuts, seeds, and dried fruits for snacking.	144	144
145	Darren	A flavorful sauce for stir-frying vegetables and meats.	145	145
146	Hinze	Eco-friendly LED lights for festive decorations.	146	146
147	Celestyna	8oz water bottle with built-in filter for clean drinking water.	147	147
148	Rora	Durable high-top leather boots for the stylish adventurer.	148	148
149	Lynnet	Ceramic pizza stone for homemade pizzas.	149	149
150	Anna	Wearable device to track fitness activities and heart rate.	150	150
151	Ralina	Fresh and tart organic green apples, great for snacking or baking.	151	151
152	Uriel	Warm and stylish jacket for cold weather.	152	152
153	Laurence	Cute fairy figurines to decorate your garden or potted plants.	153	153
154	Robbin	Rich spaghetti sauce, a perfect pasta sauce.	154	154
155	Burnard	Flexible molds perfect for baking cakes and pastries.	155	155
156	Olly	Natural fruit spread bursting with real strawberry flavor.	156	156
157	Andriette	Comprehensive first aid kit for home and travel.	157	157
158	Malena	Cozy faux fur blanket to add warmth and style to your home.	158	158
159	Ashlee	Stabilizing gimbal for smooth video recording.	159	159
160	Bernhard	Unsweetened coconut flakes for baking and snacking.	160	160
161	Randy	Healthy pizza crust made from cauliflower	161	161
162	Kat	Wearable device to track fitness activities and heart rate.	162	162
163	Levy	Fun kit for aspiring explorers with binoculars and a compass.	163	163
164	Allix	Lightweight backpack with an insulated water reservoir for hydration on the go.	164	164
165	Jacklin	Marinated beef strips in teriyaki sauce for easy grilling.	165	165
166	Hernando	Comfortable carrier for small pets during travel.	166	166
167	Damiano	Delicious cookies with rich chocolate flavor and a hint of mint.	167	167
168	Lotte	Satisfy your sweet tooth with these dark chocolate-covered raisins.	168	168
169	Luca	Quick-cooking couscous, great as a side or base.	169	169
170	Wanids	Convenient strap for carrying yoga mats to class.	170	170
171	Augie	Bluetooth-enabled key tracker to find lost items easily.	171	171
172	Tiffie	Frozen chicken bites coated in a honey sriracha glaze, spicy and sweet.	172	172
173	Adela	Quick and easy fried rice mixed with vegetables and soy sauce.	173	173
174	Sherwin	A smoky barbecue sauce, ideal for grilling and dipping.	174	174
175	Sidney	Rich and sweet paprika spice for seasoning.	175	175
176	Lexy	Ergonomic desk that adjusts height for standing or sitting.	176	176
177	Sileas	Marinated beef strips in teriyaki sauce for easy grilling.	177	177
178	Olivie	Versatile multi-cooker for pressure cooking and slow cooking.	178	178
179	Lyman	Set of ceramic knives for precision slicing.	179	179
180	Sterling	Soft and plush robe for comfort after the shower.	180	180
181	Deanne	Rich and smooth cold brew coffee concentrate, just add water or milk.	181	181
182	Norrie	Canned beans with chili sauce, perfect for chili dishes.	182	182
183	Mehetabel	Personalized wooden puzzles for children that encourage learning.	183	183
184	Zora	Personalized wooden puzzles for children that encourage learning.	184	184
185	Casandra	Multi-port USB-C hub for connecting devices.	185	185
186	Katrinka	Deliciously crunchy sweet potato chips, seasoned to perfection.	186	186
187	Leoine	A fitted ribbed knit dress that hugs your curves perfectly.	187	187
188	Alejandrina	Make delicious waffles with this user-friendly device.	188	188
189	Grace	Traditional Korean fermented vegetables, packed with flavor.	189	189
190	Ely	Durable toy designed for heavy chewers.	190	190
191	Gamaliel	Fresh sliced bell peppers for salads or stir-fries.	191	191
192	Farrel	Secure phone mount for your vehicle's dashboard.	192	192
193	Steffane	Healthy salad made with quinoa, almonds, and mixed greens, perfect for a light meal.	193	193
194	Cleve	All-natural skincare set for daily use.	194	194
195	Brit	Crunchy granola bars made with almond butter, oats, and honey, perfect for on-the-go snacking.	195	195
196	Elly	Essential attachments for pressure washing.	196	196
197	Nata	Craft your own lip balms with this complete kit.	197	197
198	Kakalina	Comprehensive first aid kit for home and travel.	198	198
199	Cully	Nutty-scented oil for stir-fry and marinades.	199	199
200	Myron	A delightful mix of nuts, fruit, and chocolate.	200	200
201	Janella	A zesty salsa made with peaches and mangos, great for chips.	201	201
202	Ikey	A crunchy collection of flavored kettle chips in a convenient pack.	202	202
203	Alta	A zesty salad with black beans, corn, and chipotle dressing.	203	203
204	Rogerio	Foldable mat for jigsaw puzzle assembly.	204	204
205	Alissa	Durable jump rope for cardio workouts.	205	205
206	Barbara-anne	Frozen green peas, a great addition to meals.	206	206
207	Vincents	Savory potato chips with a hint of maple sweetness and crispy bacon flavor.	207	207
208	Cyrill	Connect and control smart devices from one app.	208	208
209	Willie	Freshly roasted coffee beans with rich flavor.	209	209
210	Frederico	Creamy mayonnaise made with avocado oil for a healthier twist.	210	210
211	Tabbitha	Perfect dipping sauce or stir-fry addition for a sweet and tangy flavor.	211	211
212	Roarke	Marinated chicken breast seasoned with herbs, ready for grilling.	212	212
213	Deena	Instant miso soup mix, just add hot water for a warm meal.	213	213
214	Lorettalorna	Assorted herbal teas, perfect for a warm and relaxing drink.	214	214
215	Stace	Boost your Wi-Fi signal for better coverage.	215	215
216	Noel	Complete meal kit with everything needed to make beef stroganoff in under 30 minutes.	216	216
217	Adriaens	Nutritious bars packed with protein for energy	217	217
218	Devonna	Tangy dressing perfect for salads and marinades, with sesame and ginger flavors.	218	218
219	Ailee	Compostable plates suitable for various occasions.	219	219
220	Denys	Marinated beef strips in teriyaki sauce for easy grilling.	220	220
221	Tatiana	A hearty mix of beans in a flavorful tomato broth.	221	221
222	Leah	Organic rolled oats, great for breakfast or baking.	222	222
223	Barnabe	High-quality leather wallet with multiple compartments.	223	223
224	Tami	Comfortable pet bed for small to medium-sized dogs.	224	224
225	Aguste	A fresh, flavorful basil pesto for pasta and more	225	225
226	Calv	Multi-level cat tree for play and scratching.	226	226
227	Swen	Activity workbook for early learning and fun.	227	227
228	Quinn	A zero-calorie coconut oil spray for cooking and baking.	228	228
229	Kimberley	Color-changing smart LED bulbs compatible with Alexa.	229	229
230	Leeann	Compact wireless set for easy computer usability.	230	230
231	Brnaby	Dairy-free yogurt made from coconut milk.	231	231
232	Natalya	Electric foot massager with heat settings.	232	232
233	Darline	Savory roasted garlic in a jar for easy use.	233	233
234	Lyndy	Lightweight, expandable hoses for easy handling.	234	234
235	Caitrin	Classic cereal made with whole grains and honey.	235	235
236	Alanna	Fresh greens and veggies for a quick Asian-inspired salad.	236	236
237	Amabelle	All-in-one mix for easy homemade cheeseburgers, just add ground beef.	237	237
238	Rodrique	A savory marinade for meats, perfect for grilling.	238	238
239	Tybi	Organize coffee capsules with this stylish dispenser.	239	239
240	Tibold	Spicy ginger cookies that are crunchy and delicious.	240	240
241	Ezri	Creamy peanut butter with no added sugar or oils.	241	241
242	Myrilla	Creamy and smooth peanut butter, perfect for sandwiches.	242	242
243	Alphonso	Complete set of cooking utensils made from bamboo.	243	243
244	Sanson	Stylish smartwatch with fitness tracking features.	244	244
245	Analiese	Extra layer of comfort for your mattress.	245	245
246	Jemima	Nutritious chia seeds great for smoothies	246	246
247	Dorian	Custom keychain with engraved text.	247	247
248	Win	Beginner telescope for stargazing and exploring.	248	248
249	Jillene	A mix of carrots, peas, and corn, easy to stir-fry.	249	249
250	Shelly	Creamy mashed sweet potatoes with a hint of cinnamon.	250	250
\.


--
-- TOC entry 5459 (class 0 OID 41136)
-- Dependencies: 258
-- Data for Name: PAGOS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."PAGOS" (id_pago, id_estatus_pago, id_metodo_pago, monto, id_sucursal, id_clientes, fecha_de_pago) FROM stdin;
1	1	1	14.00	1	1	26/2/2025
2	2	2	32.00	2	2	10/2/2025
3	3	3	72.00	3	3	17/10/2024
4	4	4	35.00	4	4	22/1/2025
5	5	5	73.00	5	5	11/4/2025
6	6	6	44.00	6	6	14/12/2024
7	7	7	4.00	7	7	23/11/2024
8	8	8	27.00	8	8	30/7/2025
9	9	9	14.00	9	9	8/10/2024
10	10	10	8.00	10	10	31/8/2025
11	11	11	8.00	11	11	5/6/2025
12	12	12	71.00	12	12	19/3/2025
13	13	13	73.00	13	13	27/7/2025
14	14	14	33.00	14	14	24/2/2025
15	15	15	21.00	15	15	23/4/2025
16	16	16	64.00	16	16	25/3/2025
17	17	17	54.00	17	17	24/5/2025
18	18	18	17.00	18	18	4/9/2025
19	19	19	21.00	19	19	2/9/2025
20	20	20	76.00	20	20	27/2/2025
21	21	21	8.00	21	21	28/11/2024
22	22	22	99.00	22	22	2/8/2025
23	23	23	29.00	23	23	26/10/2024
24	24	24	20.00	24	24	27/8/2025
25	25	25	41.00	25	25	4/12/2024
26	26	26	68.00	26	26	28/4/2025
27	27	27	51.00	27	27	11/3/2025
28	28	28	14.00	28	28	5/8/2025
29	29	29	45.00	29	29	16/7/2025
30	30	30	74.00	30	30	5/6/2025
31	31	31	98.00	31	31	1/1/2025
32	32	32	25.00	32	32	15/8/2025
33	33	33	35.00	33	33	20/4/2025
34	34	34	82.00	34	34	14/10/2024
35	35	35	88.00	35	35	16/1/2025
36	36	36	70.00	36	36	3/7/2025
37	37	37	22.00	37	37	19/11/2024
38	38	38	28.00	38	38	15/3/2025
39	39	39	70.00	39	39	26/9/2025
40	40	40	61.00	40	40	7/4/2025
41	41	41	30.00	41	41	2/6/2025
42	42	42	11.00	42	42	3/1/2025
43	43	43	80.00	43	43	21/1/2025
44	44	44	33.00	44	44	20/2/2025
45	45	45	90.00	45	45	14/8/2025
46	46	46	18.00	46	46	24/5/2025
47	47	47	38.00	47	47	24/2/2025
48	48	48	47.00	48	48	17/5/2025
49	49	49	5.00	49	49	28/12/2024
50	50	50	3.00	50	50	8/2/2025
51	51	51	5.00	51	51	11/1/2025
52	52	52	47.00	52	52	28/6/2025
53	53	53	37.00	53	53	14/9/2025
54	54	54	21.00	54	54	12/5/2025
55	55	55	81.00	55	55	5/8/2025
56	56	56	6.00	56	56	11/9/2025
57	57	57	18.00	57	57	26/9/2025
58	58	58	16.00	58	58	26/11/2024
59	59	59	31.00	59	59	6/5/2025
60	60	60	97.00	60	60	26/5/2025
61	61	61	25.00	61	61	20/10/2024
62	62	62	4.00	62	62	11/5/2025
63	63	63	76.00	63	63	9/3/2025
64	64	64	1.00	64	64	16/11/2024
65	65	65	53.00	65	65	9/8/2025
66	66	66	3.00	66	66	21/8/2025
67	67	67	44.00	67	67	24/3/2025
68	68	68	97.00	68	68	30/8/2025
69	69	69	51.00	69	69	16/11/2024
70	70	70	54.00	70	70	25/3/2025
71	71	71	44.00	71	71	8/9/2025
72	72	72	24.00	72	72	10/11/2024
73	73	73	89.00	73	73	25/2/2025
74	74	74	99.00	74	74	27/1/2025
75	75	75	89.00	75	75	24/1/2025
76	76	76	29.00	76	76	25/7/2025
77	77	77	6.00	77	77	7/7/2025
78	78	78	16.00	78	78	11/6/2025
79	79	79	36.00	79	79	2/11/2024
80	80	80	28.00	80	80	23/4/2025
81	81	81	67.00	81	81	3/3/2025
82	82	82	63.00	82	82	31/1/2025
83	83	83	84.00	83	83	30/4/2025
84	84	84	92.00	84	84	7/1/2025
85	85	85	67.00	85	85	28/11/2024
86	86	86	94.00	86	86	28/5/2025
87	87	87	96.00	87	87	16/2/2025
88	88	88	12.00	88	88	5/3/2025
89	89	89	44.00	89	89	13/2/2025
90	90	90	66.00	90	90	26/4/2025
91	91	91	84.00	91	91	13/11/2024
92	92	92	22.00	92	92	12/5/2025
93	93	93	7.00	93	93	4/2/2025
94	94	94	71.00	94	94	8/8/2025
95	95	95	26.00	95	95	3/2/2025
96	96	96	69.00	96	96	20/12/2024
97	97	97	75.00	97	97	22/1/2025
98	98	98	67.00	98	98	14/11/2024
99	99	99	18.00	99	99	7/1/2025
100	100	100	33.00	100	100	31/7/2025
101	101	101	50.00	101	101	1/6/2025
102	102	102	53.00	102	102	8/11/2024
103	103	103	21.00	103	103	18/1/2025
104	104	104	16.00	104	104	23/9/2025
105	105	105	4.00	105	105	22/8/2025
106	106	106	68.00	106	106	15/9/2025
107	107	107	79.00	107	107	19/7/2025
108	108	108	60.00	108	108	29/12/2024
109	109	109	45.00	109	109	23/9/2025
110	110	110	97.00	110	110	9/3/2025
111	111	111	12.00	111	111	23/10/2024
112	112	112	51.00	112	112	24/1/2025
113	113	113	59.00	113	113	12/8/2025
114	114	114	91.00	114	114	13/7/2025
115	115	115	4.00	115	115	21/11/2024
116	116	116	57.00	116	116	14/5/2025
117	117	117	83.00	117	117	21/12/2024
118	118	118	56.00	118	118	30/10/2024
119	119	119	34.00	119	119	13/12/2024
120	120	120	57.00	120	120	11/1/2025
121	121	121	3.00	121	121	23/7/2025
122	122	122	49.00	122	122	6/7/2025
123	123	123	42.00	123	123	20/4/2025
124	124	124	46.00	124	124	18/6/2025
125	125	125	13.00	125	125	23/3/2025
126	126	126	17.00	126	126	14/8/2025
127	127	127	41.00	127	127	2/11/2024
128	128	128	81.00	128	128	8/1/2025
129	129	129	1.00	129	129	1/4/2025
130	130	130	73.00	130	130	10/7/2025
131	131	131	78.00	131	131	5/2/2025
132	132	132	51.00	132	132	25/11/2024
133	133	133	54.00	133	133	6/3/2025
134	134	134	40.00	134	134	11/2/2025
135	135	135	85.00	135	135	24/7/2025
136	136	136	93.00	136	136	14/4/2025
137	137	137	31.00	137	137	10/7/2025
138	138	138	53.00	138	138	11/10/2024
139	139	139	17.00	139	139	8/5/2025
140	140	140	98.00	140	140	6/10/2024
141	141	141	96.00	141	141	10/12/2024
142	142	142	99.00	142	142	11/9/2025
143	143	143	90.00	143	143	8/11/2024
144	144	144	74.00	144	144	31/8/2025
145	145	145	78.00	145	145	8/2/2025
146	146	146	72.00	146	146	31/12/2024
147	147	147	22.00	147	147	20/9/2025
148	148	148	12.00	148	148	16/4/2025
149	149	149	20.00	149	149	24/3/2025
150	150	150	42.00	150	150	8/2/2025
151	151	151	67.00	151	151	20/3/2025
152	152	152	94.00	152	152	10/8/2025
153	153	153	48.00	153	153	24/9/2025
154	154	154	9.00	154	154	5/1/2025
155	155	155	52.00	155	155	13/12/2024
156	156	156	49.00	156	156	30/7/2025
157	157	157	47.00	157	157	13/9/2025
158	158	158	29.00	158	158	25/9/2025
159	159	159	81.00	159	159	16/2/2025
160	160	160	43.00	160	160	21/11/2024
161	161	161	81.00	161	161	15/9/2025
162	162	162	16.00	162	162	6/6/2025
163	163	163	90.00	163	163	12/2/2025
164	164	164	16.00	164	164	26/2/2025
165	165	165	53.00	165	165	21/5/2025
166	166	166	18.00	166	166	27/10/2024
167	167	167	68.00	167	167	27/6/2025
168	168	168	30.00	168	168	26/2/2025
169	169	169	49.00	169	169	10/1/2025
170	170	170	41.00	170	170	15/3/2025
171	171	171	50.00	171	171	10/1/2025
172	172	172	71.00	172	172	5/5/2025
173	173	173	89.00	173	173	24/3/2025
174	174	174	17.00	174	174	22/2/2025
175	175	175	62.00	175	175	28/10/2024
176	176	176	38.00	176	176	13/3/2025
177	177	177	90.00	177	177	9/10/2024
178	178	178	61.00	178	178	14/1/2025
179	179	179	16.00	179	179	4/6/2025
180	180	180	78.00	180	180	27/5/2025
181	181	181	80.00	181	181	20/7/2025
182	182	182	35.00	182	182	10/7/2025
183	183	183	59.00	183	183	4/9/2025
184	184	184	87.00	184	184	13/2/2025
185	185	185	28.00	185	185	23/8/2025
186	186	186	5.00	186	186	6/3/2025
187	187	187	24.00	187	187	6/6/2025
188	188	188	62.00	188	188	19/7/2025
189	189	189	60.00	189	189	13/12/2024
190	190	190	17.00	190	190	22/7/2025
191	191	191	12.00	191	191	22/11/2024
192	192	192	42.00	192	192	30/10/2024
193	193	193	34.00	193	193	28/1/2025
194	194	194	96.00	194	194	28/10/2024
195	195	195	49.00	195	195	23/8/2025
196	196	196	28.00	196	196	27/6/2025
197	197	197	51.00	197	197	2/7/2025
198	198	198	54.00	198	198	6/11/2024
199	199	199	69.00	199	199	18/11/2024
200	200	200	44.00	200	200	12/9/2025
201	201	201	5.00	201	201	9/11/2024
202	202	202	75.00	202	202	20/9/2025
203	203	203	47.00	203	203	23/12/2024
204	204	204	96.00	204	204	4/11/2024
205	205	205	74.00	205	205	18/5/2025
206	206	206	22.00	206	206	24/9/2025
207	207	207	42.00	207	207	12/3/2025
208	208	208	28.00	208	208	19/2/2025
209	209	209	54.00	209	209	25/9/2025
210	210	210	22.00	210	210	25/5/2025
211	211	211	53.00	211	211	4/2/2025
212	212	212	28.00	212	212	31/7/2025
213	213	213	52.00	213	213	10/8/2025
214	214	214	96.00	214	214	6/5/2025
215	215	215	23.00	215	215	7/7/2025
216	216	216	58.00	216	216	23/1/2025
217	217	217	68.00	217	217	19/3/2025
218	218	218	80.00	218	218	13/11/2024
219	219	219	5.00	219	219	23/4/2025
220	220	220	30.00	220	220	31/8/2025
221	221	221	87.00	221	221	20/10/2024
222	222	222	57.00	222	222	15/3/2025
223	223	223	31.00	223	223	28/4/2025
224	224	224	65.00	224	224	29/7/2025
225	225	225	1.00	225	225	10/8/2025
226	226	226	16.00	226	226	18/1/2025
227	227	227	53.00	227	227	9/12/2024
228	228	228	65.00	228	228	14/7/2025
229	229	229	51.00	229	229	19/1/2025
230	230	230	70.00	230	230	4/1/2025
231	231	231	77.00	231	231	6/9/2025
232	232	232	84.00	232	232	17/7/2025
233	233	233	42.00	233	233	19/5/2025
234	234	234	58.00	234	234	27/10/2024
235	235	235	75.00	235	235	3/7/2025
236	236	236	81.00	236	236	5/5/2025
237	237	237	18.00	237	237	26/8/2025
238	238	238	10.00	238	238	28/2/2025
239	239	239	62.00	239	239	24/12/2024
240	240	240	98.00	240	240	10/6/2025
241	241	241	57.00	241	241	24/9/2025
242	242	242	92.00	242	242	30/10/2024
243	243	243	11.00	243	243	15/1/2025
244	244	244	32.00	244	244	12/7/2025
245	245	245	3.00	245	245	12/2/2025
246	246	246	21.00	246	246	9/10/2024
247	247	247	4.00	247	247	17/8/2025
248	248	248	14.00	248	248	23/9/2025
249	249	249	8.00	249	249	5/11/2024
250	250	250	72.00	250	250	21/11/2024
\.


--
-- TOC entry 5460 (class 0 OID 41139)
-- Dependencies: 259
-- Data for Name: PEDIDO_PROVEEDOR; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."PEDIDO_PROVEEDOR" (id_pedido_proveedor, fecha_pedido, fecha_entrega, estado, total) FROM stdin;
1	2025-09-17 00:00:00-06	2025-01-04 00:00:00-06	BMW	62
2	2025-02-06 00:00:00-06	2025-05-09 00:00:00-06	Ford	96
3	2025-09-20 00:00:00-06	2025-04-18 00:00:00-06	Volkswagen	60
4	2024-10-11 00:00:00-06	2025-05-19 00:00:00-06	Ford	25
5	2025-09-08 00:00:00-06	2024-10-16 00:00:00-06	Toyota	40
6	2024-10-24 00:00:00-06	2024-11-03 00:00:00-06	Nissan	3
7	2025-03-14 00:00:00-06	2025-08-16 00:00:00-06	Jaguar	93
8	2025-01-10 00:00:00-06	2024-11-06 00:00:00-06	Jaguar	25
9	2024-11-23 00:00:00-06	2025-04-24 00:00:00-06	Mercedes-Benz	30
10	2025-01-08 00:00:00-06	2025-07-31 00:00:00-06	Geo	49
11	2025-09-26 00:00:00-06	2025-02-11 00:00:00-06	Chevrolet	32
12	2024-12-07 00:00:00-06	2025-07-16 00:00:00-06	Nissan	83
13	2025-09-19 00:00:00-06	2025-01-24 00:00:00-06	Porsche	19
14	2025-03-12 00:00:00-06	2025-07-23 00:00:00-06	Buick	71
15	2024-11-05 00:00:00-06	2024-12-23 00:00:00-06	Toyota	59
16	2025-04-10 00:00:00-06	2025-08-05 00:00:00-06	BMW	34
17	2025-02-24 00:00:00-06	2025-01-12 00:00:00-06	Saab	12
18	2025-06-01 00:00:00-06	2025-09-14 00:00:00-06	Volkswagen	57
19	2025-06-21 00:00:00-06	2025-04-19 00:00:00-06	Mercedes-Benz	37
20	2024-11-06 00:00:00-06	2025-05-09 00:00:00-06	Mazda	2
21	2025-03-15 00:00:00-06	2025-08-12 00:00:00-06	Dodge	28
22	2025-03-16 00:00:00-06	2025-06-24 00:00:00-06	Mitsubishi	34
23	2025-04-29 00:00:00-06	2024-09-30 00:00:00-06	Mercury	16
24	2025-04-23 00:00:00-06	2025-08-03 00:00:00-06	Studebaker	91
25	2025-07-20 00:00:00-06	2025-04-01 00:00:00-06	Toyota	68
26	2025-02-26 00:00:00-06	2025-04-28 00:00:00-06	Pontiac	29
27	2024-12-28 00:00:00-06	2025-04-26 00:00:00-06	BMW	46
28	2024-11-22 00:00:00-06	2025-09-11 00:00:00-06	Mercedes-Benz	90
29	2025-08-24 00:00:00-06	2025-02-14 00:00:00-06	Lexus	48
30	2025-06-13 00:00:00-06	2025-09-14 00:00:00-06	Ford	72
31	2025-06-07 00:00:00-06	2025-05-19 00:00:00-06	Subaru	48
32	2025-07-03 00:00:00-06	2025-04-07 00:00:00-06	GMC	8
33	2025-02-23 00:00:00-06	2025-02-20 00:00:00-06	BMW	11
34	2025-02-28 00:00:00-06	2025-07-05 00:00:00-06	Suzuki	44
35	2025-03-16 00:00:00-06	2025-02-04 00:00:00-06	Mercedes-Benz	41
36	2024-11-05 00:00:00-06	2025-09-24 00:00:00-06	Pontiac	61
37	2025-05-09 00:00:00-06	2025-04-15 00:00:00-06	Volkswagen	44
38	2024-11-28 00:00:00-06	2025-04-24 00:00:00-06	Dodge	49
39	2025-04-06 00:00:00-06	2025-05-15 00:00:00-06	Chevrolet	70
40	2024-10-06 00:00:00-06	2025-08-02 00:00:00-06	Dodge	31
41	2024-11-17 00:00:00-06	2025-01-17 00:00:00-06	Dodge	51
42	2025-04-21 00:00:00-06	2024-12-26 00:00:00-06	BMW	88
43	2024-10-26 00:00:00-06	2025-04-07 00:00:00-06	Ford	30
44	2025-05-16 00:00:00-06	2025-07-31 00:00:00-06	Lincoln	83
45	2025-07-02 00:00:00-06	2024-10-18 00:00:00-06	Pontiac	13
46	2025-07-13 00:00:00-06	2025-07-26 00:00:00-06	Chevrolet	97
47	2025-01-06 00:00:00-06	2024-11-17 00:00:00-06	Toyota	20
48	2025-05-06 00:00:00-06	2024-12-28 00:00:00-06	Pontiac	11
49	2025-04-04 00:00:00-06	2024-12-17 00:00:00-06	Mercedes-Benz	22
50	2024-12-21 00:00:00-06	2025-05-16 00:00:00-06	Toyota	63
51	2025-03-14 00:00:00-06	2025-07-17 00:00:00-06	Chevrolet	18
52	2025-08-01 00:00:00-06	2025-01-01 00:00:00-06	Mazda	85
53	2025-08-16 00:00:00-06	2024-12-28 00:00:00-06	Ford	75
54	2024-10-27 00:00:00-06	2025-06-02 00:00:00-06	Citroën	19
55	2025-08-04 00:00:00-06	2025-06-03 00:00:00-06	Jeep	84
56	2024-10-04 00:00:00-06	2025-06-24 00:00:00-06	MINI	5
57	2025-09-14 00:00:00-06	2025-09-20 00:00:00-06	Eagle	8
58	2025-07-29 00:00:00-06	2025-05-06 00:00:00-06	Kia	63
59	2025-02-03 00:00:00-06	2024-12-22 00:00:00-06	Aston Martin	16
60	2025-09-03 00:00:00-06	2025-04-08 00:00:00-06	Mercedes-Benz	48
61	2025-01-25 00:00:00-06	2025-06-30 00:00:00-06	Mitsubishi	18
62	2025-05-26 00:00:00-06	2025-02-24 00:00:00-06	Infiniti	41
63	2025-03-18 00:00:00-06	2024-10-22 00:00:00-06	Mazda	70
64	2024-11-29 00:00:00-06	2024-12-28 00:00:00-06	Mercedes-Benz	91
65	2024-11-06 00:00:00-06	2025-09-02 00:00:00-06	Lotus	87
66	2025-09-24 00:00:00-06	2025-06-19 00:00:00-06	Volkswagen	18
67	2025-01-29 00:00:00-06	2024-12-05 00:00:00-06	Acura	53
68	2025-04-30 00:00:00-06	2024-10-09 00:00:00-06	Volkswagen	85
69	2024-11-19 00:00:00-06	2024-12-17 00:00:00-06	Mitsubishi	12
70	2025-02-05 00:00:00-06	2025-05-13 00:00:00-06	Suzuki	62
71	2024-10-12 00:00:00-06	2025-03-26 00:00:00-06	Pontiac	76
72	2025-01-13 00:00:00-06	2025-07-09 00:00:00-06	Toyota	17
73	2025-08-17 00:00:00-06	2025-02-17 00:00:00-06	Lincoln	65
74	2024-09-29 00:00:00-06	2025-01-22 00:00:00-06	Ford	55
75	2025-08-20 00:00:00-06	2025-08-10 00:00:00-06	Toyota	85
76	2025-09-05 00:00:00-06	2024-11-12 00:00:00-06	Land Rover	31
77	2024-11-20 00:00:00-06	2025-05-01 00:00:00-06	Chevrolet	30
78	2025-05-26 00:00:00-06	2025-08-11 00:00:00-06	Lexus	30
79	2024-11-22 00:00:00-06	2024-12-10 00:00:00-06	Honda	29
80	2025-01-18 00:00:00-06	2024-10-28 00:00:00-06	Ferrari	12
81	2025-02-25 00:00:00-06	2024-10-11 00:00:00-06	Volkswagen	98
82	2024-10-25 00:00:00-06	2024-10-23 00:00:00-06	GMC	54
83	2025-02-26 00:00:00-06	2025-04-29 00:00:00-06	MINI	15
84	2025-02-01 00:00:00-06	2024-10-06 00:00:00-06	Jeep	34
85	2024-12-11 00:00:00-06	2025-01-18 00:00:00-06	Cadillac	45
86	2025-04-07 00:00:00-06	2025-07-18 00:00:00-06	Nissan	52
87	2024-10-15 00:00:00-06	2025-03-19 00:00:00-06	Chrysler	28
88	2025-02-08 00:00:00-06	2024-12-19 00:00:00-06	Ford	42
89	2025-06-23 00:00:00-06	2024-10-16 00:00:00-06	GMC	1
90	2024-12-01 00:00:00-06	2024-09-28 00:00:00-06	GMC	74
91	2025-06-04 00:00:00-06	2025-04-16 00:00:00-06	BMW	33
92	2025-09-23 00:00:00-06	2025-05-18 00:00:00-06	Audi	81
93	2025-05-27 00:00:00-06	2025-02-22 00:00:00-06	GMC	47
94	2025-03-13 00:00:00-06	2024-10-17 00:00:00-06	Chevrolet	73
95	2024-10-05 00:00:00-06	2024-11-20 00:00:00-06	Kia	32
96	2025-01-09 00:00:00-06	2025-01-27 00:00:00-06	Buick	36
97	2025-09-20 00:00:00-06	2024-10-12 00:00:00-06	Ford	61
98	2025-05-10 00:00:00-06	2024-09-28 00:00:00-06	Pontiac	11
99	2025-04-25 00:00:00-06	2025-08-16 00:00:00-06	Mitsubishi	53
100	2025-09-21 00:00:00-06	2024-10-20 00:00:00-06	Audi	8
101	2025-03-22 00:00:00-06	2025-09-26 00:00:00-06	Infiniti	45
102	2024-10-03 00:00:00-06	2025-06-03 00:00:00-06	Dodge	7
103	2025-04-29 00:00:00-06	2025-08-05 00:00:00-06	Maybach	22
104	2024-12-18 00:00:00-06	2025-03-03 00:00:00-06	Toyota	22
105	2025-06-15 00:00:00-06	2025-02-22 00:00:00-06	Chevrolet	68
106	2025-09-05 00:00:00-06	2025-08-31 00:00:00-06	Lexus	47
107	2025-02-03 00:00:00-06	2025-02-16 00:00:00-06	Land Rover	53
108	2025-01-24 00:00:00-06	2024-11-30 00:00:00-06	Mitsubishi	6
109	2024-11-02 00:00:00-06	2025-08-11 00:00:00-06	Mercury	49
110	2025-02-15 00:00:00-06	2024-11-26 00:00:00-06	Dodge	19
111	2025-09-25 00:00:00-06	2025-07-25 00:00:00-06	Pontiac	5
112	2025-05-29 00:00:00-06	2025-06-21 00:00:00-06	Lincoln	75
113	2025-05-02 00:00:00-06	2025-07-11 00:00:00-06	Dodge	23
114	2024-11-03 00:00:00-06	2025-08-15 00:00:00-06	Chevrolet	12
115	2025-03-01 00:00:00-06	2025-05-18 00:00:00-06	Mitsubishi	53
116	2025-08-10 00:00:00-06	2025-06-07 00:00:00-06	Ford	98
117	2024-10-06 00:00:00-06	2025-01-20 00:00:00-06	Chevrolet	33
118	2025-06-21 00:00:00-06	2025-08-01 00:00:00-06	Pontiac	39
119	2024-12-04 00:00:00-06	2025-08-12 00:00:00-06	Ford	20
120	2025-06-25 00:00:00-06	2025-04-28 00:00:00-06	Chevrolet	66
121	2025-03-30 00:00:00-06	2025-09-16 00:00:00-06	Cadillac	16
122	2025-08-20 00:00:00-06	2024-12-29 00:00:00-06	Volkswagen	76
123	2024-10-31 00:00:00-06	2025-08-20 00:00:00-06	Mitsubishi	70
124	2024-12-08 00:00:00-06	2024-10-15 00:00:00-06	Hyundai	23
125	2025-08-18 00:00:00-06	2025-07-02 00:00:00-06	Mitsubishi	1
126	2025-09-03 00:00:00-06	2025-01-25 00:00:00-06	Mitsubishi	99
127	2025-03-26 00:00:00-06	2025-07-26 00:00:00-06	GMC	53
128	2025-02-20 00:00:00-06	2024-10-19 00:00:00-06	GMC	3
129	2025-05-28 00:00:00-06	2024-10-04 00:00:00-06	Buick	30
130	2025-09-07 00:00:00-06	2024-11-07 00:00:00-06	Aston Martin	10
131	2025-04-26 00:00:00-06	2025-07-18 00:00:00-06	Mazda	38
132	2025-06-06 00:00:00-06	2025-01-05 00:00:00-06	Mercury	37
133	2025-07-08 00:00:00-06	2024-10-28 00:00:00-06	Ford	72
134	2025-07-29 00:00:00-06	2025-08-29 00:00:00-06	Dodge	24
135	2025-03-19 00:00:00-06	2025-05-03 00:00:00-06	Nissan	20
136	2025-02-27 00:00:00-06	2025-07-03 00:00:00-06	GMC	71
137	2025-07-07 00:00:00-06	2024-11-15 00:00:00-06	Volkswagen	35
138	2025-03-07 00:00:00-06	2025-06-02 00:00:00-06	Chevrolet	86
139	2025-07-20 00:00:00-06	2025-02-02 00:00:00-06	Hyundai	7
140	2025-06-03 00:00:00-06	2025-04-25 00:00:00-06	Chevrolet	34
141	2025-01-18 00:00:00-06	2025-02-14 00:00:00-06	Isuzu	1
142	2025-07-10 00:00:00-06	2024-10-25 00:00:00-06	Ford	92
143	2025-06-30 00:00:00-06	2025-03-26 00:00:00-06	Mercedes-Benz	90
144	2024-11-19 00:00:00-06	2025-06-27 00:00:00-06	Acura	91
145	2025-03-30 00:00:00-06	2025-03-26 00:00:00-06	Ford	69
146	2025-05-26 00:00:00-06	2025-03-10 00:00:00-06	Ford	61
147	2025-08-20 00:00:00-06	2024-12-06 00:00:00-06	Lexus	45
148	2025-07-18 00:00:00-06	2025-03-29 00:00:00-06	GMC	28
149	2025-05-04 00:00:00-06	2025-02-05 00:00:00-06	Ford	40
150	2024-11-23 00:00:00-06	2025-07-17 00:00:00-06	Porsche	4
151	2025-01-09 00:00:00-06	2025-01-14 00:00:00-06	Ford	9
152	2024-12-01 00:00:00-06	2024-11-25 00:00:00-06	Hyundai	23
153	2025-04-04 00:00:00-06	2025-01-11 00:00:00-06	Jeep	79
154	2025-09-20 00:00:00-06	2025-01-21 00:00:00-06	GMC	14
155	2025-02-24 00:00:00-06	2024-11-13 00:00:00-06	Porsche	15
156	2025-03-17 00:00:00-06	2025-04-27 00:00:00-06	Jeep	68
157	2025-02-18 00:00:00-06	2025-05-22 00:00:00-06	Dodge	84
158	2024-11-11 00:00:00-06	2024-11-19 00:00:00-06	Austin	25
159	2025-05-07 00:00:00-06	2025-01-29 00:00:00-06	Chevrolet	17
160	2025-05-10 00:00:00-06	2025-06-17 00:00:00-06	Honda	12
161	2025-04-15 00:00:00-06	2025-03-25 00:00:00-06	Chevrolet	63
162	2025-04-17 00:00:00-06	2024-10-17 00:00:00-06	Mercedes-Benz	23
163	2025-03-20 00:00:00-06	2025-05-20 00:00:00-06	Chevrolet	70
164	2025-08-09 00:00:00-06	2025-07-22 00:00:00-06	Lincoln	80
165	2025-08-03 00:00:00-06	2024-11-03 00:00:00-06	BMW	87
166	2024-11-08 00:00:00-06	2025-02-22 00:00:00-06	Suzuki	71
167	2025-05-14 00:00:00-06	2025-02-19 00:00:00-06	Mazda	45
168	2025-08-22 00:00:00-06	2025-04-08 00:00:00-06	Audi	19
169	2025-02-22 00:00:00-06	2025-02-24 00:00:00-06	Ford	77
170	2024-10-04 00:00:00-06	2024-12-12 00:00:00-06	Mazda	24
171	2025-03-14 00:00:00-06	2025-09-05 00:00:00-06	Pontiac	61
172	2025-05-30 00:00:00-06	2025-06-28 00:00:00-06	Volvo	19
173	2025-06-11 00:00:00-06	2025-07-26 00:00:00-06	Infiniti	36
174	2025-08-18 00:00:00-06	2025-07-23 00:00:00-06	Aston Martin	91
175	2025-01-21 00:00:00-06	2025-01-21 00:00:00-06	Hyundai	54
176	2025-02-15 00:00:00-06	2024-12-03 00:00:00-06	Mercedes-Benz	70
177	2025-08-14 00:00:00-06	2025-07-03 00:00:00-06	Mazda	28
178	2024-11-01 00:00:00-06	2025-07-24 00:00:00-06	Pontiac	89
179	2025-04-30 00:00:00-06	2025-08-02 00:00:00-06	Honda	31
180	2025-09-08 00:00:00-06	2025-06-29 00:00:00-06	Corbin	10
181	2025-03-22 00:00:00-06	2025-06-23 00:00:00-06	Ford	83
182	2025-02-12 00:00:00-06	2024-10-26 00:00:00-06	Mitsubishi	1
183	2025-05-28 00:00:00-06	2025-05-13 00:00:00-06	Cadillac	98
184	2025-03-21 00:00:00-06	2025-02-07 00:00:00-06	Lincoln	66
185	2025-03-29 00:00:00-06	2024-12-03 00:00:00-06	Saab	62
186	2025-05-04 00:00:00-06	2025-07-20 00:00:00-06	Chevrolet	89
187	2025-02-23 00:00:00-06	2025-08-18 00:00:00-06	Volvo	39
188	2025-01-07 00:00:00-06	2024-12-20 00:00:00-06	Land Rover	9
189	2025-04-28 00:00:00-06	2025-03-26 00:00:00-06	Honda	81
190	2025-08-22 00:00:00-06	2025-04-03 00:00:00-06	Chrysler	5
191	2025-02-09 00:00:00-06	2025-09-07 00:00:00-06	Land Rover	4
192	2025-08-21 00:00:00-06	2025-08-16 00:00:00-06	Ford	30
193	2025-03-10 00:00:00-06	2024-10-05 00:00:00-06	Acura	49
194	2024-12-23 00:00:00-06	2025-07-15 00:00:00-06	Ford	53
195	2024-09-28 00:00:00-06	2025-09-09 00:00:00-06	Volkswagen	88
196	2025-03-09 00:00:00-06	2024-11-15 00:00:00-06	Nissan	62
197	2025-03-23 00:00:00-06	2024-10-20 00:00:00-06	Mercedes-Benz	44
198	2025-07-15 00:00:00-06	2025-09-16 00:00:00-06	Ford	24
199	2025-05-15 00:00:00-06	2025-07-01 00:00:00-06	Lexus	48
200	2025-08-29 00:00:00-06	2025-05-08 00:00:00-06	Saab	52
201	2025-06-23 00:00:00-06	2024-10-01 00:00:00-06	Cadillac	49
202	2025-07-24 00:00:00-06	2025-08-21 00:00:00-06	Ford	95
203	2025-03-25 00:00:00-06	2025-01-26 00:00:00-06	Lincoln	20
204	2025-08-11 00:00:00-06	2025-02-15 00:00:00-06	Jaguar	48
205	2025-07-13 00:00:00-06	2025-04-30 00:00:00-06	Dodge	78
206	2024-10-17 00:00:00-06	2024-12-08 00:00:00-06	Ford	54
207	2025-06-17 00:00:00-06	2024-11-20 00:00:00-06	Ford	87
208	2024-10-11 00:00:00-06	2025-02-24 00:00:00-06	Mazda	37
209	2025-06-21 00:00:00-06	2025-01-29 00:00:00-06	BMW	14
210	2025-09-24 00:00:00-06	2024-11-20 00:00:00-06	Hyundai	4
211	2025-02-21 00:00:00-06	2024-12-29 00:00:00-06	Mercedes-Benz	89
212	2025-01-20 00:00:00-06	2024-12-30 00:00:00-06	Ford	67
213	2024-10-03 00:00:00-06	2025-01-24 00:00:00-06	Jaguar	22
214	2025-07-24 00:00:00-06	2024-12-26 00:00:00-06	Pontiac	29
215	2024-10-16 00:00:00-06	2024-12-22 00:00:00-06	Toyota	63
216	2025-06-26 00:00:00-06	2025-03-12 00:00:00-06	Land Rover	6
217	2025-01-25 00:00:00-06	2025-03-17 00:00:00-06	Ford	51
218	2025-06-28 00:00:00-06	2024-12-02 00:00:00-06	Mazda	63
219	2025-07-12 00:00:00-06	2025-02-02 00:00:00-06	GMC	75
220	2025-02-24 00:00:00-06	2025-08-16 00:00:00-06	Volkswagen	66
221	2024-11-27 00:00:00-06	2024-10-12 00:00:00-06	Volkswagen	50
222	2025-04-15 00:00:00-06	2025-05-29 00:00:00-06	Daewoo	82
223	2025-03-02 00:00:00-06	2025-08-27 00:00:00-06	Volvo	14
224	2024-11-04 00:00:00-06	2025-09-21 00:00:00-06	Subaru	95
225	2025-08-26 00:00:00-06	2025-05-13 00:00:00-06	Buick	80
226	2024-11-24 00:00:00-06	2025-02-04 00:00:00-06	Ford	1
227	2025-04-08 00:00:00-06	2024-12-10 00:00:00-06	Suzuki	75
228	2025-08-24 00:00:00-06	2024-12-30 00:00:00-06	Honda	77
229	2025-03-02 00:00:00-06	2025-06-19 00:00:00-06	Isuzu	48
230	2025-09-03 00:00:00-06	2025-01-20 00:00:00-06	Isuzu	77
231	2024-11-16 00:00:00-06	2025-07-16 00:00:00-06	Nissan	14
232	2025-02-14 00:00:00-06	2025-02-22 00:00:00-06	Jensen	36
233	2025-01-13 00:00:00-06	2025-01-15 00:00:00-06	Ford	56
234	2024-10-27 00:00:00-06	2024-11-15 00:00:00-06	Ford	59
235	2025-06-27 00:00:00-06	2024-11-26 00:00:00-06	BMW	96
236	2025-08-04 00:00:00-06	2024-10-16 00:00:00-06	GMC	38
237	2025-01-15 00:00:00-06	2025-08-25 00:00:00-06	Chrysler	20
238	2025-06-15 00:00:00-06	2025-06-01 00:00:00-06	Mitsubishi	46
239	2025-04-15 00:00:00-06	2025-06-18 00:00:00-06	BMW	64
240	2025-07-16 00:00:00-06	2024-10-16 00:00:00-06	Volvo	88
241	2024-09-28 00:00:00-06	2025-08-18 00:00:00-06	GMC	55
242	2025-06-03 00:00:00-06	2024-12-03 00:00:00-06	Land Rover	80
243	2025-01-27 00:00:00-06	2025-09-23 00:00:00-06	Plymouth	67
244	2025-06-30 00:00:00-06	2025-05-21 00:00:00-06	Maybach	46
245	2025-03-08 00:00:00-06	2025-01-14 00:00:00-06	Chevrolet	3
246	2025-04-28 00:00:00-06	2025-04-12 00:00:00-06	Mercury	1
247	2025-09-12 00:00:00-06	2024-10-09 00:00:00-06	Volkswagen	64
248	2025-09-14 00:00:00-06	2025-01-08 00:00:00-06	Jaguar	49
249	2025-05-13 00:00:00-06	2025-04-17 00:00:00-06	Chrysler	53
250	2025-09-20 00:00:00-06	2025-08-15 00:00:00-06	Maybach	65
\.


--
-- TOC entry 5462 (class 0 OID 41143)
-- Dependencies: 261
-- Data for Name: PROMOCIONES; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."PROMOCIONES" (id_promocion, nombre_promocion, descripcion, tipo_promocion, id_sucursal) FROM stdin;
1	Akutan	Creamy mashed sweet potatoes with a hint of cinnamon.	Chichester	1
2	Guadalajara	Soft cotton pajama set for cozy nights in.	Durazno	2
3	Stebbins	Sweet and spicy salsa made with fresh peaches.	Durban	3
4	Ust-Kut	Freshly baked whole wheat bread, rich in fiber.	Thule	4
5	St. Petersburg	Soft and cozy bathrobe perfect for relaxing at home.	\N	5
6	Bathurst	Creamy vegan dressing made with cashews, perfect for salads.	Eldoret	6
7	Coral Harbour	Lean and versatile ground turkey, perfect for various dishes.	Vatry	7
8	Lyons	Sweet and tangy honey mustard dip for snacks.	Wajima	8
9	\N	Supportive yoga wheel for deep stretching and balance.	Wick	9
10	\N	Stream HD video wirelessly from devices to TV.	Patos De Minas	10
11	Lhok Seumawe-Sumatra Island	Savory sausage with a blend of spices, perfect for pasta dishes.	Liboi	11
12	Kuala Terengganu	A flowy maxi dress perfect for both casual and semi-formal occasions.	\N	12
13	\N	Fun light that creates a disco atmosphere for parties.	Awar	13
14	Dillon	Custom engraved ID tags for pets with your contact information.	Allahabad	14
15	Aba	Durable speaker designed for outdoor use with water resistance.	\N	15
16	Sawan	Magnetic puzzle assembly board for kids.	Colonia Catriel	16
17	Foley	Compact keyboard for tablets and smartphones.	Dortmund	17
18	Norwood	Essential kit for taking care of your pets' health emergencies.	Wuhai	18
19	Akure	Supportive pillow designed for a good night's sleep.	Buochs	19
20	Ua Pou	Delicate green tea leaves for a refreshing beverage.	Caquetania	20
21	Prospect Creek	Convenient dispenser for dog waste bags on walks.	\N	21
22	Kayseri	Protects car interior from sun damage and heat.	Taldy Kurgan	22
23	Forlì (FC)	Eco-friendly bamboo toothbrush for sustainable living.	Ust-Tsylma	23
24	River Cess	A zesty seasoning for meats and vegetables	Rørvik	24
25	Hattiesburg	Automated cleaning robot for hassle-free home maintenance.	Hīt	25
26	Kirensk	Polarized sunglasses with UV protection.	Soesterberg	26
27	Atikokan	Cozy oversized sweater perfect for chilly days with a textured knit design.	Mitzic	27
28	Antlers	Soft and cozy bathrobe perfect for relaxing at home.	Las Vegas	28
29	Pelotas	Crispy sweet potato fries, perfectly seasoned and baked to perfection.	Cache Creek	29
30	Glendive	Everything you need for a fresh and delicious Caesar salad.	Vicenza	30
31	\N	Ready-to-bake cinnamon roll dough for easy breakfasts.	Longreach	31
32	Mongo	Adjustable weighted jump rope for workouts.	Bangor	32
33	Miami	A light and breezy top ideal for warm days.	Bainyik	33
34	Cincinnati	Delicious dark chocolate cups filled with creamy peanut butter.	Aydın	34
35	Port Mathurin	Creamy mayonnaise, perfect for salads and sandwiches.	Ellisras	35
36	Djibo	Eco-friendly soy candles with a variety of scents.	OZ Minerals Prominent Hill Mine	36
37	Maracay	Sand-resistant and compact for outdoor and beach use.	Jambi-Sumatra Island	37
38	Bhadrapur	Lightweight hair dryer with multiple speed settings.	Veracruz	38
39	Port Alberni	Floating bookshelf to display your favorite books.	Arapahoe	39
40	Carnot	A spicy marinade perfect for chicken and fish.	Hartley Bay	40
41	Ihu	Cozy throw blanket perfect for adding warmth to your home.	\N	41
42	Cabo Frio	A comforting soup filled with chicken and noodles in broth.	Birch Creek	42
43	Montepuez	Electric indoor grill for quick meals.	Kashechewan	43
44	Casa Grande	Fun robot that engages kids with games and activities.	Tuxekan Island	44
45	Menyamya	Salty pretzels filled with creamy peanut butter.	Hyvinkää	45
46	Koingnaas	Hands-on experience with science and engineering projects.	Torwood	46
47	West Malling	Delicious and hearty black beans, great for soups or salads.	Los Menucos	47
48	El Monte	Sweet and tender peach slices preserved in syrup, great for desserts.	Chefornak	48
49	Gelephu	Healthy energy bites made with oats and natural sweeteners.	Slayton	49
50	Ishigaki	A stunning lace dress perfect for special occasions.	Bamiyan	50
51	Okoyo	Creamy hummus with a kick of spice, great for dipping.	Tatitlek	51
52	Timmins	A light and tangy dressing with poppy seeds, perfect for salads.	Aurillac	52
53	Cairo	Easy mix for making spicy beef tacos.	Zunyi	53
54	Las Vegas	Spicy chili sauce with garlic and sugar for a flavor kick.	São Borja	54
55	St Paul	Wi-Fi camera with motion detection for home security.	\N	55
56	Impfondo	Portable folding camping chair with cup holder.	Goshen	56
57	Daly Waters	Mild cheese great for sandwiches.	Stevens Point	57
58	South Molle Island Resort	Effective roller for removing pet hair from furniture.	Ar Rayyan	58
59	Dayton	Set of three aromatic candles with various scents.	Shiquanhe	59
60	Angelsey	Easy meal kit for creamy fettuccine Alfredo.	Blubber Bay	60
61	Rubelsanto	Crunchy peanuts coated in honey, perfect for snacking.	De Ridder	61
62	Codrington	Stylish and spacious case for makeup and beauty products.	Omo National Park	62
63	Ben Slimane	Assorted herbal tea bags for relaxation and wellness.	Repulse Bay	63
64	Cauquira	A rich pesto made with sun-dried tomatoes and pine nuts.	Jequié	64
65	Red Deer	Creamy ricotta cheese, great for cooking or making desserts.	Marathon	65
66	Maniwaki	Compact sewing kit for travel emergencies.	Quzhou	66
67	\N	Everyday flats that combine comfort and style.	Îles-de-la-Madeleine	67
68	Medellín	Fresh and juicy cherry tomatoes for salads and snacking.	Rio Grande	68
69	\N	Handheld vacuum cleaner for quick and easy cleaning.	Cleveland	69
70	Vangaindrano	Stabilizer for smooth video recording with smartphones.	Derna	70
71	Bhadrapur	Creamy pistachio-flavored ice cream with real nuts.	Killeen	71
72	Saint Anne	Stainless steel travel mug with spill-proof lid.	Pangia	72
73	Evenes	Crunchy and sweet banana chips, a great on-the-go snack.	Prishtina	73
74	Douala	Bold combat boots that make a statement with any outfit.	\N	74
75	Aumo	Smart robotic vacuum for automatic cleaning.	Soroti	75
76	Powell River	Complete outdoor kit for camping and hiking.	Balurghat	76
77	Muskegon	Delicious pasta shells filled with spinach and cheese	\N	77
78	Hampton	Convenient carrier for transporting yoga mat.	Santa Rosa	78
79	Normanton	A flavorful lentil curry cooked with vegetables and spices.	Tom Price	79
80	\N	Freshly ground cinnamon spice for baking or seasoning.	Fillmore	80
81	Yibin	Frozen onion rings, crispy and ready to bake.	Rehoboth Beach	81
82	Mazamari	Learning tablet with kid-friendly educational apps.	Topeka	82
83	Mareb	Compact organizer for cosmetics during travel.	Roseburg	83
84	Natuashish	Complete watercolor set with paints and brushes.	Lodja	84
85	Singapore	A protein-packed pancake mix for a nutritious breakfast.	Washabo	85
86	Manihiki Island	Reusable whiteboard for notes and reminders with magnetic backing.	Semonkong	86
87	Lusambo	Crunchy granola with pumpkin spice flavor.	Ambon	87
88	Kasese	Rich tomato soup flavored with fresh basil, ready to heat up.	Abengourou	88
89	Mahdia	Complete kit for starting your own organic garden.	Vichadero	89
90	Clinton	Rich and creamy milk perfect for baking or desserts.	Polacca	90
91	Huntington	Precision pencils for drawing, sketching, and writing.	Coen	91
92	Ephrata	Fresh zucchini, versatile for grilling or sautéing.	Kigali	92
93	Belo sur Tsiribihina	Set of baking sheets for effortless baking.	Roma	93
94	Rugao	Delicious apple sauce with a hint of cinnamon	Fane Mission	94
95	Wanganui	Multi-port USB-C hub for connecting devices.	Weno Island	95
96	Emo Mission	Complete meal kit with everything needed to make beef stroganoff in under 30 minutes.	Nemiscau	96
97	Saint Martin	Modern LED table lamp with touch control.	Welshpool	97
98	Hwange	Silicone oven mitts for safe handling of hot cookware.	Glen Canyon Natl Rec Area	98
99	Guantánamo	Ergonomic memory foam pillow for better sleep.	Liangping	99
100	Taipei	Gluten-free pasta made from lentils, high in protein.	Algona	100
101	Sumbawanga	Bluetooth thermometer that alerts you when your meat is done.	Safia	101
102	Venice	Cold-pressed coconut oil, perfect for cooking, baking, or skin care.	Satar Tacik-Flores Island	102
103	\N	Handmade eco-friendly bowls made from real coconuts.	Morlaix/Ploujean	103
104	Pangoa	Large inflatable pool for summer fun in your backyard.	Owerri	104
105	Sui	Fun robot that engages kids with games and activities.	Piracicaba	105
106	Tlemcen	Challenging puzzle game set for family entertainment.	Gore Bay	106
107	Tel Aviv	Infuser for brewing loose-leaf herbal teas easily.	\N	107
108	La Grande Rivière	Quick oatmeal with various flavors	Grumeti Game Reserve	108
109	Simferopol	Handmade eco-friendly bowls made from real coconuts.	Rocky Mount	109
110	\N	Durable yoga strap for deeper stretches.	Tahneta Pass Lodge	110
111	Gurney	Stylish desk lamp featuring a USB charging port.	Port Graham	111
112	Inverell	Chocolate-covered candy bars with coconut and almonds.	Cabo Frio	112
113	\N	Crispy and juicy chicken tenders, perfect for dipping.	San Salvador (San Luis Talpa)	113
114	Cannes/Mandelieu	Reusable mat that prevents food from sticking to the grill.	Aripuanã	114
115	Sabu-Sawu Island	Soft and breathable cotton sweatpants perfect for lounging or workouts.	Kindamba	115
116	Kalamazoo	High-resolution camera for stunning photos.	Malmö	116
117	Buochs	Creamy soup full of rich mushroom flavor.	Butler	117
118	Kelila-Papua Island	Reusable tote bags for shopping and eco-friendly living.	Reykhólar	118
119	Öndörkhaan	Professional-grade nail care set for manicures and pedicures.	Prescott	119
120	L'Aquila	Roasted cashews coated in honey and sesame seeds for a sweet treat.	Pontes e Lacerda	120
121	\N	Durable non-stick frying pan for easy cooking and cleaning.	Drayton Valley	121
122	Madison	Eco-friendly soy candles with a variety of scents.	Summerside	122
123	Raduzhnyi	Stylish and spacious case for makeup and beauty products.	Minneapolis	123
124	San Javier	Artisan bread with caraway seeds for added flavor.	Freeport	124
125	Simenti	Concentrated tomato paste, great for sauces.	Kemble	125
126	Zhengzhou	Juicy and tender boneless chicken breasts.	Sumter	126
127	Santana Do Araguaia	Moist brownie topped with sea salt and caramel drizzle.	Patuxent River	127
128	Nueva Guinea	Crispy almonds coated with cinnamon and sugar for a sweet and crunchy snack.	Bhadrapur	128
129	\N	Water bottle with built-in UV-C light for self-cleaning.	Farah	129
130	Mueo	A comfortable henley shirt made of soft cotton, perfect for casual outings.	Münster	130
131	Kastelorizo Island	Craft your own lip balms with this complete kit.	Karlstad	131
132	Quaqtaq	Sweetened sticky rice served with fresh mango and coconut sauce.	Wasua	132
133	\N	Crunchy and nutritious almonds, perfect for snacking.	Manihiki Island	133
134	Ciudad Constitución	Juicy and tender boneless chicken breasts.	\N	134
135	Ankara	Self-cleaning grooming brush for cats and dogs.	Lleida	135
136	Tokeen	Space-saving bike for indoor workouts.	Uaxactun	136
137	Burao	Rich and tangy dressing perfect for salads.	Karluk	137
138	Auburn	Multi-function rice cooker for all types of rice recipes.	Osceola	138
139	Tawa	Nutritious and hearty pasta made from whole wheat flour.	Rockhampton	139
140	Buin	Fresh baby spinach leaves, great for salads and smoothies.	Jamnagar	140
141	\N	Clip-on guitar tuner with LCD display.	Merdei-Papua Island	141
142	\N	Fresh and tart organic green apples, great for snacking or baking.	Termez	142
143	Jinghong	Versatile canned black beans, ready to add to any dish.	Chattanooga	143
144	Nîmes/Garons	Modern lamp featuring a USB port for convenient charging.	Dschang	144
145	Cleveland	Delicious dark chocolate cups filled with creamy peanut butter.	Paso de los Libres	145
146	Bristol	Adjustable dog collar with personalized tags.	Detroit	146
147	Zarafshan	Rechargeable massage gun for relieving muscle soreness.	Tyumen	147
148	Propriano	Rechargeable massage gun for relieving muscle soreness.	Lutselk'e	148
149	Torrance	A warm and stylish puffer coat perfect for winter weather.	Rockland	149
150	Seram Island	A blend of nuts, seeds, and dried fruits for snacking.	Roseburg	150
151	Orangeburg	Essential tools for outdoor barbecues including tongs and spatula.	Kake	151
152	Pleiku	3D model puzzle kit for creative builders.	Al Bayda'	152
153	Khabarovsk	Chic high-waisted skirt, perfect for professional or casual settings.	Dobo-Warmar Island	153
154	Mururoa Atoll	Storage organizer for art supplies and tools.	Al Bayda'	154
155	Muscle Shoals	Canned pumpkin puree, perfect for pies and soups.	Chico	155
156	Dawson Creek	Essential ingredient for baking fluffy cakes and pastries.	Baitadi	156
157	Loring	A spicy marinade perfect for chicken and fish.	Ashland	157
158	Eilat	Chopped and frozen spinach, ideal for cooking and smoothies.	\N	158
159	Coatepeque	Crispy chips with a sweet twist, perfect for dipping.	Cleveland	159
160	Kamarata	Handmade eco-friendly bowls made from real coconuts.	Murrin Murrin	160
161	Gaua Island	A sweet and spicy sauce, great for dipping or cooking.	Dunhuang	161
162	Contadora Island	Device that tracks soil moisture and provides care tips.	Debre Tabor	162
163	Kremenchuk	Frozen smoothie blend with berries for a quick and healthy breakfast.	Oyo	163
164	Allakaket	A timeless wardrobe staple crafted from soft cotton with a perfect fit.	Knob Noster	164
165	Hana	Delicious frozen pizza with a variety of toppings.	Tajima	165
166	Tanjung Manis	Durable and shatterproof silicone glasses for outdoor use.	Daocheng County	166
167	Pweto	Timeless belted trench coat for a polished look during fall.	Koyuk	167
168	\N	A ready-to-eat soup with coconut milk, spices, and vegetables.	Artesia	168
169	Lake Rudolf	Soft throw blanket for cozy home decor.	\N	169
170	Rome	Non-stick and heat-resistant utensils for cooking.	Chigorodó	170
171	Zhalantun	Kitchen tool for tenderizing meat to enhance flavors.	Watertown	171
172	Angelsey	A delicious pizza loaded with vegetables	Fryeburg	172
173	Chaoyang	Freshly ground cinnamon spice for baking or seasoning.	El Nido	173
174	\N	Spicy and tangy chili sauce for adding heat to any dish.	\N	174
175	Poplar River	Ready-to-eat beet salad with dressing, great side dish.	\N	175
176	Lahaina	Creamy ice cream with refreshing mint flavor and chocolate chips.	Craig Cove	176
177	Arapiraca	A mix of fresh vegetables for quick stir-fries.	Kenieba	177
178	Sisimiut	Lightweight yoga mat for practicing on the go.	Gaborone	178
179	Marília	Soft and comfortable robe, perfect for lounging at home.	Broughton Island	179
180	Ormoc City	An elegant jumpsuit that can be dressed up or down.	Bhavnagar	180
181	Tasikmalaya-Java Island	Pre-seasoned beef mix for delicious tacos, just heat and serve.	Roper Bar	181
182	Sandstone	Assorted herbal teas, perfect for a warm and relaxing drink.	Yap Island	182
183	Ndola	Make delicious waffles with this user-friendly device.	Oksibil-Papua Island	183
184	Isfahan	Eco-friendly cutting board that is safe for dishwashers.	Sable Island	184
185	Dortmund	Set of unique wooden coasters for drinks and decor.	Fort Indiantown Gap(Annville)	185
186	Cozumel	All-in-one mix for easy homemade cheeseburgers, just add ground beef.	Spearfish	186
187	Macaé	Crispy tortilla chips, perfect for dipping.	Tripoli	187
188	Lerwick	DIY kit to convert your smartphone into a mini projector.	La Ribera	188
189	N'Délé	Creamy dessert made with rice and cinnamon.	Alice	189
190	Royan/Médis	RFID-blocking slim wallet for cards and cash.	Newport	190
191	Goulding's Lodge	A mix of grilled vegetables, ready to heat for quick side dishes.	Plymouth	191
192	Wrightstown	Lightly salted frozen edamame, a protein-packed snack.	Ouagadougou	192
193	Masamba-Celebes Island	Durable apron to keep clothes clean while cooking.	Eagle River	193
194	Moroni	Multi-functional grater for cheese and vegetables.	Nanuya Levu Island	194
195	Degah Bur	Synthetic crab meat sticks, great for salads and sushi.	Badin	195
196	Juara	Precision cooker for perfect sous vide cooking.	Borrego Springs	196
197	Kimwarer	Wi-Fi smart scale for tracking weight and BMI.	Perryville	197
198	Kekaha	Sweet corn roasted to perfection for a delightful side.	Stuart Island	198
199	Maiana	Float through the day in this beautiful floor-length skirt.	Zilfi	199
200	Boundiali	Crunchy granola with almonds and coconut.	\N	200
201	Kanpur	Beautiful leather-bound journal for writing and sketching.	Liuzhou	201
202	Inukjuak	Crunchy granola with almonds and a hint of vanilla, perfect for breakfast.	Vopnafjörður	202
203	Malabang	Charming frame to showcase your favorite photos.	Mérida	203
204	San Miguel de Tucumán	Flavorful sauce perfect for stir-frying vegetables and tofu.	Virac	204
205	Gedaref	Farm fresh eggs, essential for breakfast.	Ban Mak Khaen	205
206	Laghouat	Creamy pistachio-flavored ice cream with real nuts.	Gander	206
207	Hoquiam	8oz water bottle with built-in filter for clean drinking water.	Baytown	207
208	Salzburg	High-quality olive oil infused with fresh lemon zest.	Cayenne / Rochambeau	208
209	Miles City	Compact hose reel to keep your garden tidy.	Fallon	209
210	Atar	Convenient shower system for camping and outdoor activities.	Al Bayda'	210
211	\N	All-in-one art set for kids to unleash creativity.	Constantine	211
212	\N	Storage solutions for keeping your car tidy and organized.	Siwa	212
213	Puerto Limon	Set of baking sheets for effortless baking.	Calais/Dunkerque	213
214	Au	Chic slingback sandals for a relaxed summer vibe.	Lancaster	214
215	Montauban	Frozen mix for quick berry smoothies.	Yeniseysk	215
216	Shangrao	Nutty flavor perfect for pesto and salads.	Solomon	216
217	Dikson	Smooth soup made from carrots and ginger, great for cold days.	Woodbridge	217
218	Tawa	Versatile chair that easily folds up for carrying.	Oyem	218
219	Al-Bayda	A nutritious salad with quinoa and black beans	\N	219
220	Tanah Grogot-Borneo Island	Creamy almond butter sweetened with maple syrup for a delicious spread.	Niort/Souché	220
221	Scarborough	Healthy, crunchy kale chips, a nutritious snack.	Sanikiluaq	221
222	Omo National Park	Crisp and delicious organic apples.	Nicosia	222
223	Abilene	High-frequency whistle for training your dog effectively.	Deer Lake	223
224	Sidney	Control lights remotely with this smart switch.	Colombo	224
225	Sydney	Fresh and zesty salsa, perfect for nachos.	Amritsar	225
226	Tiga	A quick and easy fried rice mix with colorful veggies and savory seasoning.	Odessa	226
227	Del Rio	Nutritious and hearty pasta made from whole wheat flour.	Nanwalek	227
228	High Prairie	Creamy almond butter sweetened with maple syrup for a delicious spread.	Wuhu	228
229	Brownwood	Personalize your calendar with photos and special dates.	Bella Coola	229
230	Arbatax	Rich dark chocolate bars, perfect for a sweet treat.	Louisburg	230
231	Taupo	Frozen pizza rolls stuffed with spinach and cheese, perfect for snacking.	Tamana Island	231
232	Heglig Oilfield	Frozen mini meatballs that are great as a snack or in pasta dishes.	Ponta Grossa	232
233	Yeva	Light and crispy baked potato chips in assorted flavors.	Mitchell Plateau	233
234	Norfolk	Add a pop of color with this stylish patterned knit scarf.	Aiken	234
235	Rostov-on-Don	Creamy ice cream with refreshing mint flavor and chocolate chips.	Parnaíba	235
236	Musgrave	Artichoke hearts marinated in herbs and oil.	Sandy Lake	236
237	Tucuruí	A warm and sustainable wool scarf for chilly days.	April River	237
238	O'Neill	Tender grilled chicken marinated in lemon herbs.	Matane	238
239	Kokonau-Papua Island	Compact digital camera with 20MP resolution.	\N	239
240	\N	Eco-friendly mesh bags for shopping produce at the market.	Eisenach	240
241	\N	Creamy almond butter made from roasted almonds.	Klawock	241
242	Pavlodar	Creamy ranch dressing, perfect for salads and dips.	\N	242
243	Red Devil	Monitor and interact with your pet remotely with this camera.	Kopiago	243
244	Bahir Dar	Foldable reclining camping chair with cup holder.	Long Island	244
245	Arboletes	Magical lens kit for kids to explore the outdoors.	Ufa	245
246	Guarapuava	1080p wireless security camera with night vision.	\N	246
247	Koolburra	High-carbon stainless steel chef knife for precision cutting.	Creston	247
248	Kilaguni	Personalized nameplate for offices or homes.	Xiaguan	248
249	Lashio	Stay hydrated with refreshing flavored water.	Dillon	249
250	Kiryat Shmona	Lightweight hammock with a sturdy stand for relaxation anywhere.	Koromiko	250
\.


--
-- TOC entry 5463 (class 0 OID 41149)
-- Dependencies: 262
-- Data for Name: PROVEEDORES_INSUMOS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."PROVEEDORES_INSUMOS" (id_proveedor_insumos, nombre_proveedor, razon_social, correo_electronico, telefono) FROM stdin;
1	Penneshaw Airport	Quimm	jricardot0@mapy.cz	1871980718
2	Roberval Airport	Babbleopia	pcleobury1@yelp.com	7698057694
3	Rum Cay Airport	Gabspot	cropp2@liveinternet.ru	8633645611
4	Kotabangun Airport	Edgeclub	rusmar3@creativecommons.org	5119124397
5	Bellary Airport	DabZ	htoller4@cdbaby.com	6346995071
6	Mc Alester Regional Airport	Kazu	ttarbert5@yelp.com	4868846508
7	Anyang Airport	Brightdog	adownie6@cocolog-nifty.com	1715053185
8	Mocopulli Airport	Devbug	msofe7@drupal.org	5923414743
9	Accomack County Airport	Jabberbean	amckag8@time.com	3822981827
10	Choiseul Bay Airport	Meemm	ffrend9@cbc.ca	2673310732
11	Cognac-Châteaubernard (BA 709) Air Base	Yadel	gbridala@zdnet.com	9364606384
12	Coimbatore International Airport	Browseblab	vpitrollob@plala.or.jp	1775550629
13	Rivers Inlet Seaplane Base	Oloo	mhaddonc@lulu.com	7644236145
14	Lebak Rural Airport	Latz	btemperleyd@hao123.com	7682002896
15	Catumbela Airport	Twitterwire	htaaffee@time.com	7587401265
16	Tak Airport	Centizu	rbernhardssonf@slideshare.net	8647288023
17	Ardabil Airport	Jabbercube	igemellig@sun.com	1319161501
18	Adado Airport	Quinu	trehorh@illinois.edu	7839155324
19	St Louis Lambert International Airport	Jaloo	rphilippaulti@biblegateway.com	1088705736
20	Cachoeira do Sul Airport	Skivee	vpollockj@ovh.net	1837389659
21	Port Moresby Jacksons International Airport	Kwilith	selvink@reuters.com	1928384195
22	Sarzana-Luni Air Base	Twiyo	dendonl@amazonaws.com	5294392351
23	Abreojos Airport	Oozz	jblosem@wordpress.com	1309962346
24	Moose Jaw Air Vice Marshal C. M. McEwen Airport	Brainverse	cwaumsleyn@sciencedaily.com	9181561389
25	Ağrı Airport	Feednation	cmissono@buzzfeed.com	5352288500
26	Fallon Municipal Airport	Gigabox	snestorp@facebook.com	2709152389
27	Inhaca Airport	Cogidoo	bdinleyq@prnewswire.com	8651310780
28	Þingeyri Airport	Izio	rasquithr@cpanel.net	4479196519
29	Marin County Airport - Gnoss Field	Fliptune	eyukhtins@taobao.com	3405749171
30	Sittwe Airport	Abatz	rcasellast@github.com	4298428531
31	Stokmarknes Skagen Airport	Innotype	ahaddestonu@indiatimes.com	8977691891
32	Hólmavík Airport	Flipbug	gneildv@uol.com.br	2218343073
33	Nunukan Airport	Aimbu	mkrikorianw@furl.net	3673320175
34	Notodden Airport	Tagpad	avassmanx@shinystat.com	2465268292
35	Lengpui Airport	Skimia	eacedoy@msn.com	4704603995
36	Capitan V A Almonacid Airport	Buzzshare	roldacrez@cafepress.com	1645880819
37	Pimenta Bueno Airport	Yodoo	psherborne10@360.cn	4922419513
38	Na-San Airport	Voonix	sdagnall11@usa.gov	3951761888
39	Abu Rudeis Airport	Teklist	cmougin12@cnbc.com	6653204610
40	Tumolbil Airport	Trudoo	dventris13@archive.org	8575616005
41	Hamilton Island Airport	Eare	mkernoghan14@dagondesign.com	2579176033
42	Dillant Hopkins Airport	Eare	kcardenoza15@patch.com	4057742524
43	Stuart Island Airpark	Yozio	reyton16@kickstarter.com	9961892502
44	Noyabrsk Airport	Photofeed	smaddra17@posterous.com	1302463187
45	Madras Municipal Airport	Izio	kweek18@apache.org	5542932061
46	Danilo Atienza Air Base	Jabbertype	kworcs19@redcross.org	6774752955
47	Asturias Airport	Feedfire	gbramham1a@army.mil	9681401092
48	Sheremetyevo International Airport	Twimm	lbrounsell1b@thetimes.co.uk	2267068695
49	Bassatine Airport	Voomm	mram1c@howstuffworks.com	6507010868
50	Puka Puka Airport	Voonix	rwillder1d@wikia.com	6678116642
51	Yuzhno-Sakhalinsk Airport	Muxo	cpretsell1e@rediff.com	4871395954
52	Aishalton Airport	Bubblemix	lpassie1f@ifeng.com	8534803667
53	Besalampy Airport	Youopia	mhurworth1g@123-reg.co.uk	9744741928
54	Tuba City Airport	Twitterlist	zfansy1h@dell.com	8455383617
55	Tucuma Airport	Wikizz	droderick1i@rakuten.co.jp	8907998162
56	Glengyle Airport	Livetube	kjago1j@360.cn	8559342623
57	Unguia Airport	Babbleblab	fchristian1k@nationalgeographic.com	7979150595
58	Gounda Airport	Devbug	ryoodall1l@simplemachines.org	7117306706
59	Chino Airport	Shufflebeat	aking1m@washington.edu	2414365310
60	Al Ahsa Airport	Quatz	cbanks1n@si.edu	2893487226
61	Randolph Air Force Base	Brainbox	abriztman1o@t.co	3331256256
62	Baruun Urt Airport	Reallinks	adunbobbin1p@cdc.gov	7859619619
63	Pormpuraaw Airport	Meezzy	efoyster1q@rambler.ru	7486909044
64	Mahenye Airport	Skiba	bczaple1r@amazonaws.com	5437910173
65	Key Lake Airport	Thoughtbridge	nvandenvelde1s@usa.gov	2563869637
66	Stykkishólmur Airport	Gigashots	lbate1t@uol.com.br	8698730305
67	Chaudhary Charan Singh International Airport	Thoughtmix	tbrouard1u@feedburner.com	8326680419
68	Indagen Airport	Photofeed	hjuszczyk1v@youtu.be	2318949242
69	Konawaruk Airport	Browseblab	cbaseley1w@aol.com	1278803070
70	Tampa International Airport	Chatterpoint	grikard1x@answers.com	4533006810
71	OR Tambo International Airport	InnoZ	brolls1y@washingtonpost.com	6456200097
72	San Luis County Regional Airport	Edgetag	gbedson1z@nytimes.com	3676089916
73	Ralph M Calhoun Memorial Airport	Janyx	gbraam20@engadget.com	8059622768
74	Kakoro(Koroko) Airstrip	Teklist	rsturgeon21@plala.or.jp	1637950231
75	Umeå Airport	Browsedrive	dstrete22@plala.or.jp	5059872609
76	Karluk Airport	Feedfire	msuddock23@seesaa.net	4104167896
77	Berezovo Airport	Zoombeat	ebarratt24@google.fr	5083747211
78	Memmingen Allgau Airport	Tavu	aeve25@studiopress.com	7114231922
79	Kagi Airport	Eabox	scudihy26@51.la	9268090352
80	Narrabri Airport	Tagtune	cjewitt27@hostgator.com	4762896879
81	Toccoa Airport - R.G. Letourneau Field	Meembee	hrichter28@linkedin.com	4262540984
82	Carauari Airport	Bubblemix	tjakubowski29@webeden.co.uk	7271544118
83	Mekane Selam Airport	Tagpad	daltamirano2a@dedecms.com	8966239106
84	Markovo Airport	Feedmix	cpinner2b@washington.edu	1603002669
85	Eilat Airport	Zoonder	ghardin2c@4shared.com	9477172762
86	General Villamil Airport	JumpXS	bchoules2d@umich.edu	6138690413
87	Pasir Pangaraan Airport	Brainbox	ndyke2e@nydailynews.com	2699912431
88	Camfield Airport	Riffwire	starbox2f@dion.ne.jp	9215223233
89	Nuiqsut Airport	Feedfish	skibbye2g@facebook.com	5535640866
90	Andi Jemma Airport	Oyoba	jelverstone2h@google.com.au	1241426324
91	Santa Maria Airport	Dabjam	jsnaddon2i@gnu.org	5932099900
92	Kira Airport	Jaxworks	dcorgenvin2j@census.gov	1834617166
93	Baker City Municipal Airport	Yombu	nbailey2k@disqus.com	7346645132
94	Inverell Airport	Fivebridge	rfayter2l@squidoo.com	7735851709
95	Argyle International Airport	Brainlounge	mskillen2m@jugem.jp	4616333450
96	Nunapitchuk Airport	Feedbug	amckearnen2n@sbwire.com	7423170071
97	Curuzu Cuatia Airport	Trilia	jgermon2o@instagram.com	5842080763
98	Ha'il Airport	Brainverse	ssidden2p@trellian.com	5652533727
99	Einasleigh Airport	Quinu	agelsthorpe2q@multiply.com	4755231856
100	Fremont County Airport	Jaxspan	rstribbling2r@digg.com	7421941105
101	Rebun Airport	Photospace	bkildahl2s@sakura.ne.jp	4836486768
102	Central Nebraska Regional Airport	Twimm	knappin2t@squidoo.com	7372349859
103	Nachingwea Airport	Divanoodle	clambricht2u@toplist.cz	5161813876
104	Kneeland Airport	Quimm	hbarford2v@earthlink.net	9785473080
105	Velikiy Ustyug Airport	Yodo	agatrill2w@sciencedirect.com	2357518811
106	Trang Airport	Gabcube	rsinnat2x@icio.us	7182450758
107	Khoram Abad Airport	Meetz	mmemory2y@pbs.org	3603475145
108	Lianshui Airport	Demizz	svernham2z@salon.com	9711603909
109	Conceição do Araguaia Airport	Meetz	vmollnar30@cdc.gov	4993574073
110	Kikwit Airport	Fatz	agoldingay31@paginegialle.it	5598029401
111	Fulton County Airport Brown Field	Vimbo	gbonham32@ebay.com	8779655922
112	Guerrero Negro Airport	Buzzdog	dpacey33@devhub.com	3157219006
113	Ndende Airport	Flashpoint	sflahive34@phpbb.com	2795498750
114	Lijiang Airport	Kimia	bsalle35@java.com	6856157427
115	Jenpeg Airport	Cogidoo	ddelmage36@webmd.com	1565171573
116	Port Lincoln Airport	Edgeclub	afarlow37@theglobeandmail.com	6689823804
117	Pyongyang Sunan International Airport	Yakijo	ewaud38@globo.com	5626165304
118	Winkler County Airport	Trudeo	jdun39@clickbank.net	7596828563
119	Garaina Airport	Leenti	nusborn3a@disqus.com	7979313174
120	Ruben Cantu Airport	Avamba	eextence3b@engadget.com	8375005240
121	Bacău Airport	Browseblab	fevered3c@slashdot.org	9263184466
122	Saúl Airport	Flashspan	rjebb3d@i2i.jp	9492678430
123	Kristianstad Airport	Topiczoom	gespinet3e@ucoz.ru	9332972738
124	Stara Zagora Airport	Yadel	oholtum3f@goodreads.com	9716235071
125	Bambari Airport	Yambee	kmarrows3g@harvard.edu	4353581260
126	Ronneby Airport	Feedspan	ltradewell3h@weebly.com	5514274134
127	Tiga Airport	Voonix	lwitcomb3i@tmall.com	9369466755
128	Harar Meda Airport	Trilith	lallington3j@topsy.com	6055066620
129	Aghajari Airport	Oyonder	msheraton3k@nydailynews.com	2942914228
130	Cibeureum Airport	Feedfire	ckelly3l@dyndns.org	3966086601
131	Ruston Regional Airport	Rhynyx	ajerrems3m@un.org	2564343740
132	Kotoka International Airport	Yambee	iitzkin3n@shutterfly.com	6246752978
133	Camaxilo Airport	Kwideo	bblackly3o@themeforest.net	6222474909
134	Ramón Villeda Morales International Airport	Agivu	twhistan3p@naver.com	4702254234
135	Malalaua Airport	Skinix	rponton3q@hugedomains.com	8826516110
136	Cape Girardeau Regional Airport	Einti	jlowth3r@ebay.com	2205631960
137	Hluhluwe Airport	Bubblemix	jorehead3s@blogs.com	2902635409
138	Beatty Airport	Realbuzz	cpelcheur3t@macromedia.com	1042514899
139	Bielsko-Bialo Kaniow Airfield	Shufflester	scater3u@wix.com	9124376189
140	Sarzana-Luni Air Base	JumpXS	srickerd3v@ucla.edu	8846181935
141	Modlin Airport	Skidoo	ablaney3w@ezinearticles.com	8953490084
142	Grundarfjörður Airport	Zooxo	nbucklee3x@sbwire.com	6568292615
143	Wings Field	Twitterwire	femett3y@ask.com	2806396364
144	Stockton Metropolitan Airport	Innotype	seyres3z@aboutads.info	3657929646
145	Perry Island Seaplane Base	Shuffledrive	guttermare40@arstechnica.com	2584043620
146	Long Bawan Airport	Layo	smathonnet41@woothemes.com	4173334583
147	Sokcho (Mulchi Airfield) (G-407/K-50) Airport	Cogidoo	wmoneti42@toplist.cz	6407651447
148	Mokpo Airport	Demimbu	cacheson43@sciencedaily.com	3396797006
149	Dupage Airport	Aimbo	pcomsty44@w3.org	5141349456
150	Puerto Escondido International Airport	Yozio	cnehlsen45@cbc.ca	2459870869
151	LBJ Ranch Airport	Thoughtstorm	tcogley46@yandex.ru	7344112976
152	Fayetteville Municipal Airport	Dablist	eschult47@walmart.com	7958668014
153	Tetebedi Airport	Oyoba	kmilburne48@sourceforge.net	3059645992
154	Mariscal Lamar Airport	Cogibox	msambiedge49@fema.gov	6648860538
155	Ivanof Bay Seaplane Base	Realbridge	yrolling4a@dedecms.com	9657019193
156	Sir Grantley Adams International Airport	Tagopia	tgrimmert4b@addtoany.com	8403312840
157	Sawan Airport	Zava	jjeanon4c@infoseek.co.jp	1524255510
158	Morawa Airport	Oyondu	mbeeble4d@house.gov	4203462593
159	Aur Island Airport	Oozz	svellacott4e@pinterest.com	6908390583
160	General Leobardo C. Ruiz International Airport	Eimbee	nklouz4f@google.fr	1636655887
161	Sundsvall-Härnösand Airport	Quire	lgeikie4g@omniture.com	2543850695
162	Usino Airport	Quire	rvaud4h@freewebs.com	8274024355
163	Maple Bay Seaplane Base	Skivee	rlayfield4i@icq.com	9522943734
164	Wuhai Airport	Twiyo	ahegg4j@posterous.com	3338423896
165	RAF Fairford	Trudeo	kleyes4k@amazon.co.jp	3741110787
166	Las Heras Airport	Twitternation	folczak4l@webnode.com	4293845061
167	Shaoguan Guitou Airport	Flipstorm	jhows4m@paginegialle.it	3441020970
168	Jabiru Airport	Realcube	sbatho4n@nifty.com	5183549805
169	Alberto Lleras Camargo Airport	Midel	sgiacomuzzi4o@blogger.com	5092660944
170	Mora Airport	Divavu	dcoverdill4p@mapy.cz	2967299583
171	Bryansk Airport	Flashdog	imaudson4q@china.com.cn	4222879766
172	Zhob Airport	Brainverse	ktroctor4r@bbc.co.uk	6258703501
173	Bayannur Tianjitai Airport	Realcube	hhargreaves4s@fastcompany.com	8677218945
174	Ottawa Macdonald-Cartier International Airport	Mycat	mmorville4t@aol.com	4808160391
175	Jacksonville Executive at Craig Airport	Twimm	emcquilliam4u@cdc.gov	7301425510
176	San Pedro Airport	BlogXS	slorain4v@hubpages.com	2785240638
177	Amgu Airport	Katz	rgerriets4w@timesonline.co.uk	1383240722
178	Batman Airport	Dynabox	rteager4x@chron.com	8425634576
179	Slave Lake Airport	Edgeify	mdalwis4y@ft.com	8457022706
180	Paramillo Airport	Ntags	cthunderman4z@scribd.com	8134236283
181	Washabo Airport	Rhyloo	eyewdall50@instagram.com	7732469311
182	Fazenda das Represas Airport	Flashset	wlynett51@hostgator.com	9477403215
183	Tabuaeran Island Airport	Jabbercube	yforber52@canalblog.com	2275403813
184	Gazipaşa Airport	Oozz	eclackers53@naver.com	4353606592
185	Mahendranagar Airport	Avavee	ahearsey54@state.gov	9179355458
186	Kasba Lake Airport	Edgeify	cmattheissen55@unc.edu	2111559197
187	Mahdia Airport	Browsedrive	kemmitt56@51.la	1033645715
188	Arkansas International Airport	Mydeo	grimes57@chicagotribune.com	9411900815
189	São Joaquim da Barra Airport	Jabberstorm	genrich58@ucoz.com	7496832279
190	Liuting Airport	Snaptags	epygott59@goo.ne.jp	4624877526
191	Bangor International Airport	Divape	rhenrique5a@altervista.org	7182073952
192	South Goulburn Is Airport	Mydo	sgillman5b@pagesperso-orange.fr	5752721931
193	Suffield Heliport	Digitube	hsynke5c@ehow.com	3317917866
194	Calabozo Airport	Zoovu	rhayth5d@issuu.com	8802791288
195	Kaadedhdhoo Airport	Yakitri	labramcik5e@cisco.com	6221461656
196	Rottnest Island Airport	Voonte	gtemblett5f@fastcompany.com	6878164721
197	Rockhampton Downs Airport	Midel	bleward5g@drupal.org	3446615019
198	Nizhnevartovsk Airport	Topicshots	lolanda5h@weebly.com	2196958177
199	Splane Memorial Airport	Trunyx	louchterlony5i@mozilla.org	8027032655
200	Terapo Airport	LiveZ	pfabb5j@ustream.tv	8871855706
201	Ofu Village Airport	Yakitri	sbonnin5k@eventbrite.com	3333737736
202	Manti-Ephraim Airport	Dazzlesphere	keyam5l@rediff.com	6046403691
203	Kzyl-Orda Southwest Airport	Wikido	jaikin5m@who.int	2333234067
204	Kericho Airport	Zava	dtwitchings5n@themeforest.net	9981995928
205	Kamalpur Airport	Flashset	nnolin5o@digg.com	4905553390
206	Santa Maria da Vitória Airport	Brightdog	pdennant5p@zdnet.com	3332503230
207	Komodo Airport	Browsecat	hcancutt5q@reuters.com	6688393868
208	Ayr Airport	Twitterlist	edaniely5r@sun.com	5072003118
209	Kaghau Airport	Camimbo	ldufton5s@biglobe.ne.jp	4294315151
210	Ikaria Airport	Agivu	hbeakes5t@reverbnation.com	7261664150
211	Spriggs Payne Airport	Geba	mimlen5u@craigslist.org	8878518015
212	Charters Towers Airport	Edgeblab	pmccorkindale5v@xinhuanet.com	1447503386
213	Sissano Airport	Tanoodle	sdaveridge5w@bbc.co.uk	8715353066
214	Jataí Airport	Edgeify	fkocher5x@wikimedia.org	6048576763
215	Agen-La Garenne Airport	Youtags	lsaffle5y@1und1.de	6161763857
216	Bali Airport	Topicshots	cbanstead5z@sogou.com	6083676241
217	Leonardo da Vinci–Fiumicino Airport	Lajo	glutz60@bloglines.com	7673935672
218	Geladi Airport	Lajo	rcutcliffe61@oracle.com	6706707278
219	Gwangju Airport	Divanoodle	ibennike62@dailymotion.com	6193035274
220	Ruti Airport	Topiczoom	lberrycloth63@msn.com	9184539074
221	Illizi Takhamalt Airport	Tagtune	kloades64@nymag.com	7799190722
222	Knee Lake Airport	Skibox	lbridgewater65@admin.ch	5162379820
223	Solovki Airport	Skalith	mmacalees66@home.pl	8622193410
224	Salt Cay Airport	Muxo	lsambrok67@indiegogo.com	4106320075
225	Torembi Airport	Babbleopia	wconklin68@pen.io	5967439703
226	Parkes Airport	Brainbox	cjarman69@studiopress.com	9615696158
227	Lusk Municipal Airport	InnoZ	spirie6a@google.co.uk	9869819390
228	Tinboli Airport	Feednation	npordal6b@soundcloud.com	9988469476
229	Santos Dumont Airport	Photolist	mduggon6c@zdnet.com	9161677809
230	Lombok International Airport	Voonix	mforestel6d@indiegogo.com	9969623396
231	São Tomé International Airport	Yoveo	jalten6e@ehow.com	9334870662
232	San Cristóbal Airport	Flashspan	cfrankton6f@webeden.co.uk	7094863989
233	Trondheim Airport Værnes	Ooba	brefford6g@usatoday.com	6722193150
234	Manitowoc County Airport	Linklinks	qmacgilrewy6h@loc.gov	6233817200
235	Laiagam Airport	Edgewire	jduffett6i@etsy.com	8055185412
236	Laurence G Hanscom Field	Skinder	vcassels6j@wufoo.com	1735373518
237	Snake Bay Airport	Gigaclub	jbelcher6k@bloglovin.com	8234708913
238	Senadora Eunice Micheles Airport	Yakidoo	mharbach6l@pcworld.com	5448145934
239	Aseki Airport	Pixope	nmillin6m@yale.edu	2772031726
240	Iran Shahr Airport	Skipfire	ucoe6n@free.fr	4751403211
241	Ubon Ratchathani Airport	Digitube	cbenoit6o@sohu.com	1738791885
242	Aek Godang Airport	Jaxspan	cricold6p@sbwire.com	7423150020
243	Odense Airport	Skiptube	kbransby6q@clickbank.net	7781669134
244	Samangoky Airport	Myworks	iorwin6r@booking.com	8581037872
245	Kontum Airport	Shufflebeat	dbonnet6s@quantcast.com	2668070963
246	Sault Ste Marie Airport	Yoveo	gcashell6t@spotify.com	5337135806
247	Taupo Airport	Zoonder	eblamires6u@mozilla.org	4743518933
248	Lal Bahadur Shastri Airport	Innotype	maberhart6v@trellian.com	5873802554
249	Frank Pais International Airport	Rhybox	sblockley6w@amazon.de	2016015004
250	Westsound/Wsx Seaplane Base	Rhynyx	omahony6x@youtube.com	1925351212
\.


--
-- TOC entry 5464 (class 0 OID 41152)
-- Dependencies: 263
-- Data for Name: PROVEEDORES_MOBILIARIOS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."PROVEEDORES_MOBILIARIOS" (id_proveedor_mobiliario, razon_social, nombre_proveedor, correo_electronico, telefono) FROM stdin;
1	Elonore	Jabbersphere	emccosh0@ovh.net	4181379961
2	Aurea	Myworks	amctrustrie1@sakura.ne.jp	9552450162
3	Stacee	Trudoo	srossi2@4shared.com	4787093191
4	Shena	Zazio	skull3@wikipedia.org	5353035655
5	Brear	Rooxo	bsearles4@walmart.com	9067673959
6	Junie	Skinix	jbattye5@forbes.com	3295259488
7	Mari	Blogtag	mschach6@ihg.com	8376622956
8	Gisele	Kwideo	gconville7@wordpress.org	3898649603
9	Dasie	Ntags	dgoakes8@wufoo.com	2259591053
10	Lucina	Aivee	lposnette9@uol.com.br	9341143019
11	Lizbeth	Skilith	loleszcuka@techcrunch.com	3729589039
12	Katharine	Realcube	kelmerb@vimeo.com	8846409398
13	Abby	Gabspot	akilroyc@yelp.com	1704432518
14	Andrea	Linkbridge	aocorraned@home.pl	8652608334
15	Janice	Kare	jsmidmore@behance.net	7777544546
16	Tabbi	Kare	tmayouf@mit.edu	4537312985
17	Horatia	Skynoodle	hbinleyg@apple.com	6956279933
18	Minny	Twitterworks	mfautleyh@storify.com	1876872676
19	Sue	Lazz	sescoffreyi@instagram.com	5447353057
20	Leigha	Tagfeed	ltomasonij@tripod.com	9275209996
21	Marylee	Quaxo	mbourgeoisk@shinystat.com	3686176338
22	Marnie	Aivee	mmorlandl@google.es	9206166288
23	Gwendolin	Lazz	gsimeonm@google.co.uk	2608802036
24	Linnea	Browsecat	lberesfordn@businessinsider.com	3128372398
25	Christan	Shufflester	cseftono@aboutads.info	4548058459
26	Lotti	Flashpoint	lcleggp@google.es	5848846531
27	Olva	Twitterlist	okepeq@gizmodo.com	9096728721
28	Hilda	Ooba	hmciloryr@linkedin.com	7048513756
29	Barbette	Yadel	bkynsons@soundcloud.com	6364860834
30	Lonni	Kayveo	lbressont@ebay.com	3678583565
31	Verile	Tazz	vmargarsonu@stanford.edu	6881159507
32	Caroljean	Skipfire	cdionisv@storify.com	4043781063
33	Fawnia	Photospace	fstyantw@ocn.ne.jp	8634895418
34	Teri	Miboo	tmapledorumx@tinypic.com	7972452544
35	Nyssa	Brainlounge	naccomby@webs.com	2717443381
36	Marline	Eazzy	mgeggiez@go.com	8147937421
37	Oralla	Mybuzz	omcandie10@usa.gov	7534463089
38	Ainsley	Brainsphere	awhitten11@comsenz.com	3635888515
39	Aleen	Feednation	amccard12@google.de	3718275173
40	Daisi	Youtags	dtripon13@jugem.jp	1045381684
41	Willie	Avaveo	wjennaway14@rakuten.co.jp	2952986326
42	Bonni	Skiba	bkubacek15@wunderground.com	6552453960
43	Anna-diana	Meevee	araddon16@washington.edu	2063740406
44	Gleda	Tagchat	ganten17@utexas.edu	4917596975
45	Rebecca	Tazzy	rmarkey18@netvibes.com	2682066220
46	Jada	Devbug	jstruttman19@homestead.com	1245052427
47	Margarethe	Einti	mfitchet1a@deliciousdays.com	1717153085
48	Jillian	Avamm	jponsford1b@telegraph.co.uk	7451483241
49	Riane	Jabbercube	rbarnewell1c@qq.com	6411339375
50	Kristyn	Twitterwire	kcopner1d@chron.com	6156200082
51	Pearle	Yakijo	pdesport1e@rambler.ru	8019478967
52	Austina	Yabox	asuddock1f@zimbio.com	1368014811
53	Norean	Jaxspan	nkroon1g@gizmodo.com	4042365201
54	Dareen	Lazz	dtrahar1h@comcast.net	5818221003
55	Donna	Zoomzone	dlinfoot1i@gravatar.com	3191633561
56	Madelaine	Trunyx	mporte1j@tmall.com	4461049355
57	Clementine	Tanoodle	ccalan1k@archive.org	2483753491
58	Morna	Feedfish	mlearman1l@ezinearticles.com	3828204512
59	Kettie	Kayveo	kdanick1m@jalbum.net	5946521215
60	Gnni	Meeveo	gmaccosty1n@booking.com	7138363956
61	Liliane	Meemm	ltreacher1o@miibeian.gov.cn	1995598127
62	Daune	Brainlounge	dwiersma1p@accuweather.com	5726074555
63	Ardyce	Youspan	ajeandillou1q@reference.com	1963709424
64	Austin	Oyope	asparks1r@newsvine.com	6467354539
65	Dora	Twitterbridge	daleksashin1s@epa.gov	5207941442
66	Nan	Oyoyo	njennison1t@sourceforge.net	7354212447
67	Angie	Eazzy	aerik1u@about.me	1264450450
68	Nicola	Brainsphere	ncurthoys1v@baidu.com	9886695699
69	Jermaine	Topdrive	jgolby1w@sun.com	2665349583
70	Adelice	Realcube	agiraudat1x@forbes.com	8113059777
71	Kassie	Yamia	kkarpeev1y@cafepress.com	7403890110
72	Alikee	Aivee	amcgeouch1z@zimbio.com	5056760924
73	Karie	Quatz	kyarrell20@dell.com	7207227890
74	Josee	Digitube	jcocklie21@t.co	9825056087
75	Ardath	Gabtype	aspeirs22@bloglines.com	5362658799
76	Sula	Fivespan	sgullis23@pagesperso-orange.fr	3459940852
77	Meara	Feedspan	mterrell24@nationalgeographic.com	1594048523
78	Charmane	Blogspan	cgrimmert25@webnode.com	9742136061
79	Riki	Vidoo	rkingswood26@google.fr	3869338220
80	Shelagh	Skinix	scausby27@goo.ne.jp	1447051761
81	Happy	Tagcat	hgandley28@zimbio.com	8402671851
82	Tamarah	Thoughtworks	ttourry29@twitter.com	1742875639
83	Rhiamon	Skynoodle	rguillon2a@si.edu	9609973157
84	Melinda	Eare	mtommaseo2b@cafepress.com	8924664582
85	Nonna	Plambee	nscurrey2c@symantec.com	9418662753
86	Rubina	Skalith	rivanilov2d@etsy.com	1953964550
87	Karole	Gigashots	kiffland2e@chicagotribune.com	7912017215
88	Caroline	Shufflebeat	cherrieven2f@utexas.edu	1272991541
89	Meris	Jabbersphere	mterren2g@techcrunch.com	7633739452
90	Rosaline	Zazio	rshellshear2h@com.com	5414669403
91	Darcie	Twitterbeat	dbenini2i@narod.ru	9855294241
92	Maurise	Realcube	mwaterfall2j@eepurl.com	9796611927
93	Carlina	Vimbo	cleaves2k@xing.com	8207914937
94	Faunie	Yakidoo	fjanaszkiewicz2l@livejournal.com	8028804752
95	Olivette	Devshare	owalworth2m@unc.edu	4648590042
96	Brittan	Mydeo	babbots2n@ucoz.ru	5022224218
97	Kamila	Gigazoom	kbuddleigh2o@ed.gov	8972042403
98	Rose	Tagpad	rwaterman2p@themeforest.net	1115608137
99	Honey	Vinte	hchill2q@oakley.com	9943220837
100	Elfreda	Ailane	ehatchman2r@t-online.de	6336905654
101	Rafaela	Skyba	rwillcott2s@google.es	2844078844
102	Sadie	Aimbu	sproppers2t@utexas.edu	7708539481
103	Doris	Digitube	dbrimblecomb2u@arstechnica.com	5311382298
104	Dorris	Tagopia	dkleinhaus2v@google.ru	4696465492
105	Augustina	Eidel	aeverton2w@friendfeed.com	1272461071
106	Staci	Dynabox	ssellner2x@blogs.com	2737531059
107	Lenee	Cogilith	lroy2y@oakley.com	7373993673
108	Alethea	Jaxnation	alindfors2z@hubpages.com	3655447559
109	Yolane	Thoughtmix	ydalby30@skype.com	5334529892
110	Jill	Twiyo	jcomberbeach31@ucoz.com	1651503885
111	Jillie	Voonder	jsyfax32@walmart.com	1268951146
112	Chloe	Fiveclub	cbackshaw33@storify.com	9124715887
113	Nerita	Shufflester	nsterndale34@imgur.com	2141364262
114	Bunny	Vimbo	bcardow35@xrea.com	3548897277
115	Tonie	Shufflebeat	tglasscoo36@google.fr	1315050306
116	Shawn	Centimia	srentenbeck37@ucoz.ru	2345546295
117	Kassie	Brainlounge	kbeisley38@comcast.net	5627539569
118	Roanna	Meetz	rhydechambers39@prweb.com	1849092940
119	Gloriane	Demivee	ggarvin3a@gravatar.com	9409074400
120	Audi	Photofeed	aofeeny3b@livejournal.com	8203336935
121	Yalonda	Blogtags	ymccourtie3c@un.org	2258931919
122	Aurore	Pixope	amewis3d@zimbio.com	4375963611
123	Lisa	Meevee	lsmallthwaite3e@exblog.jp	9091507452
124	Oona	Shufflester	osaffon3f@google.fr	8131392354
125	Flossi	Photojam	fjurewicz3g@imageshack.us	2826601423
126	Alexandrina	Skippad	atrodden3h@deliciousdays.com	8826840449
127	Gael	Dabfeed	gdanskine3i@unesco.org	3201094220
128	Wendie	Skiba	wsent3j@issuu.com	4491624536
129	Maxie	Flashspan	mrawlingson3k@flavors.me	2157628348
130	Jacinda	Thoughtbeat	jfernanando3l@amazon.de	2838833906
131	Agnesse	Oozz	aepple3m@hao123.com	9873556056
132	Antonetta	Mybuzz	apedrocchi3n@miibeian.gov.cn	6438270106
133	Remy	Skiba	rkahn3o@gnu.org	7592226090
134	Edithe	Layo	estote3p@vk.com	2922568579
135	Beatrice	Zava	bchimes3q@earthlink.net	4124229589
136	Merrilee	Vitz	mglass3r@nih.gov	7656725957
137	Hyacintha	Yata	hpittet3s@bbb.org	9739815150
138	Ginnie	Brightbean	gharle3t@opensource.org	5045043553
139	Cecilia	DabZ	ccaine3u@house.gov	9921720924
140	Jandy	Edgetag	jreedick3v@mysql.com	5677274378
141	Candie	Thoughtworks	cdallicoat3w@t.co	3408628793
142	Georgina	Jabberbean	ggoodban3x@wikia.com	1659446330
143	Lorelle	Npath	lblackborn3y@technorati.com	1539740407
144	Margit	Aimbo	mwaghorn3z@etsy.com	2837096589
145	Xenia	Edgeblab	xollerhad40@quantcast.com	9043865470
146	Nanon	Eire	ncopper41@marketwatch.com	3878899522
147	Mil	Thoughtbeat	mnoore42@who.int	8366536557
148	Elayne	Yambee	eproudlock43@hexun.com	9607953384
149	Alie	Yozio	agreeves44@icq.com	1268529572
150	Lorinda	Yakijo	lsprason45@vinaora.com	4716821031
151	Moira	Fivespan	mscarce46@aboutads.info	7257100519
152	Carlyn	Photolist	cpickervance47@reddit.com	9579467716
153	Pier	Jabberbean	ppalethorpe48@bloglovin.com	7764484959
154	Demetris	Wikido	dcasier49@amazon.co.uk	2842388367
155	Glennis	Feednation	gbetjes4a@example.com	7312305967
156	Margaretha	Wikizz	maltree4b@discovery.com	9728147519
157	Gina	Quimm	glamort4c@github.com	4784062880
158	Carley	Youtags	ctrout4d@adobe.com	2249513205
159	Rachael	Riffpath	rbolley4e@foxnews.com	5227746023
160	Esta	Digitube	emaystone4f@nba.com	7653337934
161	Cloe	Abata	cgosse4g@usnews.com	5192911618
162	Nettie	Zoomzone	ngagin4h@bravesites.com	3922049786
163	Rayna	Camimbo	rthomas4i@issuu.com	7589627618
164	Eleonore	Skyvu	eliptrot4j@studiopress.com	6791047043
165	Carole	Tagcat	cperrin4k@businesswire.com	8151874475
166	Kary	Jaxnation	kchanson4l@linkedin.com	8704645069
167	Stacey	Zazio	schildrens4m@go.com	3673134118
168	Lorinda	Thoughtblab	llatan4n@reddit.com	2582732837
169	Merrie	Jabberbean	mmacneely4o@mit.edu	8045939195
170	Darcie	Dablist	dateridge4p@statcounter.com	1031695081
171	Avrit	Minyx	aizat4q@prlog.org	2862471609
172	Bamby	Twimm	brape4r@prnewswire.com	3754004549
173	Carlin	Buzzshare	cpierse4s@google.pl	4915134425
174	Glenna	Jabbercube	gdrugan4t@naver.com	3906268443
175	Malissia	Wordpedia	malphege4u@eventbrite.com	3255078522
176	Keri	Edgeify	kriley4v@fastcompany.com	3518597978
177	Melva	Eare	mmcpeck4w@ebay.com	3341441775
178	Imogene	Aimbo	irotham4x@bizjournals.com	5312613752
179	Della	Flipbug	doakenfield4y@guardian.co.uk	7426460265
180	Crissie	Chatterpoint	cgovier4z@sohu.com	8092671560
181	Tobye	Minyx	tleving50@examiner.com	6654538094
182	Leora	Quinu	lvorley51@aboutads.info	4204791304
183	Candace	Buzzbean	cbrimblecombe52@ustream.tv	2008044961
184	Tobe	Devify	tettery53@discovery.com	5999988397
185	Bobette	Skyble	bgitting54@hibu.com	7589110986
186	Clara	Wordtune	cshields55@scribd.com	2302019044
187	Abbi	Fliptune	awinyard56@mediafire.com	5398470733
188	Elsey	Zoomdog	ephilippard57@si.edu	9982586544
189	Yalonda	Skalith	ymillen58@yahoo.com	9512775254
190	Leelah	Tagchat	lsummers59@flickr.com	7017929577
191	Grayce	Demimbu	gcowp5a@irs.gov	8132605597
192	Felisha	Photospace	fcrosfield5b@123-reg.co.uk	7905256925
193	Lynnette	Vitz	lgayton5c@redcross.org	2473963956
194	Salomi	Wordpedia	siley5d@harvard.edu	7746210594
195	Zsazsa	Quatz	zmanuello5e@mail.ru	7977499843
196	Ellie	Voomm	esayton5f@dot.gov	9185551015
197	Freddie	Pixope	fcollacombe5g@drupal.org	7178073289
198	Yolanthe	Eamia	yhebbard5h@posterous.com	1744132906
199	Ulrica	Dazzlesphere	uniece5i@51.la	2136418436
200	Cortney	Meevee	cdanskine5j@usda.gov	6862747931
201	Ofelia	Eare	odunderdale5k@google.nl	8382496364
202	Tessie	Demizz	tgerdes5l@europa.eu	4881402683
203	Simonne	Yozio	smotherwell5m@google.cn	2254257644
204	Naoma	Jatri	nogden5n@independent.co.uk	3254540727
205	Doralynne	Topicblab	dmapother5o@multiply.com	8123371210
206	Mariette	Jaloo	mtesauro5p@time.com	4064555568
207	Micaela	Zoonoodle	mgodier5q@auda.org.au	6752305971
208	Gale	Tagopia	gware5r@about.me	9139911534
209	Rianon	Edgetag	rstarkings5s@geocities.com	4014223818
210	Dulsea	Trunyx	dsimonin5t@51.la	6443229829
211	Kalindi	Meeveo	kmcphillimey5u@foxnews.com	2064290249
212	Bernete	Skilith	bhounsham5v@webmd.com	7716501508
213	Sarah	Abatz	sdetocqueville5w@gizmodo.com	4107493292
214	Pearla	Meevee	pbonhan5x@youtu.be	3576182388
215	Melisandra	Skippad	mloads5y@dyndns.org	1844147570
216	Carleen	Dynabox	cughetti5z@xinhuanet.com	9082753434
217	Oralle	Photospace	opoure60@freewebs.com	3842652076
218	Suzie	Brainverse	svanetti61@nba.com	4182777891
219	Kelley	Edgetag	khaestier62@cargocollective.com	9385402874
220	Roby	Fivebridge	rlewerenz63@youtu.be	2456204151
221	Lisette	Quatz	lgonsalvez64@rakuten.co.jp	8298654557
222	Moira	Kwinu	msouthway65@eventbrite.com	5844711300
223	Norah	Twitternation	nrafe66@examiner.com	9092379475
224	Margarita	Rooxo	mdimitriou67@nasa.gov	9309753680
225	Marijo	Realcube	mmusterd68@aboutads.info	6894841401
226	Laverne	Zoomdog	ltrustram69@rambler.ru	8134954935
227	Robbin	Trunyx	rdewfall6a@artisteer.com	9627558796
228	Hedvig	Jaxnation	hrizzardi6b@uiuc.edu	6752145164
229	Bette	Youopia	bchapellow6c@tumblr.com	3649919552
230	Moria	Innojam	mmorson6d@rambler.ru	9382291399
231	Glynis	Twimbo	glennard6e@weebly.com	1246097979
232	Lisa	Quimm	lvickarman6f@cam.ac.uk	7944423049
233	Auberta	Zoozzy	asheringham6g@bloglovin.com	3939005499
234	Mara	Gigaclub	mworboy6h@ycombinator.com	9054143716
235	Carolyn	Jaxnation	cgittose6i@java.com	3608696771
236	Rhonda	Oyope	rglasheen6j@answers.com	9751852966
237	Eva	Abatz	esimister6k@state.gov	5368047773
238	Caty	Browsetype	cdrakes6l@aboutads.info	6321441359
239	Ondrea	Linktype	omeneur6m@chronoengine.com	7282082839
240	Bernardine	Quaxo	bcauson6n@dagondesign.com	5094590338
241	Maxi	Yadel	mcruttenden6o@yandex.ru	6942704267
242	Isabelita	Fatz	ifruser6p@posterous.com	7372766623
243	Susanetta	Meevee	sbaldery6q@huffingtonpost.com	1649969807
244	Deloria	Wordpedia	dwarrell6r@exblog.jp	2847241534
245	Ollie	Dabtype	omcenery6s@europa.eu	7762321358
246	Ailis	Yamia	ashoutt6t@elegantthemes.com	8092566354
247	Leia	Browsezoom	lkennet6u@domainmarket.com	3543598397
248	Jerrie	Kaymbo	jholdin6v@buzzfeed.com	2701287658
249	Mellie	Blognation	msnooks6w@multiply.com	5362728178
250	Sabra	Jayo	sledgister6x@unesco.org	2377183276
\.


--
-- TOC entry 5465 (class 0 OID 41155)
-- Dependencies: 264
-- Data for Name: PUESTOS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."PUESTOS" (id_puesto, descripcion, id_area, id_sucursal) FROM stdin;
1	Wax warmer for creating a soothing atmosphere with fragrances.	1	1
2	Individually packaged bars made with dried fruits and nuts.	2	2
3	Powerful hand blender for soups and smoothies.	3	3
4	Instant mix for creamy vanilla pudding.	4	4
5	Hearty beef chili, ready to heat and eat.	5	5
6	Heavy-duty grill pan for indoor grilling.	6	6
7	Comfortable carry for pets while hiking or traveling.	7	7
8	Compact hair straightener for travel.	8	8
9	Refreshing sparkling water infused with cranberry and lime flavors.	9	9
10	Unique handcrafted utensils for cooking and serving.	10	10
11	Ergonomic mouse designed for gamers with high DPI.	11	11
12	Rich and creamy milk perfect for baking or desserts.	12	12
13	Portable projector with 1080p resolution for movies.	13	13
14	DIY projector that magnifies your smartphone screen for movie nights.	14	14
15	Shredded cabbage and carrots for coleslaw.	15	15
16	A spicy glaze made with sriracha and honey, perfect for meats.	16	16
17	Crispy pastry filled with seasoned vegetables.	17	17
18	Smart robotic vacuum for automatic cleaning.	18	18
19	Heavy-duty rope suitable for boating, camping, and general use.	19	19
20	Fresh salsa made with tomatoes, onions, and cilantro.	20	20
21	Sweet and tangy mango chutney for a flavorful dip.	21	21
22	Easy-to-read digital kitchen timer with alarms.	22	22
23	Travel-friendly water bottle for pets on the go.	23	23
24	Safe cleaning solution and tools for electronics screens.	24	24
25	Genuine leather wallet with multiple compartments.	25	25
26	Classic wooden puzzle game for kids and adults.	26	26
27	Convenient carrier for transporting yoga mat.	27	27
28	Stylish stand to hold your recipes while cooking.	28	28
29	Reusable suction cup hooks for hanging items.	29	29
30	Fudgy brownie bites, perfect for sharing or snacking.	30	30
31	Set with various resistance bands for workouts.	31	31
32	Energy-efficient lights that charge during the day and illuminate at night.	32	32
33	No-bake protein balls with chocolate and coconut flavors.	33	33
34	Accurate stopwatch for timing events and workouts.	34	34
35	Eco-friendly reusable bags for snacks.	35	35
36	A nutritious quinoa salad with veggies and dressing, ready-to-eat.	36	36
37	A nutritious salad with quinoa and black beans	37	37
38	Plant-based mayonnaise for a creamy taste.	38	38
39	Frozen pizza loaded with fresh vegetables and mozzarella cheese.	39	39
40	Complete set for mixing cocktails at home.	40	40
41	Jump rope that counts your jumps for tracking workouts.	41	41
42	Juicy chicken breast stuffed with spinach and feta cheese, seasoned to perfection.	42	42
43	Low-carb vegetable for pasta alternatives.	43	43
44	Tofu stir-fried with fresh vegetables in teriyaki sauce.	44	44
45	Frozen cauliflower bites coated in spicy buffalo sauce, ready to bake and enjoy as an appetizer.	45	45
46	Chocolate-covered candy bars with coconut and almonds.	46	46
47	Spicy and flavorful curry paste for authentic Thai dishes.	47	47
48	Delicious ravioli filled with creamy ricotta and fresh spinach.	48	48
49	Creamy and smooth peanut butter, perfect for sandwiches.	49	49
50	Oats and honey bars with a chewy texture and nutty flavor.	50	50
51	Crispy baked radish chips, a healthy snack alternative.	51	51
52	Creamy pumpkin soup with spices	52	52
53	Wheeled cooler for transporting drinks and snacks.	53	53
54	Stylish insulated lunch bag for on-the-go meals.	54	54
55	Handy dispenser for quick access to safety pins.	55	55
56	Multiple USB ports for charging devices simultaneously.	56	56
57	Lightweight cover-up perfect for the beach, with a breezy design.	57	57
58	Portable bed for pets while traveling.	58	58
59	Fragrant fried rice with authentic Thai basil and veggies.	59	59
60	Multi-level cat tree for play and scratching.	60	60
61	High-quality leather wallet with multiple compartments.	61	61
62	Spicy cornbread infused with jalapeños for a kick of flavor at your next meal.	62	62
63	Effective roller for removing pet hair from furniture.	63	63
64	A hearty mix of beans in a flavorful tomato broth.	64	64
65	Gentle brush for removing loose fur from pets.	65	65
66	Fresh sliced bell peppers for salads or stir-fries.	66	66
67	Fresh kale salad with a zesty lemon dressing, great as a side dish.	67	67
68	Retro arcade machine for classic gaming.	68	68
69	Unique handcrafted utensils for cooking and serving.	69	69
70	Convenient and low-carb alternative to traditional rice.	70	70
71	Crunchy seeds perfect for toppings and baking.	71	71
72	Stylish cap to complete your athletic look.	72	72
73	Tender sweet corn kernels, ready to eat or add to dishes.	73	73
74	Flour tortilla filled with cheese and a medley of vegetables.	74	74
75	Reusable mat that prevents food from sticking to the grill.	75	75
76	Breathable tank top perfect for workouts or casual wear.	76	76
77	A blend of assorted nuts, perfect for snacking or adding to recipes.	77	77
78	Instant ramen cups with flavor-packed broth.	78	78
79	Sturdy mobile workbench with storage options.	79	79
80	Bottle that allows you to infuse your water with fruits.	80	80
81	A comfortable crew neck sweater, great for all seasons.	81	81
82	Sweet and crisp apples, perfect for snacking.	82	82
83	A smoky blend of spices for grilling and roasting.	83	83
84	Continuous stream of fresh water for pets, promoting hydration.	84	84
85	True wireless earbuds with excellent sound quality.	85	85
86	Creamy yogurt blended with fresh pineapple and coconut pieces.	86	86
87	Convenient charging stand for smartphones and devices.	87	87
88	Fresh pre-cut carrot and celery sticks for easy snacking.	88	88
89	Classic chino shorts in a versatile color for summer adventures.	89	89
90	Savory and chewy beef jerky with teriyaki flavor.	90	90
91	Compact wireless printer for home use.	91	91
92	Essential attachments for pressure washing.	92	92
93	Beginner-friendly drone with HD camera.	93	93
94	Sweet and chewy taffy flavored like caramel apples, great for fall.	94	94
95	Marinated beef strips in teriyaki sauce for easy grilling.	95	95
96	Fresh and organic sweet potatoes, ideal for roasting.	96	96
97	Gluten-free bread mix made with almond flour.	97	97
98	Convenient stroller for pets to enjoy outdoor walks.	98	98
99	DIY kit to convert your smartphone into a mini projector.	99	99
100	Nutritious and hearty pasta made from whole wheat flour.	100	100
101	Countertop compost bin for kitchen waste.	101	101
102	Marinated chicken skewers infused with traditional tandoori spices.	102	102
103	Citrusy lemons perfect for drinks and cooking.	103	103
104	High-quality matcha powder for smoothies and baking.	104	104
105	Sweet and tangy raspberry lime beverage	105	105
106	Compact and stylish indoor/outdoor fire pit for ambiance.	106	106
107	Soft bagels flavored with cinnamon and raisins.	107	107
108	A refreshing salad with chickpeas, cucumber, tomatoes, and a light vinaigrette dressing.	108	108
109	Complete crafting kit for kids and adults.	109	109
110	Instant oatmeal cups with blueberries for an easy breakfast.	110	110
111	Delicious mini donuts dusted with cinnamon sugar.	111	111
112	Creamy risotto made with mushrooms and herbs, perfect as a side dish or main course.	112	112
113	Spicy and smoky sausage great for grilling.	113	113
114	Quality scissors designed for easy pet grooming.	114	114
115	Luxurious satin slip dress for an elegant evening look.	115	115
116	GPS collar that monitors your pet's location and activity level.	116	116
117	A trendy oversized denim shirt perfect for layering.	117	117
118	Fluffy quinoa mixed with lemon zest and herbs, a perfect side.	118	118
119	Moisturizing body wash with natural ingredients.	119	119
120	Durable and shatterproof silicone glasses for outdoor use.	120	120
121	Smart tracker to locate keys or other items via app.	121	121
122	Savory wraps with buffalo chicken and fresh vegetables.	122	122
123	Upgrade your phone photography with this lens kit that includes wide-angle and macro lenses.	123	123
124	Self-cleaning grooming brush for cats and dogs.	124	124
125	A comfortable henley shirt made of soft cotton, perfect for casual outings.	125	125
126	Freshly baked artisan bread, perfect for sandwiches or toasting.	126	126
127	Spicy and flavorful curry paste for authentic Thai dishes.	127	127
128	Reusable straws that come with a cleaning brush.	128	128
129	Stainless steel travel mug that keeps drinks hot or cold.	129	129
130	DIY kit to convert your smartphone into a mini projector.	130	130
131	Compact sterilizer for disinfecting small items.	131	131
132	Refreshing coconut water packed with electrolytes for hydration.	132	132
133	A lightweight tank dress, ideal for warm weather outings.	133	133
134	Sweet and crunchy roasted almonds.	134	134
135	Ready-to-eat chia seed pudding made with coconut milk, perfect for breakfast or dessert.	135	135
136	Abstract canvas print to enhance home decor.	136	136
137	Airtight container to keep pet food fresh.	137	137
138	Flavorful sauce perfect for stir-frying vegetables and tofu.	138	138
139	Savory sausage with a blend of spices, perfect for pasta dishes.	139	139
140	Bold graphic hoodie featuring a comfortable fit and soft fabric.	140	140
141	Indoor Wi-Fi camera for home security.	141	141
142	Stay hydrated with refreshing flavored water.	142	142
143	Protective goggles for DIY and construction work.	143	143
144	Crispy chicken bites, perfect for dipping.	144	144
145	Mild cheese great for sandwiches.	145	145
146	Savory sausage links with a hint of maple flavor.	146	146
147	Wild-caught tuna in olive oil, perfect for salads.	147	147
148	Smoky and sweet BBQ sauce for grilling and dipping.	148	148
149	Retro-style graphic tee with a soft wash for a vintage feel.	149	149
150	Versatile puff pastry for pies and pastries.	150	150
151	Laundry bags perfect for delicates and organizing clothes.	151	151
152	Crispy cheese snacks that melt in your mouth.	152	152
153	Convenient stroller for pets to enjoy outdoor walks.	153	153
154	Rechargeable LED lantern ideal for camping and outdoor activities.	154	154
155	Rechargeable lantern with multiple brightness settings for outdoors.	155	155
156	Spicy black bean burgers, great on the grill.	156	156
157	A rich coconut curry sauce perfect for simmering vegetables or meats.	157	157
158	Anti-fog ski goggles for winter sports.	158	158
159	Lightweight hammock with a sturdy stand for relaxation anywhere.	159	159
160	Sturdy grip to hold your phone securely while taking selfies.	160	160
161	Easy-to-make falafel mix for a tasty vegetarian meal.	161	161
162	Fresh baby spinach leaves, great for salads and smoothies.	162	162
163	Easy-to-set-up picnic table for outdoor dining.	163	163
164	Soft hamburger buns made with whole grains.	164	164
165	Spicy salsa made with fresh ingredients.	165	165
166	Space-saving bike for indoor workouts.	166	166
167	Crunchy corn chips flavored with chili and lime for a zesty kick.	167	167
168	Perfectly designed pan for making crepes and pancakes.	168	168
169	A flavorful sauce for stir-frying vegetables and meats.	169	169
170	Marinated beef strips in teriyaki sauce for easy grilling.	170	170
171	Multi-level cat tree for play and scratching.	171	171
172	All-in-one art set for kids to unleash creativity.	172	172
173	Gluten-free bread mix made with almond flour.	173	173
174	Fun inflatable float for lounging in the pool or beach.	174	174
175	Crispy and crunchy snack made from assorted vegetables.	175	175
176	Whole wheat wraps filled with spinach and feta cheese.	176	176
177	Fresh sliced bell peppers for salads or stir-fries.	177	177
178	Roasted pistachios, a healthy and tasty snack.	178	178
179	Adjustable stand to improve ergonomics while working on a laptop.	179	179
180	Hearty beef chili, ready to heat and eat.	180	180
181	High-quality whey protein powder for muscle recovery.	181	181
182	Sweet and salty popcorn with sea salt and caramel, a tasty treat.	182	182
183	Stay hydrated with refreshing flavored water.	183	183
184	Comprehensive first aid kit for home or travel emergencies.	184	184
185	Moist brownie topped with sea salt and caramel drizzle.	185	185
186	Educational tablet designed for preschool-age children.	186	186
187	Fun robot that engages kids with games and activities.	187	187
188	A delicious pizza loaded with vegetables	188	188
189	Simple tool to train your pet with positive reinforcement.	189	189
190	Salmon fillets seasoned with lemon and dill, perfect for grilling.	190	190
191	A refreshing drink mix that combines sweet raspberries and tart lemons, perfect for summer.	191	191
192	Powerful electric pressure washer for deep cleaning.	192	192
193	Sweet, chewy dried apricots, great for snacking or baking.	193	193
194	Safe and vibrant crayons for children's art projects.	194	194
195	Quick boiling kettle for small kitchens and dorms.	195	195
196	High-quality sketchbook for artists.	196	196
197	Comprehensive emergency kit for roadside assistance.	197	197
198	Secure phone mount that wirelessly charges your device while driving.	198	198
199	Trendy belt bag for hands-free carrying.	199	199
200	Crunchy cacao nibs, great for adding to smoothies or baking.	200	200
201	Spicy seasoning mix for all your favorite dishes.	201	201
202	A bright and zesty dressing perfect for salads and tacos.	202	202
203	All-in-one kit for making pasta salad easily.	203	203
204	Super soft fleece blanket, perfect for coziness.	204	204
205	Fresh mango salsa with a hint of lime for a zesty topping.	205	205
206	Thick and durable mat for workouts and yoga.	206	206
207	Durable jump rope for cardio workouts.	207	207
208	Therapeutic weighted blanket for better sleep.	208	208
209	Water-resistant blanket for picnics and outdoor events.	209	209
210	Spicy jalapenos stuffed with cheese, ideal for appetizers.	210	210
211	A healthy oil extracted from avocados, ideal for frying and salads.	211	211
212	Lightweight leaf blower for maintaining outdoor spaces.	212	212
213	Miso paste for making traditional Japanese miso soup.	213	213
214	Storage organizer for art supplies and tools.	214	214
215	Therapeutic weighted blanket for better sleep.	215	215
216	Gentle grooming gloves for shedding pets.	216	216
217	Light and fluffy cream cheese, perfect for bagels or cooking.	217	217
218	Cook rice and steam vegetables simultaneously for healthy meals.	218	218
219	Aromatic fresh basil, perfect for Italian cooking.	219	219
220	Soft and breathable cotton sweatpants perfect for lounging or workouts.	220	220
221	Tool to check car engine codes and performance issues.	221	221
222	Smooth soup made from carrots and ginger, great for cold days.	222	222
223	Delicious cookies with cranberries and almonds in every bite.	223	223
224	Activity workbook for early learning and fun.	224	224
225	Set of resistance bands for strength training at home.	225	225
226	Creamy and smooth peanut butter, perfect for sandwiches.	226	226
227	Portable induction cooktop for quick heating.	227	227
228	Essential tools for on-the-go bike maintenance.	228	228
229	Lightweight hammock for easy setup anywhere.	229	229
230	Ready-to-eat chia seed pudding made with coconut milk, perfect for breakfast or dessert.	230	230
231	A hearty salad with grains, dried fruits, and nuts.	231	231
232	Unsweetened frozen acai purée for smoothies and bowls.	232	232
233	Multi-function pressure cooker that can sauté, steam, and slow cook.	233	233
234	A creamy blend of avocados and lime juice, great for spreads or dips.	234	234
235	Ready-to-eat chia seed pudding made with coconut milk, perfect for breakfast or dessert.	235	235
236	Compact wireless printer for home use.	236	236
237	Creamy risotto made with mushrooms and herbs, perfect as a side dish or main course.	237	237
238	A perfect blend of pineapple and teriyaki for stir-fry.	238	238
239	A mix of nuts, pretzels, and crackers, seasoned just right for snacking.	239	239
240	Easy-to-prepare rice with cilantro and lime flavors, great as a side.	240	240
241	Decadent tart made with rich dark chocolate.	241	241
242	Organize your board games with this storage bin.	242	242
243	Fresh, creamy avocados ideal for salads and guacamole.	243	243
244	Ergonomically designed pillow with breathable bamboo cover.	244	244
245	Comfortable mouse pad designed to reduce wrist strain.	245	245
246	Stabilizing gimbal for smooth video recording.	246	246
247	Refreshing sparkling water with cucumber and lime flavor.	247	247
248	Juicy pork tenderloin, great for roasting.	248	248
249	Nutty and wholesome brown rice.	249	249
250	Ideal for creating custom designs on t-shirts and fabrics.	250	250
\.


--
-- TOC entry 5466 (class 0 OID 41160)
-- Dependencies: 265
-- Data for Name: RESERVACIONES; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."RESERVACIONES" (id_reservacion, id_clientes, id_sucursal, id_estado_reservacion, numero_tarjeta, fecha_check_in, fecha_check_out) FROM stdin;
1	1	1	1	1	2025-08-04 00:00:00-06	2025-03-29 00:00:00-06
2	2	2	2	2	2025-07-18 00:00:00-06	2025-01-22 00:00:00-06
3	3	3	3	3	2024-11-23 00:00:00-06	2025-07-16 00:00:00-06
4	4	4	4	4	2024-12-28 00:00:00-06	2025-08-05 00:00:00-06
5	5	5	5	5	2024-11-06 00:00:00-06	2025-01-28 00:00:00-06
6	6	6	6	6	2025-01-28 00:00:00-06	2024-11-12 00:00:00-06
7	7	7	7	7	2024-12-30 00:00:00-06	2025-08-25 00:00:00-06
8	8	8	8	8	2025-07-03 00:00:00-06	2025-04-23 00:00:00-06
9	9	9	9	9	2025-02-07 00:00:00-06	2024-10-06 00:00:00-06
10	10	10	10	10	2025-05-16 00:00:00-06	2025-07-03 00:00:00-06
11	11	11	11	11	2025-03-19 00:00:00-06	2025-05-13 00:00:00-06
12	12	12	12	12	2025-01-07 00:00:00-06	2025-07-20 00:00:00-06
13	13	13	13	13	2025-02-26 00:00:00-06	2024-10-09 00:00:00-06
14	14	14	14	14	2025-04-30 00:00:00-06	2025-07-18 00:00:00-06
15	15	15	15	15	2025-05-30 00:00:00-06	2024-12-15 00:00:00-06
16	16	16	16	16	2024-12-08 00:00:00-06	2025-07-18 00:00:00-06
17	17	17	17	17	2025-07-13 00:00:00-06	2025-09-15 00:00:00-06
18	18	18	18	18	2025-06-18 00:00:00-06	2025-02-10 00:00:00-06
19	19	19	19	19	2025-06-27 00:00:00-06	2025-03-20 00:00:00-06
20	20	20	20	20	2025-04-26 00:00:00-06	2025-03-11 00:00:00-06
21	21	21	21	21	2024-10-10 00:00:00-06	2024-10-22 00:00:00-06
22	22	22	22	22	2025-03-27 00:00:00-06	2025-03-25 00:00:00-06
23	23	23	23	23	2025-04-30 00:00:00-06	2024-12-31 00:00:00-06
24	24	24	24	24	2025-08-19 00:00:00-06	2025-04-17 00:00:00-06
25	25	25	25	25	2024-11-10 00:00:00-06	2024-12-19 00:00:00-06
26	26	26	26	26	2025-01-05 00:00:00-06	2025-08-11 00:00:00-06
27	27	27	27	27	2025-09-23 00:00:00-06	2025-07-22 00:00:00-06
28	28	28	28	28	2025-03-05 00:00:00-06	2025-04-11 00:00:00-06
29	29	29	29	29	2025-01-19 00:00:00-06	2025-07-05 00:00:00-06
30	30	30	30	30	2025-07-19 00:00:00-06	2025-04-17 00:00:00-06
31	31	31	31	31	2025-01-11 00:00:00-06	2024-12-24 00:00:00-06
32	32	32	32	32	2025-02-15 00:00:00-06	2025-02-23 00:00:00-06
33	33	33	33	33	2024-12-02 00:00:00-06	2025-03-20 00:00:00-06
34	34	34	34	34	2025-04-25 00:00:00-06	2025-09-18 00:00:00-06
35	35	35	35	35	2025-03-08 00:00:00-06	2025-07-31 00:00:00-06
36	36	36	36	36	2025-02-28 00:00:00-06	2025-03-27 00:00:00-06
37	37	37	37	37	2025-08-04 00:00:00-06	2025-06-20 00:00:00-06
38	38	38	38	38	2025-04-12 00:00:00-06	2025-02-09 00:00:00-06
39	39	39	39	39	2025-03-12 00:00:00-06	2025-01-07 00:00:00-06
40	40	40	40	40	2025-02-14 00:00:00-06	2025-02-11 00:00:00-06
41	41	41	41	41	2025-08-12 00:00:00-06	2025-06-30 00:00:00-06
42	42	42	42	42	2025-02-22 00:00:00-06	2025-05-25 00:00:00-06
43	43	43	43	43	2025-05-23 00:00:00-06	2025-04-10 00:00:00-06
44	44	44	44	44	2025-06-22 00:00:00-06	2025-09-12 00:00:00-06
45	45	45	45	45	2025-07-24 00:00:00-06	2025-06-18 00:00:00-06
46	46	46	46	46	2025-01-01 00:00:00-06	2025-07-24 00:00:00-06
47	47	47	47	47	2025-07-05 00:00:00-06	2025-01-13 00:00:00-06
48	48	48	48	48	2025-03-03 00:00:00-06	2024-11-09 00:00:00-06
49	49	49	49	49	2024-10-10 00:00:00-06	2025-03-14 00:00:00-06
50	50	50	50	50	2025-02-06 00:00:00-06	2024-10-07 00:00:00-06
51	51	51	51	51	2025-02-04 00:00:00-06	2025-04-24 00:00:00-06
52	52	52	52	52	2024-12-26 00:00:00-06	2025-07-21 00:00:00-06
53	53	53	53	53	2025-01-31 00:00:00-06	2025-05-17 00:00:00-06
54	54	54	54	54	2025-06-30 00:00:00-06	2024-10-08 00:00:00-06
55	55	55	55	55	2025-03-09 00:00:00-06	2024-10-05 00:00:00-06
56	56	56	56	56	2025-01-02 00:00:00-06	2025-05-04 00:00:00-06
57	57	57	57	57	2025-07-15 00:00:00-06	2025-02-16 00:00:00-06
58	58	58	58	58	2025-06-23 00:00:00-06	2025-06-02 00:00:00-06
59	59	59	59	59	2025-08-17 00:00:00-06	2025-04-18 00:00:00-06
60	60	60	60	60	2025-09-24 00:00:00-06	2025-02-16 00:00:00-06
61	61	61	61	61	2025-06-24 00:00:00-06	2025-01-26 00:00:00-06
62	62	62	62	62	2025-06-11 00:00:00-06	2025-04-22 00:00:00-06
63	63	63	63	63	2024-12-21 00:00:00-06	2025-07-22 00:00:00-06
64	64	64	64	64	2025-01-25 00:00:00-06	2025-03-22 00:00:00-06
65	65	65	65	65	2024-12-13 00:00:00-06	2024-09-30 00:00:00-06
66	66	66	66	66	2025-01-19 00:00:00-06	2025-09-19 00:00:00-06
67	67	67	67	67	2025-09-13 00:00:00-06	2025-05-02 00:00:00-06
68	68	68	68	68	2025-01-29 00:00:00-06	2025-03-26 00:00:00-06
69	69	69	69	69	2025-01-11 00:00:00-06	2025-05-14 00:00:00-06
70	70	70	70	70	2025-05-16 00:00:00-06	2024-11-12 00:00:00-06
71	71	71	71	71	2025-09-26 00:00:00-06	2025-08-14 00:00:00-06
72	72	72	72	72	2025-03-12 00:00:00-06	2024-10-17 00:00:00-06
73	73	73	73	73	2024-11-07 00:00:00-06	2025-01-02 00:00:00-06
74	74	74	74	74	2024-11-21 00:00:00-06	2025-09-07 00:00:00-06
75	75	75	75	75	2025-06-16 00:00:00-06	2025-07-19 00:00:00-06
76	76	76	76	76	2025-06-22 00:00:00-06	2025-03-10 00:00:00-06
77	77	77	77	77	2025-05-31 00:00:00-06	2025-04-02 00:00:00-06
78	78	78	78	78	2025-04-13 00:00:00-06	2025-05-25 00:00:00-06
79	79	79	79	79	2024-11-14 00:00:00-06	2025-06-10 00:00:00-06
80	80	80	80	80	2025-09-08 00:00:00-06	2025-04-24 00:00:00-06
81	81	81	81	81	2025-03-23 00:00:00-06	2025-05-10 00:00:00-06
82	82	82	82	82	2025-06-01 00:00:00-06	2025-04-05 00:00:00-06
83	83	83	83	83	2025-08-24 00:00:00-06	2025-08-16 00:00:00-06
84	84	84	84	84	2024-11-05 00:00:00-06	2025-03-08 00:00:00-06
85	85	85	85	85	2024-12-08 00:00:00-06	2024-11-29 00:00:00-06
86	86	86	86	86	2025-09-03 00:00:00-06	2025-02-07 00:00:00-06
87	87	87	87	87	2025-03-31 00:00:00-06	2025-08-30 00:00:00-06
88	88	88	88	88	2024-11-12 00:00:00-06	2025-04-05 00:00:00-06
89	89	89	89	89	2025-06-20 00:00:00-06	2025-07-17 00:00:00-06
90	90	90	90	90	2025-05-10 00:00:00-06	2025-04-02 00:00:00-06
91	91	91	91	91	2024-11-26 00:00:00-06	2024-12-01 00:00:00-06
92	92	92	92	92	2025-05-21 00:00:00-06	2025-08-06 00:00:00-06
93	93	93	93	93	2025-09-02 00:00:00-06	2024-12-09 00:00:00-06
94	94	94	94	94	2025-03-10 00:00:00-06	2025-06-13 00:00:00-06
95	95	95	95	95	2025-01-26 00:00:00-06	2025-08-24 00:00:00-06
96	96	96	96	96	2025-03-05 00:00:00-06	2025-03-20 00:00:00-06
97	97	97	97	97	2025-01-19 00:00:00-06	2024-12-28 00:00:00-06
98	98	98	98	98	2024-12-27 00:00:00-06	2025-08-10 00:00:00-06
99	99	99	99	99	2025-04-06 00:00:00-06	2024-11-08 00:00:00-06
100	100	100	100	100	2025-09-01 00:00:00-06	2025-02-22 00:00:00-06
101	101	101	101	101	2025-09-25 00:00:00-06	2024-10-24 00:00:00-06
102	102	102	102	102	2024-11-29 00:00:00-06	2025-08-12 00:00:00-06
103	103	103	103	103	2025-05-13 00:00:00-06	2025-06-10 00:00:00-06
104	104	104	104	104	2025-02-28 00:00:00-06	2025-08-11 00:00:00-06
105	105	105	105	105	2025-08-23 00:00:00-06	2025-02-16 00:00:00-06
106	106	106	106	106	2025-07-08 00:00:00-06	2025-07-30 00:00:00-06
107	107	107	107	107	2025-05-30 00:00:00-06	2025-01-19 00:00:00-06
108	108	108	108	108	2024-12-13 00:00:00-06	2025-02-28 00:00:00-06
109	109	109	109	109	2025-05-06 00:00:00-06	2025-05-08 00:00:00-06
110	110	110	110	110	2025-05-16 00:00:00-06	2024-11-10 00:00:00-06
111	111	111	111	111	2025-07-25 00:00:00-06	2025-04-06 00:00:00-06
112	112	112	112	112	2024-10-24 00:00:00-06	2025-04-18 00:00:00-06
113	113	113	113	113	2025-09-24 00:00:00-06	2025-01-15 00:00:00-06
114	114	114	114	114	2025-03-16 00:00:00-06	2025-04-06 00:00:00-06
115	115	115	115	115	2025-07-16 00:00:00-06	2025-03-09 00:00:00-06
116	116	116	116	116	2025-07-01 00:00:00-06	2025-05-29 00:00:00-06
117	117	117	117	117	2025-03-12 00:00:00-06	2025-06-06 00:00:00-06
118	118	118	118	118	2024-09-28 00:00:00-06	2025-02-20 00:00:00-06
119	119	119	119	119	2025-02-23 00:00:00-06	2024-12-04 00:00:00-06
120	120	120	120	120	2024-11-28 00:00:00-06	2025-01-01 00:00:00-06
121	121	121	121	121	2025-01-17 00:00:00-06	2025-04-22 00:00:00-06
122	122	122	122	122	2025-09-20 00:00:00-06	2025-02-26 00:00:00-06
123	123	123	123	123	2025-07-13 00:00:00-06	2025-07-26 00:00:00-06
124	124	124	124	124	2024-12-04 00:00:00-06	2025-07-20 00:00:00-06
125	125	125	125	125	2025-05-28 00:00:00-06	2025-04-13 00:00:00-06
126	126	126	126	126	2024-10-11 00:00:00-06	2025-01-22 00:00:00-06
127	127	127	127	127	2024-10-20 00:00:00-06	2025-01-23 00:00:00-06
128	128	128	128	128	2025-01-14 00:00:00-06	2024-12-02 00:00:00-06
129	129	129	129	129	2025-03-28 00:00:00-06	2024-12-13 00:00:00-06
130	130	130	130	130	2025-06-22 00:00:00-06	2024-11-28 00:00:00-06
131	131	131	131	131	2025-05-29 00:00:00-06	2025-01-02 00:00:00-06
132	132	132	132	132	2025-09-02 00:00:00-06	2025-01-23 00:00:00-06
133	133	133	133	133	2025-05-09 00:00:00-06	2025-09-22 00:00:00-06
134	134	134	134	134	2025-05-25 00:00:00-06	2025-09-22 00:00:00-06
135	135	135	135	135	2025-08-16 00:00:00-06	2024-10-31 00:00:00-06
136	136	136	136	136	2024-10-28 00:00:00-06	2025-02-06 00:00:00-06
137	137	137	137	137	2025-05-13 00:00:00-06	2024-11-30 00:00:00-06
138	138	138	138	138	2025-05-13 00:00:00-06	2025-06-11 00:00:00-06
139	139	139	139	139	2025-09-13 00:00:00-06	2025-02-07 00:00:00-06
140	140	140	140	140	2025-01-13 00:00:00-06	2025-04-04 00:00:00-06
141	141	141	141	141	2024-12-11 00:00:00-06	2025-09-08 00:00:00-06
142	142	142	142	142	2025-08-27 00:00:00-06	2025-01-19 00:00:00-06
143	143	143	143	143	2025-01-06 00:00:00-06	2024-10-13 00:00:00-06
144	144	144	144	144	2025-05-16 00:00:00-06	2024-12-09 00:00:00-06
145	145	145	145	145	2024-12-17 00:00:00-06	2024-12-07 00:00:00-06
146	146	146	146	146	2025-07-19 00:00:00-06	2025-04-05 00:00:00-06
147	147	147	147	147	2024-12-08 00:00:00-06	2024-10-26 00:00:00-06
148	148	148	148	148	2025-04-16 00:00:00-06	2025-08-27 00:00:00-06
149	149	149	149	149	2025-05-20 00:00:00-06	2025-05-08 00:00:00-06
150	150	150	150	150	2025-03-14 00:00:00-06	2025-08-23 00:00:00-06
151	151	151	151	151	2024-12-12 00:00:00-06	2025-03-28 00:00:00-06
152	152	152	152	152	2025-05-31 00:00:00-06	2025-05-11 00:00:00-06
153	153	153	153	153	2024-12-01 00:00:00-06	2025-03-04 00:00:00-06
154	154	154	154	154	2024-10-14 00:00:00-06	2025-06-05 00:00:00-06
155	155	155	155	155	2025-07-14 00:00:00-06	2025-09-05 00:00:00-06
156	156	156	156	156	2025-04-25 00:00:00-06	2025-01-10 00:00:00-06
157	157	157	157	157	2025-05-29 00:00:00-06	2024-12-05 00:00:00-06
158	158	158	158	158	2025-07-31 00:00:00-06	2025-03-08 00:00:00-06
159	159	159	159	159	2025-06-27 00:00:00-06	2025-08-31 00:00:00-06
160	160	160	160	160	2025-01-25 00:00:00-06	2025-03-01 00:00:00-06
161	161	161	161	161	2025-05-31 00:00:00-06	2025-01-26 00:00:00-06
162	162	162	162	162	2025-03-27 00:00:00-06	2025-01-31 00:00:00-06
163	163	163	163	163	2025-04-09 00:00:00-06	2025-05-24 00:00:00-06
164	164	164	164	164	2025-05-25 00:00:00-06	2025-01-12 00:00:00-06
165	165	165	165	165	2024-10-17 00:00:00-06	2025-03-09 00:00:00-06
166	166	166	166	166	2025-02-01 00:00:00-06	2024-12-12 00:00:00-06
167	167	167	167	167	2024-11-15 00:00:00-06	2024-12-14 00:00:00-06
168	168	168	168	168	2025-02-23 00:00:00-06	2024-11-22 00:00:00-06
169	169	169	169	169	2025-05-31 00:00:00-06	2025-08-12 00:00:00-06
170	170	170	170	170	2024-10-28 00:00:00-06	2025-08-14 00:00:00-06
171	171	171	171	171	2025-07-16 00:00:00-06	2025-01-26 00:00:00-06
172	172	172	172	172	2025-05-15 00:00:00-06	2025-01-13 00:00:00-06
173	173	173	173	173	2025-03-08 00:00:00-06	2025-04-14 00:00:00-06
174	174	174	174	174	2025-03-06 00:00:00-06	2025-06-22 00:00:00-06
175	175	175	175	175	2025-07-06 00:00:00-06	2025-09-02 00:00:00-06
176	176	176	176	176	2024-12-22 00:00:00-06	2025-04-11 00:00:00-06
177	177	177	177	177	2025-08-12 00:00:00-06	2025-09-21 00:00:00-06
178	178	178	178	178	2024-10-12 00:00:00-06	2024-10-10 00:00:00-06
179	179	179	179	179	2024-12-07 00:00:00-06	2024-12-15 00:00:00-06
180	180	180	180	180	2024-10-31 00:00:00-06	2025-04-25 00:00:00-06
181	181	181	181	181	2025-02-01 00:00:00-06	2025-08-31 00:00:00-06
182	182	182	182	182	2025-05-01 00:00:00-06	2024-10-22 00:00:00-06
183	183	183	183	183	2025-05-26 00:00:00-06	2024-12-19 00:00:00-06
184	184	184	184	184	2024-12-12 00:00:00-06	2025-04-14 00:00:00-06
185	185	185	185	185	2024-10-17 00:00:00-06	2025-05-05 00:00:00-06
186	186	186	186	186	2025-09-10 00:00:00-06	2025-02-22 00:00:00-06
187	187	187	187	187	2025-04-21 00:00:00-06	2025-01-09 00:00:00-06
188	188	188	188	188	2024-12-06 00:00:00-06	2025-08-20 00:00:00-06
189	189	189	189	189	2024-11-14 00:00:00-06	2025-08-25 00:00:00-06
190	190	190	190	190	2025-01-14 00:00:00-06	2025-08-08 00:00:00-06
191	191	191	191	191	2025-08-19 00:00:00-06	2024-12-04 00:00:00-06
192	192	192	192	192	2025-01-23 00:00:00-06	2025-04-30 00:00:00-06
193	193	193	193	193	2025-09-14 00:00:00-06	2025-05-07 00:00:00-06
194	194	194	194	194	2025-05-14 00:00:00-06	2025-01-25 00:00:00-06
195	195	195	195	195	2025-04-29 00:00:00-06	2025-04-18 00:00:00-06
196	196	196	196	196	2025-03-18 00:00:00-06	2025-03-05 00:00:00-06
197	197	197	197	197	2025-05-11 00:00:00-06	2024-11-09 00:00:00-06
198	198	198	198	198	2025-01-27 00:00:00-06	2024-10-04 00:00:00-06
199	199	199	199	199	2024-11-29 00:00:00-06	2025-01-28 00:00:00-06
200	200	200	200	200	2025-09-07 00:00:00-06	2025-04-15 00:00:00-06
201	201	201	201	201	2025-02-11 00:00:00-06	2025-08-03 00:00:00-06
202	202	202	202	202	2025-03-18 00:00:00-06	2025-01-15 00:00:00-06
203	203	203	203	203	2025-09-14 00:00:00-06	2025-08-18 00:00:00-06
204	204	204	204	204	2024-10-04 00:00:00-06	2025-01-06 00:00:00-06
205	205	205	205	205	2025-01-18 00:00:00-06	2025-05-16 00:00:00-06
206	206	206	206	206	2025-01-01 00:00:00-06	2025-01-17 00:00:00-06
207	207	207	207	207	2025-07-15 00:00:00-06	2024-10-02 00:00:00-06
208	208	208	208	208	2025-07-03 00:00:00-06	2025-06-08 00:00:00-06
209	209	209	209	209	2025-02-09 00:00:00-06	2024-10-20 00:00:00-06
210	210	210	210	210	2025-01-18 00:00:00-06	2025-06-06 00:00:00-06
211	211	211	211	211	2025-02-26 00:00:00-06	2025-03-11 00:00:00-06
212	212	212	212	212	2024-11-17 00:00:00-06	2025-02-12 00:00:00-06
213	213	213	213	213	2025-06-06 00:00:00-06	2025-08-09 00:00:00-06
214	214	214	214	214	2024-12-01 00:00:00-06	2025-07-17 00:00:00-06
215	215	215	215	215	2025-04-18 00:00:00-06	2025-05-08 00:00:00-06
216	216	216	216	216	2025-06-22 00:00:00-06	2024-11-08 00:00:00-06
217	217	217	217	217	2025-01-09 00:00:00-06	2025-02-05 00:00:00-06
218	218	218	218	218	2025-09-08 00:00:00-06	2025-04-22 00:00:00-06
219	219	219	219	219	2025-07-10 00:00:00-06	2025-08-04 00:00:00-06
220	220	220	220	220	2025-07-11 00:00:00-06	2025-07-23 00:00:00-06
221	221	221	221	221	2024-10-23 00:00:00-06	2024-11-09 00:00:00-06
222	222	222	222	222	2025-03-27 00:00:00-06	2024-11-05 00:00:00-06
223	223	223	223	223	2024-12-24 00:00:00-06	2025-08-21 00:00:00-06
224	224	224	224	224	2025-04-04 00:00:00-06	2025-06-07 00:00:00-06
225	225	225	225	225	2025-03-13 00:00:00-06	2024-12-18 00:00:00-06
226	226	226	226	226	2025-01-17 00:00:00-06	2025-07-21 00:00:00-06
227	227	227	227	227	2024-10-17 00:00:00-06	2024-10-16 00:00:00-06
228	228	228	228	228	2025-06-08 00:00:00-06	2025-01-11 00:00:00-06
229	229	229	229	229	2024-10-19 00:00:00-06	2025-02-16 00:00:00-06
230	230	230	230	230	2024-10-22 00:00:00-06	2025-01-13 00:00:00-06
231	231	231	231	231	2025-03-05 00:00:00-06	2025-04-08 00:00:00-06
232	232	232	232	232	2025-01-15 00:00:00-06	2025-01-31 00:00:00-06
233	233	233	233	233	2024-11-20 00:00:00-06	2025-08-12 00:00:00-06
234	234	234	234	234	2025-02-24 00:00:00-06	2025-03-09 00:00:00-06
235	235	235	235	235	2024-12-11 00:00:00-06	2025-02-28 00:00:00-06
236	236	236	236	236	2024-12-13 00:00:00-06	2024-12-18 00:00:00-06
237	237	237	237	237	2025-06-21 00:00:00-06	2025-08-07 00:00:00-06
238	238	238	238	238	2025-05-30 00:00:00-06	2025-04-19 00:00:00-06
239	239	239	239	239	2025-08-12 00:00:00-06	2024-10-16 00:00:00-06
240	240	240	240	240	2025-03-20 00:00:00-06	2024-12-09 00:00:00-06
241	241	241	241	241	2025-03-06 00:00:00-06	2025-01-05 00:00:00-06
242	242	242	242	242	2024-11-27 00:00:00-06	2024-10-23 00:00:00-06
243	243	243	243	243	2025-08-05 00:00:00-06	2025-03-22 00:00:00-06
244	244	244	244	244	2025-06-22 00:00:00-06	2025-08-27 00:00:00-06
245	245	245	245	245	2025-08-21 00:00:00-06	2025-04-22 00:00:00-06
246	246	246	246	246	2025-06-21 00:00:00-06	2025-09-12 00:00:00-06
247	247	247	247	247	2025-08-24 00:00:00-06	2025-05-30 00:00:00-06
248	248	248	248	248	2025-03-15 00:00:00-06	2025-05-20 00:00:00-06
249	249	249	249	249	2025-03-12 00:00:00-06	2025-03-29 00:00:00-06
250	250	250	250	250	2025-08-19 00:00:00-06	2025-05-02 00:00:00-06
\.


--
-- TOC entry 5467 (class 0 OID 41163)
-- Dependencies: 266
-- Data for Name: SALON; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."SALON" (id_salon, nombre, razon_social, capacidad, tipo, equipamiento, estado, id_sucursal) FROM stdin;
1	Camimbo	Puerto Leda	8	US	Poisoning by unsp agents aff the GI sys, assault	\N	1
2	Eamia	Hayward	7	FR	Unspecified disorder of eyelid	\N	2
3	Livepath	El Dorado	13	IE	Unspecified superficial injury of right ring finger, sequela	\N	3
4	Topiclounge	Marina	13	FR	Displacement of permanent sutures, sequela	\N	4
5	Avavee	Ziro	42	US	Toxic effect of chlorofluorocarbons, assault	\N	5
6	Blogtags	Thief River Falls	29	DE	Other infective (teno)synovitis, unspecified elbow	\N	6
7	Chatterpoint	Battle Mountain	29	US	Displaced spiral fracture of shaft of left femur, init	\N	7
8	Gevee	Toksook Bay	14	DE	Disp fx of dist pole of navic bone of l wrs, 7thD	\N	8
9	Kwimbee	Agevairu	10	US	Oth specific arthropathies, NEC, left elbow	\N	9
10	Riffpedia	Almenara	38	IE	Pre-existing hypertensive heart disease compl preg/chldbrth	\N	10
11	Feedfire	Kaltag	27	AT	Displ apophyseal fx l femr, 7thQ	\N	11
12	Bluezoom	Liverpool	33	US	Disp fx of neck of fourth metacarpal bone, left hand	\N	12
13	Tagpad	Calbayog City	19	US	Inj musc/fasc/tend at wrist and hand level, left hand	\N	13
14	Brightdog	Mokuti Lodge	7	US	Unsp pedal cyclist injured pick-up truck, pk-up/van nontraf	\N	14
15	Topdrive	Tonu	20	US	Displ oblique fx shaft of l tibia, 7thJ	\N	15
16	Devpulse	\N	24	IT	Secondary parkinsonism	\N	16
17	Tagopia	Shakiso	20	NL	Striking against diving board, sequela	\N	17
18	Twitterworks	Alagoinhas	3	NL	Gastr contents in resp tract, part unsp cause oth inj, sqla	\N	18
19	Tagcat	Suntar	31	FI	Nondisp fx of 4th metatarsal bone, l ft, 7thG	\N	19
20	Eidel	Dalnegorsk	9	AT	Diabetes with moderate nonp rtnop with macular edema, unsp	\N	20
21	Kimia	Orientos	41	US	Displ transverse fx shaft of l fibula, 7thE	\N	21
22	Browsetype	Timbunke	46	DE	Laceration of blood vessels at shldr/up arm, right arm, subs	\N	22
23	Skinte	Butler	23	US	Yellow fever, unspecified	\N	23
24	Oyonder	Karratha	20	US	Occup of bus inj pick-up truck, pk-up/van nontraf, sequela	\N	24
25	Tanoodle	Merrill	43	IT	Laceration of brachial artery, unspecified side, sequela	\N	25
26	Yakitri	Kandi	1	DE	Displaced unsp fracture of left great toe, init for opn fx	\N	26
27	Shufflester	Mercury	48	US	Drown due to fall/jump fr crushed canoe or kayak, sequela	\N	27
28	Riffwire	Spratley Islands	35	DE	Displaced spiral fracture of shaft of left femur, sequela	\N	28
29	Skiba	Erfurt	36	DE	Frostbite with tissue necrosis of right hand, subs encntr	\N	29
30	Trilia	Shang-I	1	FR	Villonodular synovitis (pigmented), multiple sites	\N	30
31	Buzzshare	Eindhoven	44	US	Contusion of adrenal gland, sequela	\N	31
32	Skibox	Longyearbyen	33	FR	Displ Maisonneuve's fx unsp leg, 7thQ	\N	32
33	Dynabox	Lawrenceville	10	IT	Superficial foreign body of unspecified wrist, subs encntr	\N	33
34	Oozz	\N	23	US	Toxic effect of organic solvents, self-harm, init	\N	34
35	Podcat	Ajaccio/Napoléon Bonaparte	3	IT	Poisoning by unsp topical agent, undetermined, subs encntr	\N	35
36	Oyondu	Minamidaitō	23	ES	Nondisp fx of med phalanx of l lit fngr, 7thG	\N	36
37	Midel	\N	11	US	Fasciculation	\N	37
38	Fatz	Bambari	45	US	Lacerat musc/tend at lower leg level, left leg, sequela	\N	38
39	Jaxnation	Três Corações	1	US	Displ oblique fx shaft of unsp fibula, 7thD	\N	39
40	Cogibox	Borama	43	IT	Disp fx of body of right talus, init for opn fx	\N	40
41	Skinte	York Landing	33	US	Unsp fx low end unsp ulna, 7thF	\N	41
42	Gigashots	Kaoma	48	AT	Pathological fracture in neoplastic disease, left hand	\N	42
43	Wikido	Vatukoula	24	FR	Unsp inj flexor musc/fasc/tend r mid fngr at forarm lv, init	\N	43
44	Digitube	Lancang Lahu Autonomous County	19	US	Poisoning by local anesthetics, undetermined, init encntr	\N	44
45	Brainsphere	Prince George	31	FI	Adverse effect of chloramphenicol group, subs encntr	\N	45
46	Zoomcast	Grosetto	5	DE	Other complications of anesthesia	\N	46
47	Fivebridge	Horta	27	US	Abrasion of right upper arm, subsequent encounter	\N	47
48	Brainverse	Lomé	17	US	Cutaneous abscess of trunk, unspecified	\N	48
49	Twinder	\N	18	FR	Pseudocoxalgia	\N	49
50	Cogidoo	Rolla/Vichy	6	AT	Other specified disorders of ear	\N	50
51	Jamia	Donegal	38	IT	Degeneration of pupillary margin, bilateral	\N	51
52	Edgetag	Vienna	18	DE	Path fx in neopltc dis, l humerus, subs for fx w routn heal	\N	52
53	Meezzy	Puerto Plata	39	DE	Injury of tibial nrv at lower leg level, right leg, sequela	\N	53
54	Meevee	Canberra	6	US	Circadian rhythm sleep disorder in conditions classd elswhr	\N	54
55	Kamba	Longana	5	US	Poisn by oth antieplptc and sed-hypntc drugs, asslt, sequela	\N	55
56	Zoomcast	Santo Domingo	14	DE	Type 2 diab with diab mclr edema, resolved fol trtmt, r eye	\N	56
57	Jetpulse	Puerto Obaldia	37	US	Incomplete spontaneous abortion without complication	\N	57
58	Trilith	Hobbs	11	US	Burn of first deg mult sites of right wrs/hnd, sequela	\N	58
59	Browsezoom	Garça	48	US	Post-traumatic osteoarthritis, unspecified hand	\N	59
60	Quamba	Olyokminsk	44	BE	Laceration of superior mesenteric vein	\N	60
61	Buzzbean	Montpellier/Méditerranée	31	US	War operations involving rubber bullets, civilian, init	\N	61
62	Skiba	Diego Garcia	28	IE	Unsp physl fx low end humer, l arm, subs for fx w routn heal	\N	62
63	Devpulse	Salmon Arm	14	IT	Nondisp fx of base of 2nd MC bone, r hand, init for opn fx	\N	63
64	Devify	Newcastle	18	US	Pnctr of abd wall w/o fb, periumb rgn w/o penet perit cav	\N	64
65	Gabtype	Porterville	38	DE	Unspecified injury of blood vessel of right index finger	\N	65
66	Eare	Sette Cama	12	DE	Disp fx of shaft of 5th MC bone, r hand, 7thD	\N	66
67	Yambee	Burnie	27	US	Other contact with nonvenomous snake, initial encounter	\N	67
68	Kazu	Menorca Island	32	US	Localized hypertrichosis	\N	68
69	Meezzy	Tahsis	7	DE	Legal intervnt involving injury by mch gun, bystand injured	\N	69
70	Cogibox	Des Moines	26	US	Chronic postrheumatic arthropathy [Jaccoud], left hand	\N	70
71	Skipstorm	Eureka	26	US	Presence of other specified functional implants	\N	71
72	Oyonder	Prishtina	39	US	Disp fx of med epicondyl of l humer, subs for fx w nonunion	\N	72
73	Pixoboo	Neumünster	45	PL	Collapsed vertebra, NEC, lumbosacral region, sqla	\N	73
74	Wordpedia	Astrakhan	30	US	Lac w/o fb of abd wall, r upper q w penet perit cav, subs	\N	74
75	Devshare	Rome	38	US	Mtrcy passenger injured in clsn w hv veh nontraf, sequela	\N	75
76	Jabbersphere	Maracaibo	48	US	Injury of median nerve at wrist and hand level of right arm	\N	76
77	Thoughtstorm	Bathurst	43	AT	Insect bite (nonvenomous) of unspecified ear, subs encntr	\N	77
78	Trilia	San Jose	20	US	Toxic effect of chewing tobacco	\N	78
79	Yotz	\N	25	US	Pre-existing essential hypertension complicating pregnancy,	\N	79
80	Avamm	Baguio City	32	US	Unspecified fracture of upper end of right humerus	\N	80
81	Lazz	Ambriz	3	US	Poisn by crbnc-anhydr inhibtr,benzo/oth diuretc, undet, sqla	\N	81
82	Flipopia	Médouneu, Gabon	3	SE	Other specified cataract	\N	82
83	Agivu	Lawrenceville	38	US	Syphilitic cerebral arteritis	\N	83
84	Skinder	Bloomington	41	US	Inj oth blood vessels at ank/ft level, left leg, sequela	\N	84
85	Zooveo	Great Bend	38	US	Burn of first degree of palm	\N	85
86	Bluezoom	Morowali	29	AT	Displ commnt fx shaft of unsp fibula, 7thN	\N	86
87	Meeveo	Xiangfan	35	BE	Corros 2nd deg mul left fingers (nail), including thumb	\N	87
88	Thoughtworks	Nunukan-Nunukan Island	18	DE	Displ osteochon fx r patella, 7thN	\N	88
89	Realbridge	El Fasher	4	US	Struck by other bat, racquet or club, sequela	\N	89
90	Wikizz	Eliptamin	45	US	Abrasion of left forearm, initial encounter	\N	90
91	Skalith	\N	44	NL	Acute suppr otitis media w/o spon rupt ear drum, unsp ear	\N	91
92	Voonte	Mount Pleasant	13	US	Other dislocation of left patella, sequela	\N	92
93	Oodoo	La Baule-Escoublac	40	US	Mesothelioma	\N	93
94	Skinix	Oulu / Oulunsalo	50	US	Injury of ulnar nerve at forearm level, unsp arm, sequela	\N	94
95	Ntags	Ceiba	30	IT	Subluxation of L4/L5 lumbar vertebra	\N	95
96	Teklist	Glendive	4	US	Occup of pk-up/van injured in clsn w pedl cyc in traf, subs	\N	96
97	Kanoodle	Long Datih	10	FR	Disp fx of body of scapula, left shoulder, sequela	\N	97
98	Dynabox	Kasaba Bay	5	IT	Intermittent monocular exotropia, right eye	\N	98
99	Linktype	Quetta	39	DE	Milt op w dest arcrft due to enmy fire/expls, civilian, subs	\N	99
100	Eazzy	Fada N'gourma	17	IE	Other doubling of uterus	\N	100
101	Shuffledrive	Latur	13	AT	Stress fracture, right ulna, sequela	\N	101
102	Nlounge	Jamnagar	49	US	Sprain of deltoid ligament of left ankle	\N	102
103	Skipfire	Leirvik	41	US	Unsp pre-existing htn comp pregnancy, unsp trimester	\N	103
104	Myworks	Los Chiles	17	NL	Oth osteoporosis w current pathological fracture, unsp hand	\N	104
105	Centizu	Enniskillen	11	US	Oth fracture of shaft of l humerus, subs for fx w malunion	\N	105
106	Abatz	Amery	6	US	Unsp inj blood vessels at hip and thi lev, left leg, init	\N	106
107	Eazzy	St Petersburg	35	US	Laceration w/o foreign body of left upper arm, subs encntr	\N	107
108	Linkbuzz	Columbia	13	DE	Mantle cell lymphoma, nodes of ing region and lower limb	\N	108
109	Fadeo	Diu	25	IE	Laceration of deep palmar arch of right hand, init encntr	\N	109
110	Podcat	Hateruma	25	IT	Person outsd bus inj pk-up truck, pk-up/van nontraf, sequela	\N	110
111	Skinder	Tashkent	23	FR	Brown-Sequard syndrome at T7-T10, subs	\N	111
112	Youspan	Moscow	25	US	Subluxation of unsp interphalangeal joint of finger, init	\N	112
113	Twitterbeat	Santiago	21	DE	Encounter for attention to tracheostomy	\N	113
114	Yambee	Balivanich	49	IT	Poisoning by salicylates, accidental, sequela	\N	114
115	Geba	\N	7	CY	Suprvsn of preg w history of infertility, unsp trimester	\N	115
116	Flipbug	\N	21	US	Occlusion and stenosis of basilar artery	\N	116
117	Skinder	McKinley Park	30	US	Inferior dislocation of unspecified acromioclavicular joint	\N	117
118	Eimbee	Heglig Oilfield	40	US	Abscess of mediastinum	\N	118
119	Trunyx	Madrid	24	US	Oth disp fx of second cervcal vert, subs for fx w delay heal	\N	119
120	Demimbu	Anatom Island	26	FR	Chronic kidney disease, stage 1	\N	120
121	Lazzy	Siwea	40	AT	Spasmodic torticollis	\N	121
122	Feedfire	Tambohorano	35	IT	Crushing injury of unspecified hip with thigh, subs encntr	\N	122
123	Thoughtmix	St Pierre	1	DE	Lacerat blood vessels at lower leg level, right leg, init	\N	123
124	Eare	Surgut	34	US	Osteitis deformans of ankle and foot	\N	124
125	Yata	Wanuma	45	US	Nondisp fx of olecran pro w/o intartic extn unsp ulna, 7thB	\N	125
126	Youfeed	Mulia-Papua Island	37	US	Insect bite (nonvenomous), left lower leg, sequela	\N	126
127	Kanoodle	Belgrade	27	IT	Nondisp fx of shaft of right clavicle, init for clos fx	\N	127
128	Edgeify	Imperial	21	US	External constriction of left eyelid and periocular area	\N	128
129	JumpXS	Carbondale/Murphysboro	46	US	Enophthalmos due to atrophy of orbital tissue, unsp eye	\N	129
130	Trilith	Scottsdale	31	US	Adverse effect of drug/meds/biol subst, init	\N	130
131	Kare	Mariupol	16	IE	Other fractures of lower leg	\N	131
132	Devpoint	Marfa	4	US	Fracture of lateral end of clavicle	\N	132
133	Gabcube	Parkersburg	37	DE	Assault by handgun discharge	\N	133
134	Jamia	Kerama	13	IT	Lateral dislocation of left patella, subsequent encounter	\N	134
135	Lazzy	\N	50	FR	Nondisplaced bimalleolar fracture of right lower leg	\N	135
136	Viva	Skardu	44	DE	Burn of 3rd deg mu sites of lower limb, except ank/ft	\N	136
137	Livetube	Rome	1	US	Nondisp seg fx shaft of ulna, unsp arm, 7thB	\N	137
138	Jayo	Salalah	22	US	Laceration w fb of l rng fngr w damage to nail, sequela	\N	138
139	Skyndu	Lubango	21	US	Nondisp transverse fx shaft of humer, l arm, 7thP	\N	139
140	Rhycero	Kalutara	7	DE	Balantidiasis	\N	140
141	Rhynoodle	\N	2	US	Sltr-haris Type II physeal fx lower end of unsp fibula	\N	141
142	Blogpad	Vyrburg	26	IT	External constriction of unsp back wall of thorax, subs	\N	142
143	Flipopia	Banda-Naira Island	26	US	Dislocation of unsp interphaln joint of l idx fngr, subs	\N	143
144	Tazz	Greenville	23	US	Burn of 3rd deg mu sites of left ankle and foot	\N	144
145	Meeveo	Puerto Plata	33	BE	Tuberculous meningoencephalitis	\N	145
146	Edgewire	Hobbs	48	US	Puncture wound without foreign body of penis, subs encntr	\N	146
147	Blognation	Nikolayev	13	IT	Underdosing of agents primarily affecting GI sys	\N	147
148	Skalith	Aomori	12	IT	Hypertrophy of bone, hand	\N	148
149	Vidoo	Mumbai	26	US	Oth postproc comp and disorders of the ear/mastd, NEC	\N	149
150	Gabtune	Contadora Island	48	AT	Athscl heart disease of native cor art w unstable ang pctrs	\N	150
151	Meembee	Puerto López	44	IT	Other shellfish poisoning, accidental (unintentional)	\N	151
152	Browsedrive	San Rafael	17	FR	Stress fracture, unspecified shoulder, sequela	\N	152
153	Trunyx	Buchanan	31	IE	Contact with blunt object, undetermined intent, sequela	\N	153
154	Topicblab	Marília	50	DE	Laceration with foreign body of unspecified wrist, sequela	\N	154
155	Brightdog	Yanji	47	US	Oth injuries of right shoulder and upper arm, init encntr	\N	155
156	Quire	Melfi	8	US	Laceration of radial artery at wrs/hnd lv of left arm, init	\N	156
157	Midel	\N	5	DE	Burn of third degree of left axilla	\N	157
158	Rhyzio	Bowling Green	13	US	Displ midcervical fx l femur, subs for clos fx w nonunion	\N	158
159	Browsedrive	Kuopio / Siilinjärvi	21	AT	Hydrocele, unspecified	\N	159
160	Blogtags	Bigatyelang Island	15	FR	Stress fracture, right radius, sequela	\N	160
161	Latz	River Cess	29	DE	Toxic effect of venom of Australian snake, accidental, init	\N	161
162	Twitterworks	Newport	27	AT	Bent bone of r ulna, 7thF	\N	162
163	Camido	Île d'Yeu	16	DE	Oth comp of fb acc left in body fol remov cath/pack, subs	\N	163
164	Brightdog	Charlotte	28	US	Malignant neoplasm of overlapping sites of oth prt mouth	\N	164
165	Topdrive	Amman	9	DE	Moderate laceration of unsp part of pancreas, subs encntr	\N	165
166	Jaxnation	\N	26	US	Explosn of mine placed during war op but expld after, milt	\N	166
167	Photolist	Leaf Rapids	39	US	Blister (nonthermal) of other part of head, init encntr	\N	167
168	Mynte	Vahitahi	4	US	Unsp inj unsp blood vess at ank/ft level, right leg, subs	\N	168
169	Rhyzio	La Grande-4	25	US	Injury of right uterine vein, subsequent encounter	\N	169
170	Katz	Jilin	36	NL	Osteitis condensans, left lower leg	\N	170
171	Tanoodle	Sármellék	19	AT	Subluxation of unsp parts of left shoulder girdle, init	\N	171
172	Latz	Ono-i-Lau	31	US	Oligohydramnios, second trimester, fetus 2	\N	172
173	Trilia	Sármellék	33	US	Aneurysmal bone cyst, left forearm	\N	173
174	Brightdog	Gotalalamo-Morotai Island	36	US	Other conjunctivitis	\N	174
175	Jatri	Kiman-Papua Island	6	US	Fracture of shaft of first metacarpal bone	\N	175
176	Jayo	Gujrat	25	SE	Nondisp transverse fx shaft of r tibia, 7thH	\N	176
177	Realpoint	Lakeba Island	19	US	Person outside hv veh injured in clsn w hv veh in traf, init	\N	177
178	Izio	\N	40	AT	Obs & eval of NB for suspected GU condition ruled out	\N	178
179	Skiba	Nunam Iqua	46	IT	Functional disorders of polymorphonuclear neutrophils	\N	179
180	Zoovu	Hancock	44	DE	Toxic effect of strychnine and its salts, self-harm	\N	180
181	Dynazzy	Fort Scott	22	NL	Oth nondisp fx of fifth cervcal vert, subs for fx w nonunion	\N	181
182	Ntag	Mouila	23	US	Open bite of unspecified upper arm, sequela	\N	182
183	Realblab	Saint Louis	41	AT	Sltr-haris Type II physeal fx unspecified metatarsal, 7thK	\N	183
184	Wikido	Fort Riley(Junction City)	24	US	Oth injury of popliteal artery, unspecified leg, init encntr	\N	184
185	Fivespan	Uyo	22	PT	Inj flexor musc/fasc/tend l rng fngr at forearm level, init	\N	185
186	Kwinu	Nelspruit	49	US	Acute and subacute allergic otitis media (mucoid) (serous)	\N	186
187	Oyoba	Salida	20	DE	Dislocation of acromioclav jt, 100%-200% displacement	\N	187
188	Skipstorm	Beagle Bay	41	BE	Laceration of axillary or brachial vein, left side, init	\N	188
189	Abata	\N	29	US	Oth fx upr end r ulna, 7thF	\N	189
190	Twimm	Orocue	37	IT	Assault by steam or hot vapors, initial encounter	\N	190
191	Oyope	\N	49	FR	Follicular lymphoma grade IIIb, spleen	\N	191
192	Youspan	Djougou	34	IT	Pasngr in 3-whl mv inj in clsn w 2/3-whl mv nontraf, init	\N	192
193	Blognation	\N	7	DE	Periprosth fx around internal prosth l shoulder jt, subs	\N	193
194	Dabshots	Stuart	18	FR	Sltr-haris Type II physeal fx lower end of l tibia, sequela	\N	194
195	Wikizz	Londolozi	2	US	Irritant contact dermatitis due to plants, except food	\N	195
196	Skyble	Fremont	34	DE	Anterior subluxation of unsp sternoclavicular joint, sequela	\N	196
197	Chatterbridge	Kelila-Papua Island	47	DE	Terorsm w explosn of marine weapons, civilian injured, init	\N	197
198	Zoonoodle	San Luis Potosí	26	AT	Unsp superficial injury of unspecified part of neck, sequela	\N	198
199	Aivee	Evansville	43	US	Unequal limb length (acquired), left fibula	\N	199
200	Realfire	East Stroudsburg	10	US	Burn of unspecified degree of right ear	\N	200
201	Skippad	Kwigillingok	9	US	Acquired hemophilia	\N	201
202	Latz	Boca de Sábalo	16	IT	Unsp injury of musc/fasc/tend at forarm lv, unsp arm, init	\N	202
203	Bubblemix	Washington	45	FR	Chagas' disease with nervous system involvement, unspecified	\N	203
204	Ailane	Curitiba	29	DE	Displ unsp fx right lesser toe(s), subs for fx w nonunion	\N	204
205	Dabjam	Reus	45	IT	Underdosing of unsp systemic anti-infect/parasit, init	\N	205
206	Zoozzy	Kiunga	42	US	Disp fx of body of left talus, subs for fx w delay heal	\N	206
207	Yombu	Bulolo	13	IE	Vesicoureteral-reflux, unspecified	\N	207
208	Trilith	Thompson	13	US	Unspecified open wound of left wrist, initial encounter	\N	208
209	Gabtype	Igloolik	46	US	Nondisp fx of triquetrum bone, r wrs, 7thG	\N	209
210	Babbleblab	Naiu Atoll	33	BE	Gout due to renal impairment, unspecified elbow	\N	210
211	Oodoo	Pococi	9	FR	Oth osteopor w current path fracture, r shoulder, init	\N	211
212	Meembee	\N	24	DE	Oth rheumatoid arthritis w rheumatoid factor of right elbow	\N	212
213	Blogspan	\N	23	DE	Inj flexor musc/fasc/tend r rng fngr at forarm lv, sequela	\N	213
214	Youbridge	Tikchik	42	IT	Traum subrac hem w LOC of 1-5 hrs 59 min, sequela	\N	214
215	Jazzy	Kawthoung	26	US	Maternal care for anti-D antibodies, second tri, fetus 4	\N	215
216	Youtags	Gobernador Gregores	7	US	Injury of r int carotid, intcr w/o LOC, subs	\N	216
217	Brainlounge	Liboi	45	US	Asphyx due to being trapped in a (discarded) refrig, assault	\N	217
218	Vimbo	Bahía de Caraquez	10	DE	Assault by steam or hot vapors, sequela	\N	218
219	Oyoba	Sinop	12	US	Bilateral inguinal hernia, with gangrene	\N	219
220	Jamia	Taguatinga	13	US	Poisoning by aminoglycosides, assault, sequela	\N	220
221	Youtags	Enid	41	LT	Nondisp fx of proximal third of navicular bone of r wrist	\N	221
222	Leexo	Front Royal	2	US	Oth incomplete lesion at C2, sequela	\N	222
223	Meevee	Groton (New London)	38	FR	Disp fx of unsp ulna styloid pro, 7thG	\N	223
224	Realfire	Almeirim	37	US	Other lack of coordination	\N	224
225	Edgeify	Lyon/Bron	19	NL	Malignant neoplasm complicating pregnancy, unsp trimester	\N	225
226	Tanoodle	Great Bend	1	AT	Amyloid pterygium of eye, bilateral	\N	226
227	BlogXS	Tres Esquinas	28	MT	Exposure of other implanted mesh into organ or tissue, subs	\N	227
228	Photobug	Soledade	11	US	Insect bite (nonvenomous), right ankle	\N	228
229	Midel	Ascensión de Guarayos	12	DE	Dislocation of MCP joint of right thumb, init	\N	229
230	Divape	Freetown	11	DE	Unsp intracap fx right femur, init for opn fx type I/2	\N	230
231	Thoughtstorm	\N	32	DE	Displ midcervical fx unsp femur, subs for clos fx w nonunion	\N	231
232	Voonix	Turbo	48	US	Posterior subluxation of unspecified humerus, sequela	\N	232
233	Yabox	Staverton	8	AT	Laceration w/o foreign body, right lower leg, init encntr	\N	233
234	Voonix	Recife	9	US	Unspecified subluxation of left radial head	\N	234
235	Tagfeed	\N	18	DE	Complete lesion at C2 level of cervical spinal cord, subs	\N	235
236	Dynabox	Guriaso	28	DE	Disp fx of med condyle of l femr, 7thN	\N	236
237	Yakijo	Moroak	42	US	Giant cell arteritis with polymyalgia rheumatica	\N	237
238	Edgeblab	Buenos Aires	30	US	Struck by raccoon	\N	238
239	Jaxworks	Paruma	35	DK	Forced landing of balloon injuring occupant, init encntr	\N	239
240	Aimbo	Tabou	48	US	Inj intrinsic musc/fasc/tend l little finger at wrs/hnd lv	\N	240
241	Katz	Xingning	16	US	Contusion of unspecified hip, sequela	\N	241
242	Shuffletag	Hudson	21	IT	Cocaine use, unsp w cocaine-induced psychotic disorder, unsp	\N	242
243	Eimbee	Niuatoputapu	22	DE	Animl-ridr or occ of anml-drn vehicle inj in clsn w stcar	\N	243
244	Voolia	Veranópolis	27	DK	Unsp mtrcy rider inj in clsn w rail trn/veh in traf, sequela	\N	244
245	Voomm	Moengo	42	US	Sequelae of Guillain-Barre syndrome	\N	245
246	Quaxo	\N	8	FR	Transient synovitis, right hand	\N	246
247	Trilith	Goma	5	US	Unsp superficial injury of right ring finger, subs encntr	\N	247
248	Kwideo	Tarbela	12	DE	Parachutist injured on landing, initial encounter	\N	248
249	Ooba	Kaunas	13	US	Displaced transcondy fx l humerus, subs for fx w nonunion	\N	249
250	Edgeify	Ivishak River	43	DE	Unsp fx upr end unsp rad, 7thH	\N	250
\.


--
-- TOC entry 5468 (class 0 OID 41168)
-- Dependencies: 267
-- Data for Name: SERVICIOS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."SERVICIOS" (id_servicio, nombre_servicio, dias_servicio, horario, precio, id_sucursal) FROM stdin;
1	Babbleopia	39	2019	35	1
2	Aimbu	80	2016	20	2
3	Teklist	38	2012	4	3
4	Geba	47	2004	50	4
5	Fivespan	85	2016	4	5
6	Linktype	51	2005	7	6
7	Divanoodle	53	2014	5	7
8	Meedoo	60	2015	4	8
9	Dabshots	76	2011	10	9
10	Tazz	29	2011	4	10
11	Edgeify	56	2009	13	11
12	Talane	47	2017	13	12
13	Topiclounge	61	2015	80	13
14	Dynabox	42	2011	2	14
15	Mita	88	2004	3	15
16	Babbleopia	17	2015	50	16
17	Realcube	28	2008	15	17
18	Twinte	46	2018	100	18
19	Wikivu	50	2005	23	19
20	Mynte	75	2019	7	20
21	Feedmix	66	2015	90	21
22	Muxo	56	2009	20	22
23	Brainbox	67	2000	2	23
24	Yodo	78	2017	90	24
25	Skippad	61	2003	250	25
26	Brainverse	52	2004	40	26
27	Browsebug	68	2013	50	27
28	Tagtune	75	2013	15	28
29	Fanoodle	13	2015	20	29
30	Devpoint	83	2011	35	30
31	Buzzster	77	2013	50	31
32	Linklinks	36	2013	2	32
33	Flipopia	19	2020	20	33
34	Gabcube	40	2014	5	34
35	Twitternation	11	2009	40	35
36	Teklist	47	2010	2	36
37	Zoomlounge	68	2012	15	37
38	Jetwire	29	2019	15	38
39	Wikibox	34	2011	4	39
40	Twimm	37	2014	50	40
41	Feedmix	17	2000	5	41
42	Yadel	35	2011	40	42
43	Yombu	56	2020	35	43
44	Kare	19	2008	2	44
45	Skimia	35	2010	30	45
46	Twitternation	12	2014	70	46
47	Voomm	83	2002	3	47
48	Dynava	67	2019	20	48
49	Shuffledrive	78	2011	50	49
50	Twitterlist	65	2012	160	50
51	Jaxbean	12	2014	4	51
52	Edgetag	44	2014	7	52
53	Divavu	57	2009	35	53
54	Feedfire	28	2012	4	54
55	Oodoo	61	2010	4	55
56	Kaymbo	90	0	3	56
57	Photofeed	42	2015	3	57
58	Voomm	87	2021	8	58
59	Vidoo	26	2015	30	59
60	Nlounge	88	2012	30	60
61	Twitternation	67	2012	5	61
62	Omba	12	2017	100	62
63	Skinder	55	2006	30	63
64	Eadel	75	2007	3	64
65	Divanoodle	87	2010	50	65
66	Quatz	66	2012	40	66
67	Feedfire	17	2011	9	67
68	Plajo	30	2020	140	68
69	Youopia	39	1999	30	69
70	Browsecat	82	2008	19	70
71	Skibox	29	2006	6	71
72	Skimia	22	2018	40	72
73	Buzzster	69	2016	5	73
74	Devify	20	2004	4	74
75	Divavu	44	2008	5	75
76	Pixope	35	0	35	76
77	Shufflester	85	2017	45	77
78	Vitz	88	2018	20	78
79	Einti	76	2012	6	79
80	Riffpath	19	2008	35	80
81	Thoughtblab	85	2008	30	81
82	Innojam	82	2004	7	82
83	Layo	52	2005	20	83
84	Skipfire	67	2012	25	84
85	Linkbridge	84	2020	16	85
86	Photofeed	43	2012	3	86
87	Wikizz	64	2013	3	87
88	Photobug	83	2020	130	88
89	Talane	51	2011	3	89
90	Yakijo	21	2020	2	90
91	Gabspot	49	2003	35	91
92	Jamia	73	2003	9	92
93	Meemm	52	2017	2	93
94	Centimia	42	2016	4	94
95	Tazz	74	2004	5	95
96	Miboo	75	2014	35	96
97	Buzzbean	42	2016	20	97
98	Shufflebeat	30	2005	3	98
99	Tambee	35	2010	6	99
100	Eare	45	2013	23	100
101	Buzzster	29	2010	30	101
102	Quamba	24	2020	40	102
103	Geba	16	2012	2	103
104	Zoomcast	81	2019	4	104
105	Mita	78	0	35	105
106	Youbridge	88	2011	2	106
107	Jaloo	17	0	50	107
108	Voonder	78	2009	100	108
109	Zazio	42	2019	20	109
110	Yamia	75	2012	15	110
111	Brainsphere	11	2014	4	111
112	Skipstorm	78	2013	40	112
113	Brightbean	65	2016	80	113
114	Livetube	58	2012	5	114
115	Layo	81	2003	3	115
116	Devify	56	2016	25	116
117	Livetube	89	2007	25	117
118	Zoozzy	69	2010	3	118
119	Pixonyx	67	2001	7	119
120	Jayo	78	2016	30	120
121	Cogidoo	38	2014	25	121
122	Kimia	13	2011	3	122
123	Buzzbean	65	2017	5	123
124	Twinder	10	2010	5	124
125	Jayo	48	2017	35	125
126	Kwimbee	42	2012	5	126
127	Twitterworks	42	2007	40	127
128	Fivespan	69	2006	4	128
129	Plambee	67	2007	4	129
130	Edgeclub	47	2018	25	130
131	Omba	53	2015	4	131
132	Yambee	41	2014	110	132
133	Tazzy	30	2015	20	133
134	Divavu	47	2013	50	134
135	Quamba	47	2020	20	135
136	Riffpedia	43	2014	4	136
137	Centimia	26	2007	3	137
138	Devbug	56	2019	20	138
139	Gabvine	88	2015	2	139
140	Gigazoom	81	2006	20	140
141	JumpXS	21	2006	3	141
142	Kwinu	22	2019	100	142
143	Topdrive	64	2020	45	143
144	Leenti	10	2009	30	144
145	Tazz	74	2007	40	145
146	Dynazzy	40	2004	5	146
147	Twiyo	24	2018	3	147
148	Kazu	40	2004	3	148
149	Jayo	71	2016	3	149
150	Linktype	90	2010	50	150
151	Shufflester	83	2008	30	151
152	Fivespan	42	2012	13	152
153	Realmix	32	2016	25	153
154	Voomm	48	2018	23	154
155	Skidoo	21	2012	3	155
156	Ainyx	46	2012	4	156
157	Fiveclub	12	2007	4	157
158	Agivu	72	2015	7	158
159	Topdrive	57	2007	3	159
160	Geba	40	2018	2	160
161	Roomm	73	2020	35	161
162	Omba	32	2006	15	162
163	Jaxnation	33	2013	5	163
164	Zoomdog	34	2010	2	164
165	Thoughtsphere	47	2008	170	165
166	Meeveo	59	2019	40	166
167	Skiba	52	2004	3	167
168	Jaxnation	23	2010	6	168
169	Edgeblab	65	2013	30	169
170	Livepath	66	2005	13	170
171	Eazzy	53	2018	40	171
172	Twimbo	87	2011	3	172
173	Eabox	58	2010	3	173
174	Edgeblab	31	2020	2	174
175	Centizu	39	2010	4	175
176	Mydo	87	2010	3	176
177	Jabberbean	50	2011	13	177
178	Eazzy	71	2017	150	178
179	Eamia	83	2017	6	179
180	Skibox	54	2013	3	180
181	Skibox	69	2015	35	181
182	Divavu	40	2018	2	182
183	Devcast	15	0	3	183
184	Dynabox	79	2003	26	184
185	Yadel	51	2012	3	185
186	Minyx	29	2010	1	186
187	Yakidoo	61	2013	40	187
188	Skibox	33	2017	5	188
189	Oodoo	42	2010	23	189
190	Rhycero	90	2017	2	190
191	Innojam	39	2009	50	191
192	Trupe	20	2012	100	192
193	Katz	44	2017	8	193
194	Innojam	44	2011	13	194
195	Babbleset	59	2012	13	195
196	Oodoo	26	2014	3	196
197	Yodel	82	2012	50	197
198	Riffpath	40	2009	20	198
199	Oyoba	37	2016	200	199
200	Livepath	11	2015	50	200
201	Kazio	66	2018	3	201
202	Gabvine	50	2014	40	202
203	Roombo	79	2011	4	203
204	Tazz	30	2020	7	204
205	Feedbug	89	2009	90	205
206	Abatz	85	2007	15	206
207	Leexo	78	2005	20	207
208	Feedfire	18	2015	5	208
209	Tagpad	72	2016	3	209
210	Skyvu	66	2016	80	210
211	Gigashots	10	2012	20	211
212	Jabbersphere	23	2014	40	212
213	Meetz	43	2009	2	213
214	Pixope	47	2010	45	214
215	Feedspan	32	2019	150	215
216	Zoonder	16	2013	3	216
217	Brainlounge	26	2001	7	217
218	Zazio	15	2020	40	218
219	Dabvine	87	2013	10	219
220	Oba	41	2014	100	220
221	Mita	27	2007	5	221
222	Meevee	18	2012	13	222
223	Edgewire	29	2006	13	223
224	Einti	51	2006	30	224
225	Tazz	80	2005	50	225
226	Gigabox	18	2003	4	226
227	Bluezoom	47	2014	35	227
228	Voomm	12	2001	200	228
229	Flashspan	53	2004	15	229
230	Topiclounge	88	2012	30	230
231	Bubblemix	81	2011	5	231
232	Einti	49	2009	6	232
233	Skinder	38	2018	4	233
234	Mynte	89	1999	5	234
235	Bluejam	83	2018	50	235
236	Rhycero	22	2000	40	236
237	Ainyx	73	2010	40	237
238	Buzzster	81	2014	16	238
239	Yozio	84	2015	8	239
240	Pixope	68	2004	80	240
241	Tagchat	35	2009	200	241
242	Realpoint	25	2013	90	242
243	Browsetype	53	2017	3	243
244	Thoughtbeat	15	2004	6	244
245	Dabjam	20	2019	2	245
246	Youopia	88	2007	4	246
247	Bubblemix	73	2014	110	247
248	Oyonder	38	2010	60	248
249	Eimbee	43	2007	20	249
250	LiveZ	63	0	90	250
\.


--
-- TOC entry 5469 (class 0 OID 41171)
-- Dependencies: 268
-- Data for Name: SERVICIO_HABITACION; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."SERVICIO_HABITACION" (id_servicio_habitacion, costo, telefono, hora_apertura, hora_cierre) FROM stdin;
1	17.00	2115539757	3	4
2	30.00	4945061211	4	5
3	2.00	9746310097	3	3
4	28.00	8961736543	4	3
5	13.00	9551157602	3	4
6	13.00	3602105540	4	3
7	27.00	5786968730	3	3
8	25.00	5503773364	3	1.5
9	28.00	1687874928	3	23
10	12.00	7881174245	3	3
11	26.00	2988299788	3	3
12	6.00	9717955942	3	1.5
13	1.00	4921154073	4	1.5
14	15.00	5329300371	4	1.5
15	30.00	3272114758	3	12
16	5.00	3824262601	3	3
17	20.00	7841715055	1.5	2.5
18	25.00	5861466472	3	3
19	17.00	6773888384	1.5	1.5
20	24.00	4899481233	3	3
21	12.00	3984533154	4	4
22	30.00	9434029573	4	4
23	11.00	7841421313	3	13
24	3.00	5128533701	1.5	11
25	29.00	4064139702	3	3
26	6.00	7575114014	3	1.5
27	23.00	9427611219	3	3
28	14.00	5619350013	3	3
29	22.00	6017228202	1.5	3
30	7.00	6111812006	3	4
31	18.00	8728406534	3	22
32	27.00	2146420213	1.5	17
33	11.00	2784649146	4	3
34	22.00	3532993217	3	1.5
35	21.00	9624268774	3	3
36	14.00	9902554661	5	3
37	20.00	2977255905	3	3
38	21.00	4226977592	3	1.5
39	26.00	5539718161	18	12
40	2.00	3251364356	3	3
41	4.00	8544900924	3	12
42	12.00	9704871648	10	1.5
43	9.00	1885409346	1.5	3
44	12.00	7257923704	3	3
45	13.00	5023928981	1.5	5.5
46	7.00	3936452357	3	4
47	18.00	4444130491	3	1.5
48	24.00	5448295725	1.5	16
49	12.00	7462462097	4	12
50	20.00	2594228711	3	1.5
51	30.00	8049602220	1.5	1.5
52	19.00	6589738381	3	3
53	3.00	1516768511	3	3
54	21.00	6622528128	12	3
55	24.00	7716821769	3	13
56	12.00	3838888121	4	3
57	15.00	6278149943	1.5	12
58	16.00	9767917885	3	3
59	25.00	4359529747	23	3
60	19.00	9046082952	3	3
61	2.00	4312766095	4	5.5
62	17.00	3184531758	11	1.5
63	9.00	1056306683	3	4.5
64	8.00	6469858511	1.5	4
65	12.00	7973020713	3	4
66	23.00	6639100584	1.5	3
67	21.00	4529112193	1.5	3
68	25.00	7778797292	1.5	3
69	30.00	9729905104	3	3
70	21.00	2917523289	3	3
71	20.00	5823994650	4	20
72	20.00	8787708393	4	5
73	26.00	4574588978	12	1.5
74	15.00	8043762168	3	1.5
75	20.00	4615134394	3	1.5
76	15.00	9337605849	1.5	3
77	28.00	5085267087	5	3
78	24.00	9069025647	6	3
79	20.00	3567092237	3	10
80	20.00	3206996168	1.5	3
81	1.00	9616239347	14	1.5
82	15.00	8877643592	3	3
83	28.00	9255584415	3	1.5
84	15.00	5874718090	3	3
85	8.00	4174625511	3	1.5
86	30.00	6645001634	3	1.5
87	6.00	6253801183	13	3
88	4.00	4255046435	3	4
89	3.00	9196448768	3	3
90	13.00	6678564623	3	3
91	14.00	6033489407	3	3
92	6.00	1904351741	4	4
93	20.00	7676802019	1.5	3
94	29.00	9315688720	3	1.5
95	13.00	8889755753	1.5	1.5
96	27.00	8597049035	12	3
97	15.00	9377651005	3	3
98	13.00	2763697737	14	4
99	8.00	2926642139	3	5
100	29.00	8874028495	4	17
101	11.00	8275664109	1.5	3
102	27.00	7464511201	3	3
103	22.00	2509400733	4	18
104	8.00	4027811103	3	5
105	19.00	1536681311	11	22
106	6.00	1306535188	3	3
107	6.00	2818007772	3	3
108	28.00	1209290738	3	14
109	23.00	9748463427	1.5	3
110	14.00	2996385193	1.5	3
111	23.00	1344896933	3	3
112	4.00	4881911431	1.5	3
113	25.00	5401220061	3	4
114	6.00	8462058451	3	3
115	18.00	1351723055	1.5	1.5
116	6.00	1631241356	4	5
117	12.00	9239118634	14	3
118	29.00	9426512391	4	4
119	5.00	7951307829	1.5	13
120	18.00	1956061786	3	9.5
121	7.00	4607682739	1.5	3
122	14.00	1959936828	11	3
123	5.00	5742160796	4.5	3
124	13.00	3292454589	1.5	3
125	8.00	5242194478	3	3
126	28.00	3902586390	9.5	3
127	24.00	8098749481	3	1.5
128	20.00	8648053153	3	3
129	24.00	8469247317	12	1.5
130	30.00	5152826826	5	15
131	26.00	6436638453	3	3
132	26.00	1383093281	3	3
133	9.00	8505225198	4	1.5
134	13.00	3216012608	1.5	3
135	29.00	9562802669	3	3
136	21.00	8156184822	3	4
137	14.00	2628048037	4	3
138	20.00	8309118113	12	3
139	12.00	5363718375	12	1.5
140	1.00	6645679102	1.5	3
141	28.00	2173109544	3	4
142	4.00	3229030842	1.5	4
143	23.00	4088849766	4	3
144	3.00	3046902130	3	3
145	8.00	6981226726	3	3
146	2.00	7909675029	16	3
147	12.00	3958355845	4	4
148	5.00	4789569895	12	12
149	16.00	6833519171	3	3
150	29.00	6862457528	14	1.5
151	5.00	6089542788	12	3
152	23.00	5779911404	3	1.5
153	8.00	5791231367	4	3
154	10.00	8392956767	1.5	3
155	3.00	6079284181	1.5	3
156	25.00	3193141426	12	3
157	25.00	5285447525	3	3
158	21.00	8941714239	3	3
159	17.00	5095927952	3	3
160	25.00	4146412019	3	5
161	5.00	1785022272	4	3
162	13.00	5164650503	1.5	4.5
163	26.00	9657496985	3	1.5
164	30.00	7419661097	1.5	1.5
165	13.00	9281912270	3	4
166	29.00	7441931356	6	3
167	10.00	4059544600	3	3
168	25.00	7923037534	3	4
169	10.00	4666247199	4	4
170	22.00	5668228184	1.5	1.5
171	25.00	9351562320	3	4
172	13.00	4862433447	3	3
173	24.00	9488592585	3	3
174	27.00	4959407863	3	3
175	6.00	9538315803	4	3
176	29.00	1463722847	3	3
177	20.00	9055607090	1.5	3
178	6.00	6947216122	3	3
179	4.00	5312533202	1.5	3
180	3.00	2321772787	11	3
181	20.00	8376711654	4	5
182	28.00	6177137436	3	3
183	3.00	9767324225	1.5	1.5
184	20.00	3792477825	3	4
185	14.00	7953370533	3	1.5
186	30.00	7389639730	4	3
187	24.00	1341525580	3	3
188	26.00	4808375343	3	12
189	16.00	3851892593	3	4
190	2.00	4267405642	12	1.5
191	30.00	4009141024	4	1.5
192	17.00	8647740144	3	13
193	22.00	6769387282	3	4
194	12.00	4816558001	1.5	3
195	24.00	8479373177	3	3
196	15.00	4207658876	3	3
197	17.00	4143667418	1.5	1.5
198	25.00	2968712536	3	3
199	28.00	4385390021	3	3
200	7.00	1519398790	3	1.5
201	14.00	1569280900	12	3
202	21.00	5183657047	3	3
203	6.00	8881258477	3	1.5
204	18.00	8696300478	1.5	4
205	22.00	6024257799	3	15.5
206	25.00	9299901050	3	4
207	28.00	4407729755	1.5	12
208	2.00	1428504864	1.5	20
209	25.00	6283159670	2.5	3
210	21.00	6052781776	3	3
211	22.00	7597715690	3	1.5
212	3.00	3883959448	1.5	3
213	20.00	7549800734	1.5	1.5
214	27.00	3062904440	1.5	1.5
215	4.00	9313234172	3	5
216	9.00	2714800832	5	3
217	7.00	5145849017	17	3
218	24.00	7111231363	3	3
219	17.00	4284762932	3	3
220	15.00	2325656205	3	3
221	13.00	8421644054	3	1.5
222	10.00	9751812866	12	1.5
223	22.00	5434460624	4	4.5
224	30.00	4367522757	4	12
225	20.00	9354526402	17	5
226	29.00	6301240836	3	3
227	7.00	2137475002	1.5	3
228	21.00	6967553905	3	3
229	10.00	7586412294	3	1.5
230	10.00	7193429888	3	3
231	15.00	4123839508	3	4
232	20.00	5334135168	12	3
233	29.00	5592667273	14	3
234	14.00	4683347500	5	3
235	5.00	5784350037	10	3
236	1.00	3083944625	3	3
237	14.00	9128217404	4	4
238	27.00	9035496382	3	4
239	22.00	2637430162	4	11
240	4.00	7484596947	3	1.5
241	5.00	9672807446	3	3
242	8.00	5708345021	15	4
243	8.00	3398850541	5	3
244	6.00	8551886380	3	20
245	23.00	7337176844	3	4
246	15.00	2967014749	3	3
247	8.00	7802954975	1.5	3
248	17.00	1477733505	1.5	3
249	30.00	2292563097	3	1.5
250	18.00	2816916230	1.5	1.5
\.


--
-- TOC entry 5470 (class 0 OID 41176)
-- Dependencies: 269
-- Data for Name: SUCURSALES; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."SUCURSALES" (id_sucursal, nombre_sucursal, colonia, codigo_postal, calle, numero_interior, numero_exterior, telefono1, telefono2, correo_electronico_contacto, id_ciudad, id_estado, numero_habitaciones, capacidad_huespedes, id_hotel) FROM stdin;
1	Gsakbox	Krypton	2591 	Alley	12	421	512513661126	125512161126	\N	1	1	51	5	1
2	Skyble	Anniversary	2010 	Junction	992	26	4698849002	3708340149	\N	2	2	54	7	2
3	Jabbertype	Ryan	2010 	Alley	2940	59	7193002136	4386009799	\N	3	3	71	8	3
4	Eabox	Kropf	1986 	Circle	7	93074	2084863233	2533496741	\N	4	4	54	10	4
5	Shufflebeat	Union	2012 	Way	72680	37	2914990386	8652865064	\N	5	5	78	9	5
6	Livetube	Clyde Gallagher	2008 	Avenue	60821	6022	4922439257	8361774186	\N	6	6	77	10	6
7	Skilith	Union	2000 	Road	271	33105	5381960411	1464901003	\N	7	7	82	5	7
8	Jaxworks	Arizona	1994 	Center	857	02	3634674362	7557872047	\N	8	8	83	10	8
9	Wordtune	Manitowish	1987 	Parkway	95	3298	4147576562	9649523616	\N	9	9	100	5	9
10	Topiclounge	Loomis	2007 	Trail	06535	6095	5902942333	3017015459	\N	10	10	100	4	10
11	Yacero	Hanover	1997 	Circle	8	3	3051080169	9194318104	\N	11	11	41	5	11
12	Myworks	Stuart	2006 	Way	4	6150	6574090628	3113788976	\N	12	12	86	9	12
13	Realbuzz	Sunfield	2003 	Terrace	84	74816	3361947592	7286726816	\N	13	13	61	5	13
14	Oyonder	Commercial	2009 	Parkway	824	00171	2373109927	8205086955	\N	14	14	58	4	14
15	Zoomlounge	Pawling	2010 	Junction	2181	2	3429553590	7237985675	\N	15	15	98	7	15
16	Avamm	Carpenter	2003 	Avenue	825	65	7033111260	1869359094	\N	16	16	81	4	16
17	Yodo	Barby	1992 	Plaza	42315	3336	1556864034	5812360232	\N	17	17	45	6	17
18	Vidoo	Division	1992 	Avenue	89	9	4055875496	8119907300	\N	18	18	79	4	18
19	Babbleset	Talisman	1997 	Point	4395	3639	1456916196	3903392799	\N	19	19	70	6	19
20	Flashspan	Cottonwood	2000 	Plaza	86	5	7779138773	9031417723	\N	20	20	63	5	20
21	Wikibox	Waxwing	2004 	Street	93006	64	2096597609	8134331968	\N	21	21	67	10	21
22	Dabvine	Mayfield	2012 	Lane	4498	2	7314054229	3119751428	\N	22	22	71	9	22
23	Meejo	Warbler	1993 	Terrace	200	4773	3321395391	7951660271	\N	23	23	76	6	23
24	Realpoint	Sycamore	1967 	Parkway	6876	9994	3845952357	7223306107	\N	24	24	100	10	24
25	Realbuzz	Caliangt	1993 	Point	84718	19	5334755161	5857154064	\N	25	25	70	9	25
26	Skiba	Hoepker	2008 	Way	746	5	5282086600	1899912564	\N	26	26	97	6	26
27	Trilia	Talisman	2002 	Crossing	698	0	3153955751	2787485500	\N	27	27	51	6	27
28	Photofeed	Oakridge	1984 	Alley	872	7	7322613501	2971329260	\N	28	28	86	9	28
29	Livepath	5th	2012 	Lane	15731	4868	1381996837	7368767970	\N	29	29	93	6	29
30	Skyvu	Burning Wood	2012 	Park	6611	7	7161140703	5188196807	\N	30	30	78	7	30
31	Devify	Mendota	1999 	Pass	93	4	3582664034	8454210756	\N	31	31	59	9	31
32	Flashspan	Lakewood Gardens	1993 	Way	25659	6	7911119806	3386626453	\N	32	32	70	9	32
33	Mycat	Alpine	2001 	Center	90969	87	4604223709	6421550428	\N	33	33	80	4	33
34	Kayveo	Kedzie	2003 	Circle	2651	5	8378515907	6969237803	\N	34	34	73	10	34
35	Kare	Truax	2009 	Road	6251	0122	4418353495	1544566592	\N	35	35	64	10	35
36	Latz	Magdeline	2001 	Road	5	42331	9472565335	5535656079	\N	36	36	74	6	36
37	Twitterbeat	Service	1994 	Lane	2964	05011	9349130592	1189767598	\N	37	37	91	8	37
38	Jatri	Mifflin	2007 	Court	85	30553	8586034932	4684712016	\N	38	38	41	5	38
39	Mudo	Brentwood	1978 	Terrace	4	67	3755749185	1165615082	\N	39	39	49	10	39
40	Meevee	Southridge	2012 	Point	2266	6585	2132476277	9612002371	\N	40	40	33	9	40
41	Tagtune	Morningstar	1986 	Circle	00392	10327	1427043140	4224652198	\N	41	41	49	9	41
42	Oyondu	Logan	1986 	Street	8	27	8164276207	4985852565	\N	42	42	65	8	42
43	Vidoo	Independence	1985 	Street	4	856	5355845331	9023303380	\N	43	43	100	9	43
44	Topicshots	Rutledge	2003 	Pass	8837	768	9755506277	7454504393	\N	44	44	98	4	44
45	Skimia	Homewood	2005 	Circle	4	655	2784681893	4778528836	\N	45	45	75	6	45
46	Thoughtstorm	Warbler	2001 	Avenue	8	52	1191238691	2363517650	\N	46	46	92	10	46
47	Yabox	Lakewood Gardens	2000 	Plaza	841	81693	8991350185	3814340770	\N	47	47	82	8	47
48	Eayo	1st	1988 	Avenue	77	19726	3033700488	3903515712	\N	48	48	38	9	48
49	Gabtune	Norway Maple	1997 	Park	8941	63	7522017108	2643813000	\N	49	49	39	4	49
50	Teklist	Stoughton	1995 	Terrace	6	008	2974380787	9175706743	\N	50	50	89	9	50
51	Twitterworks	Mesta	1999 	Hill	67866	94	9757165740	1586182362	\N	51	51	35	5	51
52	Jetwire	Truax	2008 	Park	28	37	2021318367	2093638452	\N	52	52	89	6	52
53	Aibox	Ridgeway	2004 	Point	629	538	1071202183	2271183439	\N	53	53	85	9	53
54	Kazu	Nova	2001 	Plaza	71079	1	6908949696	4917779383	\N	54	54	93	5	54
55	Jaxbean	Menomonie	1990 	Drive	752	6	9447787325	9128755399	\N	55	55	42	10	55
56	Kimia	Hanover	2008 	Road	98	28	6813702740	7028485209	\N	56	56	87	8	56
57	Gabvine	Pennsylvania	2000 	Alley	4	61322	5079027969	7443301495	\N	57	57	90	4	57
58	Livetube	Mayer	1993 	Avenue	9	2	8338525263	6572605352	\N	58	58	40	5	58
59	Photojam	Gerald	1999 	Crossing	1	752	4255427190	2073577593	\N	59	59	41	5	59
60	Buzzdog	Crowley	2012 	Crossing	40256	05829	7603502178	7089022983	\N	60	60	44	6	60
61	Skinder	Warbler	2008 	Street	55611	97	2395924750	6106954835	\N	61	61	86	7	61
62	Jatri	Mayfield	2003 	Place	752	585	1096228443	7552384866	\N	62	62	83	9	62
63	Zoombeat	Holy Cross	1998 	Center	764	6	7055896909	8825358479	\N	63	63	78	10	63
64	Skyba	Mallard	2009 	Circle	503	736	3888958498	2386706502	\N	64	64	77	6	64
65	Realfire	Shasta	2008 	Center	2	17	7465092570	5813151858	\N	65	65	78	7	65
66	Skilith	Briar Crest	2012 	Avenue	47526	89	7437483311	7334090911	\N	66	66	43	10	66
67	Realfire	Meadow Vale	2002 	Court	26171	52136	5748025961	4817194057	\N	67	67	94	7	67
68	Twimm	Corscot	2004 	Hill	43435	4	7137299986	1659346534	\N	68	68	80	7	68
69	Agimba	Ridgeway	2006 	Lane	07518	356	9904910600	7796434315	\N	69	69	99	9	69
70	Shufflester	Blaine	2008 	Hill	0043	58831	3108182908	6844126071	\N	70	70	48	5	70
71	Twitternation	Sunbrook	1994 	Center	62628	12	3722610680	2272990766	\N	71	71	69	7	71
72	Kwideo	Moulton	2004 	Terrace	02520	34480	3399894436	4344970393	\N	72	72	30	10	72
73	Bubblemix	Talmadge	2012 	Pass	5618	616	1337845373	1665293196	\N	73	73	66	10	73
74	Brainlounge	Armistice	1995 	Avenue	2308	7399	2201328813	8726229421	\N	74	74	84	4	74
75	Fivebridge	Scott	1998 	Hill	7	6357	1765750594	9167767525	\N	75	75	75	10	75
76	Eire	Pierstorff	2011 	Court	24470	21653	1969709798	7715877464	\N	76	76	57	7	76
77	Skipfire	Rowland	2012 	Alley	02	521	8587054940	2286778590	\N	77	77	86	8	77
78	Trilith	Superior	2000 	Way	8	3213	5927104748	5509919313	\N	78	78	61	9	78
79	Aimbo	Golf Course	2004 	Way	3	34	6927274780	6911257034	\N	79	79	75	5	79
80	Zoovu	Laurel	2006 	Avenue	7	3952	7924822189	1823846083	\N	80	80	58	10	80
81	Leexo	Carey	1992 	Circle	30729	4250	2764106661	5662225271	\N	81	81	79	8	81
82	Twiyo	Messerschmidt	2011 	Crossing	07468	40367	5303458550	1776613943	\N	82	82	33	4	82
83	Oba	New Castle	2011 	Circle	65845	652	9321854945	2144283346	\N	83	83	39	8	83
84	Topicshots	Corry	2008 	Way	4	3384	3558055364	8148949351	\N	84	84	38	5	84
85	Kwilith	Texas	2010 	Court	25163	3291	5342332388	6412969385	\N	85	85	60	4	85
86	Skinix	Golf	1997 	Parkway	09558	2	9569536567	9882501002	\N	86	86	48	8	86
87	Jayo	Southridge	2012 	Road	6978	9	1986856067	2044738059	\N	87	87	61	9	87
88	Jaxworks	Namekagon	1992 	Drive	228	85	1829303276	4686875592	\N	88	88	40	7	88
89	Skipfire	Mccormick	2001 	Place	8183	1	4479918039	8295464396	\N	89	89	34	5	89
90	Eare	Hollow Ridge	1993 	Way	4	6036	9307216002	8258029835	\N	90	90	74	7	90
91	JumpXS	Mallory	2008 	Center	30714	8667	8806473475	1918092766	\N	91	91	39	8	91
92	Gabvine	Washington	1995 	Place	40	3926	6033193220	1131689571	\N	92	92	93	4	92
93	Minyx	Ramsey	2007 	Trail	7	1966	7275537558	9597757355	\N	93	93	94	6	93
94	Youtags	Stang	2006 	Pass	18386	418	6402574403	3609026164	\N	94	94	89	4	94
95	Riffwire	Fairview	1998 	Park	9	4335	8856533444	2323925074	\N	95	95	44	8	95
96	Fliptune	Saint Paul	2007 	Street	8134	1	3025866139	5671516573	\N	96	96	67	9	96
97	Flashset	Novick	1994 	Pass	60	79047	8278373347	4355041989	\N	97	97	34	4	97
98	Tagpad	Michigan	2004 	Point	59	69	9909529004	2539930205	\N	98	98	58	4	98
99	Avamm	Reindahl	1999 	Park	40682	877	3355431421	1656824422	\N	99	99	89	9	99
100	Kwimbee	Morning	2002 	Crossing	21310	03	1771700884	6486607394	\N	100	100	84	6	100
101	Mita	Jackson	2012 	Pass	4892	23874	2792515717	6424235355	\N	101	101	38	9	101
102	Realbuzz	Crownhardt	2000 	Park	7	9	4126132249	6318513779	\N	102	102	67	6	102
103	DabZ	Lighthouse Bay	2006 	Parkway	1969	075	4594214002	8157244507	\N	103	103	73	8	103
104	Innojam	Westerfield	2003 	Place	269	28245	9481655371	4017857133	\N	104	104	88	10	104
105	Trudeo	Sloan	2006 	Trail	9061	5366	6467119148	2736054526	\N	105	105	39	5	105
106	Quatz	Surrey	2010 	Parkway	3310	68	3227211288	8595279457	\N	106	106	51	4	106
107	Zooxo	Esker	1953 	Crossing	318	68	7069645985	4811073416	\N	107	107	94	10	107
108	Flashspan	Calypso	2013 	Plaza	74	1	9633141099	6427944376	\N	108	108	84	4	108
109	Tekfly	Bellgrove	2003 	Park	0	5036	1529264529	1399812369	\N	109	109	93	6	109
110	Fadeo	Superior	2002 	Road	50248	55	8297055268	8177647320	\N	110	110	64	9	110
111	Shufflebeat	Birchwood	2007 	Center	7	136	6751682240	9363756543	\N	111	111	76	5	111
112	Voonix	Merry	1970 	Point	63026	11049	4355462223	7652357470	\N	112	112	92	8	112
113	Rhybox	Delladonna	1991 	Road	938	6	6434814981	4253451414	\N	113	113	72	7	113
114	Skyble	Caliangt	2011 	Circle	5	02640	3054201210	4293307868	\N	114	114	43	9	114
115	Podcat	Washington	1997 	Court	5	262	5238666248	2811421001	\N	115	115	80	5	115
116	Jazzy	Mcguire	2011 	Alley	30	19	1752633649	9494226063	\N	116	116	85	6	116
117	Feedfire	Di Loreto	1987 	Junction	832	6	4556283562	1426579605	\N	117	117	48	7	117
118	Zoomdog	Algoma	1992 	Trail	982	6328	9096339434	5242508334	\N	118	118	50	8	118
119	Browsebug	Sycamore	2001 	Center	88024	59	3593367886	9077969259	\N	119	119	71	5	119
120	Skivee	Graceland	2011 	Park	70	6445	6524140653	7124247661	\N	120	120	32	5	120
121	Avamba	Logan	1993 	Road	77	7	6059285451	8165459704	\N	121	121	55	10	121
122	Oloo	Clyde Gallagher	2008 	Center	4151	1095	5907917135	5148575431	\N	122	122	51	10	122
123	Pixope	American Ash	2010 	Park	485	29	4923784037	6524734824	\N	123	123	61	7	123
124	Jabbersphere	Acker	1989 	Point	3	32	4239043762	3743033409	\N	124	124	81	6	124
125	Yakijo	Loeprich	2005 	Drive	6346	7	3702061968	6295862876	\N	125	125	61	10	125
126	Livetube	Acker	2009 	Junction	6	6	5678969453	7573152671	\N	126	126	77	5	126
127	Jazzy	Fallview	2001 	Road	1670	0	1891205988	9437427682	\N	127	127	43	9	127
128	Katz	Chive	2007 	Parkway	9	81	8908844407	9513053163	\N	128	128	77	10	128
129	Shuffletag	Marcy	2009 	Way	72	36848	8253211739	9661393480	\N	129	129	59	7	129
130	Yakitri	Quincy	2008 	Center	85	384	5857185633	3141840287	\N	130	130	70	4	130
131	Youspan	Springview	2008 	Avenue	31	12	7149177444	2447096991	\N	131	131	47	8	131
132	Demizz	Hoard	2005 	Pass	3430	64	4344025836	9539952561	\N	132	132	52	7	132
133	Kazio	Elmside	2005 	Park	0290	8	5502852391	8772888261	\N	133	133	74	6	133
134	Janyx	Northland	2009 	Crossing	274	9273	7854496389	4413266158	\N	134	134	67	9	134
135	Brainbox	Dryden	2005 	Hill	5	8325	6418844434	9039704949	\N	135	135	80	10	135
136	Riffwire	Express	1993 	Crossing	76665	58	3892232673	6193592563	\N	136	136	63	10	136
137	Vimbo	Chinook	1992 	Place	56	60	5108584857	3021317359	\N	137	137	64	9	137
138	Digitube	Duke	1993 	Lane	47517	23100	5173136710	3766953498	\N	138	138	45	7	138
139	Jaxbean	Independence	1985 	Circle	1821	4	9466197108	8621819241	\N	139	139	70	5	139
140	Jabbersphere	Sunnyside	2008 	Street	6353	9	3998098780	6851043974	\N	140	140	49	8	140
141	Mydeo	Tennyson	1989 	Avenue	1878	339	5571239798	4678182183	\N	141	141	97	7	141
142	Buzzster	Service	1989 	Crossing	55522	2910	1674360396	8745212340	\N	142	142	77	4	142
143	Aibox	Maple	2009 	Hill	5311	9505	5444646823	1173032390	\N	143	143	54	4	143
144	Vidoo	Londonderry	1988 	Way	36343	138	8331701759	8991830251	\N	144	144	78	5	144
145	Voonte	Killdeer	2002 	Point	941	27	9539465532	9523114804	\N	145	145	95	7	145
146	Jayo	Debs	2007 	Center	51580	23	1077983846	8895393276	\N	146	146	94	6	146
147	Mynte	Corry	2007 	Way	2	86	1655071000	9471478840	\N	147	147	66	7	147
148	Pixoboo	Colorado	2007 	Avenue	17	69485	1244620585	8461953077	\N	148	148	33	5	148
149	Blogtag	Ryan	1997 	Circle	379	60894	1996989952	7848340175	\N	149	149	31	8	149
150	Thoughtbeat	Arapahoe	1999 	Point	76	6687	8545230926	5942838016	\N	150	150	41	9	150
151	Rhybox	Bonner	1992 	Alley	69827	432	5456062996	3416458603	\N	151	151	75	9	151
152	Meembee	Bluestem	1999 	Court	29	4615	3733179517	6485780951	\N	152	152	49	10	152
153	Browsecat	Hintze	2008 	Circle	09738	10	7715990022	8165110331	\N	153	153	96	4	153
154	Rooxo	Petterle	1993 	Park	33943	21481	6945814034	2145833951	\N	154	154	51	7	154
155	Mybuzz	Cascade	1989 	Terrace	81	667	8144255775	8252541871	\N	155	155	87	4	155
156	Ailane	Texas	2003 	Way	9	350	8109676090	6417820381	\N	156	156	47	9	156
157	Skidoo	Sutherland	1997 	Parkway	59	890	7805897566	1695669787	\N	157	157	32	6	157
158	Yambee	Erie	2002 	Junction	61	86	8578364833	2124028313	\N	158	158	51	8	158
159	Tazzy	Tennessee	2005 	Pass	755	2183	4458984256	8015473007	\N	159	159	31	6	159
160	Yozio	Namekagon	2005 	Center	779	6769	3077363829	2239636387	\N	160	160	66	4	160
161	Avavee	Ryan	2001 	Road	9	6022	1156162221	2497701877	\N	161	161	81	4	161
162	Yacero	Old Gate	2005 	Hill	85664	638	1592873034	3333582151	\N	162	162	95	4	162
163	Eamia	Sunbrook	1986 	Street	6313	96	1419992972	6118123650	\N	163	163	87	4	163
164	Oyonder	Maple Wood	2004 	Street	3372	38157	6414439016	2025269290	\N	164	164	92	7	164
165	Jabberbean	Nancy	1990 	Park	36	145	5287209688	2417896919	\N	165	165	33	8	165
166	Photospace	Northport	2009 	Lane	0	35120	1878109051	8527404272	\N	166	166	87	4	166
167	Yoveo	Chive	2009 	Terrace	177	199	1695053140	1066745670	\N	167	167	78	9	167
168	Linkbuzz	Sunfield	2005 	Point	1408	803	7777068645	5348292055	\N	168	168	70	9	168
169	Rhyloo	Hovde	1988 	Place	09	8	9538179306	6925960812	\N	169	169	33	7	169
170	Yotz	Red Cloud	2012 	Way	6	725	2345430678	5617695245	\N	170	170	100	6	170
171	Kimia	Grasskamp	2010 	Road	91650	167	2763014802	6428845313	\N	171	171	35	10	171
172	Ooba	Buhler	1994 	Drive	0626	8488	9839712767	1306938688	\N	172	172	77	6	172
173	Zooveo	Lillian	1994 	Hill	457	480	7914633527	1719808962	\N	173	173	87	9	173
174	Zoomlounge	Oakridge	1996 	Avenue	0809	60097	5555154486	1474570936	\N	174	174	64	9	174
175	Bubblebox	Northport	2004 	Center	14	7734	6324975274	1598363802	\N	175	175	38	10	175
176	Photobug	Corscot	2011 	Terrace	7	5602	6064924013	4395362806	\N	176	176	33	10	176
177	Fliptune	Green Ridge	2012 	Drive	759	32	8974073031	8087599743	\N	177	177	61	8	177
178	Fanoodle	Morrow	1999 	Parkway	4402	10470	1767919611	1543691922	\N	178	178	34	4	178
179	Voomm	Monica	2006 	Parkway	8	19235	7161920307	7041220288	\N	179	179	64	7	179
180	Tagpad	Jenifer	2009 	Alley	6	28	9846524323	4056427168	\N	180	180	49	4	180
181	Skajo	International	2009 	Plaza	3	34	4157351277	5294947281	\N	181	181	91	8	181
182	Realbridge	Burrows	2003 	Park	47248	9979	7714229509	9751292431	\N	182	182	64	9	182
183	Tekfly	American	2010 	Place	21	53	5456192109	3535841919	\N	183	183	56	6	183
184	Topiclounge	Mcguire	2004 	Drive	4	0	9983907436	2767523919	\N	184	184	43	5	184
185	Jabbercube	Northwestern	1994 	Lane	4078	7626	1586547544	8236532025	\N	185	185	62	10	185
186	Zava	Elka	2000 	Drive	232	008	3121671761	8329841158	\N	186	186	52	6	186
187	Rhycero	Bellgrove	1967 	Road	81430	53284	5702108429	9431299423	\N	187	187	30	5	187
188	Topicblab	Golf	2006 	Lane	4	30	5691690843	2571763096	\N	188	188	79	10	188
189	Talane	Northwestern	1999 	Drive	1	3	9913494927	3548386507	\N	189	189	75	4	189
190	Rhybox	Mesta	2007 	Place	0709	9288	9127780754	8686201999	\N	190	190	37	8	190
191	Blogtags	Gateway	2006 	Lane	46966	05	7071460941	5042967573	\N	191	191	95	4	191
192	Thoughtbridge	Susan	2012 	Circle	2	44063	3139890194	2414219709	\N	192	192	38	10	192
193	Zava	Loeprich	2005 	Street	6602	80450	8478744982	6923179035	\N	193	193	30	9	193
194	Eazzy	Londonderry	2003 	Trail	883	604	3944400587	9077604368	\N	194	194	70	5	194
195	Jaxworks	Susan	1996 	Hill	3429	2254	2024653662	5086140942	\N	195	195	75	8	195
196	Lajo	Prentice	2011 	Pass	480	7445	5335055609	7169548718	\N	196	196	80	8	196
197	Brainlounge	Morrow	1986 	Pass	7634	52	1059120481	5066980679	\N	197	197	47	10	197
198	Zoombox	Brickson Park	1987 	Court	155	84	6803694660	5495887115	\N	198	198	97	7	198
199	Mita	Harper	1986 	Trail	6578	4192	3708148401	9445137857	\N	199	199	86	6	199
200	Realfire	Fairfield	1998 	Hill	0	562	3865779231	7815974758	\N	200	200	82	5	200
201	Dynabox	Golf Course	1992 	Parkway	44	3	5615634030	7881590605	\N	201	201	41	10	201
202	Npath	Lillian	1999 	Crossing	748	60588	9407344317	1471432954	\N	202	202	47	8	202
203	Camimbo	2nd	2006 	Way	1447	72837	4532700025	6408562656	\N	203	203	42	7	203
204	Photolist	Milwaukee	2003 	Pass	118	8512	9431679499	9721753441	\N	204	204	80	9	204
205	Thoughtstorm	Springview	2000 	Place	877	25103	6581812273	4211900587	\N	205	205	51	5	205
206	Kazio	Vermont	1993 	Alley	71	5149	4277401624	8333461279	\N	206	206	100	4	206
207	Tambee	Merrick	2002 	Alley	332	190	7163843875	2556750706	\N	207	207	76	4	207
208	Feedfire	Fremont	2008 	Court	095	7424	2911220749	9765837368	\N	208	208	67	7	208
209	Kanoodle	Kim	1996 	Park	7	84117	1179886969	5734382316	\N	209	209	52	10	209
210	Yodo	Fair Oaks	2003 	Pass	3	12	8022667882	2706820787	\N	210	210	67	9	210
211	Fliptune	Kenwood	2001 	Drive	08	8	5033439004	1697582334	\N	211	211	70	4	211
212	Myworks	Farmco	1994 	Alley	5	66104	1234023910	3634426884	\N	212	212	45	4	212
213	Ntag	John Wall	1961 	Junction	7	65088	9875496353	8747242320	\N	213	213	37	8	213
214	Blogtag	Chive	2007 	Road	8	5979	9882966680	7195453307	\N	214	214	38	6	214
215	Browsezoom	Annamark	1998 	Parkway	3896	7040	4231578455	8593926962	\N	215	215	44	6	215
216	Fiveclub	Bluejay	1991 	Park	6	6	3447813322	1842911475	\N	216	216	47	7	216
217	Bubbletube	Dixon	2010 	Pass	91	664	6194883521	4995279003	\N	217	217	59	4	217
218	Babbleopia	Holmberg	2006 	Avenue	8	4	5741525218	4523999006	\N	218	218	51	8	218
219	Topicshots	Jackson	1992 	Lane	5	6135	8231680752	3718619518	\N	219	219	40	4	219
220	Buzzster	Spohn	2005 	Place	741	53	6843366496	5835748098	\N	220	220	75	4	220
221	Gabvine	Kings	2008 	Pass	82	5041	5888101138	4027007062	\N	221	221	32	9	221
222	Yacero	Chinook	1995 	Plaza	75192	1	1431652794	4233135994	\N	222	222	39	7	222
223	Wikizz	Portage	1986 	Point	393	543	3164793340	7955734394	\N	223	223	46	8	223
224	Blogtag	Lukken	1998 	Junction	2	930	8412479063	4712594424	\N	224	224	67	5	224
225	Tagchat	Spaight	1994 	Park	72	5	5241689915	2236094635	\N	225	225	36	4	225
226	Centidel	3rd	1999 	Hill	36	927	7003891958	1264500992	\N	226	226	100	6	226
227	Quamba	Arrowood	1994 	Place	917	9514	6247759437	8154467466	\N	227	227	78	8	227
228	Flashdog	Burrows	2012 	Street	6	29617	1677867261	1621856016	\N	228	228	63	5	228
229	Youspan	Banding	1985 	Parkway	328	41868	3817393912	6481626081	\N	229	229	40	5	229
230	Cogibox	Namekagon	2010 	Drive	1143	60033	4941851822	6195348806	\N	230	230	41	7	230
231	Trilia	Artisan	1996 	Park	5725	54	5034749345	5606395231	\N	231	231	38	6	231
232	Kaymbo	Hovde	2003 	Center	4280	07541	1047758582	8631414331	\N	232	232	88	4	232
233	Yabox	Bowman	1999 	Parkway	70	7	4276099107	4994383233	\N	233	233	68	4	233
234	Bubblebox	Jana	1996 	Junction	92	7	4682945445	3331838900	\N	234	234	61	5	234
235	Brainlounge	Northfield	2006 	Point	782	6	4265019014	4534736160	\N	235	235	42	4	235
236	Rhybox	Valley Edge	1990 	Drive	601	27	3403232093	4527249652	\N	236	236	85	5	236
237	Devpoint	Schurz	2008 	Pass	64	69	2755862835	3595809782	\N	237	237	99	7	237
238	Oyoba	Lakewood	2001 	Way	4409	6	3166224496	6178203653	\N	238	238	43	4	238
239	Gigabox	Park Meadow	1990 	Place	19118	8523	8033166512	4337209292	\N	239	239	60	4	239
240	Quimba	Corry	2007 	Hill	7	910	1693307023	5032983999	\N	240	240	92	4	240
241	Yabox	Monument	1998 	Terrace	21774	71633	8645636579	9668694149	\N	241	241	47	4	241
242	Tagtune	Sommers	2012 	Trail	9879	97710	6826228733	2975621754	\N	242	242	44	4	242
243	Eabox	Oakridge	2006 	Court	42319	30214	2825331473	9196361046	\N	243	243	72	6	243
244	Realbuzz	Mccormick	2012 	Circle	15121	5440	7291297933	6984570883	\N	244	244	90	8	244
245	Podcat	Service	2004 	Road	169	39	5626420878	7088250629	\N	245	245	55	7	245
246	Dabshots	Ohio	1991 	Drive	208	203	3125707538	6214335433	\N	246	246	49	8	246
247	Realfire	Tennyson	2006 	Way	91050	06	1237710399	2975740370	\N	247	247	88	4	247
248	Topicstorm	Texas	1998 	Crossing	2	06732	7115886277	6133273941	\N	248	248	46	8	248
249	Flashspan	Debs	2003 	Plaza	703	1485	2457882943	1949731734	\N	249	249	42	7	249
250	Youbridge	Melvin	2011 	Park	321	91012	2267831723	5353104901	\N	250	250	32	10	250
\.


--
-- TOC entry 5471 (class 0 OID 41181)
-- Dependencies: 270
-- Data for Name: TIPO_CAMAS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."TIPO_CAMAS" (id_tipo_cama, modelo_cama) FROM stdin;
1	Litera
2	Individual
3	Matrimonial
4	Queen zise
5	King zise
\.


--
-- TOC entry 5472 (class 0 OID 41184)
-- Dependencies: 271
-- Data for Name: TIPO_HABITACIONES; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."TIPO_HABITACIONES" (id_tipo_habitacion, nombre_tipo_habitacion, capacidad, precio, detalles, id_tipo_cama) FROM stdin;
1	Hsinchu City	16	8.99	Reusable gel ice pack for injuries and cooling.	2
2	Takume	20	3.29	Instant mix for delicious pumpkin spice lattes at home.	1
3	Babase Island	17	199.99	Sturdy mobile workbench with storage options.	2
4	Nakina	19	39.99	Compact blender for quick smoothies and shakes.	2
5	Skwentna	34	18.99	Durable baking sheet coated for easy food release.	4
6	Long Apung-Borneo Island	14	18.99	Manual blender for smoothies and mixing ingredients on the go.	3
7	Oriximiná	37	34.99	A sleek leather wallet that combines style and functionality.	5
8	Wausau	11	39.99	Eco-friendly power bank that charges via sunlight.	2
9	Kiman-Papua Island	19	3.29	A sweet and spicy sauce for dipping or cooking.	2
10	Kelowna	35	5.49	Versatile puff pastry for pies and pastries.	1
11	Porterville	15	59.99	Wheeled cooler for transporting drinks and snacks.	1
12	\N	21	49.99	A flowy maxi dress perfect for both casual and semi-formal occasions.	3
13	La Ceiba	14	22.99	Stylish stand to hold your recipes while cooking.	3
14	Keningau	14	6.49	Versatile organic coconut oil for cooking and baking.	1
15	Fajardo	31	39.99	Breathable polo shirt designed for both style and comfort on the greens.	2
16	Atkamba Mission	8	5.99	Gluten-free almond flour, perfect for baking.	5
17	Rotuma	6	2.49	Low-calorie rice cake for snacks.	3
18	Fredericton	17	2.99	High-quality whole wheat flour for baking and cooking.	1
19	Puerto Jimenez	22	39.00	Manual pasta maker for homemade pasta.	5
20	Coyoles	30	9.99	Tool for measuring perfect pasta portions every time.	3
21	Kontum	39	7.49	A nutritious salad with quinoa and black beans	1
22	Nonouti	28	3.49	Ready-to-bake garlic breadsticks, perfect with pasta dishes.	4
23	Guimarães	36	199.99	Compact ice maker for creating ice at home or in offices.	3
24	Madison	12	3.99	A refreshing drink mix that combines sweet raspberries and tart lemons, perfect for summer.	2
25	Topeka	29	22.99	Soft foam blocks perfect for building and imaginative play.	1
26	Puerto Putumayo	26	19.99	Set of five reusable fabric face masks.	2
27	Matamoros	28	9.99	Frozen salmon fillets marinated in teriyaki sauce, ready to grill or bake.	4
28	Satar Tacik-Flores Island	29	3.49	Tangy green salsa made with tomatillos, perfect for tacos.	1
29	Southend	23	24.99	Double-walled mug to keep your drink hot for longer.	4
30	Baidoa	40	1.29	Concentrated tomato paste, great for sauces.	4
31	Mashhad	39	2.49	Fine granulated sugar for all your baking needs.	2
32	Sugapa-Papua Island	26	12.99	Durable jump rope with built-in counter for workouts.	4
33	Morro Do Chapéu	29	49.99	Inflatable air mattress for convenient sleeping.	1
34	La Unión	27	22.99	Compact travel organizer for accessories and toiletries.	5
35	Remedios	18	4.99	Rich almond butter encased in dark chocolate.	4
36	Olanchito	35	4.99	A blend of dried fruits and nuts, great for snacking.	2
37	Guarapuava	5	3.99	Healthy fruit snacks, made with real fruit.	1
38	Lancaster	31	5.99	Bell peppers stuffed with rice and vegetables	4
39	Yangzhou and Taizhou	6	19.99	Fun light that creates a disco atmosphere for parties.	1
40	Paranaíba	14	24.99	Classic leather photo album for keepsakes.	1
41	Rongelap Island	19	4.29	Crispy sweet potato bites, delicious as a side or snack.	3
42	\N	22	29.99	Lightweight cover-up perfect for the beach, with a breezy design.	4
43	Cuxhaven	17	34.99	Spacious duffle bag for weekend getaways.	5
44	\N	25	39.99	Versatile canvas sneakers suitable for everyday wear with a comfortable fit.	4
45	Minneapolis	26	5.49	Savory and chewy beef jerky with teriyaki flavor.	3
46	Ibadan	24	1.99	Smooth Greek yogurt infused with vanilla bean flavor.	1
47	Puerto Berrio	18	18.99	Travel-friendly water bottle for pets on the go.	4
48	Nasik	9	24.99	Comfortable and adjustable harness for dogs.	2
49	Itapetinga	5	19.99	Fun and educational puzzle set for kids.	4
50	\N	29	24.99	Classic leather photo album for keepsakes.	3
51	Kupang-Timor Island	14	5.99	Savory, protein-rich beef jerky for on-the-go snacking.	2
52	Mudanjiang	23	69.99	Adjustable shelving unit for home or garage storage.	5
53	\N	29	29.99	Automatically cooks eggs to your desired level.	5
54	Kaluga	16	49.99	Anti-fog ski goggles for winter sports.	2
55	Gällivare	27	3.99	Sweet and juicy strawberries, perfect for desserts.	3
56	Grumeti Game Reserve	22	5.49	Couscous salad with cucumbers, tomatoes, feta, and olives, ready to eat.	4
57	Montauk	23	2.99	A blend of dried Italian herbs for cooking.	4
58	Corinth	27	2.49	Juicy peach slices in syrup, perfect for desserts.	3
59	La Grande	13	3.29	Crunchy pretzel nuggets filled with creamy peanut butter.	4
60	Sandane	22	19.99	Self-cleaning grooming brush for cats and dogs.	2
61	Magas	25	5.99	Eco-friendly bamboo toothbrush for sustainable living.	2
201	\N	14	29.99	Soft and cozy slippers for indoor wear.	3
62	Campeche	27	19.99	Bottle with infuser for brewing loose-leaf tea on the go.	5
63	Trondheim	14	4.99	A mix of frozen berries for smoothies or desserts	1
64	Rio De Janeiro	40	22.99	Compact travel organizer for accessories and toiletries.	5
65	\N	33	14.99	Compact USB fan for personal cooling.	5
66	Khovd	38	3.99	Sweet and salty popcorn with sea salt and caramel, a tasty treat.	1
67	Cabo Rojo	9	4.99	Crunchy granola with pumpkin spice flavor.	5
68	Espargos	33	24.99	Quote wall art to inspire and motivate.	5
69	Düsseldorf	24	3.49	A creamy and flavorful hummus made with roasted red peppers.	3
70	Atauro	31	4.99	Tangy feta cheese, perfect for salads and sandwiches.	5
71	Port Elizabeth	19	5.49	Fresh salad with pears, gorgonzola cheese, and nuts, perfect for lunch.	4
72	Yazd	19	3.49	Unsweetened coconut flakes for baking and snacking.	2
73	Uribe	40	39.99	Set of resistance bands for versatile strength training workouts.	3
74	Merritt	35	45.00	Abstract canvas print to enhance home decor.	4
75	Rondonópolis	10	29.99	Fun inflatable float for lounging in the pool or beach.	5
76	Glendale	28	4.99	Crunchy granola clusters, perfect for snacking or topping yogurt.	5
77	Jaffna	34	4.49	Roasted cashews coated in honey and sesame seeds for a sweet treat.	4
78	Lake Rudolf	7	19.99	Create spiraled vegetable noodles easily for healthy meals.	2
79	Ouagadougou	37	4.99	Savory pancakes made with chickpea flour, high in protein.	1
80	Montgomery	17	24.99	Comfortable and adjustable harness for dogs.	4
81	Elmira/Corning	7	9.99	Leak-proof bottles for travel-sized toiletries.	3
82	Front Royal	34	54.99	Timeless black trousers for a smart and sophisticated look.	4
83	\N	32	29.99	Quick boiling kettle for small kitchens and dorms.	5
84	Thicket Portage	22	19.99	Stylish watering can for plants with easy pouring nozzle.	5
85	Tarija	25	19.99	Eco-friendly silicone bags for food storage and snacks.	4
86	Hibbing	29	19.99	Heavy-duty chain lock for securing bicycles.	4
87	Springfield	28	3.49	Creamy Greek yogurt infused with raspberry and vanilla flavors.	2
88	Cluj-Napoca	34	1.99	Sweet and tangy raspberry lime beverage	2
89	Lukulu	7	1.99	Freshly ground cinnamon spice for baking or seasoning.	5
90	Wonju	17	12.99	Durable scoop for perfectly shaped ice cream servings.	5
91	Catarman	22	12.99	Easy-to-use tiebacks for curtains or drapes.	1
92	Gambell	34	2.89	Quick-cooking ramen noodles made with organic wheat.	2
93	Pereira	17	3.99	Crispy sweet potato fries, perfectly seasoned and baked to perfection.	5
94	Macanal	31	5.99	Healthy pizza crust made from cauliflower	4
95	Ahmed Al Jaber AB	12	8.99	Grilled chicken skewers glazed with teriyaki sauce.	1
96	Beauvais/Tillé	11	3.49	Nutty granola bars for healthy snacking.	3
97	Gasuke	18	29.99	Trendy leggings with a unique graphic print, versatile for workouts and casual wear.	3
98	Idre	18	12.99	A whole free-range chicken, ready for roasting.	3
99	Kawito	7	1.89	Rich coconut milk, great for cooking and baking.	2
100	Catumbela	15	3.99	Crunchy granola with almonds and coconut.	2
101	Cape Lisburne	10	5.29	Sweet blackberry compote, perfect for topping desserts.	1
102	Karonga	6	17.99	Beautiful wall calendar for organizing your schedule.	5
103	Shiyan	38	1.29	Versatile canned black beans, ready to add to any dish.	2
104	Jabor Jaluit Atoll	13	34.99	Rechargeable LED lantern ideal for camping and outdoor activities.	5
105	Glasgow	23	39.99	Foldable kneeler that doubles as a seat for gardening convenience.	1
106	Zakynthos Island	14	2.79	Spicy chili sauce with garlic and sugar for a flavor kick.	5
107	Gonaili	33	34.99	Professional-grade nail care set for manicures and pedicures.	3
108	\N	40	22.99	DIY kit to make your own lip balms in various flavors.	2
109	Owando	9	22.99	Wax warmer for creating a soothing atmosphere with fragrances.	1
110	Kangaatsiaq	38	29.99	Ergonomic monitor stand for improved workspace organization.	5
111	Bird Island	32	4.49	Roasted cashews coated in honey and sesame seeds for a sweet treat.	3
112	Cartwright	34	10.99	Flavorful chicken wings marinated in a sweet teriyaki glaze.	5
113	Faribault	24	5.99	All-in-one kit for making pasta salad easily.	4
114	San Juan Del César	29	19.99	Reusable mat that prevents food from sticking to the grill.	4
115	Algeciras	25	3.99	Hearty chili made with beans and vegetables, a savory meal option.	4
116	Puerto Rico	8	5.99	Creamy macaroni and cheese baked to perfection.	5
117	Silur Mission	34	5.29	No-bake energy bites made with peanut butter and oats.	1
118	Podor	38	5.99	Deliciously creamy spinach dip, perfect for parties.	5
119	\N	12	19.99	Heavy-duty rope suitable for boating, camping, and general use.	1
120	Miles City	6	59.99	Extra soft electric blanket with adjustable heat settings.	4
121	Limbang	19	19.99	Oversized gaming mousepad with smooth surface.	4
122	Mariupol	20	8.99	All ingredients included for delicious chicken fajitas.	4
123	Sinop	10	29.99	Stylish and functional backpack for school or trips.	1
124	Santa Teresita	25	3.99	Sweet and nutty filling for delicious homemade pecan pie.	4
125	Mariánské Lázně	8	12.99	Moisturizing body wash with natural ingredients.	4
126	Rochester	11	29.99	Heated stool cover for extra comfort during winter.	5
127	Picos	31	129.99	Durable tablet designed for kids with parental controls.	1
128	Rumbek	10	4.49	A wholesome granola with bits of apple and a touch of cinnamon.	3
129	Zamzama Gas Field	11	49.99	Cook rice and steam vegetables simultaneously for healthy meals.	4
130	Yancheng	5	109.99	1080p wireless security camera with night vision.	4
131	Blantyre	10	4.99	A mix of tropical fruits for a refreshing snack or dessert.	1
132	Livengood	6	15.99	Sustainable foam blocks for yoga practice.	5
133	Barcelona	25	29.99	Complete kit with crayons, markers, and paper for young artists.	5
134	Perugia	29	25.99	Ergonomic wireless mouse with adjustable DPI.	3
135	\N	36	2.39	Fragrant jasmine rice, perfect as a side dish.	4
136	Visby	40	4.99	Cold pasta salad tossed with pesto and fresh vegetables.	5
137	Morro Agudo	23	14.99	500-piece jigsaw puzzle featuring beautiful scenery.	5
138	Lansing	29	4.49	A nutrient-packed salad mix with kale, quinoa, and a lemon vinaigrette, ready to eat.	2
139	San Joaquín	6	9.99	Leak-proof bottles for travel-sized toiletries.	3
140	Paramaribo	16	3.29	Tender carrots glazed with a sweet maple sauce.	4
141	\N	26	49.99	Boosts your Wi-Fi coverage for better connectivity.	1
142	Ulusaba	21	17.99	Beautiful wall calendar for organizing your schedule.	3
143	\N	10	3.99	Sweet and juicy strawberries, perfect for desserts.	5
144	Churchill	32	64.99	Elegant classic pumps that add sophistication to any outfit.	2
145	Lemmon	15	59.99	Cordless electric screwdriver for home projects.	1
146	Mérida	19	6.99	Extra virgin olive oil infused with fresh basil.	5
147	Siwea	25	45.99	A retro-style button-down shirt with a relaxed fit.	2
148	Saint Louis	17	2.79	Perfect dipping sauce or stir-fry addition for a sweet and tangy flavor.	4
149	Hato Corozal	40	39.99	UV sanitizer that kills germs on your smartphone.	4
150	Orlando	24	19.99	Energy-efficient LED bulbs that can be controlled via smartphone.	2
151	Jijel	18	3.29	Refreshing tea with honey and lemon flavor, perfect for a warm drink.	5
152	Piracicaba	19	15.99	Premium potting soil for indoor plants.	2
153	Lake Gregory	40	6.49	Ready-to-eat chicken bowl with teriyaki sauce and rice.	4
154	Tuskegee	34	5.49	Pre-seasoned beef mix for delicious tacos, just heat and serve.	3
155	Huatulco	14	14.99	Cozy beanie hat to keep your head warm in the cold.	3
156	Abu Dhabi	19	49.99	Inflatable air mattress for convenient sleeping.	5
157	Jacksonville	37	14.99	Stylish holder for organizing cooking utensils.	5
158	Wilkes-Barre/Scranton	13	39.00	Manual pasta maker for homemade pasta.	5
159	Tabora	29	99.99	Powerful blender for smoothies and soups.	1
160	\N	23	14.99	Ceramic incense holder for a calming atmosphere.	4
161	Lamar	24	24.99	Stylish digital journaling app for notes and organizing tasks.	1
162	Keetmanshoop	7	4.29	Frozen onion rings, crispy and ready to bake.	5
163	Muscat	18	49.99	Inflatable air mattress for convenient sleeping.	5
164	Arapongas	18	24.99	Rich chocolate protein powder for smoothies and baking.	2
165	Champaign/Urbana	11	29.99	Ergonomic monitor stand for improved workspace organization.	3
166	Plato	29	4.99	Pulled jackfruit in a smoky BBQ sauce for a tasty vegan dish.	1
167	\N	20	8.99	Marinated chicken breasts coated in a sweet honey mustard glaze.	1
168	Orsk	9	7.49	Frozen vegan tacos filled with plant-based protein and spices.	3
169	Ascona	5	22.99	Space-saving solution to store shoes and keep them organized.	2
170	Hondarribia	39	4.79	Traditional Korean fermented vegetables, packed with flavor.	4
171	Lifou	26	12.99	Fun tourist magnets from around the world for your fridge.	3
172	Ipoh	21	4.19	Crunchy granola mixed with coconut flakes.	5
173	Altair	28	3.49	Savory sauce for vegetable and meat stir-fries.	4
174	Tripoli	34	15.99	Comfortable eye mask that includes noise-canceling ear plugs.	2
175	Cache Creek	7	29.99	Trendy leggings with a unique graphic print, versatile for workouts and casual wear.	2
176	Rocha	39	4.99	Fresh sliced strawberries for toppings or snacking	3
177	Charleville	22	3.49	Nutty granola bars for healthy snacking.	1
178	\N	20	2.29	Rich vegetable broth for soups and stews.	5
179	Niagara Falls	15	5.49	Ready-to-bake cookie dough packed with chocolate chips.	5
180	Dar es Salaam	11	39.99	Wireless microphone for singing and performances.	5
181	Magway	9	89.99	Indoor Wi-Fi camera for home security.	4
182	Ulan Ude	9	10.99	Handy keychain that emits a loud alarm for personal safety.	2
183	Bristol	36	39.99	Stylish and modern holder for storing wine bottles on walls.	3
184	Trondheim	36	19.99	Hands-free waist pack for carrying essentials while walking your dog.	2
185	\N	26	3.99	A flavorful garlic butter blend, perfect for cooking or baking.	1
186	Pangkal Pinang-Palaubangka Island	11	3.29	Crunchy pretzel nuggets filled with creamy peanut butter.	2
187	Dubai	29	2.99	Fresh and crunchy baby carrots ready for snacking.	2
188	Georgetown	6	99.99	Compact and portable projector for watching videos anywhere.	5
189	Pantnagar	29	109.99	3-inch memory foam mattress topper for added comfort.	5
190	Akjoujt	34	169.99	Portable projector with 1080p resolution for movies.	2
191	Kristianstad	39	64.99	Elegant classic pumps that add sophistication to any outfit.	4
192	Taipei	27	29.99	Portable ring light that enhances your photos with perfect lighting.	4
193	Chilas	38	3.99	Rich cocoa powder for baking and chocolate recipes.	3
194	Medford	26	5.49	Versatile puff pastry for pies and pastries.	1
195	Münster	24	29.99	Countertop compost bin for kitchen waste.	3
196	Guacamayas	35	29.99	High-capacity power bank for charging devices on the go.	5
197	Cody	9	6.99	Frozen stir-fry mix with chicken, veggies, and teriyaki sauce.	4
198	Marabá	9	18.99	Stylish dish soap dispenser with sponge holder.	3
199	Lloydminster	24	3.49	Healthy whole grain cereal, great for breakfast.	1
200	Parsabad	16	2.99	Baked kale chips seasoned for a healthy, crunchy snack.	1
202	Woodbridge	11	9.99	Tool for measuring perfect pasta portions every time.	3
203	Akjoujt	12	7.49	Marinated chicken grilled with lemon and herbs.	4
204	Diebougou	7	79.99	Electric foot massager with heat settings.	2
205	\N	25	39.99	Comfortable pet bed for small to medium-sized dogs.	5
206	Olbia (SS)	37	109.99	Lightweight and durable tent for camping trips.	2
207	Nakhon Pathom	40	8.99	High-frequency whistle for training your dog effectively.	3
208	Galbraith Lake	28	9.99	Juicy and tender boneless chicken breasts.	3
209	Fane Mission	26	3.49	Crispy and sweet dried apple slices	4
210	Stanton	12	19.99	Set of brush pens for colorful and creative painting.	2
211	Scusciuban	23	5.29	A warming blend of ginger and turmeric for lattes.	4
212	\N	30	1.29	Just add water for a quick pasta sauce.	1
213	\N	6	49.99	High-quality voice recorder for lectures and meetings.	5
214	Orange	24	29.99	Comfortable wireless headphones designed for sleeping.	1
215	\N	13	14.99	500-piece jigsaw puzzle featuring beautiful scenery.	1
216	Niamey	14	29.99	Lightweight and durable hammock for relaxing in nature.	5
217	\N	36	1.99	Sweet and crisp apples, perfect for snacking.	3
218	Kaunakakai	21	1.99	Corn on the cob seasoned with chili and lime for a spicy kick.	1
219	Menominee	27	39.99	Made from biodegradable materials for eco-conscious yogis.	4
220	Lock Haven	14	9.99	Marinated chicken skewers with lemon and dill flavor, grilled to perfection.	2
221	Mulatupo	29	14.99	Compact USB fan for personal cooling.	4
222	Cambridge	33	49.99	Versatile folding table great for events or outdoor activities.	3
223	Columbus	9	2.99	Rich dark chocolate bars, perfect for a sweet treat.	3
224	Duqm	36	23.99	Eco-friendly phone case designed to decompose safely.	2
225	Arona	12	14.99	500-piece jigsaw puzzle featuring beautiful scenery.	4
226	Mont-Joli	5	2.79	Perfect dipping sauce or stir-fry addition for a sweet and tangy flavor.	3
227	Atoifi	11	45.00	Complete set of gardening tools for outdoor tasks.	2
228	King City	40	2.49	Light and crispy baked chips, a healthier snack option.	2
229	Paragould	31	29.99	Comfortable wireless headphones designed for sleeping.	3
230	Parachinar	34	5.49	Fresh organic blueberries perfect for snacking or baking.	4
231	Luuq	28	15.99	Sustainable foam blocks for yoga practice.	4
232	Garanhuns	18	69.99	Comfortable gaming headset with surround sound.	3
233	\N	15	29.99	Monthly subscription for freshly roasted coffee delivered to your door.	4
234	Guangyuan	5	3.79	Crunchy granola with raisins and cinnamon for a delightful breakfast.	1
235	Tandil	25	4.49	Crispy chicken nuggets for quick meals.	2
236	Mount Pleasant	33	4.99	A soothing herbal tea made from ginger root.	3
237	Tanjung Pinang-Bintan Island	11	3.99	Soft oatmeal cookies with maple and pecans.	5
238	Omidiyeh	17	12.99	Set of reusable stainless steel straws for drinks.	3
239	Tobolsk	17	2.29	Light and crispy rice cakes, a perfect low-calorie snack.	3
240	\N	10	39.99	Ergonomic wireless controller for gaming consoles.	2
241	Cloudbreak Village	9	14.99	Eco-friendly bamboo holder for toothbrushes.	3
242	Fort Yukon	8	4.99	Savory sausage with a blend of spices, perfect for pasta dishes.	2
243	San Antonio de Palé	22	12.99	Tender riblets coated in a honey barbecue glaze, perfect for grilling or baking.	5
244	\N	30	3.79	A colorful variety of crunchy veggie chips for snacking.	3
245	College Station	16	49.99	Durable ceramic bakeware for casseroles and desserts.	5
246	Fort Severn	19	49.99	Non-stick griddle for pancakes, burgers, and more.	1
247	Austin	26	34.99	Comfortable and stretchy legging pants perfect for workouts or daily wear.	3
248	Hola	16	3.99	Crispy sweet potato fries, a delicious side dish.	2
249	Terrace Bay, ON	32	199.99	Secure digital wireless security camera system.	1
250	Paamiut	11	199.99	Waterproof camera for capturing underwater adventures.	3
\.


--
-- TOC entry 5473 (class 0 OID 41189)
-- Dependencies: 272
-- Data for Name: TIPO_MANTENIMIENTOS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."TIPO_MANTENIMIENTOS" (id_tipo_mantenimiento, tipo_mantenimiento, descripcion) FROM stdin;
1	Mantenimiento de iluminación decorativa	Revisión y reparación de luces decorativas en áreas comunes.
2	Mantenimiento de puertas automáticas	Revisión y ajuste de puertas automáticas de entrada y salida.
3	Mantenimiento de sistemas de riego	Revisión y reparación de aspersores y tuberías de riego.
4	Mantenimiento de sistemas de agua caliente	Revisión y reparación de calentadores y termos.
5	Mantenimiento de alarmas de gas	Inspección y prueba de detectores de gas.
6	Mantenimiento de ventiladores de techo	Limpieza y revisión de ventiladores en habitaciones y áreas comunes.
7	Mantenimiento de toldos y pérgolas	Reparación y limpieza de toldos y estructuras de sombra.
8	Mantenimiento de sistemas de bombeo de piscinas	Revisión de bombas, filtros y cloradores automáticos.
9	Mantenimiento de señalética	Revisión y reparación de letreros y señalización del hotel.
10	Mantenimiento de sistemas de automatización	Revisión de sistemas domóticos y control inteligente de habitaciones.
11	Mantenimiento de lámparas de emergencia	Revisión y reemplazo de lámparas de emergencia.
12	Mantenimiento de sistemas de energía solar	Inspección y limpieza de paneles solares y sistemas fotovoltaicos.
13	Mantenimiento de portones eléctricos	Revisión y lubricación de portones motorizados.
14	Mantenimiento de cámaras térmicas	Revisión y calibración de cámaras térmicas de seguridad.
15	Mantenimiento de sistemas de lavandería	Revisión y reparación de lavadoras y secadoras industriales.
16	Mantenimiento de fuentes y estanques	Limpieza y revisión de bombas y filtros de fuentes.
17	Mantenimiento de toldos retráctiles	Inspección y lubricación de mecanismos de toldos retráctiles.
18	Mantenimiento de gimnasios al aire libre	Revisión y limpieza de equipos de ejercicio al aire libre.
19	Mantenimiento de equipos de spa	Revisión y mantenimiento de saunas, jacuzzis y masajes.
20	Mantenimiento de cercas y barandales	Revisión, limpieza y reparación de cercas y barandales del hotel.
\.


--
-- TOC entry 5474 (class 0 OID 41194)
-- Dependencies: 273
-- Data for Name: TIPO_TRANSPORTE_EMPLEADOS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."TIPO_TRANSPORTE_EMPLEADOS" (id_tipo_transporte, nombre_tipo) FROM stdin;
1	Infiniti
2	GMC
3	Toyota
4	GMC
5	Ford
6	Hyundai
7	Audi
8	Pontiac
9	Ford
10	Cadillac
11	Toyota
12	Nissan
13	Toyota
14	Suzuki
15	Lexus
16	Toyota
17	Mazda
18	Porsche
19	Jeep
20	Ford
21	Lincoln
22	Aston Martin
23	Acura
24	BMW
25	Ford
26	Mercedes-Benz
27	Volvo
28	Suzuki
29	Honda
30	Toyota
31	Porsche
32	Mercedes-Benz
33	Mazda
34	Aston Martin
35	Ford
36	Toyota
37	Mercedes-Benz
38	Lexus
39	Ford
40	Audi
41	Audi
42	Buick
43	Ford
44	Chevrolet
45	Chevrolet
46	Nissan
47	Mazda
48	Honda
49	Mercury
50	Volkswagen
51	Porsche
52	Dodge
53	Infiniti
54	GMC
55	Toyota
56	GMC
57	Dodge
58	Saab
59	Toyota
60	Citroën
61	GMC
62	Mazda
63	Hyundai
64	Kia
65	Acura
66	Dodge
67	Lotus
68	Chevrolet
69	Mitsubishi
70	Mazda
71	Audi
72	Toyota
73	Chrysler
74	Oldsmobile
75	Nissan
76	Hyundai
77	GMC
78	Buick
79	Toyota
80	Ford
81	Hyundai
82	GMC
83	BMW
84	Chevrolet
85	Ford
86	Jeep
87	Buick
88	Ford
89	Mitsubishi
90	Oldsmobile
91	Chevrolet
92	Dodge
93	Saab
94	Kia
95	Hyundai
96	Mercedes-Benz
97	Chevrolet
98	Acura
99	Audi
100	Lexus
101	Chevrolet
102	Honda
103	Lotus
104	Mitsubishi
105	Honda
106	GMC
107	Ford
108	Pontiac
109	Mercedes-Benz
110	Nissan
111	Chevrolet
112	Volvo
113	Hummer
114	Chevrolet
115	BMW
116	Infiniti
117	Chevrolet
118	Subaru
119	Ford
120	Isuzu
121	Pontiac
122	Audi
123	Dodge
124	Mitsubishi
125	GMC
126	Honda
127	Pontiac
128	Subaru
129	Lexus
130	Chrysler
131	Pontiac
132	Volvo
133	Chevrolet
134	Land Rover
135	Mercedes-Benz
136	Subaru
137	Volvo
138	Mitsubishi
139	Toyota
140	Chevrolet
141	Buick
142	Mercury
143	Volvo
144	Chevrolet
145	Mercedes-Benz
146	Volkswagen
147	Nissan
148	Oldsmobile
149	Chrysler
150	Mazda
151	Saab
152	Mercury
153	Chevrolet
154	Pontiac
155	Lexus
156	Subaru
157	Volvo
158	Nissan
159	Lincoln
160	Chevrolet
161	Audi
162	Kia
163	Saab
164	Saturn
165	Chevrolet
166	Ford
167	Hyundai
168	Infiniti
169	Toyota
170	Nissan
171	Tesla
172	Lexus
173	Volkswagen
174	GMC
175	Mitsubishi
176	Dodge
177	Plymouth
178	Ford
179	Chevrolet
180	Nissan
181	Toyota
182	Lexus
183	Oldsmobile
184	Chevrolet
185	Pontiac
186	Lincoln
187	Hyundai
188	Mazda
189	Dodge
190	Ford
191	Land Rover
192	Honda
193	Jaguar
194	Isuzu
195	Dodge
196	Honda
197	Kia
198	GMC
199	Chrysler
200	Pontiac
201	Isuzu
202	Toyota
203	Pontiac
204	Mitsubishi
205	Nissan
206	Honda
207	Mercedes-Benz
208	Nissan
209	Lotus
210	Toyota
211	Chevrolet
212	Isuzu
213	Mitsubishi
214	Chevrolet
215	Lincoln
216	Buick
217	Mercury
218	Honda
219	Chevrolet
220	Chrysler
221	Ford
222	Jeep
223	Chrysler
224	Volkswagen
225	Chevrolet
226	Jeep
227	Maserati
228	Dodge
229	Nissan
230	Lincoln
231	Buick
232	Ford
233	Ford
234	Nissan
235	Honda
236	Ford
237	Suzuki
238	Nissan
239	Toyota
240	Nissan
241	Suzuki
242	Porsche
243	Mitsubishi
244	Land Rover
245	Porsche
246	Land Rover
247	Buick
248	Chevrolet
249	Mazda
250	Mazda
\.


--
-- TOC entry 5475 (class 0 OID 41197)
-- Dependencies: 274
-- Data for Name: TRANSPORTE_EMPLEADOS; Type: TABLE DATA; Schema: gestion_hotel; Owner: postgres
--

COPY gestion_hotel."TRANSPORTE_EMPLEADOS" (id_transporte_empleado, matricula, capacidad, id_sucursal, id_estado_transporte, id_tipo_transporte, modelo) FROM stdin;
1	8516393607	31	1	1	1	Ram 1500
2	6709005038	43	2	2	2	911
3	6862682555	31	3	3	3	Tundra
4	0527193380	25	4	4	4	Sable
5	5652573406	31	5	5	5	LTD
6	6933438554	11	6	6	6	Ipsum
7	4320686314	35	7	7	7	Town & Country
8	3457412456	8	8	8	8	Aurora
9	7088148439	10	9	9	9	GX
10	6975944938	40	10	10	10	GLI
11	2749438276	44	11	11	11	Mustang
12	4547294070	25	12	12	12	Town & Country
13	8445094351	13	13	13	13	K5 Blazer
14	2740768702	25	14	14	14	Swift
15	4382958172	49	15	15	15	G25
16	6709958213	2	16	16	16	Montana
17	1742504558	26	17	17	17	Sable
18	8361519858	42	18	18	18	Focus
19	1439863024	35	19	19	19	Rodeo
20	2282305914	14	20	20	20	Bronco II
21	4326077913	36	21	21	21	Range Rover
22	8174044892	44	22	22	22	626
23	2794847791	40	23	23	23	GT500
24	7296152168	14	24	24	24	Gran Sport
25	8078817843	45	25	25	25	S-Type
26	5787346173	31	26	26	26	Malibu
27	8453139385	21	27	27	27	Sebring
28	6610649243	15	28	28	28	G-Class
29	6041091022	21	29	29	29	CX-5
30	5956665106	47	30	30	30	Ram Van 3500
31	7029458567	1	31	31	31	Starion
32	8008109408	15	32	32	32	458 Italia
33	8705771277	30	33	33	33	F430 Spider
34	7295687483	45	34	34	34	Equator
35	5746155179	16	35	35	35	Civic
36	2408566614	43	36	36	36	Ranger
37	5862321098	45	37	37	37	Cutlass
38	6062827761	18	38	38	38	MR2
39	2833960786	16	39	39	39	Express 3500
40	8792757863	33	40	40	40	Voyager
41	2299011234	44	41	41	41	Tahoe
42	9433828682	14	42	42	42	G37
43	9637139109	39	43	43	43	Forester
44	7564699752	40	44	44	44	Sequoia
45	8582524196	25	45	45	45	A4
46	1296202380	32	46	46	46	Savana 1500
47	9088315639	32	47	47	47	Solstice
48	6607518222	42	48	48	48	Justy
49	3282407432	9	49	49	49	911
50	1494947498	35	50	50	50	280ZX
51	9483678781	11	51	51	51	Sonata
52	1088670520	16	52	52	52	911
53	0120549344	14	53	53	53	A8
54	3294616112	15	54	54	54	Altima
55	4828307400	32	55	55	55	Torrent
56	7876814980	22	56	56	56	Genesis
57	7110866750	29	57	57	57	Caravan
58	3807079947	35	58	58	58	3 Series
59	6420974909	45	59	59	59	Tacoma Xtra
60	6144930809	31	60	60	60	XC60
61	5151112945	34	61	61	61	Dakota
62	5290313249	20	62	62	62	900
63	4590458071	37	63	63	63	Excel
64	0167932616	33	64	64	64	ES
65	1462233589	10	65	65	65	Eldorado
66	8262321391	16	66	66	66	Somerset
67	0242323766	38	67	67	67	Yukon
68	8559600868	48	68	68	68	Mighty Max Macro
69	3330510218	18	69	69	69	2500
70	1499980973	46	70	70	70	Regal
71	3246414424	33	71	71	71	Escalade EXT
72	7743386902	3	72	72	72	CT
73	0032216734	38	73	73	73	M5
74	6800356069	50	74	74	74	Sidekick
75	5016228949	20	75	75	75	Legacy
76	7359193001	29	76	76	76	Ridgeline
77	7408569960	50	77	77	77	Grand Cherokee
78	0790314193	26	78	78	78	Tempo
79	2582704415	24	79	79	79	Achieva
80	4579566785	15	80	80	80	Daewoo Kalos
81	4580221230	31	81	81	81	Volt
82	9556986715	3	82	82	82	CTS
83	7971488092	23	83	83	83	Mighty Max
84	6767543756	28	84	84	84	Focus
85	3351690118	25	85	85	85	MKX
86	7813233603	27	86	86	86	Corvair 500
87	3402135787	27	87	87	87	Galant
88	5347108819	10	88	88	88	S-Class
89	6940596615	26	89	89	89	Space
90	9468098486	47	90	90	90	GTI
91	1239037228	50	91	91	91	GranTurismo
92	1137588179	50	92	92	92	MDX
93	2950736092	5	93	93	93	Relay
94	8024053373	4	94	94	94	Odyssey
95	5198530263	41	95	95	95	Eldorado
96	6502668569	36	96	96	96	TrailBlazer
97	1179518977	15	97	97	97	Escalade
98	4651780687	6	98	98	98	Prius
99	3341234055	1	99	99	99	Grand Cherokee
100	2373391856	9	100	100	100	Accent
101	4684049221	18	101	101	101	MDX
102	0899914896	47	102	102	102	SLK-Class
103	2697719652	9	103	103	103	Ranger
104	2039436081	43	104	104	104	500SEL
105	2434161162	4	105	105	105	H1
106	5822548970	21	106	106	106	Park Avenue
107	6914778671	40	107	107	107	Altima
108	9960061159	14	108	108	108	ES
109	3637684195	30	109	109	109	RVR
110	2709427672	20	110	110	110	Passat
111	7424088548	21	111	111	111	Accord
112	5066522131	24	112	112	112	Beetle
113	1040626262	26	113	113	113	Concorde
114	3874935558	8	114	114	114	Fusion
115	4402306817	30	115	115	115	A8
116	4168658619	8	116	116	116	R-Class
117	7513621365	37	117	117	117	Cirrus
118	1793010447	1	118	118	118	Xterra
119	6198738736	17	119	119	119	Grand Prix
120	4828535691	10	120	120	120	Park Avenue
121	3007643074	23	121	121	121	LeBaron
122	6602448889	23	122	122	122	Grand Marquis
123	3820700730	42	123	123	123	Mustang
124	5957107506	48	124	124	124	SL-Class
125	6947810531	12	125	125	125	E-Series
126	1180212053	9	126	126	126	Suburban 2500
127	4774162809	14	127	127	127	Esprit
128	3550635117	13	128	128	128	CL
129	1642637599	24	129	129	129	Chariot
130	0143820001	38	130	130	130	F-Series
131	1662462336	15	131	131	131	Mustang
132	4562218843	17	132	132	132	Regal
133	7306311085	34	133	133	133	Sunbird
134	3825367185	4	134	134	134	Carens
135	6220583604	14	135	135	135	Cutlass Supreme
136	8906139764	17	136	136	136	Mustang
137	7170178583	33	137	137	137	Econoline E150
138	0957952473	11	138	138	138	Jetta
139	4623401057	8	139	139	139	Safari
140	1109845162	11	140	140	140	Express
141	4050509725	2	141	141	141	Sunbird
142	1443892831	28	142	142	142	Phantom
143	5757679751	34	143	143	143	Navigator
144	8795040552	27	144	144	144	Ram
145	6700187176	30	145	145	145	IS
146	0972668551	25	146	146	146	Cavalier
147	0246785578	48	147	147	147	Supra
148	3291314611	18	148	148	148	Accord
149	3173177347	8	149	149	149	Navigator
150	2959497171	12	150	150	150	Corolla
151	5543424477	4	151	151	151	Legend
152	4451345448	35	152	152	152	Laser
153	2309819980	42	153	153	153	E-Class
154	9138167336	15	154	154	154	Quattroporte
155	3506902369	47	155	155	155	Sonata
156	4553028115	42	156	156	156	Cougar
157	7763743506	24	157	157	157	Continental Mark VII
158	3175462537	36	158	158	158	RS6
159	5954189102	8	159	159	159	L-Series
160	3886795985	5	160	160	160	xB
161	0269704000	39	161	161	161	Aviator
162	2805474740	48	162	162	162	Chariot
163	1256006793	31	163	163	163	Sportvan G10
164	6611375325	9	164	164	164	Turbo Firefly
165	3050372265	41	165	165	165	LR2
166	7662493644	18	166	166	166	E-Class
167	4899037821	34	167	167	167	Hombre
168	8181126114	43	168	168	168	Carens
169	7632872795	3	169	169	169	Enclave
170	1263385915	4	170	170	170	Z4 M
171	1154658732	30	171	171	171	Avalon
172	7415985141	8	172	172	172	Datsun/Nissan Z-car
173	6835388277	17	173	173	173	SL-Class
174	1707529787	16	174	174	174	9000
175	3284486992	22	175	175	175	911
176	8229281556	3	176	176	176	Caravan
177	2551957788	5	177	177	177	E-Series
178	5032711217	10	178	178	178	3 Series
179	0690161891	31	179	179	179	Diablo
180	2318269211	1	180	180	180	400E
181	3364829632	20	181	181	181	XK Series
182	7746945597	38	182	182	182	Cayman
183	3261846895	13	183	183	183	LeSabre
184	6371920944	40	184	184	184	MX-6
185	0885693159	5	185	185	185	Panamera
186	0950051136	28	186	186	186	Mirage
187	0203504704	24	187	187	187	Civic
188	5125293903	41	188	188	188	Expedition EL
189	5757252480	29	189	189	189	E-Series
190	7589643459	23	190	190	190	F-Series
191	6159241982	35	191	191	191	CX
192	6106180563	31	192	192	192	Club Wagon
193	7854893713	30	193	193	193	Veyron
194	8725638947	15	194	194	194	Tundra
195	4776186306	36	195	195	195	929
196	6333126713	30	196	196	196	Freelander
197	8862186282	25	197	197	197	XK Series
198	3798357331	34	198	198	198	F150
199	4937519077	29	199	199	199	XC60
200	7297107875	26	200	200	200	Xterra
201	4997729825	35	201	201	201	Escalade ESV
202	6229543451	33	202	202	202	Swift
203	6481155894	10	203	203	203	Crown Victoria
204	7719307755	2	204	204	204	Tahoe
205	7132605917	27	205	205	205	Explorer
206	4433632651	35	206	206	206	Horizon
207	5762789071	45	207	207	207	Sunfire
208	9357858792	41	208	208	208	Canyon
209	1072134098	17	209	209	209	Sunfire
210	9766617635	19	210	210	210	Golf
211	9541941966	2	211	211	211	Solstice
212	5761458063	12	212	212	212	Truck
213	4467696210	20	213	213	213	370Z
214	6391777470	17	214	214	214	525
215	6027359323	34	215	215	215	4Runner
216	3888878934	16	216	216	216	SL-Class
217	6397894665	33	217	217	217	Neon
218	4777248488	17	218	218	218	S-Series
219	3314346727	11	219	219	219	TL
220	9961616138	23	220	220	220	SVX
221	8492869364	48	221	221	221	Mustang
222	3362563635	15	222	222	222	Viper
223	8942890725	50	223	223	223	LS
224	5872560567	7	224	224	224	Tiguan
225	3513817959	48	225	225	225	Club Wagon
226	4486109120	25	226	226	226	Tiburon
227	3980952541	19	227	227	227	Z3
228	9628043072	44	228	228	228	Carrera GT
229	3420216440	37	229	229	229	S6
230	5900754146	19	230	230	230	Tundra
231	6727165084	10	231	231	231	Outlander
232	6600943076	8	232	232	232	Ranger
233	2445844886	22	233	233	233	Mountaineer
234	3562167520	36	234	234	234	Sierra
235	2823944664	17	235	235	235	2500
236	3473100587	43	236	236	236	Highlander
237	1629159964	27	237	237	237	TL
238	7983789378	16	238	238	238	Eclipse
239	0966731050	8	239	239	239	Ram 3500
240	1304921387	35	240	240	240	Prelude
241	6631351936	46	241	241	241	Sunbird
242	1220452157	9	242	242	242	K5 Blazer
243	8600433045	21	243	243	243	Grand Cherokee
244	9239899685	41	244	244	244	C-Class
245	2683366027	11	245	245	245	Yaris
246	7306941119	50	246	246	246	Highlander
247	8923537225	22	247	247	247	MKZ
248	8217265046	25	248	248	248	E-Class
249	9477488275	26	249	249	249	Ram Van 3500
250	9136297720	10	250	250	250	RAV4
\.


--
-- TOC entry 5595 (class 0 OID 0)
-- Dependencies: 275
-- Name: area_id_area_seq; Type: SEQUENCE SET; Schema: gestion_hotel; Owner: postgres
--

SELECT pg_catalog.setval('gestion_hotel.area_id_area_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.autos_id_clientes_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.cargo_estacionamiento_id_cargo_estacionamiento_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.cargo_estacionamiento_id_estacionamiento_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.ciudades_id_ciudad_seq', 1, true);


SELECT pg_catalog.setval('gestion_hotel.clientes_id_clientes_seq', 1, false);



SELECT pg_catalog.setval('gestion_hotel.compras_insumos_id_compra_seq', 1, false);

SELECT pg_catalog.setval('gestion_hotel.deducciones_factura_id_deducciones_factura_seq', 1, false);



SELECT pg_catalog.setval('gestion_hotel.detalle_compra_id_detalle_compra_seq', 1, false);



SELECT pg_catalog.setval('gestion_hotel.detalle_compra_mobiliarios_id_detalle_compra_mobiliarios_seq', 1, false);



SELECT pg_catalog.setval('gestion_hotel.detalle_factura_id_detalle_factura_seq', 1, false);



SELECT pg_catalog.setval('gestion_hotel.detalle_pedido_proveedor_id_detalle_pedido_proveedor_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.detalle_servicio_habitacion_id_detalle_servicio_habitacion_seq', 1, false);



SELECT pg_catalog.setval('gestion_hotel.detalle_transporte_id_detalle_transporte_seq', 1, false);

SELECT pg_catalog.setval('gestion_hotel.detalles_platillo_id_detalles_platillo_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.detalles_promocion_id_detalles_promocion_seq', 1, false);

SELECT pg_catalog.setval('gestion_hotel.dosendos', 2, false);


SELECT pg_catalog.setval('gestion_hotel.empleados_numero_tarjeta_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.encabezado_compra_mobiliario_id_compra_seq', 1, false);



SELECT pg_catalog.setval('gestion_hotel.encabezado_platillos_id_platillo_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.estacionamiento_id_estacionamiento_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.estacionamiento_id_sucursal_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.estado_habitacion_id_estado_habitacion_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.estado_id_estado_seq', 1, true);


SELECT pg_catalog.setval('gestion_hotel.estado_mantenimiento_id_estado_mantenimiento_seq', 1, false);



SELECT pg_catalog.setval('gestion_hotel.estado_reservacion_id_estado_reservacion_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.estado_transporte_id_estado_transporte_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.estatus_pago_id_estatus_pago_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.factura_id_factura_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.habitacion_id_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.historial_precios_habitacione_id_historial_precios_habitaci_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.historial_precios_habitaciones_id_tipo_habitacion_seq', 1, false);



SELECT pg_catalog.setval('gestion_hotel.historial_precios_servicios_id_historial_precios_servicios_seq', 1, false);

SELECT pg_catalog.setval('gestion_hotel.historial_precios_servicios_id_servicio_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.hotel_id_hotel_seq', 1, true);


SELECT pg_catalog.setval('gestion_hotel.insumos_id_insumos_seq', 1, false);

SELECT pg_catalog.setval('gestion_hotel.inventario_habitacion_id_inventario_habitacion_seq', 1, false);



SELECT pg_catalog.setval('gestion_hotel.mantenimiento_id_mantenimiento_seq', 1, false);

SELECT pg_catalog.setval('gestion_hotel.marcas_id_marca_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.metodo_pago_id_metodo_pago_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.mobiliarios_id_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.pago_id_pago_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.pedido_proveedor_id_pedido_proveedor_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.promociones_id_promocion_seq', 1, false);



SELECT pg_catalog.setval('gestion_hotel.proveedores_id_proveedor_seq', 1, false);



SELECT pg_catalog.setval('gestion_hotel.proveedores_mobiliarios_id_proveedor_mobiliario_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.puesto_id_puesto_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.reservaciones_id_reservation_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.salon_id_salon_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.salon_id_sucursal_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.secuenciacargoestacionamiento', 1, false);


SELECT pg_catalog.setval('gestion_hotel.servicio_habitacion_id_servicio_habitacion_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.servicio_id_servicio_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.sucursales_id_sucursal_seq', 1, false);

SELECT pg_catalog.setval('gestion_hotel.tipo_cama_id_tipo_cama_seq', 5, true);



SELECT pg_catalog.setval('gestion_hotel.tipo_habitacion_id_seq', 1, false);


SELECT pg_catalog.setval('gestion_hotel.tipo_mantenimiento_id_tipo_mantenimiento_seq', 20, true);



SELECT pg_catalog.setval('gestion_hotel.tipo_transporte_id_tipo_transporte_seq', 1, false);



SELECT pg_catalog.setval('gestion_hotel.transporte_empleados_id_transporte_empleado_seq', 1, false);



SELECT pg_catalog.setval('gestion_hotel.trikitrakatelas', 3, false);



ALTER TABLE gestion_hotel."DETALLES_RESERVAS"
    ADD CONSTRAINT "DETALLES_RESERVAS_pkey" PRIMARY KEY (id_reservacion, numero_habitacion);


ALTER TABLE gestion_hotel."DETALLE_COMPRA_INSUMOS"
    ADD CONSTRAINT "DETALLE_COMPRA_INSUMOS_pkey" PRIMARY KEY (id_insumos, id_compra);


ALTER TABLE gestion_hotel."DETALLE_COMPRA_MOBILIARIO"
    ADD CONSTRAINT "DETALLE_COMPRA_MOBILIARIO_pkey" PRIMARY KEY (id_mobiliario, id_compra);



ALTER TABLE gestion_hotel."AREAS"
    ADD CONSTRAINT area_pkey PRIMARY KEY (id_area);


ALTER TABLE gestion_hotel."AUTOS"
    ADD CONSTRAINT autos_pkey PRIMARY KEY (matricula);



ALTER TABLE gestion_hotel."CARGO_ESTACIONAMIENTO"
    ADD CONSTRAINT cargo_estacionamiento_pkey PRIMARY KEY (id_cargo_estacionamiento);


ALTER TABLE gestion_hotel."CIUDADES"
    ADD CONSTRAINT ciudades_pkey PRIMARY KEY (id_ciudad);



ALTER TABLE gestion_hotel."CLIENTES"
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id_clientes);


ALTER TABLE gestion_hotel."CLIENTES"
    ADD CONSTRAINT clientes_rfc_key UNIQUE (rfc_cliente);



ALTER TABLE gestion_hotel."COMPRAS_INSUMOS"
    ADD CONSTRAINT compras_insumos_pkey PRIMARY KEY (id_compra);

ALTER TABLE gestion_hotel."DEDUCCIONES_FACTURA"
    ADD CONSTRAINT deducciones_factura_pkey PRIMARY KEY (id_deducciones_factura);


ALTER TABLE gestion_hotel."DETALLE_FACTURA"
    ADD CONSTRAINT detalle_factura_pkey PRIMARY KEY (id_detalle_factura);



ALTER TABLE gestion_hotel."DETALLE_PEDIDO_PROVEEDOR"
    ADD CONSTRAINT detalle_pedido_proveedor_pkey PRIMARY KEY (id_detalle_pedido_proveedor);



ALTER TABLE gestion_hotel."DETALLE_SERVICIO_HABITACION"
    ADD CONSTRAINT detalle_servicio_habitacion_pkey PRIMARY KEY (id_detalle_servicio_habitacion);



ALTER TABLE gestion_hotel."DETALLE_TRANSPORTE"
    ADD CONSTRAINT detalle_transporte_pkey PRIMARY KEY (id_detalle_transporte);


ALTER TABLE gestion_hotel."DETALLE_PLATILLO"
    ADD CONSTRAINT detalles_platillo_pkey PRIMARY KEY (id_detalles_platillo);



ALTER TABLE gestion_hotel."DETALLES_PROMOCION"
    ADD CONSTRAINT detalles_promocion_pkey PRIMARY KEY (id_detalles_promocion);


ALTER TABLE gestion_hotel."EMPLEADOS"
    ADD CONSTRAINT empleados_pkey PRIMARY KEY (numero_tarjeta);

ALTER TABLE gestion_hotel."ENCABEZADO_COMPRA_MOBILIARIO"
    ADD CONSTRAINT encabezado_compra_mobiliario_pkey PRIMARY KEY (id_compra_mobiliario);


ALTER TABLE gestion_hotel."ENCABEZADO_PLATILLOS"
    ADD CONSTRAINT encabezado_platillos_pkey PRIMARY KEY (id_platillo);


ALTER TABLE gestion_hotel."ESTACIONAMIENTOS"
    ADD CONSTRAINT estacionamiento_pkey PRIMARY KEY (id_estacionamiento);



ALTER TABLE gestion_hotel."ESTADO_HABITACION"
    ADD CONSTRAINT estado_habitacion_pkey PRIMARY KEY (id_estado_habitacion);

ALTER TABLE gestion_hotel."ESTADO_MANTENIMIENTO"
    ADD CONSTRAINT estado_mantenimiento_pkey PRIMARY KEY (id_estado_mantenimiento);

ALTER TABLE gestion_hotel."ESTADOS"
    ADD CONSTRAINT estado_pkey PRIMARY KEY (id_estado);



ALTER TABLE gestion_hotel."ESTADO_RESERVACION"
    ADD CONSTRAINT estado_reservacion_pkey PRIMARY KEY (id_estado_reservacion);



ALTER TABLE gestion_hotel."ESTADO_TRANSPORTE"
    ADD CONSTRAINT estado_transporte_pkey PRIMARY KEY (id_estado_transporte);


ALTER TABLE gestion_hotel."ESTATUS_PAGO"
    ADD CONSTRAINT estatus_pago_pkey PRIMARY KEY (id_estatus_pago);


ALTER TABLE gestion_hotel."FACTURAS"
    ADD CONSTRAINT factura_pkey PRIMARY KEY (id_factura);



ALTER TABLE gestion_hotel."HABITACIONES"
    ADD CONSTRAINT habitacion_pkey PRIMARY KEY (numero_habitacion);


ALTER TABLE gestion_hotel."HISTORIAL_PRECIO_HABITACIONES"
    ADD CONSTRAINT historial_precios_habitaciones_pkey PRIMARY KEY (id_historial_precios_habitaciones);



ALTER TABLE gestion_hotel."HISTORIAL_PRECIO_SERVICIOS"
    ADD CONSTRAINT historial_precios_servicios_pkey PRIMARY KEY (id_historial_precios_servicios);


ALTER TABLE gestion_hotel."HOTEL"
    ADD CONSTRAINT hotel_pkey PRIMARY KEY (id_hotel);



ALTER TABLE gestion_hotel."INSUMOS"
    ADD CONSTRAINT insumos_pkey PRIMARY KEY (id_insumos);



ALTER TABLE gestion_hotel."INVENTARIO_HABITACION"
    ADD CONSTRAINT inventario_habitacion_pkey PRIMARY KEY (id_inventario_habitacion);


ALTER TABLE gestion_hotel."MANTENIMIENTOS"
    ADD CONSTRAINT mantenimiento_pkey PRIMARY KEY (id_mantenimiento);

ALTER TABLE gestion_hotel."MARCAS"
    ADD CONSTRAINT marcas_pkey PRIMARY KEY (id_marca);



ALTER TABLE gestion_hotel."METODO_PAGO"
    ADD CONSTRAINT metodo_pago_pkey PRIMARY KEY (id_metodo_pago);



ALTER TABLE gestion_hotel."MOBILIARIOS"
    ADD CONSTRAINT mobiliarios_pkey PRIMARY KEY (id_mobiliario);


ALTER TABLE gestion_hotel."PAGOS"
    ADD CONSTRAINT pago_pkey PRIMARY KEY (id_pago);


ALTER TABLE gestion_hotel."PEDIDO_PROVEEDOR"
    ADD CONSTRAINT pedido_proveedor_pkey PRIMARY KEY (id_pedido_proveedor);

ALTER TABLE gestion_hotel."PROMOCIONES"
    ADD CONSTRAINT promociones_pkey PRIMARY KEY (id_promocion);


ALTER TABLE gestion_hotel."PROVEEDORES_MOBILIARIOS"
    ADD CONSTRAINT proveedores_mobiliarios_pkey PRIMARY KEY (id_proveedor_mobiliario);


ALTER TABLE gestion_hotel."PROVEEDORES_INSUMOS"
    ADD CONSTRAINT proveedores_pkey PRIMARY KEY (id_proveedor_insumos);


ALTER TABLE gestion_hotel."PUESTOS"
    ADD CONSTRAINT puesto_pkey PRIMARY KEY (id_puesto);


ALTER TABLE gestion_hotel."RESERVACIONES"
    ADD CONSTRAINT reservaciones_pkey PRIMARY KEY (id_reservacion);



ALTER TABLE gestion_hotel."SALON"
    ADD CONSTRAINT salon_pkey PRIMARY KEY (id_salon);



ALTER TABLE gestion_hotel."SERVICIO_HABITACION"
    ADD CONSTRAINT servicio_habitacion_pkey PRIMARY KEY (id_servicio_habitacion);


ALTER TABLE gestion_hotel."SERVICIOS"
    ADD CONSTRAINT servicio_pkey PRIMARY KEY (id_servicio);



ALTER TABLE gestion_hotel."SUCURSALES"
    ADD CONSTRAINT sucursales_pkey PRIMARY KEY (id_sucursal);



ALTER TABLE gestion_hotel."TIPO_CAMAS"
    ADD CONSTRAINT tipo_cama_pkey PRIMARY KEY (id_tipo_cama);


ALTER TABLE gestion_hotel."TIPO_HABITACIONES"
    ADD CONSTRAINT tipo_habitacion_pkey PRIMARY KEY (id_tipo_habitacion);

ALTER TABLE gestion_hotel."TIPO_MANTENIMIENTOS"
    ADD CONSTRAINT tipo_mantenimiento_pkey PRIMARY KEY (id_tipo_mantenimiento);



ALTER TABLE gestion_hotel."TIPO_TRANSPORTE_EMPLEADOS"
    ADD CONSTRAINT tipo_transporte_pkey PRIMARY KEY (id_tipo_transporte);



ALTER TABLE gestion_hotel."TRANSPORTE_EMPLEADOS"
    ADD CONSTRAINT transporte_empleados_pkey PRIMARY KEY (id_transporte_empleado);


ALTER TABLE gestion_hotel."EMPLEADOS"
    ADD CONSTRAINT area FOREIGN KEY (id_area) REFERENCES gestion_hotel."AREAS"(id_area) NOT VALID;


ALTER TABLE gestion_hotel."PUESTOS"
    ADD CONSTRAINT area FOREIGN KEY (id_area) REFERENCES gestion_hotel."AREAS"(id_area) NOT VALID;



ALTER TABLE gestion_hotel."CLIENTES"
    ADD CONSTRAINT ciudad FOREIGN KEY (id_ciudad) REFERENCES gestion_hotel."CIUDADES"(id_ciudad) NOT VALID;


ALTER TABLE gestion_hotel."EMPLEADOS"
    ADD CONSTRAINT ciudad FOREIGN KEY (id_ciudad) REFERENCES gestion_hotel."CIUDADES"(id_ciudad) NOT VALID;

ALTER TABLE gestion_hotel."SUCURSALES"
    ADD CONSTRAINT ciudad FOREIGN KEY (id_ciudad) REFERENCES gestion_hotel."CIUDADES"(id_ciudad) NOT VALID;



ALTER TABLE gestion_hotel."DETALLE_SERVICIO_HABITACION"
    ADD CONSTRAINT cliente FOREIGN KEY (id_clientes) REFERENCES gestion_hotel."CLIENTES"(id_clientes) NOT VALID;



ALTER TABLE gestion_hotel."FACTURAS"
    ADD CONSTRAINT cliente FOREIGN KEY (id_clientes) REFERENCES gestion_hotel."CLIENTES"(id_clientes) NOT VALID;



ALTER TABLE gestion_hotel."RESERVACIONES"
    ADD CONSTRAINT cliente FOREIGN KEY (id_clientes) REFERENCES gestion_hotel."CLIENTES"(id_clientes) NOT VALID;

ALTER TABLE gestion_hotel."PAGOS"
    ADD CONSTRAINT clientes FOREIGN KEY (id_clientes) REFERENCES gestion_hotel."CLIENTES"(id_clientes) NOT VALID;



ALTER TABLE gestion_hotel."AUTOS"
    ADD CONSTRAINT clientesautos FOREIGN KEY (id_clientes) REFERENCES gestion_hotel."CLIENTES"(id_clientes) NOT VALID;


ALTER TABLE gestion_hotel."CONTRATO_SERVICIOS"
    ADD CONSTRAINT clientesservicios FOREIGN KEY (id_clientes) REFERENCES gestion_hotel."CLIENTES"(id_clientes) NOT VALID;



ALTER TABLE gestion_hotel."DETALLE_COMPRA_INSUMOS"
    ADD CONSTRAINT comprainsumo FOREIGN KEY (id_compra) REFERENCES gestion_hotel."COMPRAS_INSUMOS"(id_compra) NOT VALID;



ALTER TABLE gestion_hotel."DETALLES_RESERVAS"
    ADD CONSTRAINT detalleresereva FOREIGN KEY (id_reservacion) REFERENCES gestion_hotel."RESERVACIONES"(id_reservacion) NOT VALID;



ALTER TABLE gestion_hotel."DETALLES_PROMOCION"
    ADD CONSTRAINT detallesdepromocion FOREIGN KEY (id_promocion) REFERENCES gestion_hotel."PROMOCIONES"(id_promocion) NOT VALID;



ALTER TABLE gestion_hotel."DETALLE_TRANSPORTE"
    ADD CONSTRAINT empleado FOREIGN KEY (numero_tarjeta) REFERENCES gestion_hotel."EMPLEADOS"(numero_tarjeta) NOT VALID;



ALTER TABLE gestion_hotel."RESERVACIONES"
    ADD CONSTRAINT empleado FOREIGN KEY (numero_tarjeta) REFERENCES gestion_hotel."EMPLEADOS"(numero_tarjeta) NOT VALID;


ALTER TABLE gestion_hotel."CARGO_ESTACIONAMIENTO"
    ADD CONSTRAINT estacionamientocargo FOREIGN KEY (id_estacionamiento) REFERENCES gestion_hotel."ESTACIONAMIENTOS"(id_estacionamiento) NOT VALID;


ALTER TABLE gestion_hotel."HABITACIONES"
    ADD CONSTRAINT estado FOREIGN KEY (id_estado_habitacion) REFERENCES gestion_hotel."ESTADO_HABITACION"(id_estado_habitacion) NOT VALID;


ALTER TABLE gestion_hotel."MANTENIMIENTOS"
    ADD CONSTRAINT estado FOREIGN KEY (id_estado_mantenimiento) REFERENCES gestion_hotel."ESTADO_MANTENIMIENTO"(id_estado_mantenimiento) NOT VALID;


ALTER TABLE gestion_hotel."RESERVACIONES"
    ADD CONSTRAINT estado FOREIGN KEY (id_estado_reservacion) REFERENCES gestion_hotel."ESTADO_RESERVACION"(id_estado_reservacion) NOT VALID;



ALTER TABLE gestion_hotel."SUCURSALES"
    ADD CONSTRAINT estado FOREIGN KEY (id_estado) REFERENCES gestion_hotel."ESTADOS"(id_estado) NOT VALID;



ALTER TABLE gestion_hotel."TRANSPORTE_EMPLEADOS"
    ADD CONSTRAINT estado FOREIGN KEY (id_estado_transporte) REFERENCES gestion_hotel."ESTADO_TRANSPORTE"(id_estado_transporte) NOT VALID;



ALTER TABLE gestion_hotel."CIUDADES"
    ADD CONSTRAINT estadociudad FOREIGN KEY (id_estado) REFERENCES gestion_hotel."ESTADOS"(id_estado) NOT VALID;


ALTER TABLE gestion_hotel."PAGOS"
    ADD CONSTRAINT estatus FOREIGN KEY (id_estatus_pago) REFERENCES gestion_hotel."ESTATUS_PAGO"(id_estatus_pago) NOT VALID;


ALTER TABLE gestion_hotel."DETALLE_FACTURA"
    ADD CONSTRAINT factura FOREIGN KEY (id_factura) REFERENCES gestion_hotel."FACTURAS"(id_factura) NOT VALID;


ALTER TABLE gestion_hotel."INVENTARIO_HABITACION"
    ADD CONSTRAINT habitacion FOREIGN KEY (numero_habitacion) REFERENCES gestion_hotel."HABITACIONES"(numero_habitacion) NOT VALID;



ALTER TABLE gestion_hotel."SUCURSALES"
    ADD CONSTRAINT hotel FOREIGN KEY (id_hotel) REFERENCES gestion_hotel."HOTEL"(id_hotel) NOT VALID;


ALTER TABLE gestion_hotel."DETALLE_COMPRA_INSUMOS"
    ADD CONSTRAINT insumodetalle FOREIGN KEY (id_insumos) REFERENCES gestion_hotel."INSUMOS"(id_insumos) NOT VALID;


ALTER TABLE gestion_hotel."DETALLE_PLATILLO"
    ADD CONSTRAINT insumosplatillo FOREIGN KEY (id_insumos) REFERENCES gestion_hotel."INSUMOS"(id_insumos) NOT VALID;


ALTER TABLE gestion_hotel."MOBILIARIOS"
    ADD CONSTRAINT marca FOREIGN KEY (id_marca) REFERENCES gestion_hotel."MARCAS"(id_marca) NOT VALID;


ALTER TABLE gestion_hotel."CARGO_ESTACIONAMIENTO"
    ADD CONSTRAINT matriculacargo FOREIGN KEY (matricula) REFERENCES gestion_hotel."AUTOS"(matricula) NOT VALID;


ALTER TABLE gestion_hotel."PAGOS"
    ADD CONSTRAINT metodo FOREIGN KEY (id_metodo_pago) REFERENCES gestion_hotel."METODO_PAGO"(id_metodo_pago) NOT VALID;


ALTER TABLE gestion_hotel."DETALLES_RESERVAS"
    ADD CONSTRAINT numerohabitacion FOREIGN KEY (numero_habitacion) REFERENCES gestion_hotel."HABITACIONES"(numero_habitacion) NOT VALID;



ALTER TABLE gestion_hotel."DETALLE_FACTURA"
    ADD CONSTRAINT pagofacturas FOREIGN KEY (id_pago) REFERENCES gestion_hotel."PAGOS"(id_pago) NOT VALID;


ALTER TABLE gestion_hotel."CONTRATO_SERVICIOS"
    ADD CONSTRAINT pagoservicio FOREIGN KEY (id_pago) REFERENCES gestion_hotel."PAGOS"(id_pago) NOT VALID;



ALTER TABLE gestion_hotel."DETALLE_PEDIDO_PROVEEDOR"
    ADD CONSTRAINT pedidoprov FOREIGN KEY (id_pedido_proveedor) REFERENCES gestion_hotel."PEDIDO_PROVEEDOR"(id_pedido_proveedor) NOT VALID;


ALTER TABLE gestion_hotel."DETALLE_PLATILLO"
    ADD CONSTRAINT platillo FOREIGN KEY (id_platillo) REFERENCES gestion_hotel."ENCABEZADO_PLATILLOS"(id_platillo) NOT VALID;


ALTER TABLE gestion_hotel."DETALLE_SERVICIO_HABITACION"
    ADD CONSTRAINT platillo FOREIGN KEY (id_platillo) REFERENCES gestion_hotel."ENCABEZADO_PLATILLOS"(id_platillo) NOT VALID;


ALTER TABLE gestion_hotel."COMPRAS_INSUMOS"
    ADD CONSTRAINT provedorcomprasinsumos FOREIGN KEY (id_proveedor_insumos) REFERENCES gestion_hotel."PROVEEDORES_INSUMOS"(id_proveedor_insumos) NOT VALID;


ALTER TABLE gestion_hotel."DETALLE_COMPRA_MOBILIARIO"
    ADD CONSTRAINT proveedor FOREIGN KEY (id_mobiliario) REFERENCES gestion_hotel."MOBILIARIOS"(id_mobiliario) NOT VALID;



ALTER TABLE gestion_hotel."ENCABEZADO_COMPRA_MOBILIARIO"
    ADD CONSTRAINT proveedor FOREIGN KEY (id_proveedor_mobiliario) REFERENCES gestion_hotel."PROVEEDORES_MOBILIARIOS"(id_proveedor_mobiliario) NOT VALID;


ALTER TABLE gestion_hotel."EMPLEADOS"
    ADD CONSTRAINT puesto FOREIGN KEY (id_puesto) REFERENCES gestion_hotel."PUESTOS"(id_puesto) NOT VALID;



ALTER TABLE gestion_hotel."DETALLE_SERVICIO_HABITACION"
    ADD CONSTRAINT servicio FOREIGN KEY (id_servicio_habitacion) REFERENCES gestion_hotel."SERVICIO_HABITACION"(id_servicio_habitacion) NOT VALID;


ALTER TABLE gestion_hotel."HISTORIAL_PRECIO_SERVICIOS"
    ADD CONSTRAINT servicio FOREIGN KEY (id_servicio) REFERENCES gestion_hotel."SERVICIOS"(id_servicio) NOT VALID;


ALTER TABLE gestion_hotel."CONTRATO_SERVICIOS"
    ADD CONSTRAINT serviciocontrarto FOREIGN KEY (id_servicio) REFERENCES gestion_hotel."SERVICIOS"(id_servicio) NOT VALID;


ALTER TABLE gestion_hotel."EMPLEADOS"
    ADD CONSTRAINT sucursal FOREIGN KEY (id_sucursal) REFERENCES gestion_hotel."SUCURSALES"(id_sucursal) NOT VALID;



ALTER TABLE gestion_hotel."ESTACIONAMIENTOS"
    ADD CONSTRAINT sucursal FOREIGN KEY (id_sucursal) REFERENCES gestion_hotel."SUCURSALES"(id_sucursal) NOT VALID;


ALTER TABLE gestion_hotel."FACTURAS"
    ADD CONSTRAINT sucursal FOREIGN KEY (id_sucursal) REFERENCES gestion_hotel."SUCURSALES"(id_sucursal) NOT VALID;


ALTER TABLE gestion_hotel."MANTENIMIENTOS"
    ADD CONSTRAINT sucursal FOREIGN KEY (id_sucursal) REFERENCES gestion_hotel."SUCURSALES"(id_sucursal) NOT VALID;


ALTER TABLE gestion_hotel."MOBILIARIOS"
    ADD CONSTRAINT sucursal FOREIGN KEY (id_sucursal) REFERENCES gestion_hotel."SUCURSALES"(id_sucursal) NOT VALID;


ALTER TABLE gestion_hotel."PAGOS"
    ADD CONSTRAINT sucursal FOREIGN KEY (id_sucursal) REFERENCES gestion_hotel."SUCURSALES"(id_sucursal) NOT VALID;


ALTER TABLE gestion_hotel."PROMOCIONES"
    ADD CONSTRAINT sucursal FOREIGN KEY (id_sucursal) REFERENCES gestion_hotel."SUCURSALES"(id_sucursal) NOT VALID;


ALTER TABLE gestion_hotel."PUESTOS"
    ADD CONSTRAINT sucursal FOREIGN KEY (id_sucursal) REFERENCES gestion_hotel."SUCURSALES"(id_sucursal) NOT VALID;


ALTER TABLE gestion_hotel."RESERVACIONES"
    ADD CONSTRAINT sucursal FOREIGN KEY (id_sucursal) REFERENCES gestion_hotel."SUCURSALES"(id_sucursal) NOT VALID;

ALTER TABLE gestion_hotel."SALON"
    ADD CONSTRAINT sucursal FOREIGN KEY (id_sucursal) REFERENCES gestion_hotel."SUCURSALES"(id_sucursal) NOT VALID;

ALTER TABLE gestion_hotel."SERVICIOS"
    ADD CONSTRAINT sucursal FOREIGN KEY (id_sucursal) REFERENCES gestion_hotel."SUCURSALES"(id_sucursal) NOT VALID;


ALTER TABLE gestion_hotel."TRANSPORTE_EMPLEADOS"
    ADD CONSTRAINT sucursal FOREIGN KEY (id_sucursal) REFERENCES gestion_hotel."SUCURSALES"(id_sucursal) NOT VALID;


ALTER TABLE gestion_hotel."AREAS"
    ADD CONSTRAINT sucursalarea FOREIGN KEY (id_sucursal) REFERENCES gestion_hotel."SUCURSALES"(id_sucursal) ON UPDATE CASCADE ON DELETE CASCADE NOT VALID;


ALTER TABLE gestion_hotel."MANTENIMIENTOS"
    ADD CONSTRAINT tipo FOREIGN KEY (id_tipo_mantenimiento) REFERENCES gestion_hotel."TIPO_MANTENIMIENTOS"(id_tipo_mantenimiento) NOT VALID;


ALTER TABLE gestion_hotel."TRANSPORTE_EMPLEADOS"
    ADD CONSTRAINT tipo FOREIGN KEY (id_tipo_transporte) REFERENCES gestion_hotel."TIPO_TRANSPORTE_EMPLEADOS"(id_tipo_transporte) NOT VALID;


ALTER TABLE gestion_hotel."TIPO_HABITACIONES"
    ADD CONSTRAINT tipocama FOREIGN KEY (id_tipo_cama) REFERENCES gestion_hotel."TIPO_CAMAS"(id_tipo_cama) NOT VALID;


ALTER TABLE gestion_hotel."HISTORIAL_PRECIO_HABITACIONES"
    ADD CONSTRAINT tipohabitacion FOREIGN KEY (id_tipo_habitacion) REFERENCES gestion_hotel."TIPO_HABITACIONES"(id_tipo_habitacion) NOT VALID;


ALTER TABLE gestion_hotel."DETALLE_TRANSPORTE"
    ADD CONSTRAINT transporte FOREIGN KEY (id_transporte_empleado) REFERENCES gestion_hotel."TRANSPORTE_EMPLEADOS"(id_transporte_empleado) NOT VALID;


-- Completed on 2025-10-10 17:52:16

--
-- PostgreSQL database dump complete
--

