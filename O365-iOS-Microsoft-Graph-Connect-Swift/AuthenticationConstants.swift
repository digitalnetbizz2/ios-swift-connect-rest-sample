/*
* Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
* See LICENSE in the project root for license information.
*/

import Foundation

// You'll set your application's ClientId and RedirectURI here. These values are provided by your Microsoft Azure app
//registration. See README.MD for more details.

struct AuthenticationConstants {

    static let ClientId    = "27583ca3-6297-4e3b-a656-4d4eae95ba7d"
    static let RedirectUri = URL.init(string: "https://login.microsoftonline.com/common/oauth2/nativeclient")
    static let Authority   = "https://login.microsoftonline.com/common"
    static let ResourceId  = "https://graph.microsoft.com"

}


