//
//  Sharer.swift
//  Holmies
//
//  Created by Leonardo Geus on 29/10/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import Foundation


public enum SharerType {
    case userToUser
    case userToGroup
}



class Sharer: NSObject {
    var owner:User!
    var receiverObject:AnyObject!
    var relation:SharerType!
    var id:String!
    var createdAt:String!
    var until:String!
    var updatedAt:String!
    
    var receiver:String!
}
