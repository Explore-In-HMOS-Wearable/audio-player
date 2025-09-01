import { SongModel } from '../models/SongModel';
import { RouteService } from './RouteService';

export class BaseViewModel {
  routeService: RouteService = RouteService.instance();
  songList: SongModel[] =
    [new SongModel('Dream It Possible', 'Delacey', 'Delacey.flac'),
      new SongModel('Happy', 'DJ Happy', 'happy.mp3'),
      new SongModel('House', 'Earth', 'house.mp3'),
      new SongModel('Space', 'DJ Space', 'space.mp3')
    ];
}
