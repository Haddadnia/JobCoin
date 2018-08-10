import UIKit

class LoginViewController: UIViewController {

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        setupSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = Strings.projectName
        addressEntryTextField.becomeFirstResponder()
    }

    // MARK: - View Management

    func setupSubviews() {
        view.addSubview(loginButton)
        view.addSubview(addressEntryTextField)

        addressEntryTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        addressEntryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        addressEntryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        addressEntryTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true

        loginButton.topAnchor.constraint(equalTo: addressEntryTextField.bottomAnchor, constant: 10).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40)
    }

    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Color.brand
        button.setTitleColor(UIColor.gray, for: .selected)
        button.setTitle(Strings.login, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(userDidTapLoginButton), for: .touchUpInside)
        return button
    }()

    private lazy var addressEntryTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.placeholder = Strings.enterAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    // MARK: - Button Handling
    @objc private func userDidTapLoginButton() {
        guard let address = addressEntryTextField.text, address != "" else {
            // DISPLAY ERROR
            addressEntryTextField.text = "You need an address!"
            return
        }
        Networker.getAddress(address, completion: { [weak self] profile, error in
            guard let strongSelf = self else { return }
            if let profile = profile {
                let viewController = PortalViewController(address: address, profile: profile)
                viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: Strings.logout, style: .plain, target: strongSelf, action: #selector(strongSelf.userDidTapLogoutButton))

                let nav = UINavigationController(rootViewController: viewController)

                DispatchQueue.main.async { [weak self] in
                    self?.navigationController?.present(nav,
                                                             animated: true,
                                                             completion: nil)
                }
            } else {
                // DISPLAY ERROR
                strongSelf.addressEntryTextField.text = "ERROR"
            }
        })
    }
    @objc private func userDidTapLogoutButton() {
        addressEntryTextField.text = nil
        navigationController?.dismiss(animated: true, completion: nil)
    }
}

