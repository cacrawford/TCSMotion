module TCS
  UIGestureRecognizerSwipeFromLeft = :swipeFromLeft
  UIGestureRecognizerSwipeFromRight = :swipeFromRight
  UIGestureRecognizerSwipeFromTop = :swipeFromTop
  UIGestureRecognizerSwipeFromBottom = :swipeFromBottom

  class SideSwipeGestureRecognizer < UISwipeGestureRecognizer
    DEFAULT_EDGE_TOLERANCE = 10
    DEFAULT_DIRECTION_TOLERANCE = 10
    DEFAULT_DETECTION_DISTANCE = 50

    attr_accessor :edge_tolerance
    attr_accessor :direction_tolerance
    attr_accessor :detection_distance

    def initWithTarget(target, action:action)
      super.tap do
        self.direction = UIGestureRecognizerSwipeFromLeft
        @edge_tolerance = DEFAULT_EDGE_TOLERANCE
        @direction_tolerance = DEFAULT_DIRECTION_TOLERANCE
        @detection_distance = DEFAULT_DETECTION_DISTANCE
      end
    end

    def direction=(swipeFromDirection)
      @direction = case swipeFromDirection
                    when UIGestureRecognizerSwipeFromLeft
                      UISwipeGestureRecognizerDirectionRight
                    when UIGestureRecognizerSwipeFromRight
                      UISwipeGestureRecognizerDirectionLeft
                    when UIGestureRecognizerSwipeFromTop
                      UISwipeGestureRecognizerDirectionDown
                    when UIGestureRecognizerSwipeFromBottom
                      UISwipeGestureRecognizerDirectionUp
                    else
                      swipeFromDirection
                  end
    end

    def touch_on_edge?(point)
      case @direction
        when UISwipeGestureRecognizerDirectionRight
          point.x <= @edge_tolerance
        when UISwipeGestureRecognizerDirectionLeft
          point.x >= (self.view.bounds.size.width - @edge_tolerance)
        when UISwipeGestureRecognizerDirectionUp
          point.y <= @edge_tolerance
        else # UISwipeGestureRecognizerDirectionDown
          point.y >= (self.view.bounds.size.height - @edge_tolerance)
      end
    end

    def swiped_enough?(point)
      return false if @origin.nil?

      case @direction
        when UISwipeGestureRecognizerDirectionRight
          point.x - @origin.x >= @detection_distance
        when UISwipeGestureRecognizerDirectionLeft
          @origin.x - point.x >= @detection_distance
        when UISwipeGestureRecognizerDirectionUp
          point.y - @origin.y >= @detection_distance
        else # UISwipeGestureRecognizerDirectionDown
          @origin.y - point.y >= @detection_distance
      end
    end

    def swipe_in_wrong_direction?(point)
      return true if @origin.nil?

      case @direction
        when UISwipeGestureRecognizerDirectionRight || UISwipeGestureRecognizerDirectionLeft
          (@origin.y - point.y).abs > @direction_tolerance
        else # UISwipeGestureRecognizerDirectionUp || UISwipeGestureRecognizerDirectionDown
          (@origin.x - point.x).abs > @direction_tolerance
      end
    end

    def touchesBegan(touches, withEvent:event)
      super

      pos = self.locationOfTouch(0, inView: self.view)
      if touch_on_edge?(pos)
        @origin = pos
        self.state = UIGestureRecognizerStatePossible
      else
        self.reset
      end
    end

    def touchesCancelled(touches, withEvent:event)
      self.reset
    end

    def touchesEnded(touches, withEvent:event)
      self.reset
    end

    def touchesMoved(touches, withEvent:event)
      super

      unless @origin.nil?
        pos = touches.anyObject.locationInView(self.view)
        if swiped_enough?(pos)
          self.state = UIGestureRecognizerStateEnded
        elsif swipe_in_wrong_direction?(pos)
          self.reset
        end
      end
    end

    def reset
      @origin = nil
      self.state = UIGestureRecognizerStateFailed
    end

  end

end
