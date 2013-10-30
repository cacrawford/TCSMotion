module TCS
  module Menu

    class MenuCell < UITableViewCell
      attr_reader :attributes
      attr_reader :styles

      def self.identifier
        'TCSMenuCell'
      end

      def initWithStyle(style, reuseIdentifier: identifier)
        super.tap do
          @attributes = Hash.new
          @attributes[:indent] = 0

          @styles = TCS::Menu::default_menu_styles

          self.backgroundColor = UIColor.clearColor

          @label = UILabel.alloc.initWithFrame(self.contentView.bounds)
          self.contentView.addSubview(@label)

          @icon = UIImageView.alloc.initWithFrame(CGRectZero)
          @icon.backgroundColor = UIColor.clearColor
          self.contentView.addSubview(@icon)

          @divider = UIView.alloc.initWithFrame(CGRectZero)
          self.contentView.addSubview(@divider)

          @parentIcon = UIImageView.alloc.initWithFrame(CGRectZero)
          self.contentView.addSubview(@parentIcon)
        end

      end

      def layoutSubviews
        style = currentStyle

        textColor = if style.include?(:tintColor)
                      style[:tintColor]
                    elsif style.include?(:textColor)
                      style[:textColor]
                    else
                      nil
                    end

        self.contentView.frame = self.bounds
        self.contentView.backgroundColor = style[:backgroundColor] if style.include? :backgroundColor

        @label.backgroundColor = style[:backgroundColor] if style.include? :backgroundColor
        @label.textColor = textColor unless textColor.nil?
        @label.font = style[:font] if style.include? :font
        @label.textAlignment = style[:textAlignment] if style.include? :textAlignment
        @label.text = @attributes[:text] if @attributes.include? :text

        layoutIcon(style)
        layoutParentIcon(style)
        layoutDivider(style)
      end

      def layoutIcon(style)
        icon = if disabled? && @attributes.include?(:iconDisabled)
                 @attributes[:iconDisabled]
               elsif opened? && @attributes.include?(:iconOpened)
                 @attributes[:iconOpened]
               elsif closed? && @attributes.include?(:iconClosed)
                 @attributes[:iconClosed]
               elsif @attributes.include?(:icon)
                 styleImage(@attributes[:icon], style)
               else
                 nil
               end

        if icon.nil?
          @icon.frame = CGRectZero
          @label.frame = CGRectMake(indent, 0, self.bounds.size.width - indent, self.bounds.size.height)
        else
          xLabel = indent * 2
          if icon.size.height >= self.size.height
            @icon.frame = CGRectMake(indent, 0, self.size.height, self.size.height)
            xLabel += self.size.height
          else
            yIcon = ((self.size.height - icon.size.height) / 2).floor
            @icon.frame = CGRectMake(indent, yIcon, icon.size.width, icon.size.height)
            xLabel += icon.size.width
          end

          @icon.image = icon
          @label.frame = CGRectMake(xLabel, 0, self.bounds.size.width - xLabel, self.bounds.size.height)
        end
      end

      def layoutParentIcon(style)
        if parent? && style.include?(:parentIcon)
          @parentIcon.hidden = false
          parentIcon = styleImage(style[:parentIcon], style)
          x = self.contentView.bounds.size.width - parentIcon.size.width
          y = [((self.contentView.bounds.size.height - parentIcon.size.height)/2).ceil, 0].max
          height = [self.contentView.bounds.size.height, parentIcon.size.height].min
          @parentIcon.frame = CGRectMake(x, y, parentIcon.size.width, height)
          @parentIcon.image = parentIcon
        else
          @parentIcon.hidden = true
          @parentIcon.image = nil
        end
      end

      def layoutDivider(style)
        if style.include?(:divider) && style[:divider]
          @divider.hidden = false
          @divider.backgroundColor = style.include?(:dividerColor) ? style[:dividerColor] : UIColor.whiteColor
          height = style.include?(:dividerHeight) ? style[:dividerHeight] : 1

          xStart = opened? ? @label.frame.origin.x : 0
          width = self.contentView.bounds.size.width - xStart
          yStart = self.contentView.bounds.size.height - height
          @divider.frame = CGRectMake(xStart, yStart, width, height)
        else
          @divider.hidden = true
        end
      end

      def styleImage(image, style)
        if style.include? :tintColor
          UIImage.tintedImage(image, color: style[:tintColor])
        else
          image
        end
      end

      def setParentIconImage(image)
      end

      def attributes=(attributes)
        @attributes = attributes
      end

      def styles=(styles)
        styles.each do |name, values|
          @styles[name] = values
        end
      end

      def enabled?
        return true unless attributes.include? :enabled
        @attributes[:enabled]
      end

      def disabled?
        !enabled?
      end

      def indent
        return 0 unless currentStyle.include? :indent
        currentStyle[:indent]
      end

      def selectable?
        return false if parent?
        @attributes.include?(:delegate) && @attributes.include?(:action)
      end

      def parent?
        @attributes.include?(:parent) ? @attributes[:parent] : false
      end

      def child?
        @attributes.include?(:child) ? @attributes[:child] : false
      end

      def highlightable?
        !parent?
      end

      def opened?
        @attributes.include?(:opened) ? @attributes[:opened] : false
      end

      def closed?
        !opened?
      end

      def performAction
        return unless @attributes.include?(:delegate) && @attributes.include?(:action)
        @attributes[:delegate].send(@attributes[:action], @attributes[:arguments])
      end

      protected

      def currentStyle
        style = Hash.new

        applyStyle(style, @styles[:default]) if @styles.include?(:default)
        applyStateStyles(style, @styles[:default])

        if child?
          applyStyle(style, @styles[:child]) if child? && @styles.include?(:child)
          applyStateStyles(style, @styles[:child])
        elsif parent?
          applyStyle(style, @styles[:parent]) if parent? && @styles.include?(:parent)
          applyParentStyles(style, @styles[:parent])
          applyStateStyles(style, @styles[:parent])
        end

        style
      end

      def applyStateStyles(style, styles)
        if self.highlighted? && styles.include?(:highlighted) && highlightable? && enabled?
          applyStyle(style, styles[:highlighted])
        elsif self.disabled? && styles.include?(:disabled)
          applyStyle(style, styles[:disabled])
        elsif styles.include?(:normal)
          applyStyle(style, styles[:normal])
        end
      end

      def applyParentStyles(style, styles)
        opened = @attributes.include?(:opened) ? @attributes[:opened] : false
        if opened && styles.include?(:opened)
          applyStyle(style, styles[:opened])
        elsif !opened && styles.include?(:closed)
          applyStyle(style, styles[:closed])
        end
      end

      def applyStyle(styleTo, styleFrom)
        styleFrom.each do |key, value|
          styleTo[key] = value
        end

      end

    end

  end
end
