//
//  CalendarViewController.swift
//  KMe
//
//  Created by CSS on 05/10/23.
//

import UIKit

class CalendarViewController: UIViewController,DateScrollPickerDelegate,DateScrollPickerDataSource,Calendarswitchdelegate {
    /**  Delegate method to show today reminder view **/
    func todayview() {
        istodayview = true;
        reminderTableview.reloadData()
    }
    /**  Delegate method to show upcoming  reminder view **/
    func upcomingview() {
        istodayview = false
        reminderTableview.reloadData()
    }
    
    /**  Delegate method to toggle monthly view and weekly view **/
    func switchview(monthlyview: Bool) {
        ismonthview = monthlyview
        reminderTableview.reloadData()
        
    }
    
    /**  Declaration of interface builder components**/
    @IBOutlet weak var dateScrollPicker: DateScrollPicker!
    @IBOutlet weak var todyBtn: UIButton!
    @IBOutlet weak var upcomingBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var prevBtn: UIButton!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var calendarmonthview: UIDatePicker!
    @IBOutlet weak var calendarMonthly: Monthcalendar!
    @IBOutlet weak var monthyearview: UILabel!
    @IBOutlet weak var dayanddate: UILabel!
    @IBOutlet weak var reminderTableview: UITableView!

    
    
    var istodayview : Bool = true
    var ismonthview : Bool = false
    var data = Array(0..<10)
    var currentdate : Date = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**call inital setup method for weekly view**/
        setupweekviewcalendar()
        
        /**Setup delegate and datasource method of reminder table*/
        reminderTableview.delegate = self
        reminderTableview.dataSource = self
        /***Add bottom padding for remindertable***/
        self.reminderTableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        
        /*register cell for calendar and monthly view*/
        reminderTableview.register(UINib(nibName: "CalendarTableViewCell", bundle: nil), forCellReuseIdentifier: "CalendarTableViewCell")
        
        /*register cell for  reminder section view view*/

        reminderTableview.register(UINib(nibName: "CalendarHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "CalendarHeaderTableViewCell")
        
        reminderTableview.rowHeight = UITableView.automaticDimension
        
        
        
        
        
        calendarmonthview.setValue(UIColor.white, forKeyPath: "textColor")
        monthyearview.text = currentdate.format(dateFormat: "MMMM, YYYY")
        dayanddate.text = currentdate.format(dateFormat: "EEEE, dd")
        
        /**setup date  start date for monthly calender view **/
        calendarMonthly.updatedate(startdate: currentdate)
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
    
    
    /**action to switch next month**/
    @IBAction func nextmonth(_ sender: UIButton) {
        currentdate = currentdate.addMonth(1)!
        monthyearview.text = currentdate.format(dateFormat: "MMMM, YYYY")
        /**Based on the view switch the calendar date selection**/
        if(ismonthview)
        {
            /**set selection date for month calendar**/
            calendarMonthly.updatedate(startdate: currentdate)
            
            
        }
        else
        {
            /**set selection date for weekview calendar**/
            dateScrollPicker.scrollToDate((currentdate.addMonth(1)?.firstDateOfMonth())!)
            
        }
        
        
    }
    /**action to switch prev month**/
    @IBAction func prevmonth(_ sender: UIButton) {
        currentdate = currentdate.addMonth(-1)!
        monthyearview.text = currentdate.format(dateFormat: "MMMM, YYYY")
        
        if(ismonthview)
        {
            /**set selection date for month calendar**/

            calendarMonthly.updatedate(startdate: currentdate)
            
            
        }else
        {
            /**set selection date for weekview calendar**/

            dateScrollPicker.scrollToDate(currentdate.firstDateOfMonth())
            
        }
        
    }
    
    /**action to switch month and week view calender**/
    @IBAction func switchcalender(_ sender: UIButton) {
        ismonthview = !ismonthview
        if(ismonthview)
        {
            dateScrollPicker.isHidden = true
            calendarMonthly.isHidden = false
            calendarMonthly.updatedate(startdate: currentdate)
            
            
        }else
        {
            dateScrollPicker.isHidden = false
            calendarMonthly.isHidden = true
            dateScrollPicker.scrollToDate(currentdate.firstDateOfMonth())
            
            
        }
        
    }
    
    
    func dateScrollPicker(_ dateScrollPicker: DateScrollPicker, dotColorByDate date: Date) -> UIColor? {
        if Date.today() == date { return .yellow }
        if Date.today().addDays(1) == date { return UIColor(hex: "00FF1A") }
        if Date.today().addDays(-1) == date { return UIColor(hex: "00FF1A") }
        return UIColor.white.withAlphaComponent(0.1)
    }
    
    
    /**  Method to setup initial attributes of calenderview,  **/
    private func setupweekviewcalendar() {
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
    }
    override func viewDidAppear(_ animated: Bool) {
        dateScrollPicker.selectToday(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
     
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



extension CalendarViewController: UITableViewDataSource {
    
    
    /**this datasource method to define how many rows need to render in each section**/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(istodayview)
        {
            /**set today view reminder count and add one row because of to show week view calender and month view calender**/

            return APPCONTENT.getreminders.count + 1
            
        }else
        {
            /**set upcoming view reminder count and add one row because of to show week view calender and month view calender**/

            return APPCONTENT.getupcomingreminder.count + 1
            
        }
    }
    
    
    /**This data source method to show how each cell will show**/
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /**First row we render the calendar component**/

        if(indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarHeaderTableViewCell", for: indexPath) as! CalendarHeaderTableViewCell
            cell.setcalendarswitch = self
            cell.selectionStyle = .none
            cell.updatecalview(calswitch: ismonthview,switchview: istodayview)
            
            return cell
        }else
        {
            /**Other than first row render the reminder component**/

            let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell", for: indexPath) as! CalendarTableViewCell
            
            //here to show different status of reminder we put this condition may u can remove while integration if you maintain recoard in single array
            if(istodayview)
            {
                let reminderobj = APPCONTENT.getreminders[indexPath.row - 1] as! Reminder
                cell.profileimage.loadImageUsingCache(withUrl: reminderobj.image ?? "")
                cell.profilename.text = reminderobj.profileName
                cell.expirelabel.text = reminderobj.timesince
                cell.doctypename.text = reminderobj.documenttype
                cell.flagview.image = UIImage.init(named: reminderobj.country ?? "")
                if(reminderobj.type == 1)
                {
                    cell.expireview.backgroundColor = .red
                }else
                {
                    cell.expireview.backgroundColor = UIColor.init(named: "bgcolor")
                }
            }
            else {
                let reminderobj = APPCONTENT.getupcomingreminder[indexPath.row - 1] as! Reminder
                cell.profileimage.loadImageUsingCache(withUrl: reminderobj.image ?? "")
                cell.profilename.text = reminderobj.profileName
                cell.expirelabel.text = reminderobj.timesince
                cell.doctypename.text = reminderobj.documenttype
                cell.flagview.image = UIImage.init(named: reminderobj.country ?? "")
                if(reminderobj.type == 1)
                {
                    cell.expireview.backgroundColor = .red
                }else
                {
                    cell.expireview.backgroundColor = UIColor.init(named: "bgcolor")
                }
            }
            cell.selectionStyle = .none
            
            
            return cell
        }
        
    }
    
    /**This datasource method to define the height of the tableview**/
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0)
        {
            
            /**Change the height based on calendar view **/

            return !ismonthview ? 350 : 500
        }else
        {
            return UITableView.automaticDimension
        }
        
    }
}

extension CalendarViewController: UITableViewDelegate {
    
  
    
   
    
    private func handleReupload() {
        print("Moved to reupload")
    }
    
    private func handleSnooze() {
        print("Moved to snooze")
    }
    
    /**
     ddelegate method to swipe tableview row
    **/
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if(indexPath.row > 0)
        {
            // Snooze action
            let archive = UIContextualAction(style: .destructive,
                                             title: "Snooze") { [weak self] (action, view, completionHandler) in
                self?.handleSnooze()
                completionHandler(true)
            }
            // Reupload action
            let reupload = UIContextualAction(style: .normal,
                                              title: "Re-upload") { [weak self] (action, view, completionHandler) in
                self?.handleReupload()
                completionHandler(true)
            }
            reupload.backgroundColor = UIColor.init(hex: "373835")
            
            reupload.image =  UIImage.init(named: "upload")!
            
            
            archive.image = UIImage.init(named: "reminder")!
            
            let actions: [UIContextualAction] = [archive,reupload]
            
            let configuration = UISwipeActionsConfiguration(actions: actions)
            configuration.performsFirstActionWithFullSwipe = false
            return configuration
        }else{
            return nil
        }
        
    }
    
    
    /**action for navigation buttons**/
    @IBAction func searchclicked(_ sender: UIButton){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SendInviteViewController") as! SendInviteViewController
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    @IBAction func notifyclicked(_ sender: UIButton){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    @IBAction func backclicked(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}

