import Foundation

class JhiUserDto {
    init(login:String?,email:String?,firstName:String?,lastName:String?,phoneNumber:String?){
        self.login=login;
        self.email=email;
        self.firstName=firstName;
        self.lastName=lastName;
        self.phoneNumber=phoneNumber;
    }
    var login: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var phoneNumber: String?
}
