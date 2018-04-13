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
    
    let sW = UIScreen.main.bounds.width         //screen width
    let sH = UIScreen.main.bounds.height        //screen height
    
    //objects to be added to scene
    var lookAtNode = SCNNode()
    let materialRed = SCNMaterial()                 //set red material
    let materialCyan = SCNMaterial()                //set cyan material
    
    var gameView: SCNView!
    var gameScene: SCNScene!
    var camaraNode: SCNNode!
    var targetCreationTime: TimeInterval = 0
    
    var maze: Maze!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initMaterial()
        initElements()
        
        let lookAtGeometry = SCNCylinder(radius: 1.0, height: 15.0)
        lookAtGeometry.materials = [materialCyan]
        
        lookAtNode.geometry = lookAtGeometry
        sceneView.scene?.rootNode.addChildNode(lookAtNode)
        
        maze = Maze()
        maze.generateMaze()
        maze.loadMaze()
        sceneView.scene?.rootNode.addChildNode(maze.x)
//        generateMaze()
//        loadMaze()
        
        //Left Button
        LeftButton.setTitle("<", for: .normal)
        LeftButton.setTitleColor(UIColor.white, for: .normal)
        LeftButton.frame = CGRect(origin: CGPoint(x: sW*(1/8)-25,y :sH-100), size: CGSize(width: 50, height: 50))
        LeftButton.transform = CGAffineTransform(scaleX: 3,y: 3);
        LeftButton.addTarget(self, action:#selector(leftButton), for: .touchUpInside)
        self.view.addSubview(LeftButton)
        
        //Right Button
        RightButton.setTitle(">", for: .normal)
        RightButton.setTitleColor(UIColor.white, for: .normal)
        RightButton.frame = CGRect(origin: CGPoint(x: sW*(7/8)-25,y :sH-100), size: CGSize(width: 50, height:50))
        RightButton.transform = CGAffineTransform(scaleX: 3,y: 3);
        RightButton.addTarget(self, action:#selector(rightButton), for: .touchUpInside)
        self.view.addSubview(RightButton)
        
        //Forward Button
        ForwardButton.setTitle("^", for: .normal)
        ForwardButton.setTitleColor(UIColor.white, for: .normal)
        ForwardButton.frame = CGRect(origin: CGPoint(x: sW*(1/2)-25,y :sH-100), size: CGSize(width: 50, height: 50))
        ForwardButton.transform = CGAffineTransform(scaleX: 4,y: 4);
        ForwardButton.addTarget(self, action:#selector(forwardButton), for: .touchUpInside)
        self.view.addSubview(ForwardButton)
        
        //Restart Menu
        RestartButton.setTitle("Restart", for: .normal)
        RestartButton.setTitleColor(UIColor.black, for: .normal)
        RestartButton.frame = CGRect(origin: CGPoint(x: 0,y :15), size: CGSize(width: 100, height: 30))
        RestartButton.addTarget(self, action:#selector(restartMenu), for: .touchUpInside)
        self.view.addSubview(RestartButton)
        
        //Confrim Restart
        ConfirmButton.setTitle("Yes", for: .normal)
        ConfirmButton.setTitleColor(UIColor.white, for: .normal)
        ConfirmButton.frame = CGRect(origin: CGPoint(x: sW*(2/8)-25,y :sH-200), size: CGSize(width: 50, height: 50))
        ConfirmButton.transform = CGAffineTransform(scaleX: 4,y: 4);
        ConfirmButton.addTarget(self, action:#selector(restart), for: .touchUpInside)
        
        //Deny Restart
        DenyButton.setTitle("No", for: .normal)
        DenyButton.setTitleColor(UIColor.white, for: .normal)
        DenyButton.frame = CGRect(origin: CGPoint(x: sW*(6/8)-25,y :sH-200), size: CGSize(width: 50, height: 50))
        DenyButton.transform = CGAffineTransform(scaleX: 4,y: 4);
        DenyButton.addTarget(self, action:#selector(goBack), for: .touchUpInside)
        
        //Restart Message
        RestartMessage.numberOfLines = 3
        RestartMessage.text = "Are you sure you want to restart?"
        RestartMessage.frame = CGRect(origin: CGPoint(x: sW*(0.5)-50,y :sH*(1/8)), size: CGSize(width: 145, height: 50))
        RestartMessage.transform = CGAffineTransform(scaleX: 3,y: 3);
        
    }
    
    let LeftButton = UIButton()
    let RightButton = UIButton()
    let ForwardButton = UIButton()
    let RestartButton = UIButton()
    let ConfirmButton = UIButton()
    let DenyButton = UIButton()
    let RestartMessage = UILabel()
    var xpos:Float = 0.0
    var zpos:Float = 0.0
    
    
    @objc func restart(){
        lookAtNode.position = SCNVector3(x: 5, y: 0, z: 5)
        self.camera.position = SCNVector3(x: 5, y: 30, z: -20)
//        unloadMaze()
//        maze.generateMaze()
//        maze.loadMaze()
        self.view.addSubview(LeftButton)
        self.view.addSubview(RightButton)
        self.view.addSubview(ForwardButton)
        self.view.addSubview(RestartButton)
        ConfirmButton.removeFromSuperview()
        DenyButton.removeFromSuperview()
        RestartMessage.removeFromSuperview()
    }
    
    @objc func goBack(){
        self.camera.position = SCNVector3(x: xpos, y: 30, z: zpos)
        self.view.addSubview(LeftButton)
        self.view.addSubview(RightButton)
        self.view.addSubview(ForwardButton)
        self.view.addSubview(RestartButton)
        ConfirmButton.removeFromSuperview()
        DenyButton.removeFromSuperview()
        RestartMessage.removeFromSuperview()
    }
    @objc func restartMenu(){
        xpos = camera.position.x
        zpos = camera.position.z
        self.camera.position = SCNVector3(x: -300, y: 150, z: -300)
        LeftButton.removeFromSuperview()
        RightButton.removeFromSuperview()
        ForwardButton.removeFromSuperview()
        RestartButton.removeFromSuperview()
        self.view.addSubview(ConfirmButton)
        self.view.addSubview(DenyButton)
        self.view.addSubview(RestartMessage)
    }
    
    @objc func leftButton(){
        if(lookAtNode.position.z > camera.position.z) {
            self.camera.position = SCNVector3(x: lookAtNode.position.x - 20, y: 30, z: lookAtNode.position.z)
        } else if(lookAtNode.position.x > camera.position.x) {
            self.camera.position = SCNVector3(x: lookAtNode.position.x, y: 30, z: lookAtNode.position.z + 20)
        } else if(lookAtNode.position.z < camera.position.z) {
            self.camera.position = SCNVector3(x: lookAtNode.position.x + 20, y: 30, z: lookAtNode.position.z)
        } else if(lookAtNode.position.x < camera.position.x) {
            self.camera.position = SCNVector3(x: lookAtNode.position.x, y: 30, z: lookAtNode.position.z - 20)
        }
    }
    
    @objc func rightButton(){
        if(lookAtNode.position.z > camera.position.z) {
            self.camera.position = SCNVector3(x: lookAtNode.position.x + 20, y: 30, z: lookAtNode.position.z)
        } else if(lookAtNode.position.x > camera.position.x) {
            self.camera.position = SCNVector3(x: lookAtNode.position.x, y: 30, z: lookAtNode.position.z - 20)
        } else if(lookAtNode.position.z < camera.position.z) {
            self.camera.position = SCNVector3(x: lookAtNode.position.x - 20, y: 30, z: lookAtNode.position.z)
        } else if(lookAtNode.position.x < camera.position.x) {
            self.camera.position = SCNVector3(x: lookAtNode.position.x, y: 30, z: lookAtNode.position.z + 20)
        }
    }
    
    @objc func forwardButton(){
        if(lookAtNode.position.z > camera.position.z) {
            self.camera.position = SCNVector3(x: camera.position.x, y: 30, z: camera.position.z + 5)
            lookAtNode.position = SCNVector3(x: lookAtNode.position.x, y: 0, z: lookAtNode.position.z + 5)
        } else if(lookAtNode.position.x > camera.position.x) {
            self.camera.position = SCNVector3(x: camera.position.x + 5, y: 30, z: camera.position.z)
            lookAtNode.position = SCNVector3(x: lookAtNode.position.x + 5, y: 0, z: lookAtNode.position.z)
        } else if(lookAtNode.position.z < camera.position.z) {
            self.camera.position = SCNVector3(x: camera.position.x, y: 30, z: camera.position.z - 5)
            lookAtNode.position = SCNVector3(x: lookAtNode.position.x, y: 0, z: lookAtNode.position.z - 5)
        } else if(lookAtNode.position.x < camera.position.x) {
            self.camera.position = SCNVector3(x: camera.position.x - 5, y: 30, z: camera.position.z)
            lookAtNode.position = SCNVector3(x: lookAtNode.position.x - 5, y: 0, z: lookAtNode.position.z)
        }
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
        
        lookAtNode.position = SCNVector3(x: 5, y: 0, z: 5)
        
        let camera = SCNCamera()

        camera.zFar = 1000
        self.camera = SCNNode()
        self.camera.camera = camera
        constraint = SCNLookAtConstraint(target: lookAtNode)
        constraint.isGimbalLockEnabled = true
       
        self.camera.constraints = [constraint]
        self.camera.position = SCNVector3(x: 5, y: 30, z: -20)
        cameraOrbit.addChildNode(self.camera)
        
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
        //light.position = SCNVector3(x: lookAtX, y: 100, z: lookAtZ)
        light.constraints = [constraint]
    }
    
    func initMaterial() {
        //loading materials with correct color
        materialRed.diffuse.contents = UIColor.red
        materialCyan.diffuse.contents = UIColor.cyan
    }
    
    func initElements() {
        sceneView.allowsCameraControl = true
        sceneView.scene?.rootNode.addChildNode(cameraOrbit)
        
//        sceneView.scene?.lookAtNode.addChildNode(cameraOrbit)
        sceneView.scene?.rootNode.addChildNode(ground)
        sceneView.scene?.rootNode.addChildNode(light)
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
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

