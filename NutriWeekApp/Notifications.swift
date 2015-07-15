//
//  Notifications.swift
//  NutriWeekApp
//
//  Created by Vítor Machado Rocha on 13/07/15.
//  Copyright (c) 2015 Gabarron. All rights reserved.
//

import Foundation

class Notifications {
    
    /** Recebe o dia da semana e a hora escolhida no PickerDate.
    Através do dia da semana, constrói  a notificação, retornando a data a ser agendada **/
    func scheduleNotifications (diaDaSemana: String, dateHour: String) -> (NSDate) {
        
        // Obtendo o dia da semana atual
        let currentDate = NSDate()
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.CalendarUnitWeekday, fromDate: currentDate)
        let weekDay = myComponents.weekday

        var daysTo: NSInteger?
        
        ///De acordo com o dia da semana, cria os horários de cada notificação
        
            switch diaDaSemana {
            case "Domingo":
                daysTo = (8 - weekDay ) % 7
                
            case "Segunda":
                daysTo = (9 - weekDay ) % 7
                
            case "Terça":
                daysTo = (10 - weekDay ) % 7
                
            case "Quarta":
                daysTo = (11 - weekDay ) % 7
                
            case "Quinta":
                daysTo = (12 - weekDay ) % 7
                
            case "Sexta":
                daysTo = (13 - weekDay ) % 7
                
            case "Sábado":
                daysTo = (14 - weekDay ) % 7
                
                
            default:
                println("Error: This day of week is false!")
            }
        
            let interval: NSTimeInterval = NSTimeInterval(daysTo!)
            let currentAdded: NSDate = currentDate.dateByAddingTimeInterval(interval * 60*60*24)
        
            //Dia obtido à cima
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateDay = dateFormatter.stringFromDate(currentAdded)
            
            //Hora obtida no pickerdate
            let dateStringToAdd = dateDay + "-" + dateHour + ":00"
            println(dateStringToAdd)
            
            //Soma dos dois
            let dateFormatterBack = NSDateFormatter()
            dateFormatterBack.dateFormat = "yyyy-MM-dd-HH:mm:ss"
            var dateToAdd = dateFormatterBack.dateFromString(dateStringToAdd)
            
            ///Compara a data obtida com a data atual. Se a data obtida já tive passado - acontece apenas se marquei para o dia da semana que é hoje, mas pra horário anterior - acrescenta o intervalo de uma semana
            let dateComparisionResult:NSComparisonResult = currentDate.compare(dateToAdd!)
            
            if dateComparisionResult == NSComparisonResult.OrderedDescending || dateComparisionResult == NSComparisonResult.OrderedSame
            {
                // Current date is greater than end date.
                dateToAdd = dateToAdd?.dateByAddingTimeInterval(60*60*24*7)
            }
        
        return dateToAdd!
        
    }
    
    
    
    
}