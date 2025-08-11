

class User {

  final int uid;
  final String nombre;
  final String rol;
  final String token;
  final bool debeCambiarPassword;

  User({
    required this.uid, 
    required this.nombre, 
    required this.rol, 
    required this.token, 
    required this.debeCambiarPassword 
  });

}