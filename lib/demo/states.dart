abstract class DemoStates {}

class DemoInitStates extends DemoStates {}

class DemoGetVideoSuccessStates extends DemoStates {}

class DemoGetVideoErrorStates extends DemoStates {
  final String error;

  DemoGetVideoErrorStates(this.error);
}

class DemoGetFeedPostSuccessState extends DemoStates {}

class DemoGetFeedPostErrorState extends DemoStates {
  final String error;

  DemoGetFeedPostErrorState(this.error);
}
