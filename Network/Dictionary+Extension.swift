//
//  Dictionary+Extension.swift
//  Network
//
//  Created by lyy on 2017/11/27.
//  Copyright © 2017年 lyy. All rights reserved.
//

import Foundation

func += <K, V> (left: inout [K:V], right: [K:V]) {
    for (k, v) in right {
        left[k] = v
    }
}
