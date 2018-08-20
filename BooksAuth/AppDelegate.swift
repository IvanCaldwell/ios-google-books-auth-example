//
//  AppDelegate.swift
//  BooksAuth
//
//  Created by Andrew R Madsen on 8/19/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
    
    // MARK: - URL Handling
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return GoogleBooksAuthorizationClient.shared.resumeAuthorizationFlow(with: url)
    }
    
    // MARK: - Properties
    
    var window: UIWindow?
}

