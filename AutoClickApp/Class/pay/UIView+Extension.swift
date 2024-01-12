import UIKit
import AttributedString
import SwiftTheme
public extension UIView {
    var x: CGFloat {
        set {
            frame.origin.x = newValue
        }
        get {
            return frame.origin.x
        }
    }

    var y: CGFloat {
        set {
            frame.origin.y = newValue
        }
        get {
            return frame.origin.y
        }
    }

    var width: CGFloat {
        set {
            frame.size.width = newValue
        }
        get {
            return frame.size.width
        }
    }

    var height: CGFloat {
        set {
            frame.size.height = newValue
        }
        get {
            return frame.size.height
        }
    }

    var centerX: CGFloat {
        set {
            center.x = newValue
        }
        get {
            return center.x
        }
    }

    var centerY: CGFloat {
        set {
            center.y = newValue
        }
        get {
            return center.y
        }
    }

    var size: CGSize {
        set {
            frame.size = newValue
        }
        get {
            return frame.size
        }
    }

    var origin: CGPoint {
        set {
            frame.origin = newValue
        }
        get {
            return frame.origin
        }
    }

    var top: CGFloat {
        set {
            frame.origin.y = newValue
        }
        get {
            return frame.origin.y
        }
    }

    var bottom: CGFloat {
        set {
            frame.origin.y = newValue - frame.size.height
        }
        get {
            return frame.origin.y + frame.size.height
        }
    }

    var left: CGFloat {
        set {
            frame.origin.x = newValue
        }
        get {
            return frame.origin.x
        }
    }

    var right: CGFloat {
        set {
            frame.origin.x = newValue - frame.size.width
        }
        get {
            return frame.origin.x + frame.size.width
        }
    }


    var viewController: UIViewController? {
        var view: UIView? = self
        while view != nil {
            let next = view?.next
            if next?.isKind(of: UIViewController.self) ?? false {
                return (next as? UIViewController) ?? nil
            }
            view = view?.superview
        }
        return nil
    }

    convenience init(_ size: CGSize) {
        self.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    }

    /// 圆角
    func setCornerRadius(float: CGFloat) {
        layer.cornerRadius = float
        layer.masksToBounds = true
    }

    /// 圆角, corners某些角
    func setCornerRadius(float: CGFloat, corners: UIRectCorner) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: float, height: float))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }

    func setRoundedCouners(corners: UIRectCorner, radii: CGSize, viewRect: CGRect, borderWidth: CGFloat, borderColor: UIColor) {
        let rounded = UIBezierPath(roundedRect: viewRect, byRoundingCorners: corners, cornerRadii: radii)
        let shape = CAShapeLayer()
        shape.path = rounded.cgPath

        layer.mask = shape

        layer.sublayers?.forEach {
            $0.isHidden = true
        }

        let borderLayer = CAShapeLayer()
        borderLayer.path = rounded.cgPath
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        layer.addSublayer(borderLayer)
    }

    /// 方向
    enum ColorGradientDirection {
        case horizontal
        case vertical
    }

    /// 给view添加渐变图层
    func addGradientLayer(_ direction: ColorGradientDirection = .horizontal, beginColor: UIColor, endColor: UIColor) {
        layoutIfNeeded()

        let gradientColors: [CGColor] = [beginColor.cgColor, endColor.cgColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors

        let horizontalV: Int = direction == ColorGradientDirection.horizontal ? 1 : 0
        let verticalV: Int = direction == ColorGradientDirection.vertical ? 1 : 0

        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: horizontalV, y: verticalV)
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius

        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    //Colors：渐变色色值数组
    func setLayerColors(_ colors:[CGColor])  {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.colors = colors
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        self.layer.addSublayer(layer)
    }

    /// UIView从Xib加载
    class func initFromXib() -> UIView? {
        let nibName = "\(type(of: self))"
        if Bundle.main.path(forResource: nibName, ofType: "nib") != nil {
            return Bundle.main.loadNibNamed(nibName, owner: self, options: nil)?.last as? UIView
        } else {
            return nil
        }
    }

    /// remove all subViews
    func removeAllSubviews() {
        while subviews.count > 0 {
            subviews.last?.removeFromSuperview()
        }
    }

    /// view 截屏
    func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        guard let curContext = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: curContext)
        guard let snap = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        return snap
    }

    /// 在view中 显示
    @objc class func show(_ view: UIView? = nil, _ animated: Bool = true) {
        guard let view = view else {
            Self.dismiss(UIApplication.shared.keyWindow, animated)
            let view = Self.self.init(frame: UIScreen.main.bounds)
            UIApplication.shared.keyWindow?.addSubview(view)
            if animated { view.animateShow() }
            return
        }
        Self.dismiss(view, animated)
        let showView = Self.self.init(frame: view.bounds)
        view.addSubview(showView)
        if animated { view.animateShow() }
    }

    /// 在view中 消失
    class func dismiss(_ view: UIView? = nil, _ animated: Bool = true) {
        guard let view = view else {
            for v in UIApplication.shared.keyWindow?.subviews ?? [] {
                if v.isKind(of: Self.self) {
                    if animated {
                        v.animateDismiss()
                    } else {
                        v.removeFromSuperview()
                    }
                }
            }
            return
        }
        for v in view.subviews {
            if v.isKind(of: Self.self) {
                if animated {
                    v.animateDismiss()
                } else {
                    v.removeFromSuperview()
                }
            }
        }
    }
}

public extension UIImageView {
    convenience init(_ imageName: String) {
        self.init()
        image = UIImage(named: imageName)
    }

    convenience init(_ imageName: String, _ size: CGSize) {
        self.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIImage(named: imageName)
    }
}

public extension UILabel {
    convenience init(_ myText: String, _ color: UIColor, _ myFont: UIFont) {
        self.init()
        text = myText
        textColor = color
        font = myFont
        sizeToFit()
    }

    convenience init(_ myframe: CGRect = CGRect.zero,
                     _ myText: String = "",
                     _ myColor: UIColor = .black,
                     _ myBackgoroudColor: UIColor = .white,
                     _ myFont: CGFloat = 12,
                     _ mytextAlignment: NSTextAlignment = .center)
    {
        self.init()
        frame = myframe
        text = myText
        textColor = myColor
        backgroundColor = myBackgoroudColor
        textAlignment = mytextAlignment
        font = UIFont.systemFont(ofSize: myFont)
        sizeToFit()
    }
}

public extension CALayer {
    func shakeBody() {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        keyFrameAnimation.values = [0, 16, -16, 8, -8, 0]
        keyFrameAnimation.duration = 0.3
        keyFrameAnimation.repeatCount = 1
        add(keyFrameAnimation, forKey: "shake")
    }
}

public extension UIView {
    /// 添加shake动画
    func addShakeAnimate() {
        if isHidden == true { isHidden = false }
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 0.3
        var values = [NSValue]()
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.5, 0.5, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.5, 1.5, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values
        layer.add(animation, forKey: nil)
    }

    /// 添加dismiss动画
    func dismissShakeAnimate() {
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 0.3
        var values = [NSValue]()
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.0, 0.0, 1.0)))
        animation.values = values
        layer.add(animation, forKey: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) { [weak self] in
            self?.isHidden = true
        }
    }

    /// 渐变显示
    func animateShow() {
        alpha = 0
        UIView.animate(withDuration: 0.35, animations: {
            self.alpha = 1
        })
    }

    /// 渐变隐藏
    func animateDismiss() {
        alpha = 1
        UIView.animate(withDuration: 0.35, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
}

public extension UIScrollView {
    
}

// MARK: - UITabBarItem

/// UITabBarItem
public extension UITabBarItem {
    /// 获取view
    var view: UIView? {
        guard let view = value(forKey: "view") as? UIView else {
            return nil
        }
        return view
    }

    var imageView: UIImageView? {
        guard let imageView = view?.subviews.filter({ view in
            view is UIImageView
        }).first else {
            return nil
        }
        return (imageView as? UIImageView)
    }
    
    var titleLab: UILabel? {
        guard let titleLab = view?.subviews.filter({ view in
            view is UILabel
        }).first else {
            return nil
        }
        return (titleLab as? UILabel)
    }
}


extension UIView {
    
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
    
}




//抖动方向枚举
public enum ShakeDirection: Int {
    case horizontal  //水平抖动
    case vertical  //垂直抖动
}
 
extension UIView {
     
    /**
     扩展UIView增加抖动方法
      
     @param direction：抖动方向（默认是水平方向）
     @param times：抖动次数（默认5次）
     @param interval：每次抖动时间（默认0.1秒）
     @param delta：抖动偏移量（默认2）
     @param completion：抖动动画结束后的回调
     */
    public func shake(direction: ShakeDirection = .horizontal, times: Int = 5,
                      interval: TimeInterval = 0.1, delta: CGFloat = 2,
                      completion: (() -> Void)? = nil) {
        //播放动画
        UIView.animate(withDuration: interval, animations: { () -> Void in
            switch direction {
            case .horizontal:
                self.layer.setAffineTransform( CGAffineTransform(translationX: delta, y: 0))
                break
            case .vertical:
                self.layer.setAffineTransform( CGAffineTransform(translationX: 0, y: delta))
                break
            }
        }) { (complete) -> Void in
            //如果当前是最后一次抖动，则将位置还原，并调用完成回调函数
            if (times == 0) {
                UIView.animate(withDuration: interval, animations: { () -> Void in
                    self.layer.setAffineTransform(CGAffineTransform.identity)
                }, completion: { (complete) -> Void in
                    completion?()
                })
            }
            //如果当前不是最后一次抖动，则继续播放动画（总次数减1，偏移位置变成相反的）
            else {
                self.shake(direction: direction, times: times - 1,  interval: interval,
                           delta: delta * -1, completion:completion)
            }
        }
    }
}


public extension UIView {
    
    // MARK: 添加渐变色图层
     func gradientColor(_ startPoint: CGPoint, _ endPoint: CGPoint, _ colors: [Any]) {
        
        guard startPoint.x >= 0, startPoint.x <= 1, startPoint.y >= 0, startPoint.y <= 1, endPoint.x >= 0, endPoint.x <= 1, endPoint.y >= 0, endPoint.y <= 1 else {
            return
        }
        
        // 外界如果改变了self的大小，需要先刷新
        layoutIfNeeded()
        
        var gradientLayer: CAGradientLayer!
        
        removeGradientLayer()

        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.layer.bounds
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = colors
        gradientLayer.cornerRadius = self.layer.cornerRadius
        gradientLayer.masksToBounds = true
        // 渐变图层插入到最底层，避免在uibutton上遮盖文字图片
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.backgroundColor = UIColor.clear
        // self如果是UILabel，masksToBounds设为true会导致文字消失
        self.layer.masksToBounds = false
    }
    
    // MARK: 移除渐变图层
    // （当希望只使用backgroundColor的颜色时，需要先移除之前加过的渐变图层）
    func removeGradientLayer() {
        if let sl = self.layer.sublayers {
            for layer in sl {
                if layer.isKind(of: CAGradientLayer.self) {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
}



extension UIView {
    
    func addGradientLayerWithCorner(cornerRadius:CGFloat, lineWidth:CGFloat, colors: [CGColor]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.blue.cgColor,UIColor.green.cgColor]
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        let maskLayer = CAShapeLayer()
        maskLayer.lineWidth = lineWidth
        maskLayer.path = UIBezierPath(roundedRect: CGRect(x: lineWidth / 2, y: lineWidth / 2, width: bounds.width - lineWidth, height: bounds.height - lineWidth), cornerRadius: cornerRadius).cgPath
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.black.cgColor
        
        gradientLayer.mask = maskLayer
        self.layer.addSublayer(gradientLayer)
    }
}
