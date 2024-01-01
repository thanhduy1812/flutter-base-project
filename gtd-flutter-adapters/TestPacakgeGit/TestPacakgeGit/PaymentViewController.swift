//
//  PaymentViewController.swift
//  TestPacakgeGit
//
//  Created by Duy Nguyen on 23/04/2023.
//

import UIKit
import IOSGotadiSDK

class PaymentViewController: UIViewController {
    var object: IOSGotadiSDK = IOSGotadiSDK.shared
    var bookingNumberResult: String?
    @IBOutlet weak var bookingNumber: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        bookingNumber.text = bookingNumberResult ?? "Unknown booking"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "PAYMENT VIB NATIVE"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func paymentSuccess(_ sender: Any) {
        object.pushToInvoice(viewController: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
