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
    //@Option(name: .shortAndLong, help: "set the number system base") var base: Int = 2
}
