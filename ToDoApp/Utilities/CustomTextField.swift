//
//  CustomTextField.swift
//  ToDoApp
//
//  Created by Oleg Koptev on 21.02.2021.
//

import SwiftUI

struct CustomTextField: UIViewRepresentable {
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String
        @Binding var nextResponder : Bool?
        @Binding var isResponder : Bool?
        
        var didBeginEditingHandler: () -> Void
        var didEndEditingHandler: () -> Void
        
        init(text: Binding<String>,
             nextResponder : Binding<Bool?>,
             isResponder : Binding<Bool?>,
             didBeginEditingHandler: @escaping () -> Void,
             didEndEditingHandler: @escaping () -> Void
        ) {
            _text = text
            _isResponder = isResponder
            _nextResponder = nextResponder
            self.didBeginEditingHandler = didBeginEditingHandler
            self.didEndEditingHandler = didEndEditingHandler
        }
        
        func getWidth(_ text: String) -> CGFloat {
            let txtField = UITextField(frame: .zero)
            txtField.text = text
            txtField.sizeToFit()
            return txtField.frame.size.width
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.text = textField.text ?? ""
            }
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.isResponder = true
                self.didBeginEditingHandler()
            }
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.isResponder = false
                if self.nextResponder != nil {
                    self.nextResponder = true
                }
                self.didEndEditingHandler()
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
    
    var placeholder: String = ""
    @Binding var text: String
    @Binding var nextResponder : Bool?
    @Binding var isResponder : Bool?
    
    var isSecured : Bool = false
    var keyboard : UIKeyboardType
    
    var didBeginEditingHandler: () -> Void = {}
    var didEndEditingHandler: () -> Void = {}
    
    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isSecured
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = keyboard
        
        // Here we get San Francisco with the desired weight
        let systemFont = UIFont.preferredFont(forTextStyle: .body)

        // Will be SF Compact or standard SF in case of failure.
        let font: UIFont

        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            font = UIFont(descriptor: descriptor, size: systemFont.pointSize)
        } else {
            font = systemFont
        }
        
        textField.font = font
        
        textField.delegate = context.coordinator
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }
    
    func makeCoordinator() -> CustomTextField.Coordinator {
        return Coordinator(text: $text, nextResponder: $nextResponder, isResponder: $isResponder, didBeginEditingHandler: didBeginEditingHandler, didEndEditingHandler: didEndEditingHandler)
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.text = text
        if isResponder ?? false {
            uiView.selectedTextRange = uiView.textRange(from: uiView.endOfDocument, to: uiView.endOfDocument)
            uiView.becomeFirstResponder()
        }
    }
    
}
