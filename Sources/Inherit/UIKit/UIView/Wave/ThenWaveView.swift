//
//  ThenWaveView.swift
//  ThenUIKit
//
//  Created by ghost on 2023/5/17.
//

import UIKit

/// 音调波形图
public class ThenWaveView: UIView {

    // MARK: - Properties Public
    
    // 波浪的数量，默认为5
    public var numberOfWaves: Int = 5
    
    // 波浪的颜色
    public var waveColor: UIColor = .black
    
    // 渐变颜色
    public var gradientColors: [CGColor] = [UIColor.green.cgColor, UIColor.cyan.cgColor, UIColor.green.cgColor]
    
    // 振幅的级别，范围为0.0到1.0，默认为0.0
    public var level: CGFloat = 0.0 {
        didSet {
            // 波形的相位每次增加一个相位偏移值
            phase += phaseShift
            // 振幅为level和idleAmplitude中的较大值
            amplitude = max(level, idleAmplitude)
            // 更新波形
            updateMeters()
        }
    }
    
    // 主波浪的宽度，默认为2.0
    public var mainWaveWidth: CGFloat = 2.0
    
    // 装饰性波浪的宽度，默认为1.0
    public var decorativeWavesWidth: CGFloat = 1.0
    
    // 空闲状态下的振幅，默认为0.01
    public var idleAmplitude: CGFloat = 0.01
    
    // 波形的频率，默认为1.2
    public var frequency: CGFloat = 1.2
    
    // 振幅
    private(set) var amplitude: CGFloat = 1.0
    
    // 波形的密度，默认为1.0
    public var density: CGFloat = 1.0
    
    // 波形的相位偏移量，默认为-0.25
    public var phaseShift: CGFloat = -0.25
    
    
    // MARK: - Properties Private
    
    // 振幅变化后的回调闭包
    private var levelClosure: ((ThenWaveView) -> ())?
    
    // 波形的相位，初始值为0.0
    private var phase: CGFloat = 0.0
    
    // 波形图层
    private var linelayers: [CAShapeLayer] = []
    
    private var wavelayer = CALayer()
    
    // 波形的高度
    private var waveHeight: CGFloat = 0
    
    // 波形的宽度
    private var waveWidths: CGFloat = 0
    
    // 波形的中心
    private var waveMiddle: CGFloat = 0
    
    // 最大振幅
    private var maxAmplitude: CGFloat = 0
    
    // 控制动画的刷新频率
    private var displayLink: CADisplayLink?
    
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.addSublayer(wavelayer)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.wavelayer.frame = bounds
        
        // 更新波形的高度、宽度、中心点、最大振幅等属性
        waveHeight = bounds.height
        waveWidths = bounds.width
        waveMiddle = waveWidths * 0.5
        maxAmplitude = waveHeight * 0.5 - 4.0
    }
    
    deinit { displayLink?.invalidate() }
    
    
    // MARK: - Actions
    
    // 启动振幅变化的监测
    public func startObserve(_ closure: ((ThenWaveView) -> ())?) {
        levelClosure = closure
        // 先停止之前的动画
        displayLink?.invalidate()
        // 创建CADisplayLink对象，目标是当前对象，选择器为invokeWaveCallback
        displayLink = CADisplayLink(target: self, selector: #selector(invokeWaveCallback))
        // 将CADisplayLink添加到当前运行循环中，以便可以刷新屏幕
        displayLink?.add(to: .main, forMode: RunLoop.Mode.common)
        // 创建波形图层
        for i in 0..<numberOfWaves {
            let linelayer = CAShapeLayer()
            linelayer.lineCap = .butt
            linelayer.lineJoin = .round
            linelayer.strokeColor = UIColor.clear.cgColor
            linelayer.fillColor = UIColor.clear.cgColor
            linelayer.lineWidth = (i == 0 ? mainWaveWidth : decorativeWavesWidth)
            let progress = 1.0 - CGFloat(i) / CGFloat(numberOfWaves)
            let multiplier = min(1.0, progress / 3.0 * 2.0 + 1.0 / 3.0)
            let color = waveColor.withAlphaComponent(i == 0 ? 1.0 : 1.0 * multiplier * 0.6)
            linelayer.strokeColor = color.cgColor
            
            let gradientlayer = CAGradientLayer()
            gradientlayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
            gradientlayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientlayer.endPoint = CGPoint(x: 1, y: 0.5)
            gradientlayer.locations = [0, 0.5, 1]
            gradientlayer.colors = gradientColors
            gradientlayer.mask = linelayer
            
            self.wavelayer.addSublayer(gradientlayer)
            // self.layer.addSublayer(linelayer)
            self.linelayers.append(linelayer)
        }
    }
    
    public func startAnimate() {
        displayLink?.add(to: .main, forMode: .common)
        displayLink?.isPaused = false
    }
    
    public func stopAnimate() {
        displayLink?.remove(from: .main, forMode: .common)
        displayLink?.isPaused = true
    }
    
    @objc private func invokeWaveCallback() {
        levelClosure?(self)
    }
    
    // 更新波形
    private func updateMeters() {
        // 创建图形上下文
        UIGraphicsBeginImageContext(bounds.size)
        defer { UIGraphicsEndImageContext() }
        
        // 设置波形Path
        for i in 0..<numberOfWaves {
            let path = UIBezierPath()
            let progress = 1.0 - CGFloat(i) / CGFloat(numberOfWaves)
            let normedAmplitude = (1.5 * progress - 0.5) * amplitude
            for x in stride(from: CGFloat(0), to: waveWidths + density, by: density) {
                let scaling = 1 - pow((x / waveMiddle) - 1, 2)
                let y = scaling * maxAmplitude * normedAmplitude * sin(2.0 * CGFloat.pi * (x / waveWidths) * frequency + phase) + waveHeight * 0.5
                if x == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            linelayers[i].path = path.cgPath
        }
    }
}
