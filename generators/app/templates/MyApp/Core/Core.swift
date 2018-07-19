import Foundation
import GGARest

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
        GGARest.ws()
        .post(url: baseUrl+"/api/firebase-tokens")
        .withJson(object: FirebaseTokenDto(token: token))
        .onSuccess(resultType: FirebaseTokenDto.self, objectListener: {(response:ObjectStorer,fullResponse:FullRepsonse) -> Void in
            let object = response.getObject(type: FirebaseTokenDto.self)
            self.saveFirebaseToken(id:object.id!.intValue,token:object.token);
        })
        .onOther(simpleListener: {(fullResponse:FullRepsonse) -> Void in
                
        })
        .execute()

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
            GGARest.ws()
                .post(url: baseUrl+"/api/firebase-tokens")
                .withJson(object: FirebaseTokenDto(token: firebaseToken, id:loadFirebaseTokenId()))
                .with(headers: ("Authorization","Bearer "+token))
                .onSuccess(resultType: FirebaseTokenDto.self, objectListener: {(response:ObjectStorer,fullResponse:FullRepsonse) -> Void in
                    let object = response.getObject(type: FirebaseTokenDto.self)
                    if(object.id != nil && object.token.count > 0){
                        self.saveFirebaseTokenConnectedWithUser(enabled: true)
                    }
                })
                .onOther(simpleListener: {(fullResponse:FullRepsonse) -> Void in
                    
                })
                .execute()
        }
    }
    func logoutDidSuccess() {
        self.token = nil
    }
}
