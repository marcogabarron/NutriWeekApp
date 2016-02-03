//
//  Connection.swift
//  NutriWeekApp
//
//  Created by Jessica Oliveira on 28/01/16.
//  Copyright © 2016 Gabarron. All rights reserved.
//

import Foundation

class Connection: NSObject {
    
    var urlPath: String! = "nosso site - link onde estára o php com conexão"
    var downloadedData = NSMutableData()

    func findLocale() {
        // Download the json file
        let url: NSURL = NSURL(string: urlPath)!
        
        // Create the request
        let urlRequest: NSURLRequest = NSURLRequest(URL: url)
        
        // Create the NSURLConnection
        let connection: NSURLConnection = NSURLConnection(request: urlRequest, delegate: self, startImmediately: true)!
        connection.start()    }
    
    func connection(data: NSData, connection didReceiveData: NSURLConnection){
        self.downloadedData.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!)
    {
        var codes: NSMutableArray = []
        var error: NSError
        
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(downloadedData, options: NSJSONReadingOptions.MutableContainers, error: error) as NSDictionary
        
        
        
        var dersler : NSArray = jsonResult.valueForKey("Nutritionist_X_Patient") as! NSArray
        
        
        //[ercorrendo todos dados?
        for vartype : AnyObject in dersler
        {
            codes.addObject(vartype.code)
        }
        
        
        
        
    }
    
}
