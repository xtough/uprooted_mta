using manageProducts;

annotate manageProducts.Products with 
{
	@UI.HiddenFilter
	@Common.Label: 'Product'
	@Common.SemanticObject: 'EPMProduct'
	@Common.Text: name
	id;
	@UI.Hidden: true
	@Common.Label: 'Name'
	name;
	@Common.Label: 'Description'
	@UI.MultiLineText: true
	description;
	@Common.Label: 'Main Category'
	mainCategory;
	@Common.Label: 'Category'
	category;
	@Common.Label: 'Supplier'
	@UI.TextArrangement: #TextOnly
	@Common.Text: toSupplier.companyName
	@Common.ValueList: {
		Label:'Supplier',
		CollectionPath:'Suppliers',
		SearchSupported: true,
		Parameters: [
			{ $Type:'Common.ValueListParameterInOut', LocalDataProperty: supplier, ValueListProperty: toSupplier.id },
			{ $Type:'Common.ValueListParameterDisplayOnly', ValueListProperty: toSupplier.companyName }
		]
	}
	supplier;
	@Common.Label: 'Price per Unit'
	@Measures.ISOCurrency: currency
	price;
	currency;
	@Common.Label: 'Image'
	@UI.IsImageURL
	@UI.HiddenFilter
	imageUrl;
	@Common.Label: 'Dimension Unit'
	dimensionUnit;
	@Common.Label: 'Base Unit'
	baseUnit;
	@Common.Label: 'Weight'
	@Measures.Unit: weightUnit
	weight;
	@Common.Label: 'Weight Unit'
	weightUnit;
	@Common.Label: 'Product Height'
	@Measures.Unit: dimensionUnit
	height;
	@Common.Label: 'Product Width'
	@Measures.Unit: dimensionUnit
	width;
	@Common.Label: 'Product Depth'
	@Measures.Unit: dimensionUnit
	depth;
	@Common.Label: 'Original Language'
	originalLanguage;
	@UI.HiddenFilter
	review;
	@UI.HiddenFilter
	toSupplier;
}; 

annotate manageProducts.Products with @(
	Common.SemanticKey: [id],

	UI.LineItem: [ 
		{$Type: 'UI.DataField', Value: imageUrl, "@UI.Importance": #High}, 
		{$Type: 'UI.DataField', Value: id, "@UI.Importance":#High}, 
		{$Type: 'UI.DataField', Value: mainCategory, "@UI.Importance": #High}, 
		{$Type: 'UI.DataField', Value: category, "@UI.Importance": #Medium}, 
		{$Type: 'UI.DataField', Value: supplier, "@UI.Importance": #Medium},
		{$Type: 'UI.DataField', Value: productStock.availability, Criticality: productStock.availability, "@UI.Importance": #High},
		{$Type: 'UI.DataFieldForAnnotation', Target: 'review/@UI.DataPoint#AverageRatingValue', "@UI.Importance": #High}, 
		{$Type: 'UI.DataField', Value: price, "@UI.Importance": #High} 
	],
	UI.SelectionFields: [ supplier, mainCategory ], // filter groups are not yet right 

	UI.HeaderInfo: {
		TypeName:'Product', 
		TypeNamePlural:'Products',
		TypeImageUrl: 'sap-icon://product',
		Title:{Value:name}, 
		Description:{Value:id},
		ImageUrl:imageUrl
	},
	UI.HeaderFacets: [
		{$Type:'UI.ReferenceFacet', Label: 'General Information', Target: '@UI.FieldGroup#GeneralInformation', "@UI.Importance": #High},
		{$Type:'UI.ReferenceFacet', Label: 'Description', Target: '@UI.FieldGroup#ProductHeaderText', "@UI.Importance": #Medium},
		{$Type:'UI.ReferenceFacet', Target: 'productStock/@UI.DataPoint#StockAvailability', "@UI.Importance": #Medium},
		{$Type:'UI.ReferenceFacet', Target: '@UI.DataPoint#Price', "@UI.Importance": #Medium}
	],
	UI.FieldGroup#GeneralInformation: {
		Label: 'General Information',
		Data: [
			{$Type:'UI.DataField', Value:mainCategory},
			{$Type:'UI.DataField', Value:category},
			{$Type:'UI.DataField', Value:supplier}
		]
	},
	UI.FieldGroup#ProductHeaderText: {
		Label: 'Description',
		Data: [
			{$Type: 'UI.DataField', Label: 'Description', Value: description} 
		]
	},
	UI.DataPoint#Price: { 
		Value:price,
		Title:'Price' 
	},
	UI.Facets:
	[
		{
			$Type:'UI.CollectionFacet', 
			Facets: [ 
						{ $Type:'UI.ReferenceFacet', Target: '@UI.FieldGroup#TechnicalData' },
					],
			Label:'Technical Data',		
		},
		{$Type:'UI.ReferenceFacet', Label: 'Reviews', Target: 'reviewPost/@UI.LineItem'},
	],	
	UI.FieldGroup#TechnicalData: {
		Label: 'Technical Data',
		Data: [
			{$Type:'UI.DataField', Value:baseUnit, "@UI.Importance": #High},
			{$Type:'UI.DataField', Value:height, "@UI.Importance": #Medium},
			{$Type:'UI.DataField', Value:width, "@UI.Importance": #Medium},
			{$Type:'UI.DataField', Value:depth, "@UI.Importance": #Medium},
			{$Type:'UI.DataField', Value:weight, "@UI.Importance": #Medium}
		]
	}
);

annotate manageProducts.Reviews with { 
	@Common.Label: 'Average Rating'
	averageRatingValue;
};

annotate manageProducts.Reviews with @(
	UI.DataPoint#AverageRatingValue: {
		Value: averageRatingValue,
		Title: 'Rating',
		TargetValue: 5,
		Visualization: #Rating
	}
);

annotate manageProducts.ReviewPosts with { 
	@Common.Label: 'Date'
	date;
};

annotate manageProducts.ReviewPosts with @(
	UI.LineItem: 
	[
		{$Type: 'UI.DataFieldForAnnotation', Target: '@UI.DataPoint#ReviewRatingValue'},
		{Value: date, Label : 'Review Date'},
		{Value: text, Label : 'Review Text'},
		{$Type: 'UI.DataFieldForAnnotation', Target: '@UI.DataPoint#NumberOfAffirmativeAnswers'}
	],
	UI.DataPoint#ReviewRatingValue: {
		Value: ratingValue,
		Title: 'Rating',
		TargetValue: 5,
		Visualization: #Rating
	},
	UI.DataPoint#NumberOfAffirmativeAnswers: {
		Value: numberOfAffirmativeAnswers,
		Title: 'Rated helpful by',
		TargetValue: totalNumberOfAnswers,
		Visualization: #Progress
	},
	UI.HeaderFacets: [
		{$Type:'UI.ReferenceFacet', Label: 'Review', Target: '@UI.FieldGroup#Metadata'},
		{$Type:'UI.ReferenceFacet', Label: 'Rating', Target: '@UI.DataPoint#ReviewRatingValue'},
		{$Type:'UI.ReferenceFacet', Label: 'Rated helpful by', Target: '@UI.DataPoint#NumberOfAffirmativeAnswers'}
	],
	UI.FieldGroup#Metadata: {
		Label: 'Review',
		Data: [
			{$Type:'UI.DataField', Value: date},
			{$Type:'UI.DataField', Label: 'Review by', Value: contactPerson}
		]
	},
	UI.Facets: [
		{
			$Type:'UI.CollectionFacet', 
			Facets: [ 
						{ $Type:'UI.ReferenceFacet', Target: '@UI.FieldGroup#ReviewText', "@UI.Importance": #High },
					],
			Label:'Review',		
		},
	],
	UI.FieldGroup#ReviewText: {
		Label: 'Review',
		Data: [
			{$Type:'UI.DataField', Label: 'Review Title', Value: title},
			{$Type:'UI.DataField', Label: 'Review Text', Value: text}
		]
	}
);
/*
annotate manageProducts.Suppliers with {
	@ObjectModel.Text.Element: companyName 
	id; 
};

annotate manageProducts.Suppliers with @(
	UI.HeaderInfo: {
		TypeName: 'Supplier',
		TypeNamePlural: 'Suppliers',
		TypeImageUrl: 'sap-icon://supplier',
		Title: { Type: #Standard, Value: companyName }
	},
	UI.LineItem: [ 
		{Value:id, Importance: #High, $Type: #Standard},
		{Value:companyName, Importance:#High, $Type: #Standard}, 
		{Value:emailAddress, Importance:#High, $Type: #Standard},
		{Value:phoneNumber, Importance: #High, $Type: #Standard}, 
		{Value:faxNumber, Importance: #Low, $Type: #Standard},
		{Value:url, Importance: #Medium, $Type: #WithUrl, Url: url} 
	]
);
*/
annotate manageProducts.ProductStocks with {
	@UI.HiddenFilter
	id;
	@UI.HiddenFilter
	quantity;
	@UI.HiddenFilter
	quantityUnit;
	@Common.Label: 'Availability'
	@UI.TextArrangement: #TextOnly
	@Common.Text: toAvailability.text
	availability;
};

annotate manageProducts.ProductStocks with @(
	UI.HeaderInfo:{
		TypeName: 'Product Stock',
		TypeNamePlural: 'Product Stock',
		Title: { Value: 'Product' }
	},
	UI.DataPoint#StockAvailability: { 
		Value: availability, 
		Criticality: availability,
		Title:'Stock Availability'
	}
);
