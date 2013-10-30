class ViewControllerWithMenuButton < UIViewController

  def showMenuButton?
    true
  end

end

class SideMenuTestController < TCS::Menu::SideMenuController

  def init
    rootController = ViewControllerWithMenuButton.alloc.init
    @menu_width = UIScreen.mainScreen.bounds.size.width / 2
    initWithRootViewController(rootController).tap do
      self.view.accessibilityLabel = viewLabel
    end
  end

  def viewLabel
    'access_view'
  end

  def blockingViewLabel
    'access_blocking_view'
  end

  def menuClosed?
    @navController.view.frame == self.view.bounds
  end

  def menuOpened?
    @navController.view.frame == rectWhenMenuOpen
  end

  def menuIsCorrectWidth?
    @menu.frame.size.width == @menu_width
  end

  def navController
    @navController
  end

  def menuView
    @menu
  end

  def disableNavigation
    super
    @blockingView.accessibilityLabel = blockingViewLabel
  end

  def blockingView
    @blockingView
  end

end

class ValidatingSideMenuTestController < SideMenuTestController

  def init
    rootController = UIViewController.alloc.init
    self.navigationControllerClass = ValidatingNavController
    initWithRootViewController(rootController).tap do

    end
  end

end

