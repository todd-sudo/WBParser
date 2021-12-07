import Foundation
import UIKit


class Service {
    var tableView: UITableView
    let decoder: JSONDecoder
    var dataSource: [Product] = []
    var productImage: UIImageView
    
    let session = URLSession.shared
    
    init(tableView: UITableView, decoder: JSONDecoder, productImage: UIImageView, dataSource: [Product]){
        self.tableView = tableView
        self.decoder = decoder
        self.productImage = productImage
        self.dataSource = dataSource
    }
    
    // MARK: - Получает данные с API Willdberies
    func getProduct(productId: String){
        guard let urlData = URL(string: "https://wbxcatalog-ru.wildberries.ru/nm-2-card/catalog?spp=3&lang=ru&curr=rub&offlineBonus=0&onlineBonus=0&emp=0&locale=ru&nm=\(productId)") else {return}

        session.dataTask(with: urlData) { [weak self] (data, response, error) in
            guard let strongSelf = self else {return}
            if error == nil, let parsData = data {
              
                guard let welcome = try? strongSelf.decoder.decode(Welcome.self, from: parsData) else {return}
                strongSelf.dataSource = welcome.data.products
                // Запускам в главном потоке
//                DispatchQueue.main.async {
//                    strongSelf.tableView.reloadData()
//                }
            }
            else {
                print("Error \(error?.localizedDescription)")
            }
        }.resume()

    }
    
    // MARK: - Генерирует ссылку на изображение
    func generateLinkImage(_ productID: String) -> String{
        let genID = productID.dropLast(4) + "0000"
        let imageUrl = "https://images.wbstatic.net/big/new/\(genID)/\(productID)-1.jpg"
        return imageUrl
    }
    
    // MARK: - Скачивает изображение
    func dowloadImage(productId: String) {
        let imageURL = generateLinkImage(productId)
        DispatchQueue.main.async {
            if let url = URL(string: imageURL) {
                if let data = try? Data(contentsOf: url){
                    self.productImage.image = UIImage(data: data)
                }
            }
        }
    }
}
