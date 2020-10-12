
import 'dart:convert';

List<Evento> eventoFromJson(String str) => List<Evento>.from(json.decode(str).map((x) => Evento.fromJson(x)));

String eventoToJson(List<Evento> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Evento {
    Evento({
        this.id,
        this.evento,
        this.fecha,
        this.isBackground,
    });

    String id;
    String evento;
    String fecha;
    bool isBackground;

    factory Evento.fromJson(Map<String, dynamic> json) => Evento(
        id: json["id"],
        evento: json["evento"],
        fecha: json["fecha"],
        isBackground: json["is_background"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "evento": evento,
        "fecha": fecha,
        "is_background": isBackground,
    };
}
