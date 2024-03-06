//
//  VerifyPageView.swift
//  twmwallet
//
//  Created by dora on 2024/2/27.
//

import Foundation
import UIKit

class VerifyPageView: UIView {
    private var textField: UITextField!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter verification code"

        self.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: self.topAnchor),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    func getVerificationCode() -> String {
        return textField.text ?? ""
    }
}


#Preview {
    VerifyPageView()
}
