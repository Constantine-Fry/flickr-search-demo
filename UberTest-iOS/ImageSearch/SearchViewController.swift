//
//  ViewController.swift
//  ZippityDoDa
//
//  Created by Constantine Fry on 07.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import UIKit
import BusinessLogicKit

class SearchViewController: UIViewController, ImageSearchViewing {

    var name = ""

    @IBOutlet private var searchField: UISearchBar!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet private var collectienView: UICollectionView!

    private var viewItem: ImageSearchViewItem?

    var presenter: (ImageSearchPresenting & ImageLoadPresenting)?

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.ready()
    }

    func update(_ state: ImageViewState) {
        switch state {
        case .presentError(let text):
            self.activityIndicator.stopAnimating()
            self.viewItem = nil
            self.title = self.name
            self.errorLabel.text = text
            self.errorLabel.isHidden = false
        case .showEmpty:
            self.activityIndicator.stopAnimating()
            self.viewItem = nil
            self.title = self.name
            self.errorLabel.isHidden = true
        case .set(let item):
            self.activityIndicator.stopAnimating()
            self.viewItem = item
            self.title = "\(item.photos.count) photos"
            self.errorLabel.isHidden = true
        case .showLoading:
            self.activityIndicator.startAnimating()
            self.viewItem = nil
            self.title = self.name
            self.errorLabel.isHidden = true
        }
        self.collectienView.reloadData()
    }

}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewItem?.photos.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectienView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        cell.backgroundColor = .white
        if let photo = cell.photo {
            self.presenter?.stopLoadImage(for: photo)
        }
        let photo = self.viewItem!.photos[indexPath.row]
        cell.photo = photo
        if let image = self.presenter?.cachedImage(for: photo) {
            cell.imageView.image = UIImage(cgImage: image)
        }
        if let viewItem = self.viewItem, indexPath.row == viewItem.photos.count - 20 {
            self.presenter?.loadMore(for: viewItem)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ImageCell, let photo = cell.photo, cell.imageView.image == nil {
            self.presenter?.loadImage(for: photo, completion: { (image) in
                if let image = image {
                    UIView.transition(with: cell.imageView, duration: 0.2, options: .transitionCrossDissolve,
                                      animations: { cell.imageView.image = UIImage(cgImage: image)},
                                      completion: nil)
                } else {
                    cell.backgroundColor = .black
                }
            })
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ImageCell, let photo = cell.photo {
            self.presenter?.stopLoadImage(for: photo)
        }
    }


}

extension SearchViewController: UICollectionViewDataSourcePrefetching {

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { (indexPath) in
            let photo = self.viewItem!.photos[indexPath.row]
            if self.presenter?.cachedImage(for: photo) == nil {
                self.presenter?.loadImage(for: photo, completion: { (_) in })
            }
        }
    }
    
}

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.presenter?.search(term: searchText )
    }

}

