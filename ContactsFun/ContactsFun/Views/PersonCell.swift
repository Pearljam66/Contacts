//
//  PersonCell.swift
//  ContactsFun
//
//  Created by Sarah Clark on 3/6/25.
//

import Contacts
import UIKit

class PersonCell: UITableViewCell {
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var contactEmailLabel: UILabel!
    @IBOutlet weak var contactImageView: UIImageView! {
        didSet {
            contactImageView.layer.cornerRadius = 20
            contactImageView.layer.masksToBounds = true
        }
    }

    var person: Person? {
        didSet {
            configurePeopleCell()
        }
    }

    private func configurePeopleCell() {
        let formatter = CNContactFormatter()
        formatter.style = .fullName

        guard let person = person, let name = formatter.string(from: person.contactValue) else { return }

        contactNameLabel.text = name
        contactEmailLabel.text = person.personalEmailAddress
        contactImageView.image = person.profileImage ?? UIImage(systemName: "person.circle")
    }

}
