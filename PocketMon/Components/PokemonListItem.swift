//
//  PokemonListItem.swift
//  PocketMon
//
//  Created by HoangDus on 01/09/2024.
//

import SwiftUI
import CoreData

struct PokemonListItem: View {
    var pokémon: PokemonEntity?
	var context: NSManagedObjectContext
	var action: () -> Void
    @State private var isFaved = false
    
	let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
	
    var body: some View {
        VStack(){
            if pokémon != nil {
                HStack{
                    ForEach(pokémon!.combinedSpriteLinks, id: \.self){ value in
                        Color.clear.overlay{
                            AsyncImage(url: URL(string: "\(documentsPath)\(value)"), content: { image in
                                image.resizable()
                            }, placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.black)
                            }).frame(width: 80, height: 80)
                        }
                    }
                }.frame(maxWidth: .infinity)
                HStack{
                    VStack(alignment: .leading, spacing: 5){
						CustomLabelTextView(value: pokémon!.captitalizedName, fontSize: 30, color: .white)
						CustomLabelTextView(value: "Type(s): \(pokémon!.combinedTypeNames)", fontSize: 18, color: .white)
						CustomLabelTextView(value: "Weight: \((pokémon!.weight) / 10)kg", fontSize: 18, color: .white)
                        CustomLabelTextView(value: "Height: \((Double(pokémon!.height)) / 10.0)m", fontSize: 18, color: .white)
                    }
//                    .frame(maxHeight: .infinity)
                    Spacer()
                    Image(systemName: isFaved ? "heart.fill" : "heart")
                        .font(.system(size: 40))
                        .foregroundColor(isFaved ? .pink : .black)
                        .alignmentGuide(VerticalAlignment.center, computeValue: { d in -10})
                        .onTapGesture {
							if(isFaved){
								action()
								isFaved.toggle()
							}else{
								isFaved.toggle()
							}
                        }
//                    .alignmentGuide(HorizontalAlignment.trailing, computeValue: { d in d[HorizontalAlignment.trailing]})
                }
           
            }else{
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
//        .fixedSize(horizontal: false, vertical: true)
        .padding(20)
        .background(Color(uiColor: .gray).opacity(0.6))
        .cornerRadius(20)
		.onTapGesture {
			print(pokémon ?? "no pokemon data")
		}
		.onAppear(){
			if(pokémon != nil){
				isFaved = LocalPokemonRepository(context: self.context).entityExistsByID(with: Int(pokémon!.id))
			}
		}
    }
    
    func CustomLabelTextView(value: String, fontSize: CGFloat, color: UIColor) -> some View{
        Text(value).font(.system(size: fontSize)).foregroundColor(Color(uiColor: color))
    }
    
    
}
