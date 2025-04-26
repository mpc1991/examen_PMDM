import 'dart:convert';

class Usuaris {
    int page;
    int perPage;
    int total;
    int totalPages;
    List<User> data;
    Support support;

    Usuaris({
        required this.page,
        required this.perPage,
        required this.total,
        required this.totalPages,
        required this.data,
        required this.support,
    });

    factory Usuaris.fromJson(String str) => Usuaris.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Usuaris.fromMap(Map<String, dynamic> json) => Usuaris(
        page: json["page"],
        perPage: json["per_page"],
        total: json["total"],
        totalPages: json["total_pages"],
        data: List<User>.from(json["data"].map((x) => User.fromMap(x))),
        support: Support.fromMap(json["support"]),
    );

    Map<String, dynamic> toMap() => {
        "page": page,
        "per_page": perPage,
        "total": total,
        "total_pages": totalPages,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "support": support.toMap(),
    };
}

class User {
    int id;
    String email;
    String firstName;
    String lastName;
    String avatar;

    User({
        required this.id,
        required this.email,
        required this.firstName,
        required this.lastName,
        required this.avatar,
    });

    factory User.fromJson(String str) => User.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        avatar: json["avatar"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "first_name": firstName,
        "last_name": lastName,
        "avatar": avatar,
    };
}

class Support {
    String url;
    String text;

    Support({
        required this.url,
        required this.text,
    });

    factory Support.fromJson(String str) => Support.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Support.fromMap(Map<String, dynamic> json) => Support(
        url: json["url"],
        text: json["text"],
    );

    Map<String, dynamic> toMap() => {
        "url": url,
        "text": text,
    };
}
