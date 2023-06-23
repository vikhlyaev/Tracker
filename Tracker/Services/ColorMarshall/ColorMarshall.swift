import UIKit

protocol ColorMarshall {
    func encode(color: UIColor) -> String
    func decode(hexColor: String) -> UIColor
}
