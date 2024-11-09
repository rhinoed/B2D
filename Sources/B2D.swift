//
//  B2D.swift
//  
//
//  Created by Mark Edmunds on 5/30/24.
//
import ArgumentParser
import Foundation

@main
struct B2D: ParsableCommand{
    static let configuration: CommandConfiguration = CommandConfiguration(abstract: "B2D is a simple command line uttillity intended to convert binary number to decimal",version: "1.0", subcommands: [Converter.self, Encode.self],defaultSubcommand: Converter.self)
    

}

struct Options: ParsableArguments{
    @Argument(help: "Value you wish to convert") var arg: String
    @Option(name: .shortAndLong, help: "Set the number system base. The default is 2 (binary). Other options are 8 (octal), 10 (decimal), and 16 (hexadecimal).") var numberBase: Int = 2
	@Option(name: .shortAndLong, help: "Set the separator for the IP or Subnet octets: ") var separator: String = "."
}
