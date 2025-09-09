//
//  ChoosePokemonWidget.swift
//  ChoosePokemonWidget
//
//  Created by HoangDus on 19/07/2025.
//

import WidgetKit
import SwiftUI
import Intents
import CoreData
import ClockHandRotationEffect

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SelactedPokemonEntry {
        SelactedPokemonEntry(date: Date(), gifFrames: [], imageData: Data())
    }

	func getSnapshot(for config: ConfigIntent, in context: Context, completion: @escaping (SelactedPokemonEntry) -> ()) {
        let entry = SelactedPokemonEntry(date: Date(), gifFrames: [], imageData: Data())
        completion(entry)
    }

	func getTimeline(for config: ConfigIntent, in context: Context, completion: @escaping (Timeline<SelactedPokemonEntry>) -> ()) {
        let selectedPokemonGif = config.selectedPokemon?.gifImageURL
        let imageURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.hoangdus.pocketmon"
        )
        var imageData = Data()
        var frames: [UIImage] = []
        
        if(imageURL != nil && selectedPokemonGif != nil){
            print("image name: \(selectedPokemonGif!)")
            do {
                imageData = try Data(contentsOf: imageURL!.appendingPathComponent(selectedPokemonGif!, conformingTo: .url))
                frames = extractGIFFramesToUIImages(from: imageURL!.appendingPathComponent(selectedPokemonGif!, conformingTo: .url))
                print(imageData)
            }catch{
                print("loading image error \(error)")
            }
        }else{
            print("image URL nil")
        }
        print(frames.count)
        let entry = SelactedPokemonEntry(date: Date(), gifFrames: frames, imageData: imageData)
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
    
    func extractGIFFramesToUIImages(from gifURL: URL) -> [UIImage] {
        var frames: [UIImage] = []
        
        guard let imageSource = CGImageSourceCreateWithURL(gifURL as CFURL, nil) else {
            print("Error: Could not create image source from GIF file")
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

struct SelactedPokemonEntry: TimelineEntry {
    let date: Date
    let gifFrames: [UIImage]
	let imageData: Data
}

struct ChoosePokemonWidgetEntryView : View {
    var entry: Provider.Entry
    var imageData: Data {
        entry.imageData
    }
    
    var sliceCount: Int {
        entry.gifFrames.count
    }
    var sliceSize: CGFloat {
        360 / CGFloat(sliceCount)
    }
    
    var body: some View {
        GeometryReader{ geometry in
            let parentWidth = geometry.size.width == 0 ? 0 : geometry.size.width
            let parentHeight = geometry.size.height == 0 ? 0 : geometry.size.height
            ZStack{
                if(sliceCount > 1){
                    ForEach(0..<sliceCount, id: \.self) { i in
                        Image(uiImage: entry.gifFrames[i])
                            .resizable()
                            .frame(width: parentHeight * 0.7,height: parentHeight * 0.7)
                            .mask{
                                GiantWheel(size: sliceSize, index: i)
                            }
                    }
                }else if(sliceCount == 1){
                    Image(uiImage: entry.gifFrames[0])
                        .resizable()
                        .frame(width: parentHeight * 0.7,height: parentHeight * 0.7)
                }else{
                    Image(systemName: "photo")
                        .resizable()
                        .frame(width: parentHeight * 0.7,height: parentHeight * 0.7)
                }
            }.frame(width: parentWidth, height: parentHeight)
        }
    }
}

struct ChoosePokemonWidget: Widget {
    let kind: String = "ChoosePokemonWidget"

    var body: some WidgetConfiguration {
		IntentConfiguration(
			kind: kind,
			intent: ConfigIntent.self,
			provider: Provider()) { entry in
                if #available(iOS 17.0, *){
                    ChoosePokemonWidgetEntryView(entry: entry)
                        .containerBackground(.fill.tertiary, for: .widget)
                }else{
                    ChoosePokemonWidgetEntryView(entry: entry)
                        .padding()
                        .background()
                }
			}
		.supportedFamilies([.systemSmall])
        .configurationDisplayName("Choose a Pokémon")
        .description("Put your favorite Pokémon on the homescreen.")
        .containerBackgroundRemovable(false)
    }
}

//#Preview(as: .systemSmall) {
//    ChoosePokemonWidget()
//} timeline: {
//    SimpleEntry(date: .now, emoji: "😀")
//    SimpleEntry(date: .now, emoji: "🤩")
//}
