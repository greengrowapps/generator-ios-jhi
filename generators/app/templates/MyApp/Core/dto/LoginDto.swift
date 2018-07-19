//
//  LoginDto.swift
//  MyIosApp
//
//  Created by Adrian Sanchis Serrano on 18/7/18.
//  Copyright © 2018 Pablo Apellidos. All rights reserved.
//

import UIKit
import GGARest

class LoginRequestDto: JSonBaseObject {
    @objc dynamic var email : String = ""
    @objc dynamic var password : String = ""

    init(email:String,password:String) {
        self.email=email;
        self.password=password
    }
}
