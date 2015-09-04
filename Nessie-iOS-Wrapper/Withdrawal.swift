//
//  Withdrawal.swift
//  Nessie-iOS-Wrapper
//
//  Created by Mecklenburg, William on 4/3/15.
//  Copyright (c) 2015 Nessie. All rights reserved.
//

import Foundation

public class WithdrawalRequestBuilder {
    public var requestType: HTTPType?
    public var accountId: String!
    
    public var withdrawalMedium: TransactionMedium?
    public var amount: Int?
    public var withdrawalId: String?
    public var description: String?
}

public class WithdrawalRequest {
    
    private var request:  NSMutableURLRequest?
    private var getsArray: Bool = true
    private var builder: WithdrawalRequestBuilder!
    
    public convenience init?(block: (WithdrawalRequestBuilder -> Void)) {
        let initializingBuilder = WithdrawalRequestBuilder()
        block(initializingBuilder)
        self.init(builder: initializingBuilder)
    }
    
    private init?(builder: WithdrawalRequestBuilder)
    {
        self.builder = builder
        
        if (builder.withdrawalId == nil && (builder.requestType == HTTPType.PUT || builder.requestType == HTTPType.DELETE)) {
            NSLog("PUT/DELETE require a deposit id")
            return nil
        }
        
        if ((builder.accountId == nil || builder.withdrawalMedium == nil || builder.amount == nil) && builder.requestType == HTTPType.POST) {
            if (builder.accountId == nil) {
                NSLog("POST requires accountId")
            }
            if (builder.amount == nil) {
                NSLog("POST requires amount")
            }
            if (builder.withdrawalMedium == nil) {
                NSLog("POST requires withdrawalMedium")
            }
            
            return nil
        }
        
//        if ((builder.withdrawalId == nil || builder.withdrawalMedium == nil || builder.amount == nil) && builder.requestType == HTTPType.PUT) {
//            if (builder.withdrawalId == nil) {
//                NSLog("POST requires withdrawalId")
//            }
//            if (builder.amount == nil) {
//                NSLog("POST requires amount")
//            }
//            if (builder.withdrawalMedium == nil) {
//                NSLog("POST requires withdrawalMedium")
//            }
//            
//            return nil
//        }
        
        var requestString = buildRequestUrl()
        buildRequest(requestString)
    }
    
    //Methods for building the request.
    
    private func buildRequestUrl() -> String {
        var requestString = "\(baseString)"
        
        if (builder.requestType == HTTPType.PUT) {
            requestString += "/withdrawals/\(builder.accountId)?"
            requestString += "key=\(NSEClient.sharedInstance.getKey())"
            return requestString
        }
        
        if (builder.requestType == HTTPType.DELETE) {
            requestString += "/withdrawals/\(builder.accountId)?"
            requestString += "key=\(NSEClient.sharedInstance.getKey())"
            return requestString
        }
        
        if (builder.accountId != nil) {
            requestString += "/accounts/\(builder.accountId!)/withdrawals"
        }
        if (builder.withdrawalId != nil) {
            self.getsArray = false
            requestString += "/withdrawals/\(builder.withdrawalId!)"
        }
        requestString += "?key=\(NSEClient.sharedInstance.getKey())"
        return requestString

    }
    
    private func buildRequest(url: String) -> NSMutableURLRequest {
        self.request = NSMutableURLRequest(URL: NSURL(string: url)!)
        self.request!.HTTPMethod = builder.requestType!.rawValue
        
        addParamsToRequest();
        
        self.request!.setValue("application/json", forHTTPHeaderField: "content-type")
        
        return request!
    }
    
    private func addParamsToRequest() {
        var params:Dictionary<String, AnyObject> = [:]
        var err: NSError?
        
        if (builder.requestType == HTTPType.POST) {
            params = ["medium":builder.withdrawalMedium!.rawValue, "amount":builder.amount!]
            if let description = builder.description {
                params["description"] = description
            }
            self.request!.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        }
        if (builder.requestType == HTTPType.PUT) {
            if let medium = builder.withdrawalMedium {
                params["medium"] = medium.rawValue
            }
            if let amount = builder.amount {
                params["amount"] = amount
            }
            if let description = builder.description {
                params["description"] = description
            }
            self.request!.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        }
    }
    
    
    //Sending the request
    
    public func send(#completion: ((WithdrawalResult) -> Void)?) {
        
        NSURLSession.sharedSession().dataTaskWithRequest(request!, completionHandler:{(data, response, error) -> Void in
            if error != nil {
                NSLog(error.description)
                return
            }
            if (completion == nil) {
                return
            }
            
            var result = WithdrawalResult(data: data)
            completion!(result)
            
        }).resume()
    }
}


public struct WithdrawalResult {
    private var dataItem:Transaction?
    private var dataArray:Array<Transaction>?
    private init(data:NSData) {
        var parseError: NSError?
        if let parsedObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error:&parseError) as? Array<Dictionary<String,AnyObject>> {
            
            dataArray = []
            dataItem = nil
            for withdrawal in parsedObject {
                dataArray?.append(Transaction(data: withdrawal))
            }
        }
        if let parsedObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error:&parseError) as? Dictionary<String,AnyObject> {
            dataArray = nil
            
            //If there is an error message, the json will parse to a dictionary, not an array
            if let message:AnyObject = parsedObject["message"] {
                NSLog(message.description!)
                if let reason:AnyObject = parsedObject["culprit"] {
                    NSLog("Reasons:\(reason.description)")
                    return
                } else {
                    return
                }
            }
            
            dataItem = Transaction(data: parsedObject)
        }
        if (dataItem == nil && dataArray == nil) {
            var datastring = NSString(data: data, encoding: NSUTF8StringEncoding)
            if (data.description == "<>") {
                NSLog("Withdrawal delete successful")
            } else {
                NSLog("Could not parse data: \(datastring)")
            }
        }
    }
    
    public func getWithdrawal() -> Transaction? {
        if (dataItem == nil) {
            NSLog("No single data item found. If you were intending to get multiple items, try getAllWithdrawals()");
        }
        return dataItem
    }
    
    public func getAllWithdrawals() -> Array<Transaction>? {
        if (dataArray == nil) {
            NSLog("No array of data items found. If you were intending to get one single item, try getWithdrawal()");
        }
        return dataArray
    }
}