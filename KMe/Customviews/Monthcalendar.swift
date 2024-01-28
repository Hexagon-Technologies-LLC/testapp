//
//  Monthcalendar.swift
//  KMe
//
//  Created by CSS on 20/10/23.
//

import UIKit

class Monthcalendar: UIView {

    
    /* To show monthlyview we arrange 7 row with 6 button each row.
     based on month day we handle button visiblity using the tag number
     button tag number start from 101 to 143
     */
    
    public func updatedate(startdate: Date)  {
        var start_tag_number = 101;
        
        /**Get first day of the current month**/
        var currentDate = startdate.firstDateOfMonth()
        /**Get first day of the next  month**/
        let monthEndDate = currentDate.addMonth(1)!

        var starting_tag = -1;
        
        
        
        /**This while loop used to hide all button  useing background color **/
        while start_tag_number < 143 {
            if let daybtn = self.viewWithTag(start_tag_number) as? UIButton {
                daybtn.setTitle("", for: .normal)
                daybtn.borderWidth = 0;
                daybtn.borderColor = .clear
                daybtn.cornerRadius = 0
                daybtn.backgroundColor = .clear
            }
            
            start_tag_number = start_tag_number + 1
        }
        
        
        /** Change the background color for uibutton based on current month days  **/

        while currentDate < monthEndDate {
            
            if currentDate == currentDate.firstDateOfMonth() {
               
                starting_tag = currentDate.dayNumberOfWeek() ?? -1;
            }
            
            /*we start element tag number from 101 so added 100 here*/
            let buttontag = starting_tag + 100
           
            if let daybtn = self.viewWithTag(buttontag) as? UIButton {
                // set date value as title for the button
                daybtn.setTitle(currentDate.format(dateFormat: "dd"), for: .normal)
                daybtn.setTitleColor(.white, for: .normal)

                // Highlight current date with differenct background color
                if(Calendar.current.isDateInToday(currentDate))
                {
                    daybtn.backgroundColor = UIColor.init(named: "accent")
                    daybtn.borderWidth = 1
                    daybtn.cornerRadius = 7
                    daybtn.setTitleColor(.black, for: .normal)
                }
                //use this commmented code to customize the day view
//                 else if(buttontag == 107 || buttontag == 103 ||  buttontag == 118)
//                    {
//                        daybtn.backgroundColor = UIColor.clear
//                        daybtn.borderWidth = 1
//                     daybtn.cornerRadius = 7
//                     daybtn.borderColor = UIColor.init(named: "accent")
//                     daybtn.setTitleColor(.white, for: .normal)
//                    }
//
                    
                
                
            }
           
            // Increase tag number for each day

            if(starting_tag > -1)
            {
                starting_tag = starting_tag + 1
                currentDate = currentDate.addDays(1)!

            }
        }
    }
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder: NSCoder) {
           super.init(coder: coder)
           commonInit()
       }
       
    /**load ui from nib file**/
       func commonInit(){
           let viewFromXib = Bundle.main.loadNibNamed("Monthcalendar", owner: self, options: nil)![0] as! UIView
           viewFromXib.frame = self.bounds
           addSubview(viewFromXib)
       }

}
