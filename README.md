# cinemapedia

# Dev
1. Copiar el .env.template y renombrarlo a .env
2. Cambiar las variables de entorno (The MovieDB)
3. Cambios en la entidad, hay que ejecutar el comando
   ```
   flutter pub run build_runner build
   ```

# Tener en cuenta
En dispositivos antiguos las peticiones con certificado SSL pueden dart error
   ```
   CERTIFICATE_VERIFY_FAILED
   ```
Pasos para solucionar el error:
1. Descargar cert de https://letsencrypt.org/certs/lets-encrypt-r3.pem
2. Agregar este archivo al directorio raíz del proyecto assets/ca/ Flutter
3. Agregar directorio assets/ca/ assets en pubspec.yaml
4. Agrega este código en la inicialización de la aplicación:
   ```
   void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   ByteData data = await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
   SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
   runApp(MyApp());
   }
   ```
Funciona con la cadena predeterminada, por lo que no se necesitan cambios en el servidor. Los clientes de Android < 7.1.1 seguirán teniendo acceso en un contexto de navegador.
