//
//  Notifications.swift
//  NutriWeekApp
//
//  Created by Vítor Machado Rocha on 13/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import Foundation

class Notifications {
    
    
    let day: NSTimeInterval = 60*60*24
    
    /** Recebe a array com dias da semana listados e a hora escolhida no PickerDate. 
    Através do dia da semana, constrói  as notifications de cada dia, com horários iguais, e coloca em uma Array **/
    func listNotifications (diaDaSemana: String, dateHour: String) -> (NSDate) {
        
        ///Lista com as datas de cada dia da semana, já com o horário certo
        var listOfDates = Array<NSDate>()
        
        // Obtendo o dia da semana atual
        let currentDate = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.CalendarUnitWeekday, fromDate: currentDate)
        let weekDay = myComponents.weekday
        
        var currentAdded: NSDate?
        
        ///De acordo com os dias da semana da Array, cria os horários de cada notificação
//        for buildNotifications in weekArray {
        
            switch diaDaSemana {
            case "Domingo":
                var daysTo: NSInteger = (8 - weekDay ) % 7
                var interval: NSTimeInterval = NSTimeInterval(daysTo)
                currentAdded = currentDate.dateByAddingTimeInterval(interval * day)
                
            case "Segunda":
                var daysTo: NSInteger = (9 - weekDay ) % 7
                var interval: NSTimeInterval = NSTimeInterval(daysTo)
                currentAdded = currentDate.dateByAddingTimeInterval(interval * day)
                
            case "Terça":
                var daysTo: NSInteger = (10 - weekDay ) % 7
                var interval: NSTimeInterval = NSTimeInterval(daysTo)
                currentAdded = currentDate.dateByAddingTimeInterval(interval * day)
                
            case "Quarta":
                var daysTo: NSInteger = (11 - weekDay ) % 7
                var interval: NSTimeInterval = NSTimeInterval(daysTo)
                currentAdded = currentDate.dateByAddingTimeInterval(interval * day)
                
            case "Quinta":
                var daysTo: NSInteger = (12 - weekDay ) % 7
                var interval: NSTimeInterval = NSTimeInterval(daysTo)
                currentAdded = currentDate.dateByAddingTimeInterval(interval * day)
                
            case "Sexta":
                var daysTo: NSInteger = (13 - weekDay ) % 7
                var interval: NSTimeInterval = NSTimeInterval(daysTo)
                currentAdded = currentDate.dateByAddingTimeInterval(interval * day)
                
            case "Sábado":
                var daysTo: NSInteger = (14 - weekDay ) % 7
                var interval: NSTimeInterval = NSTimeInterval(daysTo)
                currentAdded = currentDate.dateByAddingTimeInterval(interval * day)
                
            default:
                println("Error: This day of week is false!")
            }
        
            //Dia obtido à cima
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateDay = dateFormatter.stringFromDate(currentAdded!)
            
            //Hora obtida no pickerdate
            let dateStringToAdd = dateDay + "-" + dateHour
            println(dateStringToAdd)
            
            //Soma dos dois
            let dateFormatterBack = NSDateFormatter()
            dateFormatterBack.dateFormat = "yyyy-MM-dd-HH:mm:ss"
            var dateToAdd = dateFormatterBack.dateFromString(dateStringToAdd)
            
            ///Compara a data obtida com a data atual. Se a data obtida já tive passado - acontece apenas se marquei para o dia da semana que é hoje, mas pra horário anterior - acrescenta o intervalo de uma semana
            var dateComparisionResult:NSComparisonResult = currentDate.compare(dateToAdd!)
            
            if dateComparisionResult == NSComparisonResult.OrderedDescending || dateComparisionResult == NSComparisonResult.OrderedSame
            {
                // Current date is greater than end date.
                dateToAdd = dateToAdd?.dateByAddingTimeInterval(60*60*24*7)
            }
    
            
//            listOfDates.append(dateToAdd!)
        
//        }
        
        return dateToAdd!
        
    }
    
    
    
    
}