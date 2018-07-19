import Foundation
import GGARest

enum RegisterStatus{
    case SUCCESS
    case ERROR
    case ALREADY_EXISTS
}

protocol LoginDelegate{
    func loginDidSuccess(token:String)
    func logoutDidSuccess()
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

    public var loginDelegate : LoginDelegate?

    private let api: JhiUsersApi
    private var token: String?
    private var user: JhiUserDto?
    private var keepLogin: Bool

    init(api: JhiUsersApi, keepLogin: Bool){
        self.api = api
        self.keepLogin = keepLogin
    }

    func login(email: String, password: String, completion: @escaping (Bool,String) -> Void) {
        GGARest.ws()
        .post(url: api.loginUrl())
        .withJson(object: LoginRequestDto(username:email,password:password))
        .onSuccess(resultType: LoginResponseDto.self, objectListener: {(objectStorer:ObjectStorer,fullResponse:FullRepsonse)-> Void in
            let object=objectStorer.getObject(type: LoginResponseDto.self);
            if(object.id_token.count <= 0){
                completion(false,"Bad credentials")
                return;
            }
            self.token = object.id_token
            self.loginDelegate?.loginDidSuccess(token: object.id_token)
            
            if(self.keepLogin){
                self.saveUsernameAndPassword(username:email,password:password)
            }
            completion(true,"")
        }).onResponse(code: 401, simpleListener: {(fullRepsonse:FullRepsonse)-> Void in
            completion(false,"Bad credentials")
        })
        .onOther(simpleListener: {(fullRepsonse:FullRepsonse)-> Void in
            completion(false,"Server error")
        })
        .execute()
        
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
        GGARest.ws()
            .post(url: api.loginWithGoogleUrl())
            .withJson(object: token)
            .onSuccess(resultType: LoginResponseDto.self, objectListener: {(objectStorer:ObjectStorer,fullResponse:FullRepsonse)-> Void in
                let object=objectStorer.getObject(type: LoginResponseDto.self);
                if(object.id_token.count <= 0){
                    completion(false,"Bad credentials")
                    return;
                }
                self.token = object.id_token
                self.saveGoogleLogin(self.keepLogin)
                completion(true,"")
            }).onResponse(code: 401, simpleListener: {(fullRepsonse:FullRepsonse)-> Void in
                completion(false,"Bad credentials")
            })
            .onOther(simpleListener: {(fullRepsonse:FullRepsonse)-> Void in
                completion(false,"Server error")
            })
            .execute()
    }

    func loginWithFacebook(token: String, completion: @escaping (Bool,String) -> Void) {
        GGARest.ws()
            .post(url: api.loginWithFacebookUrl())
            .withJson(object: token)
            .onSuccess(resultType: LoginResponseDto.self, objectListener: {(objectStorer:ObjectStorer,fullResponse:FullRepsonse)-> Void in
                let object=objectStorer.getObject(type: LoginResponseDto.self);
                if(object.id_token.count <= 0){
                    completion(false,"Bad credentials")
                    return;
                }
                self.token = object.id_token
                self.saveFacebookLogin(self.keepLogin)
                completion(true,"")
            }).onResponse(code: 401, simpleListener: {(fullRepsonse:FullRepsonse)-> Void in
                completion(false,"Bad credentials")
            })
            .onOther(simpleListener: {(fullRepsonse:FullRepsonse)-> Void in
                completion(false,"Server error")
            })
            .execute()
    }
    func register(email: String, firstName: String, lastName: String, password: String, langKey: String, completion: @escaping (RegisterStatus) -> Void) {
  
        let registerObject = RegisterRequestDto(firstName: firstName, lastName: lastName, password: password, email: email, langKey: langKey, login: email);
        GGARest.ws()
        .post(url: api.registerUrl())
        .withJson(object: registerObject)
        .onResponse(code: 201, simpleListener: {(fullRepsonse:FullRepsonse)-> Void in
            completion(RegisterStatus.SUCCESS)
        })
        .onResponse(code: 400, resultType: String.self, objectListener: {(storer:ObjectStorer,response:FullRepsonse) -> Void in
            completion(RegisterStatus.ALREADY_EXISTS)
        })
        .onOther(simpleListener: {(fullRepsonse:FullRepsonse)-> Void in
            completion(RegisterStatus.ERROR)
        })
        .execute();
    }
    func recoverPassword(email: String, completion: @escaping (Bool) -> Void) {
        GGARest.ws()
        .post(url: api.recoverPasswordUrl())
        .onSuccess(simpleListener:{(fullRepsonse:FullRepsonse)-> Void in
            completion(true)
        }).onOther(simpleListener:{(fullRepsonse:FullRepsonse)-> Void in
            completion(false)
        }).execute();
    }
    
    func changePassword(password: String, completion: @escaping (Bool) -> Void) {
        GGARest.ws()
            .post(url: api.accountUrl())
            .withPlainText(text: password)
            .with(headers: ("Authorization","Bearer "+(token ?? "")))
            .onSuccess(simpleListener:{(fullRepsonse:FullRepsonse)-> Void in
                completion(true)
            }).onOther(simpleListener:{(fullRepsonse:FullRepsonse)-> Void in
                completion(false)
            }).execute();
    }
    
    func loadUser(completion: @escaping (JhiUserDto?) -> Void) {
        GGARest.ws()
        .get(url: api.accountUrl())
        .with(headers: ("Authorization","Bearer "+(token ?? "")))
        .onSuccess(resultType: JhiUserDto.self, objectListener: {(objectStorer:ObjectStorer,fullResponse:FullRepsonse)-> Void in
            let object = objectStorer.getObject(type: JhiUserDto.self);
            self.user = object
            completion(object)
        })
        .onOther(simpleListener: {(fullRepsonse:FullRepsonse)-> Void in
            completion(nil)
        })
        .execute()
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
        self.loginDelegate?.logoutDidSuccess()
    }


}
