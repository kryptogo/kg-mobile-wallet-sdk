import SwiftUI
import UIKit

class VerifyPageView: UIView {
    // MARK: - Properties
    private let textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.placeholder = "Enter verification code"
        tf.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        tf.textColor = .darkText
        tf.backgroundColor = .systemBackground
        tf.layer.cornerRadius = 8
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.systemGray4.cgColor
        tf.textAlignment = .center
        tf.keyboardType = .numberPad
        return tf
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Verification"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .systemBackground
        
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(closeButton)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            textField.centerXAnchor.constraint(equalTo: centerXAnchor),
            textField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            textField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // MARK: - Actions
    @objc private func submitTapped() {
        // Handle submit action here
        print("Verification code submitted: \(getVerificationCode())")
    }

    // MARK: - Public Methods
    func getVerificationCode() -> String {
        return textField.text ?? ""
    }
    
    func setCloseAction(_ action: @escaping () -> Void) {
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeAction = action
    }
    
    // MARK: - Private Methods
    private var closeAction: (() -> Void)?
    
    @objc private func closeButtonTapped() {
        closeAction?()
    }
}

// MARK: - SwiftUI Preview
#if DEBUG
import SwiftUI

struct VerifyPageView_Preview: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            VerifyPageView()
        }
        .previewLayout(.sizeThatFits)
        .padding()
        .previewDisplayName("VerifyPageView")
    }
}

struct UIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View
    
    init(_ builder: @escaping () -> View) {
        view = builder()
    }
    
    func makeUIView(context: Context) -> some UIView {
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // No-op
    }
}
#endif
