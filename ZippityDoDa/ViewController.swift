//
//  ViewController.swift
//  ZippityDoDa
//
//  Created by Constantine Fry on 07.04.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import UIKit
import BusinessLogicKit

class ViewController: UIViewController, ImageSearchViewing {

    @IBOutlet private var searchField: UISearchBar!
    @IBOutlet private var collectienView: UICollectionView!

    private var viewItem: ImageSearchViewItem?

    var presenter: ImageSearchPresenting?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func update(_ update: ImageViewUpdate) {
        switch update {
        case .presentError(let text):
            self.viewItem = nil
            self.showError(text)
        case .showEmpty:
            self.viewItem = nil
            break
        case .set(let item):
            self.viewItem = item
        case .append:
            break
        }
        self.collectienView.reloadData()
    }

    private func showError(_ text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }


}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewItem?.images.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectienView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .gray
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = round(collectienView.frame.size.width/3)
        return CGSize(width: size, height: size)
    }

}

extension ViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.presenter?.search(term: searchText )
    }

}

