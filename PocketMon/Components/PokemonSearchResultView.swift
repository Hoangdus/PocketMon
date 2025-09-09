//
//  PokemonSearchResultView.swift
//  PocketMon
//
//  Created by HoangDus on 15/06/2025.
//

import SwiftUI
import CoreData

struct PokemonSearchResultView: View {
	var pokémon: Pokémon?
	@State private var isFaved = false
	@Environment(\.managedObjectContext) private var moc: NSManagedObjectContext
	private var localPokemonRepository: LocalPokemonRepository {
		return LocalPokemonRepository(context: moc)
	}
	
    @State private var degree: Double = 0
    
	var body: some View {
		VStack(){
			if pokémon != nil {
				HStack{
					ForEach(pokémon!.combinedSpriteLinks, id: \.self){ value in
						Color.clear.overlay{
							AsyncImage(url: URL(string: value), content: { image in
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
//					.frame(maxHeight: .infinity)
					Spacer()
					Image(systemName: isFaved ? "heart.fill" : "heart")
						.font(.system(size: 40))
						.foregroundColor(isFaved ? .pink : .black)
						.alignmentGuide(VerticalAlignment.center, computeValue: { d in -10})
						.onTapGesture {
							isFaved.toggle()
							if(isFaved){
								localPokemonRepository.favoriteAPokemon(newFavPokemon: self.pokémon!)
							}else{
								localPokemonRepository.unFavoriteAPokemon(pokemonID: Int32(pokémon!.id))
							}

						}
//						.alignmentGuide(HorizontalAlignment.trailing, computeValue: { d in d[HorizontalAlignment.trailing]})
				}
			}else{
				Image("PokeBallIcon")
                    .resizable()
                    .frame(width: 64, height: 64)
                    .rotationEffect(Angle(degrees: degree))
                    .onAppear(){
                        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)){
                            degree = 360
                        }
                    }
			}
		}
		.frame(maxWidth: .infinity)
		.frame(height: 200)
//		.fixedSize(horizontal: false, vertical: true)
		.padding(20)
		.background(Color(uiColor: .gray).opacity(0.6))
		.cornerRadius(20)
		.onChange(of: self.pokémon){ pokemon in
			if(pokemon != nil){
				isFaved = localPokemonRepository.entityExistsByID(with: pokemon!.id)
			}
		}
		.onAppear(){
			if(pokémon != nil){
				isFaved = localPokemonRepository.entityExistsByID(with: pokémon!.id)
			}
		}
	}
	
	func CustomLabelTextView(value: String, fontSize: CGFloat, color: UIColor) -> some View{
		Text(value).font(.system(size: fontSize)).foregroundColor(Color(uiColor: color))
	}
	
	
}


//#Preview {
//    PokemonSearchResultView()
//}
