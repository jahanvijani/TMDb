//
//  UILabel+Extension.swift
//  TMDb
//
//  Created by Jahanvi Vyas on 29/01/2020.
//  Copyright © 2020 Jahanvi Vyas. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setVoteAverage(_ string: String?) {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "star")
        let attachmentString = NSAttributedString(attachment: attachment)

        let mutableAttachmentString = NSMutableAttributedString(attributedString: attachmentString)
        let strLabelText = NSAttributedString(string: string ?? "")
        mutableAttachmentString.append(strLabelText)

        self.attributedText = mutableAttachmentString
    }
}
