export class SongModel {
  public songName: string;
  public songAuthor: string;
  public isFavorite: boolean;
  public songPath: string;

  constructor(songName: string, songAuthor: string, songPath: string, isFavorite: boolean = false) {
    this.songName = songName;
    this.songAuthor = songAuthor;
    this.isFavorite = isFavorite;
    this.songPath = songPath;
  }

  static empty() {
    return new SongModel('', '', '')
  }
}