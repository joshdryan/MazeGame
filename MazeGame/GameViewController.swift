//
//  GameViewController.swift
//  MazeGame
//
//  Created by Daniel Lambert, Josh Ryan, Leo Stelmaszek on 2/26/18.
//  Copyright © 2018 Bootleg Mobile. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit

class GameViewController: UIViewController{
    
    
    var sceneView: SCNView!
    var camera = SCNNode()
    var cameraOrbit = SCNNode()
    var ground = SCNNode()
    var light = SCNNode()
    var constraint = SCNLookAtConstraint()
    let sW = UIScreen.main.bounds.width
    let sH = UIScreen.main.bounds.height
    
    //objects to be added to scene
    var lookAtNode = SCNNode()
    var wall: [SCNNode] = []
    let materialGreen = SCNMaterial()               //set green material
    let materialRed = SCNMaterial()                 //set red material
    let materialBlue = SCNMaterial()                //set blue material
    let materialPurple = SCNMaterial()              //set purple material
    let materialCyan = SCNMaterial()                //set cyan material
    
    
    let testMazeB = [10,6,
                    1,1,1,1,1,1,1,1,1,6,
                    1,0,1,0,0,0,1,0,1,6,
                    1,0,1,0,1,0,1,0,1,6,
                    1,0,0,0,1,0,0,0,1,6,
                    1,1,1,1,1,1,1,1,1,9,]
    
    /*let testMaze = [[1,1,1,1,1,1,1,1,1,1],
                    [1,0,0,0,0,0,0,0,0,1],
                    [1,0,0,0,0,0,0,0,0,1],
                    [1,0,0,0,0,0,0,0,0,1],
                    [1,0,0,0,0,0,0,0,0,1],
                    [1,1,1,1,1,1,1,1,1,1]]*/
    
    var testMaze = [[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                    [1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1],
                    [1,0,1,1,1,1,1,1,0,1,0,1,0,1,0,1],
                    [1,0,1,0,0,0,1,0,0,1,0,0,0,1,0,1],
                    [1,0,1,0,1,0,1,0,1,1,1,1,1,1,0,1],
                    [1,0,0,0,1,0,1,0,0,0,0,0,0,1,0,1],
                    [1,1,1,1,1,0,1,1,1,1,1,1,0,1,0,1],
                    [0,0,1,0,0,0,0,0,0,0,1,0,0,1,0,1],
                    [1,0,1,1,1,1,1,1,1,0,1,0,0,0,0,1],
                    [1,0,1,0,0,0,0,0,1,0,1,0,1,1,0,1],
                    [1,0,1,0,1,1,1,0,1,0,1,0,1,1,0,1],
                    [1,0,0,0,1,0,1,0,1,1,1,0,1,1,0,1],
                    [1,1,1,1,1,0,1,0,1,1,1,0,1,1,0,1],
                    [1,0,0,0,0,0,1,0,0,0,1,0,0,1,0,1],
                    [1,0,1,1,1,1,1,1,1,0,1,1,0,1,0,1],
                    [1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0],
                    [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]]
    
    //         8x8 array with walls
//    var testMaze = [[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
//                     [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
//                     [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
//                     [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
//                     [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
//                     [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
//                     [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
//                     [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
//                     [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
//                     [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
//                     [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
//                     [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
//                     [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
//                     [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
//                     [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
//                     [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
//                     [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]]
    
    var gameView: SCNView!
    var gameScene: SCNScene!
    var camaraNode: SCNNode!
    var targetCreationTime: TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initMaterial()
        initElements()
//      generateMaze()
        loadMaze()
        //move()

        //Restart Button
        let RestartButton = UIButton()
        RestartButton.setTitle("Restart", for: .normal)
        RestartButton.setTitleColor(UIColor.black, for: .normal)
        RestartButton.frame = CGRect(origin: CGPoint(x: 0,y :15), size: CGSize(width: 100, height: 30))
        RestartButton.addTarget(self, action:#selector(restart), for: .touchUpInside)
        self.view.addSubview(RestartButton)
        
        //Left Button
        let LeftButton = UIButton()
        LeftButton.setTitle("<", for: .normal)
        LeftButton.setTitleColor(UIColor.white, for: .normal)
        LeftButton.frame = CGRect(origin: CGPoint(x: sW*(1/8)-25,y :sH-100), size: CGSize(width: 50, height: 50))
        LeftButton.transform = CGAffineTransform(scaleX: 3,y: 3);
        LeftButton.addTarget(self, action:#selector(leftButton), for: .touchUpInside)
        self.view.addSubview(LeftButton)
        
        //Right Button
        let RightButton = UIButton()
        RightButton.setTitle(">", for: .normal)
        RightButton.setTitleColor(UIColor.white, for: .normal)
        RightButton.frame = CGRect(origin: CGPoint(x: sW*(7/8)-25,y :sH-100), size: CGSize(width: 50, height:50))
        RightButton.transform = CGAffineTransform(scaleX: 3,y: 3);
        RightButton.addTarget(self, action:#selector(rightButton), for: .touchUpInside)
        self.view.addSubview(RightButton)
        
        //Forward Button
        let ForwardButton = UIButton()
        ForwardButton.setTitle("^", for: .normal)
        ForwardButton.setTitleColor(UIColor.white, for: .normal)
        ForwardButton.frame = CGRect(origin: CGPoint(x: sW*(1/2)-25,y :sH-100), size: CGSize(width: 50, height: 50))
        ForwardButton.transform = CGAffineTransform(scaleX: 4,y: 4);
        ForwardButton.addTarget(self, action:#selector(forwardButton), for: .touchUpInside)
        self.view.addSubview(ForwardButton)
    }
    
    @objc func restart(){
        print("Restart Pressed")
    }
    
    @objc func leftButton(){
        print("Left Pressed")
    }
    
    @objc func rightButton(){
        print("Right Pressed")
    }
    
    @objc func forwardButton(){
        print("Forward Pressed")
    }
    
    //is not working yet
    @IBAction func tapToMove(_ sender: UITapGestureRecognizer) {
        move()
    }
    
    func move() {
        print("moving")
        //lookAtNode.position = SCNVector3(x: 100, y: 0, z: 100)
        //constraint = SCNLookAtConstraint(target: lookAtNode)
        self.camera.position = SCNVector3(x: (self.camera.position.x + 5), y: 2.5, z: (self.camera.position.x + 5))
        //print(SCNVector3(x: (self.camera.position.x + 5), y: 2.5, z: (self.camera.position.x + 5)))
        
        //lookAtNode.position = SCNVector3(x: lookAtNode.position.x + 5, y: 2.5, z: 0)
    }
    
    func initView() {
        sceneView = SCNView(frame: self.view.frame)
        sceneView.antialiasingMode = .multisampling2X
        sceneView.scene = SCNScene()
        self.view.addSubview(sceneView)
        
        let groundGeometry = SCNFloor()
        groundGeometry.reflectivity = 0
        let groundMaterial = SCNMaterial()
        groundMaterial.diffuse.contents = UIColor.white
        groundGeometry.materials = [groundMaterial]
        ground = SCNNode(geometry: groundGeometry)
        
        //finding center of maze
        let lookAtX = (Float(testMaze[0].count / 2)) * 5
        let lookAtZ = (Float(testMaze.count / 2)) * 5
        
        lookAtNode.position = SCNVector3(x: 23.5, y: 0, z: 5)
        
        let camera = SCNCamera()

        camera.zFar = 10000
        self.camera = SCNNode()
        self.camera.camera = camera
        constraint = SCNLookAtConstraint(target: lookAtNode)
        constraint.isGimbalLockEnabled = true
       
        self.camera.constraints = [constraint]
        
        //print(self.camera.pivot)
        //self.camera.pivot = SCNMatrix4MakeTranslation(lookAtX, 0.0,lookAtZ)
        //print(self.camera.worldTransform)
        //self.camera.position = SCNVector3(x: 7.5, y: 5, z: 7.5)
        self.camera.position = SCNVector3(x: 0, y: 40, z: 0)
        //self.camera.position = SCNVector3(x: lookAtX, y: 10, z: lookAtZ) //temp
//        cameraOrbit = SCNNode()
        cameraOrbit.addChildNode(self.camera)
//        lookAtNode.addChildNode(cameraOrbit)
        
        //self.camera.transform();
        
//        pitch
//        cameraOrbit.eulerAngles.x = Float(0)
//        yaw
//        cameraOrbit.eulerAngles.y = Float(M_PI_4*3)
//        roll
//        cameraOrbit.eulerAngles.y = Float(1000)
        
        let ambientLight = SCNLight()
        ambientLight.color = UIColor.darkGray
        ambientLight.type = SCNLight.LightType.ambient
        self.camera.light = ambientLight/**/
        
        
        let spotLight = SCNLight()
        spotLight.type = SCNLight.LightType.spot
        spotLight.castsShadow = true
        spotLight.spotInnerAngle = 80.0
        spotLight.spotOuterAngle = 90.0
        spotLight.zFar = 500
        light = SCNNode()
        light.light = spotLight
        light.position = SCNVector3(x: -25, y: 15, z: -25)
//        light.position = SCNVector3(x: lookAtX, y: 100, z: lookAtZ)
        light.constraints = [constraint]
    }
    
    func initMaterial() {
        //loading materials with correct color
        materialGreen.diffuse.contents = UIColor.green
        materialRed.diffuse.contents = UIColor.red
        materialBlue.diffuse.contents = UIColor.blue
        materialPurple.diffuse.contents = UIColor.purple
        materialCyan.diffuse.contents = UIColor.cyan
    }
    
    func initElements() {
        sceneView.allowsCameraControl = true
        sceneView.scene?.rootNode.addChildNode(cameraOrbit)
        
//        sceneView.scene?.lookAtNode.addChildNode(cameraOrbit)
        sceneView.scene?.rootNode.addChildNode(ground)
        sceneView.scene?.rootNode.addChildNode(light)
    }
    
    func generateMaze() {
        
//        https://en.wikipedia.org/wiki/Maze_generation_algorithm
        
        ////         8x8 array with walls
        //        var testArray = [[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
        //                        [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
        //                        [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
        //                        [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
        //                        [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
        //                        [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
        //                        [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
        //                        [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
        //                        [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
        //                        [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
        //                        [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
        //                        [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
        //                        [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
        //                        [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
        //                        [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
        //                        [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
        //                        [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]]
        
        
        //        8x8 array
        var Array1 = [0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0]
        
        let mazeSize = Array1.count - 1
        
        var currentPos = 0
        var newPos = 0
        
        //        random starting position, change int to UInt32 for compatibility
        let startingPos = Int(arc4random_uniform(UInt32(mazeSize)))
        print(startingPos)
        
        currentPos = startingPos
        
        Array1[startingPos] = 1
        
        print(Array1)
        while Array1.contains(0) {
            var neighbors = [Int]()
            var neighborPos = 0
            
            //            Test for neighbors
            
            //            Left neighbor
            neighborPos = currentPos % 8
            if (neighborPos - 1) >= 0{
                neighborPos = currentPos-1
                if Array1[neighborPos] == 0 {
                    neighbors.append(neighborPos)
                }
                else {
                    let visitChance = Int(arc4random_uniform(UInt32(100)))
                    if visitChance < 50 {
                        neighbors.append(neighborPos)
                    }
                }
                
            }
            
            //            Right neighbor
            neighborPos = currentPos % 8
            if (neighborPos + 1) != 8{
                neighborPos = currentPos+1
                if Array1[neighborPos] == 0 {
                    neighbors.append(neighborPos)
                }
                else {
                    let visitChance = Int(arc4random_uniform(UInt32(100)))
                    if visitChance < 50 {
                        neighbors.append(neighborPos)
                    }
                }
            }
            
            //            Top neighbor
            neighborPos = currentPos-8
            if neighborPos >= 0{
                if Array1[neighborPos] == 0 {
                    neighbors.append(neighborPos)
                }
                else {
                    let visitChance = Int(arc4random_uniform(UInt32(100)))
                    if visitChance < 50 {
                        neighbors.append(neighborPos)
                    }
                }
            }
            
            //            Bottom neighbor
            neighborPos = currentPos+8
            if neighborPos <= 63{
                if Array1[neighborPos] == 0 {
                    neighbors.append(neighborPos)
                }
                else {
                    let visitChance = Int(arc4random_uniform(UInt32(100)))
                    if visitChance < 50 {
                        neighbors.append(neighborPos)
                    }
                }
            }
            
            
            if neighbors.count > 0 {
                let randNeighbor = Int(arc4random_uniform(UInt32(neighbors.count-1)))
                
                Array1[neighbors[randNeighbor]] = 1
                newPos = neighbors[randNeighbor]
                
            }
            else {
                
                newPos = 0
                
                while newPos == 0 {
                    let tempPos = Int(arc4random_uniform(UInt32(mazeSize)))
                    if Array1[tempPos] == 0 {
                        newPos = tempPos
                        Array1[newPos] = 1
                        currentPos = newPos
                    }
                }
            }
            
            
            if abs(currentPos-newPos) == 1 {
                var col = currentPos % 8
                var row = ((currentPos-col) / 8) + 1
                
                col = (((col+1)*2) - 1) + (newPos-currentPos)
                row = (row*2) - 1
                
                //print("Right/Left")
                
                //print(testMaze)
                //print(row, col)
                
                testMaze[row][col] = 0
                //print(testMaze)
            }
            else if abs(currentPos-newPos) == 8{
                var col = currentPos % 8
                var row = ((currentPos-col) / 8) + 1
                
                let newCol = newPos % 8
                let newRow = ((newPos-newCol)/8) + 1
                
                col = ((col+1)*2) - 1
                row = ((row*2) - 1) + (newRow - row)
                
                testMaze[row][col] = 0
            }
            currentPos = newPos
        }
    }
    
    func loadMaze() {
        let wallGeometry = SCNBox(width: 5, height: 8, length: 5, chamferRadius: 0)
        wallGeometry.materials = [materialRed]
        
        var xpos = 0.0
        var zpos = 0.0
        let ypos = 4
        var i = 0
        var xcont = 0
        
        print(testMaze.count)
        
        while(i < testMaze.count){
            
            for item in testMaze[i]{
                switch (item){
                case 0:
                    //print("blank")
                    xpos=xpos+5
                    
                case 1:
                    wall.append(SCNNode(geometry: wallGeometry))
                    wall[xcont].position = SCNVector3(x: Float(xpos), y: Float(ypos), z: Float(zpos))
                    //print("X-axis wall: x: ", xpos, " y: ", ypos, " z: ", zpos)
                    xcont = xcont + 1;
                    xpos = xpos + 5;
                    
                default:
                    print("this shouldn't happen")
                }
            }
            //print("Array",i)
            xpos = 0
            zpos = zpos+5
            i = i+1;
        }
        print("finished maze")
        
        for child in wall {
            print(child.position)
            sceneView.scene?.rootNode.addChildNode(child)
        }
        
        let lookAtGeometry = SCNCylinder(radius: 1.0, height: 15.0)
        lookAtGeometry.materials = [materialCyan]
        
        lookAtNode.geometry = lookAtGeometry
        sceneView.scene?.rootNode.addChildNode(lookAtNode)
        
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}

