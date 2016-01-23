//
//  GradientView.swift
//  CatchUp
//
//  Created by Shivam Kapur on 09/01/16.
//  Copyright © 2016 Shivam Kapur. All rights reserved.
//

import UIKit
import QuartzCore

class GradientView: UIView {

    @IBOutlet var gradientView: UIView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        NSBundle.mainBundle().loadNibNamed("GradientView", owner: self, options: nil)
        
        let color1 = UIColor(red: 100/255, green: 197/255, blue: 244/255, alpha: 1.0).CGColor
        let color2 = UIColor(red: 194/255, green: 229/255, blue: 156/255, alpha: 1.0).CGColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [color1,color2]
        gradientLayer.frame = gradientView.bounds
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientView.layer.insertSublayer(gradientLayer, atIndex: 0)
        self.insertSubview(gradientView, atIndex: 0)
        
    }
    
    override init(frame:CGRect) {
        super.init(frame: frame)
  

    }
}
