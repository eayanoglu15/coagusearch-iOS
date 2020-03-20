//
//  String+Additions.swift
//  Coagusearch
//
//  Created by Ege Melis Ayanoğlu on 19.03.2020.
//  Copyright © 2020 coagusearch. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
       return String.localizedStringWithFormat(NSLocalizedString(self,comment: ""))
    }

    func localizedWithComment(comment:String) -> String {
       return String.localizedStringWithFormat(NSLocalizedString(self,comment: comment))
    }
}
