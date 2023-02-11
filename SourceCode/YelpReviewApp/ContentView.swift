//
//  ContentView.swift
//  YelpReviewApp
//
//  Created by Fernando Torres on 12/2/22.
//

import SwiftUI
import Alamofire
import SwiftyJSON


struct ContentView: View {
    @State var key: String = ""
    @State private var distance: Double = 10
    private var categories = ["Default", "Arts and Entertainment", "Health and Medical", "Hotels and Travel", "Food", "Professional Services"]
    @State private var category = "Default"
    @State private var location: String = ""
    @State private var autoDetect: Bool = false
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var showsPopover = false
    @State private var autoSuggestions:[String] = []
    @State private var showResults = false
    @State private var resultsJson: JSON = []
    @State var businesses : [Business] = []
    @State var details : [String: BusinessDetails] = [:]
    @State var noResults = false
    @State var recurresionNum = 0
    @State var showProgress = false
    
    
    var allFields: Bool{
        if(!key.isEmpty && (autoDetect || !location.isEmpty)){
            return true
        }
        else{
            return false
        }
    }
    
    var submitButtonColor: Color{
        return allFields ? .red : .gray
    }
    
    func getFromIPInfo(completion: @escaping (String, String) -> Void){
        AF.request("https://ipinfo.io/json?token=7383037207bcb5").response{
            response in switch response.result{
            case .success(let data):
                let ret = JSON(data as Any)
                let coord = ret["loc"].string
                let loc = coord?.components(separatedBy: ",")
                latitude = loc![0]
                longitude = loc![1]
                completion(latitude,longitude)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getFromGoogle(completion: @escaping (String, String) -> Void){
        let urlLocation = "https://business-search-57191.wl.r.appspot.com/getLocation?location=" + location
        if let urlEnc = urlLocation.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: (urlEnc)){
            AF.request(url).response{
                response in switch response.result{
                case .success(let data):
                    let ret = JSON(data as Any)
                    if(ret.isEmpty){
                        latitude = ""
                        longitude = ""
                    }
                    else{
                        latitude = ret["lat"].stringValue
                        longitude = ret["lng"].stringValue
                    }
                    completion(latitude,longitude)
                    submit()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getAutocomplete(completion: @escaping ([String]) ->Void){
        let urlAutocomplete = "https://business-search-57191.wl.r.appspot.com/autocomplete?text="+key
        if let UrlEnc = urlAutocomplete.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: (UrlEnc)){
            AF.request(url).response{
                response in switch response.result{
                case .success(let data):
                    let ret = JSON(data as Any)
                    print(ret)
                    autoSuggestions = ret.rawValue as? [String] ?? []
                    completion(autoSuggestions)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getDetails(id: String, completion: @escaping (JSON) -> Void){
        let urlDetails = "https://business-search-57191.wl.r.appspot.com/businessDetails?ID=" + id
        if let url = URL(string: (urlDetails)){
            AF.request(url).response{
                response in switch response.result{
                case .success(let data):
                    let ret = JSON(data as Any)
                    completion(ret)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getresults(completion: @escaping (JSON) -> Void){
        let temp = Int(round(distance * 1609.34))
        
        let cat = category=="Default" ? "all" : category
        let rad = temp>40000 ? "40000" : "\(temp)"
        
        let urlSearch = "https://business-search-57191.wl.r.appspot.com/searchTerm?term=\(key)&latitude=\(latitude)&longitude=\(longitude)&categories=\(cat)&radius=\(rad)"
        if let UrlEnc = urlSearch.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: (UrlEnc)){
            AF.request(url).response{
                response in switch response.result{
                case .success(let data):
                    let ret = JSON(data as Any)
                    completion(ret)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
    func submit(){
        
        showProgress = true
        
        if(!latitude.isEmpty && !longitude.isEmpty){
            
            getresults(){
                x in print(x)
                resultsJson = x
                
                if resultsJson.count != 0{
                    for i in 0..<resultsJson.count{
                        if(i == 10){break}
                        businesses.append(Business(num: i+1, id: resultsJson[i]["id"].stringValue, name: resultsJson[i]["name"].stringValue, rating: resultsJson[i]["rating"].doubleValue, distance: resultsJson[i]["distance"].doubleValue, imageURL: resultsJson[i]["image_url"].exists() ? resultsJson[i]["image_url"].stringValue : ""))
                        
                        getDetails(id: resultsJson[i]["id"].stringValue){
                            detailsJSON in print(detailsJSON)
                            
                            var cat:[String] = []
                            var add:[String] = []
                            
                            if detailsJSON["categories"].exists(){
                                for i in 0..<detailsJSON["categories"].count{
                                    cat.append(detailsJSON["categories"][i]["title"].stringValue)
                                }
                            }
                            
                            if detailsJSON["location"]["display_address"].exists(){
                                for i in 0..<detailsJSON["location"]["display_address"].count{
                                    add.append(detailsJSON["location"]["display_address"][i].stringValue)
                                }
                            }
                            
                            savedBusinessDetails[detailsJSON["id"].stringValue] = BusinessDetails(id: detailsJSON["id"].stringValue, name: detailsJSON["name"].stringValue, address: add, categories: cat, phone: detailsJSON["display_phone"].exists() ? detailsJSON["display_phone"].stringValue : "", price: detailsJSON["price"].exists() ? detailsJSON["price"].stringValue : "", status: detailsJSON["hours"][0]["is_open_now"].boolValue, url: detailsJSON["url"].exists() ? detailsJSON["url"].stringValue : "", photos: detailsJSON["photos"].exists() ? detailsJSON["photos"].arrayObject as! [String] : [], coordinates: detailsJSON["coordinates"].exists() ? [detailsJSON["coordinates"]["latitude"].doubleValue, detailsJSON["coordinates"]["longitude"].doubleValue] : [])
                            
                            print(savedBusinessDetails[detailsJSON["id"].stringValue] as Any)
                        }
                    }
                    
                    showProgress = false
                    savedBusiness = businesses
                    showResults = true
                }else{
                    showResults = true
                    noResults = true
                    print("no results")
                }
                
                
            }
            
        }else{
            showProgress = false
            showResults = true
            noResults = true
            print("no results")
        }
        
        
    }
    

    var body: some View {
        NavigationStack{
            List{
                Section{
                    HStack{
                        Text("Keyword: ")
                            .foregroundColor(.gray)
                        TextField("keyword", text: $key, prompt: Text("Required")).onChange(of: key){ x in
                            autoSuggestions = []
                            getAutocomplete(){
                                _ in print(autoSuggestions)
                                showsPopover = true
                            }
                        }
                        .alwaysPopover(isPresented: $showsPopover){
                            VStack(alignment: .leading, spacing: 4) {
                                if(autoSuggestions.isEmpty){
                                    ProgressView("loading...")
                                }
                                else{
                                    ForEach(autoSuggestions, id: \.self){x in
                                        Button(action: {
                                            showsPopover = false
                                            key = x
                                        }, label: {
                                            Label(x,systemImage: "")
                                        }).foregroundColor(.gray)
                                    }
                                }
                            }.padding(10)
                            
                        }
                    }
                    HStack{
                        Text("Distance: ")
                            .foregroundColor(.gray)
                        TextField(value: $distance, format: .number, prompt: Text("")){
                            Text("distance")
                        }
                    }
                    HStack{
                        Text("Category: ")
                            .foregroundColor(.gray)
                        Picker("Categories" , selection: $category){
                            ForEach(categories, id: \.self){
                                Text($0)
                            }
                        }
                        .padding(.horizontal, -15.0)
                        .pickerStyle(.menu)
                        .labelsHidden()
                    }
                    if !autoDetect {
                        HStack{
                            Text("Location: ")
                                .foregroundColor(.gray)
                            TextField("location", text: $location, prompt: Text("Required"))
                                .labelsHidden()
                        }
                    } else {
                        /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
                    }
                    HStack{
                        Text("Auto-detect my location: ")
                            .foregroundColor(.gray)
                        Spacer()
                        Toggle("auto detection",isOn: $autoDetect).onChange(of: autoDetect){ x in
                            if(autoDetect){
                                getFromIPInfo(){
                                    _,_  in print(latitude, longitude)
                                }
                            }
                        }
                        .labelsHidden()
                    }
                    HStack{
                        Spacer()
                        Button(action:{
                            Task{
                                noResults = false
                                showResults = false
                                businesses = []
                                savedBusiness = []
                                savedBusinessDetails = [:]
                                savedReviews = [:]
                                recurresionNum = 0
                                if(autoDetect){
                                    submit()
                                }else{
                                    getFromGoogle(){
                                        _,_ in print(longitude, latitude)
                                    }
                                }
                            }
                        }){
                            Text("Submit")
                                .padding(.all)
                                .padding(.horizontal, 15)
                        }
                        .foregroundColor(.white)
                        .background(submitButtonColor)
                        .cornerRadius(15)
                        .buttonStyle(.borderless)
                        .disabled(!allFields)
                        Spacer()
                        Button(action: {
                            key = ""
                            distance = 10
                            category = "Default"
                            location = ""
                            autoDetect = false
                            autoSuggestions = []
                            latitude = ""
                            longitude = ""
                            showsPopover = false
                            showResults = false
                            resultsJson = []
                            businesses = []
                            savedBusiness = []
                            savedBusinessDetails = [:]
                            savedReviews = [:]
                            noResults = false
                            recurresionNum = 0
                        }){
                            Text("Clear")
                                .padding(.all)
                                .padding(.horizontal, 20)
                        }
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(15)
                        .buttonStyle(.borderless)
                        Spacer()
                    }
                    .padding(.vertical)
                }
                .scrollDismissesKeyboard(.immediately)
                
                Section {
                    Text("Results")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 10.0)
                    if(showProgress){
                        HStack{
                            Spacer()
                            ProgressView("Please wait...")
                            Spacer()
                        }
                    }
                    if showResults {
                        if(noResults){
                            Text("No result available").padding(.vertical).foregroundColor(.red)
                        }
                        else{
                            ForEach(savedBusiness){ i in
                                NavigationLink {
                                    TabViewView(id: i.id, display:true)
                                } label: {
                                    ResultRowView(business: i)
                                }
                            }
                        }
                    }
                }
                .padding(.top, -8.0)
            }.navigationTitle("Business Search")
                .toolbar{
                    ToolbarItemGroup(placement: .primaryAction){
                        NavigationLink{
                            ReservationStorage(display: true)
                        } label:{
                            Image(systemName: "calendar.badge.clock")
                        }
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
