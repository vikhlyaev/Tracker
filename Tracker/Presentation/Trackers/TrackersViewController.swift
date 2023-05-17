import UIKit

final class TrackersViewController: UIViewController {
    
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

extension TrackersViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }
    
}

