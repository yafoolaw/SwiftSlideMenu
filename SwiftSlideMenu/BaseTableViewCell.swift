//
//  BaseTableViewCell.swift
//  SwiftSlideMenu
//
//  Created by FrankLiu on 15/10/26.
//  Copyright © 2015年 刘大帅. All rights reserved.
//

import UIKit

public class BaseTableViewCell: UITableViewCell {
    
    class var identifier: String {
    
        return String.className(self)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    public func setup() {
    
    }
    
    override public func setHighlighted(highlighted: Bool, animated: Bool) {
        
        if highlighted {
        
            self.alpha = 0.4
            
        } else {
        
             self.alpha = 1
        }
    }
    
    override public func setSelected(selected: Bool, animated: Bool) {
        
    }
}
