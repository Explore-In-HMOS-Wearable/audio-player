import { SongModel } from '../../core/models/SongModel';
import { AudioService } from '../../core/services/AudioService';
import { BaseViewModel } from '../../core/services/BaseViewModel';

@ObservedV2
export class HomeViewModel extends BaseViewModel {
  @Trace isInited: boolean = false;
  audioService: AudioService = AudioService.getInstance();

  constructor() {
    super();
    this.initVm();
  }

  initVm() {
    this.isInited = true;
  }


  navigateToAudioList() {
    this.routeService.pushRoute('ui/pages/audio_list')
  }


  startAudio(songModel: SongModel) {
    this.audioService.playEmbeddedMp3(songModel.songPath);
  }

  stopAudio() {
    this.audioService.pause();
  }

  nextSong() {
    const currentIndex = this.songList.indexOf(this.audioService.currentSong);
    if (currentIndex < this.songList.length - 1) {
      this.audioService.release();
      this.audioService.playEmbeddedMp3(this.songList[currentIndex + 1].songPath);
    }
  }

  previousSong() {
    const currentIndex = this.songList.indexOf(this.audioService.currentSong);
    if (currentIndex > 0) {
      this.audioService.release();
      this.audioService.playEmbeddedMp3(this.songList[currentIndex - 1].songPath);
    }
  }
}
