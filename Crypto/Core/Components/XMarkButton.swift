//
//  XMarkButton.swift
//  Crypto
//
//  Created by PC on 28/09/22.
//

import SwiftUI

struct XMarkButton: View {      
    var action: ()-> Void
    var body: some View {
        Button {
            action()
//            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }

    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton() {
            
        }
    }
}
