//
//  SleepAnalysis.swift
//  weltAppleHealthETL
//
//  Created by jo on 2021/05/08.
//

import Foundation

class SleepAnalysis{
    var sleepInBed:SleepInBed
    var sleepAsleepList:[SleepAsleep]
    var TIB:Int//inbed 시간 합
    var TST:Int//asleep시간 합
    var SOL:Int//불끄고 잠 들때까지 걸린 시간
    var TASAFA:Int//완전히 깼는데 침대에 누워있던시간
    var frequencyWakeUp: Int//자다 중간에 깬 빈도수
    var WASO:Int
    var sleepEfficiency:Double
    init(inbed : SleepInBed,asleepList:[SleepAsleep],tib:Int,tst:Int,sol:Int,tasafa:Int,frequncy:Int,waso:Int, eff:Double) {
        self.sleepInBed=inbed
        self.sleepAsleepList=asleepList
        self.TIB=tib
        self.TST=tst
        self.SOL=sol
        self.TASAFA=tasafa
        self.frequencyWakeUp=frequncy
        self.WASO=waso
        self.sleepEfficiency=eff
    }
}
