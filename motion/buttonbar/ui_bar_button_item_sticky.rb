module TCS

  class UIBarButtonItemSticky < UIBarButtonItem

    def initWithImage(imageNormal, selected: imageSelected, target: target, action: action)
      self.target = target
      self.action = action

      button = UIButton.alloc.initWithFrame(CGRectMake(0, 0, imageNormal.size.width, imageNormal.size.height))
      button.setImage(imageNormal, forState: UIControlStateNormal)
      button.setImage(imageSelected, forState: UIControlStateSelected)
      button.addTarget(self, action: :'clicked:', forControlEvents: UIControlEventTouchUpInside)
      button.showsTouchWhenHighlighted = false
      button.reversesTitleShadowWhenHighlighted = false
      button.contentEdgeInsets = UIEdgeInsetsMake(0,1,0,1)
      initWithCustomView(button).tap {}
    end

    def clicked(sender)
      sender.selected = !sender.selected?
      target.send(action, sender.selected?)
    end

  end

end

