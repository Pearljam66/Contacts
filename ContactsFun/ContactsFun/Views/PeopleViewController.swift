//
//  PeopleViewController.swift
//  ContactsFun
//
//  Created by Sarah Clark on 3/5/25.
//

import UIKit

class PeopleViewController: UITableViewController {
    @IBAction private func addFriends(sender: UIBarButtonItem) {

    }

    var peopleList = Person.defaultContacts()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "People"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.tintColor = .black
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Add code later.
    }

}

// MARK: - UITableViewDataSource
extension PeopleViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)

        if let cell = cell as? PersonCell {
            let person = peopleList[indexPath.row]
            cell.person = person
        }

        return cell
    }

}

// MARK: - UITableViewDelegate
extension PeopleViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
