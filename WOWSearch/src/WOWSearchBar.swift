//
//  WOWSearchBar.swift
//  SearchDemo
//
//  Created by Zhou Hao on 01/11/16.
//  Copyright © 2016年 Zhou Hao. All rights reserved.
//

import UIKit

@IBDesignable
class WOWSearchBar: UISearchBar {

    enum BorderType {
        case left
        case right
        case top
        case bottom
    }

    private var leftBorderLayer : CALayer?
    private var rightBorderLayer : CALayer?
    private var topBorderLayer : CALayer?
    private var bottomBorderLayer : CALayer?
    
    private var _shape = CAShapeLayer()
    private var _setup = false
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        if !_setup {
            _setup = true
            
            self._shape = CAShapeLayer()
            self._shape.lineCap = kCALineCapRound
            self._shape.lineJoin = kCALineJoinRound
            self.layer.addSublayer(self._shape)
        }
    }
        
    // MARK: private properties
    private var textField : UITextField? {
        get {
            let svs = subviews.flatMap { $0.subviews }
            guard let tf = (svs.filter { $0 is UITextField }).first as? UITextField else { return nil }
            return tf
        }
    }
        
    // MARK: Inspectable properties
    
    /**
     Text color in SearchBar. Actually in TextField.
     */
    @IBInspectable
    open var textColor : UIColor? {
        get {
            return textField?.textColor
        }
        set {
            textField?.textColor = newValue
        }
    }

    // TODO: text font, size etc
    
    /**
     Background color in TextField.
     */
    @IBInspectable
    open var contentBackgroundColor : UIColor? {
        get {
            return textField?.backgroundColor
        }
        set {
            textField?.backgroundColor = newValue
        }
    }

    /**
     Background color for container view. It's actually the background of UISearchBar.
     */
    @IBInspectable
    open var containerBackgroundColor : UIColor? {
        get {
            return self.backgroundColor
        }
        set {
            self.backgroundImage = UIImage() // must be set the image to nil otherwise can't change the backgroud color
            self.backgroundColor = newValue
        }
    }
    
    /**
     Border color for UITextField.
     */
    @IBInspectable
    open var borderColor : UIColor? {
        get {
            return nil
        }
        set {
            textField?.layer.borderColor = newValue?.cgColor
        }
    }

    /**
     Border width for UITextField.
     */
    @IBInspectable
    open var borderWidth : CGFloat {
        get {
            return textField?.layer.borderWidth != nil ? (textField?.layer.borderWidth)! : CGFloat(0.0)
        }
        set {
            textField?.layer.borderWidth = newValue
        }
    }
    
    /**
     Corner Radius for UITextField.
     */
    @IBInspectable
    open var cornerRadius : CGFloat {
        get {
            return textField?.layer.cornerRadius != nil ? (textField?.layer.cornerRadius)! : CGFloat(0.0)
        }
        set {
            textField?.layer.cornerRadius = newValue
        }
    }
    
    /**
     Color for placeholder text.
     */    
    @IBInspectable
    open var placeholderColor : UIColor? {
        get {
            return nil
        }
        set {
            let str = NSAttributedString(string: (textField?.placeholder!)!, attributes: [NSForegroundColorAttributeName:newValue ?? UIColor.darkGray])
            textField?.attributedPlaceholder = str
        }
    }
    
    /**
     Color for search icon
     */    
    @IBInspectable
    open var searchIconColor : UIColor? {
        get {
            return nil
        }
        set {
            if let glassIconView = textField?.leftView as? UIImageView {
                glassIconView.image = glassIconView.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                glassIconView.tintColor = newValue
            }
        }
    }
    
    /**
     Tint color for UITextField, used for such as cursor, clear icon button highlight color, etc...
     */
    @IBInspectable
    open var contentTintColor: UIColor? {
        get {
            return textField?.tintColor
        }
        set {
            textField?.tintColor = newValue
        }
    }
    
    /**
     Tint color for clear icon in normal state.
     */
    @IBInspectable
    open var tintForNormalClear : UIColor? {
        get {
            return nil
        }
        set {
            setClearColor(color: newValue!, forState: .normal)
        }
    }
    
    /**
     SearchBar border color.
     */
    @IBInspectable
    open var containerBorderColor : UIColor = UIColor.clear {
        didSet {
            self._shape.strokeColor = self.containerBorderColor.cgColor
            refreshDisplay()
        }
    }
    
    /**
     SearchBar border width.
     */
    @IBInspectable
    open var containerBorderWidth : CGFloat = 0 {
        didSet {
            self._shape.lineWidth = self.containerBorderWidth
            refreshDisplay()
        }
    }
    
    @IBInspectable
    open var containerBorderOffset : CGFloat = 0 {
        didSet {
            refreshDisplay()
        }
    }
    
    /**
     SearchBar left border width.
     */
    @IBInspectable
    open var leftBorder: CGFloat = 0 {
        didSet {
            refreshDisplay()
        }
    }
    
    @IBInspectable
    open var topBorder: CGFloat = 0 {
        didSet {
            refreshDisplay()
        }
    }
    
    @IBInspectable
    open var rightBorder: CGFloat = 0 {
        didSet {
            refreshDisplay()
        }
    }
    
    @IBInspectable
    open var bottomBorder: CGFloat = 0 {
        didSet {
            refreshDisplay()
        }
    }
    
    private func refreshDisplay() {
        self.setNeedsDisplay()
    }
    
    private func setClearColor(color: UIColor, forState: UIControlState) {
        if let clearButton = textField?.value(forKey: "_clearButton") as? UIButton {
            // Create a template copy of the original button image
            let templateImage =  clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            // Set the template image copy as the button image
            clearButton.setImage(templateImage, for: forState)
            // Finally, set the image color
            clearButton.tintColor = color
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let path = UIBezierPath()
        
        if self.leftBorder > 0 {
            path.move(to:CGPoint(x:self.containerBorderOffset, y:0))
            path.addLine(to:CGPoint(x:self.containerBorderOffset,y:self.frame.size.height))
        }
        if self.rightBorder > 0 {
            path.move(to:CGPoint(x:self.frame.size.width - self.containerBorderOffset,y:0))
            path.addLine(to:CGPoint(x:self.frame.size.width - self.containerBorderOffset,y:self.frame.size.height))
        }
        if self.bottomBorder > 0 {
            path.move(to:CGPoint(x:0,y:self.frame.size.height - self.containerBorderOffset))
            path.addLine(to:CGPoint(x:self.frame.size.width,y:self.frame.size.height - self.containerBorderOffset))
        }
        if self.topBorder > 0 {
            path.move(to:CGPoint(x:0,y:self.containerBorderOffset))
            path.addLine(to:CGPoint(x:self.frame.size.width,y:self.containerBorderOffset))
        }
        
        self._shape.path = path.cgPath
    }
    
}
