//
//  JhiUsers.swift
//  <%= appName %>
//
//  Created by Pablo Apellidos on 8/6/18.
//  Copyright © 2018 Pablo Apellidos. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum RegisterStatus{
    case SUCCESS
    case ERROR
    case ALREADY_EXISTS
}

class JhiUsersApi{
    let baseUrl : String!

    init(baseUrl: String!){
        self.baseUrl = baseUrl
    }

    func loginUrl() -> String!{
        return baseUrl+"/api/authenticate"
    }

    func accountUrl() -> String!{
        return baseUrl+"/api/account"
    }

    func registerUrl() -> String!{
        return baseUrl+"/api/register"
    }

    func changePasswordUrl() -> String!{
        return baseUrl+"/api/account/change-password"
    }

    func recoverPasswordUrl() -> String!{
        return baseUrl+"/api/account/reset-password/init"
    }

    func loginWithGoogleUrl() -> String!{
        return baseUrl+"/api/authenticate/appGoogle"
    }

    func loginWithFacebookUrl() -> String!{
        return baseUrl+"/api/authenticate/appFacebook"
    }
}

class JhiUsers{

    private let usernameDefault = "JhiUsername";
    private let passwordDefault = "JhiPassword";
    private let googleSavedDefault = "JhiGoogleSaved";
    private let facebookSavedDefault = "JhiFacebookSaved";


    private let api: JhiUsersApi
    private var token: String?
    private var user: JhiUserDto?
    private var keepLogin: Bool

    init(api: JhiUsersApi, keepLogin: Bool){
        self.api = api
        self.keepLogin = keepLogin
    }

    func login(email: String, password: String, completion: @escaping (Bool,String) -> Void) {
        guard let url = URL(string: api.loginUrl() ) else {
            completion(false,"")
            return
        }
        let json = JSON([
            "username": email,
            "password": password
            ])

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let pjson = json.rawString(String.Encoding.utf8, options: .sortedKeys)

        request.httpBody = (pjson?.data(using: .utf8))! as Data

        Alamofire.request(request)
            .responseJSON { response in
                guard let value = response.result.value as? [String: Any] else {
                        print("Malformed data received from login")
                        completion(false,"Server error")
                        return
                }
                let json = JSON(value)
                let responseStatus = json["status"].int;
                guard responseStatus==nil else {
                    guard let message = json["detail"].string else {
                        completion(false,"Server error")
                        print("Error while login: \(String(describing: response.result.error))")
                        return
                    }
                    completion(false,message)
                    return
                }

                guard let token = json["id_token"].string else {
                        completion(false,"Bad credentials")
                        return
                }
                self.token = token

                if(self.keepLogin){
                    self.saveUsernameAndPassword(username:email,password:password)
                }

                completion(true,"")
        }
    }
    func autoLogin(completion: @escaping (Bool,String) -> Void) {
        let defaults = UserDefaults.standard;
        let username = defaults.string(forKey: usernameDefault)
        let password = defaults.string(forKey: passwordDefault)

        login(email: username ?? "", password: password ?? "", completion: completion)
    }


    private func saveUsernameAndPassword(username:String?,password:String?){
        let defaults = UserDefaults.standard

        defaults.set(username, forKey: usernameDefault)
        defaults.set(password, forKey: passwordDefault)
    }
    private func saveGoogleLogin(_ enabled: Bool){
        let defaults = UserDefaults.standard

        defaults.set(enabled, forKey: googleSavedDefault)
    }
    private func saveFacebookLogin(_ enabled: Bool){
        let defaults = UserDefaults.standard

        defaults.set(enabled, forKey: facebookSavedDefault)
    }

    func loginWithGoogle(token: String, completion: @escaping (Bool,String) -> Void) {
        guard let url = URL(string: api.loginWithGoogleUrl() ) else {
            completion(false,"")
            return
        }
        let json = JSON(token)

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let pjson = json.rawString(String.Encoding.utf8, options: .sortedKeys)

        request.httpBody = (pjson?.data(using: .utf8))! as Data

        Alamofire.request(request)
            .responseJSON { response in
                guard let value = response.result.value as? [String: Any] else {
                    print("Malformed data received from login")
                    completion(false,"Server error")
                    return
                }
                let json = JSON(value)
                guard let token = json["id_token"].string else {
                    completion(false,"Bad credentials")
                    return
                }
                self.token = token
                self.saveGoogleLogin(self.keepLogin)
                completion(true,"")
        }
    }

    func loginWithFacebook(token: String, completion: @escaping (Bool,String) -> Void) {
        guard let url = URL(string: api.loginWithFacebookUrl()) else {
            completion(false,"")
            return
        }
        let json = JSON(token)

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let pjson = json.rawString(String.Encoding.utf8, options: .sortedKeys)

        request.httpBody = (pjson?.data(using: .utf8))! as Data

        Alamofire.request(request)
            .responseJSON { response in
                guard let value = response.result.value as? [String: Any] else {
                    print("Malformed data received from login")
                    completion(false,"Server error")
                    return
                }
                let json = JSON(value)
                guard let token = json["id_token"].string else {
                    completion(false,"Bad credentials")
                    return
                }
                self.token = token
                self.saveFacebookLogin(self.keepLogin)
                completion(true,"")
        }
    }
    func register(email: String, firstName: String, lastName: String, password: String, langKey: String, completion: @escaping (RegisterStatus) -> Void) {
        guard let url = URL(string: api.registerUrl()) else {
            completion(RegisterStatus.ERROR)
            return
        }
        let json = JSON([
            "firstName": firstName,
            "lastName": lastName,
            "password": password,
            "email": email,
            "langKey": langKey,
            "login": email
            ])



        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let pjson = json.rawString(String.Encoding.utf8, options: .sortedKeys)

        request.httpBody = (pjson?.data(using: .utf8))! as Data

        Alamofire.request(request)
            .responseJSON { response in
                guard let statusCode = response.response?.statusCode else {
                    completion(RegisterStatus.ERROR)
                    return
                }

                if(statusCode==201){
                    completion(RegisterStatus.SUCCESS)
                    return
                }

                guard let value = response.result.value as? [String: Any] else {
                    print("Malformed data received from register")
                    completion(RegisterStatus.ERROR)
                    return
                }
                let json = JSON(value)
                let responseStatus = json["status"].int;
                guard responseStatus==nil else {
                    guard let errorKey = json["errorKey"].string else {
                        completion(RegisterStatus.ERROR)
                        print("Error while register: \(String(describing: response.result.error))")
                        return
                    }
                    completion(errorKey=="userexists" ? RegisterStatus.ALREADY_EXISTS : RegisterStatus.ERROR)
                    return
                }
                completion(RegisterStatus.ERROR)
        }
    }
    func recoverPassword(email: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: api.recoverPasswordUrl()) else {
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("text/plain;charset=UTF-8", forHTTPHeaderField: "Content-Type")

        request.httpBody = (email.data(using: .utf8))! as Data

        Alamofire.request(request)
            .responseJSON { response in
                guard let statusCode = response.response?.statusCode else {
                    completion(false)
                    return
                }

                if(statusCode==200){
                    completion(true)
                    return
                }

                completion(false)
        }
    }
    func changePassword(password: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: api.changePasswordUrl()) else {
            completion(false)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("text/plain;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer "+(token ?? ""), forHTTPHeaderField: "Authorization")

        request.httpBody = (password.data(using: .utf8))! as Data

        Alamofire.request(request)
            .response { response in
                guard let statusCode = response.response?.statusCode else {
                    completion(false)
                    return
                }

                if(statusCode==200){
                    completion(true)
                    return
                }

                completion(false)
        }
    }
    func loadUser(completion: @escaping (JhiUserDto?) -> Void) {
        guard let url = URL(string: api.accountUrl() ) else {
            completion(nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer "+(token ?? ""), forHTTPHeaderField: "Authorization")

        Alamofire.request(request)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while login: \(String(describing: response.result.error))")
                    completion(nil)
                    return
                }

                guard let value = response.result.value as? [String: Any]
                     else {
                        print("Malformed data received from login")
                        completion(nil)
                        return
                }

                let json = JSON(value)
                let user = JhiUserDto( login: json["login"].string,
                                       email: json["email"].string,
                                       firstName: json["firstName"].string,
                                       lastName: json["lastName"].string,
                                       phoneNumber: nil)

                self.user = user
                completion(user)
        }
    }
    func isLoginSaved() -> Bool {

        let defaults = UserDefaults.standard;

        let username = defaults.string(forKey: usernameDefault)
        let password = defaults.string(forKey: passwordDefault)

        return username != nil && password != nil
    }
    func isFacebookLoginSaved() -> Bool {
        return UserDefaults.standard.bool(forKey: facebookSavedDefault)
    }
    func isGoogleLoginSaved() -> Bool {
        return UserDefaults.standard.bool(forKey: googleSavedDefault)
    }
    func isLogedIn() -> Bool{
        return token != nil;
    }
    func logout(){
        saveUsernameAndPassword(username: nil, password: nil)
        saveGoogleLogin(false)
        saveFacebookLogin(false)
        token = nil;
    }


}
