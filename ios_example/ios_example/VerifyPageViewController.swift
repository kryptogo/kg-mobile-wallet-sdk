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
        verifyView.translatesAutoresizingMaskIntoConstraints = false
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
    }

    @objc func submitAction() {
        // Check the verification code here and close the view controller
        // For example, assume verification is always successful
        let verificationSuccess = true // Or some logic to validate the verification code

        // Assuming you have a method to communicate back to Flutter
        communicateToFlutter(verificationSuccess: verificationSuccess)
    }

    func communicateToFlutter(verificationSuccess: Bool) {
       completion?(verificationSuccess)
    }
}
