module TCS
  class SideViewController < UIViewController
    alias :'super_init' :'init'

    attr_accessor :sideControllerSize
    attr_reader :mainController
    attr_reader :sideController

    def initWithMainController(mainController, sideController: sideController, side: side)
      super_init.tap do
        raise ArgumentError, "Invalid value for side: #{side}" unless [:left, :right, :top, :bottom].include? side
        @mainController = mainController
        @sideController = sideController
        @side = side
        @sideControllerSize ||= @sideController.view.frame.size

        self.view.autoresizesSubviews = false

        @sideController.view.frame = sideViewRect
        @mainController.view.frame = mainViewRect

        self.addChildViewController(@sideController)
        @sideController.didMoveToParentViewController(self)
        self.addChildViewController(@mainController)
        @mainController.didMoveToParentViewController(self)

        self.view.addSubview(@sideController.view)
        self.view.addSubview(@mainController.view)
      end
    end

    def viewWillAppear(animated)
      super

      @sideController.view.frame = sideViewRect
      @mainController.view.frame = mainViewRect
    end

    def opened?
      @opened.nil? ? false : @opened
    end

    def opened=(opened)
      @opened = opened

      @sideController.view.frame = sideViewRect unless @sideController.nil?
      @mainController.view.frame = mainViewRect unless @mainController.nil?
    end

    def showSideView
      @opened = true
      UIView.animateWithDuration(
          0.25,
          animations: lambda {
            @mainController.view.frame = mainViewRect(false)
          },
          completion: lambda { |finished|
            @mainController.view.frame = mainViewRect
          })
    end

    def hideSideView
      @opened = false
      UIView.animateWithDuration(
          0.25,
          animations: lambda {
            @mainController.view.frame = mainViewRect
          })
    end

    def willAnimateRotationToInterfaceOrientation(interfaceOrientation, duration:duration)
      @sideController.view.frame = sideViewRect
      @mainController.view.frame = mainViewRect
      super
    end

    protected

    def sideViewRect

      case @side
        when :left
          CGRectMake(0, 0, @sideControllerSize.width, self.view.size.height)
        when :right
          CGRectMake(self.view.frame.size.width - @sideControllerSize.width,
                     0,
                     @sideControllerSize.width,
                     self.view.frame.size.height)
        when :top
          CGRectMake(0, 0, self.view.frame.size.width, @sideControllerSize.height)
        when :bottom
          CGRectMake(0,
                     self.view.frame.size.height - @sideControllerSize.height,
                     self.view.frame.size.width,
                     @sideControllerSize.height)
        else
          raise ArgumentError, "Invalid side #{@side}"
      end
    end

    def mainViewRect(resize = true)
      return self.view.bounds unless opened?

      sizeSelf = self.view.frame.size
      sizeMain = if resize
                   CGSizeMake(sizeSelf.width - @sideControllerSize.width,
                              sizeSelf.height - @sideControllerSize.height)
                 else
                   self.view.frame.size
                 end

      case @side
        when :left
          CGRectMake(@sideControllerSize.width, 0, sizeMain.width, sizeSelf.height)
        when :right
          CGRectMake(0, 0, sizeMain.width, sizeSelf.height)
        when :top
          CGRectMake(0, @sideControllerSize.height, sizeSelf.width, sizeMain.height)
        when :bottom
          CGRectMake(0, 0, sizeSelf.width, sizeMain.height)
        else
          raise ArgumentError, "Invalid side #{@side}"
      end
    end
  end

end
