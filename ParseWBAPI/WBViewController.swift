import UIKit


class WBViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var productId: String = ""

    var tableView = UITableView()
    let identifire = "cell"
    let sessionConfiguration = URLSessionConfiguration.default
    let session = URLSession.shared
    let decoder = JSONDecoder()
    var dataSource = [Product]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTable()
        getProduct(productId: productId)
    }
    
    func createTable() {
        self.tableView = UITableView(frame: view.bounds, style: .plain)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.identifire)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
        
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: identifire, for: indexPath)
        let product = dataSource.first
        let objects = [
            "Название - \(product?.name ?? "-")",
            "Бренд - \(product?.brand ?? "-")",
            "Скидка - \(product?.sale ?? 0)%",
            "Промокод - \(product?.extended.promoSale ?? 0)%",
            "Базовая цена - \((product?.priceU ?? 0) / 100) рублей",
            "Цена со скидкой - \((product?.extended.basicPriceU ?? 0) / 100) рублей",
            "Конечная цена - \((product?.salePriceU ?? 0) / 100) рублей",
            "Цена с промокодом - \((product?.extended.promoPriceU ?? 0) / 100) рублей",
            "Рейтинг - \(product?.rating ?? 0) звезд",
            "Кол-во отзывов - \(product?.feedbacks ?? 0) отзывов",
            "Цвет - \(product?.colors[0].name ?? "-")",
        ]
        cell.textLabel?.text = objects[indexPath.row]
        return cell
    }
    
    func getProduct(productId: String) {
        guard let urlData = URL(string: "https://wbxcatalog-ru.wildberries.ru/nm-2-card/catalog?spp=3&lang=ru&curr=rub&offlineBonus=0&onlineBonus=0&emp=0&locale=ru&nm=\(productId)") else {return}
        
        session.dataTask(with: urlData) { [weak self] (data, response, error) in
            guard let strongSelf = self else {return}
            if error == nil, let parsData = data {
              
                guard let welcome = try? strongSelf.decoder.decode(Welcome.self, from: parsData) else {return}
                strongSelf.dataSource = welcome.data.products
                // Запускам в главном потоке
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                }
            }
            else {
                print("Error \(error?.localizedDescription)")
            }
        }.resume()
    }
    
}
