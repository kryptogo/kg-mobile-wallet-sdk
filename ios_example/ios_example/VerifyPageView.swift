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
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = .darkGray
        textField.backgroundColor = .lightGray
        

        self.addSubview(textField)

        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: self.centerXAnchor), // 水平置中
            textField.centerYAnchor.constraint(equalTo: self.centerYAnchor), // 垂直置中
            textField.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 40), // 固定高度
            textField.widthAnchor.constraint(equalToConstant: 200) // 固定寬度
        ])
    }

    

    func getVerificationCode() -> String {
        return textField.text ?? ""
    }
}


#Preview {
    VerifyPageView()
}
