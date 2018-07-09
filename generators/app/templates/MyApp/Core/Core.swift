import Foundation
import Alamofire
import SwiftyJSON

class Core : LoginDelegate {
    private let firebaseTokenDefault = "FirebaseToken"
    private let firebaseTokenIdDefault = "FirebaseTokenId"
    private let firebaseTokenConnectedWithUserDefault = "FirebaseTokenConnectedWithUser"

    let users : JhiUsers
    let baseUrl : String

    var token : String?

    init(users:JhiUsers, baseUrl: String){
        self.users = users
        self.baseUrl = baseUrl

        users.loginDelegate = self
    }

    func didReceiveFirebaseToken(token:String){
        if(token == loadFirebaseToken()){
            return
        }

        saveFirebaseTokenConnectedWithUser(enabled: false)

        guard let url = URL(string: baseUrl+"/api/firebase-tokens" ) else {
            return
        }
        let json = JSON([
            "token": token,
            ])

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let pjson = json.rawString(String.Encoding.utf8, options: .sortedKeys)

        request.httpBody = (pjson?.data(using: .utf8))! as Data

        Alamofire.request(request)
            .responseJSON { response in
                guard let value = response.result.value as? [String: Any] else {
                    print("Malformed data received from register token")
                    return
                }
                let json = JSON(value)
                guard let tokenId = json["id"].int else {
                    return
                }
                guard let token = json["token"].string else {
                    return
                }
                self.saveFirebaseToken(id:tokenId,token:token)
        }
    }
    private func saveFirebaseToken(id: Int, token:String){
        let defaults = UserDefaults.standard

        defaults.set(token, forKey: firebaseTokenDefault)
        defaults.set(id, forKey: firebaseTokenIdDefault)
    }
    private func loadFirebaseTokenConnectedWithUser() -> Bool{
        let defaults = UserDefaults.standard

        return defaults.bool(forKey: firebaseTokenConnectedWithUserDefault)
    }
    private func saveFirebaseTokenConnectedWithUser(enabled:Bool){
        let defaults = UserDefaults.standard

        defaults.set(token, forKey: firebaseTokenConnectedWithUserDefault)
    }
    private func loadFirebaseToken() -> String?{
        let defaults = UserDefaults.standard

        return defaults.string(forKey: firebaseTokenDefault)
    }
    private func loadFirebaseTokenId() -> Int{
        let defaults = UserDefaults.standard

        return defaults.integer(forKey: firebaseTokenIdDefault)
    }

    func loginDidSuccess(token: String) {
        self.token = token

        if let firebaseToken = loadFirebaseToken() {

            guard let url = URL(string: baseUrl+"/api/firebase-tokens" ) else {
                return
            }
            let json = JSON([
                "id": loadFirebaseTokenId(),
                "token": firebaseToken
                ])

            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.put.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer "+token, forHTTPHeaderField: "Authorization")

            let pjson = json.rawString(String.Encoding.utf8, options: .sortedKeys)

            request.httpBody = (pjson?.data(using: .utf8))! as Data

            Alamofire.request(request)
                .responseJSON { response in
                    guard let value = response.result.value as? [String: Any] else {
                        print("Malformed data received from register token")
                        return
                    }
                    let json = JSON(value)
                    if json["id"].int == nil || json["token"].string == nil {
                        return
                    }
                    self.saveFirebaseTokenConnectedWithUser(enabled: true)
            }
        }
    }
    func logoutDidSuccess() {
        self.token = nil
    }
}
