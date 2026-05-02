import { media } from '@kit.MediaKit';
import { audio } from '@kit.AudioKit';
import { common } from '@kit.AbilityKit';
import { vibrator } from '@kit.SensorServiceKit';
import { SongModel } from '../models/SongModel';
import GlobalContext from './GlobalContext';

export
enum AudioStatus {
  Undefined,
  Playing,
  Paused,
  Released
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
  @Trace volume: number = 0.5;
  @Trace currentTime: number = 0;
  @Trace duration: number = 0;

  setCallbacks(avPlayer: media.AVPlayer) {

    avPlayer.on('timeUpdate', (time: number) => {
      this.currentTime = time;
    });

    avPlayer.on('durationUpdate', (duration: number) => {
      this.duration = duration;
    });

    avPlayer.on('stateChange', async (state: string) => {
      console.info('AVPlayer state:', state);
      switch (state) {
        case 'initialized':
          avPlayer.audioRendererInfo = {
            usage: audio.StreamUsage.STREAM_USAGE_MUSIC,
            rendererFlags: 0
          };
          avPlayer.prepare();
          break;
        case 'prepared':
          this.audioStatus = AudioStatus.Playing
          avPlayer.setVolume(this.volume);
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
    const context: common.UIAbilityContext = GlobalContext.getInstance().getServiceContext();
    const resourceFd = await context.resourceManager.getRawFd(fileName);

    const avFileDescriptor: media.AVFileDescriptor = {
      fd: resourceFd.fd,
      offset: resourceFd.offset,
      length: resourceFd.length
    };
    try {
      this.player = await media.createAVPlayer();
      if (this.player !== undefined) {
        this.player.on('audioInterrupt', (event) => {
          if (event.hintType === audio.InterruptHint.INTERRUPT_HINT_PAUSE) {
            console.info('Audio interruption: Player is stopping...');
            this.player?.pause();
          }
        });

        this.player.on('audioOutputDeviceChangeWithInfo', (info) => {
          console.info('Device changed..');
          if (info?.changeReason === audio.AudioStreamDeviceChangeReason.REASON_OLD_DEVICE_UNAVAILABLE) {
            this.player?.pause();
          }
        });
      }

      this.setCallbacks(this.player);
      this.player.fdSrc = avFileDescriptor;
    } catch (error) {
      console.error(`createAVPlayer start error: ${error}`);
    }
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

  public setVolume(volume: number) {
    this.volume = Math.max(0, Math.min(1, volume));
    this.player?.setVolume(this.volume);
  }

  public triggerHapticFeedback() {
    try {
      vibrator.startVibration({
        type: 'time',
        duration: 50
      }, {
        id: 0,
        usage: 'alarm'
      }, (error) => {
        if (error) {
          console.error(`vibrator error: ${error.message}`);
        }
      });
    } catch (err) {
      console.error(`vibrator error: ${err.message}`);
    }
  }
}
