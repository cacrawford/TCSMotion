class UIImage

  def self.tintedImage(image, color:tintColor)
    UIImage.blendedImage(image, color:tintColor, blendMode:KCGBlendModeOverlay)
  end

  def self.tintedImageNamed(name, color:color)
    UIImage.tintedImage(UIImage.imageNamed(name), color:color)
  end

  def self.blendedImage(image, color:color, blendMode:mode)
    rect = CGRectMake(0, 0, image.size.width, image.size.height)
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)

    color.setFill
    UIRectFill(rect)

    image.drawInRect(rect, blendMode:mode, alpha:1.0)
    image.drawInRect(rect, blendMode:KCGBlendModeDestinationIn, alpha:1.0) unless mode == KCGBlendModeDestinationIn

    tintedImage = UIImage.UIGraphicsGetImageFromCurrentImageContext
    UIImage.UIGraphicsEndImageContext
    tintedImage
  end

end
