//
//  FirebaseTokenDto.swift
//  MyIosApp
//
//  Created by Adrian Sanchis Serrano on 19/7/18.
//  Copyright © 2018 Pablo Apellidos. All rights reserved.
//

import UIKit
import GGARest

class FirebaseTokenDto :JSonBaseObject {
    @objc dynamic var id : NSNumber?
    @objc dynamic var token : String = ""
    
    init(token:String) {
        self.token=token;
    }
    init(token:String,id:Int) {
        self.token=token;
        self.id=NSNumber(integerLiteral: id);
    }
}
