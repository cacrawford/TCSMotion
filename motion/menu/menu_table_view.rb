module TCS
  module Menu

    class MenuTableView < UITableView
      DEFAULT_HEADER_HEIGHT = 20

      attr_accessor :header_height

      def initWithFrame(rect)
        super.tap do
          self.delegate = self
          self.dataSource = self
          self.allowsSelection = true

          @header_height = DEFAULT_HEADER_HEIGHT
          @selected_delegate = nil
          @selected_target = nil

          self.registerClass(TCS::Menu::MenuCell, forCellReuseIdentifier: TCS::Menu::MenuCell.identifier)

          @menuData = Array.new
          @styles = TCS::Menu::default_menu_styles
          self.applyTableStyle(@styles[:table]) if @styles.include? :table
        end
      end

      def defineStyle(styleId, styles)
        @styles[styleId] = styles
        self.applyTableStyle(styles) if styleId == :table
      end

      def setTargetWhenSelected(delegate, target)
        @selected_delegate = delegate
        @selected_target = target
      end

      def clearCells
        @menuData = Array.new
      end

      def setMenuItemAttributes(menuData)
        @menuData = menuData
        @menuData.each_with_index do |item, id|
          if item.include?(:parent) && item[:parent]
            item[:opened] = false unless item.include? :opened
            item[:delegate] = self
            item[:action] = :'menuToggled:'
            item[:arguments] = Hash.new
            item[:arguments][:id] = id
            item[:child] = false
          else
            item[:parent] = false
          end
        end
      end

      def reloadData
        @currentMenu = Array.new

        addChild = true
        @menuData.each do |item|
          if item[:parent]
            addChild = item[:opened]
            @currentMenu << item
          elsif item[:child]
            @currentMenu << item if addChild
          else
            @currentMenu << item
            addChild = true
          end
        end

        super
      end

      def menuToggled(arguments)
        item = @menuData.at(arguments[:id])
        item[:opened] = !item[:opened]
        reloadData
      end

      def numberOfSectionsInTableView(tableView)
        1
      end

      def tableView(tableView, numberOfRowsInSection: section)
        self.scrollEnabled = shouldBeScrollable?
        @currentMenu.size
      end

      def tableView(tableView, cellForRowAtIndexPath: indexPath)
        cellAttributes = @currentMenu.at(indexPath.row)
        cell = tableView.dequeueReusableCellWithIdentifier(TCS::Menu::MenuCell.identifier)
        cell.styles = @styles if cell.respond_to?(:styles) && @styles
        cell.attributes = cellAttributes if cell.respond_to? :attributes
        cell
      end

      def tableView(tableView, shouldHighlightRowAtIndexPath: indexPath)
        cell = cellForRowAtIndexPath(indexPath)
        cell.highlighted = true
        cell.enabled?
      end

      def tableView(tableView, didSelectRowAtIndexPath: indexPath)
        cell = cellForRowAtIndexPath(indexPath)

        if cell.selectable? && @selected_delegate && @selected_target
          @selected_delegate.send(@selected_target)
        end

        cell.send(:performAction) if cell.respond_to? :performAction
      end

      def tableView(tableView, heightForHeaderInSection:seciton)
        @header_height
      end

      def tableView(tableView, viewForHeaderInSection:section)
        view = UIView.alloc.initWithFrame(CGRectZero)
        view.backgroundColor = @styles[:table][:backgroundColor]
        view
      end

      def tableView(tableView, heightForFooterInSection:section)
        0.01
      end

      def tableView(tableView, viewForFooterInSection:section)
        view = UIView.alloc.initWithFrame(CGRectZero)
        view.backgroundColor = @styles[:table][:separatorColor]
        view
      end

      def shouldBeScrollable?
        @currentMenu.size >= minimumCells
      end

      def minimumCells
        (self.bounds.size.height - @header_height) / rowHeight
      end

      def applyTableStyle(style)
        self.backgroundColor = style[:backgroundColor] if style.include? :backgroundColor
        self.separatorColor = style[:separatorColor] if style.include? :separatorColor
        self.separatorStyle = style[:separatorStyle] if style.include? :separatorStyle
      end
    end

  end
end
