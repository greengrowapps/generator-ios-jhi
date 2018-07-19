//
//  LoginRequestDto.swift
//  MyIosApp
//
//  Created by Adrian Sanchis Serrano on 18/7/18.
//  Copyright © 2018 Pablo Apellidos. All rights reserved.
//

import UIKit
import GGARest

class LoginRequestDto: JSonBaseObject {
    @objc dynamic var username : String = ""
    @objc dynamic var password : String = ""
    
    init(username:String,password:String) {
        self.username=username;
        self.password=password
    }
}
