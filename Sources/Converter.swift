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
    @Flag(name: .shortAndLong, help: "Marks the input as octal") var octal: Bool = false
    
    
    mutating func run() throws{
        let invalidNumbers = [2,3,4,5,6,7,8,9]
		let acceptedNumberBases: [Int] = [2,8,10,16,64]
		guard acceptedNumberBases.contains(options.numberBase) else{
			throw CleanExit.message("Invalid number base: \(options.numberBase) number base must be one of: \(acceptedNumberBases)")
		}
        if base64 || options.numberBase == 64{
            base64Convert(options.arg)
            return
        }
		
		switch true {
			case options.numberBase == 2:
				print(try binaryToDec(options.arg,options.arg.count,invalidNumbers))
			case options.numberBase == 8 || octal:
				print("")
			case options.numberBase == 16:
				print("")
		case options.numberBase == 64 || base64:
				print("")
			default :
				print("")
		}

		if dec || options.numberBase == 10 || address && dec{
			let octets = options.arg.components(separatedBy: options.separator)
            var binString: String = ""
            for b in octets{
                    let byte = try decToBinary(b)
                    binString.append("\(String(byte)).")
            }
            let _ = binString.popLast()
            print(binString)
            return
        }
        if address{
			let octets = options.arg.components(separatedBy: options.separator)
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
            
		}else if options.numberBase == 2{
            
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
    private func binaryToDec(_ digits: String, _ sigBit: Int, _ invalidNumbers: [Int]) throws -> Int {
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
    private func base64Convert (_ base64: String){
        if let data = Data(base64Encoded: base64,options: .ignoreUnknownCharacters){
            
            print(String(data: data, encoding: .utf8) ?? "fail")
        }
    }
    
    private func checkInput(_ input: String) throws -> String{
        return "placeholder"
    }
    private func decToBinary(_ input: String) throws->String{
		guard let i = Int(input) else{
			throw ConversionError.invalidInput(description: "The argument included a non decimal number")
		}
		return String(i,radix: 2)
        
    }
	
	private func isValidBinaryString( _ input: String) throws -> Bool{
		let validBinaryNumbers = ["0","1"]
		guard validBinaryNumbers.contains(input) else{
			throw ConversionError.invalidInput(description: "The argument included a non binary number")
		}
		return true
	}
}

enum ConversionError: LocalizedError{
    case invalidInput(description: String)
    case outOfBounds(description: String)
    var errorDescription: String?{
        switch self{
        case .invalidInput(let description):
            return description
        case .outOfBounds(let description):
            return description
        }
    }
}
