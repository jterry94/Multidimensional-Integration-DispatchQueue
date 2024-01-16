//
//  ContentView.swift
//  Multidimensional Integration
//
//  Created by Jeff_Terry on 1/15/24.
//

import SwiftUI

struct ContentView: View {
    // Variables
    @State  var limitsOfIntegrationText: String = "0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n0.0, 1.0\n"
    @State  var integralValue: String = ""
    @State  var numberOfGuesses: String = "32000"
    @State  var numberOfIterations: String = "2048"
    @State  var progress: Double = 0.0
    @State  var selectedFunction: String = "exp(-x)"
    @State  var exactValue: String = ""
    @State  var stdDevValue: String = ""
    @State  var errorValue: String = ""
    @State  var timeValue: String = ""
    
    var functionOptions = ["exp(-x)", "exp(x)", "10DIntegral"]
    
    @State var dimensions = 1.0
    //integral e^-x from 0 to 1
    @State var exact = -exp(-1.0)+exp(0.0)
    @State var functionForIntegration: integrationFunctionHandler = eToTheMinusX
    
    @State var limitsOfIntegration = ([0.0], [1.0])
    @State var integral = 0.0
    @State var iterations = 0.0
    @State var currentIteration = 0.0
    @State var totalGuesses = 0.0
    @State var guesses = 0.0
    @State var error = 0.0
    @State var stdDev = 0.0
    @State var progressPercentage = 0.0
    
    @State var start = DispatchTime.now() //Start time
    @State var stop = DispatchTime.now()  //Stop time
    
    @State var nanotime :UInt64 = 0
    @State var timeInterval : Double = 0.0
    
    @State var calculating = false
    
    
    var body: some View {
        VStack {
            // Button to start calculation
            Button("Integrate") {
                integrateButton()
                startTheIntegration()
            }
            .padding()
            .disabled(calculating == true)
            VStack{
                
                Text("Limits of Integration:")
                // Textfield for limits of integration
                TextEditor(text: $limitsOfIntegrationText).frame(width:80, height:130).padding()
            }
            
            // Progress indicator
            if calculating {
                ProgressView()
                ProgressView("Calculaton:", value: currentIteration, total: iterations)
            } else {
                Text("Idle")
            }
            
            
            // Picker for selecting function
            Picker("Select Function", selection: $selectedFunction) {
                ForEach(functionOptions, id: \.self) {
                    Text($0)
                }
            }
            .onChange(of: selectedFunction, {functionSelector()})
            .pickerStyle(MenuPickerStyle())
            .padding().pickerStyle(MenuPickerStyle())
            .padding()
            
            HStack{
                
            Text("Number of Guesses:")
            // Textfield for number of guesses
            TextField("Number of Guesses", text: $numberOfGuesses)
                .padding()
            
        }
            
            HStack{
                
            Text("Number of Interations:")
                
            // Textfield for number of iterations
            TextField("Number of Iterations", text: $numberOfIterations)
                .padding()
        }
            

            HStack{
                
            Text("Integral Value:")
            // Textfield for integral value
            TextField("Integral Value", text: $integralValue)
                .padding()
            
        }
            
            HStack{
                
            Text("Standard Deviation:")
            // Textfield for std dev value
            TextField("Standard Deviation", text: $stdDevValue)
                .padding()
            
        }
            
            HStack{
                
            Text("Exact Value:")
            // Textfield for exact value
            TextField("Exact Value", text: $exactValue)
                .padding()
            
        }
            
            HStack{
                
            Text("Error:")
            // Textfield for error value
            TextField("Error", text: $errorValue)
                .padding()
            
        }
            
            HStack{
                
            Text("Time:")
            // Textfield for time value
            TextField("Time", text: $timeValue)
                .padding()
            
        }

            
        }
        .padding()
    }
    
    // Functions
    func performIntegration() {
        // Implement your integration logic here
        // Update progress as needed
    }
    
    // Function associated with the integrateButton
    func integrateButton() {
        performIntegration()
        // Update other variables or UI elements as needed
    }
    
    /// startTheIntegration
    /// - Parameter sender: normally integration button in the GUI
    /// starts the multidimensional integration
    func startTheIntegration() {
        
        //Blank the Display
        self.integralValue = ""
        self.exactValue = ""
        self.errorValue = ""
        self.stdDevValue = ""
        self.timeValue = ""
        
        //get limits of Integration
        let integrationLimitString = limitsOfIntegrationText
        limitsOfIntegration = parseString(stringWithParameters: integrationLimitString, separator: ", ")
        
        //test to make sure the number of Dimensions matches the number of Integration Limits
        //matches equals or exceeds.
        
        var safeToCalculate = false
        let numberOfLowerLimits = limitsOfIntegration.0.count
        let numberOfUpperLimits = limitsOfIntegration.1.count
        
        if(numberOfLowerLimits >= Int(dimensions)){
            
            safeToCalculate = true
        }
        
        if ((numberOfUpperLimits >= Int(dimensions) && safeToCalculate)){
            
            safeToCalculate = true
            
            
        }
        else{
            
            safeToCalculate = false
        }
        
        if !safeToCalculate {
            
            
            print("There was an error in the limits of integration.")
            return
        }
        
        
        
        let theIterations = Int(numberOfIterations)
        iterations = Double(theIterations!)
        
        let myGuesses = Int(numberOfGuesses)
        //print (myGuesses)
        
        start = DispatchTime.now() // starting time of the integration
        //progressIndicator.startAnimation(self)
        self.calculating = true
        
        //integrateButton.isEnabled = false
        
        let myQueue = DispatchQueue.init(label: "integrationQueue", qos: .userInitiated, attributes: .concurrent)
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            
            self.integration(iterations: Int32(theIterations!), guesses: Int32(myGuesses!), lowerLimit:self.limitsOfIntegration.0, upperLimit:self.limitsOfIntegration.1, theQueue: myQueue)
            
        }
        
        print("done")
        
    }
    
    /// integration
    /// does the heavily lifting and performs the threaded Monte Carlo Integration
    /// - Parameters:
    ///   - iterations: number of iterations
    ///   - guesses: number of guesses
    ///   - lowerLimit: array of the lower limits of integration should be >= number of dimensions
    ///   - upperLimit: array of the upper limits of integration should be >= number of dimensions
    ///   - theQueue: DispatchQueue in which we will perform the threaded integration. This can be concurrent or synchrous as needed. Testing usally synchronously. Calculations done concurrently.
    func integration(iterations: Int32, guesses: Int32, lowerLimit:[Double], upperLimit:[Double], theQueue: DispatchQueue)  {
        
        var integralArray :[Double] = []
        
        theQueue.async{
            
            DispatchQueue.concurrentPerform(iterations: Int(iterations), execute: { index in
                
                //print("started index \(index)")
                
                DispatchQueue.main.async{
                    
                    self.currentIteration = Double(index)
                }
                
                
                integralArray.append(calculateMonteCarloIntegral(dimensions: Int(self.dimensions), guesses: guesses, lowerLimit: lowerLimit, upperLimit: upperLimit, functionToBeIntegrated: self.functionForIntegration))
                
                
            })
            
        //Calculate the Volume of the Multidimensional Box
            
        let myVolume = BoundingBox()
        
        myVolume.initWithDimensionsAndRanges(dimensions: Int(self.dimensions), lowerBound: lowerLimit, upperBound: upperLimit)
        
        
        let volume = myVolume.volume
        
        let integralValue = integralArray.map{$0 * (volume / Double(guesses))}
        
        //print(integralValue)
        
        let myIntegral = integralValue.mean
            let myStdDev = integralValue.stdev
        
        print("integral is \(myIntegral) exact is \(self.exact)")
            
            
        self.integral = myIntegral
        self.stdDev = myStdDev ?? 0.0
            self.error = exact - myIntegral
        
        DispatchQueue.main.async{
            
            self.integralValue = myIntegral.formatted(.number.precision(.fractionLength(7)))
            
            self.exactValue = self.exact.formatted(.number.precision(.fractionLength(7)))
            self.stdDevValue = self.stdDev.formatted(.number.precision(.fractionLength(7)))
            
            self.errorValue = self.error.formatted(.number.precision(.fractionLength(7)))
            
        self.stop = DispatchTime.now()    //end time
            
            self.calculating = false
            
           // self.progressIndicator.stopAnimation(self)
           // self.integrateButton.isEnabled = true
            
            self.nanotime = self.stop.uptimeNanoseconds - self.start.uptimeNanoseconds //difference in nanoseconds from the start of the calculation until the end.
            
            self.timeInterval = Double(self.nanotime) / 1_000_000_000
            self.timeValue = timeInterval.formatted(.number.precision(.fractionLength(7)))
            
            
        
            
            
        }
            
        
        
        
        }
         
        
    }
    
    func functionSelector() {
        
        switch selectedFunction {
            
        case "exp(x)":
            dimensions = 1
            exact = exp(1.0) - exp(0.0)
            functionForIntegration = eToTheX
            
        case "10DIntegral":
            dimensions = 10
            exact = 155.0/6.0
            functionForIntegration = tenDIntegral
            
        case "exp(-x)":
            dimensions = 1
            exact = -exp(-1.0) + exp(0.0)
            functionForIntegration = eToTheMinusX
            
        default:
            
            dimensions = 1
            exact = -exp(-1.0) + exp(0.0)
            functionForIntegration = eToTheMinusX
            
            
            
        }
        
        
        
    }
}


#Preview {
    ContentView()
}

