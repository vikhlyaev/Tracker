import UIKit

final class ViewController: UIViewController {
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setConstraints()
    }
    
    // MARK: - Setup UI
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
}

// MARK: - Setting Constraints

extension ViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }
    
}

