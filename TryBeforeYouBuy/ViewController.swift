//
//  ViewController.swift
//  TryBeforeYouBuy
//
//  Created by Aaron Rosen on 8/10/17.
//  Copyright © 2017 Harrys. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreImage

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!

    var anchors = [ARAnchor]()

    let NODE_NAME = "harrys-razor"
    let ciContext = CIContext()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true

//        let lookAtConstraint = SCNLookAtConstraint(target: sceneView.pointOfView)
//        lookAtConstraint.isGimbalLockEnabled = true
//        lookAtConstraint.influenceFactor = 0.01

        // Create a new scene
        let razorScene = SCNScene(named: "art.scnassets/\(NODE_NAME).scn")!
        if let node = razorScene.rootNode.childNode(withName: NODE_NAME, recursively: true) {
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.orange
            material.diffuse.contentsTransform = SCNMatrix4MakeScale(0.5, 0.5, 0.5)

            node.geometry?.materials = [material]
        }
//        sceneView.scene = razorScene


//        let sphereGeometry = SCNSphere(radius: 0.2)
//        let beardNode = SCNNode(geometry: sphereGeometry)
////        let beardNode = createSphereWithBeard(UIImage(named: "chuckNorris")!)
//        beardNode.position.z = -0.8
//        sceneView.scene.rootNode.addChildNode(beardNode)
//
        let beards = ["chuckNorris", "gandolf", "jackSparrow", "mrT", "zach"].map { UIImage(named: $0) }
        for beard in beards {
            if let beard: UIImage = beard {
                let beardNode = createSphereWithBeard(beard)

                let randomY = Float(arc4random()) / Float(UINT32_MAX) * 3.0 - 1.5
                let randomX = Float(arc4random()) / Float(UINT32_MAX) * 3.0 - 1.5

                print("X: \(randomX) Y: \(randomY)")

                beardNode.position.z = -0.8
                beardNode.position.x = randomX
                beardNode.position.y = randomY
                sceneView.scene.rootNode.addChildNode(beardNode)
            }
        }

        if let razor = SCNScene(named: "art.scnassets/\(NODE_NAME).scn")?.rootNode.childNode(withName: NODE_NAME, recursively: true) {
            razor.position.z = -0.2
            let orangeColor = SCNMaterial()
            orangeColor.diffuse.contents = UIColor.orange
            razor.geometry?.materials = [orangeColor]
            razor.pivot = SCNMatrix4Identity
            sceneView.scene.rootNode.addChildNode(razor)
        }

//        sphereNode.position.z = -0.8

//        sceneView.scene.rootNode.addChildNode(sphereNode)

        self.anchors = [ARAnchor]()
    }

    func createSphereWithBeard(_ beard: UIImage) -> SCNNode {
        let beardMaterial = SCNMaterial()
        beardMaterial.diffuse.contents = beard

        let sphereGeometry = SCNSphere(radius: 0.2)
        let sphereNode = SCNNode(geometry: sphereGeometry)
        sphereNode.geometry?.materials = [beardMaterial]

        return sphereNode
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        if anchors.contains(anchor) {
//            let razorAnchor = self.razorNode
//            razorAnchor.position.z = -0.5
//            node.addChildNode(razorAnchor)
//        }
    }

//    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
//        if anchors.contains(anchor) {
//            print("move the node")
//        }
//    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        razorNode.position = SCNVector3Make(frame.camera.transform[3].x, frame.camera.transform[3].y, frame.camera.transform[3].z - 0.15)

        razorNode.eulerAngles.x = frame.camera.eulerAngles.x
        razorNode.eulerAngles.y = frame.camera.eulerAngles.y
        razorNode.eulerAngles.z = frame.camera.eulerAngles.z + Float.pi/2.0

//        print("Razor angles: x: \(razorNode.eulerAngles.x),y: \(razorNode.eulerAngles.y),z: \(razorNode.eulerAngles.z), ")

        let frameImage = CIImage(cvPixelBuffer: frame.capturedImage)
//        self.resultImage = frameImage


//        DispatchQueue.main.async {
//            let detector = CIDetector(ofType: CIDetectorTypeFace, context: self.ciContext, options: [:])
//            let features = detector?.features(in: frameImage)
//            if let faceFeature = features?.first as? CIFaceFeature {
//
//            }
//        }
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }

    var razorNode: SCNNode {
        return self.sceneView.scene.rootNode.childNode(withName: NODE_NAME, recursively: true)!
    }

    // MARK: - Gesture Recognizers

    @objc func handleTapFrom(_ recognizer: UITapGestureRecognizer) {
//        if let frame = sceneView.session.currentFrame {
//            print("adding anchor")
//            let translation = matrix_identity_float4x4
//            let handTransform = simd_mul(frame.camera.transform, translation)
//            let anchor = ARAnchor(transform: handTransform)
//            self.anchors.append(anchor)
//            sceneView.session.add(anchor: anchor)
//        }
    }
}
