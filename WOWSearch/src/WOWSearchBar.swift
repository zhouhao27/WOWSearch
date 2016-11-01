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

    private var leftBorderLayer : CALayer?
    private var rightBorderLayer : CALayer?
    private var topBorderLayer : CALayer?
    private var bottomBorderLayer : CALayer?
    
    private var leftBorderView : UIView?
    private var topBorderView : UIView?
    private var rightBorderView : UIView?
    private var bottomBorderView : UIView?
    
    private var leftHConstraints : [NSLayoutConstraint]?
    private var leftVConstraints : [NSLayoutConstraint]?
    private var rightHConstraints : [NSLayoutConstraint]?
    private var rightVConstraints : [NSLayoutConstraint]?
    private var topHConstraints : [NSLayoutConstraint]?
    private var topVConstraints : [NSLayoutConstraint]?
    private var bottomHConstraints : [NSLayoutConstraint]?
    private var bottomVConstraints : [NSLayoutConstraint]?

    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
            refreshDisplay()
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
            refreshDisplay()
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
            refreshDisplay()
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
            refreshDisplay()
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
            refreshDisplay()
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
            refreshDisplay()
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
            refreshDisplay()
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
            refreshDisplay()
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
            refreshDisplay()
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
            refreshDisplay()
        }
    }
    
    /**
     SearchBar corner radius.
     */
    @IBInspectable
    open var containerCornerRadius : CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
            refreshDisplay()
        }
    }
    
    /**
     SearchBar border color.
     */
    @IBInspectable
    open var containerBorderColor : UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    /**
     SearchBar border width.
     */
    @IBInspectable
    open var containerBorderWidth : CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    open var containerBorderOffset : CGFloat = 0
    
    /**
     SearchBar left border width.
     */
    @IBInspectable
    open var leftBorder: CGFloat {
        get {
            return 0.0
        }
        set {
            if leftBorderView != nil {
                leftBorderView?.removeFromSuperview()
                self.removeConstraints(leftHConstraints!)
                self.removeConstraints(leftVConstraints!)
            }
            
            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: newValue, height: self.bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = self.containerBorderColor
            self.leftBorderView = line
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            
            self.leftHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|[line(==lineWidth)]", options: [], metrics: metrics, views: views)
            self.leftVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views)
            
            self.addConstraints(self.leftHConstraints!)
            self.addConstraints(self.leftVConstraints!)
        }
    }
    
    @IBInspectable
    open var topBorder: CGFloat {
        get {
            return 0.0
        }
        set {
            if topBorderView != nil {
                topBorderView?.removeFromSuperview()
                self.removeConstraints(topHConstraints!)
                self.removeConstraints(topVConstraints!)
            }

            let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = self.containerBorderColor
            self.topBorderView = line
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            self.topHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views)
            self.topVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[line(==lineWidth)]", options: [], metrics: metrics, views: views)
            self.addConstraints(self.topHConstraints!)
            self.addConstraints(self.topVConstraints!)
        }
    }
    
    @IBInspectable
    open var rightBorder: CGFloat {
        get {
            return 0.0
        }
        set {
            if rightBorderView != nil {
                rightBorderView?.removeFromSuperview()
                self.removeConstraints(rightHConstraints!)
                self.removeConstraints(rightVConstraints!)
            }

            let line = UIView(frame: CGRect(x: self.bounds.width, y: 0.0, width: newValue, height: self.bounds.height))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = self.containerBorderColor
            self.rightBorderView = line
            self.addSubview(line)
            
            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            self.rightHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "[line(==lineWidth)]|", options: [], metrics: metrics, views: views)
            self.rightVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views)
            self.addConstraints(self.rightHConstraints!)
            self.addConstraints(self.rightVConstraints!)
        }
    }
    
    @IBInspectable
    open var bottomBorder: CGFloat {
        get {
            return 0.0
        }
        set {
/*
            if bottomBorderView != nil {
                bottomBorderView?.removeFromSuperview()
                self.removeConstraints(bottomHConstraints!)
                self.removeConstraints(bottomVConstraints!)
            }

            let line = UIView(frame: CGRect(x: 0.0, y: self.bounds.height, width: self.bounds.width, height: newValue))
            line.translatesAutoresizingMaskIntoConstraints = false
            line.backgroundColor = self.containerBorderColor
            self.bottomBorderView = line
            self.addSubview(line)

            let views = ["line": line]
            let metrics = ["lineWidth": newValue]
            self.bottomHConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views)
            self.bottomVConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[line(==lineWidth)]|", options: [], metrics: metrics, views: views)
            self.addConstraints(self.bottomHConstraints!)
            self.addConstraints(self.bottomVConstraints!)
*/
            if bottomBorderLayer != nil {
                self.bottomBorderLayer?.removeFromSuperlayer()
            }
            
            let border = CALayer()
            let width = CGFloat(1.0)
            border.borderColor = self.containerBorderColor?.cgColor
            border.frame = CGRect(x:0, y: self.frame.size.height - width - self.containerBorderOffset,  width:  self.frame.size.width, height: width)
            
            border.borderWidth = width
            self.bottomBorderLayer = border
            
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true

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
}
