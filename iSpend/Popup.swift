//
//  Popup.swift
//  iSpend
//
//  Created by Jonas Kaiser on 21.02.23.
//

import SwiftUI

struct Popup: View {
    @Binding var message: String
    @Binding var display: Bool
    
    init(_ message: Binding<String>, display: Binding<Bool>) {
        self._message = message
        self._display = display
    }
    
    @State private var manualStopped = false
    @State private var timerStopped = false
    
    var body: some View {
        GeometryReader { geometry in
            Text(message)
                .padding(10.0)
                .background(
                    RoundedRectangle(cornerRadius: 10.0)
                        .fill(.ultraThinMaterial)
                )
                .position(x: geometry.size.width*0.5, y: display ? 20 : -100)
                .transition(.slide)
                .onChange(of: display) { newValue in
                    if display {
                        Task {
                            try? await Task.sleep(for: .seconds(3.0))
                            
                            if manualStopped {
                                manualStopped = false
                                return
                            }
                            
                            withAnimation(.easeOut(duration: 0.5)) {
                                timerStopped = true
                                display = false
                            }
                        }
                    } else if !timerStopped {
                        manualStopped = true
                    } else {
                        timerStopped = false
                    }
                }
        }
    }
}

struct Popup_PreviewsHelper: View {
    @State var message: String = "Something went wrong!"
    @State var display: Bool = false
    
    var body: some View {
        ZStack {
            Button("Error") {
                withAnimation(.easeOut(duration: 0.5)) {
                    display.toggle()
                }
            }
            Popup($message, display: $display)
        }
    }
}

struct Popup_Previews: PreviewProvider {
    static var previews: some View {
        Popup_PreviewsHelper()
    }
}
