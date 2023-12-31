//
//  widgetextension.swift
//  widgetextension
//
//  Created by Lujain Abdullah Halabi Almeri on 05/06/1445 AH.
//

import WidgetKit
import SwiftUI

/* supplies the data
 
 */
struct Provider: TimelineProvider {
    //create a snapshot with data
    
    @AppStorage(
        "breakfast",
        store: UserDefaults(
            suiteName: "group.a.NC2"
        )
    ) private var breakfast = ""
    
    @AppStorage(
        "lunch",
        store: UserDefaults(
            suiteName: "group.a.NC2"
        )
    ) private var lunch = ""
    
    @AppStorage(
        "dinner",
        store: UserDefaults(
            suiteName: "group.a.NC2"
        )
    ) private var dinner = ""
    
    @AppStorage(
        "snack",
        store: UserDefaults(
            suiteName: "group.a.NC2"
        )
    ) private var snack = ""
    
    let data = DataService()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), breakfast: breakfast, lunch: lunch, dinner: dinner, snack: snack)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), breakfast: breakfast, lunch: lunch, dinner: dinner, snack: snack)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            
            //MARK: HERE
            let breakfast = breakfast
            let lunch = lunch
            let dinner = dinner
            let snack = snack
            
            let entry = SimpleEntry(date: entryDate, breakfast: breakfast, lunch: lunch, dinner: dinner, snack: snack)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
//data
struct SimpleEntry: TimelineEntry {
    let date: Date
    let breakfast: String
    let lunch: String
    let dinner: String
    let snack: String
}

struct widgetextensionEntryView : View {
    var entry: Provider.Entry
    
    var date: Date {
         return Date()
     }

     var dayName: String {
         let calendar = Calendar.current
         let dayOfWeek = calendar.component(.weekday, from: date)
         return calendar.weekdaySymbols[dayOfWeek - 1]
     }
    
    let data = DataService()
    
    //UI
    var body: some View {
        ZStack {
           Color("wColor")
            HStack{
                VStack(alignment: .leading){
                    HStack {
                        Text("Breackfast:").font(.system(size: 17))
                            .foregroundColor(Color("gColor")).fontWeight(.semibold)
                        
                        Text(data.getBreakfast()).frame(width: 150, alignment: .leading).font(.system(size: 15))
                            .foregroundColor(Color("bColor"))
                    }.padding(.bottom, 5)
                    HStack {
                        Text("Lunch:").font(.system(size: 17))
                            .foregroundColor(Color("gColor")).fontWeight(.semibold)
                        
                        Text(data.getLunch()).frame(width: 150, alignment: .leading)
                            .font(.system(size: 15))
                            .foregroundColor(Color("bColor"))
                    }.padding(.bottom, 5)
                    HStack {
                        Text("Dinner:").font(.system(size: 17))
                            .foregroundColor(Color("gColor")).fontWeight(.semibold)
                        
                        Text(data.getDinner()).frame(width: 150, alignment: .leading)
                            .font(.system(size: 15))
                            .foregroundColor(Color("bColor"))
                    }.padding(.bottom, 0)
                        
                    Divider().frame(width: 130, height: 0.3)
                        .overlay(Color("bColor")).padding(.bottom, 5).padding(.leading, 0)

                    HStack {
                        Text(NSLocalizedString("Snacks:", bundle: .main, comment: "")).font(.system(size: 17))
                            .foregroundColor(Color("gColor")).fontWeight(.semibold)
                        
                        Text(data.getSnack()).frame(width: 150, alignment: .leading)
                            .font(.system(size: 15))
                            .foregroundColor(Color("bColor"))
                    }
                }
            }.padding(.top, 3).padding(.leading, -25)
                .containerBackground(Color("lColor"), for: .widget)
                .ignoresSafeArea()
            
            Image("bg").resizable().frame(width: 220, height: 230, alignment: .leading).opacity(0.2).padding(.leading, 280).padding(.top, 30)
        }
    }
}

//actual widget
struct widgetextension: Widget {
    //widget id
    let kind: String = "widgetextension"
    
    var body: some WidgetConfiguration {
        //type of widget - pass id to deal with the widget, provider: supplier of widget data, after provider: actual view
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                widgetextensionEntryView(entry: entry)// background color
                    .containerBackground(Color("lColor"), for: .widget)
            } else {
                widgetextensionEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName(String(NSLocalizedString("Mealanner widget", bundle: .main, comment: "")))
        .description(String(NSLocalizedString("Where meals planning is just a click away!", bundle: .main, comment: "")))
        
        // added
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    widgetextension()
} timeline: {
    SimpleEntry(date: .now, breakfast: "", lunch: "", dinner: "", snack: "")
    SimpleEntry(date: .now, breakfast: "", lunch: "", dinner: "", snack: "")
}
