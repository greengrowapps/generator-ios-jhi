import Foundation
import GGARest

class JhiUserDto : JSonBaseObject {
    @objc dynamic var login: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var phoneNumber: String = ""
}
