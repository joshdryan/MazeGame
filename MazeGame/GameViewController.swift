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

class GameViewController: UIViewController {
    
    var sceneView: SCNView!
    
    var camera = SCNNode()
    var ground = SCNNode()
    var light = SCNNode()
    
    //objects to be added to scene
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
    
    //var gameView: SCNView!
    //var gameScene: SCNScene!
    //var camaraNode: SCNNode!
    //var targetCreationTime: TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        
        //loading materials with correct color
        materialGreen.diffuse.contents = UIColor.green
        materialRed.diffuse.contents = UIColor.red
        materialBlue.diffuse.contents = UIColor.blue
        materialPurple.diffuse.contents = UIColor.purple
        materialCyan.diffuse.contents = UIColor.cyan
        
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
        
        sphere1.addChildNode(camera)
        
        let borderWallxGeometry = SCNBox(width: 100, height: 5, length: 1, chamferRadius: 0)
        borderWallxGeometry.materials = [materialRed]
        borderWallx = SCNNode(geometry: borderWallxGeometry)
        borderWallx.position = SCNVector3(x: 50, y: 1.5, z: -0.5)
        
        let borderWallzGeometry = SCNBox(width: 1, height: 5, length: 100, chamferRadius: 0)
        borderWallzGeometry.materials = [materialCyan]
        borderWallz = SCNNode(geometry: borderWallzGeometry)
        borderWallz.position = SCNVector3(x: -0.5, y: 1.5, z: 50)
        
        sceneView.allowsCameraControl = true
        sceneView.scene?.rootNode.addChildNode(self.camera)
        sceneView.scene?.rootNode.addChildNode(ground)
        sceneView.scene?.rootNode.addChildNode(light)
        sceneView.scene?.rootNode.addChildNode(cylinder1)
        sceneView.scene?.rootNode.addChildNode(sphere1)
        
        
        
        sceneView.scene?.rootNode.addChildNode(borderWallx)
        sceneView.scene?.rootNode.addChildNode(borderWallz)
        
        loadMaze()
        
    }
    
    
    func loadMaze() {
        let wallxGeometry = SCNBox(width: 5, height: 5, length: 1, chamferRadius: 0)
        wallxGeometry.materials = [materialRed]
        wallx += [SCNNode(geometry: wallxGeometry)]
        wallx[0].position = SCNVector3(x: 7.5, y: 1.5, z: 10)
        wallx.append(SCNNode(geometry: wallxGeometry))
        wallx[1].position = SCNVector3(x: 9.5, y: 1.5, z: 12)
        
        let wallzGeometry = SCNBox(width: 1, height: 5, length: 5, chamferRadius: 0)
        wallzGeometry.materials = [materialCyan]
        wallz += [SCNNode(geometry: wallzGeometry)]
        wallz[0].position = SCNVector3(x: 10, y: 1.5, z: 7.5)
        
        
        sceneView.scene?.rootNode.addChildNode(wallx[0])
        sceneView.scene?.rootNode.addChildNode(wallx[1])
        sceneView.scene?.rootNode.addChildNode(wallz[0])
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
        
        let camera = SCNCamera()
        camera.zFar = 10000
        self.camera = SCNNode()
        self.camera.camera = camera
        self.camera.position = SCNVector3(x: -30, y: 20, z: -30)
        let constraint = SCNLookAtConstraint(target: ground)
        constraint.isGimbalLockEnabled = true
        self.camera.constraints = [constraint]
        
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

