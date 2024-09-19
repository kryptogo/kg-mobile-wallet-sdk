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
    
    private let subTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Verification code is 111111"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .gray
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
    
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit", for: .normal)
        return button
    }()
    
    private var submitAction: (() -> Void)?
    
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
        addSubview(subTitle)
        addSubview(textField)
        addSubview(closeButton)
        addSubview(submitButton)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            textField.centerXAnchor.constraint(equalTo: centerXAnchor),
            textField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            textField.heightAnchor.constraint(equalToConstant: 50),
            
            submitButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 200),
            submitButton.heightAnchor.constraint(equalToConstant: 44),
            submitButton.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -20) // 確保按鈕不會太靠近底部
        ])
    }
    
    // MARK: - Actions
    @objc private func submitTapped() {
        // Handle submit action here
        print("Verification code submitted: \(getVerificationCode())")
    }

    @objc private func submitButtonTapped() {
        submitAction?()
    }

    // MARK: - Public Methods
    func getVerificationCode() -> String {
        return textField.text ?? ""
    }
    
    func setCloseAction(_ action: @escaping () -> Void) {
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeAction = action
    }
    
    func setSubmitAction(_ action: @escaping () -> Void) {
        submitAction = action
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
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
