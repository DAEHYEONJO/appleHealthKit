//
//  UIAlertController+Extension.swift
//  weltAppleHealthETL
//
//  Created by SangHyuk Lee on 2021/04/20.
//

import UIKit

extension UIAlertController {
    
    //MARK: - Alert with Message + OK Action
    class func alertWithMessage(_ title: String, _ message: String, handler: ((UIAlertAction?) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        return alert
    }
}
