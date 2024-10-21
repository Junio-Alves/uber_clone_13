class Usuario {
  final String userUid;
  final String nome;
  final String email;
  final String profileUrl;
  Usuario({
    required this.userUid,
    required this.nome,
    required this.email,
    required this.profileUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      "userUid": userUid,
      "Nome": nome,
      "Email": email,
      "profileUrl": profileUrl,
    };
  }
}
