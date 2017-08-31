context manageProductsModel
{
	entity Products
	{
		key id: String(10);
			category: String(40);
			mainCategory: String(40);
			price: Decimal(16, 3);
			currency: String(5);
			height: Decimal(13, 3);
			width: Decimal(13, 3);
			depth: Decimal(13, 3);
			dimensionUnit: String(3);
			imageUrl: String(255);
			supplier: String(10);
			baseUnit: String(3);
			weight: Decimal(13, 3);
			weightUnit: String(3);
			originalLanguage: String(2);
			name: String(255);
			description: String(255);
			review: Association to one Reviews on review.product = id; // Composition of
			reviewPost: Association [*] to ReviewPosts on reviewPost.product = id; // Composition of
			productStock: Association to one ProductStocks on productStock.id = id; // Composition of
			toSupplier: Association to one Suppliers on toSupplier.id = supplier;
	}

	entity Reviews
	{
		key id: String(10);
			product: String(10);
			averageRatingValue: Decimal(4,2);
			numberOfReviewPosts: Integer;
	}

	entity ReviewPosts
	{
		key id: String(10);
			review: String(10);
			product: String(10);
			title: String(60);
			text: String(1024); // LargeString;
			ratingValue: Decimal(4,2);
			numberOfAffirmativeAnswers: Integer;
			totalNumberOfAnswers: Integer;
			date: Date;
			contactPerson: String(10);
			isReviewOfCurrentUser: Boolean;
	}

	entity Suppliers
	{
		key id: String(10);
			companyName: String(80);
			emailAddress: String(255);
			faxNumber: String(30);
			phoneNumber: String(30);
			url: String(255); // LargeString;
			address: String(10);
	}

	entity ProductStocks
	{
		key id: String(10);
			quantity: Decimal(13, 3);
			quantityUnit: String(3);
			availability: Integer;
			minimumQuantity: Decimal(13,3);
			toAvailability: Association to one StockAvailabilities on toAvailability.id = availability;
	}

	entity StockAvailabilities {
		key id: Integer;
			text: String(60);
	};
};
