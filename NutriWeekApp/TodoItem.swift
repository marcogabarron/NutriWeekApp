//
//  ToDoItem.swift
//  NutriWeekApp
//
//  Created by Vítor Machado Rocha on 12/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import Foundation

struct TodoItem {
    var title: String
    var deadline: NSDate
    var UUID: String
    
    init(deadline: NSDate, title: String, UUID: String) {
        self.deadline = deadline
        self.title = title
        self.UUID = UUID
    }
    
    //Informa se a data da notificação já passou. Não vai acontecer, porque evitei isso na clsse Notifications.
    var isOverdue: Bool {
        return (NSDate().compare(self.deadline) == NSComparisonResult.OrderedDescending)
    }
}