//
//  Mockdata.swift
//  KMe
//
//  Created by CSS on 25/10/23.
//

import Foundation

struct APPCONTENT {
    //URL Enviroments
    static var getnotifications:NSArray {
           let notifications =   [
            Notify(profileName: "Helena Wayne", image: "https://i.ibb.co/MSc2dth/person1.png", Id: 1, description: "Accessed your Indian passport", timesince: "2 hours ago", type: 1),
            Notify(profileName: "Damian Wayne", image: "https://i.ibb.co/ZhFHW6V/person2.png", Id: 1, description: "Requested access for your Indian passport", timesince: "1 day ago", type: 2),
            Notify(profileName: "Diana Luther", image: "https://i.ibb.co/MDjgyVH/person3.png", Id: 1, description: "Requested access for your Indian passport", timesince: "3 days ago", type: 3),
            Notify(profileName: "Meeya Rajan", image: "https://i.ibb.co/jvYvYHy/person4.png", Id: 1, description: "Accessed your Indian passport", timesince: "4 days ago", type: 1),
            
            Notify(profileName: "Henry Joseph", image: "https://i.ibb.co/zrZg5wJ/person5.png", Id: 1, description: "Accessed your Indian passport", timesince: "5 days ago", type: 1)
           ]
        
       
        return notifications as NSArray
    }
    
    
    static var getreminders:NSArray {
           let notifications =   [
            Reminder(profileName: "Bruce (Yours)", image: "https://i.ibb.co/KF6gPdX/person1.png", Id: 1, country: "India", timesince: "Expires today", type: 1, documenttype: "Passport"),
            Reminder(profileName: "Damian Wayne", image: "https://i.ibb.co/vssGjg1/person2.png", Id: 1, country: "UK", timesince: "Expires today", type: 1, documenttype: "Passport"),
            
            Reminder(profileName: "Diana Luther", image: "https://i.ibb.co/JngDMJc/person3.png", Id: 1, country: "USA", timesince: "Expires today", type: 1, documenttype: "Health Card"),
            
            Reminder(profileName: "Meeya Rajan", image: "https://i.ibb.co/ZXF2zBM/person4.png", Id: 1, country: "Canada", timesince: "Expires today", type: 1, documenttype: "Voter Identity"),
            Reminder(profileName: "Henry Joseph", image: "https://i.ibb.co/cF34xpj/person5.png", Id: 1, country: "Australia", timesince: "Expires today", type: 1, documenttype: "Passport")
            
           
           ]
        
       
        return notifications as NSArray
    }
    
    static var getupcomingreminder:NSArray {
           let notifications =   [
            Reminder(profileName: "Henry Joseph", image: "https://i.ibb.co/cF34xpj/person5.png", Id: 1, country: "UK", timesince: "Expires in 3 days", type: 1, documenttype: "Passport"),
            
            Reminder(profileName: "Diana Luther", image: "https://i.ibb.co/JngDMJc/person3.png", Id: 1, country: "Australia", timesince: "Expires in 90 days", type: 2, documenttype: "Health Card"),
           
            Reminder(profileName: "Damian Wayne", image: "https://i.ibb.co/vssGjg1/person2.png", Id: 1, country: "USA", timesince: "Expires in 72 days", type: 2, documenttype: "Passport"),
          
            Reminder(profileName: "Bruce (Yours)", image: "https://i.ibb.co/KF6gPdX/person1.png", Id: 1, country: "Canada", timesince: "Expires in 45 days", type: 2, documenttype: "Passport"),
            Reminder(profileName: "Meeya Rajan", image: "https://i.ibb.co/ZXF2zBM/person4.png", Id: 1, country: "India", timesince: "Expires in 32 days", type: 2, documenttype: "Voter Identity"),
          
            
           
           ]
        
       
        return notifications as NSArray
    }
 
    static var getsharewith:NSArray {
           let notifications =   [
            Sharedwith(profileName: "Helena Wayne", image: "https://i.ibb.co/cF34xpj/person5.png", Id: 1, description: "Access for KYC approval", timesince: "2 hours ago", type: 1,toshare: "Wife"),
            
            Sharedwith(profileName: "Diana Luther", image: "https://i.ibb.co/JngDMJc/person3.png", Id: 1, description: "Access for driving licence renewal", timesince: "Mar 27, 2023", type: 2, toshare: "Son"),
            
            Sharedwith(profileName: "Amelia", image: "https://i.ibb.co/ZXF2zBM/person4.png", Id: 1, description: "Access for verification", timesince: "Mar 23, 2023", type: 3,toshare: "Brother")
           
           ]
        
       
        return notifications as NSArray
    }
    
    
    
    static var getmembers:NSArray {
           let notifications =   [
            Member(profileName: "Helena Wayne", image: "https://i.ibb.co/ggD4yvk/person1.png", Id: 1, relationship: "Wife",country:"",status:1),

            Member(profileName: "Damian Wayne", image: "https://i.ibb.co/p3qmYWv/person2.png", Id: 1, relationship: "Father",country:"",status:1),

            Member(profileName: "Diana Luther", image: "https://i.ibb.co/7GMdhRF/person3.png", Id: 1, relationship: "Mother",country:"",status:1),
            
            Member(profileName: "Meeya Rajan", image: "https://i.ibb.co/JK6wMGt/person4.png", Id: 1, relationship: "Son",country:"",status:1),
            
            Member(profileName: "Henry Joseph", image: "https://i.ibb.co/QDVXySQ/person5.png", Id: 1, relationship: "Uncle",country:"",status:1),
           ]


        return notifications as NSArray
    }
    
    
    static var getinvitemember:NSArray {
           let notifications =   [
            InviteMember(profileName: "Helena Wayne", image: "https://i.ibb.co/ggD4yvk/person1.png", Id: 1, relationship: "Wife",country:"",status:1,memberemail: "helena@gmail.com"),

            InviteMember(profileName: "Damian Wayne", image: "https://i.ibb.co/p3qmYWv/person2.png", Id: 1, relationship: "Father",country:"",status:1,memberemail: "damian@gmail.com"),

            InviteMember(profileName: "Diana Luther", image: "https://i.ibb.co/7GMdhRF/person3.png", Id: 1, relationship: "Mother",country:"",status:1,memberemail: "diana@gmail.com"),
            
            InviteMember(profileName: "Meeya Rajan", image: "https://i.ibb.co/JK6wMGt/person4.png", Id: 1, relationship: "Son",country:"",status:1,memberemail: "meeya@gmail.com"),
            
            InviteMember(profileName: "Henry Joseph", image: "https://i.ibb.co/QDVXySQ/person5.png", Id: 1, relationship: "Uncle",country:"",status:1,memberemail: "henry@gmail.com"),
           ]


        return notifications as NSArray
    }
    
    
    static var getrecenactivity:NSArray {
            let notifications =   [
             Activity(profileName: "Helena Wayne", image: "https://i.ibb.co/cF34xpj/person5.png", Id: 1, country: "UK", timesince: "Accessed 2 hours ago", type: 1, documenttype: "Passport"),
             
             Activity(profileName: "Diana Luther", image: "https://i.ibb.co/JngDMJc/person3.png", Id: 1, country: "Australia", timesince: "Accessed 8 hours ago", type: 2, documenttype: "Health Card"),
            
             Activity(profileName: "Damian Wayne", image: "https://i.ibb.co/vssGjg1/person2.png", Id: 1, country: "USA", timesince: "Accessed 2 days ago", type: 2, documenttype: "Passport"),
           
             Activity(profileName: "Meeya Rajan", image: "https://i.ibb.co/KF6gPdX/person1.png", Id: 1, country: "Canada", timesince: "Accessed 1 month ago", type: 2, documenttype: "Passport"),
             Activity(profileName: "Henry Joseph", image: "https://i.ibb.co/ZXF2zBM/person4.png", Id: 1, country: "India", timesince: "Accessed 1 month ago", type: 2, documenttype: "Voter Identity"),
           
             
            
            ]

        return notifications as NSArray
    }
    
    static var getCountryMaster:NSArray {
            let notifications =   [
                CountryMaster(Id: 1, name: "All", flagname: "All"),
                CountryMaster(Id: 1, name: "India", flagname: "flag"),
                CountryMaster(Id: 1, name: "UK", flagname: "UK"),
                CountryMaster(Id: 1, name: "USA", flagname: "USA"),
                CountryMaster(Id: 1, name: "Canada", flagname: "Canada"),
                CountryMaster(Id: 1, name: "Australia", flagname: "aus"),
           
            
            ]

        return notifications as NSArray
    }


    
    
    
    
    static var getMemberDocuments:NSArray {
            let notifications =   [
                MemberDocument(Id: 1, documentName: "Passport", documentPlaceholder: "passport_placeholder", documentColour: "FF7639", status: 1),
            MemberDocument(Id: 2, documentName: "Voter ID Card", documentPlaceholder: "voterid_placeholder", documentColour: "F1CF48", status: 1),
            MemberDocument(Id: 3, documentName: "Aadhaar Card", documentPlaceholder: "aadhaar", documentColour: "CBBFD7", status: 1),
            MemberDocument(Id: 4, documentName: "Driving License", documentPlaceholder: "drivinglicence_placehoder", documentColour: "E7FE55", status: 1),
            
            ]

        return notifications as NSArray
    }
    
    
    static var getgender:NSArray {
        
        let gendermaster = ["Select gender","Male","Female","Other","Don't want to specify"]
        return gendermaster as NSArray
    }

}
