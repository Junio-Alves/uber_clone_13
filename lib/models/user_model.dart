class Usuario {
  final String nome;
  final String email;
  final String profileUrl;
  Usuario({
    required this.nome,
    required this.email,
    required this.profileUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      "Nome": nome,
      "Email": email,
      "profileUrl": profileUrl,
    };
  }
}
