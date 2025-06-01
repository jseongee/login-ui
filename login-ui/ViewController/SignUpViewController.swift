import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        // 이름 필드 오토포커스
        nameField.becomeFirstResponder()
    }

    private func setupUI() {
        // 텍스트필드 스타일 설정
        [nameField, emailField, passwordField].forEach {
            $0?.layer.cornerRadius = 10
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.secondaryLabel.cgColor
        }
    }

    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        print("\("Forgot Password") button is tapped")
    }

    @IBAction func logInButtonTapped(_ sender: UIButton) {
        guard logInButton.isEnabled else { return }

        print("email: \(emailField.text ?? ""), password: \(passwordField.text ?? "")")
    }

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            // 이름 필드에서 Next -> 이메일 필드 포커스
        case nameField:
            emailField.becomeFirstResponder()
            // 이메일 필드에서 Next -> 비밀번호 필드 포커스
        case emailField:
            passwordField.becomeFirstResponder()
            // 비밀번호 필드에서 Done -> 로그인
        case passwordField:
            passwordField.resignFirstResponder()
            self.logInButtonTapped(logInButton)
        default:
            break
        }

        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let isValidName = validateName(nameField.text ?? "")
        let isValidEmail = validateEmail(emailField.text ?? "")
        let isValidPassword = validatePassword(passwordField.text ?? "")

        // 유효한 이름/이메일/비밀번호일 때만 로그인 버튼 활성화
        logInButton.isEnabled = isValidName && isValidEmail && isValidPassword
    }
}

// MARK: - Validation
extension SignUpViewController {
    // 이름 검사
    func validateName(_ name: String) -> Bool {
        return (2...5).contains(name.count)
    }

    // 이메일 검사
    func validateEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }

    // 비밀번호 검사
    // (?=.*[A-Za-z]): 대소문자 하나 이상
    // (?=.*\\d): 숫자 하나 이상
    // (?=.*[!@#$%^&*()_+=-]): 특수문자 하나 이상
    // {6,20}: 길이 6 ~ 20
    func validatePassword(_ password: String) -> Bool {
        let passwordRegEx = "^(?=.*[a-zA-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+=-]).{6,20}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegEx).evaluate(with: password)
    }
}
