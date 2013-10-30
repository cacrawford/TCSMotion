
describe 'EnhancedCollectionView' do
  tests EnhancedCollectionViewTestController

  it 'should create view with layout and data' do
    data = Array.new
    100.times do |index|
      data << "Cell #{index}"
    end

    controller.collectionView.setCellDataForSection(0, data)
    controller.collectionView.cellsForSection(0).at(1).should == 'Cell 1'
  end

  it 'should return default cell class when no section or cell class specified' do
    controller.collectionView.defaultCellClass = TestDefaultCell

    controller.collectionView.appendCellToSection(0, 'section0')
    controller.collectionView.appendCellToSection(1, 'section1')
    controller.collectionView.cellsForSection(0).size.should == 1
    controller.collectionView.cellsForSection(1).size.should == 1
    controller.collectionView.getIndexIdentifier([0,0].nsindexpath).should == TestDefaultCell.identifier
    controller.collectionView.getIndexIdentifier([1,0].nsindexpath).should == TestDefaultCell.identifier
  end

  it 'should override default cell class with section cell class' do
    controller.collectionView.defaultCellClass = TestDefaultCell
    controller.collectionView.setCellClassForSection(0, TestSectionCell)

    controller.collectionView.appendCellToSection(0, 'section0')
    controller.collectionView.appendCellToSection(1, 'section1')
    controller.collectionView.cellsForSection(0).size.should == 1
    controller.collectionView.cellsForSection(1).size.should == 1
    controller.collectionView.getIndexIdentifier([0,0].nsindexpath).should == TestSectionCell.identifier
    controller.collectionView.getIndexIdentifier([1,0].nsindexpath).should == TestDefaultCell.identifier
  end

  it 'should override section cell class with index cell class' do
    controller.collectionView.defaultCellClass = TestDefaultCell
    controller.collectionView.setCellClassForSection(0, TestSectionCell)

    controller.collectionView.appendCellToSection(0, 'section0x0', TestIndexCell)
    controller.collectionView.appendCellToSection(0, 'section0x1')
    controller.collectionView.appendCellToSection(1, 'section1')
    controller.collectionView.cellsForSection(0).size.should == 2
    controller.collectionView.cellsForSection(1).size.should == 1
    controller.collectionView.getIndexIdentifier([0,0].nsindexpath).should == TestIndexCell.identifier
    controller.collectionView.getIndexIdentifier([0,1].nsindexpath).should == TestSectionCell.identifier
    controller.collectionView.getIndexIdentifier([1,0].nsindexpath).should == TestDefaultCell.identifier
  end

end

