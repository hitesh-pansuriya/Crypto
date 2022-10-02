//
//  UIApplication.swift
//  Crypto
//
//  Created by PC on 28/09/22.
//

import Foundation
import SwiftUI

extension UIApplication{

    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
