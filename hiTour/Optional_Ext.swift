//
//  Optional_Ext.swift
//  hiTour
//
//  Created by Adam Chlupacek on 17/03/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation

extension Optional {
    
    /// A standard fold funcion on optional value
    ///
    /// Takes a default value then if empty returns this value
    /// Otherwise it will apply a function f and will make a type A out of the wrapped type
    ///
    func fold<A>(def: A) -> ((Wrapped -> A) -> A) {
        func wrap(f: Wrapped -> A) -> A {
            switch self {
            case .Some(let w):
                return f(w)
            case _:
                return def
            }
        }
        return wrap
    }
    
    ///
    /// Convenience function for cheking if option is empty
    ///
    func isEmpty() -> Bool {
        return self == nil
    }
    
    ///
    /// Gets either the value of the optional or if empty it will return a def value
    ///
    func getOrElse(def: Wrapped) -> Wrapped  {
        if self != nil {
            return self!
        } else {
            return def
        }
    }
    
    ///
    /// As map except it expects a void return type, and returns void on its own, not an Option<B>
    ///
    func forEach(f: (Wrapped) -> Void) -> Void {
        switch self {
        case .Some(let w):
            f(w)
        case _: {}()
        }
    }
}