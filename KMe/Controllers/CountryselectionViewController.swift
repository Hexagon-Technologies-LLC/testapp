//
//  CountryselectionViewController.swift
//  KMe
//
//  Created by CSS on 15/09/23.
//

import UIKit
protocol regionselectiondelegate: AnyObject {
    func regionselectionapplied(countries: NSMutableArray)
    func regionclosed()
    
}
class CountryselectionViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    @IBOutlet weak var countriestable: UITableView!
    @IBOutlet weak var searchbar: UISearchBar!
    
    var countrylist : NSMutableArray = NSMutableArray()
    var mastercountrylist : NSMutableArray = NSMutableArray()
    var selectedcountry : NSMutableArray = NSMutableArray()
    
    weak var regiondelegate: regionselectiondelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countriestable.register(UINib(nibName: "CountryselectionTableViewCell", bundle: nil), forCellReuseIdentifier: "CountryselectionTableViewCell")
        countriestable.delegate = self
        countriestable.dataSource = self
        countriestable.separatorStyle = .singleLine
        
        countrylist = ["India","UK","Australia", "USA","Canada"]
        
        mastercountrylist = ["India","UK","Australia", "Canada"]
        searchbar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        countriestable.reloadData()
    }
    @IBAction func applyfilter(_ sender: UIButton) {
        
        
        regiondelegate?.regionselectionapplied(countries: selectedcountry)
        selectedcountry.removeAllObjects()
        countriestable.reloadData()
    }
    
    @IBAction func clearfilter(_ sender: UIButton) {
        self.view.endEditing(true)
        selectedcountry.removeAllObjects()
        countriestable.reloadData()
        //dismiss(animated: true)
        
    }
    @IBAction func cancelchoose(_ sender: UIButton) {
        regiondelegate?.regionclosed()
        
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  countrylist.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryselectionTableViewCell", for: indexPath) as! CountryselectionTableViewCell
        cell.countryLabel.text = countrylist[indexPath.row] as? String
        cell.coiuntryflag.image = UIImage.init(named: countrylist[indexPath.row] as! String)
        cell.tintColor = UIColor.init(named: "primarytextcolor")
        if selectedcountry.contains( countrylist[indexPath.row] as! String) {
            cell.accessoryType = .checkmark
            
        }
        else
        {
            cell.accessoryType = .none
            
        }
        
        cell.selectionStyle = .none
        
        return cell
        
        
        
        
        // cell.backgroundColor = rainbow[indexPath.item]
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let countryname =  countrylist.object(at: indexPath.row) as? String
        
        if selectedcountry.contains(countryname ?? "") {
            selectedcountry.remove(countryname ?? "")
        }else{
            selectedcountry.add(countryname ?? "")
        }
        countriestable.reloadData()
        
    }
    
    
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        print("search endediting")
        return true
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //  if searchbar.text?.count == 1 && stockslist.count == 0 {
        filterdata(searchtxt : searchText)
        
        /*  }else{
         if searchbar.text?.count ?? 0 > 1 {
         self.filterdata(searchtxt: searchText)
         
         }
         
         }*/
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        print("begin beginediting")
        return true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        if !(searchbar.text?.isEmpty ?? false) {
            filterdata(searchtxt : searchbar.text ?? "")
            
        }else{
            //            stockslist.removeAllObjects()
            //            stocktable.reloadData()
        }
        
    }
    func filterdata(searchtxt: String)
    {
        print("searchText",searchtxt)
        
        //  let predicate = NSPredicate(format: "symbol BEGINSWITH [c] %@", searchtxt.uppercased())
        //let filtered = stockslist.filtered(using: predicate)
        if let a = mastercountrylist as? [String] {
            
            print("searchText",a)
            
            let filteredArray = a.filter { $0.localizedLowercase.hasPrefix(searchtxt.lowercased()) == true }
            
            
            print(filteredArray)
            countrylist.removeAllObjects()
            countrylist.addObjects(from: filteredArray)
            countriestable.reloadData()
            // [["id": 1, "name": x1], ["name": x2, "id": 2]]
        }
    }
}
