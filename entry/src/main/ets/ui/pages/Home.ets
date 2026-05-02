import { ArcList, ArcListItem, ArcListAttribute, ArcListItemAttribute } from '@kit.ArkUI';
import { SongModel } from '../../core/models/SongModel';
import { AudioService } from '../../core/services/AudioService';
import { HomeViewModel } from '../viewmodels/HomeViewModel';
import { AudioView } from './AudioView';

class MenuDataSource implements IDataSource {
  private list: SongModel[];
  private listeners: DataChangeListener[] = [];

  constructor(list: SongModel[]) {
    this.list = list;
  }

  totalCount(): number {
    return this.list.length;
  }

  getData(index: number): SongModel {
    return this.list[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    this.listeners.push(listener);
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    this.listeners = this.listeners.filter(l => l !== listener);
  }
}

@Entry
@Component
struct Home {
  homeViewModel: HomeViewModel = new HomeViewModel();
  private watchSize: string = '466px';
  currentPage: number = 0;
  totalPages: number = 2;
  translateX: number = 0;
  @Provide('pathStack') pathStack: NavPathStack = new NavPathStack()

  @Builder
  PageMap(name: string) {
    if (name === 'AudioView') {
      AudioView()
    }
  }

  private songListDataSource: MenuDataSource = new MenuDataSource(this.homeViewModel.songList);

  onPageShow(): void {
    AudioService.getInstance().release();
  }

  build() {
    Navigation(this.pathStack){
    ArcList({ initialIndex: 0 }) {
      LazyForEach(this.songListDataSource, (item: SongModel, index: number) => {
        ArcListItem() {
          Button(item.songName) // Display the index (0, 1, 2)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
            .width('90%')
            .height(40)
            .backgroundColor(Color.Yellow)
            .borderRadius(16)
            .onClick(() => {
              this.homeViewModel.audioService.currentSong = item;
              this.pathStack.pushPathByName('AudioView', null)
            })
        }
        .align(Alignment.Center)
        .margin({ top: 10, right: 2, left: 2 })
        .width('100%')

      })
    }
    .width('100%')
    .height('100%')
    .borderRadius(this.watchSize)
    .focusable(true)
    .focusOnTouch(true)
    .defaultFocus(true)
  }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .hideBackButton(true)
    .navDestination(this.PageMap)
  }
}

