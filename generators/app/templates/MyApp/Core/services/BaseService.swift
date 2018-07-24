//
//  BaseService.swift
//  MyIosApp
//
//  Created by Adrian Sanchis Serrano on 23/7/18.
//  Copyright © 2018 Pablo Apellidos. All rights reserved.
//

import UIKit
import GGARest;

protocol IbaseUrl {
    func url()-> String;
}

class BaseService<T:BaseEntity> :IbaseUrl {
    
    required func url() -> String {
        return "";
    }
    

    
    
    public func entityUrl() -> String{
        return "http://";
    }

    func list(onOk: @escaping(Array<T>) -> Void ){
        GGARest.ws()
        .get(url: self.entityUrl())
            .onSuccess(resultType: Array<T>.self, objectListener: {(storer:ObjectStorer,response:FullRepsonse)-> Void in
                onOk(storer.getObject(type: Array<T>.self))
        }).onOther(simpleListener: {(resp:FullRepsonse)-> Void in
                
        }).execute();
    }
}
