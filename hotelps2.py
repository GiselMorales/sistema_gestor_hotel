"""
SISTEMA DE GESTIÓN HOTELERA
Versión: 2.0 
"""

import tkinter as tk
from tkinter import ttk, messagebox
from datetime import datetime, timedelta
import psycopg2
from psycopg2 import pool

# ============================================================================
# CONFIGURACIÓN 
# ============================================================================
class Config:
    """Configuración centralizada del sistema"""
    COLOR_PRIMARIO = "#1E3A8A"
    COLOR_SECUNDARIO = "#7593C3"
    COLOR_ACENTO = "#60A5FA"
    COLOR_CLARO = "#F8FAFC"
    COLOR_BLANCO = "#FFFFFF"
    COLOR_GRIS = "#64748B"
    COLOR_EXITO = "#8EC0AF"
    COLOR_ADVERTENCIA = "#F59E0B"
    COLOR_PELIGRO = "#EF4444"
    COLOR_TEXTO_OSCURO = "#1F2937"
    
    COLOR_BOTON_PRIMARIO = "#1E40AF"
    COLOR_BOTON_SECUNDARIO = "#C1DDF9"
    COLOR_BOTON_EXITO = "#F59E0B"
    COLOR_BOTON_PELIGRO = "#EF4444"
    
    FUENTE_PRINCIPAL = ("Segoe UI", 10)
    FUENTE_NEGRITA = ("Segoe UI", 10, "bold")
    FUENTE_TITULO = ("Segoe UI", 14, "bold")
    FUENTE_SUBTITULO = ("Segoe UI", 12, "bold")
    FUENTE_BOTON = ("Segoe UI", 10, "bold")
    
    DB_CONFIG = {
        "host": "localhost",
        "database": "ahotel",
        "user": "postgres",
        "password": "Yuliana2005",
        "port": "5432"
    }


# ============================================================================
# HELPER FUNCTIONS
# ============================================================================
class Helpers:
    """Funciones auxiliares reutilizables"""
    
    @staticmethod
    def formatear_fecha(fecha):
        """Formatea fecha para mostrar en UI"""
        if isinstance(fecha, str):
            return fecha
        elif hasattr(fecha, 'strftime'):
            return fecha.strftime('%Y-%m-%d')
        return str(fecha)
    
    @staticmethod
    def centrar_ventana(ventana, ancho=None, alto=None):
        """Centra una ventana en la pantalla"""
        ventana.update_idletasks()
        
        if ancho and alto:
            w, h = ancho, alto
        else:
            w = ventana.winfo_width()
            h = ventana.winfo_height()
        
        x = (ventana.winfo_screenwidth() // 2) - (w // 2)
        y = (ventana.winfo_screenheight() // 2) - (h // 2)
        ventana.geometry(f'{w}x{h}+{x}+{y}' if ancho else f'+{x}+{y}')
    
    @staticmethod
    def crear_boton_estilizado(parent, texto, comando=None, 
                               estilo="primario", ancho=None, 
                               padding_y=10, padding_x=20):
        """
        Crea un botón estilizado con buen contraste
        
        Estilos disponibles:
        - "primario": Botón azul oscuro con texto blanco
        - "secundario": Botón azul medio con texto blanco
        - "exito": Botón verde con texto blanco
        - "peligro": Botón rojo con texto blanco
        """
        configs = {
            "primario": {
                "bg": Config.COLOR_BOTON_PRIMARIO,
                "fg": Config.COLOR_BLANCO,
                "hover_bg": Config.COLOR_SECUNDARIO
            },
            "secundario": {
                "bg": Config.COLOR_BOTON_SECUNDARIO,
                "fg": Config.COLOR_BLANCO,
                "hover_bg": Config.COLOR_ACENTO
            },
            "exito": {
                "bg": Config.COLOR_BOTON_EXITO,
                "fg": Config.COLOR_BLANCO,
                "hover_bg": "#10B981"
            },
            "peligro": {
                "bg": Config.COLOR_BOTON_PELIGRO,
                "fg": Config.COLOR_BLANCO,
                "hover_bg": "#EF4444"
            }
        }
        
        config = configs.get(estilo, configs["primario"])
        
        boton = tk.Button(
            parent,
            text=texto,
            font=Config.FUENTE_BOTON,
            bg=config["bg"],
            fg=config["fg"],
            relief="flat",
            padx=padding_x,
            pady=padding_y,
            cursor="hand2",
            command=comando
        )
        
        if ancho:
            boton.config(width=ancho)
        
        def on_enter(e):
            boton.config(bg=config.get("hover_bg", config["bg"]))
        
        def on_leave(e):
            boton.config(bg=config["bg"])
        
        boton.bind("<Enter>", on_enter)
        boton.bind("<Leave>", on_leave)
        
        return boton


# ============================================================================
# CLASE DE CONEXIÓN A BASE DE DATOS (ORIGINAL)
# ============================================================================
class GestorBaseDatos:
    def __init__(self):
        self.pool_conexiones = None
        self.configurar_conexion()
    
    def configurar_conexion(self):
        """Configura la conexión a PostgreSQL"""
        try:
            self.pool_conexiones = psycopg2.pool.SimpleConnectionPool(
                1, 10,
                host="localhost",
                database="ahotel",
                user="postgres",
                password="Yuliana2005",
                port="5432"
            )
            print("Conexión a PostgreSQL establecida")
            return True
        except Exception as e:
            print(f"Error de conexión: {e}")
            return False
        
    def ejecutar_funcion_postgresql(self, nombre_funcion, parametros=None, esquema="gestion_hotel"):
        """
        Ejecuta CUALQUIER función PostgreSQL y retorna resultados
        
        Args:
            nombre_funcion: Nombre de la función 
            parametros: Lista/tupla de parámetros
            esquema: Esquema donde está la función
        
        Returns:
            Lista de diccionarios con los resultados
        """
        try:
            conexion = self.pool_conexiones.getconn()
            cursor = conexion.cursor()
            
            funcion_completa = f"{esquema}.{nombre_funcion}" if esquema else nombre_funcion
            
            if parametros:
                placeholders = ', '.join(['%s'] * len(parametros))
                query = f"SELECT * FROM {funcion_completa}({placeholders})"
                cursor.execute(query, parametros)
            else:
                query = f"SELECT * FROM {funcion_completa}()"
                cursor.execute(query)
            
            resultados = cursor.fetchall()
            
            if cursor.description:
                columnas = [desc[0] for desc in cursor.description]
            else:
                columnas = []
            
            datos = []
            for fila in resultados:
                item = {}
                for i, columna in enumerate(columnas):
                    item[columna] = fila[i]
                datos.append(item)
            
            cursor.close()
            self.pool_conexiones.putconn(conexion)
            
            return datos
            
        except Exception as e:
            print(f"❌ Error ejecutando función {nombre_funcion}: {e}")
            if 'conexion' in locals():
                self.pool_conexiones.putconn(conexion)
            return []

    def buscar_habitaciones_disponibles_bd(self, fecha_inicio, fecha_fin, id_sucursal=None):
        """Llama a la función PostgreSQL para buscar habitaciones disponibles"""
        if id_sucursal:
            return self.ejecutar_funcion_postgresql(
                'buscar_habitaciones_disponibles',
                [fecha_inicio, fecha_fin, id_sucursal]
            )
        else:
            return self.ejecutar_funcion_postgresql(
                'buscar_habitaciones_disponibles',
                [fecha_inicio, fecha_fin]
            )
        
    def obtener_conexion(self):
        """Obtiene una conexión del pool"""
        if self.pool_conexiones:
            try:
                return self.pool_conexiones.getconn()
            except:
                return None
        return None
    
    def devolver_conexion(self, conexion):
        """Devuelve conexión al pool"""
        if self.pool_conexiones and conexion:
            try:
                self.pool_conexiones.putconn(conexion)
            except:
                pass
    
    def ejecutar_consulta(self, consulta, parametros=None, obtener_resultados=True):
        """Ejecuta una consulta SQL"""
        conexion = self.obtener_conexion()
        if not conexion:
            return None
            
        try:
            with conexion.cursor() as cursor:
                cursor.execute(consulta, parametros or ())
                if obtener_resultados:
                    columnas = [desc[0] for desc in cursor.description]
                    filas = cursor.fetchall()
                    conexion.commit()
                    return [dict(zip(columnas, fila)) for fila in filas]

                conexion.commit()
                return True
        except Exception as e:
            print(f" Error en consulta: {e}")
            conexion.rollback()
            return None
        finally:
            self.devolver_conexion(conexion)

    def buscar_reserva_por_id(self, id_reserva):
        """
        Busca una reserva por ID usando la función PostgreSQL
        """
        try:
            resultados = self.ejecutar_funcion_postgresql(
                'buscar_reserva_por_id',
                [id_reserva]
            )
            return resultados
        except Exception as e:
            print(f"❌ Error en buscar_reserva_por_id: {e}")
            return []
        
    def verificar_login(self, usuario, contrasena):
        """Verifica credenciales de usuario contra PostgreSQL"""
        try:
            conn = psycopg2.connect(
                host="localhost",
                database="ahotel",
                user=usuario,
                password=contrasena,
                port="5432"
            )
            conn.close()
            
            # Usuario aceptado 
            return [{
                'nombre': usuario.capitalize(),
                'apellido_paterno': 'PG',
                'apellido_materno': 'User',
                'numero_tarjeta': 1001,
                'rol': 'recepcionista'
            }]
        except:
            return None
        
    # ========== FUNCIONES ESPECÍFICAS  ==========
    def registrar_bitacora(self, modulo, accion, descripcion):
        """Registra un movimiento en la bitácora del sistema"""
        try:
            # Obtener usuario actual
            usuario = "Sistema"
            if hasattr(self, 'usuario') and self.usuario:
                usuario = self.usuario.get('nombre', 'Sistema')
        
        # Consulta SQL
            consulta = """
            INSERT INTO gestion_hotel.bitacora_sistema 
            (modulo, accion, descripcion, usuario)
            VALUES (%s, %s, %s, %s)
            """
        
            # Ejecutar
            resultado = self.ejecutar_consulta(
                consulta, 
                [modulo, accion, descripcion, usuario],
                obtener_resultados=False
            )
            
        except Exception as e:
            print(f"Error al registrar en bitácora: {e}")
        
        return False
    
    def obtener_clientes(self):
        """Obtiene todos los clientes"""
        consulta = """
        SELECT id_clientes, nombre, apellido_paterno, apellido_materno, 
               rfc_cliente, curp, genero, id_ciudad
        FROM gestion_hotel."CLIENTES"
        ORDER BY apellido_paterno, nombre
        LIMIT 1000
        """
        return self.ejecutar_consulta(consulta)
    
    def buscar_cliente_por_id(self, id_cliente):
        """Busca un cliente por ID"""
        consulta = """
        SELECT * FROM gestion_hotel."CLIENTES"
        WHERE id_clientes = %s AND nombre != 'ELIMINADO'
        """
        resultado = self.ejecutar_consulta(consulta, (id_cliente,))
        return resultado[0] if resultado else None
    
    def insertar_cliente(self, datos):
        """Inserta un nuevo cliente"""
        consulta = """
        INSERT INTO gestion_hotel."CLIENTES" 
        (nombre, apellido_paterno, apellido_materno, calle, colonia, 
         codigo_postal, rfc_cliente, curp, id_ciudad, genero)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        RETURNING id_clientes
        """
        parametros = (
            datos['nombre'],
            datos['apellido_paterno'],
            datos['apellido_materno'],
            datos.get('calle', ''),
            datos.get('colonia', ''),
            datos.get('codigo_postal', '00000'),
            datos['rfc_cliente'],
            datos['curp'],
            datos.get('id_ciudad', 1),
            datos.get('genero', 'M')
        )

        resultado = self.ejecutar_consulta(
            consulta,
            parametros,
            obtener_resultados=True
        )
       
        if resultado:
            id_cliente = resultado[0]['id_clientes']

            self.registrar_bitacora(
                modulo="CLIENTES",
                accion="INSERT",
                descripcion=f"Alta de cliente ID {id_cliente}"
            )

            return id_cliente

        return None

    
    def actualizar_cliente(self, id_cliente, datos):
        """Actualiza un cliente existente"""
        consulta = """
        UPDATE gestion_hotel."CLIENTES" 
        SET nombre = %s, apellido_paterno = %s, apellido_materno = %s,
            calle = %s, colonia = %s, codigo_postal = %s,
            rfc_cliente = %s, curp = %s, id_ciudad = %s, genero = %s
        WHERE id_clientes = %s
        """
        parametros = (
            datos['nombre'], datos['apellido_paterno'], datos['apellido_materno'],
            datos.get('calle'), datos.get('colonia'), datos.get('codigo_postal'),
            datos['rfc_cliente'], datos['curp'], datos.get('id_ciudad'), datos.get('genero'),
            id_cliente
        )
        resultado = self.ejecutar_consulta(
            consulta,
            parametros,
            obtener_resultados=False
        )

        if resultado:
            self.registrar_bitacora(
                modulo="CLIENTES",
                accion="UPDATE",
                descripcion=f"Actualización de cliente ID {id_cliente}"
            )
            return True


        return False
    
    def eliminar_cliente(self, id_cliente):
        """Elimina un cliente"""
        consulta = """
        UPDATE gestion_hotel."CLIENTES" 
        SET nombre = 'ELIMINADO', rfc_cliente = 'ELIMINADO', curp = 'ELIMINADO'
        WHERE id_clientes = %s
        """
        resultado = self.ejecutar_consulta(
            consulta,
            (id_cliente,),
            obtener_resultados=False
        )

        if resultado:
            self.registrar_bitacora(
                modulo="CLIENTES",
                accion="DELETE",
                descripcion=f"Eliminación lógica de cliente ID {id_cliente}"
            )
            return True
        return self.ejecutar_consulta(consulta, (id_cliente,), obtener_resultados=False)
    
    def obtener_reservas(self):
        """Obtiene todas las reservas"""
        consulta = """
        SELECT r.id_reservacion, 
               c.nombre || ' ' || c.apellido_paterno as cliente,
               r.fecha_check_in, r.fecha_check_out, 
               h.numero_habitacion, er.tipo_estado_reservacion as estado,
               r.id_clientes, r.id_sucursal
        FROM gestion_hotel."RESERVACIONES" r
        JOIN gestion_hotel."CLIENTES" c ON r.id_clientes = c.id_clientes
        LEFT JOIN gestion_hotel."DETALLES_RESERVAS" dr ON r.id_reservacion = dr.id_reservacion
        LEFT JOIN gestion_hotel."HABITACIONES" h ON dr.numero_habitacion = h.numero_habitacion
        LEFT JOIN gestion_hotel."ESTADO_RESERVACION" er ON r.id_estado_reservacion = er.id_estado_reservacion
        WHERE c.nombre != 'ELIMINADO'
        ORDER BY r.fecha_check_in DESC
        LIMIT 50
        """
        return self.ejecutar_consulta(consulta)
    
    def obtener_habitaciones_disponibles(self, fecha_inicio, fecha_fin):
        """Busca habitaciones disponibles"""
        consulta = """
        SELECT DISTINCT h.numero_habitacion, h.descripcion, h.piso, h.id_sucursal,
               th.nombre_tipo_habitacion as tipo, th.precio
        FROM gestion_hotel."HABITACIONES" h
        JOIN gestion_hotel."TIPO_HABITACIONES" th ON h.id_tipo_habitacion = th.id_tipo_habitacion
        WHERE h.id_estado_habitacion = 1
        AND NOT EXISTS (
            SELECT 1 
            FROM gestion_hotel."DETALLES_RESERVAS" dr
            JOIN gestion_hotel."RESERVACIONES" r ON dr.id_reservacion = r.id_reservacion
            WHERE dr.numero_habitacion = h.numero_habitacion
            AND r.id_estado_reservacion IN (1, 2)
            AND (
                (r.fecha_check_in <= %s AND r.fecha_check_out >= %s)
            )
        )
        ORDER BY th.precio, h.piso
        """
        return self.ejecutar_consulta(consulta, (fecha_fin, fecha_inicio))
    
    def crear_reserva_completa(self, datos_reserva):
        """Ejecuta el PROCEDURE PostgreSQL para crear reserva completa"""
        try:
            conn = self.pool_conexiones.getconn()
            cursor = conn.cursor()
            
            # Llamar al PROCEDURE
            sql = """
            CALL gestion_hotel.crear_reserva_completa_simple(
                %s, %s, %s, %s, %s, %s
            )
            """
            
            cursor.execute(sql, [
                datos_reserva['id_cliente'],
                datos_reserva['id_sucursal'],
                datos_reserva['fecha_inicio'],
                datos_reserva['fecha_fin'],
                datos_reserva.get('numero_tarjeta_empleado', 19),
                datos_reserva['numero_habitacion'],
            ])
            
            conn.commit()
            
            # Obtener el último ID
            cursor.execute("SELECT lastval()")
            id_reserva = cursor.fetchone()[0]

            return id_reserva
            
        except Exception as e:
            print(f"Error en crear_reserva_completa: {e}")
            if 'conn' in locals():
                conn.rollback()
            return None
        
        finally:
            if cursor:
                cursor.close()
            if conn:
                self.pool_conexiones.putconn(conn)
                
    def actualizar_reserva(self, id_reserva, datos):
        """Actualiza una reserva usando el PROCEDURE con bitácora"""
        try:
            # Obtener conexión
            conn = self.pool_conexiones.getconn()
            cursor = conn.cursor()
        
            # Llamar al PROCEDURE de PostgreSQL
            sql = """
            CALL gestion_hotel.actualizar_reserva(
                %s,  -- p_id_reservacion
                %s,  -- p_fecha_check_in
                %s,  -- p_fecha_check_out
                %s,  -- p_id_sucursal
                %s,  -- p_numero_tarjeta_empleado
                %s   -- p_numero_habitacion_nuevo
            )
            """
        
            # Parámetros para el procedure
            params = [
                id_reserva,
                datos['fecha_inicio'],         
                datos['fecha_fin'],           
                datos['id_sucursal'],         
                datos['id_empleado'],         
                datos['numero_habitacion']    
            ]   
        
        # Ejecutar el procedure
            cursor.execute(sql, params)
        
        # Confirmar cambios
            conn.commit()
        
        # Cerrar cursor y devolver conexión
            cursor.close()
            self.pool_conexiones.putconn(conn)
        
        
        except Exception as e:
        
        # Revertir cambios si hubo error
            if 'conn' in locals():
                try:
                    conn.rollback()
                except:
                    pass
                finally:
                        self.pool_conexiones.putconn(conn)
        
            return False
    
    def eliminar_reserva(self, id_reserva):
        """Elimina una reserva"""
        conexion = self.obtener_conexion()
        if not conexion:
            return False
            
        try:
            with conexion.cursor() as cursor:
                # Obtener habitación para liberarla
                cursor.execute("""
                    SELECT numero_habitacion 
                    FROM gestion_hotel."DETALLES_RESERVAS"
                    WHERE id_reservacion = %s
                """, (id_reserva,))
                
                habitacion = cursor.fetchone()
                if habitacion:
                    # Liberar habitación
                    cursor.execute("""
                        UPDATE gestion_hotel."HABITACIONES"
                        SET id_estado_habitacion = 1
                        WHERE numero_habitacion = %s
                    """, (habitacion[0],))
                
                # Eliminar detalle de reserva
                cursor.execute("""
                    DELETE FROM gestion_hotel."DETALLES_RESERVAS"
                    WHERE id_reservacion = %s
                """, (id_reserva,))
                
                # Eliminar reserva
                cursor.execute("""
                    DELETE FROM gestion_hotel."RESERVACIONES"
                    WHERE id_reservacion = %s
                """, (id_reserva,))
                
                conexion.commit()
                self.registrar_bitacora(
                    modulo="RESERVAS",
                    accion="DELETE",
                    descripcion=f"Eliminacion de reserva ID {id_reserva}"
                )
                return True
                
        except Exception as e:
            print(f"Error al eliminar reserva: {e}")
            conexion.rollback()
            return False
        finally:
            self.devolver_conexion(conexion)


# ============================================================================
# VENTANA DE LOGIN
# ============================================================================
class VentanaLogin:
    def __init__(self):
        self.ventana = tk.Tk()
        self.ventana.title("🏨 Sistema Hotelero - Acceso")
        self.ventana.geometry("500x600")
        self.ventana.configure(bg=Config.COLOR_CLARO)
        self.ventana.resizable(False, False)
        
        try:
            self.ventana.iconbitmap("hotel.ico")
        except:
            pass
        
        self.bd = GestorBaseDatos()
        self.usuario_autenticado = None
        self.crear_interfaz()
        Helpers.centrar_ventana(self.ventana, 500, 600)
    
    def crear_interfaz(self):
        """Crea la interfaz de login"""
        frame_principal = tk.Frame(
            self.ventana, 
            bg=Config.COLOR_BLANCO,
            relief="flat",
            borderwidth=0
        )
        frame_principal.pack(expand=True, fill='both', padx=20, pady=20)
        
        frame_logo = tk.Frame(frame_principal, bg=Config.COLOR_BLANCO)
        frame_logo.pack(pady=(20, 30))
        
        tk.Label(
            frame_logo, 
            text="🏨", 
            font=("Arial", 42), 
            bg=Config.COLOR_BLANCO, 
            fg=Config.COLOR_PRIMARIO
        ).pack()
        
        tk.Label(
            frame_logo, 
            text="TECNO-CHICAS", 
            font=("Segoe UI", 20, "bold"), 
            bg=Config.COLOR_BLANCO, 
            fg=Config.COLOR_PRIMARIO
        ).pack(pady=(10, 0))
        
        tk.Label(
            frame_logo, 
            text="Hotel", 
            font=("Segoe UI", 14), 
            bg=Config.COLOR_BLANCO, 
            fg=Config.COLOR_GRIS
        ).pack()
        
        frame_formulario = tk.Frame(frame_principal, bg=Config.COLOR_BLANCO)
        frame_formulario.pack(pady=20, padx=40, fill='x')
        
        tk.Label(
            frame_formulario, 
            text="Usuario:", 
            font=Config.FUENTE_NEGRITA,
            bg=Config.COLOR_BLANCO, 
            fg=Config.COLOR_TEXTO_OSCURO,
            anchor='w'
        ).pack(fill='x', pady=(10, 5))
        
        self.entrada_usuario = ttk.Entry(
            frame_formulario, 
            font=Config.FUENTE_PRINCIPAL
        )
        self.entrada_usuario.pack(fill='x', ipady=8, pady=(0, 10))
        self.entrada_usuario.insert(0, "")
       
        tk.Label(
            frame_formulario, 
            text="Contraseña:", 
            font=Config.FUENTE_NEGRITA,
            bg=Config.COLOR_BLANCO, 
            fg=Config.COLOR_TEXTO_OSCURO,
            anchor='w'
        ).pack(fill='x', pady=(10, 5))
        
        self.entrada_contrasena = ttk.Entry(
            frame_formulario, 
            font=Config.FUENTE_PRINCIPAL, 
            show="•"
        )
        self.entrada_contrasena.pack(fill='x', ipady=8, pady=(0, 10))
        self.entrada_contrasena.insert(0, "")
       
        frame_boton = tk.Frame(frame_formulario, bg=Config.COLOR_BLANCO)
        frame_boton.pack(fill='x', pady=(5, 2))
        
        boton_login = Helpers.crear_boton_estilizado(
            frame_boton,
            texto="INGRESAR AL SISTEMA",
            comando=self.verificar_credenciales,
            estilo="primario",
            padding_y=10
        )
        boton_login.pack(fill='x', ipady=10)

        frame_pie = tk.Frame(frame_principal, bg=Config.COLOR_BLANCO)
        frame_pie.pack(fill='x', pady=(20, 0))
        
        tk.Label(
            frame_pie, 
            text="© 2025 Sistema Hotelero v2.0", 
            font=("Segoe UI", 9),
            bg=Config.COLOR_BLANCO, 
            fg=Config.COLOR_GRIS
        ).pack()
    
    def verificar_credenciales(self):
        """Verifica las credenciales del usuario"""
        usuario = self.entrada_usuario.get().strip()
        contrasena = self.entrada_contrasena.get().strip()
        
        if not usuario or not contrasena:
            messagebox.showerror("Error", "Por favor complete todos los campos")
            return
        
        resultado = self.bd.verificar_login(usuario, contrasena)
        
        if resultado:
            self.usuario_autenticado = resultado[0]
            self.ventana.destroy()
            app = AplicacionPrincipal(self.usuario_autenticado)
            app.iniciar()
        else:
            messagebox.showerror("Error", "Credenciales incorrectas")


# ============================================================================
# APLICACIÓN PRINCIPAL
# ============================================================================
class AplicacionPrincipal:
    def __init__(self, usuario):
        self.usuario = usuario
        self.bd = GestorBaseDatos()
        self.ventana = None
        self.helpers = Helpers()
        
        self.fecha_hoy = datetime.now().strftime('%Y-%m-%d')
        self.fecha_manana = (datetime.now() + timedelta(days=1)).strftime('%Y-%m-%d')
    
    def iniciar(self):
        """Inicia la aplicación principal"""
        self.ventana = tk.Tk()
        self.ventana.title(f"🏨 Sistema Hotelero - Recepcionista: {self.usuario['nombre']}")
        self.ventana.geometry("1300x750")
        self.ventana.configure(bg=Config.COLOR_CLARO)
        self.ventana.minsize(1200, 700)
        
        try:
            self.ventana.iconbitmap("hotel.ico")
        except:
            pass
        
        self.configurar_estilos()
        self.crear_interfaz()
        self.mostrar_dashboard()
        
        self.helpers.centrar_ventana(self.ventana, 1300, 750)
        self.ventana.protocol("WM_DELETE_WINDOW", self.cerrar_sesion)
        
        self.ventana.mainloop()
    
    def configurar_estilos(self):
        """Configura los estilos de ttk"""
        estilo = ttk.Style()
        estilo.theme_use('clam')
        
        estilo.configure(
            "Treeview",
            background=Config.COLOR_BLANCO,
            foreground=Config.COLOR_TEXTO_OSCURO,
            rowheight=28,
            fieldbackground=Config.COLOR_BLANCO,
            borderwidth=1,
            relief="flat"
        )
        
        estilo.configure(
            "Treeview.Heading",
            background=Config.COLOR_PRIMARIO,
            foreground=Config.COLOR_BLANCO,
            font=Config.FUENTE_NEGRITA,
            relief="flat",
            padding=5
        )
        
        estilo.map(
            "Treeview",
            background=[('selected', Config.COLOR_ACENTO)],
            foreground=[('selected', Config.COLOR_BLANCO)]
        )
        
        estilo.configure(
            "TButton",
            font=Config.FUENTE_BOTON,
            padding=10,
            relief="flat"
        )
    
    def crear_interfaz(self):
        """Crea la interfaz principal"""
        self.frame_principal = tk.Frame(self.ventana, bg=Config.COLOR_CLARO)
        self.frame_principal.pack(fill='both', expand=True)
        
        # ========== BARRA SUPERIOR ==========
        barra_superior = tk.Frame(
            self.frame_principal, 
            bg=Config.COLOR_PRIMARIO, 
            height=70
        )
        barra_superior.pack(fill='x')
        barra_superior.pack_propagate(False)
        
        frame_titulo = tk.Frame(barra_superior, bg=Config.COLOR_PRIMARIO)
        frame_titulo.pack(side='left', padx=25)
        
        tk.Label(
            frame_titulo, 
            text="🏨", 
            font=("Arial", 28), 
            bg=Config.COLOR_PRIMARIO, 
            fg=Config.COLOR_BLANCO
        ).pack(side='left', padx=(0, 10))
        
        tk.Label(
            frame_titulo, 
            text="TECNO-CHICAS", 
            font=("Segoe UI", 18, "bold"), 
            bg=Config.COLOR_PRIMARIO, 
            fg=Config.COLOR_BLANCO
        ).pack(side='left')
        
        frame_usuario = tk.Frame(barra_superior, bg=Config.COLOR_PRIMARIO)
        frame_usuario.pack(side='right', padx=25)
        
        tk.Label(
            frame_usuario,
            text=f"👤 {self.usuario['nombre']} {self.usuario.get('apellido_paterno', '')} | Recepcionista",
            font=Config.FUENTE_NEGRITA,
            bg=Config.COLOR_PRIMARIO,
            fg=Config.COLOR_BLANCO
        ).pack(side='left', padx=(0, 20))
        
        boton_salir = Helpers.crear_boton_estilizado(
            frame_usuario,
            texto="Salir",
            comando=self.cerrar_sesion,
            estilo="peligro",
            padding_y=8,
            padding_x=15
        )
        boton_salir.pack(side='left')
        
        # ========== BARRA LATERAL ==========
        self.barra_lateral = tk.Frame(
            self.frame_principal, 
            bg=Config.COLOR_BLANCO, 
            width=250
        )
        self.barra_lateral.pack(side='left', fill='y')
        self.barra_lateral.pack_propagate(False)
        
        frame_menu = tk.Frame(self.barra_lateral, bg=Config.COLOR_BLANCO)
        frame_menu.pack(fill='x', padx=20, pady=25)
        
        tk.Label(
            frame_menu, 
            text="📋 MENÚ PRINCIPAL", 
            font=("Segoe UI", 12, "bold"),
            bg=Config.COLOR_BLANCO, 
            fg=Config.COLOR_PRIMARIO
        ).pack(anchor='w', pady=(0, 20))
        
        opciones_menu = [
            ("📊 Dashboard", self.mostrar_dashboard, "primario"),
            ("👥 Gestionar Clientes", self.mostrar_clientes, "secundario"),
            ("📅 Gestionar Reservas", self.mostrar_reservas, "secundario"),
            ("🛌 Habitaciones", self.mostrar_habitaciones, "secundario")
        ]
        
        for texto, comando, estilo_boton in opciones_menu:
            boton = Helpers.crear_boton_estilizado(
                frame_menu,
                texto=texto,
                comando=comando,
                estilo=estilo_boton,
                ancho=20,
                padding_y=12,
                padding_x=15
            )
            boton.pack(fill='x', pady=6, ipady=10)
        
        tk.Frame(
            self.barra_lateral, 
            bg=Config.COLOR_CLARO, 
            height=2
        ).pack(fill='x', pady=30)
        
        frame_info = tk.Frame(self.barra_lateral, bg=Config.COLOR_BLANCO)
        frame_info.pack(fill='x', padx=20, pady=10)
        
        tk.Label(
            frame_info, 
            text="🏨 Sistema Hotelero", 
            font=("Segoe UI", 10, "bold"),
            bg=Config.COLOR_BLANCO, 
            fg=Config.COLOR_PRIMARIO
        ).pack(anchor='w', pady=(0, 5))
        
        tk.Label(
            frame_info, 
            text="Módulo de Recepción", 
            font=("Segoe UI", 9),
            bg=Config.COLOR_BLANCO, 
            fg=Config.COLOR_GRIS
        ).pack(anchor='w')
        
        # ========== CONTENIDO PRINCIPAL ==========
        self.contenido_principal = tk.Frame(
            self.frame_principal, 
            bg=Config.COLOR_CLARO
        )
        self.contenido_principal.pack(
            side='right', 
            fill='both', 
            expand=True, 
            padx=25, 
            pady=25
        )
    
    def limpiar_contenido(self):
        """Limpia el área de contenido principal"""
        for widget in self.contenido_principal.winfo_children():
            widget.destroy()
    
    # ========== MÉTODOS DE SECCIONES ==========
    
    def mostrar_dashboard(self):
        """Muestra el dashboard principal"""
        self.limpiar_contenido()
        
        frame_titulo = tk.Frame(self.contenido_principal, bg=Config.COLOR_CLARO)
        frame_titulo.pack(fill='x', pady=(0, 25))
        
        tk.Label(
            frame_titulo, 
            text="📊 Dashboard Principal", 
            font=Config.FUENTE_TITULO,
            bg=Config.COLOR_CLARO, 
            fg=Config.COLOR_PRIMARIO
        ).pack(anchor='w')
        
        tk.Label(
            frame_titulo, 
            text="Resumen y estadísticas del sistema hotelero",
            font=Config.FUENTE_PRINCIPAL,
            bg=Config.COLOR_CLARO, 
            fg=Config.COLOR_GRIS
        ).pack(anchor='w')
        
        # Tarjetas de resumen
        frame_tarjetas = tk.Frame(self.contenido_principal, bg=Config.COLOR_CLARO)
        frame_tarjetas.pack(fill='x', pady=(0, 30))
        
        # Obtener datos básicos
        clientes = self.bd.obtener_clientes() or []
        reservas = self.bd.obtener_reservas() or []
        
        tarjetas_info = [
            ("👥 Clientes Activos", len(clientes), Config.COLOR_PRIMARIO),
            ("📅 Reservas Activas", len([r for r in reservas if r['estado'] in ['Confirmada', 'En curso']]), Config.COLOR_SECUNDARIO),
            ("🛌 Hab. Disponibles", "Consultar", Config.COLOR_ADVERTENCIA),
            ("💰 Ingresos Hoy", "$0.00", Config.COLOR_EXITO)
        ]
        
        for i, (titulo, valor, color) in enumerate(tarjetas_info):
            frame_tarjeta = tk.Frame(
                frame_tarjetas, 
                bg=Config.COLOR_BLANCO,
                relief="flat",
                borderwidth=1
            )
            frame_tarjeta.grid(row=0, column=i, padx=10, sticky='nsew')
            frame_tarjetas.columnconfigure(i, weight=1)
            
            tk.Label(
                frame_tarjeta, 
                text=titulo, 
                font=Config.FUENTE_PRINCIPAL,
                bg=Config.COLOR_BLANCO, 
                fg=Config.COLOR_GRIS
            ).pack(anchor='w', padx=15, pady=(15, 5))
            
            tk.Label(
                frame_tarjeta, 
                text=str(valor), 
                font=("Segoe UI", 28, "bold"),
                bg=Config.COLOR_BLANCO, 
                fg=color
            ).pack(padx=15, pady=(0, 15))
        
        # Acciones rápidas
        frame_acciones = tk.Frame(self.contenido_principal, bg=Config.COLOR_CLARO)
        frame_acciones.pack(fill='x', pady=(0, 25))
        
        tk.Label(
            frame_acciones, 
            text="🚀 Acciones Rápidas", 
            font=Config.FUENTE_SUBTITULO,
            bg=Config.COLOR_CLARO, 
            fg=Config.COLOR_PRIMARIO
        ).pack(anchor='w', pady=(0, 15))
        
        frame_botones_acciones = tk.Frame(frame_acciones, bg=Config.COLOR_CLARO)
        frame_botones_acciones.pack(fill='x')
        
        acciones = [
            ("➕ Nuevo Cliente", self.mostrar_formulario_cliente, "primario"),
            ("📅 Nueva Reserva", self.mostrar_formulario_reserva, "exito"),
            ("🔍 Buscar Habitaciones", self.mostrar_habitaciones, "secundario"),
            ("📊 Ver Reportes", self.mostrar_reportes, "secundario")
        ]
        
        for texto, comando, estilo in acciones:
            boton = Helpers.crear_boton_estilizado(
                frame_botones_acciones,
                texto=texto,
                comando=comando,
                estilo=estilo,
                padding_y=10,
                padding_x=15
            )
            boton.pack(side='left', padx=(0, 10))
        
        # Últimas reservas
        frame_reservas = tk.Frame(self.contenido_principal, bg=Config.COLOR_CLARO)
        frame_reservas.pack(fill='both', expand=True)
        
        tk.Label(
            frame_reservas, 
            text="📋 Últimas Reservas", 
            font=Config.FUENTE_SUBTITULO,
            bg=Config.COLOR_CLARO, 
            fg=Config.COLOR_PRIMARIO
        ).pack(anchor='w', pady=(0, 15))
        
        columnas = ('ID', 'Cliente', 'Check-in', 'Check-out', 'Habitación', 'Estado')
        
        frame_tabla = tk.Frame(frame_reservas, bg=Config.COLOR_CLARO)
        frame_tabla.pack(fill='both', expand=True)
        
        tree = ttk.Treeview(frame_tabla, columns=columnas, show='headings', height=10)
        
        anchos = [80, 200, 120, 120, 100, 120]
        for col, ancho in zip(columnas, anchos):
            tree.heading(col, text=col)
            tree.column(col, width=ancho, anchor='center')
        
        scrollbar = ttk.Scrollbar(frame_tabla, orient='vertical', command=tree.yview)
        tree.configure(yscrollcommand=scrollbar.set)
        
        tree.pack(side='left', fill='both', expand=True)
        scrollbar.pack(side='right', fill='y')
        
        # Cargar datos
        if reservas:
            for reserva in reservas[:10]:
                fecha_in = self.helpers.formatear_fecha(reserva.get('fecha_check_in'))
                fecha_out = self.helpers.formatear_fecha(reserva.get('fecha_check_out'))
                
                tree.insert('', 'end', values=(
                    reserva.get('id_reservacion', ''),
                    reserva.get('cliente', ''),
                    fecha_in,
                    fecha_out,
                    reserva.get('numero_habitacion', 'N/A'),
                    reserva.get('estado', '')
                ))
    
    def mostrar_clientes(self):
        """Muestra la gestión de clientes"""
        self.limpiar_contenido()
        
        frame_superior = tk.Frame(self.contenido_principal, bg=Config.COLOR_CLARO)
        frame_superior.pack(fill='x', pady=(0, 20))
        
        tk.Label(
            frame_superior, 
            text="👥 Gestión de Clientes", 
            font=Config.FUENTE_TITULO,
            bg=Config.COLOR_CLARO, 
            fg=Config.COLOR_PRIMARIO
        ).pack(side='left')
        
        frame_botones_superiores = tk.Frame(frame_superior, bg=Config.COLOR_CLARO)
        frame_botones_superiores.pack(side='right')
        
        Helpers.crear_boton_estilizado(
            frame_botones_superiores,
            texto="➕ Nuevo Cliente",
            comando=self.mostrar_formulario_cliente,
            estilo="primario",
            padding_y=8,
            padding_x=15
        ).pack(side='left', padx=5)
        
        Helpers.crear_boton_estilizado(
            frame_botones_superiores,
            texto="🔄 Actualizar",
            comando=self.actualizar_tabla_clientes,
            estilo="secundario",
            padding_y=8,
            padding_x=15
        ).pack(side='left', padx=5)
        
        frame_busqueda = tk.Frame(self.contenido_principal, bg=Config.COLOR_CLARO)
        frame_busqueda.pack(fill='x', pady=(0, 15))
        
        tk.Label(
            frame_busqueda, 
            text="🔍 Buscar por ID:", 
            font=Config.FUENTE_PRINCIPAL,
            bg=Config.COLOR_CLARO, 
            fg=Config.COLOR_PRIMARIO
        ).pack(side='left', padx=(0, 10))
        
        self.entry_id_busqueda = ttk.Entry(frame_busqueda, width=15)
        self.entry_id_busqueda.pack(side='left', padx=(0, 10))
        self.entry_id_busqueda.bind('<Return>', lambda e: self.buscar_cliente_por_id_ui())
        
        Helpers.crear_boton_estilizado(
            frame_busqueda,
            texto="Buscar",
            comando=self.buscar_cliente_por_id_ui,
            estilo="secundario",
            padding_y=6,
            padding_x=12
        ).pack(side='left', padx=(0, 10))
        
        Helpers.crear_boton_estilizado(
            frame_busqueda,
            texto="Mostrar Todos",
            comando=self.actualizar_tabla_clientes,
            estilo="secundario",
            padding_y=6,
            padding_x=12
        ).pack(side='left')
     
        frame_tabla = tk.Frame(self.contenido_principal, bg=Config.COLOR_CLARO)
        frame_tabla.pack(fill='both', expand=True)
        
        columnas = ('ID', 'Nombre', 'Apellido Paterno', 'Apellido Materno', 'RFC', 'CURP', 'Género')
        
        self.tabla_clientes = ttk.Treeview(frame_tabla, columns=columnas, show='headings', height=15)
        
        anchos = [60, 150, 150, 150, 150, 180, 80]
        for col, ancho in zip(columnas, anchos):
            self.tabla_clientes.heading(col, text=col)
            self.tabla_clientes.column(col, width=ancho, minwidth=50, anchor='center')
        
        scrollbar = ttk.Scrollbar(frame_tabla, orient='vertical', command=self.tabla_clientes.yview)
        self.tabla_clientes.configure(yscrollcommand=scrollbar.set)
        
        self.tabla_clientes.pack(side='left', fill='both', expand=True)
        scrollbar.pack(side='right', fill='y')
        
        frame_acciones = tk.Frame(self.contenido_principal, bg=Config.COLOR_CLARO)
        frame_acciones.pack(fill='x', pady=(15, 0))
        
        Helpers.crear_boton_estilizado(
            frame_acciones,
            texto="✏️ Editar",
            comando=self.editar_cliente,
            estilo="secundario",
            padding_y=8,
            padding_x=15
        ).pack(side='left', padx=5)
        
        Helpers.crear_boton_estilizado(
            frame_acciones,
            texto="🗑️ Eliminar",
            comando=self.eliminar_cliente,
            estilo="peligro",
            padding_y=8,
            padding_x=15
        ).pack(side='left', padx=5)
        
        self.actualizar_tabla_clientes()
    
    def actualizar_tabla_clientes(self):
        """Actualiza la tabla de clientes"""
        for item in self.tabla_clientes.get_children():
            self.tabla_clientes.delete(item)
        
        clientes = self.bd.obtener_clientes()
        
        if clientes:
            for cliente in clientes:
                self.tabla_clientes.insert('', 'end', values=(
                    cliente['id_clientes'],
                    cliente['nombre'],
                    cliente['apellido_paterno'],
                    cliente['apellido_materno'],
                    cliente['rfc_cliente'],
                    cliente['curp'],
                    cliente['genero']
                ))
    
    def buscar_cliente_por_id_ui(self):
        """Busca cliente por ID desde la interfaz"""
        id_texto = self.entry_id_busqueda.get().strip()
    
        if not id_texto:
            messagebox.showwarning("Advertencia", "Por favor ingrese un ID para buscar")
            return
    
        try:
            id_cliente = int(id_texto)
        except ValueError:
            messagebox.showerror("Error", "El ID debe ser un número")
            return
    
        cliente = self.bd.buscar_cliente_por_id(id_cliente)
    
        if not cliente:
            messagebox.showinfo("Resultado", f"No se encontró cliente con ID: {id_cliente}")
            return
    
        for item in self.tabla_clientes.get_children():
            self.tabla_clientes.delete(item)
    
        self.tabla_clientes.insert('', 'end', values=(
            id_cliente,
            cliente['nombre'],
            cliente['apellido_paterno'],
            cliente['apellido_materno'],
            cliente['rfc_cliente'],
            cliente['curp'],
            cliente['genero']
        ))
    
        self.tabla_clientes.selection_set(self.tabla_clientes.get_children())
    
        messagebox.showinfo("Cliente Encontrado", 
                           f"✅ Cliente ID: {id_cliente}\n"
                           f"Nombre: {cliente['nombre']} {cliente['apellido_paterno']}")    

    def mostrar_formulario_cliente(self, id_cliente=None):
        """Muestra formulario para crear/editar cliente"""
        dialog = tk.Toplevel(self.ventana)
        dialog.title("Nuevo Cliente" if not id_cliente else "Editar Cliente")
        dialog.geometry("500x550")
        dialog.configure(bg=Config.COLOR_CLARO)
        dialog.transient(self.ventana)
        dialog.grab_set()
        self.helpers.centrar_ventana(dialog, 500, 550)
 
        frame_principal = tk.Frame(dialog, bg=Config.COLOR_BLANCO, padx=30, pady=30)
        frame_principal.pack(fill='both', expand=True)
        
        titulo = "➕ NUEVO CLIENTE" if not id_cliente else "✏️ EDITAR CLIENTE"
        tk.Label(frame_principal, text=titulo,
                font=Config.FUENTE_TITULO,
                bg=Config.COLOR_BLANCO, fg=Config.COLOR_PRIMARIO).grid(row=0, column=0, columnspan=2, pady=(0, 25), sticky='w')
        
        campos = [
            ("Nombre:", "nombre", True),
            ("Apellido Paterno:", "apellido_paterno", True),
            ("Apellido Materno:", "apellido_materno", False),
            ("Calle:", "calle", False),
            ("Colonia:", "colonia", False),
            ("Código Postal:", "codigo_postal", False),
            ("RFC:", "rfc_cliente", True),
            ("CURP:", "curp", True),
            ("Ciudad ID:", "id_ciudad", False),
            ("Género:", "genero", False)
        ]
        
        self.entradas_cliente = {}
        
        datos_cliente = None
        if id_cliente:
            datos_cliente = self.bd.buscar_cliente_por_id(id_cliente)
        
        for i, (etiqueta, campo, requerido) in enumerate(campos):
            tk.Label(frame_principal, text=etiqueta,
                    font=Config.FUENTE_PRINCIPAL,
                    bg=Config.COLOR_BLANCO, fg=Config.COLOR_PRIMARIO).grid(row=i+1, column=0, sticky='w', pady=8)
            
            if campo == 'genero':
                entrada = ttk.Combobox(frame_principal, values=['M', 'F'], state='readonly', width=27)
                entrada.set(datos_cliente[campo] if datos_cliente else 'M')
            else:
                entrada = ttk.Entry(frame_principal, width=30)
                if datos_cliente:
                    entrada.insert(0, datos_cliente[campo])
                elif campo == 'id_ciudad':
                    entrada.insert(0, '1')
            
            entrada.grid(row=i+1, column=1, pady=8, padx=(10, 0))
            self.entradas_cliente[campo] = entrada
        
        frame_botones = tk.Frame(frame_principal, bg=Config.COLOR_BLANCO)
        frame_botones.grid(row=len(campos)+2, column=0, columnspan=2, pady=30)
        
        def guardar():
            try:
                datos = {}
                for campo, entrada in self.entradas_cliente.items():
                    datos[campo] = entrada.get().strip()
                
                campos_requeridos = ['nombre', 'apellido_paterno', 'rfc_cliente', 'curp']
                for campo in campos_requeridos:
                    if not datos[campo]:
                        messagebox.showerror("Error", f"El campo {campo} es requerido")
                        return
                
                if not id_cliente:
                    nuevo_id = self.bd.insertar_cliente(datos)
                    if nuevo_id:
                        messagebox.showinfo("Éxito", f"✅ Cliente creado con ID: {nuevo_id}")
                        dialog.destroy()
                        self.actualizar_tabla_clientes()
                else:
                    if self.bd.actualizar_cliente(id_cliente, datos):
                        messagebox.showinfo("Éxito", "✅ Cliente actualizado correctamente")
                        dialog.destroy()
                        self.actualizar_tabla_clientes()
                        
            except Exception as e:
                messagebox.showerror("Error", f"❌ Error: {str(e)}")
        
        Helpers.crear_boton_estilizado(
            frame_botones,
            texto="💾 Guardar",
            comando=guardar,
            estilo="exito",
            padding_y=10,
            padding_x=20
        ).pack(side='left', padx=5)
        
        Helpers.crear_boton_estilizado(
            frame_botones,
            texto="❌ Cancelar",
            comando=dialog.destroy,
            estilo="peligro",
            padding_y=10,
            padding_x=20
        ).pack(side='left', padx=5)
    
    def editar_cliente(self):
        """Abre formulario para editar cliente seleccionado"""
        seleccion = self.tabla_clientes.selection()
        if not seleccion:
            messagebox.showwarning("Advertencia", "Seleccione un cliente para editar")
            return
        
        item = self.tabla_clientes.item(seleccion[0])
        id_cliente = item['values'][0]
        self.mostrar_formulario_cliente(id_cliente)
    
    def eliminar_cliente(self):
        """Elimina el cliente seleccionado"""
        seleccion = self.tabla_clientes.selection()
        if not seleccion:
            messagebox.showwarning("Advertencia", "Seleccione un cliente para eliminar")
            return
        
        item = self.tabla_clientes.item(seleccion[0])
        id_cliente = item['values'][0]
        nombre_cliente = item['values'][1]
        
        respuesta = messagebox.askyesno("Confirmar", 
                                       f"¿Está seguro de eliminar al cliente: {nombre_cliente}?\n\nEsta acción marcará al cliente como 'ELIMINADO' pero no borrará sus reservas históricas.")
        
        if respuesta:
            if self.bd.eliminar_cliente(id_cliente):
                messagebox.showinfo("Éxito", " Cliente eliminado correctamente")
                self.actualizar_tabla_clientes()
    
    def mostrar_reservas(self):
        """Muestra la gestión de reservas"""
        self.limpiar_contenido()
        
        frame_superior = tk.Frame(self.contenido_principal, bg=Config.COLOR_CLARO)
        frame_superior.pack(fill='x', pady=(0, 20))
        
        tk.Label(
            frame_superior, 
            text="📅 Gestión de Reservas", 
            font=Config.FUENTE_TITULO,
            bg=Config.COLOR_CLARO, 
            fg=Config.COLOR_PRIMARIO
        ).pack(side='left')
        
        frame_botones_superiores = tk.Frame(frame_superior, bg=Config.COLOR_CLARO)
        frame_botones_superiores.pack(side='right')
        
        Helpers.crear_boton_estilizado(
            frame_botones_superiores,
            texto="➕ Nueva Reserva",
            comando=self.mostrar_formulario_reserva,
            estilo="exito",
            padding_y=8,
            padding_x=15
        ).pack(side='left', padx=5)
        
        Helpers.crear_boton_estilizado(
            frame_botones_superiores,
            texto="🔄 Actualizar",
            comando=self.actualizar_tabla_reservas,
            estilo="secundario",
            padding_y=8,
            padding_x=15
        ).pack(side='left', padx=5)

        frame_busqueda = tk.Frame(self.contenido_principal, bg=Config.COLOR_CLARO)
        frame_busqueda.pack(fill='x', padx=20, pady=10)
    
        tk.Label(
            frame_busqueda, 
            text="Buscar por ID de Reserva:",
            font=("Arial", 10),
            bg=Config.COLOR_CLARO
        ).pack(side='left', padx=(0, 10))
    
        self.entry_buscar_reserva = tk.Entry(frame_busqueda, width=20)
        self.entry_buscar_reserva.pack(side='left', padx=(0, 10))
        self.entry_buscar_reserva.focus()

        Helpers.crear_boton_estilizado(
            frame_busqueda,
            texto="🔍 Buscar",
            comando=self.buscar_reserva_id,
            estilo="secundario",
            padding_y=6,
            padding_x=12
        ).pack(side='left')
    
        Helpers.crear_boton_estilizado(
            frame_busqueda,
            texto="📋 Ver Todas",
            comando=self.mostrar_todas_reservas,
            estilo="secundario",
            padding_y=6,
            padding_x=12
        ).pack(side='left', padx=10)
    
        self.entry_buscar_reserva.bind('<Return>', 
                                      lambda e: self.buscar_reserva_id())
        
        frame_tabla = tk.Frame(self.contenido_principal, bg=Config.COLOR_CLARO)
        frame_tabla.pack(fill='both', expand=True)
        
        columnas = ('ID', 'Cliente', 'Check-in', 'Check-out', 'Habitación', 'Estado')
        
        self.tabla_reservas = ttk.Treeview(frame_tabla, columns=columnas, show='headings', height=15)
        
        anchos = [80, 180, 100, 100, 90, 120]
        for col, ancho in zip(columnas, anchos):
            self.tabla_reservas.heading(col, text=col)
            self.tabla_reservas.column(col, width=ancho, anchor='center')
        
        scrollbar = ttk.Scrollbar(frame_tabla, orient='vertical', command=self.tabla_reservas.yview)
        self.tabla_reservas.configure(yscrollcommand=scrollbar.set)
        
        self.tabla_reservas.pack(side='left', fill='both', expand=True)
        scrollbar.pack(side='right', fill='y')

        frame_acciones = tk.Frame(self.contenido_principal, bg=Config.COLOR_CLARO)
        frame_acciones.pack(fill='x', padx=20, pady=10)
        
        botones = [
            ("✏️ Editar", self.editar_reserva),
            ("📋 Detalles", self.ver_detalles_reserva),
            ("🗑️ Eliminar", self.eliminar_reserva)
        ]
    
        for texto, comando in botones:
            Helpers.crear_boton_estilizado(
                frame_acciones,
                texto=texto,
                comando=comando,
                estilo="secundario",
                padding_y=8,
                padding_x=15
            ).pack(side='left', padx=5)
        
        self.actualizar_tabla_reservas()

    def buscar_reserva_id(self):
        """Busca una reserva por ID"""
        try:
            texto = self.entry_buscar_reserva.get().strip()
            
            if not texto:
                messagebox.showwarning("Campo vacío", "Ingresa un ID de reserva")
                return
        
            if not texto.isdigit():
                messagebox.showerror("Error", "El ID debe ser un número")
                return
            
            id_reserva = int(texto)
        
            reservas = self.bd.buscar_reserva_por_id(id_reserva)
            
            if reservas:
                for item in self.tabla_reservas.get_children():
                    self.tabla_reservas.delete(item)
                
                for reserva in reservas:
                    fecha_in = self.helpers.formatear_fecha(reserva.get('fecha_check_in'))
                    fecha_out = self.helpers.formatear_fecha(reserva.get('fecha_check_out'))
                
                    self.tabla_reservas.insert('', 'end', values=(
                        reserva.get('id_reservacion', ''),
                        reserva.get('nombre_cliente', ''),
                        fecha_in,
                        fecha_out,
                        reserva.get('numero_habitacion', 'N/A'),
                        reserva.get('estado_reserva', '')
                    ))
            
                messagebox.showinfo("Encontrado", f"✅ Reserva #{id_reserva} encontrada")
            else:
                messagebox.showinfo("No encontrado", f"❌ No existe reserva con ID {id_reserva}")
                self.actualizar_tabla_reservas()
            
        except Exception as e:
            messagebox.showerror("Error", f"Error al buscar: {str(e)}")
            print(f"Error detallado: {e}")


    def mostrar_todas_reservas(self):
        """Muestra TODAS las reservas"""
        self.entry_buscar_reserva.delete(0, tk.END)
        self.actualizar_tabla_reservas()


    def actualizar_tabla_reservas(self):
        """Actualiza la tabla de reservas"""
        for item in self.tabla_reservas.get_children():
            self.tabla_reservas.delete(item)
        
        reservas = self.bd.obtener_reservas()
        
        if reservas:
            for reserva in reservas:
                fecha_in = self.helpers.formatear_fecha(reserva.get('fecha_check_in'))
                fecha_out = self.helpers.formatear_fecha(reserva.get('fecha_check_out'))
                
                self.tabla_reservas.insert('', 'end', values=(
                    reserva['id_reservacion'],
                    reserva['cliente'],
                    fecha_in,
                    fecha_out,
                    reserva['numero_habitacion'] if reserva['numero_habitacion'] else 'N/A',
                    reserva['estado']
                ), tags=(reserva['id_reservacion'],))
    
    def mostrar_formulario_reserva(self, id_reserva=None):
        """Muestra formulario para crear/editar reserva"""
        dialog = tk.Toplevel(self.ventana)
        dialog.title("Nueva Reserva" if not id_reserva else "Editar Reserva")
        dialog.geometry("500x500")
        dialog.configure(bg=Config.COLOR_CLARO)
        dialog.transient(self.ventana)
        dialog.grab_set()
        
        self.helpers.centrar_ventana(dialog, 500, 500)
        
        frame_principal = tk.Frame(dialog, bg=Config.COLOR_BLANCO, padx=30, pady=30)
        frame_principal.pack(fill='both', expand=True)
        
        titulo = "➕ NUEVA RESERVA" if not id_reserva else "✏️ EDITAR RESERVA"
        tk.Label(frame_principal, text=titulo,
                font=Config.FUENTE_TITULO,
                bg=Config.COLOR_BLANCO, fg=Config.COLOR_PRIMARIO).grid(row=0, column=0, columnspan=2, pady=(0, 25), sticky='w')
        
        datos_reserva = None
        if id_reserva:
            pass
        
        campos = [
            ("ID Cliente:", "id_cliente"),
            ("ID Sucursal:", "id_sucursal"),
            ("Fecha Check-in:", "fecha_inicio"),
            ("Fecha Check-out:", "fecha_fin"),
            ("ID Empleado:", "id_empleado"),
            ("Número Habitación:", "numero_habitacion")
        ]
        
        self.entradas_reserva = {}
        
        valores_por_defecto = {
            'fecha_inicio': self.fecha_hoy,
            'fecha_fin': self.fecha_manana,
            'id_sucursal': '1',
            'id_empleado': str(self.usuario['numero_tarjeta']) if self.usuario else '1001'
        }
        
        for i, (etiqueta, campo) in enumerate(campos):
            tk.Label(frame_principal, text=etiqueta,
                    font=Config.FUENTE_PRINCIPAL,
                    bg=Config.COLOR_BLANCO, fg=Config.COLOR_PRIMARIO).grid(row=i+1, column=0, sticky='w', pady=8)
            
            entrada = ttk.Entry(frame_principal, width=30)
            
            if campo in valores_por_defecto:
                entrada.insert(0, valores_por_defecto[campo])
            elif datos_reserva and campo in datos_reserva:
                entrada.insert(0, datos_reserva[campo])
            
            entrada.grid(row=i+1, column=1, pady=8, padx=(10, 0))
            self.entradas_reserva[campo] = entrada
        
        frame_buscar = tk.Frame(frame_principal, bg=Config.COLOR_BLANCO)
        frame_buscar.grid(row=len(campos)+1, column=0, columnspan=2, pady=15, sticky='w')

        
        def buscar_habitaciones():
            try:
                fecha_inicio = self.entradas_reserva['fecha_inicio'].get()
                fecha_fin = self.entradas_reserva['fecha_fin'].get()
                
                if not fecha_inicio or not fecha_fin:
                    messagebox.showwarning("Advertencia", "Ingrese fechas para buscar habitaciones")
                    return
                
                id_sucursal = None
                if 'id_sucursal' in self.entradas_reserva:
                    sucursal_text = self.entradas_reserva['id_sucursal'].get()
                    if sucursal_text and sucursal_text.strip():
                        try: 
                            id_sucursal = int(sucursal_text)
                        except ValueError:
                            pass
                        
                if id_sucursal:
                    habitaciones = self.bd.buscar_habitaciones_disponibles_bd(
                        fecha_inicio, fecha_fin, id_sucursal
                    )
                else:
                    habitaciones = self.bd.buscar_habitaciones_disponibles_bd(
                        fecha_inicio, fecha_fin
                    )
        
                if habitaciones:
                    ventana_hab = tk.Toplevel(dialog)
                    ventana_hab.title("Habitaciones Disponibles")
                    ventana_hab.geometry("600x400")
                    
                    frame_lista = tk.Frame(ventana_hab)
                    frame_lista.pack(fill='both', expand=True, padx=10, pady=10)

                    columnas = ('Habitación', 'Descripción', 'Piso', 'Sucursal', 'Tipo', 'Precio')
                    tree = ttk.Treeview(frame_lista, columns=columnas, show='headings', height=15)
                    
                    for col in columnas:
                        tree.heading(col, text=col)
                        tree.column(col, width=100)
                    
                    scrollbar = ttk.Scrollbar(frame_lista, orient='vertical', command=tree.yview)
                    tree.configure(yscrollcommand=scrollbar.set)
                    
                    tree.pack(side='left', fill='both', expand=True)
                    scrollbar.pack(side='right', fill='y')
                    
                    for hab in habitaciones:
                        tree.insert('', 'end', values=(
                            hab['numero_habitacion'],
                            hab['descripcion'][:30] + "..." if len(hab['descripcion']) > 30 else hab['descripcion'],
                            hab['piso'],
                            hab['id_sucursal'],
                            hab['tipo_habitacion'],
                            f"${float(hab['precio']):.2f}"
                        ))
                    
                    def seleccionar_habitacion():
                        seleccion = tree.selection()
                        if seleccion:
                            item = tree.item(seleccion[0])
                            num_habitacion = item['values'][0]
                            self.entradas_reserva['numero_habitacion'].delete(0, tk.END)
                            self.entradas_reserva['numero_habitacion'].insert(0, str(num_habitacion))
                            ventana_hab.destroy()
                    
                    frame_botones_hab = tk.Frame(ventana_hab)
                    frame_botones_hab.pack(fill='x', padx=10, pady=10)
                    
                    Helpers.crear_boton_estilizado(
                        frame_botones_hab,
                        texto="Seleccionar",
                        comando=seleccionar_habitacion,
                        estilo="primario",
                        padding_y=8,
                        padding_x=15
                    ).pack()
                    
                else:
                    messagebox.showinfo("Información", "No hay habitaciones disponibles en esas fechas")
                    
            except Exception as e:
                messagebox.showerror("Error", f"Error al buscar habitaciones: {str(e)}")
        
        Helpers.crear_boton_estilizado(
            frame_buscar,
            texto="🔍 Buscar Habitaciones Disponibles",
            comando=buscar_habitaciones,
            estilo="secundario",
            padding_y=8,
            padding_x=15
        ).pack()
        
        frame_botones = tk.Frame(frame_principal, bg=Config.COLOR_BLANCO)
        frame_botones.grid(row=len(campos)+2, column=0, columnspan=2, pady=20)
        
        def guardar_reserva():
            try:
                datos = {}
                for campo, entrada in self.entradas_reserva.items():
                    datos[campo] = entrada.get().strip()
                
                campos_requeridos = ['id_cliente', 'fecha_inicio', 'fecha_fin', 'numero_habitacion']
                for campo in campos_requeridos:
                    if not datos[campo]:
                        messagebox.showerror("Error", f"El campo {campo} es requerido")
                        return
                
                try:
                    datos['id_cliente'] = int(datos['id_cliente'])
                    datos['id_sucursal'] = int(datos['id_sucursal'])
                    datos['id_empleado'] = int(datos['id_empleado'])
                    datos['numero_habitacion'] = int(datos['numero_habitacion'])
                except ValueError:
                    messagebox.showerror("Error", "Los IDs y número de habitación deben ser números")
                    return
                
                fecha_inicio = datetime.strptime(datos['fecha_inicio'], '%Y-%m-%d')
                fecha_fin = datetime.strptime(datos['fecha_fin'], '%Y-%m-%d')
                
                if fecha_fin <= fecha_inicio:
                    messagebox.showerror("Error", "La fecha de salida debe ser posterior a la de entrada")
                    return
                
                if not id_reserva:
                    id_nueva_reserva = self.bd.crear_reserva_completa(datos)
                    if id_nueva_reserva is not None:
                        messagebox.showinfo("Éxito", f"Reserva creada con ID: {id_nueva_reserva}")
                        dialog.destroy()
                        self.actualizar_tabla_reservas()
                else:
                    if self.bd.actualizar_reserva(id_reserva, datos):
                        messagebox.showinfo("Éxito", "Reserva actualizada correctamente")
                        dialog.destroy()
                        self.actualizar_tabla_reservas()
                        
            except Exception as e:
                messagebox.showerror("Error", f" Error: {str(e)}")
        
        Helpers.crear_boton_estilizado(
            frame_botones,
            texto="💾 Guardar Reserva",
            comando=guardar_reserva,
            estilo="exito",
            padding_y=10,
            padding_x=20
        ).pack(side='left', padx=5)
        
        Helpers.crear_boton_estilizado(
            frame_botones,
            texto="❌ Cancelar",
            comando=dialog.destroy,
            estilo="peligro",
            padding_y=10,
            padding_x=20
        ).pack(side='left', padx=5)
    
    def editar_reserva(self):
        """Abre formulario para editar reserva seleccionada"""
        seleccion = self.tabla_reservas.selection()
        if not seleccion:
            messagebox.showwarning("Advertencia", "Seleccione una reserva para editar")
            return
        
        item = self.tabla_reservas.item(seleccion[0])
        id_reserva = int(item['values'][0])
        self.mostrar_formulario_reserva(id_reserva)
    
    def eliminar_reserva(self):
        """Elimina la reserva seleccionada"""
        seleccion = self.tabla_reservas.selection()
        if not seleccion:
            messagebox.showwarning("Advertencia", "Seleccione una reserva para eliminar")
            return
        
        item = self.tabla_reservas.item(seleccion[0])
        id_reserva = item['values'][0]
        cliente = item['values'][1]
        
        respuesta = messagebox.askyesno("Confirmar", 
                                       f"¿Está seguro de eliminar la reserva #{id_reserva} del cliente {cliente}?\n\nEsta acción liberará la habitación y eliminará los registros.")
        
        if respuesta:
            if self.bd.eliminar_reserva(id_reserva):
                messagebox.showinfo("Éxito", "✅ Reserva eliminada correctamente")
                self.actualizar_tabla_reservas()
    
    def ver_detalles_reserva(self):
        """Muestra detalles de la reserva seleccionada"""
        seleccion = self.tabla_reservas.selection()
        if not seleccion:
            messagebox.showwarning("Advertencia", "Seleccione una reserva para ver detalles")
            return
        
        item = self.tabla_reservas.item(seleccion[0])
        id_reserva = item['values'][0]
        
        
        
        messagebox.showinfo("Detalles de Reserva",
                          f"Reserva ID: {id_reserva}\n"
                          f"Cliente: {item['values'][1]}\n"
                          f"Check-in: {item['values'][2]}\n"
                          f"Check-out: {item['values'][3]}\n"
                          f"Habitación: {item['values'][4]}\n"
                          f"Estado: {item['values'][5]}")
    
    def mostrar_habitaciones(self):
        """Muestra la búsqueda de habitaciones"""
        self.limpiar_contenido()
        
        frame_titulo = tk.Frame(self.contenido_principal, bg=Config.COLOR_CLARO)
        frame_titulo.pack(fill='x', pady=(0, 20))
        
        tk.Label(
            frame_titulo, 
            text="🛌 Buscar Habitaciones Disponibles", 
            font=Config.FUENTE_TITULO,
            bg=Config.COLOR_CLARO, 
            fg=Config.COLOR_PRIMARIO
        ).pack(anchor='w')
        
        tk.Label(
            frame_titulo, 
            text="Busque habitaciones disponibles por fecha",
            font=Config.FUENTE_PRINCIPAL,
            bg=Config.COLOR_CLARO, 
            fg=Config.COLOR_GRIS
        ).pack(anchor='w')
        
        frame_filtros = tk.Frame(self.contenido_principal, bg=Config.COLOR_CLARO)
        frame_filtros.pack(fill='x', pady=(0, 20))
        
        tk.Label(
            frame_filtros, 
            text="Fecha Inicio:",
            font=Config.FUENTE_PRINCIPAL,
            bg=Config.COLOR_CLARO, 
            fg=Config.COLOR_PRIMARIO
        ).grid(row=0, column=0, padx=(0, 5), sticky='w')
        
        self.fecha_inicio_hab = ttk.Entry(frame_filtros, width=12)
        self.fecha_inicio_hab.grid(row=0, column=1, padx=(0, 20))
        self.fecha_inicio_hab.insert(0, self.fecha_hoy)
        
        tk.Label(
            frame_filtros, 
            text="Fecha Fin:",
            font=Config.FUENTE_PRINCIPAL,
            bg=Config.COLOR_CLARO, 
            fg=Config.COLOR_PRIMARIO
        ).grid(row=0, column=2, padx=(0, 5), sticky='w')
        
        self.fecha_fin_hab = ttk.Entry(frame_filtros, width=12)
        self.fecha_fin_hab.grid(row=0, column=3, padx=(0, 20))
        self.fecha_fin_hab.insert(0, (datetime.now() + timedelta(days=3)).strftime('%Y-%m-%d'))
        
        Helpers.crear_boton_estilizado(
            frame_filtros,
            texto="🔍 Buscar Habitaciones",
            comando=self.buscar_y_mostrar_habitaciones,
            estilo="primario",
            padding_y=8,
            padding_x=15
        ).grid(row=0, column=4, padx=(20, 0))
        
        frame_resultados = tk.Frame(self.contenido_principal, bg=Config.COLOR_CLARO)
        frame_resultados.pack(fill='both', expand=True)
        
        columnas = ('Habitación', 'Descripción', 'Piso', 'Sucursal', 'Tipo', 'Precio')
        
        self.tabla_habitaciones = ttk.Treeview(frame_resultados, columns=columnas, show='headings', height=15)
        
        anchos = [100, 250, 80, 100, 120, 120]
        for col, ancho in zip(columnas, anchos):
            self.tabla_habitaciones.heading(col, text=col)
            self.tabla_habitaciones.column(col, width=ancho, minwidth=50, anchor='center')
        
        scrollbar = ttk.Scrollbar(frame_resultados, orient='vertical', command=self.tabla_habitaciones.yview)
        self.tabla_habitaciones.configure(yscrollcommand=scrollbar.set)
        
        self.tabla_habitaciones.pack(side='left', fill='both', expand=True)
        scrollbar.pack(side='right', fill='y')
    
    def buscar_y_mostrar_habitaciones(self):
        """Busca y muestra habitaciones disponibles"""
        try:
            fecha_inicio = self.fecha_inicio_hab.get()
            fecha_fin = self.fecha_fin_hab.get()
            
            if not fecha_inicio or not fecha_fin:
                messagebox.showerror("Error", "Por favor ingrese ambas fechas")
                return
            
            for item in self.tabla_habitaciones.get_children():
                self.tabla_habitaciones.delete(item)
            
            habitaciones = self.bd.obtener_habitaciones_disponibles(fecha_inicio, fecha_fin)
            
            if habitaciones:
                for hab in habitaciones:
                    self.tabla_habitaciones.insert('', 'end', values=(
                        hab['numero_habitacion'],
                        hab['descripcion'],
                        hab['piso'],
                        hab['id_sucursal'],
                        hab['tipo'],
                        f"${float(hab['precio']):.2f}"
                    ))
                
                messagebox.showinfo("Resultados", f"Se encontraron {len(habitaciones)} habitaciones disponibles")
            else:
                messagebox.showinfo("Resultados", "No hay habitaciones disponibles en el rango de fechas seleccionado")
                
        except Exception as e:
            messagebox.showerror("Error", f"❌ Error al buscar habitaciones: {str(e)}")
    
    def mostrar_reportes(self):
        """Muestra sección de reportes"""
        self.limpiar_contenido()
        
        frame_titulo = tk.Frame(self.contenido_principal, bg=Config.COLOR_CLARO)
        frame_titulo.pack(fill='x', pady=(0, 20))
        
        tk.Label(
            frame_titulo, 
            text="📊 Reportes", 
            font=Config.FUENTE_TITULO,
            bg=Config.COLOR_CLARO, 
            fg=Config.COLOR_PRIMARIO
        ).pack(anchor='w')
        
        tk.Label(
            frame_titulo, 
            text="Esta sección está en desarrollo",
            font=Config.FUENTE_PRINCIPAL,
            bg=Config.COLOR_CLARO, 
            fg=Config.COLOR_GRIS
        ).pack(anchor='w')
    
    def cerrar_sesion(self):
        """Cierra la sesión actual"""
        respuesta = messagebox.askyesno("Cerrar Sesión", "¿Está seguro de cerrar sesión?")
        if respuesta:
            if self.bd.pool_conexiones:
                self.bd.pool_conexiones.closeall()
            self.ventana.destroy()
            login = VentanaLogin()
            login.ventana.mainloop()


# ============================================================================
# EJECUCIÓN PRINCIPAL
# ============================================================================
if __name__ == "__main__":
    try:
        import psycopg2
    except ImportError:
        messagebox.showerror("Error", 
            "La biblioteca psycopg2 no está instalada.\n"
            "Por favor instálela con: pip install psycopg2-binary")
    else:
        login = VentanaLogin()
        login.ventana.mainloop()
