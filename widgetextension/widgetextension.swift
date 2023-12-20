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
    
    let data = DataService()
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), streak: data.progress())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), streak: data.progress())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, streak: data.progress())
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
//data
struct SimpleEntry: TimelineEntry {
    let date: Date
    let streak: Int
}

struct widgetextensionEntryView : View {
    var entry: Provider.Entry
    
    let data = DataService()
    //UI
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: 20)
            //change the progress
            let pct = Double(data.progress())/50.0
            Circle()
                .trim(from: 0, to: pct)
                .stroke(.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(-90))
            
            VStack{
                Text(String(data.progress())).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .bold()
            }.foregroundStyle(.white)
                .fontDesign(.rounded)
            
        }.padding()
        .containerBackground(.black, for: .widget)
        
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
                    .containerBackground(.black, for: .widget)
            } else {
                widgetextensionEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        
        // added
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemSmall) {
    widgetextension()
} timeline: {
    SimpleEntry(date: .now, streak: 1)
    SimpleEntry(date: .now, streak: 4)
}
