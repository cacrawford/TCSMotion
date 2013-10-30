module TCS

  class TextCell < UICollectionViewCell

    def self.identifier
      'TCSTextCell'
    end

    def initWithFrame(rect)
      super.tap do
        @label = UILabel.alloc.initWithFrame(rect)
        @label.backgroundColor = UIColor.whiteColor
        @label.textColor = UIColor.blackColor
        @label.textAlignment = NSTextAlignmentCenter
        @backgroundColor = UIColor.clearColor
        addSubview(@label)
      end
    end

    def layoutSubviews
      super

      if self.selected?
        @label.backgroundColor = UIColor.yellowColor
      else
        @label.backgroundColor = UIColor.whiteColor
      end

      @label.frame = self.bounds
    end

    def selected=(selected)
      if selected
        @label.backgroundColor = UIColor.yellowColor
      else
        @label.backgroundColor = UIColor.whiteColor
      end
    end

    def data
      @label.text
    end

    def data=(data)
      @label.text = data
    end

    def font
      @label.font
    end

    def font=(font)
      @label.font = font
    end

    def textAlignment
      @label.textAlignment
    end

    def textAlignment=(textAlignment)
      @label.textAlignment = textAlignment
    end

    def textColor
      @label.textColor
    end

    def textColor=(color)
      @label.textColor = color
    end

    def backgroundColor=(color)
      super.tap do
        @label.backgroundColor = color
      end
    end

  end

end

