//
//  hud.swift
//  MazeGame
//
//  Created by Daniel Lambert on 4/4/18.
//  Copyright © 2018 Bootleg Mobile. All rights reserved.
//
import Foundation
import UIKit

@IBDesignable class hud: UIView {
    
    var view: UIView!
    let nibName = "hud"
    
    override init(frame: CGRect) { // programmer creates our custom View
        super.init(frame: frame)
        
        setupHud()
    }
    
    required init(coder aDecoder: NSCoder) {  // Storyboard or UI File
        super.init(coder: aDecoder)!
        setupHud()
    }
    
    func setupHud() { // setup XIB here
        
        view = loadHudFromNib()
        view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height-90, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height) // this will be the size of your HUD in game
        view.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        addSubview(view)
    }
    
    func loadHudFromNib() ->UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
}
