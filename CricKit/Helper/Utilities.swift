//
//  Utilities.swift
//  CricKit
//
//  Created by Qaisar Raza on 26/08/23.
//

import Foundation
import UIKit

final class Utilities {
    
    static let shared = Utilities()
    private init() {}
    
    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        ///getting the all scenes
        let scenes = UIApplication.shared.connectedScenes
        ///getting windowScene from scenes
        let windowScene = scenes.first as? UIWindowScene
        ///getting window from windowScene
        let window = windowScene?.windows.first
        ///getting the root view controller
        let rootVC = window?.rootViewController
        let controller = controller ?? rootVC
        
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
