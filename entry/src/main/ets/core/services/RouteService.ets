import { router } from '@kit.ArkUI';

export class RouteService {
  static _instance: RouteService;
  baseRoute: string = '';
  routeStack: string[] = [this.baseRoute];

  //Please dont forget to init
  public init(params: InitParams) {
    this.baseRoute = params.baseRoute ?? `pages/Home`;
  }


  // Ensure only one instance of this Service has created
  static instance() {
    if (!RouteService._instance) {
      RouteService._instance = new RouteService();
    }
    return RouteService._instance;
  }


  // Push a new route into the stack and navigate
  pushRoute(route:
    string
  ) {
    this.routeStack.push(route);
    router.pushUrl({ url: route });
  }

  // Pop the latest route from the stack and navigate
  popRoute() {
    if (this.routeStack.length != 1) {
      this.routeStack.pop();
      router.back();
    }
  }


  // Remove the current route from the stack and navigate
  pushAndRemoveCurrent(route:
    string) {
    this.routeStack.pop();
    router.pushUrl({ url: route });
  }

  // Check if it's the first route
  isFirstRoute():
    boolean {
    return this.routeStack.length === 1;
  }
}

export class InitParams {
  baseRoute?: string;
}