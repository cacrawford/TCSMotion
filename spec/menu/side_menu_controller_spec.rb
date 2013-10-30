describe 'SideMenuController' do
  tests SideMenuTestController

  it 'should start with menu hidden' do
    controller.menuClosed?.should.be.true?
  end

  it 'should open menu when asked' do
    controller.showMenu
    controller.menuOpened?.should.be.true?
  end

  it 'should close menu when asked' do
    controller.showMenu
    controller.menuOpened?.should.be.true?
    controller.hideMenu
    controller.menuOpened?.should.be.false?
  end

  it 'should be created at requested width' do
    controller.menuIsCorrectWidth?.should.be.true?
  end

  it 'should pass menu data to menu view' do
    menu = TCS::Menu::MenuBuilder.new(self) do
      add(TCS::Menu::ActionMenuItem.new('Action1').withAction(:leftArrowSelected))
      add(TCS::Menu::ActionMenuItem.new('Action2').withAction(:rightArrowSelected))
      add(TCS::Menu::ExpandableMenuItem.new('SubMenu1')) do
        add(TCS::Menu::ActionMenuItem.new('SubMenuAction1'))
        add(TCS::Menu::ActionMenuItem.new('SubMenuAction2'))
      end
      add(TCS::Menu::ActionMenuItem.new('Last Menu Item'))
    end

    controller.menuData = menu.build
    controller.menuView.menuData.should == menu.build
  end

  it 'should contain blocking view over navigation view when menu open' do
    controller.showMenu
    wait 0.5 do
      controller.blockingView.frame.should == controller.navController.view.frame
    end
  end

  it 'recognizes right swipe from side to open menu' do
    flick controller.viewLabel, :from => :left
    controller.menuOpened?.should.be.true?
  end

  it 'recognizes tap to close menu' do
    controller.showMenu
    controller.menuOpened?.should.be.true?
    tap controller.blockingViewLabel, :touches => 1
    controller.menuOpened?.should.be.false?
  end

  it 'recognizes swipe from left to close menu' do
    controller.showMenu
    controller.menuOpened?.should.be.true?
    wait 0.5 do
      flick controller.blockingViewLabel, {
          :from => CGPointMake(controller.blockingView.frame.size.width/2, controller.blockingView.frame.size.height/2),
          :to => CGPointMake(controller.blockingView.frame.size.width/2 - 25, controller.blockingView.frame.size.height/2),
          :duration => 0.5}
      controller.menuOpened?.should.be.false?
    end
  end

  it 'should load menu button in navigation bar' do
    controller.navigationBar.topItem.leftBarButtonItem.should.not.be.nil?
  end

  it 'opens the menu when the menu button is clicked' do
    controller.navigationBar.topItem.leftBarButtonItem.accessibilityLabel = 'tapMenu'
    tap 'tapMenu'
    controller.menuOpened?.should.be.true?
  end

end

describe 'SideMenuController with custom navigation class' do
  tests ValidatingSideMenuTestController

  it 'should create custom nav controller class' do
    controller.navController.is_a?(ValidatingNavController).should.be.true?
  end

  it 'should pass nav controller functions to inner nav controller' do
    controller.navController.validating = true
    controller.popToRootViewControllerAnimated(:stub)
    controller.popToViewController(:stub, animated: :stub)
    controller.popViewControllerAnimated(:stub)
    controller.pushViewController(:stub, animated: :stub)
    controller.setNavigationBarHidden(:stub, animated: :stub)
    controller.setToolbarHidden(:stub, animated: :stub)
    controller.setViewControllers(:stub, animated: :stub)
    controller.delegate
    controller.delegate = :stub
    controller.navigationBar
    controller.navigationBarHidden
    controller.navigationBarHidden = :stub
    controller.toolbar
    controller.toolbarHidden
    controller.toolbarHidden = :stub
    controller.topViewController
    controller.viewControllers
    controller.viewControllers = :stub
    controller.visibleViewController
    controller.navController.validating = false

    controller.navController.validated?('popToRootViewControllerAnimated:').should.be.true?
    controller.navController.validated?('popToViewController:animated:').should.be.true?
    controller.navController.validated?('popViewControllerAnimated:').should.be.true?
    controller.navController.validated?('pushViewController:animated:').should.be.true?
    controller.navController.validated?('setNavigationBarHidden:animated:').should.be.true?
    controller.navController.validated?('setToolbarHidden:animated:').should.be.true?
    controller.navController.validated?('setViewControllers:animated:').should.be.true?
    controller.navController.validated?('delegate').should.be.true?
    controller.navController.validated?('delegate=:').should.be.true?
    controller.navController.validated?('navigationBar').should.be.true?
    controller.navController.validated?('navigationBarHidden').should.be.true?
    controller.navController.validated?('navigationBarHidden=:').should.be.true?
    controller.navController.validated?('toolbar').should.be.true?
    controller.navController.validated?('toolbarHidden').should.be.true?
    controller.navController.validated?('toolbarHidden=:').should.be.true?
    controller.navController.validated?('topViewController').should.be.true?
    controller.navController.validated?('viewControllers').should.be.true?
    controller.navController.validated?('viewControllers=:').should.be.true?
    controller.navController.validated?('visibleViewController').should.be.true?
  end
end