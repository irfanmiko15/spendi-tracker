//
//  CustomTextField.swift
//  SpendiTracker
//
//  Created by Irfan Dary Sujatmiko on 01/03/25.
//


import Foundation
import SwiftUI
import Combine
struct CustomTextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color.textFieldColor)
            .cornerRadius(10)
        
    }
}
struct PasswordTextField:View{
    @Binding var value:String
    @Binding var label:String
    @Binding var hint:String
    @Binding var showPassword:Bool
    var accessibilityId: String? = nil
    var body: some View {
        VStack(alignment: .leading) {
            Text(label).textCase(.uppercase).font(.caption)
            HStack{
                showPassword == true ? AnyView(TextField("******",text: $value).accessibilityIdentifier(accessibilityId ?? "").overlay{
                    if !value.isEmpty {
                        HStack{
                            Spacer()
                            Button {
                                value = ""
                            }label: {
                                Image(systemName: "multiply.circle.fill").foregroundStyle(Color.gray)
                                    
                            }
                            .padding(.trailing, 10)
                        }
                    }
                    
                }) : AnyView(SecureField("******",text: $value).accessibilityIdentifier(accessibilityId ?? "").overlay{
                    if !value.isEmpty {
                        HStack{
                            Spacer()
                            Button {
                                value = ""
                            }label: {
                                Image(systemName: "multiply.circle.fill").foregroundStyle(Color.gray)
                                    
                            }
                            .padding(.trailing, 10)
                        }
                    }
                    
                })
                    Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill").onTapGesture {
                        showPassword = !showPassword
                    }
            }.modifier(CustomTextFieldStyle())
        }
    }
    
}

struct DefaultTextField:View{
    @Binding var value:String
    @Binding var label:String
    @Binding var hint:String
    let textLimit = 25
    var accessibilityId: String? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label).textCase(.uppercase).font(.caption)
            HStack{
                TextField(hint,text: $value).accessibilityIdentifier(accessibilityId ?? "")  .onReceive(Just(value)) { _ in limitText(textLimit) }.modifier(CustomTextFieldStyle()).overlay{
                    if !value.isEmpty {
                        HStack{
                            Spacer()
                            Button {
                                value = ""
                            }label: {
                                Image(systemName: "multiply.circle.fill").foregroundStyle(Color.gray)
                                    
                            }
                            .padding(.trailing, 10)
                        }
                    }
                    
                }
            }
        }
    }
    func limitText(_ upper: Int) {
        if value.count > upper {
            value = String(value.prefix(upper))
        }
    }
}

#Preview {
    PasswordTextField(value: .constant(String("a")), label: .constant(String("label")), hint: .constant(String("hint")),showPassword: .constant(false))
}

