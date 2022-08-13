
class CategoryModel {
   int? index;
   String? img  ;
   String? title ;
  CategoryModel(this.index, this.img, this.title);
CategoryModel.fromJson(Map<String , dynamic> json){
  index = json["id"];
  img = json["iconUrl"] ;
  title = json["name"];
}
}