//
//  ViewController.swift
//  ContactList
//
//  Created by Дмитрий Куприенко on 27.04.2022.
//

import UIKit
import Contacts

class ViewController: UIViewController {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    private var contactsArray = [CNContact]()
    private var duplicateNamesDictionary = [String:[CNContact]]()
    private var duplicatePhoneNumbersDictionary = [String:[CNContact]]()
    private var emptyNameArray = [CNContact]()
    private var emptyPhoneNumbersArray = [CNContact]()
    private var emptyEmailArray = [CNContact]()
    private let contactStore = CNContactStore()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.mainTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil),
                                    forCellReuseIdentifier: "CustomTableViewCell")
        self.title = contactsString
        contactStore.requestAccess(for: .contacts) { granted, stop in
            if granted {
                self.fetchAndFilter()
                self.mainTableView.reloadData()
            } else {
                print(stop)
            }
        }
        
    }
    
    // MARK: - Private
    
    private func fetchAndFilter() {
        
        fetchDuplicateNameContacts()
        fetchAllContacts()
        fetchDuplicatePhoneNumberContacts()
        filterByEmptyName()
        filterByEmptyPhoneNumber()
        filterByEmptyEmail()
    }
    
    private func fetchAllContacts() {
        
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey,
                           CNContactEmailAddressesKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        do {
            contactsArray.removeAll()
            try contactStore.enumerateContacts(with: request) { [self]
                (contact, stop) in
                contactsArray.append(contact)
            }
        } catch {
            print("Failed to fetch contact, error: \(error)")
        }
    }
    
    private func fetchDuplicateNameContacts() {
        
        let keysToFetch = [CNContactIdentifierKey as CNKeyDescriptor,
                           CNContactFormatter.descriptorForRequiredKeys(for: .fullName)]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        var contactsByName = [String: [CNContact]]()
        try? contactStore.enumerateContacts(with: request) { contact, stop in
            guard let name = CNContactFormatter.string(from: contact,
                                                       style: .fullName) else { return }
            contactsByName[name] = (contactsByName[name] ?? []) + [contact]
        }
        let duplicates = contactsByName.filter { $1.count > 1 }
        duplicateNamesDictionary.removeAll()
        for eachItem in duplicates {
            duplicateNamesDictionary.updateValue(eachItem.value, forKey: eachItem.key)
        }
    }
    
    private func fetchDuplicatePhoneNumberContacts() {
        
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey,
                           CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        var contactsByPhoneNumber = [String: [CNContact]]()
        try? contactStore.enumerateContacts(with: request) { contact, stop in
            for eachPhoneNumber in contact.phoneNumbers {
                var phoneNumberNumber = 0
                let phoneNumber = eachPhoneNumber.value.stringValue
                contactsByPhoneNumber[phoneNumber] = (contactsByPhoneNumber[phoneNumber] ?? []) + [contact]
                phoneNumberNumber += 1
            }
        }
        let duplicates = contactsByPhoneNumber.filter { $1.count > 1 }
        duplicatePhoneNumbersDictionary.removeAll()
        for eachItem in duplicates {
            duplicatePhoneNumbersDictionary.updateValue(eachItem.value,
                                                        forKey: eachItem.key)
        }
    }
    
    private func filterByEmptyName() {
        
        let emptyName = contactsArray.filter { $0.givenName.count < 1 }
        emptyNameArray.removeAll()
        for eachContact in emptyName {
            emptyNameArray.append(eachContact)
        }
    }
    
    private func filterByEmptyPhoneNumber() {
        
        let emptyPhones = contactsArray.filter { $0.phoneNumbers.first?.value.stringValue.count ?? 0 < 1 }
        emptyPhoneNumbersArray.removeAll()
        for eachContact in emptyPhones {
            emptyPhoneNumbersArray.append(eachContact)
        }
    }
    
    private func filterByEmptyEmail() {
        
        let emptyEmail = contactsArray.filter { $0.emailAddresses.first?.value.length ?? 0 < 1 }
        emptyEmailArray.removeAll()
        for eachContact in emptyEmail {
            emptyEmailArray.append(eachContact)
        }
    }
}

// MARK: - Extensions

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let customTableViewCell = mainTableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell",
                                                                          for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        customTableViewCell.configureTableViewCell(indexPathRow: indexPath.row,
                                                   summaryAmmount: contactsArray.count,
                                                   repeatedPhoneNumbersAmmount: duplicatePhoneNumbersDictionary.count,
                                                   repeatedNamesAmmount: duplicateNamesDictionary.count,
                                                   noNamesAmmount: emptyNameArray.count,
                                                   noPhoneNumberAmmount: emptyPhoneNumbersArray.count,
                                                   noEmailAmmount: emptyEmailArray.count)
        return customTableViewCell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        if let detailsViewController = main.instantiateViewController(withIdentifier:
                                                                        "DetailsViewController")
            as? DetailsViewController {
            navigationController?.pushViewController(detailsViewController, animated: true)
            detailsViewController.indexPathRow = indexPath.row
            detailsViewController.configureDetailsViewController(indexPathRow: indexPath.row)
            detailsViewController.detailsContactsArray = contactsArray
            detailsViewController.detailsDuplicateNamesDictionary = duplicateNamesDictionary
            detailsViewController.detailsDuplicatePhoneNumbersDictionary = duplicatePhoneNumbersDictionary
            detailsViewController.detailsEmptyNamesArray = emptyNameArray
            detailsViewController.detailsEmptyPhoneNumbersArray = emptyPhoneNumbersArray
            detailsViewController.detailsEmptyEmailsArray = emptyEmailArray
        }
    }
}
