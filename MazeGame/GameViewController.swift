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
    var cylinder1 = SCNNode()
    var sphere1 = SCNNode()
    var sphere2 = SCNNode()
    var borderWallx = SCNNode()
    var borderWallz = SCNNode()
    var wallz: [SCNNode] = []
    var wallx: [SCNNode] = []
    
    let materialGreen = SCNMaterial()               //set green material
    let materialRed = SCNMaterial()                 //set red material
    let materialBlue = SCNMaterial()                //set blue material
    let materialPurple = SCNMaterial()              //set purple material
    let materialCyan = SCNMaterial()                //set cyan material
    let testMaze = [1,1,1,1,1,1,1,1,1,8,
                    1,0,1,0,0,0,1,0,1,8,
                    1,0,0,0,1,0,0,0,1,7,
                    1,1,1,1,1,1,1,1,1,9,]
    
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
        let borderWallxGeometry = SCNBox(width: 100, height: 5, length: 1, chamferRadius: 0)
        borderWallxGeometry.materials = [materialRed]
        borderWallx = SCNNode(geometry: borderWallxGeometry)
        borderWallx.position = SCNVector3(x: 50, y: 1.5, z: -0.5)
        
        let borderWallzGeometry = SCNBox(width: 1, height: 5, length: 100, chamferRadius: 0)
        borderWallzGeometry.materials = [materialCyan]
        borderWallz = SCNNode(geometry: borderWallzGeometry)
        borderWallz.position = SCNVector3(x: -0.5, y: 1.5, z: 50)
        
        sceneView.scene?.rootNode.addChildNode(borderWallx)
        sceneView.scene?.rootNode.addChildNode(borderWallz)
        
        let wallxGeometry = SCNBox(width: 5, height: 5, length: 1, chamferRadius: 0)
        wallxGeometry.materials = [materialRed]
        wallx += [SCNNode(geometry: wallxGeometry)]
        wallx[0].position = SCNVector3(x: 7.5, y: 1.5, z: 10)
        wallx.append(SCNNode(geometry: wallxGeometry))
        wallx[1].position = SCNVector3(x: 12.5, y: 1.5, z: 15)
        
        let wallzGeometry = SCNBox(width: 1, height: 5, length: 5, chamferRadius: 0)
        wallzGeometry.materials = [materialCyan]
        wallz += [SCNNode(geometry: wallzGeometry)]
        wallz[0].position = SCNVector3(x: 10, y: 1.5, z: 7.5)
        
        /*
        var xpos = 0
        var zpos = 0
        var i = 0
        var xcont = 0
        var zcont = 0
        var xz = true
        while(i<testMaze.count){
            switch (testMaze[i]){
            case 0:
                print("blank")
                xpos=xpos+5
            case 1:
                print("wall")
                if(xz){
                    
                }else{
                    
                }
            case 7:
                print("x to z new line")
                xz = false
                xcont = 0
                zcont=zcont+5
                
            case 8:
                print("z to x new line")
                xz = true
                xcont = 0
                zcont=zcont+5
                
            case 9:
                print("finished maze")
            default:
                print("this shouldn't happen")
            }
            
            
            i = i+1;
        }
        
        */
        
        for child in wallx {
            //print(child.position)
            sceneView.scene?.rootNode.addChildNode(child)
        }
        for child in wallz {
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
        let cylinderGeometry = SCNCylinder(radius: 0.1, height: 10)
        cylinderGeometry.materials = [materialGreen]
        cylinder1 = SCNNode(geometry: cylinderGeometry)
        cylinder1.position = SCNVector3(x: 0, y: 5, z: 0)
        
        let sphereGeometry = SCNSphere(radius: 1.5)
        sphereGeometry.materials = [materialPurple]
        sphere1 = SCNNode(geometry: sphereGeometry)
        sphere1.position = SCNVector3(x: -5, y: 1.5, z: 0)
        sphere2 = SCNNode(geometry: sphereGeometry)
        sphere2.position = SCNVector3(x: 0, y: 1.5, z: -5)/**/
        
        sceneView.allowsCameraControl = true
        sceneView.scene?.rootNode.addChildNode(self.camera)
        sceneView.scene?.rootNode.addChildNode(ground)
        sceneView.scene?.rootNode.addChildNode(light)
        sceneView.scene?.rootNode.addChildNode(cylinder1)
        sceneView.scene?.rootNode.addChildNode(sphere1)
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

