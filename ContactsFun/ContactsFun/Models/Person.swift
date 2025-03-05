//
//  Person.swift
//  ContactsFun
//
//  Created by Sarah Clark on 3/4/25.
//

import Contacts
import UIKit

final class Person {
    let id: String?
    let firstName: String
    let lastName: String
    let personalEmailAddress: String
    let profileImage: UIImage?
    var storedContact: CNMutableContact?
    var phoneNumberField: (CNLabeledValue<CNPhoneNumber>)?

    init(firstName: String, lastName: String, emailAddress: String, profileImage: UIImage?) {
        self.id = UUID().uuidString
        self.firstName = firstName
        self.lastName = lastName
        self.personalEmailAddress = emailAddress
        self.profileImage = profileImage
    }

    private static func defaultContacts() -> [Person] {
        return [
            Person(firstName: "Rachel", lastName: "McKitty", emailAddress: "Rachel@cats.com", profileImage: UIImage(named: "rachelpicture")),
            Person(firstName: "Kate", lastName: "McFriend", emailAddress: "Kate@friends.com", profileImage: UIImage(named: "katepicture")),
            Person(firstName: "Orko", lastName: "McPuppy", emailAddress: "Orko@puppy.com", profileImage: UIImage(named: "orkopicture")),
            Person(firstName: "Molly", lastName: "McPuppy", emailAddress: "Molly@puppy.com", profileImage: UIImage(named: "mollypicture")),
            Person(firstName: "Eric", lastName: "McFriend", emailAddress: "Eric@friends.com", profileImage: UIImage(named: "ericpicture")),
            Person(firstName: "Logan", lastName: "McNephew", emailAddress: "Logan@nephews.com", profileImage: UIImage(named: "loganpicture"))]
    }

}

extension Person: Identifiable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.firstName == rhs.firstName &&
        lhs.lastName == rhs.lastName &&
        lhs.personalEmailAddress == rhs.personalEmailAddress &&
        lhs.profileImage?.pngData() == rhs.profileImage?.pngData()
    }

}

extension Person {
    var contactValue: CNContact {
        let contact = CNMutableContact()
        contact.givenName = firstName
        contact.familyName = lastName
        contact.emailAddresses = [CNLabeledValue(label: CNLabelHome, value: personalEmailAddress as NSString)]

        if let profileImage = profileImage {
            let imageData = profileImage.jpegData(compressionQuality: 1)
            contact.imageData = imageData
        }

        if let phoneNumberField = phoneNumberField {
            contact.phoneNumbers.append(phoneNumberField)
        }
        return contact
    }

    convenience init?(contact: CNContact) {
        guard let email = contact.emailAddresses.first else { return nil }
        let firstName = contact.givenName
        let lastName = contact.familyName
        let personalEmail = email.value as String
        var profileImage: UIImage?

        if let imageData = contact.imageData {
            profileImage = UIImage(data: imageData)
        }

        self.init(firstName: firstName, lastName: lastName, emailAddress: personalEmail, profileImage: profileImage)

        if let contactPhone = contact.phoneNumbers.first {
            phoneNumberField = contactPhone
        }
    }

}
