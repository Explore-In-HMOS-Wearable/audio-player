import { AudioStatus } from '../../core/services/AudioService';
import { AudioViewViewModel } from '../viewmodels/AudioViewViewModel';

@Component
export struct AudioView {
  audioVM = new AudioViewViewModel();
  @Consume('pathStack') pathStack: NavPathStack;

  aboutToAppear(): void {
    this.audioVM.initVm();
  }

  formatTime(ms: number): string {
    const totalSeconds = Math.floor(ms / 1000);
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    return `${minutes}:${seconds.toString().padStart(2, '0')}`;
  }

  build() {
    NavDestination() {
      Stack() {
        Progress({
          value: this.audioVM.audioService.currentTime,
          total: this.audioVM.audioService.duration,
          type: ProgressType.Ring
        })
          .width('100%')
          .height('100%')
          .color(Color.Yellow)
          .style({ strokeWidth: 10 })

        Column() {
        Column() {
          //Author
          Text(this.audioVM.audioService.currentSong.songName)
            .id(`txtItem${this.audioVM.audioService.currentSong.songAuthor}`)
            .fontSize($r('app.float.song_font_size'))
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.White)
            .alignRules({
              center: { anchor: '__container__', align: VerticalAlign.Center },
              middle: { anchor: '__container__', align: HorizontalAlign.Center }
            })
            .onClick(() => {
              console.info(JSON.stringify(this.audioVM.audioService.currentSong));
            })
            .margin({ top: 10 });

          //Song
          Text(this.audioVM.audioService.currentSong.songAuthor)
            .id(`txtItem${this.audioVM.audioService.currentSong.songAuthor}`)
            .fontSize($r('app.float.song_font_size'))
            .fontWeight(FontWeight.Normal)
            .fontColor(Color.White)
            .alignRules({
              center: { anchor: '__container__', align: VerticalAlign.Center },
              middle: { anchor: '__container__', align: HorizontalAlign.Center }
            })
            .onClick(() => {
              console.info(JSON.stringify(this.audioVM.audioService.currentSong));
            })
            .margin({ top: 4, bottom: 10 });
        }.flexGrow(1).justifyContent(FlexAlign.End)

        Column() {
          Text(`${this.formatTime(this.audioVM.audioService.currentTime)} / ${this.formatTime(this.audioVM.audioService.duration)}`)
            .fontSize(14)
            .fontColor(Color.White)
            .margin({ bottom: 10 })

          Row() {
            Image($r('app.media.previous'))
              .width(40)
              .height(40)
              .fillColor(Color.White)
              .margin({ right: 20 })
              .onClick(() => {
                this.audioVM.audioService.triggerHapticFeedback();
                this.audioVM.previousSong();
              });

            Image($r(this.audioVM.audioService.audioStatus === AudioStatus.Playing ? 'app.media.pause' :
              'app.media.start'))
              .width(50)
              .height(50)
              .fillColor(Color.White)
              .onClick(async () => {
                this.audioVM.audioService.triggerHapticFeedback();
                if (this.audioVM.audioService.audioStatus !== AudioStatus.Playing) {
                  await this.audioVM.startAudio(this.audioVM.audioService.currentSong);

                } else {
                  this.audioVM.stopAudio();

                }
              });

            Image($r('app.media.next'))
              .width(40)
              .height(40)
              .fillColor(Color.White)
              .margin({ left: 20 })
              .onClick(() => {
                this.audioVM.audioService.triggerHapticFeedback();
                this.audioVM.nextSong();
              });
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center);
        }.flexGrow(1)
        .justifyContent(FlexAlign.Start)

      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .height('100%')
      .width('100%')
      }
      .backgroundColor(Color.Black);
    }
    .focusable(true)
    .defaultFocus(true)
    .onDigitalCrown((event: CrownEvent) => {
      const sensitivity = 0.001;
      const delta = event.angularVelocity * sensitivity;
      const oldVolume = this.audioVM.audioService.volume;
      this.audioVM.audioService.setVolume(oldVolume + delta);

      if (Math.floor(oldVolume * 10) !== Math.floor(this.audioVM.audioService.volume * 10)) {
        this.audioVM.audioService.triggerHapticFeedback();
      }
    })
    .hideTitleBar(true)
    .hideBackButton(true)
  }
}
