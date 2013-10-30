class SideViewTestController < TCS::SideViewController

  def initWithSide(side)
    mainController = UIViewController.alloc.init
    sideController = UIViewController.alloc.init
    self.sideControllerSize = CGSizeMake(200,200)

    mainController.view.backgroundColor = [220,20,60].uicolor
    sideController.view.backgroundColor = [255,253,208].uicolor

    initWithMainController(mainController, sideController:sideController, side: side).tap do

    end
  end

  def sideViewOpened?
    !sideViewClosed?
  end

  def sideViewClosed?
    mainViewRect == self.view.bounds
  end

  def verify_on_left?
    @sideController.view.origin.x == 0 && @sideController.view.frame.size.width == @sideControllerSize.width
  end

  def verify_on_right?
    @sideController.view.origin.x == self.view.frame.size.width - @sideControllerSize.width
  end

  def verify_on_top?
    @sideController.view.origin.y == 0 && @sideController.view.frame.size.height == @sideControllerSize.height
  end

  def verify_on_bottom?
    @sideController.view.origin.y == self.view.frame.size.height - @sideControllerSize.height
  end

  def verify_main_to_left?
    @mainController.view.frame.origin.x = @sideControllerSize.width &&
        @mainController.view.frame.size.width == self.view.frame.size.width - @sideControllerSize.width
  end

  def verify_main_to_right?
    @mainController.view.frame.origin.x = 0 &&
        @mainController.view.frame.size.width == self.view.frame.size.width - @sideControllerSize.width
  end

  def verify_main_to_top?
    @mainController.view.frame.origin.y = @sideControllerSize.height &&
        @mainController.view.frame.size.height == self.view.frame.size.height - @sideControllerSize.height
  end

  def verify_main_to_bottom?
    @mainController.view.frame.origin.y = 0 &&
        @mainController.view.frame.size.height == self.view.frame.size.height - @sideControllerSize.height
  end


end


class LeftSideViewTestController < SideViewTestController
  def init
    initWithSide(:left).tap do

    end
  end
end

class RightSideViewTestController < SideViewTestController
  def init
    initWithSide(:right).tap do

    end
  end
end

class TopSideViewTestController < SideViewTestController
  def init
    initWithSide(:top).tap do

    end
  end
end

class BottomSideViewTestController < SideViewTestController
  def init
    initWithSide(:bottom).tap do

    end
  end
end