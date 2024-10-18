class Motorista {
  final String nome;
  final String email;
  final String profileUrl;
  final String carroModelo;
  final String placa;
  Motorista(
      {required this.nome,
      required this.email,
      required this.profileUrl,
      required this.carroModelo,
      required this.placa});

  Map<String, dynamic> toMap() {
    return {
      "Nome_Motorista": nome,
      "Email": email,
      "profileUrl": profileUrl,
      "Carro_Modelo": carroModelo,
      "Carro_Placa": placa,
    };
  }
}
