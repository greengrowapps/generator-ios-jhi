//
//  RegisterRequest.swift
//  MyIosApp
//
//  Created by Adrian Sanchis Serrano on 19/7/18.
//  Copyright © 2018 Pablo Apellidos. All rights reserved.
//

import UIKit
import GGARest

class RegisterRequestDto: JSonBaseObject {
    @objc dynamic var firstName : String = ""
    @objc dynamic var lastName : String = ""
    @objc dynamic var password : String = ""
    @objc dynamic var email : String = ""
    @objc dynamic var langKey : String = ""
    @objc dynamic var login : String = ""

    init(firstName : String, lastName : String, password : String, email : String, langKey : String, login : String) {
        super.init()
        self.firstName=firstName;
        self.lastName=lastName;
        self.password=password;
        self.email=email;
        self.langKey=langKey;
        self.login=login;
    }
}
