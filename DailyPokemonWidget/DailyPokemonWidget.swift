//
//  DailyPokemonWidget.swift
//  DailyPokemonWidget
//
//  Created by HoangDus on 19/07/2025.
//

import WidgetKit
import SwiftUI
import ClockHandRotationEffect

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> DailyPokemonEntry {
        DailyPokemonEntry(date: Date(), pokémon: nil, imageFrames: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (DailyPokemonEntry) -> ()) {
        let entry = DailyPokemonEntry(date: Date(), pokémon: nil, imageFrames: [])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [DailyPokemonEntry] = []
        
        getDailyPokemon(){ imageData, pokemon, error in
            let entryDate = Date()
            let entry = DailyPokemonEntry(date: entryDate, pokémon: pokemon, imageFrames: extractGIFFramesToUIImagesFromData(from: imageData!))
            entries.append(entry)

            let timeline = Timeline(entries: entries, policy: .after(Date().addingTimeInterval(36 * 60)))
            completion(timeline)
        }
        
        func extractGIFFramesToUIImagesFromData(from imageData: Data) -> [UIImage] {
            var frames: [UIImage] = []
            
            guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil) else {
                print("Error: Could not create image source from imput Data")
                return frames
            }
            
            let frameCount = CGImageSourceGetCount(imageSource)
            
            for i in 0..<frameCount {
                guard let cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil) else {
                    print("Error: Could not create image for frame \(i)")
                    continue
                }
                
                let uiImage = UIImage(cgImage: cgImage)
                frames.append(uiImage)
            }
            
            return frames
        }
    }
}

struct DailyPokemonEntry: TimelineEntry {
    let date: Date
    let pokémon: Pokémon?
    let imageFrames: [UIImage]
}

struct DailyPokemonWidgetEntryView : View {
    var entry: Provider.Entry

    var sliceCount: Int {
        entry.imageFrames.count
    }
    var sliceSize: CGFloat {
        360 / CGFloat(sliceCount)
    }
    
    var body: some View {
        GeometryReader(){ geometry in
            let backgroundColor = Color.gray
            let parentWidth = geometry.size.width == 0 ? 0 : geometry.size.width
            let parentHeight = geometry.size.height == 0 ? 0 : geometry.size.height
            let infoViewWidth = parentWidth - parentHeight - 5 < 0 ? 0 : parentWidth - parentHeight - 5
            
            HStack(spacing: 0) {
                ZStack{
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: parentHeight,height: parentHeight)
                        .background(ContainerRelativeShape().fill(backgroundColor))
                        .opacity(0.5)
                    if(sliceCount > 1){
                        ForEach(0..<sliceCount, id: \.self) { i in
                            Image(uiImage: entry.imageFrames[i])
                                .resizable()
                                .frame(width: parentHeight * 0.7,height: parentHeight * 0.7)
                                .mask{
                                    GiantWheel(size: sliceSize, index: i)
                                }
                        }
                    }else if(sliceCount == 1){
                        Image(uiImage: entry.imageFrames[0])
                            .resizable()
                            .frame(width: parentHeight * 0.7,height: parentHeight * 0.7)
                    }else{
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: parentHeight * 0.7,height: parentHeight * 0.7)
                    }
                }
                Spacer()
                    .frame(width: 5)
                ZStack(alignment: .leading){
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: infoViewWidth,height: geometry.size.height)
                        .background(ContainerRelativeShape().fill(backgroundColor))
                        .opacity(0.5)
                    VStack(alignment: .leading, spacing: 6){
//                        Spacer()
                        Text("Name: \(entry.pokémon?.name.capitalized ?? "No data")")
                            .font(.system(size: 16))
                        Text("Type(s): \(entry.pokémon?.combinedTypeNames ?? "No data")")
                            .font(.system(size: 14))
//                        Spacer()
                    }.padding(5)
                }
            }
        }.padding(5)
    }
}

struct DailyPokemonWidget: Widget {
    let kind: String = "DailyPokemonWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                DailyPokemonWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                DailyPokemonWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .contentMarginsDisabled()
		.supportedFamilies([.systemMedium])
        .configurationDisplayName("Pokémon of the day")
        .description("Show a new pokémon everyday.")
    }
}

//#Preview(as: .systemSmall) {
//    DailyPokemonWidget()
//} timeline: {
//    SimpleEntry(date: .now, emoji: "😀")
//    SimpleEntry(date: .now, emoji: "🤩")
//}
