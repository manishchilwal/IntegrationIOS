import UIKit
import CleverTapSDK

class SignupViewController: UIViewController {
    
    // Define UI elements
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email Address"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Phone Number"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .phonePad
        return textField
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    private func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [nameTextField, emailTextField, usernameTextField, phoneTextField, signupButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func signupButtonTapped() {
        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let username = usernameTextField.text,
              let phone = phoneTextField.text else { return }
        
        // Create the profile dictionary
        let profile: [String: AnyObject] = [
            "Name": name as AnyObject,
            "Email": email as AnyObject,
            "Identity": username as AnyObject,
            "Phone": phone as AnyObject
        ]
        
        // Send data to CleverTap
        CleverTap.sharedInstance()?.onUserLogin(profile)
        
        // Navigate to the Home Page
        navigateToHomePage(username: username)
    }
    
    private func navigateToHomePage(username: String) {
        let homePageViewController = HomePageViewController()
        homePageViewController.username = username // Pass username
        navigationController?.pushViewController(homePageViewController, animated: true)
    }
}
