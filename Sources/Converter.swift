//
//  Converter.swift
//
//
//  Created by Mark Edmunds on 5/30/24.
//

import ArgumentParser
import Foundation



struct Converter: ParsableCommand{
    @OptionGroup var options: Options
    @Flag(name:.shortAndLong, help: "Marks the input as an IP address or Subnet mask") var address: Bool = false
    @Flag(name: .shortAndLong, help: "Marks the input as base 64 string") var base64: Bool = false
    @Flag(name: .shortAndLong, help: "Marks the input as a base 10 number") var dec: Bool = false
    @Option(name: .shortAndLong, help: "Set the separator for the IP or Subnet octets: ") var separator: String = "."
    
    mutating func run() throws{
        let invalidNumbers = [2,3,4,5,6,7,8,9]
        if base64{
            base64Convert(options.arg)
            return
        }

        if dec || address && dec{
            let octets = options.arg.components(separatedBy: separator)
            var binString: String = ""
            for b in octets{
                    let byte = decToBinary(b)
                    binString.append("\(String(byte)).")
            }
            let _ = binString.popLast()
            print(binString)
            return
        }
        if address{
            let octets = options.arg.components(separatedBy: separator)
            var decString: String = ""
            for b in octets{
                do{
                    let byte = try binaryToDec(b,b.count - 1, invalidNumbers)
                    decString.append("\(String(byte)).")
                }catch{
                    print("\(error.localizedDescription)\n\(error)")
                    
                    
                }
                
            }
            let _ = decString.popLast()
            print(decString)
            
        }else{
            
            let sigBit = options.arg.count - 1
            guard sigBit <= 63 else{
                throw ConversionError.outOfBounds(description: "You entered \(sigBit + 1) digits the value of that number exceeds the limit of a signed 64bit interger")
            }
            do{
                print(try binaryToDec(options.arg,sigBit, invalidNumbers))
            }catch{
                print("\(error.localizedDescription)\n\(error)")
            }
        }
    }
}
extension Converter{
    fileprivate func binaryToDec(_ digits: String, _ sigBit: Int, _ invalidNumbers: [Int]) throws -> Int {
        var place = 1 << (digits.count - 1)
        var output = 0
        for i in digits{
            if let bit = Int(String(i)){
                guard !invalidNumbers.contains(bit) else{
                    throw ConversionError.invalidInput(description: "The argument included a non binary number")
                }
                output += Int(place) * bit
                place >>= 1
            }else{
                throw ConversionError.invalidInput(description: "The argument included a character which cannot be coverted to an interger")
            }
        }
        return output
    }
    fileprivate func base64Convert (_ base64: String){
        if let data = Data(base64Encoded: base64,options: .ignoreUnknownCharacters){
            
            print(String(data: data, encoding: .utf8) ?? "fail")
        }
    }
    
    fileprivate func checkInput(_ input: String) throws -> String{
        return "placeholder"
    }
    fileprivate func decToBinary(_ input: String)-> String{
        if let input = Int(input){
           return String(input,radix: 2)
        }
        return ""
    }
}

enum ConversionError: LocalizedError{
    case invalidInput(description: String)
    case outOfBounds(description: String)
}
