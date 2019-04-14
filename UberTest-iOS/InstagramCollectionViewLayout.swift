//
//  Created by Constantine Fry on 14.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import UIKit

final class InstagramCollectionViewLayout: UICollectionViewFlowLayout {

    var items = [UICollectionViewLayoutAttributes]()

    override func prepare() {
        super.prepare()
        let space: CGFloat = 2
        let width = (self.collectionView!.frame.size.width - space * 2) / 3
        let largeItemSize = CGSize(width: width * 2 + space, height: width * 2 + space)
        let smallItemSize = CGSize(width: width, height: width)
        self.minimumLineSpacing = 2
        self.minimumInteritemSpacing = 2
        self.items = [UICollectionViewLayoutAttributes]()
        let count = self.collectionView!.numberOfItems(inSection: 0)
        if count == 0 {
            return
        }
        var y: CGFloat = 0
        (0...count-1).forEach { (num) in
            let attribute = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: num, section: 0))
            let num = attribute.indexPath.item % 18
            if num == 0 {
                attribute.frame = CGRect(x: 0, y: y,
                                         width: smallItemSize.width, height: smallItemSize.height)
            }
            if num == 1 {
                attribute.frame = CGRect(x: 0, y: y + smallItemSize.height + space,
                                         width: smallItemSize.width, height: smallItemSize.height)
            }
            if num == 2 {
                attribute.frame = CGRect(x: smallItemSize.width + space, y: y,
                                         width: largeItemSize.width , height: largeItemSize.height)
                y += largeItemSize.height + space
            }

            if num == 10 {
                attribute.frame = CGRect(x: 0, y: y,
                                         width: largeItemSize.width, height: largeItemSize.height)
            }
            if num == 11 {
                attribute.frame = CGRect(x: largeItemSize.width + space, y: y ,
                                         width: smallItemSize.width, height: smallItemSize.height)
            }
            if num == 12 {
                attribute.frame = CGRect(x: largeItemSize.width + space,
                                         y: y + smallItemSize.height + space,
                                         width: smallItemSize.width, height: smallItemSize.height)
                y += largeItemSize.height + space
            }
            if num >= 4 && num <= 9 || num >= 13 && num <= 18 {
                attribute.frame = CGRect(x: CGFloat(num % 3) * (smallItemSize.width + space),
                                         y: y, width: smallItemSize.width, height: smallItemSize.height)
                if num == 6 || num == 9 || num == 15 || num == 18 {
                    y += smallItemSize.height + space
                }
            }
            self.items.append(attribute)
        }
    }

    override var collectionViewContentSize: CGSize {
        let height = self.items.last?.frame.maxY ?? 0
        return CGSize(width: self.collectionView!.frame.width, height: height)
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.items[indexPath.item]
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in self.items {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

}
