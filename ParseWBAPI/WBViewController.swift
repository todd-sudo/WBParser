import UIKit


class WBViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var productImage: UIImageView!
    
    var productId: String = ""

    var tableView = UITableView()
    let identifire = "cell"
    let sessionConfiguration = URLSessionConfiguration.default
    let session = URLSession.shared
    let decoder = JSONDecoder()
    var dataSource: [Product] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTable()
        let service = Service(
            tableView: tableView,
            decoder: decoder,
            productImage: productImage,
            dataSource: dataSource
        )

        service.dowloadImage(productId: self.productId)
        service.getProduct(productId: self.productId)
        DispatchQueue.main.async {
            self.dataSource = service.dataSource
            service.tableView.reloadData()
        }
    }

    func createTable() {
        self.tableView = UITableView(frame: view.bounds, style: .plain)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.identifire)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)
        
        tableView.frame = CGRect(x: 0, y: 356, width: tableView.frame.width, height: tableView.frame.height)
        
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
        return 12
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifire, for: indexPath)
        let product = dataSource.first
        
        var qty = 0
        let sizes = product?.sizes ?? []
        
        for size in sizes{
            for stock in size.stocks {
                qty += stock.qty
            }
        }
        
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
            "Всего товаров - \(qty) штук",
        ]
        cell.textLabel?.text = objects[indexPath.row]
        return cell
    }
}
