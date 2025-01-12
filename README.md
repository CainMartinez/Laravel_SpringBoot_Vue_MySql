![Logo de QoRders](QoRders/images/logo.png)

# Introducción

**QoRders** es una plataforma diseñada para digitalizar y optimizar la gestión de restaurantes, con la posibilidad de una ambientación temática.

El Backend está desarrollado con ***Spring Boot*** para los usuarios **Cliente**, y proporciona funcionalidades robustas para manejar reservas, y ***Laravel*** para roles importantes, como **Manager** y **Camarero**, ofreciendo una experiencia fluida y profesional.

El Frontend está desarrollado con ***Vue*** y la parte de donaciones y ONG con ***React***.

![QoRders](QoRders/images/home.png)

---

## 🍽️ Optimización de reservas y pedidos
**QoRders** asegura una experiencia fluida tanto para clientes como para el personal del restaurante:

- **Simplicidad y Agilidad**:
  - Desde la reserva hasta la llegada, todo el proceso está optimizado.
  - Confirmaciones claras y detalladas en tiempo real.
  - Comandas abiertas para cualquier camarero que esté libre para mejorar la velocidad del servicio.

---

### 🍔 Salas y Productos

- **Experiencia Temática**
  - Acceder a salas con comida y ambientanción temática de distintos paises.
  - Los productos son únicos por cada sala temática, desde los entrantes hasta las bebidas.

![Salas](QoRders/images/salas.png)

- **Visualización de la carta del restaurante:**
  - Lista de alérgenos para que puedas elegir tu plato preferido sin peligro.
  - También incluye precio, descripción e imagen para una mayor transparencia.
  - Filtrado por precio y tipo de producto.
  - Todos los tipos de usuarios pueden ver la carta.

![Carta](QoRders/images/carta.png)

---

### 🔐 Login y Registro
La plataforma permite a los usuarios registrarse y acceder con cualquier tipo de usuario desde el mismo formulario.

- **Registro de Usuarios**:
  - Los usuarios pueden registrarse seleccionando el tipo de usuario (`Cliente`, `Camarero`, `Manager`) mediante un radio button.
  - Cada tipo de usuario tiene su propio formulario de registro con validaciones específicas.
  - Se permite el uso del mismo email para diferentes tipos de cuentas ya que se almacenan en tablas distintas.

![Register](QoRders/images/register.png)

- **Validaciones**:
  - Todos los campos obligatorios deben ser completados.
  - El email debe tener un formato válido.
  - La contraseña debe cumplir con los requisitos de seguridad (mínimo 8 caracteres, al menos una letra mayúscula, una letra minúscula y un número).
  - Confirmación de contraseña para asegurar que ambas coinciden.

- **Login de Usuarios**:
  - Los usuarios pueden iniciar sesión seleccionando el tipo de usuario (Cliente, Camarero, Manager) mediante un radio button.
  - Se verifica el email y la contraseña contra la tabla correspondiente en la base de datos.
  - Los usuarios autenticados reciben un token JWT para acceder a las funcionalidades de la plataforma.

![Login](QoRders/images/login.png)

---

### 📅 Gestión de Reservas
La plataforma permite a los clientes realizar reservas de forma sencilla y segura, asegurando una experiencia fluida para el usuario y eficiencia en la gestión operativa.

- **Creación de Reservas**:
  - Los clientes pueden reservar turnos específicos (comida o cena) en salas temáticas.
  - Se verifica automáticamente la disponibilidad y la capacidad antes de confirmar la reserva en el calendario a tiempo real.

![Reserva](QoRders/images/reserva.png)

- **Validación y Confirmación**:
  - QoRders asegura que los clientes no puedan duplicar reservas en el mismo día.
  - La confirmación incluye un mensaje de texto enviado al cliente.

![Whatsapp](QoRders/images/whatsapp.png)

---

### 📱 Generación de Códigos QR
La plataforma utiliza códigos QR para agilizar la experiencia tanto de los clientes como del personal del restaurante.

- **Automatización**:
  - Cada reserva confirmada genera automáticamente un código QR único.
  - Este código es utilizado para identificar y gestionar fácilmente la reserva en el restaurante.

- **Seguimiento y Control**:
  - Los códigos QR tienen diferentes estados (`Generado`, `Impreso`, `En Progreso`, `Expirado`) para evitar duplicidades.

![QR](QoRders/images/QR.png)

---

### 📊 Dashboard para Clientes
El dashboard permite ver tu información y las reservas realizadas.

- **Información y métricas**:
  - Visualización de una gráfica de reservas.
  - Métrica para la obtención de una comida gratis por objetivos.
  - Ver y modificar la información personal.

![Cliente](QoRders/images/cliente.png)
![Cliente Reservas](QoRders/images/reservas-cliente.png)


---

### 🧑‍🍳 Dashboard para Camareros
El dashboard simplifica las operaciones diarias del personal del restaurante.

- **Gestión de Reservas**:
  - Visualización de reservas asignadas a la sala del camarero.
  - Acceso a generar y enviar códigos QR para check-in.
  - Visualización de tickets asociados a reservas completadas.

![Reservas Camarero](QoRders/images/reservas-camarero.png)

- **Gestión de Comandas**:
  - Visualizar y gestionar los pedidos asociadas a cada reserva.
  - Cambiar estados de los pedidos y detallar productos pedidos.

![Pedidos](QoRders/images/pedidos.png)


- **Perfil Camarero**:
  - Ver los datos personales.
  - Modificar información de su perfil que no sea relevante al puesto de trabajo.

![Camarero](QoRders/images/camarero.png)

---

### 🧑‍💼 Dashboard para Managers
El dashboard proporciona a los managers una herramienta centralizada para gestionar operaciones clave.

- **Gestión de Salas, ONG y Productos**:
  - Crear, actualizar y habilitar/deshabilitar salas y ONG.
  - Filtro de productos por sala para poder modificarlos.

  ![ONG Manager](QoRders/images/ONG-manager.png)
  ![Productos](QoRders/images/productos.png)
  ![Salas Manager](QoRders/images/salas-manager.png)

- **Perfil Manager**:
  - Ver los datos personales.
  - Modificar información del perfil.

  ![Manager](QoRders/images/manager.png)


---

### 🔒 Seguridad y Control de Acceso
QoRders prioriza la seguridad y la gestión de accesos:

- **Autenticación con JWT**:
  - Garantiza un acceso seguro a todas las funcionalidades.
  - Manejo de sesiones con tokens y control de expiración.

- **Roles y Permisos**:
  - Control granular basado en roles como `Cliente`, `Manager` y `Camarero`.
  - Middleware asegura que solo usuarios autorizados accedan a funcionalidades específicas.

---

### 🌍 Valor Social
En cada venta del restaurante que gestione **QoRders** el 5% del monto total de la cuenta se abonará a una **ONG** asociada al país de origen de la sala temática:

- **Donaciones a ONG**:
  - Visualizar las ONG vinculadas al restaurante.
  
  - Posibilidad de donación a las ONG sin estar registrado.

![ONG](QoRders/images/ONG.png)

![Donaciones](QoRders/images/donaciones.png)

---

## Conclusión
QoRders ofrece una solución robusta y segura para la gestión de restaurantes, mejorando la eficiencia operativa y asegurando una experiencia excepcional para los clientes. Con su diseño modular y extensible, está preparado para crecer e integrarse con nuevas funcionalidades en el futuro ya tengas un restaurante temático o uno tradicional.

---

#### 📜 Licencia
Esta aplicación está licenciada bajo la [Licencia MIT](https://opensource.org/licenses/MIT).
