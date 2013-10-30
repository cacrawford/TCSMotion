module TCS

  module CustomBackButton
    include TCS::BarButtonHelper

    def self.included(base)
      base.instance_eval do
        attr_accessor :backAnimated
      end
    end

    def viewDidLoad
      super if self.is_a? UIViewController
      setupImageBackButton
    end

    def setupImageBackButton
      self.navigationItem.leftBarButtonItem = backButton(self, :backButtonPressed)
      self.navigationItem.hidesBackButton = true
    end

    def backButtonPressed
      @backAnimated = true if @backAnimated.nil?
      self.navigationController.popViewControllerAnimated(@backAnimated)
    end

  end

end