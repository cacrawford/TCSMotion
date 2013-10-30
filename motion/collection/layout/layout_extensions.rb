class UICollectionViewLayoutAttributes

  def cell?
    self.representedElementCategory == UICollectionElementCategoryCell
  end

  def decoration?
    self.representedElementCategory == UICollectionElementCategoryDecorationView
  end

  def supplementary?
    self.representedElementCategory == UICollectionElementCategorySupplementaryView
  end

  def header?
    self.representedElementKind == UICollectionElementKindSectionHeader
  end

  def footer?
    self.representedElementKind == UICollectionElementKindSectionFooter
  end

  def intersects?(rect)
    frame.intersects?(rect)
  end

end