import UIKit

class HomePageViewController: UIViewController {
    
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupLayout()
    }
    
    private func setupNavigationBar() {
        let profileButton = UIButton(type: .system)
        profileButton.setTitle("Profile", for: .normal)
        profileButton.layer.cornerRadius = 20
        profileButton.layer.borderWidth = 1
        profileButton.layer.borderColor = UIColor.gray.cgColor
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem(customView: profileButton)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    private func setupLayout() {
        let welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome to the Home Page"
        welcomeLabel.textAlignment = .center
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let webviewButton = UIButton(type: .system)
        webviewButton.setTitle("Open Webview", for: .normal)
        webviewButton.layer.cornerRadius = 20
        webviewButton.layer.borderWidth = 1
        webviewButton.layer.borderColor = UIColor.gray.cgColor
        webviewButton.addTarget(self, action: #selector(openWebview), for: .touchUpInside)
        webviewButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(welcomeLabel)
        view.addSubview(webviewButton)
        
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            webviewButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            webviewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc private func openWebview() {
        let webviewVC = WebviewViewController()  // Create a new view controller for Webview
        navigationController?.pushViewController(webviewVC, animated: true)
    }
    
    @objc private func profileButtonTapped() {
        let profileViewController = ProfileViewController()
        profileViewController.username = username
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}
