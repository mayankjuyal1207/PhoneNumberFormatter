//
//  ViewModel.swift
//  PhoneNumberFormatter
//
//  Created by Mayank juyal on 08/03/18.
//  Copyright © 2018 abhishek. All rights reserved.
//

import UIKit
import PhoneNumberKit

class ViewModel: NSObject {
    
    private let pratialFormater = PartialFormatter()
    
    private func addingCountryCodeTo(_ text: String, countryCode: String) -> String {
        let concatenatedText = countryCode + text
        return concatenatedText
    }
    
    private func removingCountryCodeFrom(_ text: String, countryCode: String) -> String {
        let removedString = text.replacingOccurrences(of: countryCode, with: "")
        return removedString
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String, countryCode: String) {
        guard let text = textField.text else {
            fatalError("ShouldChangeCharactersIn not working!!!")
        }
        let textAsNSString = text as NSString
        let modifiedTextField = (textAsNSString.replacingCharacters(in: range, with: string)).removingWhiteSpace()
        let concatText = self.addingCountryCodeTo(modifiedTextField, countryCode: countryCode)
        let formattedNationalNumber = pratialFormater.formatPartial(concatText as String)
        let newString = self.removingCountryCodeFrom(formattedNationalNumber, countryCode: countryCode)
        textField.text = newString
        textField.sendActions(for: .editingChanged)
    }
    
    func getFormatted(_ text: String, countryCode: String) -> String {
        let combinedString = addingCountryCodeTo(text, countryCode: countryCode).removingWhiteSpace()
        let formattedNationalNumber = pratialFormater.formatPartial(combinedString as String)
        let newString = removingCountryCodeFrom(formattedNationalNumber, countryCode: countryCode)
        return newString
    }
    
    func getCountryPhoneCode(_ countryCode : String) -> String {
        let countries = Countries().countries
        for country in countries {
            if country.countryCode == countryCode {
                return country.phoneExtension
            }
        }
        return ""
    }
    
    func flag(country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
     /*func validatePhoneNumber(cellPhone:String,countryCode:String,countryName:String)->Bool{
        let finalResult = "+" + countryCode + cellPhone
        let formattedBasedOnCountryCode = PartialFormatter().formatPartial(finalResult)
        let result = self.parseNumber(formattedBasedOnCountryCode,countryName: countryName.uppercased())
        if result.removingWhiteSpace().characters.count > 1 {
            return true
        }
        else{
            return false
        }
    }
    
     private func parseNumber(_ number: String,countryName:String) ->String {
        let phoneNumberKit = PhoneNumberKit()
        do {
            let phoneNumber = try phoneNumberKit.parse(number, withRegion: countryName, ignoreType: true)
            let result = phoneNumberKit.format(phoneNumber, toType: .international, withPrefix: false)
            // print("resulted phone number = \(result)")
            return result
        }
        catch {
            //print("Something went wrong = \(number) and countryName = \(countryName)")
            return ""
        }
    }*/
    
    
}

extension String {
    func removingWhiteSpace()-> String {
        let trimmedString = self.trimmingCharacters(in: .whitespaces)
        return trimmedString
    }
}
