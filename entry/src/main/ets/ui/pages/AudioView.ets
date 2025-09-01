import { AudioStatus } from '../../core/services/AudioService';
import { AudioViewViewModel } from '../viewmodels/AudioViewViewModel';

@Entry
@Component
export struct AudioView {
  audioVM = new AudioViewViewModel();

  aboutToAppear(): void {
    this.audioVM.initVm();
  }

  build() {

    Column() {
      Column() {
        //Author
        Text(this.audioVM.audioService.currentSong.songName)
          .id('txtItem' + this.audioVM.audioService.currentSong.songAuthor)
          .fontSize($r('app.float.song_font_size'))
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            console.log(JSON.stringify(this.audioVM.audioService.currentSong));
          })
          .margin({ top: 10 });

        //Song
        Text(this.audioVM.audioService.currentSong.songAuthor)
          .id('txtItem' + this.audioVM.audioService.currentSong.songAuthor)
          .fontSize($r('app.float.song_font_size'))
          .fontWeight(FontWeight.Normal)
          .fontColor(Color.White)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
          .onClick(() => {
            console.log(JSON.stringify(this.audioVM.audioService.currentSong));
          })
          .margin({ top: 4, bottom: 10 });
      }.flexGrow(1).justifyContent(FlexAlign.End)


      Column() {
        Row() {
          Image($r('app.media.previous'))
            .width(40)
            .height(40)
            .fillColor(Color.White)
            .margin({ right: 20 })
            .onClick(() => {
              this.audioVM.previousSong();

            });

          Image($r(this.audioVM.audioService.audioStatus == AudioStatus.Playing ? 'app.media.pause' :
            'app.media.start'))
            .width(50)
            .height(50)
            .fillColor(Color.White)
            .onClick(async () => {
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
    .backgroundColor(Color.Black);

  }
}
