module TCS
  module Menu
    class MenuCell < UITableViewCell

      def getStyle(styleNames)
        savedEnabled = self.enabled?
        savedHighlight = self.highlighted?
        savedChild = self.child?
        savedParent = self.parent?

        @attributes[:child] = styleNames.include?(:child)
        @attributes[:parent] = styleNames.include?(:parent)
        @attributes[:enabled] = styleNames.include?(:normal)
        @attributes[:enabled] = !styleNames.include?(:disabled)
        self.highlighted = styleNames.include?(:highlighted)

        style = currentStyle

        @attributes[:child] = savedChild
        @attributes[:parent] = savedParent
        @attributes[:enabled] = savedEnabled
        self.highlighted = savedHighlight

        style
      end

    end
  end
end

class MenuCellTestController < UIViewController

  attr_reader :cell

  def init
    super.tap do
      @cell = TCS::Menu::MenuCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:'id')
      @cell.frame = CGRectMake(0, 0, 100, 100)
      self.view.addSubview(@cell)
    end
  end



end