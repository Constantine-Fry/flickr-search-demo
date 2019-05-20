//
//  Created by Constantine Fry on 14.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import UIKit

final class InstagramCollectionViewLayout: UICollectionViewFlowLayout {

    var items = [UICollectionViewLayoutAttributes]()

    override func prepare() {
        super.prepare()
        let frames = self.frames(count: self.collectionView!.numberOfItems(inSection: 0),
                                 viewWidth: self.collectionView!.frame.width)
        self.items = frames.enumerated().map({
            let attribute = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: $0.offset, section: 0))
            attribute.frame = $0.element
            return attribute
        })
    }

    private func frames(count: Int, viewWidth: CGFloat) -> [CGRect] {
        if count == 0 {
            return []
        }
        let space: CGFloat = 2
        let width = (self.collectionView!.frame.size.width - space * 2) / 3
        let largeItemSize = CGSize(width: width * 2 + space, height: width * 2 + space)
        let smallItemSize = CGSize(width: width, height: width)
        var y: CGFloat = 0
        return (0...count-1).map { (num) in
            var frame = CGRect.zero
            let num = num % 18 + 1
            if num == 1 {
                frame = CGRect(x: 0, y: y,
                               width: smallItemSize.width, height: smallItemSize.height)
            }
            if num == 2 {
                frame = CGRect(x: 0, y: y + smallItemSize.height + space,
                               width: smallItemSize.width, height: smallItemSize.height)
            }
            if num == 3 {
                frame = CGRect(x: smallItemSize.width + space, y: y,
                               width: largeItemSize.width , height: largeItemSize.height)
                y += largeItemSize.height + space
            }

            if num == 10 {
                frame = CGRect(x: 0, y: y,
                               width: largeItemSize.width, height: largeItemSize.height)
            }
            if num == 11 {
                frame = CGRect(x: largeItemSize.width + space, y: y ,
                               width: smallItemSize.width, height: smallItemSize.height)
            }
            if num == 12 {
                frame = CGRect(x: largeItemSize.width + space,
                               y: y + smallItemSize.height + space,
                               width: smallItemSize.width, height: smallItemSize.height)
                y += largeItemSize.height + space
            }
            if num >= 4 && num <= 9 || num >= 13 && num <= 18 {
                var x: CGFloat = 0
                if num % 3 == 0 {
                    x = (smallItemSize.width + space) * 2
                } else if num % 3 == 2 {
                    x = smallItemSize.width + space
                }
                frame = CGRect(x: x, y: y, width: smallItemSize.width, height: smallItemSize.height)
                if num == 6 || num == 9 || num == 15 || num == 18 {
                    y += smallItemSize.height + space
                }
            }
            return frame
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
