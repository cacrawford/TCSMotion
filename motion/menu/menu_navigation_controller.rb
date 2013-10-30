module TCS

  class MenuNavigationController < UINavigationController
    include TCS::BarButtonHelper

    attr_accessor :menuTarget
    attr_accessor :menuAction

    def initWithRootViewController(viewController)
      @menuTarget = nil
      @menuAction = nil
      @externalDelegate = nil

      super.tap do
        self.delegate = self
      end
    end

    def navigationController(navigationController, willShowViewController:viewController, animated:animated)
      if viewController.respond_to?(:showMenuButton?) && viewController.showMenuButton?
        viewController.navigationItem.leftBarButtonItem = menuButton(self, :menuSelected)
      end
    end

    def delegate=(delegate)
      raise ArgumentError, 'Cannot set delegate for MenuNavigationController' unless delegate == self
      super(self)
    end

    def menuSelected
      return if @menuTarget.nil? || @menuAction.nil?
      @menuTarget.send(@menuAction)
    end

  end

end