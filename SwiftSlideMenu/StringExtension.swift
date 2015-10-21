//
//  StringExtension.swift
//  SwiftSlideMenu
//
//  Created by FrankLiu on 15/10/21.
//  Copyright © 2015年 刘大帅. All rights reserved.
//

import Foundation

extension String {

    static func className(aClass: AnyClass) -> String {
    
        print("StringExtension:\(NSStringFromClass(aClass))")
        
        NSLog("StringExtension:%@", NSStringFromClass(aClass).componentsSeparatedByString("."))
        
        NSLog("StringExtension:%@", NSStringFromClass(aClass).componentsSeparatedByString(".").last!)
        
        return NSStringFromClass(aClass).componentsSeparatedByString(".").last!
    }
}