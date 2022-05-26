//
//  CountDownViewController.swift
//  GettingUsedToSwift
//
//  Created by Dan Abid on 2/17/21.
//

import UIKit

class CountDownViewController: UIViewController {

    @IBOutlet weak var CountDownDateSelected: UIDatePicker!
    @IBOutlet weak var countDownLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    var date = Date()

    @IBAction func dateSelected(_ sender: Any) {
        date = CountDownDateSelected.date
        countDownLabel.text = "Time Left: " + date.timeIntervalSinceNow.format()!
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension TimeInterval {

  func format() -> String? {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.day, .hour, .minute, .second, .nanosecond]
    formatter.unitsStyle = .abbreviated
    formatter.maximumUnitCount = 4
    return formatter.string(from: self)
  }
}
