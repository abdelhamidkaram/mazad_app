abstract class CategoriesStates {}

class InitCategoriesState extends CategoriesStates{}

class GetCategoryProductsSuccess extends CategoriesStates{}
class GetCategoryProductsLoading extends CategoriesStates{}
class GetCategoryProductsError extends CategoriesStates{}