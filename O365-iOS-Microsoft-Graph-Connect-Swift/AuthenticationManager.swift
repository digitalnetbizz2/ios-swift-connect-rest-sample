/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

import Foundation

enum AuthenticationResult {
    case success
    case failure(ADAuthenticationError)
}


class AuthenticationManager {
    
    // MARK: Properties and variables
    // Singleton class
    class var sharedInstance: AuthenticationManager {
        struct Singleton {
            static let instance = AuthenticationManager()
        }
        // We need to know this ASAP if we get generate singleton.
        assert(Singleton.instance != nil)
        return Singleton.instance!
    }
    
    // Internal properties
    internal var accessToken: String?
    internal var userInformation: ADUserInformation?
    
    // Private properties
    fileprivate let context: ADAuthenticationContext!
    
    // MARK: Initializer
    init?() {
        var error: ADAuthenticationError?
        guard let context = ADAuthenticationContext(authority: AuthenticationConstants.Authority, error: &error) else {
            if let error = error {
                print(error.localizedDescription)
            }
            self.context = nil
            return nil
        }
        self.context = context
    }
    
    // MARK: Authentication methods
    //Acquire and store access token and user information.
    func acquireAuthToken(_ completion: ((AuthenticationResult) -> Void)?) {
        self.context.acquireToken(withResource: AuthenticationConstants.ResourceId,
                                  clientId: AuthenticationConstants.ClientId,
                                  redirectUri: AuthenticationConstants.RedirectUri) {
                                    [weak self] (result:ADAuthenticationResult?) in
                                    
                                    if let handler = completion {
                                        if result?.status == AD_SUCCEEDED {
                                            self?.accessToken = result?.accessToken
                                            self?.userInformation = result?.tokenCacheStoreItem.userInformation
                                            
                                            handler(AuthenticationResult.success)
                                        }
                                        else {
                                            if let error = result?.error {
                                                handler(AuthenticationResult.failure(error))
                                            }
                                        }
                                    }
        }
    }
    
    //Clears the ADAL token cache and the cookie cache.
    func clearCredentials() {
        // Remove all the cookies from this application's sandbox. The authorization code is stored in the
        // cookies and ADAL will try to get to access tokens based on the auth code in the cookie.
        let cookieStore = HTTPCookieStorage.shared
        if let cookies = cookieStore.cookies {
            for cookie in cookies {
                cookieStore.deleteCookie(cookie)
            }
        }
        
        var error: ADAuthenticationError?
        context.tokenCacheStore.removeAllWithError(&error)
        if let error = error {
            print(error )
        }
    }
    
}
