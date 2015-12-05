package contexts;
import List;
import events.ContextCreatedEvent;
import events.SceneChangeEvent;
import starling.display.Sprite;
import starling.display.DisplayObjectContainer;
import routers.SceneChangeData;
import configs.Def;
import starling.events.Event;
import routers.Router;
import models.RouterProp;

using Lambda;

class BaseContext extends Sprite {
  public var iAmContext:Bool = true;

  private var that:BaseContext;

  private var router:Router;
  private var rootContext:BaseContext;
  private var sceneMap:Map<String, Dynamic> = new Map();

  private var actors:List<Dynamic> = new List();
  private var tasks:List<Dynamic> = new List();

  private var subActors:List<BaseContext> = new List();
  private var subTasks:List<BaseContext> = new List();

  public var isRoot(get, never):Bool;

  public function new(props:RouterProp) {
    super();
    this.that = this;
    this.router = props.router;
    this.rootContext = props.contextRoot;

    addEventListener(SceneChangeEvent.GO, onScneChange);
  }

  private function onScneChange(e:SceneChangeEvent) {
    var routeData:SceneChangeData = e.routeData;
    var route:Dynamic = sceneMap.get(routeData.route);
    if (route != null) {
      route(routeData);
    }
  }

  public function finishActivation() {
    emit(new ContextCreatedEvent(this));
  }

  // 毎フレーム処理関係のメソッド

  public function startAnimation() {
    if (isRoot) {
      Def.stage.addEventListener(Event.ENTER_FRAME, work);
    } else {
      rootContext.addSubActors(this);
      rootContext.addSubTasks(this);
    }
  }

  public function stopAnimation() {
    if (isRoot) {
      Def.stage.removeEventListener(Event.ENTER_FRAME, work);
    } else {
      rootContext.removeSubActors(this);
      rootContext.removeSubTasks(this);
    }
  }

  private function work(e:Event) {
    plan();
    act();
  }

  // actorの処理

  public function act() {
    // 処理中にlistが増減するためこの処理になる
    var acted:List<Dynamic> = new List();
    var actor:Dynamic = actors.pop();
    while (actor) {
      if (!actor.act()) {
        actor.deactivate();
      } else {
        acted.push(actor);
      }
      actor = actors.pop();
    }
    actors = acted;

    for (sub in subActors) {
      sub.act();
    }
  }

  public function addFixedActors(actors:Array<Dynamic>, ?container:DisplayObjectContainer) {
    var targetContainer:DisplayObjectContainer = container != null ? container : this;
    for(actor in actors){
      addActor(actor, true, container);
    }
  }

  public function addActor(actor:Dynamic, fixed:Bool = false, container:DisplayObjectContainer = null) {
    var targetContainer:DisplayObjectContainer = container != null ? container : this;
    if(Reflect.hasField(actor, 'activate')){
      actor.activate(this, targetContainer);
      if (!fixed) { warmUp(actor); }
    }else{
      targetContainer.addChild(actor);
    }
  }

  private function warmUp(actor:Dynamic) {
    actors.push(actor);
    actor.act();
  }

  public function removeAllActors() {
    for (actor in actors) {
      actor.deactivate();
    }
    actors.clear();
  }

  // taskの処理

  public function plan() {
    for (tasks in tasks) {
      tasks(this);
    }

    for (sub in subTasks) {
      sub.plan();
    }
  }

  public function addTask(task:Dynamic) {
    tasks.push(task);
  }

  public function removeTask(task:Dynamic) {
    tasks.remove(task);
  }

  // サブcontextからの処理

  public function addSubActors(sub:BaseContext) {
    subActors.push(sub);
  }

  public function removeSubActors(sub:BaseContext) {
    subActors.remove(sub);
  }

  public function addSubTasks(sub:BaseContext) {
    subTasks.push(sub);
  }

  public function removeSubTasks(sub:BaseContext) {
    subTasks.remove(sub);
  }

  // routerから呼ばれる

  public function deactivate() {
    stopAnimation();
    removeEventListeners();

    Def.stage.addEventListener(Event.ENTER_FRAME, deactivateStepwise);
  }

  // actorが多い場合、そのdeactivateでフリーズするので回避策として徐々にdeactivateする

  private function deactivateStepwise(e:Event) {
    for (i in 0...Def.deactivationAmoutOnce) {
      if (actors.length == 0) {
        Def.stage.removeEventListener(Event.ENTER_FRAME, deactivateStepwise);
        removeChildren();
        break;
      }
      var actor:Dynamic = actors.pop();
      actor.deactivate();
    }
  }

  public function broadcast(e:Event) {
    router.broadcast(e);
  }

  public function emit(e:Event) {
    router.emit(e);
  }

  public function registerScene(sceneName:String, callback:Dynamic) {
    sceneMap.set(sceneName, callback);
  }

  public function go(route:SceneChangeData) {
    emit(new SceneChangeEvent(route));
  }

  public function get_isRoot():Bool {
    return this.rootContext == null;
  }

  @:extern inline private function isContext(a:Dynamic):Bool {
    return Reflect.hasField(a, 'iAmContext');
  }
}
