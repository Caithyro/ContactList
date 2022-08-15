//
//  DetailsViewController.swift
//  ContactList
//
//  Created by Дмитрий Куприенко on 28.04.2022.
//

import UIKit
import Contacts

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var detailsTableView: UITableView!
    
    var detailsContactsArray = [CNContact]()
    var detailsDuplicateNamesDictionary = [String:[CNContact]]()
    var detailsDuplicatePhoneNumbersDictionary = [String:[CNContact]]()
    var detailsEmptyNamesArray = [CNContact]()
    var detailsEmptyPhoneNumbersArray = [CNContact]()
    var detailsEmptyEmailsArray = [CNContact]()
    var indexPathRow = 0
    
    private var detailsDuplicateNamesArray = [CNContact]()
    private var detailsDuplicatePhoneNumbersArray = [CNContact]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.detailsTableView.register(UINib(nibName: "DetailsTableViewCell", bundle: nil),
                                       forCellReuseIdentifier: "DetailsTableViewCell")
        dictionariesToArrays()
    }
    
    func configureDetailsViewController(indexPathRow: Int) {
        
        switch indexPathRow {
        case 0:
            self.title = contactsString
        case 1:
            self.title = duplicateNamesString
        case 2:
            self.title = duplicateNumbersString
        case 3:
            self.title = noNameString
        case 4:
            self.title = noNumberString
        case 5:
            self.title = noEmailsString
        default:
            print("Something went wrong")
        }
    }
    
    // MARK: - Private
    
    private func dictionariesToArrays() {
        
        for _ in detailsDuplicateNamesDictionary {
            if detailsDuplicateNamesDictionary.isEmpty == false {
                detailsDuplicateNamesArray.append(detailsDuplicateNamesDictionary.first!.value.first!)
                detailsDuplicateNamesDictionary.removeValue(forKey:
                                                                detailsDuplicateNamesArray[0].givenName)
            }
        }
        
        for _ in detailsDuplicatePhoneNumbersDictionary {
            if detailsDuplicatePhoneNumbersDictionary.isEmpty == false {
                detailsDuplicatePhoneNumbersArray.append(detailsDuplicatePhoneNumbersDictionary.first!.value.first!)
                detailsDuplicatePhoneNumbersDictionary.removeValue(forKey:
                                                                    detailsDuplicatePhoneNumbersArray[0].phoneNumbers.first!.value.stringValue)
            }
        }
    }
}

// MARK: - Extensions

extension DetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch indexPathRow {
        case 0:
            return detailsContactsArray.count
        case 1:
            return detailsDuplicateNamesArray.count
        case 2:
            return detailsDuplicatePhoneNumbersArray.count
        case 3:
            return detailsEmptyNamesArray.count
        case 4:
            return detailsEmptyPhoneNumbersArray.count
        case 5:
            return detailsEmptyEmailsArray.count
        default:
            print("Something went wrong")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let detailsTableViewCell = detailsTableView.dequeueReusableCell(withIdentifier: "DetailsTableViewCell",
                                                                              for: indexPath) as? DetailsTableViewCell else { return UITableViewCell() }
        detailsTableViewCell.configureDetailsCell(indexPathRowFromMain: indexPathRow,
                                                  indexPathRowFromDetails: indexPath.row,
                                                  contactsArray: detailsContactsArray,
                                                  duplicateNamesArray: detailsDuplicateNamesArray,
                                                  duplicatePhoneNumbersArray: detailsDuplicatePhoneNumbersArray,
                                                  emptyNamesArray: detailsEmptyNamesArray,
                                                  emptyPhoneNumbersArray: detailsEmptyPhoneNumbersArray,
                                                  emptyEmailsArray: detailsEmptyEmailsArray)
        return detailsTableViewCell
    }
}
