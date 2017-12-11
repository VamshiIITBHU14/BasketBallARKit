//
//  CustomButton.swift
//  ARBasketBall
//
//  Created by Vamshi Krishna on 10/12/17.
//  Copyright © 2017 Vamshi Krishna. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        customiseButton()
    }
    
    func customiseButton(){
        backgroundColor = UIColor.lightGray
        layer.cornerRadius = 10.0
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.white.cgColor
        
    }

}
