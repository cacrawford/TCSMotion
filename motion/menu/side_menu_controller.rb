module TCS
  module Menu

    class SideMenuController < UIViewController
      alias :'super_init' :'init'

      attr_accessor :menu_width
      attr_accessor :navigationControllerClass

      def initWithRootViewController(rootViewController)
        super_init.tap do
          @menu_width ||= 300
          @menuHidden = CGRectMake(0, 0, @menu_width, BW::Device::Screen::height)
          @menuShown = @menuHidden

          @menu = TCS::Menu::MenuTableView.alloc.initWithFrame(@menuHidden)
          @menu.setTargetWhenSelected(self, :hideMenu)
          self.view.addSubview(@menu)

          @menu.reloadData unless @menuData.nil?
          @menuData = nil

          @navigationControllerClass ||= TCS::MenuNavigationController
          createController(rootViewController)
        end
      end

      def viewDidLoad
        super

        @menu_width ||= 300
      end

      # Convenience methods to mimic navigation controller
      def popToRootViewControllerAnimated(animated)
        @navController.popToRootViewControllerAnimated(animated)
      end

      def popToViewController(viewController, animated:animated)
        @navController.popToViewController(viewController, animated:animated)
      end

      def popViewControllerAnimated(animated)
        @navController.popViewControllerAnimated(animated)
      end

      def pushViewController(viewController, animated:animated)
        @navController.pushViewController(viewController, animated:animated)
      end

      def setNavigationBarHidden(hidden, animated:animated)
        @navController.setNavigationBarHidden(hidden, animated:animated)
      end

      def setToolbarHidden(hidden, animated:animated)
        @navController.setToolbarHidden(hidden, animated:animated)
      end

      def setViewControllers(viewControllers, animated:animated)
        @navController.setViewControllers(viewControllers, animated:animated)
      end

      def delegate
        @navController.delegate
      end

      def delegate=(delegate)
        @navController.delegate = delegate
      end

      def navigationBar
        @navController.navigationBar
      end

      def navigationBarHidden
        @navController.navigationBarHidden
      end

      def navigationBarHidden=(hidden)
        @navController.navigationBarHidden = hidden
      end

      def toolbar
        @navController.toolbar
      end

      def toolbarHidden
        @navController.toolbarHidden
      end

      def toolbarHidden=(hidden)
        @navController.toolbarHidden = hidden
      end

      def topViewController
        @navController.topViewController
      end

      def viewControllers
        @navController.viewControllers
      end

      def viewControllers=(controllers)
        @navController.viewControllers = controllers
      end

      def visibleViewController
        @navController.visibleViewController
      end

      def menuData=(menuData)
        if @menu.nil?
          @menuData = menuData
        else
          @menu.setMenuItemAttributes(menuData)
          @menu.reloadData
        end
      end

      def menuStyle=(menuStyle)
        menuStyle.each do |styleName, styles|
          @menu.defineStyle(styleName, styles)
        end
      end

      def showMenu
        unless @menuData.nil?
          @menu.scrollToRowAtIndexPath([0,0].nsindexpath, atScrollPosition:UITableViewScrollPositionTop, animated:false)
        end
        UIView.animateWithDuration(0.25,
                                   animations: lambda {
                                     @navController.view.frame = rectWhenMenuOpen
                                   },
                                   completion: lambda { |finished| disableNavigation })
      end

      def hideMenu
        UIView.animateWithDuration(0.25,
                                   animations: lambda {
                                     @navController.view.frame = self.view.bounds
                                   },
                                   completion: lambda { |finished| enableNavigation })
      end

      def willAnimateRotationToInterfaceOrientation(fromInterfaceOrientation, duration:duration)
        super

        rect = @menu.frame
        rect.size.height = @navController.view.bounds.size.height
        @menu.frame = rect
      end

      protected

      def createController(rootViewController)
        @navController = @navigationControllerClass.alloc.initWithRootViewController(rootViewController)

        @navController.menuTarget = self if @navController.respond_to? :menuTarget
        @navController.menuAction = :showMenu if @navController.respond_to? :menuAction

        unless self.view.nil?
          addChildViewController(@navController)
          @navController.view.frame = self.view.bounds
          self.view.addSubview(@navController.view)
          @navController.didMoveToParentViewController(self)

          @swipeGesture = TCS::SideSwipeGestureRecognizer.alloc.initWithTarget(self, action: :'swipeToOpen:')
          @swipeGesture.direction = TCS::UIGestureRecognizerSwipeFromLeft
          @navController.view.addGestureRecognizer(@swipeGesture)
        end
      end

      def swipeToOpen(recognizer)
        showMenu
      end

      def swipeToClose(recognizer)
        hideMenu
      end

      def tapped(recognizer)
        hideMenu
      end

      def rectWhenMenuOpen
        CGRectMake(@menu_width,
                   0,
                   @navController.view.bounds.size.width,
                   @navController.view.bounds.size.height)
      end

      def disableNavigation
        @blockingView = UIView.alloc.initWithFrame(rectWhenMenuOpen)
        @blockingView.backgroundColor = UIColor.clearColor
        self.view.insertSubview(@blockingView, aboveSubview: @navController.view)
        @blockingView.addGestureRecognizer(UITapGestureRecognizer.alloc.initWithTarget(self, action: 'tapped:'))

        gesture = UISwipeGestureRecognizer.alloc.initWithTarget(self, action: :'swipeToClose:')
        gesture.direction = UISwipeGestureRecognizerDirectionLeft
        @blockingView.addGestureRecognizer(gesture)
      end

      def enableNavigation
        return if @blockingView.nil?
        @blockingView.removeFromSuperview
        @blockingView = nil
      end

    end

  end
end

