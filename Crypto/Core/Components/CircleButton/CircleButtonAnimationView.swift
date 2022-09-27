//
//  CircleButtonAnimationView.swift
//  Crypto
//
//  Created by PC on 26/09/22.
//

import SwiftUI

struct CircleButtonAnimationView: View {

    @Binding var animate : Bool

    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.5 : 0)
            .opacity(animate ? 0 : 1)
            .animation(animate ? Animation.linear(duration: 1.0) : .none, value: animate)
    }
}

struct CircleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimationView(animate: .constant(false))
            .foregroundColor(.red)
            .frame(width: 100, height: 100)
    }
}
