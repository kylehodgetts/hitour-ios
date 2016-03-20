//
//  Optional_Ext.swift
//  hiTour
//
//  Created by Adam Chlupacek on 17/03/16.
//  Copyright © 2016 stranders.kcl.ac.uk. All rights reserved.
//

import Foundation

extension Optional {
    
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
    
    func isEmpty() -> Bool {
        return self == nil
    }
    
    func getOrElse(val:Wrapped) -> Wrapped  {
        if self != nil {
            return self!
        } else {
            return val
        }
    }
    
    func forEach(f: (Wrapped) -> Void) -> Void {
        switch self {
        case .Some(let w):
            f(w)
        case _: {}()
        }
    }
}