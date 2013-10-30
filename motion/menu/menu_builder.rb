module TCS
  module Menu

    class MenuItem
      attr_reader :attributes

      def initialize(title, attributes = {})
        self.tap do
          @attributes = Hash.new
          @attributes.replace(attributes)
          @attributes[:text] = title
          @attributes[:enabled] ||= true
          @attributes[:child] ||= false
          @attributes[:parent] ||= false
        end
      end

      def withDisabled
        self.tap do
          @attributes[:enabled] = false
        end
      end

      def parent?
        @attributes.include?(:parent) && @attributes[:parent]
      end
    end

    class ActionMenuItem < MenuItem

      def withAction(action, arguments = {})
        self.tap do
          @attributes[:action] = action
          @attributes[:arguments] = arguments
        end
      end
    end

    class ExpandableMenuItem < MenuItem

      def initialize(title, attributes = {})
        super.tap do
          @attributes[:parent] = true
          @attributes[:opened] ||= false
        end
      end

      def withOpened
        self.tap do
          @attributes[:opened] = true
        end
      end

    end

    class MenuBuilder

      def initialize(delegate, &block)
        self.tap do
          @delegate = delegate
          @menuData = Array.new
          @levels = 0
          instance_eval &block if block_given?
        end
      end

      def add(menuItem, &block)
        menuItem.attributes[:delegate] = @delegate if menuItem.attributes[:delegate].nil?
        menuItem.attributes[:child] = @levels > 0
        @menuData << menuItem.attributes

        if menuItem.parent?
          @levels += 1
          block.call if block_given?
          @levels -= 1
        end
      end

      def build
        @menuData
      end

    end

  end
end
