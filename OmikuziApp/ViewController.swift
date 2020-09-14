//
//  ViewController.swift
//  OmikuziApp
//
//  Created by 高橋康之 on 2020/09/14.
//  Copyright © 2020 yasu.com. All rights reserved.
//

import UIKit
import AVFoundation //この1行を追記

class ViewController: UIViewController {
    
    
    // 下の1行を追加。結果を表示したときに音を出すための再生オブジェクトを格納します。
    var resultAudioPlayer: AVAudioPlayer = AVAudioPlayer()
    
    
    @IBOutlet var stickView: UIView!
    @IBOutlet var stickLabel: UILabel!
    @IBOutlet var stickHeight: NSLayoutConstraint!
    @IBOutlet var stickBottomMargin: NSLayoutConstraint!
    
    
    @IBOutlet var overView: UIView!
    
    @IBOutlet var bigLabel: UILabel!
    
    
    //おみくじの内容を格納
    let resultTexts: [String] = [
        "大吉",
        "中吉",
        "小吉",
        "吉",
        "末吉",
        "凶",
        "大凶"
    ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupSound() //この1行を追加
    }
    //モーションを終了認識したタイミングで動作
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        
        if motion != UIEvent.EventSubtype.motionShake || overView.isHidden == false {
            // シェイクモーション以外では動作させない
            // 結果の表示中は動作させない
            return
        }
        //配列の要素番号の範囲でランダムの値を取得しています。UInt32は0と自然数のみを扱えます。対してIntは整数を扱うので、マイナス値も扱えます。
        let resultNum = Int( arc4random_uniform(UInt32(resultTexts.count)) )
        //配列の要素を取得し、stickLabelのテキストとしています。
        stickLabel.text = resultTexts[resultNum]
        //おみくじ棒下辺の間隔を変えて表示位置を変える
        stickBottomMargin.constant = stickHeight.constant * -1
        //アニメーションさせる,withDurationはアニメーションを行う秒数です。今回は1秒
        UIView.animate(withDuration: 1, animations: {
            //アニメーションが反映
            self.view.layoutIfNeeded()
            //結果のViewを表示します。
        }, completion: { (finished: Bool) in
            self.bigLabel.text = self.stickLabel.text
            self.overView.isHidden = false
            
            //次の1行を追加 -> 結果表示のときに音を再生(Play)する！
            self.resultAudioPlayer.play()
        })
    }
    
    
    @IBAction func tapRetryButton(_ sender: Any) {
        
        //変数soundに指定した効果音ファイルの場所を読み込んでいます。
        if let sound = Bundle.main.path(forResource: "drum", ofType: ".mp3") {
            resultAudioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            resultAudioPlayer.prepareToPlay()
        }
        //この下から追記！→ 結果表示するときに鳴らす音の準備
        func setupSound() {
            if let sound = Bundle.main.path(forResource: "drum", ofType: ".mp3") {
                resultAudioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
                resultAudioPlayer.prepareToPlay()
            }
        }
        //ここまで追記！
        //1行目でoverViewを再び非表示にしています。
        //2行目では、シェイク時に変更された制約の値を0に戻して、再度おみくじ棒が本体の中に隠れるようにしています。
        
        overView.isHidden = true
        stickBottomMargin.constant = 0
    }
    
}

