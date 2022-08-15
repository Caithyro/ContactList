//
//  CustomTableViewCell.swift
//  ContactList
//
//  Created by Дмитрий Куприенко on 27.04.2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ammountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureTableViewCell(indexPathRow: Int,
                                summaryAmmount: Int,
                                repeatedPhoneNumbersAmmount: Int,
                                repeatedNamesAmmount: Int,
                                noNamesAmmount: Int,
                                noPhoneNumberAmmount: Int,
                                noEmailAmmount: Int) {
        
        switch indexPathRow {
        case 0:
            leftImageView.image = UIImage(systemName: "person.crop.circle")
            titleLabel.text = contactsString
            ammountLabel.text = summaryAmmount.description
        case 1:
            leftImageView.image = UIImage(systemName: "person.3")
            titleLabel.text = duplicateNamesString
            ammountLabel.text = repeatedNamesAmmount.description
        case 2:
            leftImageView.image = UIImage(systemName: "phone")
            titleLabel.text = duplicateNumbersString
            ammountLabel.text = repeatedPhoneNumbersAmmount.description
        case 3:
            leftImageView.image = UIImage(systemName: "person.crop.circle.badge.questionmark")
            titleLabel.text = noNameString
            ammountLabel.text = noNamesAmmount.description
        case 4:
            leftImageView.image = UIImage(systemName: "iphone.slash")
            titleLabel.text = noNumberString
            ammountLabel.text = noPhoneNumberAmmount.description
        case 5:
            leftImageView.image = UIImage(systemName: "envelope")
            titleLabel.text = noEmailsString
            ammountLabel.text = noEmailAmmount.description
        default:
            print("Something wrong, go check your code")
        }
    }
}
