//
//  StopWatch.swift
//  StopWatch-02
//
//  Created by 태로고침 on 2021/04/04.
//

import Foundation

class StopWatch: NSObject {
    var counter: Double
    var timer: Timer
    
    override init(){
        counter = 0.0
        timer = Timer()
    }
}
