
import UIKit
@IBDesignable
class TextField: UITextField{

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
@IBInspectable var leftImage : UIImage? {
    didSet{
        updateView()
    }
}
    @IBInspectable var leftPadding : CGFloat = 0{
        didSet{
            updateView()
        }
    }
   
    
    
func updateView(){
    leftViewMode = .always
    rightViewMode = .always
    
    let leftImageView = UIImageView(frame: CGRect(x: leftPadding,  y:0, width: 20, height: 20))
    leftImageView.image = leftImage
    
    //to set tint color of image
    //imageView.tintColor = tintColor
    
    var width = leftPadding + 20
    
    if borderStyle == UITextBorderStyle.none || borderStyle == UITextBorderStyle.line{
        width = width + 5
    }
    else if leftImage == nil{
        width = width - 20
    }

    // to set placehodler color same as tint color
    attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "" , attributes: [NSAttributedStringKey.foregroundColor: tintColor])
    let view = UIView(frame: CGRect(x:0,  y:0, width: width, height: 20 ))
    
    view.addSubview(leftImageView)
    leftView = view
    
}
    
    
    
}
