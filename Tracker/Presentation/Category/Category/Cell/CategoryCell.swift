import UIKit

final class CategoryCell: UITableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        layer.cornerRadius = 0
        layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMinXMaxYCorner,
            .layerMaxXMinYCorner,
            .layerMaxXMaxYCorner
        ]
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
