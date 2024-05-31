//
//  Encode.swift
//
//
//  Created by Mark Edmunds on 5/30/24.
//
import ArgumentParser
import Foundation

struct Encode: ParsableCommand{
    @Flag(name: .shortAndLong, help: "Marks the input should be encoded") var encode: Bool = false
    @OptionGroup var options: Options
    
    mutating func run() throws {
        
        let data = Data(options.arg.utf8)
        print(data.base64EncodedString(options: .endLineWithCarriageReturn))
    
    }
}

struct Base: ExpressibleByArgument{
    init?(argument: BaseType.RawValue) {
        self.argument = argument
    }
    let argument: String
    
}
enum BaseType: String{
    case binary = "bin"
    case octal = "oct"
    case hex = "hex"
    case baseSiXFour = "base64"
}
