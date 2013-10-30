class EnhancedCollectionViewTestController < UIViewController

  attr_reader :collectionView

  def init
    super.tap do
      @layout =
      @collectionView = TCS::EnhancedCollectionView.alloc.initWithFrame(self.view.bounds,
                                                                        collectionViewLayout: EmptyLayout.alloc.init)
      @collectionView.delegate = self
      self.view.addSubview(@collectionView)
    end
  end

end

class TestDefaultCell < TCS::DefaultCell
  def self.indentifier
    'TestDefaultCell'
  end
end

class TestSectionCell < TCS::DefaultCell
  def self.indentifier
    'TestSectionCell'
  end
end

class TestIndexCell < TCS::DefaultCell
  def self.indentifier
    'TestIndexCell'
  end
end

class EmptyLayout < UICollectionViewFlowLayout

end
