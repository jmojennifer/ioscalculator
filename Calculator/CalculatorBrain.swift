//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Jennifer Owens on 5/2/17.
//  Copyright © 2017 Jennifer Owens. All rights reserved.
//

import Foundation

func changeSign(operand: Double) -> Double {
    return -operand
}

func multiply(opt1: Double, opt2: Double) -> Double {
    return opt1 * opt2
}

//stucts automatically initialize vars by default
struct CalculatorBrain {
    
    // private is for internal-only variables; the ? optional sets it to nil which is what we want from the start
    private var accumulator: Double?
    
    // new private type enum to have Double, others, etc. to represent all operations
    private enum Operation {
        // enums can have associated values i.e. (Double)
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±" : Operation.unaryOperation(changeSign),
        "x" : Operation.binaryOperation(multiply),
        "=" : Operation.equals
    ]
    
    // mutating is needed here because accumulator is being mutated (but would otherwise be immutable)
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    
    //in a struct, need to tell a method that it's mutating otherwise it'll treat it as immutable
    mutating func setOperand( _ operand: Double) {
        accumulator = operand
        
    }
    
    // read-only property, because set is not also included; is a ? optional because it will not always be set (i.e. in the times part of 5 * 3
    var result: Double? {
        get {
            return accumulator
        }
    }
}
