//
//  ViewController.swift
//  StopWatch-02
//
//  Created by 태로고침 on 2021/04/04.
//

import UIKit

class ViewController: UIViewController {
    
    fileprivate let mainStopWatch: StopWatch = StopWatch()
    fileprivate let lapStopWatch: StopWatch = StopWatch()
    fileprivate var isPlay: Bool = false
    fileprivate var laps:[String] = []
    
    @IBOutlet weak var mainStopWatchLabel: UILabel!
    @IBOutlet weak var lapStopWatchLabel: UILabel!
    @IBOutlet weak var lapTimerBtn: UIButton!
    @IBOutlet weak var startTimerBtn: UIButton!
    @IBOutlet weak var lapsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Timer"
        
        lapTimerBtn.isEnabled = false
        lapsTableView.delegate = self
        lapsTableView.dataSource = self
        
    }
    
    // Pressed laps Btn
    @IBAction func pressedLapTimerBtn(_ sender: UIButton) {
        if !isPlay {
          resetMainTimer()
          resetLapTimer()
          changeButton(lapTimerBtn, title: "Lap", titleColor: UIColor.lightGray)
          lapTimerBtn.isEnabled = false
        } else {
          if let timerLabelText = mainStopWatchLabel.text {
            laps.append(timerLabelText)
          }
          lapsTableView.reloadData()
          resetLapTimer()
          unowned let weakSelf = self
          lapStopWatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: weakSelf, selector: Selector.updateLapTimer, userInfo: nil, repeats: true)
          RunLoop.current.add(lapStopWatch.timer, forMode: RunLoop.Mode.common)
        }
    }
    
    // Pressed Start, Stap Btn
    @IBAction func pressedStartBtn(_ sender: UIButton) {
        lapTimerBtn.isEnabled = true
        if !isPlay {
            unowned let weakSelf = self
            mainStopWatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: weakSelf, selector: Selector.updateMainTimer, userInfo: nil, repeats: true)
            
            RunLoop.current.add(mainStopWatch.timer, forMode: RunLoop.Mode.common)
            RunLoop.current.add(lapStopWatch.timer, forMode: RunLoop.Mode.common)
            
            isPlay = true
            changeButton(startTimerBtn, title: "Stop", titleColor: UIColor.red)
        }
        else {
            
            mainStopWatch.timer.invalidate()
            lapStopWatch.timer.invalidate()
            isPlay = false
            changeButton(startTimerBtn, title: "Start", titleColor: UIColor.green)
            changeButton(lapTimerBtn, title: "Reset", titleColor: UIColor.black)
        }
        
    }
    
}




extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String = "lapCell"
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        if let labelNum = cell.viewWithTag(11) as? UILabel {
          labelNum.text = "Lap \(laps.count - (indexPath as NSIndexPath).row)"
        }
        if let labelTimer = cell.viewWithTag(12) as? UILabel {
          labelTimer.text = laps[laps.count - (indexPath as NSIndexPath).row - 1]
        }
        
        return cell
    }
}

extension ViewController {
    
    // 버튼 전환
    fileprivate func changeButton(_ button: UIButton, title: String, titleColor: UIColor) {
        button.setTitle(title, for: UIControl.State())
        button.setTitleColor(titleColor, for: UIControl.State())
    }
    
    // 메인 타이머 리셋
    fileprivate func resetMainTimer() {
        resetTimer(mainStopWatch, label: mainStopWatchLabel)
        laps.removeAll()
        lapsTableView.reloadData()
    }
    
    // 랩타이머 리셋
    fileprivate func resetLapTimer() {
        resetTimer(lapStopWatch, label: lapStopWatchLabel)
    }
    
    //타이머 리셋
    fileprivate func resetTimer(_ stopwatch: StopWatch, label: UILabel) {
        stopwatch.timer.invalidate()
        stopwatch.counter = 0.0
        label.text = "00:00:00"
    }
    
    //메인 타이머 업데이트
    @objc func updateMainTimer() {
        updateTimer(mainStopWatch, label: mainStopWatchLabel)
    }
    
    //랩 타이머 업데이트
    @objc func updateLapTimer() {
        updateTimer(lapStopWatch, label: lapStopWatchLabel)
    }
    
    
    // 타이머 업데이트
    func updateTimer(_ stopwatch: StopWatch, label: UILabel) {
        stopwatch.counter = stopwatch.counter + 0.035
        
        var minutes: String = "\((Int)(stopwatch.counter / 60))"
        if (Int)(stopwatch.counter / 60) < 10 {
            minutes = "0\((Int)(stopwatch.counter / 60))"
        }
        
        var seconds: String = String(format: "%.2f", (stopwatch.counter.truncatingRemainder(dividingBy: 60)))
        if stopwatch.counter.truncatingRemainder(dividingBy: 60) < 10 {
            seconds = "0" + seconds
        }
        
        label.text = minutes + ":" + seconds
    }
}

// MARK: - Extension
fileprivate extension Selector {
    static let updateMainTimer = #selector(ViewController.updateMainTimer)
    static let updateLapTimer = #selector(ViewController.updateLapTimer)
}
