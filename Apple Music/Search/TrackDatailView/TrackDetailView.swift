//
//  TrackDetailView.swift
//  Apple Music
//
//  Created by Vlad Lytvynets on 02.07.2021.
//

import UIKit
import SDWebImage
import AVKit

protocol TrackMovingDelegate {
    func moveBackTrack() -> SearchViewModel.Cell?
    func moveForwardTrack() -> SearchViewModel.Cell?
}

class TrackDetailView: UIView {
    
    //Minimized
    @IBOutlet weak var maximizedStackView: UIStackView!
    @IBOutlet weak var miniTrackDetilView: UIView!
    @IBOutlet weak var ImageMiniTrackDetailView: UIImageView!
    @IBOutlet weak var trackLabelMiniTrackDetailView: UILabel!
    
    //Maximized
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var autorTitleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    
    //MARK: - Delegate
    var delegate: TrackMovingDelegate?
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    
    //Player
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    
    //MARK: - awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
        let scale: CGFloat = 0.8
        trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        trackImageView.layer.cornerRadius = 5
        trackImageView.backgroundColor = .red
        setupGestures()
    }
    
    
    //MARK: - Data display on TrackDetailWiew
    func set(viewModel: SearchViewModel.Cell){
        trackLabelMiniTrackDetailView.text = viewModel.trackName
        trackTitleLabel.text = viewModel.trackName
        autorTitleLabel.text = viewModel.artistName
        playTrack(previewUrl: viewModel.previewUrl)
        monitorStartTime()
        observeCurrentTime()
        let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: string600 ?? "") else { return }
        
        trackImageView.sd_setImage(with: url, completed: nil)
        ImageMiniTrackDetailView.sd_setImage(with: url, completed: nil)
        
    }
    
    
    //MARK: - Work with gestures
    private func setupGestures(){
        miniTrackDetilView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximized)))
        miniTrackDetilView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
    }
    
    
    @objc private func handleTapMaximized(){
        self.tabBarDelegate?.maximizedTrackDetailController(viewModel: nil)
    }
    
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .began:
            print("began")
        case .changed:
            handlePanChanged(gesture: gesture)
        case .ended:
            handlePanEnded(gesture: gesture)
        @unknown default:
            print("@unknown default")
        }
    }
    
    
    private func handlePanChanged(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        let newAlpha = 1 + translation.y / 200
        self.miniTrackDetilView.alpha = newAlpha < 0 ? 0 : newAlpha
        self.maximizedStackView.alpha = -translation.y / 200
    }
    
    
    private func handlePanEnded(gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        UIView.animate(withDuration: 0.5, delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1, options: .curveEaseOut,
                       animations: {
            self.transform = .identity
            if translation.y < -200 || velocity.y < -500 {
                self.tabBarDelegate?.maximizedTrackDetailController(viewModel: nil)
            }else{
                self.miniTrackDetilView.alpha = 1
                self.maximizedStackView.alpha = 0
            }
        }, completion: nil)
    }
    
    //Звуртає екран в мінімальний
    @objc private func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            let translation = gesture.translation(in: self.superview)
            maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        case .ended:
            let translation = gesture.translation(in: self.superview)
            UIView.animate(withDuration: 0.5,
                           delay: 0, usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 1,
                           options: .curveEaseInOut,
                           animations: {
                
                self.maximizedStackView.transform = .identity
                if translation.y > 50 {
                    self.tabBarDelegate?.minimizedTrackDetailController()
                }
            }, completion: nil)
        @unknown default:
            print("unknown default")
        }
    }
    
    
    private func playTrack(previewUrl: String?){
        guard let url = URL(string: previewUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    
    //MARK: - Time setup
    private func monitorStartTime(){
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargeTrackImageView()
        }
    }
    
    
    private func enlargeTrackImageView(){
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.trackImageView.transform = .identity
        }, completion: nil)
    }
    
    private func reduceTrackImageView(){
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            let scale: CGFloat = 0.8
            self.trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }, completion: nil)
    }
    
    
    
    private func observeCurrentTime(){
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            self?.currentTimeLabel.text = time.toDisplayString()
            
            let durationTime = self?.player.currentItem?.duration
            let currentDurationText = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toDisplayString()
            self?.durationLabel.text = "-\(currentDurationText)"
            self?.updateCurrentTimeSlider()
        }
    }
    
    
    private func updateCurrentTimeSlider(){
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSeconds / durationSeconds
        self.currentTimeSlider.value = Float(percentage)
    }
    
    
    
    //MARK: - IBActions
    @IBAction func handlerVolumeSlider(_ sender: Any) {
        player.volume = volumeSlider.value
    }
    
    @IBAction func handlerCurrentTimeSlider(_ sender: Any) {
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSecond = CMTimeGetSeconds(duration)
        let seekTimeUnSecond = Float64(percentage) * durationInSecond
        let seekTime = CMTimeMakeWithSeconds(seekTimeUnSecond, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    @IBAction func dragDownButtonTapped(_ sender: Any) {
        tabBarDelegate?.minimizedTrackDetailController()
    }
    
    @IBAction func previousTrack(_ sender: Any) {
        let cellViewModel = delegate?.moveBackTrack()
        guard let cellView = cellViewModel else { return }
        self.set(viewModel: cellView)
    }
    
    @IBAction func nextTrack(_ sender: Any) {
        let cellViewModel = delegate?.moveForwardTrack()
        guard let cellView = cellViewModel else { return }
        self.set(viewModel: cellView)
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "Pause"), for: .normal)
            enlargeTrackImageView()
        }else{
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "Triangle"), for: .normal)
            reduceTrackImageView()
        }
    }
}
