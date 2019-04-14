//
//  ViewController.swift
//  UberTest-macOS
//
//  Created by Constantine Fry on 12.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import Cocoa
import BusinessLogicKit

class ViewController: NSViewController, ImageSearchViewing {

    private var viewItem: ImageSearchViewItem?

    @IBOutlet var collectionView: NSCollectionView!

    @IBOutlet var searchField: NSSearchFieldCell!

    var presenter: (ImageSearchPresenting & ImageLoadPresenting)?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.ready()
    }

    func update(_ state: ImageViewState) {
        switch state {
        case .presentError(let text):
            self.viewItem = nil
            NSApplication.shared.windows.first?.title = text
        case .showEmpty:
            self.viewItem = nil
            NSApplication.shared.windows.first?.title = "Search"
        case .set(let item):
            NSApplication.shared.windows.first?.title = "\(item.photos.count) photos"
            self.viewItem = item
        case .showLoading:
            self.viewItem = nil
            NSApplication.shared.windows.first?.title = "Loading"
        }
        self.collectionView.reloadData()
    }


}

extension ViewController: NSSearchFieldDelegate {

    func controlTextDidChange(_ obj: Notification) {
        self.presenter?.search(term: self.searchField.stringValue)
    }

}

extension ViewController: NSCollectionViewDataSource, NSCollectionViewDelegate {

    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewItem?.photos.count ?? 0
    }

    func collectionView(_ collectionView: NSCollectionView,
                        itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"),
                                           for: indexPath) as! CollectionViewItem
        cell.imageView?.layer?.backgroundColor = NSColor.clear.cgColor
        if let photo = cell.photo {
            self.presenter?.stopLoadImage(for: photo)
        }
        let photo = self.viewItem!.photos[indexPath.item]
        cell.photo = photo
        if let image = self.presenter?.cachedImage(for: photo) {
            cell.imageView?.image = NSImage(cgImage: image, size: NSSize(width: image.width, height: image.height))
        }
        if let viewItem = self.viewItem, indexPath.item == viewItem.photos.count - 20 {
            self.presenter?.loadMore(for: viewItem)
        }

        return cell
    }

    func collectionView(_ collectionView: NSCollectionView,
                        willDisplay item: NSCollectionViewItem, forRepresentedObjectAt indexPath: IndexPath) {
        if let cell = item as? CollectionViewItem, let photo = cell.photo, cell.imageView?.image == nil {
            self.presenter?.loadImage(for: photo, completion: { (image) in
                if let image = image {
                    cell.imageView?.image = NSImage(cgImage: image, size: NSSize(width: image.width, height: image.height))
                } else {
                    cell.imageView?.layer?.backgroundColor = NSColor.black.cgColor
                }
            })
        }
    }

}

extension ViewController: NSCollectionViewPrefetching {

    func collectionView(_ collectionView: NSCollectionView, prefetchItemsAt indexPaths: [IndexPath]) {

    }


}

