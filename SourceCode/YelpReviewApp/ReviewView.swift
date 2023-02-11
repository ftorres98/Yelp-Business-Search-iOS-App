//
//  ReviewView.swift
//  YelpReviewApp
//
//  Created by Fernando Torres on 12/8/22.
//

import SwiftUI
import Alamofire
import SwiftyJSON

//taken from https://stackoverflow.com/questions/63090325/how-to-execute-non-view-code-inside-a-swiftui-view
struct ExecuteCode : View {
    init( _ codeToExec: () -> () ) {
        codeToExec()
    }
    
    var body: some View {
        return EmptyView()
    }
}

struct ReviewView: View {
    let id: String
    let willGetReviews : Bool
    
    @State var displayReviews = false
    
    func getReviews(completion: @escaping (JSON) -> Void){
        let urlReviews = "https://business-search-57191.wl.r.appspot.com/getReviews?ID=" + id
        if let url = URL(string: (urlReviews)){
            AF.request(url).response{
                response in switch response.result{
                case .success(let data):
                    let ret = JSON(data as Any)
                    var tempArr : [Reviews] = []
                    for i in 0..<ret.count{
                        tempArr.append(Reviews(id: ret[i]["id"].stringValue, name: ret[i]["user"]["name"].stringValue, rate: ret[i]["rating"].doubleValue, date: ret[i]["time_created"].stringValue, reviewText: ret[i]["text"].stringValue))
                    }
                    savedReviews[id] = tempArr
                    displayReviews = true
                    completion(ret)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    var body: some View {
        
        if(willGetReviews){
            ExecuteCode{
                print("Test")
                getReviews(){
                    results in print(results)
                }
            }
        }
        
        if(displayReviews){
            List(savedReviews[id]!){
                item in
                VStack{
                    HStack{
                        Text(item.name).font(.headline)
                        Spacer()
                        Text("\(Int(item.rate))/5").font(.headline)
                    }
                    HStack{
                        Spacer()
                        Text(item.reviewText).foregroundColor(.gray)
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        Text(item.date.split(separator: " ")[0])
                        Spacer()
                    }
                }
            }
        }else{
            ProgressView("Please wait...")
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(id: "", willGetReviews: false)
    }
}
