//
//  SwiftUIView.swift
//  Zcode
//
//  Created by samara on 1/25/24.
//

import SwiftUI

struct AboutView: View {
    var info = Bundle.main.infoDictionary!
    
    var body: some View {
        HStack {
            if let appIcon = getAppIcon() {
                Image(nsImage: appIcon)
                    .resizable()
                    .interpolation(.high)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 130, height: 130)
                    .padding(EdgeInsets(top: -23, leading: 18, bottom: 0, trailing: 25))
            }
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text((info["CFBundleName"] as? String) ?? "")
                        .font(Font.system(size: 38))
                    
                    Text("Version \(info["CFBundleShortVersionString"] as? String ?? "0.0")")
                        .font(.system(size: 14))
                        .opacity(0.5)
                        .padding(EdgeInsets(top: -25, leading: 0, bottom: 0, trailing: 0))
                }
                .padding(EdgeInsets(top: -23, leading: 0, bottom: 0, trailing: 0))

                Spacer()
                
                Text((info["NSHumanReadableCopyright"] as? String) ?? "")
                    .font(.system(size: 9.5))
                    .opacity(0.5)
                
                Spacer()
                Divider()
                                
                HStack {
                    customButton(action: showWebsite, label: "Source")
                }
                
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .frame(maxWidth: .infinity)
        }
        .frame(minWidth: 500, minHeight: 160)
        .padding()

    }
    
    func getAppIcon() -> NSImage? {
        if let iconPath = Bundle.main.path(forResource: "AppIcon", ofType: "icns"),
           let iconImage = NSImage(contentsOfFile: iconPath) {
            return iconImage
        }
        return nil
    }
    
    func customButton(action: @escaping () -> Void, label: String) -> some View {
        Button(action: action) {
            Text(label)
                .frame(maxWidth: .infinity)
        }
    }
    
    func showWebsite() {
        let website = URL(string: "https://github.com/ssalggnikool/Zcode")!
        NSWorkspace.shared.open(website)
    }
}
