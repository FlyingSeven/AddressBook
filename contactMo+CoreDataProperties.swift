//
//  contactMo+CoreDataProperties.swift
//  AddressBook
//
//  Created by Seven on 11/25/15.
//  Copyright © 2015 Seven. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension contactMo {

    @NSManaged var avatarImg: NSData?
    @NSManaged var gender: String?
    @NSManaged var name: String?
    @NSManaged var phoneNum: String?

}
