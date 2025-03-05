//
//  PersonTests.swift
//  ContactsFun
//
//  Created by Sarah Clark on 3/4/25.
//

import Contacts
import Testing
import UIKit

@testable import ContactsFun

@Suite("Person Tests")
struct PersonTests {

    @Test("Initialize Person with basic properties")
    func testInitializePerson() {
        let person = Person(
            firstName: "John",
            lastName: "Doe",
            emailAddress: "john.doe@example.com",
            profileImage: nil
        )

        #expect(person.id != nil)
        #expect(person.firstName == "John")
        #expect(person.lastName == "Doe")
        #expect(person.personalEmailAddress == "john.doe@example.com")
        #expect(person.profileImage == nil)
        #expect(person.storedContact == nil)
        #expect(person.phoneNumberField == nil)
    }

    @Test("Initialize Person with profile image")
    func testInitializePersonWithProfileImage() {

        // Create a simple UIImage for testing
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.red.cgColor)
        context?.fill(CGRect(origin: .zero, size: size))
        let testImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let person = Person(
            firstName: "Jane",
            lastName: "Smith",
            emailAddress: "jane.smith@example.com",
            profileImage: testImage
        )

        #expect(person.profileImage != nil)
        #expect(person.profileImage?.pngData() == testImage?.pngData())
    }

    @Test("contactValue maps Person properties to CNContact")
    func testContactValue() {
        let person = Person(
            firstName: "Alice",
            lastName: "Johnson",
            emailAddress: "alice.j@example.com",
            profileImage: nil
        )

        let contact = person.contactValue

        #expect(contact.givenName == "Alice")
        #expect(contact.familyName == "Johnson")
        #expect(contact.emailAddresses.count == 1)
        #expect(contact.emailAddresses.first?.value as String? == "alice.j@example.com")
        #expect(contact.emailAddresses.first?.label == CNLabelHome)
        #expect(contact.imageData == nil)
        #expect(contact.phoneNumbers.isEmpty)
    }

    @Test("contactValue includes profile image and phone number")
    func testContactValueWithImageAndPhone() {

        // Create a simple UIImage for testing
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.blue.cgColor)
        context?.fill(CGRect(origin: .zero, size: size))
        let testImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let person = Person(
            firstName: "Bob",
            lastName: "Williams",
            emailAddress: "bob.w@example.com",
            profileImage: testImage
        )

        // Add a phone number
        let phoneNumber = CNPhoneNumber(stringValue: "123-456-7890")
        person.phoneNumberField = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: phoneNumber)

        let contact = person.contactValue

        #expect(contact.givenName == "Bob")
        #expect(contact.familyName == "Williams")
        #expect(contact.emailAddresses.first?.value as String? == "bob.w@example.com")
        #expect(contact.imageData != nil)
        #expect(contact.imageData == testImage?.pngData())
        #expect(contact.phoneNumbers.count == 1)
        #expect(contact.phoneNumbers.first?.value.stringValue == "123-456-7890")
        #expect(contact.phoneNumbers.first?.label == CNLabelPhoneNumberMobile)
    }

    @Test("Convenience init from CNContact with valid data")
    func testConvenienceInitWithValidContact() {
        let contact = CNMutableContact()
        contact.givenName = "Eve"
        contact.familyName = "Brown"
        contact.emailAddresses = [CNLabeledValue(label: CNLabelHome, value: "eve.b@example.com" as NSString)]

        // Add a phone number
        let phoneNumber = CNPhoneNumber(stringValue: "987-654-3210")
        contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: phoneNumber)]

        // Add a simple image
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.green.cgColor)
        context?.fill(CGRect(origin: .zero, size: size))
        let testImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        contact.imageData = testImage?.pngData()

        guard let person = Person(contact: contact) else {
            #expect(Bool(false), "Failed to initialize Person from CNContact")
            return
        }

        #expect(person.firstName == "Eve")
        #expect(person.lastName == "Brown")
        #expect(person.personalEmailAddress == "eve.b@example.com")

        // Normalize the testImage by round-tripping it through UIImage(data:)
        if let testImageData = testImage?.pngData(), let normalizedTestImage = UIImage(data: testImageData) {
            #expect(person.profileImage?.pngData() == normalizedTestImage.pngData())
        } else {
            #expect(Bool(false), "Failed to normalize test image")
        }

        #expect(person.phoneNumberField?.value.stringValue == "987-654-3210")
        #expect(person.phoneNumberField?.label == CNLabelPhoneNumberMobile)
    }

    @Test("Convenience init fails with CNContact missing email")
    func testConvenienceInitFailsWithoutEmail() {
        let contact = CNMutableContact()
        contact.givenName = "Charlie"
        contact.familyName = "Davis"
        // No email address provided

        let person = Person(contact: contact)

        #expect(person == nil)
    }

    @Test("Equality for identical Persons")
    func testEqualityForIdenticalPersons() {
        let person1 = Person(
            firstName: "Sam",
            lastName: "Taylor",
            emailAddress: "sam.t@example.com",
            profileImage: nil
        )

        let person2 = Person(
            firstName: "Sam",
            lastName: "Taylor",
            emailAddress: "sam.t@example.com",
            profileImage: nil
        )

        #expect(person1 == person2)
    }

    @Test("Inequality for different Persons")
    func testInequalityForDifferentPersons() {
        let person1 = Person(
            firstName: "Sam",
            lastName: "Taylor",
            emailAddress: "sam.t@example.com",
            profileImage: nil
        )

        let person2 = Person(
            firstName: "Sam",
            lastName: "Taylor",
            emailAddress: "sam.t2@example.com", // Different email
            profileImage: nil
        )

        #expect(person1 != person2)
    }

    @Test("Equality with identical images")
    func testEqualityWithIdenticalImages() {
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.yellow.cgColor)
        context?.fill(CGRect(origin: .zero, size: size))
        let testImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let person1 = Person(
            firstName: "Pat",
            lastName: "Lee",
            emailAddress: "pat.l@example.com",
            profileImage: testImage
        )

        let person2 = Person(
            firstName: "Pat",
            lastName: "Lee",
            emailAddress: "pat.l@example.com",
            profileImage: testImage
        )

        #expect(person1 == person2)
    }

    @Test("Inequality with different images")
    func testInequalityWithDifferentImages() {
        let size = CGSize(width: 1, height: 1)

        UIGraphicsBeginImageContext(size)
        let context1 = UIGraphicsGetCurrentContext()
        context1?.setFillColor(UIColor.red.cgColor)
        context1?.fill(CGRect(origin: .zero, size: size))
        let image1 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        UIGraphicsBeginImageContext(size)
        let context2 = UIGraphicsGetCurrentContext()
        context2?.setFillColor(UIColor.blue.cgColor)
        context2?.fill(CGRect(origin: .zero, size: size))
        let image2 = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let person1 = Person(
            firstName: "Alex",
            lastName: "Green",
            emailAddress: "alex.g@example.com",
            profileImage: image1
        )

        let person2 = Person(
            firstName: "Alex",
            lastName: "Green",
            emailAddress: "alex.g@example.com",
            profileImage: image2
        )

        #expect(person1 != person2)
    }

}
