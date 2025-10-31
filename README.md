# Estadísticas Móvil UNI

## 📊 Descripción del Proyecto

Sistema de estadísticas móvil para la visualización y análisis de datos de postulantes en los procesos de admisión de la Dirección de Admisión de la Universidad Nacional de Ingeniería (UNI).

Este proyecto está compuesto por dos componentes principales:
- **Aplicación Móvil**: Desarrollada en Dart (Flutter) para dispositivos iOS y Android
- **Backend API REST**: Desarrollado en PHP con Laravel para el manejo de datos y lógica de negocio

## 🎯 Características Principales

### Aplicación Móvil
- ✅ Visualización de estadísticas de postulantes en tiempo real
- ✅ Gráficos interactivos y dashboards informativos
- ✅ Filtros por proceso de admisión, especialidad y periodo
- ✅ Interfaz responsive y amigable
- ✅ Compatibilidad con iOS y Android
- ✅ Modo offline con sincronización automática

### Backend API
- ✅ API RESTful robusta y escalable
- ✅ Autenticación y autorización segura
- ✅ Gestión de datos de postulantes
- ✅ Procesamiento de estadísticas en tiempo real
- ✅ Endpoints documentados con Swagger/OpenAPI
- ✅ Optimización de consultas para grandes volúmenes de datos

## 🏗️ Arquitectura del Sistema

```
┌─────────────────────────┐
│   Aplicación Móvil      │
│   (Flutter/Dart)        │
│   - iOS                 │
│   - Android             │
└───────────┬─────────────┘
            │
            │ HTTP/HTTPS
            │ (API REST)
            │
┌───────────▼─────────────┐
│   Backend API           │
│   (Laravel/PHP)         │
│   - Autenticación       │
│   - Lógica de Negocio   │
│   - Procesamiento Datos │
└───────────┬─────────────┘
            │
            │
┌───────────▼─────────────┐
│   Base de Datos         │
│   (MySQL/PostgreSQL)    │
│   - Datos Postulantes   │
│   - Estadísticas        │
└─────────────────────────┘
```

## 📋 Requisitos Previos

### Para la Aplicación Móvil
- Flutter SDK (versión 3.0 o superior)
- Dart SDK (versión 2.17 o superior)
- Android Studio / Xcode (para emuladores)
- Git

### Para el Backend API
- PHP >= 8.0
- Composer
- Laravel 9.x o superior
- MySQL 5.7+ / PostgreSQL 12+
- Servidor web (Apache/Nginx)

## 🚀 Instalación y Configuración

### Configuración del Backend (Laravel)

1. **Clonar el repositorio**
```bash
git clone https://github.com/PowerST2/Stadistics-Movil-UNI.git
cd Stadistics-Movil-UNI/backend
```

2. **Instalar dependencias**
```bash
composer install
```

3. **Configurar variables de entorno**
```bash
cp .env.example .env
php artisan key:generate
```

4. **Editar el archivo `.env` con tus credenciales**
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=estadisticas_uni
DB_USERNAME=tu_usuario
DB_PASSWORD=tu_contraseña
```

5. **Ejecutar migraciones**
```bash
php artisan migrate
php artisan db:seed
```

6. **Iniciar servidor de desarrollo**
```bash
php artisan serve
```

El backend estará disponible en `http://localhost:8000`

### Configuración de la Aplicación Móvil (Flutter)

1. **Navegar al directorio de la app móvil**
```bash
cd Stadistics-Movil-UNI/mobile
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Configurar la URL del API**
Editar el archivo `lib/config/api_config.dart`:
```dart
const String API_BASE_URL = 'http://tu-servidor:8000/api';
```

4. **Ejecutar la aplicación**
```bash
# Para Android
flutter run

# Para iOS (solo en macOS)
flutter run -d ios

# Para un dispositivo específico
flutter devices
flutter run -d <device-id>
```

## 📱 Uso de la Aplicación

### Funcionalidades Principales

1. **Dashboard Principal**
   - Visualización de estadísticas generales
   - Gráficos de tendencias de postulantes
   - Indicadores clave de rendimiento

2. **Filtros y Búsqueda**
   - Filtrar por proceso de admisión
   - Filtrar por especialidad/carrera
   - Filtrar por periodo académico
   - Búsqueda avanzada de postulantes

3. **Reportes**
   - Generación de reportes estadísticos
   - Exportación de datos (PDF, Excel)
   - Compartir información

4. **Sincronización**
   - Actualización automática de datos
   - Modo offline con cache local

## 🔌 API Endpoints

### Autenticación
```
POST   /api/login          - Iniciar sesión
POST   /api/logout         - Cerrar sesión
POST   /api/refresh        - Refrescar token
```

### Estadísticas
```
GET    /api/statistics              - Obtener estadísticas generales
GET    /api/statistics/by-process   - Estadísticas por proceso
GET    /api/statistics/by-career    - Estadísticas por carrera
GET    /api/statistics/by-period    - Estadísticas por periodo
```

### Postulantes
```
GET    /api/applicants              - Listar postulantes
GET    /api/applicants/{id}         - Obtener postulante específico
GET    /api/applicants/search       - Buscar postulantes
```

### Procesos de Admisión
```
GET    /api/admission-processes     - Listar procesos de admisión
GET    /api/admission-processes/{id} - Obtener proceso específico
```

## 🛠️ Tecnologías Utilizadas

### Backend
- **Framework**: Laravel 9.x
- **Lenguaje**: PHP 8.0+
- **Base de Datos**: MySQL / PostgreSQL
- **Autenticación**: Laravel Sanctum / JWT
- **Documentación**: Swagger / L5-Swagger

### Aplicación Móvil
- **Framework**: Flutter 3.x
- **Lenguaje**: Dart 2.17+
- **Gestión de Estado**: Provider / Bloc / Riverpod
- **HTTP Client**: Dio / http
- **Almacenamiento Local**: Shared Preferences / Hive
- **Gráficos**: fl_chart / syncfusion_flutter_charts

## 📊 Estructura del Proyecto

```
Stadistics-Movil-UNI/
├── backend/                    # API Laravel
│   ├── app/
│   │   ├── Http/
│   │   │   ├── Controllers/   # Controladores API
│   │   │   └── Middleware/    # Middlewares
│   │   ├── Models/            # Modelos Eloquent
│   │   └── Services/          # Lógica de negocio
│   ├── database/
│   │   ├── migrations/        # Migraciones de BD
│   │   └── seeders/          # Seeders
│   ├── routes/
│   │   └── api.php           # Rutas del API
│   └── tests/                # Tests unitarios
│
├── mobile/                    # Aplicación Flutter
│   ├── lib/
│   │   ├── config/           # Configuraciones
│   │   ├── models/           # Modelos de datos
│   │   ├── providers/        # Gestión de estado
│   │   ├── screens/          # Pantallas de la app
│   │   ├── services/         # Servicios API
│   │   ├── widgets/          # Widgets reutilizables
│   │   └── main.dart         # Punto de entrada
│   ├── assets/               # Recursos (imágenes, fuentes)
│   ├── test/                 # Tests
│   └── pubspec.yaml          # Dependencias Flutter
│
└── README.md                 # Este archivo
```

## 🧪 Testing

### Backend (Laravel)
```bash
# Ejecutar todos los tests
php artisan test

# Ejecutar tests específicos
php artisan test --filter=StatisticsTest

# Cobertura de código
php artisan test --coverage
```

### Mobile (Flutter)
```bash
# Ejecutar tests unitarios
flutter test

# Ejecutar tests de integración
flutter test integration_test/

# Cobertura de código
flutter test --coverage
```

## 🤝 Contribución

Las contribuciones son bienvenidas. Por favor, sigue estos pasos:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/NuevaCaracteristica`)
3. Commit tus cambios (`git commit -m 'Agregar nueva característica'`)
4. Push a la rama (`git push origin feature/NuevaCaracteristica`)
5. Abre un Pull Request

### Estándares de Código

#### Backend (Laravel)
- Seguir PSR-12 para estilo de código PHP
- Usar nombres descriptivos para métodos y variables
- Documentar funciones complejas
- Escribir tests para nuevas funcionalidades

#### Mobile (Flutter)
- Seguir las guías de estilo de Dart/Flutter
- Usar nombres descriptivos siguiendo camelCase
- Comentar código complejo
- Mantener widgets pequeños y reutilizables

## 📄 Licencia

Este proyecto está licenciado bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 👥 Equipo de Desarrollo

Desarrollado por el equipo de tecnología de la Dirección de Admisión - Universidad Nacional de Ingeniería (UNI).

## 📞 Contacto y Soporte

Para reportar bugs, solicitar características o contribuir al proyecto:

- **Issues**: [GitHub Issues](https://github.com/PowerST2/Stadistics-Movil-UNI/issues)
- **Dirección de Admisión UNI**: [Sitio Web Oficial](https://www.uni.edu.pe)

## 🔐 Seguridad

Si descubres alguna vulnerabilidad de seguridad, por favor envía un email a seguridad@uni.edu.pe en lugar de usar el issue tracker.

## 📚 Documentación Adicional

- [Documentación de Laravel](https://laravel.com/docs)
- [Documentación de Flutter](https://flutter.dev/docs)
- [Guía de API](docs/api-guide.md)
- [Manual de Usuario](docs/user-manual.md)

## 🗺️ Roadmap

### Versión 2.0 (Próximamente)
- [ ] Notificaciones push
- [ ] Análisis predictivo con Machine Learning
- [ ] Dashboard personalizable
- [ ] Exportación avanzada de reportes
- [ ] Integración con sistemas académicos
- [ ] Modo oscuro
- [ ] Soporte multilenguaje

## ⚙️ Configuración Avanzada

### Variables de Entorno (Backend)

```env
# Configuración de la aplicación
APP_NAME="Estadísticas UNI"
APP_ENV=production
APP_DEBUG=false
APP_URL=https://tu-dominio.com

# Base de datos
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=estadisticas_uni
DB_USERNAME=usuario
DB_PASSWORD=contraseña

# Cache y sesiones
CACHE_DRIVER=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis

# Redis
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379
```

## 🐛 Solución de Problemas

### Problemas Comunes

**Error de conexión al API**
- Verificar que el servidor backend esté ejecutándose
- Comprobar la URL del API en la configuración móvil
- Revisar configuración de CORS en Laravel

**Error al ejecutar migraciones**
- Verificar credenciales de base de datos
- Asegurar que la base de datos exista
- Ejecutar `php artisan config:clear`

**Problemas con dependencias de Flutter**
- Ejecutar `flutter clean`
- Borrar `pubspec.lock`
- Ejecutar `flutter pub get` nuevamente

---

**Desarrollado con ❤️ para la Universidad Nacional de Ingeniería**