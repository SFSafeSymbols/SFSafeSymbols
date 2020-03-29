#if canImport(UIKit) && (os(iOS) || targetEnvironment(macCatalyst))

import UIKit

@available(iOS 13.0, *)
public extension UIButton {
    
    class func systemButton(with symbol: SFSymbol, target: Any?, action: Selector?) -> Self {
        let symbol = UIImage(systemSymbol: symbol)
        return self.systemButton(with: symbol, target: target, action: action)
    }
    
    func setImage(with symbol: SFSymbol, for state: UIControl.State) {
        let symbol = UIImage(systemSymbol: symbol)
        self.setImage(symbol, for: state)
    }
    
}
#endif
