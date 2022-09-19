//
//  Contacts.swift
//  MeshtasticApple
//
//  Created by Garth Vander Houwen on 12/21/21.
//

import SwiftUI

struct Contacts: View {

	@Environment(\.managedObjectContext) var context
	@EnvironmentObject var bleManager: BLEManager
	
	@State var onboarding = true

	@FetchRequest(
		sortDescriptors: [NSSortDescriptor(key: "longName", ascending: true)],
		animation: .default)

	private var users: FetchedResults<UserEntity>

    var body: some View {

		NavigationView {
			
			// Display Contact for Primary Channel
			// Display Contacts for DM's on the Primary Channel
			// Display Contacts for the rest of the non admin channels
			

			List(users) { (user: UserEntity) in
				
				let connectedNodeNum = bleManager.connectedPeripheral != nil ? bleManager.connectedPeripheral.num : 0
				
				if  user.num != connectedNodeNum {
				
					NavigationLink(destination: UserMessageList(user: user)) {
								
						if user.messageList.count > 0 {
						
						let mostRecent = user.messageList.last
						let lastMessageTime = Date(timeIntervalSince1970: TimeInterval(Int64((mostRecent!.messageTimestamp ))))
						let lastMessageDay = Calendar.current.dateComponents([.day], from: lastMessageTime).day ?? 0
						let currentDay = Calendar.current.dateComponents([.day], from: Date()).day ?? 0
							
						HStack {
							
							VStack {

								CircleText(text: user.shortName ?? "???", color: Color.blue)
							}
							.padding([.leading, .trailing])
							
							VStack {
								
								HStack {
							
									VStack {

										Text(user.longName ?? "Unknown").font(.headline).fixedSize()
									}
							
									VStack {

										if lastMessageDay == currentDay {

											Text(lastMessageTime, style: .time )
												.font(.caption)
												.foregroundColor(.gray)

										} else if  lastMessageDay == (currentDay - 1) {

											Text("Yesterday")
												.font(.callout)
												.foregroundColor(.gray)

										} else if  lastMessageDay < (currentDay - 1) && lastMessageDay > (currentDay - 5) {

											Text(lastMessageTime, style: .date)

										} else {

											Text(lastMessageTime, style: .date)
										}
									}
									.frame(maxWidth: .infinity, alignment: .trailing)
								}
								.listRowSeparator(.hidden).frame(height: 5)
								
								HStack(alignment: .top) {
										
										Text(mostRecent!.messagePayload ?? "Empty Message")
											.frame(height: 60)
											.truncationMode(.tail)
											.foregroundColor(Color.gray)
											.frame(maxWidth: .infinity, alignment: .leading)
								}
							}
							.padding(.top)
						}
						
					} else {
						
						HStack {

							VStack {

								CircleText(text: user.shortName ?? "????", color: Color.blue)
							}
							.padding(.trailing)

							VStack {

								HStack {

									VStack {

										Text(user.longName ?? "Unknown").font(.headline).fixedSize()
									}

									VStack {
										Text("               ")
									}
									.frame(maxWidth: .infinity, alignment: .trailing)
								}
								.listRowSeparator(.hidden).frame(height: 5)
							}
						}.padding()
					}
				}
				}
			}
			.navigationTitle("Contacts")
			.navigationBarTitleDisplayMode(.inline)
		}
		.listStyle(PlainListStyle())
    }
}

struct Contacts_Previews: PreviewProvider {
    static var previews: some View {
        Contacts()
    }
}