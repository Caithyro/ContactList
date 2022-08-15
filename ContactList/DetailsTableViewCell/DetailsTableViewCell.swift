//
//  DetailsTableViewCell.swift
//  ContactList
//
//  Created by Дмитрий Куприенко on 28.04.2022.
//

import UIKit
import Contacts

class DetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureDetailsCell(indexPathRowFromMain: Int,
                              indexPathRowFromDetails: Int,
                              contactsArray: [CNContact],
                              duplicateNamesArray: [CNContact],
                              duplicatePhoneNumbersArray: [CNContact],
                              emptyNamesArray: [CNContact],
                              emptyPhoneNumbersArray: [CNContact],
                              emptyEmailsArray: [CNContact]) {
        
        switch indexPathRowFromMain {
        case 0:
            if contactsArray[indexPathRowFromDetails].givenName == "" {
                nameLabel.text = noNameString
            } else {
                nameLabel.text = contactsArray[indexPathRowFromDetails].givenName
            }
        case 1:
            nameLabel.text = duplicateNamesArray[indexPathRowFromDetails].givenName
        case 2:
            nameLabel.text = duplicatePhoneNumbersArray[indexPathRowFromDetails].phoneNumbers.first?.value.stringValue
        case 3:
            nameLabel.text = emptyNamesArray[indexPathRowFromDetails].phoneNumbers.first?.value.stringValue ?? noPhoneNumberString
        case 4:
            if emptyPhoneNumbersArray[indexPathRowFromDetails].givenName == "" {
                nameLabel.text = noNameString
            } else {
                nameLabel.text = emptyPhoneNumbersArray[indexPathRowFromDetails].givenName
            }
        case 5:
            if emptyEmailsArray[indexPathRowFromDetails].givenName == "" {
                nameLabel.text = noNameString
            } else {
                nameLabel.text = emptyEmailsArray[indexPathRowFromDetails].givenName
            }
        default:
            print("Something went wrong")
        }
    }
}
