//
//  LoginResponseDto.swift
//  MyIosApp
//
//  Created by Adrian Sanchis Serrano on 18/7/18.
//  Copyright © 2018 Pablo Apellidos. All rights reserved.
//

import UIKit
import GGARest

class LoginResponseDto: JSonBaseObject {
    @objc dynamic var id_token : String = ""
}
