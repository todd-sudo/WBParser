import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var url: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "viewDataWB" else { return }
        guard let destination = segue.destination as? WBViewController else {return}
        let productId = String(url.text!.split(separator: "/")[3])
        destination.productId = productId
    }

}

