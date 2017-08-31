using manageProductsModel;

service manageProducts
{
	entity Products as projection on manageProductsModel.Products actions {
		action changeImage(
			url: String(255) not null
		) returns String(255);
	};
	entity ReviewPosts as projection on manageProductsModel.ReviewPosts;
	entity Reviews as projection on manageProductsModel.Reviews;
	entity Suppliers as projection on manageProductsModel.Suppliers;
	entity ProductStocks as projection on manageProductsModel.ProductStocks;
	entity StockAvailabilities as projection on manageProductsModel.StockAvailabilities;
}
