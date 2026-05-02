import { SongModel } from '../../core/models/SongModel';
import { AudioService } from '../../core/services/AudioService';
import { BaseViewModel } from '../../core/services/BaseViewModel';

@ObservedV2
export class AudioViewViewModel extends BaseViewModel {
  @Trace isInited: boolean = false;
  audioService: AudioService = AudioService.getInstance();

  constructor() {
    super();
    this.initVm();
  }

  initVm() {
    this.isInited = true;
  }

  async startAudio(songModel: SongModel) {
    await this.audioService.playEmbeddedMp3(songModel.songPath);
  }

  stopAudio() {
    this.audioService.pause();
  }

  nextSong() {
    const currentIndex = this.songList.indexOf(this.audioService.currentSong);
    if (currentIndex < this.songList.length - 1) {
      this.audioService.release();
      this.audioService.currentSong = this.songList[currentIndex + 1];
      this.audioService.playEmbeddedMp3(this.songList[currentIndex + 1].songPath);
    }
    console.info(this.audioService.currentSong.songName)
  }

  previousSong() {
    const currentIndex = this.songList.indexOf(this.audioService.currentSong);
    if (currentIndex > 0) {
      this.audioService.release();
      this.audioService.currentSong = this.songList[currentIndex - 1];
      this.audioService.playEmbeddedMp3(this.songList[currentIndex - 1].songPath);
    }
  }
}
