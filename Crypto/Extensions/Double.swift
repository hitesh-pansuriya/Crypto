//
//  Double.swift
//  Crypto
//
//  Created by PC on 26/09/22.
//

import Foundation


extension Double {

    /// Converts a Double a Currency with 2-6 decimal places
    ///```
    /// Convert 1234.56 to $1,234.56
    ///```
    private  var CurrencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        //        formatter.locale = .current // <- default value
        //        formatter.currencyCode = "usd" // <- change currency
        //        formatter.currencySymbol = "$" // <- change currency symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }


    /// Converts a Double a Currency with 2-6 decimal places
    ///```
    /// Convert 1234.56 to $1,234.56
    ///```
    func asCurrancyWith2Decimals() -> String{
        let number = NSNumber(value: self)
        return CurrencyFormatter2.string(from: number) ?? "$0.00"
    }

    /// Converts a Double a Currency with 2-6 decimal places
    ///```
    /// Convert 1234.56 to $1,234.56
    /// Convert 12.3456 to $12.3456
    /// Convert 0.123456 to $0.123456
    ///```
    private  var CurrencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current // <- default value
//        formatter.currencyCode = "usd" // <- change currency
//        formatter.currencySymbol = "$" // <- change currency symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }


    /// Converts a Double a Currency with 2-6 decimal places
    ///```
    /// Convert 1234.56 to $1,234.56
    /// Convert 12.3456 to $12.3456
    /// Convert 0.123456 to $0.123456
    ///```
    func asCurrancyWith6Decimals() -> String{
        let number = NSNumber(value: self)
        return CurrencyFormatter6.string(from: number) ?? "$0.00"
    }

    ///Converts a double into string representation
    /// Converts a Double a Currency with 2-6 decimal places
    ///```
    /// Convert 1.23456 to $1.23
    ///```
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }

    ///Converts a double into string representation
    /// Converts a Double a Currency with 2-6 decimal places
    ///```
    /// Convert 1.23456 to $1.23%
    ///```
    func asPercentString() -> String{
        return asNumberString() + "%"
    }

}
