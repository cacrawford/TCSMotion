module TCS
  module Menu
    class MenuTableView < UITableView

      def numMenuItems
        @menuData.nil? ? 0 : @menuData.size
      end

      def isMenuItemVisible?(name)
        @currentMenu.each do |cell|
          return true if cell[:text] == name
        end
        false
      end

      def selectMenuItem(name)
        @currentMenu.each_with_index do |cell, index|
          return tableView(@menu, didSelectRowAtIndexPath: [0,index].nsindexpath) if cell[:text] == name
        end
      end

      def menuData
        @menuData
      end

    end
  end
end
