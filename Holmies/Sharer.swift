//
//  Sharer.swift
//  Holmies
//
//  Created by Leonardo Geus on 29/10/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import Foundation


public enum SharerType {
    case userToUser, userToGroup
}



class Sharer: NSObject {
    var owner:String!
    var receiverObject:AnyObject!
    var relation:SharerType!
    var id:String!
    var createdAt:String!
    var until:String!
    var updatedAt:String!
    var status:String!
    var receiver:String!
    var updater:String!
}
