//
//  ViewController.swift
//  TestPacakgeGit
//
//  Created by Duy Nguyen on 27/02/2023.
//

import UIKit
import IOSGotadiSDK
class ViewController: UIViewController {
    let object: IOSGotadiSDK = IOSGotadiSDK.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJodW9uZy5wdGhAZ290YWRpLmNvbSIsImF1dGgiOiJST0xFX0IyQyxST0xFX1VTRVIiLCJYLWliZS1kIjoiYzRhOGM3ZjM4M2ZiNmZlMmFjYzFlODdmZjJhZmUxOGYzOThjODQwNTUwYWM5ZWZkOGNhZTk0MDk5MGMxYWE1MzA2MmVlZDA4YWM1NzQwZmE2OGYzYmRlMzk3MzY4OGI5OTlkOTQ5ZTYxNGU4MWE4NmRkMTRjNmUxYmFmMWY4ODE5NTQ4ZDZlNjg3YzVkMDBlMGUzYTQyN2Y2YzdmYjUyZTk3YTIwMzM4YTIwYzgyYjc0ZDBkMTYzMWFjYTgyZjVkM2QzYWJiZDdlZGFlOTljZDg1MzAyZmE4OTU1NGVmYjkxMjg4NDA1YTM2NzZlOGQ0OGQ0NTQ5OThlMWQ5MTFhZTA5YjY5MmIxZGIwYWEzNzNkZDI5ODc2OWU3ZTFlZGNkZDU2OGQxZWMxYjgyOTdjMjhhZGJjN2Q2NzYyZDYwN2U0MmQ1ODdkZjlmOTA0MDZhMzVmYzIwNGI3YTUwMTg0NTQ4NDM2NjA1OGY5ODEyNjU1NGRlZGZjZmNhYzA0YjM1N2U5YjlmODNmMDdlNDc5Y2VlOTlmZjUyMWU3N2Y1NzNjMTJmNTI2N2I1NTUyZjQ1NDlkMGM1MGNlNTg4OWU0MWNkZTE4ZGY2NWQzYjNlMGFlNmZiYmMwYTI3NTI5ZmE3MWZkZjUzNjcxYmQxNGI1MWI1ZWU3MTgyM2U2YTA1NjFjYTRiNzQzYjkwZWM3MTBiMzEzMGEzMjk5ZGFjNTMwMTRkMjFhZTAwMGRiNjY0MzFjOTg1NjczZGNiNWVmMzc3MTc5OTAxMGJlNmQ2NTMzMTE4NDE4OGYyYjc0YTJhNzJjM2RhYzNiN2RjNDlkNjkzNGMyYjYzMWRhN2I0YzY5OGY3YzFkMmRmOTQ1Yjc0YjQyMDU2NmU5NGY5YzliN2FiMWEwOGYxYmViNmMwMDVjMmY0NmVhY2ZmMjNlODcwMjM5MDk4NjY3NTNmNmQyZWU1NzE2ZTMwMjFhNzc5ZmIxNmQ0NTViZDZjOGI2NjBjMzY1ZWI3OGQyYmIyZmNlMTRjOWQ1Zjg5MDlhZjA4YTg1YWQyMmZhMWE1MDJmZDU2MzA5YmExNjQwN2QwZmZkZjc3YTQ4YzlkMTQyOWU3MzJhMGU2YzBhMjRmZDBkY2Y5M2EwOWFiNDI3OGNmYzMwMTZmNmIxZDNkYjRjYTI2ZDRiN2ZiN2IyMWZkYmE3YWU1NmE5NTIyODE5MTI3MTJkYTNlMmVmYmZhM2ZlZWNiYWFhZTIyNzlkOWVjOTcyYjU0ZWQwOTQyNjdlNTBkNjllZTFjNzFjMjE3NjcxODIzZDVhYzc5ZGRjN2MyY2U0Y2MxZTE2NTYxZGU4YzkyZDBiZjBmOWIyNmEyMmU2OTNhYThmYjAxZDM5NjI1ZmUxNTg5OTdlY2I3OWNjYWRhMzZhZjlkNmNjY2YwNWY2MTAwNDA3MWMwNzAzYzk5OGVmYTI3ZjIzOWNiMzQ2ZTAwYTc3OWNlNjdjMTUzMDZlMjRhN2I4Yjk4ZTMxN2FmYWQ3ZGI1NzE4NjUzNDIwZjJkM2M3MzU4N2RiN2JlNzBhZGQxZWIyYzM4ODU4NzNmNjk3OGYzYTBmZTgwYTRjM2QxMjhkYjg4M2FhY2Q0OGYyOGY2ZWYyZGNjOTJmMGNiYTUyNjc3YWU1Y2M3ODE0NmE2Mjc0ZDU0OGFkOGE3MGRjYWFiY2I0Mjk4ZGQ3NDlhNjk5M2I3ODI0NDc1YmE3ZWRmYWRhZjc3MjU5M2JkZjM0NGVmOGE1YTU1NDc3OWUxNDRiZmJhYmZjYWIwNmJmYTNhNmM0NDg0NjljYzRiNDJkYmQ0NTRjNmVkNzFlMWM2NDI4MmM0NWFjZDU4NmQ3NWFjMTI5NTdkMzYxOTEyZDNiOWU2NWEyZGJkZmM0MTgwYzNiNmI5MGY4NWY4OWViMTdmZjJjZWYzOTJlNjFlNjhlMjA2MjdkZjRjNjdkYjQ5ZDljZWM5MWVjMDYzOGI1YTQwNGU0MmY0ZDI2MzAwMDFjYjMyMzkzYWVmNmM4OTRiY2Y2ZGEwZjFkNWY0MTEzNTZiZjdiYzAxNWU1NjFhZmViZjNlYzRhODI1ZmE2NzdkYWY5YWRmMzg2ODNhNGEwMGQ1Mzc0NDA0ODA2MDFhODYyNDc2MmJiYmUyNmYyN2ExMjQ0NjEyYzYzMzg1N2RkYzJjZDkwNjZmZmI0MjNmY2Y1Mjc0MDI1ZjYzNDkzZGFiYjUzMGNkZDYzNzg0NzYyYTAwYmUyNmE3NDMwZGM4ZDZjNWE0MzVhZjFjZmI1MDM4MGViNTMyOTk5NDQwZWU4N2Y1M2JiNDNiYTI4NjViNTlhMTFlMmM0MGYwYzBhMTg5NWNlNTEyMWExYmQ3NjY2ODQwNDJmM2U2YWUzMjZmOWY4NjAwYzBlNmJjNzkzZTAwOGE3ZWUzZTI0YjJiZjA1ZWE1MmI3MTI4NGYwM2NkYmY4ODA0ZTM1OWM3NTVjMDQyNDdiMDdmNmQ2YzFlMTBhOGU5MzEwYTJkZWM3MWE4ZTEzN2RhMGMzM2MyZGE1MDQyYzhlZGQ0OTBhMGU4NjBkY2IxYWE2NjhmODFhMjdlODNjYWZhMjQzNTliOWZmNzBlN2I5NTVkOGY3M2Q1YTIyMTYzNTExMTM4NjFkNDI0NDg2NTI4MDMxZGFlZjI1Y2Q5ZmZkMDI0Y2JjN2IzMDQyZWI4ODU5ZTQ0Y2M3OTBmYjk5ODlkY2FjOGM4ZDNmMWYxN2ZlOGU0MWJkYTFjODFiN2FiZDNjYjRjMDExOWVmMDFkNDhhZDI0NjA5N2UxYjVjN2E4MjUyOGM5YjhmOTM4NDMyYWZmNTIxMjViN2JmNDNkNDNlNDE1ZWNlZWQxNTQzNTRlZGI5OWVkZDEyZTc5M2YwNjllZTFhNzc2ZDNhODU2YTNjNzcxMWU1ZTU5ZDA3YWIxOWI1NzYyMmIzYjE4NDg4YTNkNmY5MGZkYWYyMGQ0MGUyZDZkY2VkNjNmNDI4NjU0MTdkN2JhZDQwNGU0ZTU0ODk2MGFjNmQwYjYwODY2NzNkZGE3ZWIzMDJiYzU1MzAyNTcyY2MxYTFmYzQyMzBlZTQzYTM2N2JjYmZkYWY3NTI0MjVjMWMzZThkZTliODQwMWY1ZmUyODUwYjkwYTQ5MTI1ZDc2ZWM4NzQ2N2ZkYjJjYThlZThiZjNiNDljYjJhMTA1NDNjMzFmNjJhNjQxYTg0YTA2ZTA2N2NmM2VmMjFkZDYxMjM0MjI4YjhhMWVmMGFjNDg3MTNkYmFiNTg1ZjhhMWU0MGIwNjgxZDEyOTBiNmM5ZTdhMTc0YWRmOGIxODY4ZGU2MTBhMGQxZmE2OTZkMjU1M2EzMjY0MzIxODQyMjljMzNhOTNlNDE1YmE3ZGZlNTEyN2NlYjhkN2ZlZjJjNjcyOWQwNzRkMzU0MTU3NDM3ODk2YzBkOTEyYzdlMjE0NWNmMDg1Nzk1MzdmZDg0MzQxIiwiWC1pYmUtayI6ImY4ZDExYmJmNzZkNmQ2ZjQiLCJleHAiOjE2OTU0Mzg2NjB9.F-FSdfF2Oehzhg5up-O0SZwMsRQ2YXlT7UDQ4ICAy6BN9FVdljbzxspknAIJZisq17_9_-w8YbypBSGALCV47A"
        //TODO: Call API authorize get Token from Gotadi
        object.setup(partnerSetting:
                        GotadiPartnerSetting(
                            env: "uat",
                            partnername: "vib",
                            language: "vi", token: token, theme:.secondary))

    }

    @IBAction func actionFlutter(_ sender: Any) {
//        let object = IOSGotadiAdapter()
        object.pushToHomePartner(partnerViewController: self, handlePayment: {[weak self] gotadiViewController, bookingNumber in
            print(bookingNumber)
            if let paymentViewController  = self?.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as? PaymentViewController {
                paymentViewController.bookingNumberResult = bookingNumber
                gotadiViewController.navigationController?.pushViewController(paymentViewController, animated: true)
            }
        })


//        object.showDemoController(viewController: self)
    }
    @IBAction func showBookingDetail(_ sender: Any) {
//        object?.showBookingDetail(viewController: self)
        object.pushToMyBooking(viewController: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    

    @IBAction func onChangeTheme(_ sender: UISwitch) {
        
        if sender.isOn {
            object.config?.changeTheme(theme: .primary)
        } else {
            object.config?.changeTheme(theme: .secondary)
        }
        
    }
    
    
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count == 2
    }
}
