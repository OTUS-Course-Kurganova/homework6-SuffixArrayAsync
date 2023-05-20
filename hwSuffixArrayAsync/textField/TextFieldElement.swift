//
//  TextFieldElement.swift
//  hwSuffixArrayAsync
//
//  Created by Alexandra Kurganova on 20.05.2023.
//

import SwiftUI

struct TextFieldElement: View {
    @State var inputedWord: String = .init()
    @EnvironmentObject var viewModel: TextFieldElementViewModel

    var body: some View {
        InputedField
            .lineLimit(100)
            .onSubmit {
                viewModel.fillHistory(text: inputedWord)
                Task {
                    try await viewModel.countSuffixesFrom(text: inputedWord)
                }
            }
        SegmentedControlElement()
            .padding(.top, 5)
    }

    var InputedField: some View {
        TextField("Ведите слово:", text: $inputedWord, axis: .vertical)
            .foregroundColor(.cyan)
            .truncationMode(.tail)
            .autocapitalization(.none)
            .padding()
            .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.orange, lineWidth: 1)
                )
            .padding()
    }
}

struct TextFieldElement_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldElement()
    }
}

