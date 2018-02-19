import UIKit
@IBDesignable
class RoundedButton: UIButton {
    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet{
            layer.cornerRadius = cornerRadius
        }
    }
    
    
    @IBInspectable var borderWidth: CGFloat = 1 {
        didSet {
            layer.borderWidth = borderWidth
            
        }
    }
    @IBInspectable var borderColor: UIColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0) {
        didSet {
            layer.borderColor = borderColor.cgColor
            
        }
    }
   
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        layer.borderWidth = 1/UIScreen.main.nativeScale
//        contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
//        titleLabel?.adjustsFontForContentSizeCategory = true
//        
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        layer.cornerRadius = frame.height/2
//        layer.borderColor = isEnabled ? tintColor.cgColor : UIColor.lightGray.cgColor
//        
//        
//    }
}

