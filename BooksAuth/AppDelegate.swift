//
//  AppDelegate.swift
//  BooksAuth
//
//  Created by Andrew R Madsen on 8/19/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import GTMAppAuth

let gtmAuthKeychainName = "BooksAuth-GTMAuthorization"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        loadGTMAuthState()
        
        return true
    }
    
    // MARK: - URL Handling
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if currentAuthorizationFlow?.resumeAuthorizationFlow(with: url) ?? false {
            currentAuthorizationFlow = nil
            return true
        }
        
        return false
    }
    
    // MARK: - Private
    
    private func loadGTMAuthState() {
        gtmAuthorization = GTMAppAuthFetcherAuthorization(fromKeychainForName: gtmAuthKeychainName)
    }
    
    private func saveGTMAuthState() {
        if let auth = gtmAuthorization {
            GTMAppAuthFetcherAuthorization.save(auth, toKeychainForName: gtmAuthKeychainName)
        } else {
            GTMAppAuthFetcherAuthorization.removeFromKeychain(forName: gtmAuthKeychainName)
        }
    }
    
    // MARK: - Properties
    
    var window: UIWindow?

    var currentAuthorizationFlow: OIDAuthorizationFlowSession?
    var gtmAuthorization: GTMAppAuthFetcherAuthorization? {
        didSet {
            saveGTMAuthState()
        }
    }
}

