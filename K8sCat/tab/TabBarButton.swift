//
//  TabBarButton.swift
//  K8sCat
//
//  Created by 顾艳华 on 2022/12/20.
//

import SwiftUI

struct TabBarButton: View {
    let text: String
    @Binding var isSelected: Bool
    var body: some View {
        Text(text)
            .fontWeight(isSelected ? .heavy : .regular)
            .font(.custom("Avenir", size: 16))
            .padding(.bottom, 10)
            .border(width: isSelected ? 2 : 1, edges: [.bottom], color: .black)
    }
}

struct NamespacesTabBar: View {
    @Binding var tabIndex: Int
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                Group {
                    TabBarButton(text: "Pods", isSelected: .constant(tabIndex == 0))
                        .onTapGesture { onButtonTapped(index: 0) }
                    TabBarButton(text: "Deployments", isSelected: .constant(tabIndex == 1))
                        .onTapGesture { onButtonTapped(index: 1) }
                    TabBarButton(text: "Job", isSelected: .constant(tabIndex == 2))
                        .onTapGesture { onButtonTapped(index: 2) }
                    TabBarButton(text: "Cron Job", isSelected: .constant(tabIndex == 3))
                        .onTapGesture { onButtonTapped(index: 3) }
                    TabBarButton(text: "Statefull Sets", isSelected: .constant(tabIndex == 4))
                        .onTapGesture { onButtonTapped(index: 4) }
                    TabBarButton(text: "Service", isSelected: .constant(tabIndex == 5))
                        .onTapGesture { onButtonTapped(index: 5) }
                }
                Group {
                    TabBarButton(text: "Config Map", isSelected: .constant(tabIndex == 6))
                        .onTapGesture { onButtonTapped(index: 6) }
                    TabBarButton(text: "Secrets", isSelected: .constant(tabIndex == 7))
                        .onTapGesture { onButtonTapped(index: 7) }
                    TabBarButton(text: "Daemon Sets", isSelected: .constant(tabIndex == 8))
                        .onTapGesture { onButtonTapped(index: 8) }
                    TabBarButton(text: "Replica Sets", isSelected: .constant(tabIndex == 9))
                        .onTapGesture { onButtonTapped(index: 9) }
                    TabBarButton(text: "‎Horizontal Pod Autoscaler", isSelected: .constant(tabIndex == 10))
                        .onTapGesture { onButtonTapped(index: 10) }
                }
              
            }
        }
        .border(width: 1, edges: [.bottom], color: .black)
    }
    
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}

struct NodesTabBar: View {
    @Binding var tabIndex: Int
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                TabBarButton(text: "Nodes", isSelected: .constant(tabIndex == 0))
                    .onTapGesture { onButtonTapped(index: 0) }
            }
        }
        .border(width: 1, edges: [.bottom], color: .black)
    }
    
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}

struct StorageTabBar: View {
    @Binding var tabIndex: Int
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                TabBarButton(text: "Persistent Volumes", isSelected: .constant(tabIndex == 0))
                    .onTapGesture { onButtonTapped(index: 0) }
                TabBarButton(text: "Persistent Volumes Claim", isSelected: .constant(tabIndex == 1))
                    .onTapGesture { onButtonTapped(index: 1) }
            }
        }
        .border(width: 1, edges: [.bottom], color: .black)
    }
    
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}

struct EdgeBorder: Shape {

    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}
