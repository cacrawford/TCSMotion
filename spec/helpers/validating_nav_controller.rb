class ValidatingNavController < UINavigationController

  def validate
    @validations ||= Hash.new
    callingFunc = caller[0][/`([^']*)'/, 1]
    @validations[callingFunc.to_sym] = true
  end

  def validated?(function)
    @validations ||= Hash.new
    @validations.include?(function.to_sym)
  end

  def validating=(validating)
    @validating = validating
  end

  def validating?
    @validating
  end

  def popToRootViewControllerAnimated(animated)
    validate
    super unless validating?
  end

  def popToViewController(viewController, animated:animated)
    validate
    super unless validating?
  end

  def popViewControllerAnimated(animated)
    validate
    super unless validating?
  end

  def pushViewController(viewController, animated:animated)
    validate
    super unless validating?
  end

  def setNavigationBarHidden(hidden, animated:animated)
    validate
    super unless validating?
  end

  def setToolbarHidden(hidden, animated:animated)
    validate
    super unless validating?
  end

  def setViewControllers(viewControllers, animated:animated)
    validate
    super unless validating?
  end

  def delegate
    validate
    super unless validating?
  end

  def delegate=(delegate)
    validate
    super unless validating?
  end

  def navigationBar
    validate
    super unless validating?
  end

  def navigationBarHidden
    validate
    super unless validating?
  end

  def navigationBarHidden=(hidden)
    validate
    super unless validating?
  end

  def toolbar
    validate
    super unless validating?
  end

  def toolbarHidden
    validate
    super unless validating?
  end

  def toolbarHidden=(hidden)
    validate
    super unless validating?
  end

  def topViewController
    validate
    super unless validating?
  end

  def viewControllers
    validate
    super unless validating?
  end

  def viewControllers=(controllers)
    validate
    super unless validating?
  end

  def visibleViewController
    validate
    super unless validating?
  end
end
