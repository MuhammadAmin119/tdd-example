
class ProductModel {
    int id;
    String name;
    String description;
    String price;
    List<Image> images;
    DateTime createdAt;

    ProductModel({
        required this.id,
        required this.name,
        required this.description,
        required this.price,
        required this.images,
        required this.createdAt,
    });

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"] ?? 0,
        name: json["name"]?? '',
        description: json["description"]?? '',
        price: json["price"] ??'',
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x)))?? [],
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "images": List<dynamic>.from(images.map((x) => x.toJson())),
        "created_at": createdAt.toIso8601String(),
    };
}

class Image {
    int id;
    String image;

    Image({
        required this.id,
        required this.image,
    });

    factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
    };
}
