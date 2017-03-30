//
//  Groups.swift
//  Holmies
//
//  Created by Leonardo Geus on 30/09/15.
//  Copyright © 2015 Leonardo Geus. All rights reserved.
//

import UIKit

class Group: NSObject {
    var createdAt:String!
    var id:String!
    var name:String!
    var photo:String!
    var updateAt:String!
    var users:[User]!
    var share:Sharer!
}
