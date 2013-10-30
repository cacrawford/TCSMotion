module TCS

  class UIBarButtonItemFlat < UIBarButtonItem

    def initWithImage(imageNormal, highlighted: imageHighlighted, target: target, action: action)
      button = UIButton.alloc.initWithFrame(CGRectMake(0,0,imageNormal.size.width, imageNormal.size.height))
      button.setImage(imageNormal, forState: UIControlStateNormal)
      button.setImage(imageHighlighted, forState: UIControlStateHighlighted)
      button.addTarget(target, action: action, forControlEvents: UIControlEventTouchUpInside)
      initWithCustomView(button).tap {}
    end

  end

end
