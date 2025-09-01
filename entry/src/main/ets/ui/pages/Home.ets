import { ComponentContent, LengthMetrics } from '@kit.ArkUI';
import { ArcList, ArcListItem, ArcListAttribute, ArcListItemAttribute } from '@kit.ArkUI';
import { SongModel } from '../../core/models/SongModel';
import { AudioService } from '../../core/services/AudioService';
import { RouteService } from '../../core/services/RouteService';
import { HomeViewModel } from '../viewmodels/HomeViewModel';

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
  private listSize: string = '414px';
  @State currentPage: number = 0; // Current page index
  @State totalPages: number = 2; // Total number of pages
  @State translateX: number = 0;

  private songListDataSource: MenuDataSource = new MenuDataSource(this.homeViewModel.songList);

  onPageShow(): void {
    AudioService.getInstance().release();
  }

  build() {
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
              RouteService.instance().pushRoute('ui/pages/AudioView')
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
}

