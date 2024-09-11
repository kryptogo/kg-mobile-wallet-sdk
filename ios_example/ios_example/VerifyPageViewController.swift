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
        verifyView.backgroundColor = .white // 设置 verifyView 的背景色

        self.view.addSubview(verifyView)
        
        // 设置 verifyPageView 的约束以全屏展示
        verifyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verifyView.topAnchor.constraint(equalTo: view.topAnchor),
            verifyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            verifyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            verifyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        // Add submit button and its action
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        verifyView.addSubview(submitButton) // Add button to verifyView instead of self.view
        
        // Adjust constraints for the submit button within verifyView
        NSLayoutConstraint.activate([
            submitButton.centerXAnchor.constraint(equalTo: verifyView.centerXAnchor),
            submitButton.bottomAnchor.constraint(equalTo: verifyView.bottomAnchor, constant: -200) // Adjust constant as needed
        ])
        
        submitButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
        
        // Set close button action
        verifyView.setCloseAction { [weak self] in
            self?.dismiss(animated: true) {
                self?.completion?(false)
            }
        }
    }
    
    @objc func submitAction() {
        let inputCode = verifyView.getVerificationCode()
        // Check the verification code here and close the view controller
        if (inputCode == "111111") {
            // Assuming you have a method to communicate back to Flutter
            communicateToFlutter(verificationSuccess: true)
        }
        else {
            let alertController = UIAlertController(title: "Error", message: "Invalid verification code", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
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
