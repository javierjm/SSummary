
import Foundation
import Alamofire
import KeychainAccess
import SwiftyJSON

enum HTTPRequestAuthType {
    case HTTPBasicAuth
    case HTTPTokenAuth
}

enum HTTPRequestContentType {
    case HTTPJsonContent
    case HTTPMultipartContent
}

class HTTPHelper {

    static let sharedInstance = HTTPHelper()
    let clientID = "9511"
    let clientSecret = "ba59667445fdf41d77ce5aeff72592ce0c8f182f"
    let authUrl = "https://www.strava.com/oauth/authorize"
    let acessTokenUrl = "https://www.strava.com/oauth/token"
    let redirectUri = "ssummary://ssummary.com"
    let keychain = Keychain(service: "com.strava-token")

    var OAuthToken: String? {
        set {
            if let valueToSave = newValue {
                do {
                    try keychain.set(valueToSave, key: "token")
                }
                catch let error {
                    print(error)
                }
                addSessionHeader("Authorization", value: "token \(newValue)")
            } else{
                do {
                try keychain.removeAll()
                    removeSessionHeaderIfExists("Authorization")
                } catch let error {
                    print(error)
                }
            }
        }
        get {
            // try to load from keychain
            do {
                let token = try keychain.getString("token")
                return token
            } catch let error {
                print (error)
                removeSessionHeaderIfExists("Authorization")
                return nil
            }
        }
    }
 

    // handlers for the OAuth process
    // stored as vars since sometimes it requires a round trip to safari which
    // makes it hard to just keep a reference to it
    var OAuthTokenCompletionHandler:(NSError? -> Void)?
    
    func loadInitialData() {
        if (!HTTPHelper.sharedInstance.hasOAuthToken()) {
            
            HTTPHelper.sharedInstance.OAuthTokenCompletionHandler = {
                (error) -> Void in
                print("handlin stuff")
                if let receivedError = error {
                    print(receivedError)
                    // TODO: handle error
                    // TODO: issue: don't get unauthorized if we try this query
                    HTTPHelper.sharedInstance.startOAuth2Login()
                }
                else {
                    self.fetchMyActivities({ (fetchedRepos, error) -> Void in
                        print ("Got Activities")
                        if let gotErr = error {
                            print ("There was an error retrieving errors \(gotErr)")
                        } else {
                            print("Got Repos !!!!")
                        }
                    })                }
            }
            HTTPHelper.sharedInstance.startOAuth2Login()
        } else {
            fetchMyActivities({ (fetchedRepos, error) -> Void in
                print ("Got Activities")
                if let gotErr = error {
                    print ("There was an error retrieving errors \(gotErr)")
                } else {
                    print("Got Repos !!!!")
                }
            })
        }
    }

    func alamofireManager() -> Manager {
        let manager = Alamofire.Manager.sharedInstance
        // Read the Documentation for Additional Headers
        return manager
    }
    
    // MARK: - OAuth flow
    
    func hasOAuthToken() -> Bool {
        if let token = self.OAuthToken {
            return !token.isEmpty
        }
        return false
    }
    
    func startOAuth2Login() {
        // TODO: implement
        let authPath:String = "\(authUrl)?client_id=\(clientID)&response_type=code&scope=write&state=mystate&approval_prompt=force&redirect_uri=\(redirectUri)"
        
        if let authURL:NSURL = NSURL(string: authPath) {
            // do stuff with authURL
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(true, forKey: "loadingOAuthToken")
            
            UIApplication.sharedApplication().openURL(authURL)
        }
    }
    
    
    func processOAuthStep1Response(url: NSURL) {
        print("URL: \(url.absoluteString)")
        let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: false)
        var code:String?
        if let queryItems = components?.queryItems {
            for queryItem in queryItems {
                if (queryItem.name.lowercaseString == "code") {
                    code = queryItem.value
                    break
                }
            }
        }
        
        if let receivedCode = code {
            let getTokenPath:String = acessTokenUrl
            let tokenParams = ["client_id": clientID, "client_secret": clientSecret, "code": receivedCode]
            Alamofire.request(.POST, getTokenPath, parameters: tokenParams).responseString{response in
                    print(response.request)
                if let anError = response.result.error {
                    print(anError)
                    if let completionHandler = self.OAuthTokenCompletionHandler {
                        let noOAuthError = NSError(domain:"com.error.domain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not obtain an OAuth token", NSLocalizedRecoverySuggestionErrorKey: "Please retry your request"])
                        completionHandler(noOAuthError)
                    }
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setBool(false, forKey: "loadingOAuthToken")
                    return
                }
                
                print("Results: \(response.result)")
                
                if let receivedResults = response.result.value {
                    let resultParams:Array<String> = receivedResults.componentsSeparatedByString("&")
                    
                    for param in resultParams {
                        let resultsSplit = param.componentsSeparatedByString("=")
                        if (resultsSplit.count == 2) {
                            let key = resultsSplit[0].lowercaseString // access_token, scope, token_type
                            let value = resultsSplit[1]
                            switch key {
                            case "access_token":
                                self.OAuthToken = value
                            case "scope":
                                // TODO: verify scope
                                print("SET SCOPE")
                            case "token_type":
                                // TODO: verify is bearer
                                print("CHECK IF BEARER")
                            default:
                                print("got more than I expected from the OAuth token exchange")
                                print(key)
                                print(value)
                            }
                        }
                    }
                }
                
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setBool(false, forKey: "loadingOAuthToken")
                
                if self.hasOAuthToken() {
                    if let completionHandler = self.OAuthTokenCompletionHandler {
                        completionHandler(nil)
                    }
                } else {
                    if let completionHandler = self.OAuthTokenCompletionHandler {
                        let noOAuthError = NSError(domain: "com.error.domain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not obtain an OAuth token", NSLocalizedRecoverySuggestionErrorKey: "Please retry your request"])
                        completionHandler(noOAuthError)
                    }
                }
            }
    
        } else {
        // no code in URL that we launched with
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(false, forKey: "loadingOAuthToken")
        }
    }
    
    // MARK: Header Managers
    func addSessionHeader(key: String, value: String) {
        let manager = Alamofire.Manager.sharedInstance
        if var sessionHeaders = manager.session.configuration.HTTPAdditionalHeaders as? Dictionary<String, String> {
            sessionHeaders[key] = value
            manager.session.configuration.HTTPAdditionalHeaders = sessionHeaders
        } else {
            manager.session.configuration.HTTPAdditionalHeaders = [key: value]
        }
    }
    
    func removeSessionHeaderIfExists(key: String) {
        let manager = Alamofire.Manager.sharedInstance
        if var sessionHeaders = manager.session.configuration.HTTPAdditionalHeaders as? Dictionary<String, String> {
            sessionHeaders.removeValueForKey(key)
            manager.session.configuration.HTTPAdditionalHeaders = sessionHeaders
        }
    }
    
// MARK: API Access
    
    func fetchMyActivities(completionHandler: (Array<Activity>?, NSError?) -> Void) {
        let path = "https://www.strava.com/api/v3/athlete/activities"
        
        self.alamofireManager().request(.GET, path, parameters: ["per_page": "1"], encoding: ParameterEncoding.URL).responseJSON { (response) in
            debugPrint(response)
            print("Response.request is: \n \(response.request)")
            print("Response.response is: \n \(response.response)")
            print("Response.data is: \n \(response.data)")
            print("Response.result is: \n \(response.result)")
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    }
    
}
