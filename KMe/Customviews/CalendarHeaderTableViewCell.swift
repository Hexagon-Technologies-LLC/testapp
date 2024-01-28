//
//  CalendarHeaderTableViewCell.swift
//  KMe
//
//  Created by CSS on 31/10/23.
//

import UIKit
protocol Calendarswitchdelegate:AnyObject {
    func switchview(monthlyview : Bool)
    func todayview()
    func upcomingview()
}
class CalendarHeaderTableViewCell: UITableViewCell,DateScrollPickerDelegate,DateScrollPickerDataSource  {
    @IBOutlet weak var dateScrollPicker: DateScrollPicker!
    weak var setcalendarswitch:Calendarswitchdelegate?
    @IBOutlet weak var dayanddate: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var monthyearview: UILabel!
    @IBOutlet weak var calendarMonthly: Monthcalendar!
    @IBOutlet weak var todaybtn: UIButton!
    @IBOutlet weak var upcomingbtn: UIButton!
    var ismonthview : Bool = false
    var currentdate : Date = Date()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.prevBtn.transform = CGAffineTransformMakeRotation(Double.pi)

        setupScrollPicker3()
        resetweekview()
    }

    func resetweekview()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) { [self] in
            self.dateScrollPicker.selectToday(animated: true)
            currentdate =  Date()
            monthyearview.text = currentdate.format(dateFormat: "MMMM, YYYY")
            dayanddate.text = currentdate.format(dateFormat: "EEEE, dd")

            if(self.ismonthview)
            {
                self.dateScrollPicker.isHidden = false
            }
        }
    }
    @IBAction func upcomingcontent(_ sender: UIButton) {
        setcalendarswitch?.upcomingview()
       
    }
    @IBAction func todaycontent(_ sender: UIButton) {
      
        setcalendarswitch?.todayview()
    }
    @IBAction func nextmonth(_ sender: UIButton) {
      

        if(ismonthview)
        {
            currentdate = currentdate.addMonth(1)!
            monthyearview.text = currentdate.format(dateFormat: "MMMM, YYYY")
            calendarMonthly.updatedate(startdate: currentdate)


        }
        else
        {
            currentdate = currentdate.addDays(7)!
            monthyearview.text = currentdate.format(dateFormat: "MMMM, YYYY")
            dateScrollPicker.scrollToDate(currentdate)

        }
       

    }
    @IBAction func prevmonth(_ sender: UIButton) {
   
        if(ismonthview)
        {
            currentdate = currentdate.addMonth(-1)!
            monthyearview.text = currentdate.format(dateFormat: "MMMM, YYYY")

            calendarMonthly.updatedate(startdate: currentdate)


        }else
        {
            currentdate = currentdate.addDays(-7)!
            monthyearview.text = currentdate.format(dateFormat: "MMMM, YYYY")

            dateScrollPicker.scrollToDate(currentdate)

        }

    }
    @IBAction func switchcalender(_ sender: UIButton) {
        setcalendarswitch?.switchview(monthlyview: !ismonthview)
        
    }
    
    func updatecalview(calswitch: Bool,switchview: Bool)
    {
        ismonthview = calswitch;
        if(ismonthview)
        {
            moreBtn.backgroundColor = UIColor.init(named: "accent")

            moreBtn.setImage(UIImage.init(named: "monthview"), for: .normal)
            
            dateScrollPicker.isHidden = true
            calendarMonthly.isHidden = false
            calendarMonthly.updatedate(startdate: currentdate)

            
        }else
        {
            resetweekview()

            moreBtn.backgroundColor = UIColor.init(named: "descrioptiontextcolor")

            moreBtn.setImage(UIImage.init(named: "weekview"), for: .normal)
            
            dateScrollPicker.isHidden = false
            calendarMonthly.isHidden = true
            dateScrollPicker.scrollToDate(currentdate.firstDateOfMonth())


        }
        if(switchview)
        {
            todaybtn.configuration?.baseForegroundColor =   UIColor.init(named: "primarytextcolor")
            todaybtn.borderColor = UIColor.init(named: "primarytextcolor")
            upcomingbtn.configuration?.baseForegroundColor =  UIColor.init(named: "inactiveborder")
            upcomingbtn.borderColor = UIColor.init(named: "inactiveborder")
        }else
        {
            todaybtn.configuration?.baseForegroundColor =  UIColor.init(named: "inactiveborder");           todaybtn.borderColor = UIColor.init(named: "inactiveborder")
            upcomingbtn.configuration?.baseForegroundColor =   UIColor.init(named: "primarytextcolor")
            upcomingbtn.borderColor = UIColor.init(named: "primarytextcolor")
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func setupScrollPicker3() {
        var format = DateScrollPickerFormat()
        format.days = 7
        format.topTextColor = UIColor.white.withAlphaComponent(1.0)
        format.mediumTextColor = UIColor.white.withAlphaComponent(1.0)
        format.bottomTextColor = UIColor.white.withAlphaComponent(1.0)
        format.topTextSelectedColor = UIColor.black
        format.mediumTextSelectedColor = UIColor.black
        format.bottomTextSelectedColor = UIColor.black
        format.topFont = UIFont(name: "Montserrat-SemiBold", size: 8)!
        format.mediumFont = UIFont(name: "Montserrat-SemiBold", size: 18)!
        format.bottomFont = UIFont(name: "Montserrat-SemiBold", size: 8)!
        format.dayBackgroundColor = UIColor.white.withAlphaComponent(0)
        format.dayBackgroundSelectedColor = UIColor(hex: "E6FD54")
        format.separatorTopTextColor = UIColor.white.withAlphaComponent(0.6)
        format.separatorBottomTextColor = UIColor.white.withAlphaComponent(0.6)
        format.separatorBackgroundColor = UIColor.white.withAlphaComponent(0.3)
        format.separatorTopFont = UIFont(name: "Montserrat-SemiBold", size: 12)!
        format.separatorBottomFont = UIFont(name: "Montserrat-SemiBold", size: 12)!
        format.separatorEnabled = false
        dateScrollPicker.format = format
        dateScrollPicker.delegate = self
       
      //  dateScrollPicker.dataSource = self
    }
    func dateScrollPicker(_ dateScrollPicker: DateScrollPicker, mediumAttributedStringByDate date: Date) -> NSAttributedString? {
        if dateScrollPicker === dateScrollPicker {
            let attributes1 = [NSAttributedString.Key.font: UIFont(name: "Montserrat-SemiBold", size: 11)!]
            let attributes2 = [NSAttributedString.Key.font: UIFont(name: "Montserrat-SemiBold", size: 10)!]
            let attributed = NSMutableAttributedString(string: date.format(dateFormat: "dd EEE").uppercased())
            attributed.addAttributes(attributes1, range: NSRange(location: 0, length: 2))
            attributed.addAttributes(attributes2, range: NSRange(location: 2, length: 4))
            return attributed
        } else {
            return nil
        }
    }
    
    func dateScrollPicker(_ dateScrollPicker: DateScrollPicker, dataAttributedStringByDate date: Date) -> NSAttributedString? {
        if dateScrollPicker === dateScrollPicker {
            let attributes = [NSAttributedString.Key.font: UIFont(name: "Montserrat-SemiBold", size: 12)!, NSAttributedString.Key.foregroundColor: UIColor.white]
            return Date.today() == date ? NSAttributedString(string: "3 events", attributes: attributes) : nil
        } else {
            return nil
        }
    }
}
