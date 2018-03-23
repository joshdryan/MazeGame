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

class GameViewController: UIViewController, UIGestureRecognizerDelegate{
    
    var sceneView: SCNView!
    
    var camera = SCNNode()
    var ground = SCNNode()
    var light = SCNNode()
    var constraint = SCNLookAtConstraint()
    
    
    //objects to be added to scene
    var lookAtNode = SCNNode()
    var wallz: [SCNNode] = []
    var wallx: [SCNNode] = []
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
    let testMaze = [10,6,
                    1,1,1,1,1,1,1,1,6,
                    1,0,1,0,1,0,0,1,6,
                    1,0,0,0,0,1,0,1,6,
                    1,0,0,0,0,1,0,1,6,
                    1,0,1,0,1,0,0,1,6,
                    1,1,1,1,1,1,1,1,9,]
    
    //var gameView: SCNView!
    //var gameScene: SCNScene!
    //var camaraNode: SCNNode!
    //var targetCreationTime: TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initMaterial()
        initElements()
        loadMaze()
        //move()
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
        print(SCNVector3(x: (self.camera.position.x + 5), y: 2.5, z: (self.camera.position.x + 5)))
        
        //lookAtNode.position = SCNVector3(x: lookAtNode.position.x + 5, y: 2.5, z: 0)
    }
    
    func loadMaze() {
        let wallxGeometry = SCNBox(width: 5, height: 5, length: 5, chamferRadius: 0)
        wallxGeometry.materials = [materialRed]
        
        var xpos = 0.0
        var zpos = 0.0
        let ypos = 2.5
        var i = 2
        var xcont = 0
        
        while(i<testMaze.count){
            switch (testMaze[i]){
            case 0:
                print("blank")
                xpos=xpos+5
            case 1:
                    wallx.append(SCNNode(geometry: wallxGeometry))
                    wallx[xcont].position = SCNVector3(x: Float(xpos), y: Float(ypos), z: Float(zpos))
                    wallx += [SCNNode(geometry: wallxGeometry)]
                    print("X-axis wall: x: ", xpos, " y: ", ypos, " z: ", zpos)
                    xcont = xcont + 1;
                    xpos = xpos + 5;
                
            case 6:
                print("new line")
                xpos = 0
                zpos = zpos+5
            case 9:
                print("finished maze")
            default:
                print("this shouldn't happen")
            }
            i = i+1;
        }
        
        
        
        for child in wallx {
            //print(child.position)
            sceneView.scene?.rootNode.addChildNode(child)
        }

    }
    
    func initView() {
        sceneView = SCNView(frame: self.view.frame)
        sceneView.scene = SCNScene()
        self.view.addSubview(sceneView)
        
        let groundGeometry = SCNFloor()
        groundGeometry.reflectivity = 0
        let groundMaterial = SCNMaterial()
        groundMaterial.diffuse.contents = UIColor.white
        groundGeometry.materials = [groundMaterial]
        ground = SCNNode(geometry: groundGeometry)
        
        lookAtNode.position = SCNVector3(x: 100, y: 0, z: 100)
        
        let camera = SCNCamera()
        //camera.zFar = 10000
        self.camera = SCNNode()
        self.camera.camera = camera
        constraint = SCNLookAtConstraint(target: lookAtNode)
        constraint.isGimbalLockEnabled = true
        self.camera.constraints = [constraint]
        self.camera.position = SCNVector3(x: 0, y: 5, z: 0)
        self.camera.position = SCNVector3(x: -20, y: 50, z: -40) //temp
        
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
        sceneView.scene?.rootNode.addChildNode(self.camera)
        sceneView.scene?.rootNode.addChildNode(ground)
        sceneView.scene?.rootNode.addChildNode(light)

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

