import Foundation


// MARK: - Welcome
struct Welcome: Codable {
    let state: Int
    let data: DataClass
}


struct DataClass: Codable {
    let products: [Product]
}

// MARK: - Product
struct Product: Codable {
    let id, root, kindID, subjectID: Int
    let name, brand: String
    let brandID, siteBrandID, priceU, sale: Int
    let salePriceU: Int
    let extended: Extended
    let pics, rating, feedbacks: Int
    let promoTextCard, promoTextCat: String
    let colors: [Color]
    let sizes: [Size]
    let diffPrice: Bool

    enum CodingKeys: String, CodingKey {
        case id, root
        case kindID = "kindId"
        case subjectID = "subjectId"
        case name, brand
        case brandID = "brandId"
        case siteBrandID = "siteBrandId"
        case priceU, sale, salePriceU, extended, pics, rating, feedbacks, promoTextCard, promoTextCat, colors, sizes, diffPrice
    }
}

// MARK: - Color
struct Color: Codable {
    let name: String
    let id: Int
}

// MARK: - Extended
struct Extended: Codable {
    let basicSale: Int?
    let basicPriceU: Int?
    let promoPriceU: Int?
    let promoSale: Int?
}

// MARK: - Size
struct Size: Codable {
    let name, origName: String
    let rank, optionID: Int
    let stocks: [Stock]

    enum CodingKeys: String, CodingKey {
        case name, origName, rank
        case optionID = "optionId"
        case stocks
    }
}

// MARK: - Stock
struct Stock: Codable {
    let wh, qty: Int
}
