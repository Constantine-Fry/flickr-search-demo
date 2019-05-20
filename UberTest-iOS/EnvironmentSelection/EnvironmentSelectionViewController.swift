//
//  Created by Constantine Fry on 20.05.19.
//  Copyright © 2019 lololo. All rights reserved.
//

import UIKit
import BusinessLogicKit

final class EnvironmentSelectionViewController: UIViewController,
    UITableViewDelegate, UITableViewDataSource, EnvironmentSelectionViewing  {

    @IBOutlet var tableView: UITableView!
    var presenter: EnvironmentSelectionPresenting!

    private var items = [SelectionItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.ready()
    }

    func set(state: EnvironmentSelectionState) {
        self.items = state.items
        self.title = state.title
        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.items[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.items[indexPath.row].action()
    }

}
