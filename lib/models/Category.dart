
class CategoryModel {  // Corrected spelling from CategotyModel to CategoryModel
  int? id;
  String? category;
  
  CategoryModel({
    this.id,
    this.category,
  });
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
        id: json['id'],
        category: json['category'],
      );
  }
}


