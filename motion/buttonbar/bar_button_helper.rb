module TCS

  module BarButtonHelper

    UIBarButtonItemStyleFlat = :uiBarButtonItemStyleFlat
    UIBarButtonItemStyleSticky = :uiBarButtonItemStyleSticky

    class << self
      attr_accessor :flexibleSpaceItem
      attr_accessor :style
      attr_accessor :icons
    end

    def self.buttonStyle
      self.style ||= UIBarButtonItemStylePlain
    end

    def self.buttonStyle=(style)
      self.style = style
    end

    def self.defaultIcons
      if self.icons.nil?
        self.icons = Hash.new
        self.icons[:menu_normal] = UIImage.imageNamed('menu_normal')
        self.icons[:menu_highlighted] = UIImage.imageNamed('menu_highlighted')
        self.icons[:back_normal] = UIImage.imageNamed('back_normal')
        self.icons[:back_highlighted] = UIImage.imageNamed('back_highlighted')
        self.icons[:left_arrow] = UIImage.imageNamed('left_arrow')
        self.icons[:right_arrow] = UIImage.imageNamed('right_arrow')
      end
      self.icons
    end

    def flexibleSpace
      BarButtonHelper.flexibleSpaceItem ||= UIBarButtonItem.alloc
      .initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace,
                                   target: nil,
                                   action: nil)
    end

    def fixedSpace(width)
      space =UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFixedSpace,
                                                               target: nil,
                                                               action: nil)
      space.width = width
      space
    end

    def menuButton(target, action, style = nil)
      imageButton({
                      :normal => TCS::BarButtonHelper::defaultIcons[:menu_normal],
                      :highlighted => TCS::BarButtonHelper::defaultIcons[:menu_highlighted]
                  },
                  target,
                  action,
                  style)
    end

    def backButton(target = nil, action = nil, style = nil)
      imageButton({
                      :normal => TCS::BarButtonHelper::defaultIcons[:back_normal],
                      :highlighted => TCS::BarButtonHelper::defaultIcons[:back_highlighted]
                  },
                  target,
                  action,
                  style)
    end

    def leftArrowButton(target, action, style = nil)
      imageButton({
                      :normal => TCS::BarButtonHelper::defaultIcons[:left_arrow]
                  },
                  target,
                  action,
                  style)
    end

    def rightArrowButton(target, action, style = nil)
      imageButton({
                      :normal => TCS::BarButtonHelper::defaultIcons[:right_arrow]
                  },
                  target,
                  action,
                  style)
    end

    def titleButton(title, target, action)
      UIBarButtonItem.alloc.initWithTitle(title,
                                          style: UIBarButtonItemStylePlain,
                                          target: target,
                                          action: action)
    end

    def imageButton(images, target, action, style = nil)
      useStyle= style.nil? ? TCS::BarButtonHelper::buttonStyle : style
      if useStyle == TCS::BarButtonHelper::UIBarButtonItemStyleFlat
        flatImageButton(images[:normal], images[:highlighted], target, action)
      elsif useStyle == TCS::BarButtonHelper::UIBarButtonItemStyleSticky
        stickyImageButton(images[:normal], images[:selected], target, action)
      else
        defaultImageButton(images[:normal], useStyle, target, action)
      end
    end

    def flatImageButton(imageNormal, imageHighlighted, target, action)
      TCS::UIBarButtonItemFlat.alloc.initWithImage(imageNormal,
                                                   highlighted: imageHighlighted,
                                                   target: target,
                                                   action: action)
    end

    def stickyImageButton(imageNormal, imageSelected, target, action)
      TCS::UIBarButtonItemSticky.alloc.initWithImage(imageNormal,
                                                     selected: imageSelected,
                                                     target: target,
                                                     action: action)
    end

    def defaultImageButton(image, style, target, action)
      UIBarButtonItem.alloc.initWithImage(image,
                                          style: style,
                                          target: target,
                                          action: action)
    end

    def customView(view)
      UIBarButtonItem.alloc.initWithCustomView(view)
    end

    def titleSpace(title)
      labelSpace(:text => title)
    end

    # Contains defaults used by UINavigationBar
    def labelSpace(options = {})
      options[:size] ||= CGSizeZero
      options[:text] ||= ''
      options[:textAlignment] ||= NSTextAlignmentCenter
      options[:backgroundColor] ||= UIColor.clearColor
      options[:textColor] ||= UIColor.blackColor
      options[:shadowColor] ||= UIColor.colorWithWhite(0.0, alpha: 0.5)
      options[:font] ||= UIFont.boldSystemFontOfSize(20)

      view = UILabel.alloc.initWithFrame(CGRectMake(0, 0, options[:size].width, options[:size].height))
      options.each do |key, value|
        view.send("#{key.to_s}=", value)
      end

      customView(view)
    end

  end

end
