//
//  ViewController.swift
//  BooksAuth
//
//  Created by Andrew R Madsen on 8/19/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import GTMAppAuth
import SafariServices

private let issuer = URL(string: "https://accounts.google.com")!
private let clientID = "644706638286-dknddjfp4hdqv2qebq8q5rci6bht20ou.apps.googleusercontent.com"
private let redirectURI = URL(string: "com.googleusercontent.apps.644706638286-dknddjfp4hdqv2qebq8q5rci6bht20ou:/oauthredirect")!
private let bookScopeURL = URL(string: "https://www.googleapis.com/auth/books")!

class ViewController: UIViewController {

    @IBAction func authorize(_ sender: Any) {
        OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) { (configuration, error) in
            if let error = error, configuration == nil {
                NSLog("Error retrieving discovery document: \(error)")
                return
            }
            guard let configuration = configuration else { return }
            
            // Create a request for authorization
            let authRequest = OIDAuthorizationRequest(configuration: configuration,
                                                      clientId: clientID,
                                                      scopes: [OIDScopeOpenID, OIDScopeProfile, bookScopeURL.absoluteString],
                                                      redirectURL: redirectURI,
                                                      responseType: OIDResponseTypeCode,
                                                      additionalParameters: nil)
            
            // Perform the request
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: authRequest, presenting: self) { (authState, error) in
                if let error = error, authState == nil {
                    NSLog("Authorization error: \(error)")
                    return
                }
                guard let authState = authState else {
                    appDelegate.gtmAuthorization = nil
                    return
                }
                appDelegate.gtmAuthorization = GTMAppAuthFetcherAuthorization(authState: authState)
            }
        }
    }
    
    @IBAction func fetchData(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let auth = appDelegate.gtmAuthorization else {
            NSLog("Need to authorize first")
            return
        }
        
        let url = URL(string: "https://www.googleapis.com/books/v1/mylibrary/bookshelves")!
        let request = NSMutableURLRequest(url: url)
        auth.authorizeRequest(request) { (error) in
            if let error = error {
                NSLog("Unable to authorize request: \(error)")
                return
            }
            
            URLSession.shared.dataTask(with: request as URLRequest) { (data, _, error) in
                if let error = error {
                    NSLog("Error getting bookshelves: \(error)")
                    return
                }
                guard let data = data else { return }
                
                if let json = String(data: data, encoding: .utf8) {
                    print(json)
                }
            }.resume()
        }
    }
    
}

