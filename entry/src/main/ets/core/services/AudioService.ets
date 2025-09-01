import { media } from '@kit.MediaKit';
import { audio } from '@kit.AudioKit';
import { common } from '@kit.AbilityKit';
import { SongModel } from '../models/SongModel';

export
enum AudioStatus {
  Undefined,
  Playing,
  Paused,
  Released,
}

@ObservedV2
export class AudioService {
  static _instance: AudioService;

  // Ensure only one instance of this ViewModel is created
  static getInstance() {
    if (!AudioService._instance) {
      AudioService._instance = new AudioService(AudioStatus.Undefined);
    }
    return AudioService._instance;
  }

  constructor(audioStatus: AudioStatus) {
    this.audioStatus = audioStatus;
    this.currentSong = SongModel.empty();
  }


  private player: media.AVPlayer | undefined;
  @Trace audioStatus: AudioStatus;
  @Trace currentSong: SongModel;

  setCallbacks(avPlayer: media.AVPlayer) {

    avPlayer.on('stateChange', async (state: string) => {
      console.info('AVPlayer state:', state);
      switch (state) {
        case 'initialized':
          avPlayer.audioRendererInfo = {
            usage: audio.StreamUsage.STREAM_USAGE_MUSIC,
            rendererFlags: 0,
          };
          avPlayer.prepare();
          break;
        case 'prepared':
          this.audioStatus = AudioStatus.Playing
          avPlayer.play();
          break;
        case 'completed':
          avPlayer.stop();
          break;
        case 'stopped':
          avPlayer.reset();
          break;
        case 'idle':
          avPlayer.release();
          break;
      }
    });

    avPlayer.on('error', (err) => {
      console.error('AVPlayer error:', err.message);
      avPlayer.reset();
    });
  }

  public async playEmbeddedMp3(fileName: string) {
    const context = getContext(this) as common.UIAbilityContext;
    const resourceFd = await context.resourceManager.getRawFd(fileName);

    const avFileDescriptor: media.AVFileDescriptor = {
      fd: resourceFd.fd,
      offset: resourceFd.offset,
      length: resourceFd.length,
    };
    this.player = await media.createAVPlayer();
    this.setCallbacks(this.player);
    this.player.fdSrc = avFileDescriptor;
  }

  public pause() {
    this.audioStatus = AudioStatus.Paused
    this.player?.pause();
  }

  public resume() {
    this.audioStatus = AudioStatus.Playing
    this.player?.play();
  }

  public stop() {
    this.audioStatus = AudioStatus.Released
    this.player?.stop();
  }

  public release() {
    this.audioStatus = AudioStatus.Released
    this.player?.reset();
  }
}
