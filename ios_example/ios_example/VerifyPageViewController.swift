import UIKit

class VerifyPageViewController: UIViewController {
    var verifyView: VerifyPageView!
    var completion: ((Bool) -> Void)? // Add this line
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        // Initialize and set up the verify view
        verifyView = VerifyPageView()
        verifyView.backgroundColor = .white
        self.view.addSubview(verifyView)
        
        // 設置 verifyView 的約束，讓它不是全屏顯示
        verifyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verifyView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            verifyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            verifyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            verifyView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier:1) // 設置高度為視圖高度的 70%
        ])
        
        // 設置 submitButton 的動作
        verifyView.setSubmitAction { [weak self] in
            self?.submitAction()
        }
        
        // Set close button action
        verifyView.setCloseAction { [weak self] in
            self?.dismiss(animated: true) {
                self?.completion?(false)
            }
        }
    }
    
    @objc private func submitAction() {
        let inputCode = verifyView.getVerificationCode()
        // 檢查驗證碼並關閉視圖控制器
        if inputCode == "111111" {
            // 假設你有一個方法來與 Flutter 通信
            communicateToFlutter(verificationSuccess: true)
        } else {
            let alertController = UIAlertController(title: "錯誤", message: "無效的驗證碼", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func communicateToFlutter(verificationSuccess: Bool) {
        completion?(verificationSuccess)
    }
}
