//
//  PasswordViewController.swift
//  MoviePlayer
//
//  Created by jack on 2023/8/20.
//

import Foundation

// 密码采用本地采用md5保存
class PasswordViewController: UIViewController {
    enum PageType {
        case PageTypeValid // 验证界面
        case PageTypeSet   // 输入界面
        case PageClean  // 清空密码
    }
    
    static let KEY_PRIVATE_PASSWORD = "private_password"
    
    let pageType: PageType
    
    init(pageType: PageType) {
        self.pageType = pageType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var passTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.returnKeyType = .done
        textField.isSecureTextEntry = true
//        textField.backgroundColor = .black
        textField.textColor = UIColor(rgb: 0xffffff, alpha: 0.7)
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.layer.borderWidth = 1
        textField.keyboardType = .asciiCapableNumberPad
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    // 右上角
    private lazy var closeBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private lazy var okBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("OK", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = pageType == .PageTypeValid ? "validate password" : "setup password"
        let colors: [CGColor] = [UIColor(red: 19/255.0, green: 41/255.0, blue: 75/255.0, alpha: 1).cgColor,
                                 UIColor(red: 5/255.0, green: 12/255.0, blue: 23/255.0, alpha: 1).cgColor]
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        
        self.view.addSubview(passTextField)
        passTextField.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(30)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-100)
        }
        
        self.view.addSubview(closeBtn)
        closeBtn.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.right.top.equalTo(0)
        }
        
        self.view.addSubview(okBtn)
        okBtn.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.top.equalTo(passTextField).offset(40)
            make.centerX.equalToSuperview()
        }
        
        closeBtn.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        okBtn.addTarget(self, action: #selector(handleOKActio), for: .touchUpInside)
        
        passTextField.delegate = self
        passTextField.becomeFirstResponder()
        
        if self.pageType == .PageTypeValid {
            closeBtn.isHidden = true
        }
    }
    
    @objc func handleClose() {
        self.dismiss(animated: true)
    }
    
    @objc func handleOKActio() {
        guard let password = self.passTextField.text,
              password.count > 0,
              let md5String = password.ss_md5(),
              md5String.count > 0 else {
            Toast(text: "Please input some charactor.", duration: Delay.long).showToast()
            return
        }
        
        if self.pageType == .PageTypeSet {
            UserDefaults.standard.set(md5String, forKey: PasswordViewController.KEY_PRIVATE_PASSWORD)
            UserDefaults.standard.synchronize()
            Toast(text: "Password set successfully.", duration: Delay.long).showToast()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dismiss(animated: true)
            }
        } else if self.pageType == .PageTypeValid {
            if let savedPass = UserDefaults.standard.value(forKey: PasswordViewController.KEY_PRIVATE_PASSWORD) as? String {
                if savedPass != md5String {
                    // 验证失败，请重新输入
                    Toast(text: "Password authentication failed.", duration: Delay.long).showToast()
                    return
                }
                self.dismiss(animated: true)
            }
        } else {
            if let savedPass = UserDefaults.standard.value(forKey: PasswordViewController.KEY_PRIVATE_PASSWORD) as? String {
                if savedPass != md5String {
                    // 验证失败，请重新输入
                    Toast(text: "Password clean successfully.", duration: Delay.long).showToast()
                    return
                }
                UserDefaults.standard.set("", forKey: PasswordViewController.KEY_PRIVATE_PASSWORD)
                UserDefaults.standard.synchronize()
                self.dismiss(animated: true)
            }
        }
    }
}

extension PasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleOKActio()
        return true
    }
}

extension Toast {
    func showToast() {
        self.view.useSafeAreaForBottomOffset = true
        self.view.bottomOffsetPortrait = 350
        self.view.font = UIFont.systemFont(ofSize: 18)
        self.show()
    }
}
